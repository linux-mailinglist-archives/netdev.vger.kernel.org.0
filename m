Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E38D54BC9D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiFNVNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbiFNVNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:13:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD6B4F9C7;
        Tue, 14 Jun 2022 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8HSyIfVTT1zYlvK02xC9mRk+gd/87N3apl+idAVh+1o=; b=vbbdR/lPasINng/RkQ1kPsbUox
        IMQ5LdA2hXTvTmlhHYmj1kz/EzPFPmHHbfpGaxrYmq7UViHDZhQcJWKsSO76D72nOKqM2wvgUpWq7
        3p0Fl/dETEM+uwyG0tFVhIaovjc5xl4+1myBXfM46Rk+C1EFAZX+OjyLvdqpdDzkfMj0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1Dqh-006vkm-2A; Tue, 14 Jun 2022 23:13:19 +0200
Date:   Tue, 14 Jun 2022 23:13:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        lxu@maxlinear.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support to SGMII 1G and
 2.5G
Message-ID: <Yqj575Z/tYXsRHHK@lunn.ch>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614103424.58971-5-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* MMD Device IDs */
> +#define STD_DEVID			(0x0)
> +#define MMD_PMAPMD			(0x1)
> +#define MMD_PCS				(0x3)
> +#define MMD_ANEG			(0x7)
> +#define MMD_VSPEC1			(0x1E)
> +#define MMD_VSPEC2			(0x1F)

Please use the values from include/uapi/mdio.h

> +
> +/* Vendor Specific SGMII MMD details */
> +#define SR_MII_DEV_ID1			0x0002
> +#define SR_MII_DEV_ID2			0x0003

MDIO_DEVID1 & MDIO_DEVID2

> +#define SR_VSMMD_PCS_ID1		0x0004
> +#define SR_VSMMD_PCS_ID2		0x0005
> +#define SR_VSMMD_STS			0x0008
> +#define SR_VSMMD_CTRL			0x0009
> +
> +#define SR_MII_CTRL			0x0000
> +#define SR_MII_CTRL_RST_		BIT(15)
> +#define SR_MII_CTRL_LBE_		BIT(14)
> +#define SR_MII_CTRL_SS13_		BIT(13)
> +#define SR_MII_CTRL_AN_ENABLE_		BIT(12)
> +#define SR_MII_CTRL_LPM_		BIT(11)
> +#define SR_MII_CTRL_RESTART_AN_		BIT(9)
> +#define SR_MII_CTRL_DUPLEX_MODE_	BIT(8)
> +#define SR_MII_CTRL_SS6_		BIT(6)

These look like standard BMCR registers. Please use the values from
mii.h

> +#define SR_MII_STS			0x0001
> +#define SR_MII_STS_ABL100T4_		BIT(15)
> +#define SR_MII_STS_FD100ABL_		BIT(14)
> +#define SR_MII_STS_HD100ABL_		BIT(13)
> +#define SR_MII_STS_FD10ABL_		BIT(12)
> +#define SR_MII_STS_HD10ABL_		BIT(11)
> +#define SR_MII_STS_FD100T_		BIT(10)
> +#define SR_MII_STS_HD100T_		BIT(9)
> +#define SR_MII_STS_EXT_STS_ABL_		BIT(8)
> +#define SR_MII_STS_UN_DIR_ABL_		BIT(7)
> +#define SR_MII_STS_MF_PRE_SUP_		BIT(6)
> +#define SR_MII_STS_AN_CMPL_		BIT(5)
> +#define SR_MII_STS_RF_			BIT(4)
> +#define SR_MII_STS_AN_ABL_		BIT(3)
> +#define SR_MII_STS_LINK_STS_		BIT(2)
> +#define SR_MII_STS_EXT_REG_CAP_		BIT(0)

These look like BMSR.

It could even be, you can just use generic code for these.

   Andrew
