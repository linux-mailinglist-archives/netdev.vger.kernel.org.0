Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A1D2168E3
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 11:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGGJSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 05:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGGJSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 05:18:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3278C061755;
        Tue,  7 Jul 2020 02:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PEPkpJ1U8/XdtEMupOhDNtE/L5C3GtSPL7IkTCZNSMY=; b=u//BIq20gBtm03+DHzBIfHpOo
        c3f7BD9SX4z6mbRxtXLNTaGYT7qcYXauf2PDiEJWmh3LYiu2wYfwE8Dsffj8bEoN4gf1i49YwKDPW
        yZjaMuVNZvJFnR6itt6Etd1kxP4foHLxPsjPuxZQEMT/hV9ZlhMw2GBUfCXSfsuAlnlu3zeBNkzFG
        l2/GJU7EjlJWHNFWqHUapU1NaSC80Go76p1CAwAh+fsWmkch6UuQMMaybL5o0xsXIc8W0xaVWF46R
        dDxmKr1HClbrZNoLaQYb8YyA5TyP588oOTZyvXwMwl/0cIP1ncDm6FzEeaINK/OEtZb8/AlRqIBeY
        oG7CusBVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36396)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jsjkI-0006n7-A9; Tue, 07 Jul 2020 10:18:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jsjkF-0008O5-Dj; Tue, 07 Jul 2020 10:18:31 +0100
Date:   Tue, 7 Jul 2020 10:18:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [PATCH net-next v4 1/3] net: dsa: felix: move USXGMII defines to
 common place
Message-ID: <20200707091831.GX1551@shell.armlinux.org.uk>
References: <20200706220255.14738-1-michael@walle.cc>
 <20200706220255.14738-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706220255.14738-2-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 12:02:53AM +0200, Michael Walle wrote:
> The ENETC has the same PCS PHY and thus needs the same definitions. Move
> them into the common enetc_mdio.h header which has already the macros
> for the SGMII PCS.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 21 ---------------------
>  include/linux/fsl/enetc_mdio.h         | 19 +++++++++++++++++++
>  2 files changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 19614537b1ba..53453c7015f6 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -16,29 +16,8 @@
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
> diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
> index 2d9203314865..611a7b0d5f10 100644
> --- a/include/linux/fsl/enetc_mdio.h
> +++ b/include/linux/fsl/enetc_mdio.h
> @@ -28,6 +28,25 @@ enum enetc_pcs_speed {
>  	ENETC_PCS_SPEED_2500	= 2,
>  };
>  
> +#define USXGMII_BMCR_RESET		BIT(15)
> +#define USXGMII_BMCR_AN_EN		BIT(12)
> +#define USXGMII_BMCR_RST_AN		BIT(9)

Aren't these just redefinitions of the standard BMCR definitions?

> +#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
> +#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)

Aren't these just redefinitions of the standard BMSR definitions just
differently?

Maybe convert the code to use the standard definitions found in
include/uapi/linux/mii.h and include/uapi/linux/mdio.h?

> +#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
> +#define USXGMII_ADVERTISE_FDX		BIT(12)
> +#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
> +#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
> +#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
> +#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
> +
> +enum usxgmii_speed {
> +	USXGMII_SPEED_10	= 0,
> +	USXGMII_SPEED_100	= 1,
> +	USXGMII_SPEED_1000	= 2,
> +	USXGMII_SPEED_2500	= 4,
> +};
> +

I've asked in other patch sets for the USXGMII definitions to be moved
into some header that everyone can use - there is nothing enetc specific
about the USXGMII word definitions.  Please move them to a header file
so that everyone can use them.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
