Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EEF3E15C2
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241705AbhHENdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbhHENdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 09:33:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60070C061765;
        Thu,  5 Aug 2021 06:33:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d6so8386499edt.7;
        Thu, 05 Aug 2021 06:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5KnmBsMekLsd2KwbsCS76Z4wO/OCvggDPwW2Gn92Ahw=;
        b=M+Mo3cGpJOMX18N6LDI1LAyw7SvwYwAAxW2/b5IQcqeDKiFV3D1yniW86DRuabe95M
         ZwexJyeLi4cSWMz/8IzinGKVuCQ6LapSRhjiYHRhVmuPAGmkCkLfV2cCks1i/tKotVDK
         tSh3i8nyKsuJ6wsDaP1czISWsff7gPfGLNCss8Sr5taIKQznhRV4kZN5OP2+wzdYXbdx
         brSEEYpyh+Y+M2YR63u6gQ41NMTRr8Dg6a6anUG3c9L5FVbXOVFJbSnOYWAZKnyBd2F9
         R/Hr3bp3jk8a9ZB4BzvyXFtfJZjcyJ/0oceL7BfQliuPP4NeGMyqUUi3KxqMoISmE1q6
         W6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5KnmBsMekLsd2KwbsCS76Z4wO/OCvggDPwW2Gn92Ahw=;
        b=TcQTJPiQKZk56OJUnki6qMj342MlR7dCJWumlGbSfeCi/b9QVbrGaBFvs2ER17CLdC
         yih4p5VE437yQQN09eLfi7HvvlMxG4sG69VXzIA3pACl5fZl/hGmE0UqHCRP73iwXlTm
         /Sf0qJMeRBKxnbnVRNd3c6Mu99RBoMB0g5PzsRRpyLAiqyd15E0AeS5j1FUKNA6aVefv
         upG+eCYd15t3CbJiVVYMPu0J5QAZQafxqV4s7TvNUHW+DKreo92nYGkIq3rtaxle4WZ9
         lvqP6cUBrYg6GLdyGmkmuauXrLCsWLB5Jp8eFKcrkfQ86fxyDbCQzNPfqrdef/FlcntQ
         eFmA==
X-Gm-Message-State: AOAM532ZOyI2Ei5Qn2QmfK8NbYdj3OiVA7XaBw7RpbBo7U/N/GqnExCP
        BlFhx2LCXQtfO1tWbZ/FvFk=
X-Google-Smtp-Source: ABdhPJy8m29nLG+tfWs5oWsDoLeffEefb1XumC1J2kldxf7KmM/8mwma+wQMLr7MKklhYfK2aA4PUg==
X-Received: by 2002:a05:6402:b19:: with SMTP id bm25mr6658537edb.213.1628170382003;
        Thu, 05 Aug 2021 06:33:02 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id df14sm2294248edb.90.2021.08.05.06.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 06:33:01 -0700 (PDT)
Date:   Thu, 5 Aug 2021 16:32:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <snelson@pensando.io>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        drivers@pensando.io, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>, Karen Xie <kxie@chelsio.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next v4] ethernet: fix PTP_1588_CLOCK dependencies
Message-ID: <20210805133258.zvhn5kznjt7taqyu@skbuf>
References: <20210805082253.3654591-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805082253.3654591-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 10:13:57AM +0200, Arnd Bergmann wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
> index 634a48e6616b..7a2445a34eb7 100644
> --- a/drivers/net/dsa/mv88e6xxx/Kconfig
> +++ b/drivers/net/dsa/mv88e6xxx/Kconfig
> @@ -2,6 +2,7 @@
>  config NET_DSA_MV88E6XXX
>  	tristate "Marvell 88E6xxx Ethernet switch fabric support"
>  	depends on NET_DSA
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select IRQ_DOMAIN
>  	select NET_DSA_TAG_EDSA
>  	select NET_DSA_TAG_DSA
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index 932b6b6fe817..9948544ba1c4 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -5,6 +5,7 @@ config NET_DSA_MSCC_FELIX
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on NET_VENDOR_FREESCALE
>  	depends on HAS_IOMEM
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MSCC_OCELOT_SWITCH_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
> @@ -19,6 +20,7 @@ config NET_DSA_MSCC_SEVILLE
>  	depends on NET_DSA
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on HAS_IOMEM
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MSCC_OCELOT_SWITCH_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
> diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
> index b29d41e5e1e7..1291bba3f3b6 100644
> --- a/drivers/net/dsa/sja1105/Kconfig
> +++ b/drivers/net/dsa/sja1105/Kconfig
> @@ -2,6 +2,7 @@
>  config NET_DSA_SJA1105
>  tristate "NXP SJA1105 Ethernet switch family support"
>  	depends on NET_DSA && SPI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select NET_DSA_TAG_SJA1105
>  	select PCS_XPCS
>  	select PACKING
> diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
> index 2d3157e4d081..b07912434560 100644
> --- a/drivers/net/ethernet/mscc/Kconfig
> +++ b/drivers/net/ethernet/mscc/Kconfig
> @@ -13,6 +13,7 @@ if NET_VENDOR_MICROSEMI
>  
>  # Users should depend on NET_SWITCHDEV, HAS_IOMEM, BRIDGE
>  config MSCC_OCELOT_SWITCH_LIB
> +	depends on PTP_1588_CLOCK_OPTIONAL

No, don't make the MSCC_OCELOT_SWITCH_LIB depend on anything please,
since it is always "select"-ed, it shouldn't have dependencies, see
the comment above. If you want, add this to the comment: "Users should
depend on (...), PTP_1588_CLOCK_OPTIONAL".

>  	select NET_DEVLINK
>  	select REGMAP_MMIO
>  	select PACKING
> @@ -24,6 +25,7 @@ config MSCC_OCELOT_SWITCH_LIB
>  
>  config MSCC_OCELOT_SWITCH
>  	tristate "Ocelot switch driver"
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	depends on BRIDGE || BRIDGE=n
>  	depends on NET_SWITCHDEV
>  	depends on HAS_IOMEM
> @@ -253,6 +254,7 @@ config NATIONAL_PHY
>  
>  config NXP_C45_TJA11XX_PHY
>  	tristate "NXP C45 TJA11XX PHYs"
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	help
>  	  Enable support for NXP C45 TJA11XX PHYs.
>  	  Currently supports only the TJA1103 PHY.

With that changed:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
