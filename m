Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F9218540
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgGHKsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgGHKsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:48:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC964C08C5DC;
        Wed,  8 Jul 2020 03:48:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id rk21so49872986ejb.2;
        Wed, 08 Jul 2020 03:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RrgVo9Yoph6Ph9pZjHhn/teNbRi42NVD4aZq8okezck=;
        b=ozbZSuHlgNvUn0royS5449Kz59zjfL6zwyEYeS06CQlDmyw8vJXBqgNu3dPcpvEKAW
         JPnbgauwPtHjLtTAQZIz8+tVDfv1Iuiaryeyh4nOFFTvmAxx2wTG+nJkNT0ZkZ06MgH/
         p1QxLdrDDVmsK+iOCE3DZ7EWkzDVFzjJb/93yBsTA+t4RMtCPhzeUkXzyfyCJHVUT++s
         7ZgkLXzLz9rebsjdHHI9yuNFPO0foifVP4qVSgccGLGQ7wG6mIE2b6gLqhkbiJ0lRbZf
         HtZQCUcBBkC/tdwYRwLiA50pLD6OxeDC5kAVQhj+wAXL8A5wL6euvnGY1bqazZpoe0HT
         JhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RrgVo9Yoph6Ph9pZjHhn/teNbRi42NVD4aZq8okezck=;
        b=IOtgPzuKLEKRTsyBq9CK6zCsuIGnp7BYWEyYQNYuKQrl3u9mX9XvFmpMi77/Z3AaVN
         2VJS6FjvZlUgWOvEnB6Pn2IcrMbEcbxbNaab0yYyV+pKiJ2qWr666kRmsDZvcd+H5HWG
         DAzIbXOVPrVJjvtaAbN9DfM4HdjEG2LDpJDBUl5NNsQQRVOnUb1lAezP8Rb+1CcJeAeF
         oPMYU7sCMA0R8lmZQKHEot2bYH3Zs96SKGhmw+qVdLiBn6xEVkYihaPoV6acAxTBXh7L
         A/u+NbECuXTV7mlp7IrSeiIx/POPFQtJPKcDY2DeDQmiOOufryGBhrR0oq3+hSPBJaIz
         vGUw==
X-Gm-Message-State: AOAM531DwcWdusXb3mcweqREVTTqSdis5m7OtkyO4AMWz4u9G9IRSQ25
        zbDJAflDTT0x4qYWmu8KCAE=
X-Google-Smtp-Source: ABdhPJxWhbuv0rjacuXTmpKtsDVemvrvB46zpN3nY5Aslf4uERjwIeSfKC+t/aSUk1O0BpgvVY60nQ==
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr51246219ejy.138.1594205279341;
        Wed, 08 Jul 2020 03:47:59 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id q3sm23700539eds.41.2020.07.08.03.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 03:47:58 -0700 (PDT)
Date:   Wed, 8 Jul 2020 13:47:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v5 2/4] net: dsa: felix: (re)use already
 existing constants
Message-ID: <20200708104756.y42eid56w5jspl6u@skbuf>
References: <20200707212131.15690-1-michael@walle.cc>
 <20200707212131.15690-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707212131.15690-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 11:21:29PM +0200, Michael Walle wrote:
> Now that there are USXGMII constants available, drop the old definitions
> and reuse the generic ones.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 45 +++++++-------------------
>  1 file changed, 12 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 19614537b1ba..4310b1527022 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -10,35 +10,15 @@
>  #include <soc/mscc/ocelot.h>
>  #include <net/pkt_sched.h>
>  #include <linux/iopoll.h>
> +#include <linux/mdio.h>
>  #include <linux/pci.h>
>  #include "felix.h"
>  
>  #define VSC9959_VCAP_IS2_CNT		1024
>  #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
>  #define VSC9959_VCAP_PORT_CNT		6
> -
> -/* TODO: should find a better place for these */
> -#define USXGMII_BMCR_RESET		BIT(15)
> -#define USXGMII_BMCR_AN_EN		BIT(12)
> -#define USXGMII_BMCR_RST_AN		BIT(9)
> -#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
> -#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)
> -#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
> -#define USXGMII_ADVERTISE_FDX		BIT(12)
> -#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
> -#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
> -#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
> -#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
> -
>  #define VSC9959_TAS_GCL_ENTRY_MAX	63
>  
> -enum usxgmii_speed {
> -	USXGMII_SPEED_10	= 0,
> -	USXGMII_SPEED_100	= 1,
> -	USXGMII_SPEED_1000	= 2,
> -	USXGMII_SPEED_2500	= 4,
> -};
> -
>  static const u32 vsc9959_ana_regmap[] = {
>  	REG(ANA_ADVLEARN,			0x0089a0),
>  	REG(ANA_VLANMASK,			0x0089a4),
> @@ -787,11 +767,10 @@ static void vsc9959_pcs_config_usxgmii(struct phy_device *pcs,
>  {
>  	/* Configure device ability for the USXGMII Replicator */
>  	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
> -		      USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
> -		      USXGMII_ADVERTISE_LNKS(1) |
> +		      MDIO_LPA_USXGMII_2500FULL |
> +		      MDIO_LPA_USXGMII_LINK |
>  		      ADVERTISE_SGMII |
> -		      ADVERTISE_LPACK |
> -		      USXGMII_ADVERTISE_FDX);
> +		      ADVERTISE_LPACK);
>  }
>  
>  static void vsc9959_pcs_config(struct ocelot *ocelot, int port,
> @@ -1005,8 +984,8 @@ static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
>  		return;
>  
>  	pcs->autoneg = true;
> -	pcs->autoneg_complete = USXGMII_BMSR_AN_CMPL(status);
> -	pcs->link = USXGMII_BMSR_LNKS(status);
> +	pcs->autoneg_complete = status & BMSR_ANEGCOMPLETE;
> +	pcs->link = status & BMSR_LSTATUS;

These are "unsigned :1" in struct phy_device, and not booleans. I'm not
sure how the compiler is going to treat this assignment of an integer.
I have a feeling it may not do the right thing. Could you please do
this?

	pcs->autoneg_complete = !!(status & BMSR_ANEGCOMPLETE);
	pcs->link = !!(status & BMSR_LSTATUS);

>  
>  	if (!pcs->link || !pcs->autoneg_complete)
>  		return;
> @@ -1015,24 +994,24 @@ static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
>  	if (lpa < 0)
>  		return;
>  
> -	switch (USXGMII_LPA_SPEED(lpa)) {
> -	case USXGMII_SPEED_10:
> +	switch (lpa & MDIO_LPA_USXGMII_SPD_MASK) {
> +	case MDIO_LPA_USXGMII_10:
>  		pcs->speed = SPEED_10;
>  		break;
> -	case USXGMII_SPEED_100:
> +	case MDIO_LPA_USXGMII_100:
>  		pcs->speed = SPEED_100;
>  		break;
> -	case USXGMII_SPEED_1000:
> +	case MDIO_LPA_USXGMII_1000:
>  		pcs->speed = SPEED_1000;
>  		break;
> -	case USXGMII_SPEED_2500:
> +	case MDIO_LPA_USXGMII_2500:
>  		pcs->speed = SPEED_2500;
>  		break;
>  	default:
>  		break;
>  	}
>  
> -	if (USXGMII_LPA_DUPLEX(lpa))
> +	if (lpa & MDIO_LPA_USXGMII_FULL_DUPLEX)
>  		pcs->duplex = DUPLEX_FULL;
>  	else
>  		pcs->duplex = DUPLEX_HALF;
> -- 
> 2.20.1
> 

Thanks,
-Vladimir
