Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3711421DC9E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgGMQd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730194AbgGMQd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:33:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD270C061755;
        Mon, 13 Jul 2020 09:33:25 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n26so17964616ejx.0;
        Mon, 13 Jul 2020 09:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ychIRptdstMkkJKoImCG9Y7RbnRSRh80JgCAkhzxkSs=;
        b=OZCc5S23rCiTeSjlJXE1Zr5xv8geoZGQiPcazXiStEmJciJGyFZuujbONmZ3eE0/yk
         V0lzBVL8NIyYEkb7SAMZpfEnf7sTKf4DLFxBJ7OLNmrY1etyRaEBwjNcmDsXxY8Cfab+
         rNRR1C1+z4pzFUP4TQtAveMJVitxjXixlNS6LLEjMNlgujXunkHJZSkfBYCCeOJMwZtK
         m6ZBZBdY+qDby1eTiToaaOtZ5qFFdvxb0J9ABu90d3KW1MdTazoBMHStsfUn5uvQDsCw
         5EOTaAzN13f5DRFeZgMfqqirSX6odtRME5I9rSBA9NxZSAWcmTUWo+kekD5BQkfh0VxX
         j2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ychIRptdstMkkJKoImCG9Y7RbnRSRh80JgCAkhzxkSs=;
        b=NHjsbgRoVRvC8I4XEcGA3h+O0gkhGlEGEFbz4lA97UQ1k4gjHhUdhEkxSYYpXnS+Ma
         GFQU/+HMdgrjK5bPo599puXBYy7BYaeSUwpBJeE4D50e2x3GDjrKxpSd/Yb7DIiYBGbB
         O/yC3d0oQhqivVfY49SV7gYBkts3WrBqIyZqYBUUcePpI9mtcqjS7RKjkm5Es7H90t6m
         uPrmGkaN3X0iVGyTWj8G2F+jWUjW/Z5keYRZPUlVXL6Fn7rb0nDXD2cvYmMOfvbe/I6v
         BUIXGCSF3fK2YH/ZNVSw1mOwOoxWyMNIegz9a3PFt+X49NijeqygmGfQEslZxNQnXCHI
         0fKA==
X-Gm-Message-State: AOAM533r0zeDSGFT46rJIhvkpk3V5/T8uLVWxuvyF0Xm6tXJuRNurlts
        Z/gZtBShY8uPMIITzSEsQ/U=
X-Google-Smtp-Source: ABdhPJwYdQKIRCnUaToJoITFPULDi1TRTE2JaB0aezgBFQuz8Mzxvf0JB0NOlhphjV+sHd9wcQGjfg==
X-Received: by 2002:a17:906:538a:: with SMTP id g10mr599771ejo.354.1594658004599;
        Mon, 13 Jul 2020 09:33:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id v19sm12145888eda.70.2020.07.13.09.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:33:24 -0700 (PDT)
Date:   Mon, 13 Jul 2020 19:33:21 +0300
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
Subject: Re: [PATCH net-next v6 2/4] net: dsa: felix: (re)use already
 existing constants
Message-ID: <20200713163321.5mvc7k6td3t7b4qo@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:24PM +0200, Michael Walle wrote:
> Now that there are USXGMII constants available, drop the old definitions
> and reuse the generic ones.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

I did regression-testing of this on an LS1028A-QDS with SerDes protocol
0x13bb.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

There was a regression, but it wasn't caused by you.

>  drivers/net/dsa/ocelot/felix_vsc9959.c | 45 +++++++-------------------
>  1 file changed, 12 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 19614537b1ba..a3ddb1394540 100644
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
> +	pcs->autoneg_complete = !!(status & BMSR_ANEGCOMPLETE);
> +	pcs->link = !!(status & BMSR_LSTATUS);
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
