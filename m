Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658933E033A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhHDObK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhHDO3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:29:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23DAC0613D5;
        Wed,  4 Aug 2021 07:28:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so3148263plr.11;
        Wed, 04 Aug 2021 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zVcpGvB1fjh2beX8VuQl4JyzQJhoYo0herXV11yWWbs=;
        b=DlPJi8NTGYgpF0kLDymlbx/qsIOw+YUJUFd0uee97CrNMiv5C8uJX2CvB0NAcvZ7uL
         /J9nw6aGFEKDFRk0IcEblVwVfqUNh2KG2l8ncEAnYeknHDLISdeXNIkUtuzYnCbzyH41
         w2mWpkWBaGQ4AsUpB8tpaNoogZgJhiiw1nhZ/8SNi+qSbN4RU4Ix3nlaU1VCkLGbSz2x
         Q1p1RAgKkY96CljmN0eDfxb6B4kK+aeleRhAHNg+KNvKiDzgAMBRYiDe+zY3Ye5NfHJ0
         Jp65G9d0dH8GhuAABGDmC4otkfYcbBJisXNvfhmxey5BQuH/IuDS0qaEpvs7wKE1EKcM
         Wr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zVcpGvB1fjh2beX8VuQl4JyzQJhoYo0herXV11yWWbs=;
        b=j59YszDVmbDgvfUU7sNbpHhACPs43tbJsSoFRKto1OMDrNh+UB1yS+ohCC95DoZUmy
         G16BFtgIRkETEsUEDJnnZR9uzzuoXzBko4ZEbniwqBx3nf2laH5TieQXspS/IY5gbb5r
         ZgTkyVnt9tEyrIqSGjtsnDwBwQkqY+5rZ+49RA09eDQZNBXN/2dUV7h8IiF8Wl0NgQ3L
         imcR6wHUsSXRYngAH0nnf2FRPaycejB6Z62roFK6ILLaD/FEvW0KiaJa5h4MyK9CgesL
         JTIEkU/7WJBA44+LTAHNHit6wiQhsebdnMPDjLZZ+O3Ko0FQKKIbE94473TFf1KDkx79
         QcSA==
X-Gm-Message-State: AOAM531KeMUkBjBZTgQmMWR5EqEU3mDqYBcvDTL6OKbg4fXnqpoHWYUe
        JamD5pd8OhwgEm+rkz8/6T0=
X-Google-Smtp-Source: ABdhPJwpgB+G6j9ZEhkZr+2iv541VWgYpL+xsaxdbxqVoJgpZCcbeqTou5qmsHLrcKhA6pnVjWPPaA==
X-Received: by 2002:a17:902:c391:b029:12c:f2:f5f with SMTP id g17-20020a170902c391b029012c00f20f5fmr10522935plg.48.1628087299216;
        Wed, 04 Aug 2021 07:28:19 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s31sm3816465pgm.27.2021.08.04.07.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 07:28:18 -0700 (PDT)
Date:   Wed, 4 Aug 2021 07:28:14 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
Message-ID: <20210804142814.GB1645@hoboy.vegasvil.org>
References: <20210804121318.337276-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804121318.337276-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 01:57:04PM +0200, Arnd Bergmann wrote:

> Since this should cover the dependencies correctly, the IS_REACHABLE()
> hack in the header is no longer needed now, and can be turned back
> into a normal IS_ENABLED() check. Any driver that gets the dependency
> wrong will now cause a link time failure rather than being unable to use
> PTP support when that is in a loadable module.

yes!

> Changes in v3:
> - rewrite to introduce a new PTP_1588_CLOCK_OPTIONAL symbol
> - use it for all driver, not just Intel's

Thanks for following up.

> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index 82744a7501c7..9c1d0b715748 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -58,8 +58,8 @@ config E1000
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>  	depends on PCI && (!SPARC32 || BROKEN)
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select CRC32
> -	imply PTP_1588_CLOCK
>  	help
>  	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
>  	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
> @@ -87,8 +87,8 @@ config E1000E_HWTS
>  config IGB
>  	tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
>  	depends on PCI
> -	imply PTP_1588_CLOCK
> -	select I2C
> +	depends on PTP_1588_CLOCK_OPTIONAL
> +	depends on I2C

This little i2c bit sneaks in, but I guess you considered any possible
trouble with it?

Acked-by: Richard Cochran <richardcochran@gmail.com>
