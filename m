Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1521C6962
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgEFGvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFGvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:51:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DCBC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 23:51:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so389640pjb.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 23:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zWslycsoqOQ359IakGW3a1F/5xT9RTlCzfLGPEdji2s=;
        b=VVRPac8JxQ2yO15PzcdX1hP2MLRiJEj2HFle/fWZJfRhqKwz1VUpjJdtye3lEX1NIW
         eY+gb5/i8thO7fxUOpy+IWPnYi5J38J7Ch04uOZqpgneUG982J8lnjA9IyHl8LqowtNz
         LEWFHbTLgVKIXCy18RxFG+qDC1FQjWe0qFZAbncAluPpGa1FeHObBBzZ3Ppsf+qgPZ+Z
         RfMgJMPkmUWvIwQE6WdPM7bjn1qVtatSYhQvhoVZIUAcEC1IQw+W180UdTrVvpgT0NjT
         T/QIsA70LDYe05eVIJuhFW/qNTu7pwhR0OE4Biw0NhIlctzSaqMPjKLbF6yI2eX64HX1
         XdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zWslycsoqOQ359IakGW3a1F/5xT9RTlCzfLGPEdji2s=;
        b=L45M9p+EE4YSh3zIZ217uRfh5UvEppCc9ADIh1LkKrKYdQcrnr/hjLBPRrksBWuxfP
         tS/ZC2Vc7xXCFEJYGvDi+IgCUH3W84hAKxdXrbxO8sX+J3ZwMBn0y0doubNdENtRsRym
         UVMyhVL65hGsotdaCAuQFWUSZQUcrIsu8wezhRwyJ2WSJSPLoKjEbn3rwa6N9L9GUMlM
         fP0oaWXhqYFNa5OVcLCI5kbqE1BHUO/hFj0zjecwL/t5RlKBt4MC8TS1f/oLI108dtOZ
         /3s4mHtIdfEVYHRCwhf4+C1Iz6yqZaegaFzS0//FfnO+3JTDhbWIQV6y5SrMUFs8umrq
         iy4g==
X-Gm-Message-State: AGi0PuZcuVNtyVCwLDqsHdtzOzk7lsJdtZXM7dY5RGNNamqqdcQJzdeY
        mEZX0i2bqcKSYVGAgEMRDZhA
X-Google-Smtp-Source: APiQypJcNy0kd6l7daOweAVRgu2WF8Ua8sYRhEpoLPpFDpd65Xi99VrdKZTPAjbReAAEY1z261G08g==
X-Received: by 2002:a17:90a:25c3:: with SMTP id k61mr7352238pje.28.1588747874993;
        Tue, 05 May 2020 23:51:14 -0700 (PDT)
Received: from arctic-shiba-lx ([47.156.151.166])
        by smtp.gmail.com with ESMTPSA id x13sm867837pfq.154.2020.05.05.23.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 23:51:14 -0700 (PDT)
Date:   Tue, 5 May 2020 23:51:05 -0700
From:   Clay McClure <clay@daemons.net>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Message-ID: <20200506065105.GA3226@arctic-shiba-lx>
References: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
 <20200504165711.5621-1-clay@daemons.net>
 <f07c695b-5537-41bf-e4f8-0d8012532f64@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f07c695b-5537-41bf-e4f8-0d8012532f64@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 10:41:26AM +0300, Grygorii Strashko wrote:

> It's better if you send v2 not as reply to v1.

Noted, thank you, and thank you for taking the time to review my patch.

> just to clarify. After these two patches
>  - the PTP_1588_CLOCK can still be set to "M"
>  - which will cause TI_CPTS to be "M",
>  - but TI_CPSW will still be "Y".
> 
> and all above will build and produce built-in CPSW without CPTS support
> and cpts.ko which is loadable, but not functional.
> 
> Sorry, I'm a little bit lost regarding the target you'are trying to achieve.
> At least previously "imply PTP_1588_CLOCK" allowed to select properly PTP_1588_CLOCK
> without modifying every defconfig.

Well, I just wanted to squelch a WARN_ON(). As Arnd pointed out in [1],
code that uses the stubbed cpts functions is supposed to gracefully
handle receiving a null pointer. Splatting a warning is not graceful,
and that's what I was trying to fix.

But your question in [2] prompted me to consider whether it should be
possible to build TI_CPTS without PTP_1588_CLOCK at all. I think the
answer is no, so I tried to fix it, but you're right, it's still
possible to end up with a nonfunctional module after my patch.

If you prefer to revert, that's fine with me. Should I post a patch, or
just ask David to revert?

-- 
Clay

[1]: https://lore.kernel.org/lkml/CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com/
[2]: https://lore.kernel.org/lkml/6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com/

