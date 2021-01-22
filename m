Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F235A30098E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbhAVQxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:53:39 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:41718 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbhAVQlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:41:31 -0500
Received: by mail-ot1-f53.google.com with SMTP id k8so5633682otr.8;
        Fri, 22 Jan 2021 08:41:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBT6lOdqQ9gMoz0GrIXk1aglXl4WV8PiXf0WiP0Be/g=;
        b=sK9HqeorKNyuqZc9D65d3wLYSPXF6CBNQZ9wzZsDtqdMEiF2P4KVX8cLsEqDbvX3dQ
         p09W/XK0J2jglBb8Hm3ALhwXRTZljkIDle1Fbbp3vCnZh74XotZI6I3Lfn+W7S0WOdJ4
         ICv4eFU7XQIsU8G+dzrF1MlLXYxiWXBQU0ySIPanqxgUm3N4Ju+vaNdQXSk9MBBldHcA
         7nan7bmA4eL0lzt0Qscu/NuVYMxa8GHbdaXcRdcsP8NMuPcrTqh2j0rCA4v/xQUGVxfY
         Zn0T9fi0NO9MjgJBHAXALIJbfCL9Jb8TzJy5Nhr/xT5VNdYHr38y086VAig97gnydXJd
         0K1A==
X-Gm-Message-State: AOAM533930mA3d/BAblFPajpgCU/5qJPIRUOB17DZqCNlgrMGFp1tERY
        DKIvt/fo3xlOBO1iD9kiiBS2rCch8V5j7hdPSOs=
X-Google-Smtp-Source: ABdhPJwkHlDPwIKw9uPIf9JKIEPyQ8b86W99bEyIhjtfIg47ZVy19I7pbvzBYx7O/SotAOAHLaBtP7zplW4kclFkKoA=
X-Received: by 2002:a9d:745a:: with SMTP id p26mr4087167otk.206.1611333652686;
 Fri, 22 Jan 2021 08:40:52 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com> <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 17:40:41 +0100
Message-ID: <CAJZ5v0gzdi08fwf0e3NyP1WzuSBk47J5OT5DW_aaUHn_9icfag@mail.gmail.com>
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

So I'm not really sure if this is going to be generically useful.

First of all, the meaning of the _ADR return value is specific to a
given bus type (e.g. the PCI encoding of it is different from the I2C
encoding of it) and it just happens to be matching the definition of
the "reg" property for this particular binding.

IOW, not everyone may expect the "reg" property and the _ADR return
value to have the same encoding and belong to the same set of values,
so maybe put this function somewhere closer to the code that's going
to use it, because it seems to be kind of specific to this particular
use case?

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
