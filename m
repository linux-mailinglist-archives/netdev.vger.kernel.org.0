Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E090300B84
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbhAVSkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:40:01 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:45796 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbhAVSOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:14:49 -0500
Received: by mail-ot1-f52.google.com with SMTP id n42so5943246ota.12;
        Fri, 22 Jan 2021 10:14:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HbzDW3QA2Q6g0uGYU2IZR5GIe/DUZOJ1PbaP0DrVns=;
        b=j3WQ8ew6Ak8rPeJaW+Yzx24oEoVnSxGAxM+jh7XCwsmDkyBgGTtkNH8vNGdYFIPrFq
         QUynhtwmGz4TTj5lYpUvRb1T4+iA8VuuHOiqVWYDdKSG3P0yl735fP/46KtOEdVcMx02
         Ok5RCAF7MafGVoC5REdAxi62dPfojOQWtaSaVLURnbuLyC/tmyFFtH3YtM22ILhqRfcQ
         xjY18fM/9Y2/xSkhqeWothEuyA0H/NHyNed2ohhgu3+UgO5srb/rhXQUzeGFeXHpoI3R
         8/YPWfhSwNXL5DSFChS4uAUHemOQQK6zU/Lx1wEZkqoxCWrEPn8LgoH5DPhSx9aCmtj8
         3qeg==
X-Gm-Message-State: AOAM531ihuTWW7K7smEsjpTlklJjM9J95eZ1lpAxVp2rePrEqB7u2c0T
        W/k6iJ9tzoTGRLsx/U26HvkITS0aCravOWO9EoU=
X-Google-Smtp-Source: ABdhPJzivYSb5OAa9kG8kDW7HZ8zJjJRPWKRWYfpBQGNK2wKOYqgBNEDWAHrsPMWMVMugxiK7nEsEYEpK1TmCJcy0ms=
X-Received: by 2002:a9d:745a:: with SMTP id p26mr4444083otk.206.1611339247292;
 Fri, 22 Jan 2021 10:14:07 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com> <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 19:13:47 +0100
Message-ID: <CAJZ5v0i9XyBKqZS9OL3riAdpmu3St_HZ3JBDcswMbX5pw03gqQ@mail.gmail.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce fwnode_get_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 4:46 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Using fwnode_get_id(), get the reg property value for DT node
> or get the _ADR object value for ACPI node.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v4:
> - Improve code structure to handle all cases
>
> Changes in v3:
> - Modified to retrieve reg property value for ACPI as well
> - Resolved compilation issue with CONFIG_ACPI = n
> - Added more info into documentation
>
> Changes in v2: None
>
>  drivers/base/property.c  | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/property.h |  1 +
>  2 files changed, 35 insertions(+)
>
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 35b95c6ac0c6..f0581bbf7a4b 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -580,6 +580,40 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
>         return fwnode_call_ptr_op(fwnode, get_name_prefix);
>  }
>
> +/**
> + * fwnode_get_id - Get the id of a fwnode.
> + * @fwnode: firmware node
> + * @id: id of the fwnode
> + *
> + * This function provides the id of a fwnode which can be either
> + * DT or ACPI node. For ACPI, "reg" property value, if present will
> + * be provided or else _ADR value will be provided.
> + * Returns 0 on success or a negative errno.
> + */
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> +{
> +#ifdef CONFIG_ACPI
> +       unsigned long long adr;
> +       acpi_status status;
> +#endif
> +       int ret;
> +
> +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> +       if (ret) {
> +#ifdef CONFIG_ACPI
> +               status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +                                              METHOD_NAME__ADR, NULL, &adr);
> +               if (ACPI_FAILURE(status))
> +                       return -EINVAL;

Please don't return -EINVAL from here, because this means "invalid
argument" to the caller, but there may be nothing wrong with the
fwnode and id pointers.

I would return -ENODATA instead.

> +               *id = (u32)adr;
> +#else
> +               return ret;
> +#endif
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(fwnode_get_id);
> +
>  /**
>   * fwnode_get_parent - Return parent firwmare node
>   * @fwnode: Firmware whose parent is retrieved
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 0a9001fe7aea..3f41475f010b 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -82,6 +82,7 @@ struct fwnode_handle *fwnode_find_reference(const struct fwnode_handle *fwnode,
>
>  const char *fwnode_get_name(const struct fwnode_handle *fwnode);
>  const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode);
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id);
>  struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);
>  struct fwnode_handle *fwnode_get_next_parent(
>         struct fwnode_handle *fwnode);
> --
> 2.17.1
>