> 
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Clay McClure <clay@daemons.net>
> > ---
> > Changes in v2:
> > 
> > - Don't regenerate the defconfigs, just add PTP_1588_CLOCK.
> > 
> >   arch/arm/configs/keystone_defconfig    |  1 +
> >   arch/arm/configs/omap2plus_defconfig   |  1 +
> >   drivers/net/ethernet/ti/Kconfig        | 13 ++++---------
> >   drivers/net/ethernet/ti/Makefile       |  2 +-
> >   drivers/net/ethernet/ti/cpsw_ethtool.c |  2 +-
> >   drivers/net/ethernet/ti/cpts.h         |  3 +--
> >   drivers/net/ethernet/ti/netcp_ethss.c  | 10 +++++-----
> >   7 files changed, 14 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
> > index 11e2211f9007..84a3b055f253 100644
> > --- a/arch/arm/configs/keystone_defconfig
> > +++ b/arch/arm/configs/keystone_defconfig
> > @@ -147,6 +147,7 @@ CONFIG_I2C_DAVINCI=y
> >   CONFIG_SPI=y
> >   CONFIG_SPI_DAVINCI=y
> >   CONFIG_SPI_SPIDEV=y
> > +CONFIG_PTP_1588_CLOCK=y
> >   CONFIG_PINCTRL_SINGLE=y
> >   CONFIG_GPIOLIB=y
> >   CONFIG_GPIO_SYSFS=y
> > diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> > index 3cc3ca5fa027..8b83d4a5d309 100644
> > --- a/arch/arm/configs/omap2plus_defconfig
> > +++ b/arch/arm/configs/omap2plus_defconfig
> > @@ -274,6 +274,7 @@ CONFIG_SPI_TI_QSPI=m
> >   CONFIG_HSI=m
> >   CONFIG_OMAP_SSI=m
> >   CONFIG_SSI_PROTOCOL=m
> > +CONFIG_PTP_1588_CLOCK=y
> >   CONFIG_PINCTRL_SINGLE=y
> >   CONFIG_DEBUG_GPIO=y
> >   CONFIG_GPIO_SYSFS=y
> > diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> > index 8e348780efb6..f3f8bb724294 100644
> > --- a/drivers/net/ethernet/ti/Kconfig
> > +++ b/drivers/net/ethernet/ti/Kconfig
> > @@ -77,23 +77,18 @@ config TI_CPSW_SWITCHDEV
> >   	  will be called cpsw_new.
> >   config TI_CPTS
> > -	bool "TI Common Platform Time Sync (CPTS) Support"
> > +	tristate "TI Common Platform Time Sync (CPTS) Support"
> >   	depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
> >   	depends on COMMON_CLK
> > -	depends on POSIX_TIMERS
> > +	depends on PTP_1588_CLOCK
> 
> > +	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
> 
> even with above statement it's possible to force TI_CPTS="M" while CPSW/NETCP="Y"
> 
> > +	default m
> 
> I could be mistaken by above 2 lines seems can be 'imply TI_CPTS'
> in TI_CPSW, TI_KEYSTONE_NETCP, TI_CPSW_SWITCHDEV
> 
> >   	---help---
> >   	  This driver supports the Common Platform Time Sync unit of
> >   	  the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
> >   	  The unit can time stamp PTP UDP/IPv4 and Layer 2 packets, and the
> >   	  driver offers a PTP Hardware Clock.
> > -config TI_CPTS_MOD
> > -	tristate
> > -	depends on TI_CPTS
> > -	depends on PTP_1588_CLOCK
> > -	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
> > -	default m
> 
> and this prevented user from forcing TI_CPTS="M" while CPSW/NETCP="Y"
> 
> > -
> >   config TI_K3_AM65_CPSW_NUSS
> >   	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
> >   	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
> > diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
> > index 53792190e9c2..cb26a9d21869 100644
> 
> Below small diff should fix build fail:
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 8e348780efb6..eeaee47598aa 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -81,6 +81,7 @@ config TI_CPTS
>         depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
>         depends on COMMON_CLK
>         depends on POSIX_TIMERS
> +       depends on PTP_1588_CLOCK
>         ---help---
>           This driver supports the Common Platform Time Sync unit of
>           the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
> @@ -90,7 +91,6 @@ config TI_CPTS
>  config TI_CPTS_MOD
>         tristate
>         depends on TI_CPTS
> -       depends on PTP_1588_CLOCK
>         default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
>         default m
> 
> Then separate patch can be used to enable PTP_1588_CLOCK in defconfigs.
> 
> My personal opinion - it might be better to revert TI CPTS part from
> b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
> at all.
> 
> -- 
> Best regards,
> grygorii
