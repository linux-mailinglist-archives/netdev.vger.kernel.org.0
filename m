Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B348B2F3496
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405596AbhALPsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404991AbhALPsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:48:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA2AC061575;
        Tue, 12 Jan 2021 07:47:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v3so1581082plz.13;
        Tue, 12 Jan 2021 07:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUV6Ra+1gHnPMGTHHEeVWGU6ZIJCwcoEdn1PhsWkOrY=;
        b=dsGYO+bwa60VxX6utSG9a9nnvGP7WNVoZloNeeNVK0TOm6xhw+uUIyEqGPC5l8+shy
         6ppMTxcuLP3anazWBVH5sX431LU3VAFipuJC/EhaQBFGxSysebfY18DWbzCo1ytXkv5I
         CWUTAFidBOb8QHj1gTAJKutpHf19cLzsUcCaW1SOMfeJtMsIZzIBOUtoBYXjxJlEDE/H
         yFN+0fU7dXwj+GxvKUgA3RpDgy1/OcWdj4rC6rxXsvhV00BKiy0/YcgJ+FjLsylSx0Jr
         bmXTyNDNGjzLTp2qFzSCk/HnssfBk9c/f8ZG8msauGUk8xqG9iqqCyfY/K8UWGPlRnsr
         +4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUV6Ra+1gHnPMGTHHEeVWGU6ZIJCwcoEdn1PhsWkOrY=;
        b=LMraMia9BKXxq+jnNdbNQWi3DOsqQmPQ6/1q13n7N5N62U+seCoaPy44qe1ST9giKO
         2WOdvjf/JPo4XJQIZKhrkHYor3OHY2wqR6YRCRsQlWNyjQJT6X6Gdo+zJz0SN/Jx5kqc
         cjI1SmK48dBBKM6zBIvaaBOecqNxK14fESkT6Tvk2/GqGz7Sc09PGqBNKoLODfYhkG/g
         81btQibZfN+N7oIZjaK9xZEL3O0h09bspuhU7khcyPVgYw2bvUKc4oMEdl9+3t5KKP5g
         4dMT7yNVpiM40CTFmB5VKrpC7WYY/x5RDChsFllo4YUunoXOVi7sKDVczNaC0Mm0vbnD
         WYMg==
X-Gm-Message-State: AOAM5306FXTIDnDwESi0E9ipRIfiR9ewIN2fSV0/aARYVHSSpOVEsw8y
        bbk47XBz4kPMmYQrsxvmZ5NXYEEwKtNWRjkLNjI=
X-Google-Smtp-Source: ABdhPJwrpjrkIkwoENuRFLz4GRvxuPBgIcvj3r9erx9frMs2YOytFtMOsVoKAR4bANCHlXYIisd7EHA1QBXNEPjseZQ=
X-Received: by 2002:a17:902:c244:b029:da:e63c:cede with SMTP id
 4-20020a170902c244b02900dae63ccedemr48014plg.0.1610466440771; Tue, 12 Jan
 2021 07:47:20 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-10-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-10-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jan 2021 17:48:09 +0200
Message-ID: <CAHp75VdyPWD-cM5Q_9k8yRAutMSjm-3kwE0pQT3+ztKGwcU+4A@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Saravana Kannan <saravanak@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:42 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Using fwnode_get_id(), get the reg property value for DT node
> or get the _ADR object value for ACPI node.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v3:
> - Modified to retrieve reg property value for ACPI as well
> - Resolved compilation issue with CONFIG_ACPI = n
> - Added more info into documentation
>
> Changes in v2: None
>
>  drivers/base/property.c  | 33 +++++++++++++++++++++++++++++++++
>  include/linux/property.h |  1 +
>  2 files changed, 34 insertions(+)
>
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 35b95c6ac0c6..2d51108cb936 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -580,6 +580,39 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
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
> +       if (!(ret && is_acpi_node(fwnode)))
> +               return ret;
> +
> +#ifdef CONFIG_ACPI
> +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +                                      METHOD_NAME__ADR, NULL, &adr);
> +       if (ACPI_FAILURE(status))
> +               return -EINVAL;
> +       *id = (u32)adr;

Shouldn't be

       return 0;
#else
       return -EINVAL;
#endif

?

Yes, it's a theoretical case when is_acpi_node() returns true when
CONFIG_ACPI=n.

> +#endif
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


-- 
With Best Regards,
Andy Shevchenko
