Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2171E337221
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhCKMLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhCKMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:11:10 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA7FC061574;
        Thu, 11 Mar 2021 04:11:09 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 16so7126308pgo.13;
        Thu, 11 Mar 2021 04:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w69u9haWUp7YyyRifTBBdCO9AMFL3iKp2esRU3gVS/w=;
        b=Uzq1lJTQHfliiP9ckv3avNMXf3O4PAJF/m/o25aGvNCDamWpxVXQI2c0kIZizBdeKm
         hcNZ88NTPFuexUtkXAAaT+8TqRoxmq8P9mUa+q0EXzHivpwAVQSiRiHoO3BwF2O0sRvc
         4MUQwnCOSl2KNBur4T1OemCxhBtvDS1bKRNF3MnQK2fa+6ll/aW3wzLkwoMv9fA8y1tE
         jjhlfYPIh8PnAGTYbQlmznDUtpyanW5cbtpHnDGrtgbjuPUyoHpR1ayX7Z0T9iA0HdKL
         RuYzvDZd/sz7WOi1NL4NK5kJJP4GAfuVBsWvBo9zT25AaYGLZYplr9WkFxKhCUdNtpf5
         fDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w69u9haWUp7YyyRifTBBdCO9AMFL3iKp2esRU3gVS/w=;
        b=Gx7tTfYMD+C4BX0iodI88Tgp/p5CIBu5Chdjoq5oSzYG1w7Tl/uYiLGunB77imabFc
         hyor5j/xxV9sLuL56u+cyRdxxBOg81S9RquyYTnFJVaXzL3ZdGkijBCEv/LRYHB2FQO1
         PCgnR4UdCpBOj5Vr99D1mxTGbC+TqKrnR+sKpyL6kUu+GcCnffHy6JvAZ7wZ+GqvGm9L
         KKWFXNtCwCqrOK13Fi2VrMlIkYS/tbx5UyVtvqcw1jIOJCbXh7XdDMJkmuV8PhZVvMMO
         rTpfbuOPj1obrYel6SdWywwUww+bmYHFNfUjfZbVm6oO3o9z4Q9xLM+tnaW+lxqu1ZnF
         W8kg==
X-Gm-Message-State: AOAM530sOA6wgkvJ5VGk54f929Ts1z0POsR2FZ9jEOlLkNrQqtY52mVL
        xnmMp/x5AUXDjypLMi5FO3hFJZ1nyubrk5qvPs0=
X-Google-Smtp-Source: ABdhPJwDJ2LyrvM+yGoawF7YjWlt50VsanO16V59FCreJ6iqEaHGFZt6YEvCIYprPTzm5Z6rkDvc2xMG6HvKI1x3SpA=
X-Received: by 2002:a62:7c43:0:b029:1ef:20ce:ba36 with SMTP id
 x64-20020a627c430000b02901ef20ceba36mr7662587pfc.40.1615464669404; Thu, 11
 Mar 2021 04:11:09 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com> <20210311062011.8054-11-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210311062011.8054-11-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 11 Mar 2021 14:10:53 +0200
Message-ID: <CAHp75VfFtQ8AeBsWpsn7MqbcchSYGyOTcybJsy-FWzWTzjB-yg@mail.gmail.com>
Subject: Re: [net-next PATCH v7 10/16] ACPI: utils: Introduce acpi_get_local_address()
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 8:22 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce a wrapper around the _ADR evaluation.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
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
> Changes in v2: None
>
>  drivers/acpi/utils.c | 14 ++++++++++++++
>  include/linux/acpi.h |  7 +++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 682edd913b3b..41fe380a09a7 100644
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
> index fcdaab723916..700f9fc303ab 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -706,6 +706,8 @@ static inline u64 acpi_arch_get_root_pointer(void)
>  }
>  #endif
>
> +int acpi_get_local_address(acpi_handle handle, u32 *addr);
> +
>  #else  /* !CONFIG_ACPI */
>
>  #define acpi_disabled 1
> @@ -953,6 +955,11 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
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
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
