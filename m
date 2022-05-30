Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C228E53783A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiE3Jr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiE3JrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:47:25 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A2EA19F;
        Mon, 30 May 2022 02:47:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id wh22so19758116ejb.7;
        Mon, 30 May 2022 02:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/k2m83LaODmcLsyS0dbBoJk+VKnEiUhqE8c6BRPwNpA=;
        b=HEdtIu9h1Ee4llxxfLUHdT6WXTT7YVh7HuJ1UWwgpaAZEzYcK8Kt18Rc0y6hhxh/pk
         gNEh0cjdDf/DymaC3VMDJfzt8hACMMSArRNFzvgV2rASP/QOIxu5SVhVDBmuBaF6jSqH
         pE7Z+UNUl0L+YpcyxdWHlt+wnBHwJZV6FpL32JVe2MnfNBn8UF1zu7hi0PqUJB5JrUta
         PzgzVuMmyO9cQBNDseiGyFnSevNpMoE0l5EdZjqKzsaGAyssfHObZ+KUH6ErxYptI92w
         d+o7sRvi1EM4ocHQV9T1yTo01whLdcagvrS5NvenSKkHgxAUoXpqgSIjqaOGUKnRw74d
         T+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/k2m83LaODmcLsyS0dbBoJk+VKnEiUhqE8c6BRPwNpA=;
        b=XIrlJyRmWz55gyGgE2tHLcI3n1KCn3c0QQ4hM8elz+uMq7DZLj8SVGg7SjPePkUrNK
         r4voehXaHfnMIi4k9R7MHYk8P6hUkma9KiUXJ2CcdAAIMfTUNkc4W7O8AjWXLqwiwADi
         xClUWCGk7ai8jeyhGmxF3Q7/E4Tyci7rQsHXql1ewvXhvVXuAN7QyD72prej/TRDBgg7
         AtZwYQbjBi1hPaMT0pvI7oAdvKk9816J90m/2lHgMYfTJ8R18XmS0vRCyOl8Wy8U9puT
         +UAJ7H6lSqmJILbwPHC8aa3AIYmV5tFXro0meFeE7HIRE+dCdqDNtXMfZfUQQdMsDbM+
         /gRg==
X-Gm-Message-State: AOAM533BXqkPbcSKmfTVv+5p287lnPZ/DiMfDzh/8cUPXy0OIAmfmvjH
        X9MFVBJqNPNeWV7/TCB5jR9fGi/HEkNLF8OpVj8=
X-Google-Smtp-Source: ABdhPJz2Y4PPvobMreDaaaGYBcFdlzgaDp1D8UrIIx2/xRRkK7/L2BM9dOFFBRp5uNmzREpsNBcvOr4GVqLWfEZBHGw=
X-Received: by 2002:a17:907:6e04:b0:6f4:d6f3:c72a with SMTP id
 sd4-20020a1709076e0400b006f4d6f3c72amr47585054ejc.636.1653904039317; Mon, 30
 May 2022 02:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com> <20220526081550.1089805-8-saravanak@google.com>
In-Reply-To: <20220526081550.1089805-8-saravanak@google.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 30 May 2022 11:46:43 +0200
Message-ID: <CAHp75VcJRfQO6oJpVUoGK4JQpr3Wbff9vgkm8+q8fn8cxohQug@mail.gmail.com>
Subject: Re: [RFC PATCH v1 7/9] driver core: Add fw_devlink_unblock_may_probe()
 helper function
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 1:22 PM Saravana Kannan <saravanak@google.com> wrote:
>
> This function can be used during the kernel boot sequence to forcefully
> override fw_devlink=on and unblock the probing of all devices that have
> a driver.
>
> It's mainly meant to be called from late_initcall() or
> late_initcall_sync() where a device needs to probe before the kernel can
> mount rootfs.

...

> diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> index 9a81c4410b9f..0770edda7068 100644
> --- a/include/linux/fwnode.h
> +++ b/include/linux/fwnode.h
> @@ -13,6 +13,7 @@
>  #include <linux/list.h>
>  #include <linux/bits.h>
>  #include <linux/err.h>
> +#include <linux/init.h>
>
>  struct fwnode_operations;
>  struct device;
> @@ -199,5 +200,6 @@ extern bool fw_devlink_is_strict(void);
>  int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup);
>  void fwnode_links_purge(struct fwnode_handle *fwnode);
>  void fw_devlink_purge_absent_suppliers(struct fwnode_handle *fwnode);
> +void __init fw_devlink_unblock_may_probe(void);

I don't think you need init.h and __init here. Important is that you
have it in the C-file. Am I wrong?

-- 
With Best Regards,
Andy Shevchenko
