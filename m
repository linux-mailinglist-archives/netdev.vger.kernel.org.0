Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D475F3A32BD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFJSLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:11:37 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:33389 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJSLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:11:36 -0400
Received: by mail-ot1-f54.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so634904otl.0;
        Thu, 10 Jun 2021 11:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H74hTkKP2g6ySS07n5+YG2w6RIcuFmWGYRWFYR1JiqA=;
        b=ojD/Jp/5MwXUlI9YqI+ZNKAssdM6EHxNDy/JcJ3M1zquA9sLb75WGAYCDyPNVF8YGm
         qWQbFX3osO9joqOMT7s5ydXBgi0jLBL+6uk6ZhJOOECoOPsiO6ZbWeCI0vnBDLGImuP5
         KrspLK9zjt9d3qe9gYF1HqMcXW1V3AFO1yKNYZjf53WOsib9yGgjF2N682IAPVc3V4sn
         DLYeKqLx3aqC5aTUkuUeBbIt/3vo2LxY9TP5z1Vun6x0G9Iorn0TnitcvEtVLrAytnLO
         6+0HEfhVf4mzmhfhnEYbFAsIUD4KzNy3bguhJfgfYC5wJwd6LJ/lDkgDr39rPm0mxHcP
         2NoQ==
X-Gm-Message-State: AOAM530L94jpFnm9sU9JpD3DalZe7AN1fRKtyWpwQ1i1zhPnhfd/yONM
        vXniFoOP4AnY0jKPxAP0IgxjHkVkMkWnqYQa/kE=
X-Google-Smtp-Source: ABdhPJwDqF0etO0EruaT/luSSSGB6a5eMF+IOWAMaQ3IVd/ew2h/X8ygupnGqAzOzJigxxF0WuBW6+542FHZPkbhxuI=
X-Received: by 2002:a9d:3e53:: with SMTP id h19mr3460002otg.260.1623348565935;
 Thu, 10 Jun 2021 11:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com> <20210610163917.4138412-11-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-11-ciorneiioana@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:09:14 +0200
Message-ID: <CAJZ5v0ivYQhhLeO_fcTOexgsUtRJ7dbzr0N99vMZBv-m8CkU1g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 10/15] ACPI: utils: Introduce acpi_get_local_address()
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 6:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Introduce a wrapper around the _ADR evaluation.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5:
> - Replace fwnode_get_id() with acpi_get_local_address()
>
> Changes in v4:
> - Improve code structure to handle all cases
>
> Changes in v3:
> - Modified to retrieve reg property value for ACPI as well
> - Resolved compilation issue with CONFIG_ACPI = n
> - Added more info into documentation
>
>  drivers/acpi/utils.c | 14 ++++++++++++++
>  include/linux/acpi.h |  7 +++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 3b54b8fd7396..e7ddd281afff 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -277,6 +277,20 @@ acpi_evaluate_integer(acpi_handle handle,
>
>  EXPORT_SYMBOL(acpi_evaluate_integer);
>
> +int acpi_get_local_address(acpi_handle handle, u32 *addr)
> +{
> +       unsigned long long adr;
> +       acpi_status status;
> +
> +       status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &adr);
> +       if (ACPI_FAILURE(status))
> +               return -ENODATA;
> +
> +       *addr = (u32)adr;
> +       return 0;
> +}
> +EXPORT_SYMBOL(acpi_get_local_address);
> +
>  acpi_status
>  acpi_evaluate_reference(acpi_handle handle,
>                         acpi_string pathname,
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index c60745f657e9..6ace3a0f1415 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -710,6 +710,8 @@ static inline u64 acpi_arch_get_root_pointer(void)
>  }
>  #endif
>
> +int acpi_get_local_address(acpi_handle handle, u32 *addr);
> +
>  #else  /* !CONFIG_ACPI */
>
>  #define acpi_disabled 1
> @@ -965,6 +967,11 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
>         return NULL;
>  }
>
> +static inline int acpi_get_local_address(acpi_handle handle, u32 *addr)
> +{
> +       return -ENODEV;
> +}
> +
>  #endif /* !CONFIG_ACPI */
>
>  #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
> --
> 2.31.1
>
