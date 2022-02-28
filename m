Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115304C6F0D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiB1ONa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiB1ON3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:13:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CAE37002;
        Mon, 28 Feb 2022 06:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OJ1gRNEUSqP52FWYxziDdfpkPpm8wJ65QOTUW1Ma5gs=; b=OnzF8RGS5nV7aqrahARKNDCydG
        pzBm1owZD1yQlCjCVadmPQURAZD/Xauadw6Mxb13umjb0aUw97bLnN/STjwc+m71T3bYwxqwG00bu
        yzLBOXs7+oyd0alB+J/wxySJe4lQ+mQafyhp6XnIV+RB64BJ6CFiCnt2OCUwE+LexiiLAYPyFc5y9
        TaoNY/b6DvBa6Ej0gVwVjLPUc8b9hEDdAB52JRZwYQ2m5iiQX3PoKEU+hC6gZFirfgKUJD6um29M8
        ZSHcrhRtMuulyP/8VO57elTr5/rCxCCmPZkuM4NrI/jxEsyu/k0z8rquDDYfOIqBdkpDzG/cX+eKi
        AahWfjlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57562)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nOglY-0008Qb-1F; Mon, 28 Feb 2022 14:12:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nOglV-0006E9-Dm; Mon, 28 Feb 2022 14:12:41 +0000
Date:   Mon, 28 Feb 2022 14:12:41 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 4/4] net: phy: added master-slave config and
 cable diagnostics for Lan937x
Message-ID: <YhzYWXf30zcedsH1@shell.armlinux.org.uk>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
 <20220228140510.20883-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228140510.20883-5-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 07:35:10PM +0530, Arun Ramadoss wrote:
> To configure the Lan937x T1 phy as master or slave using the ethtool -s
> <dev> master-slave <forced-master/forced-slave>, the config_aneg and
> read status functions are added. And for the cable-diagnostics, used the
> lan87xx routines.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/phy/microchip_t1.c | 75 ++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
> index 634a1423182a..3a0d4c4fab0a 100644
> --- a/drivers/net/phy/microchip_t1.c
> +++ b/drivers/net/phy/microchip_t1.c
> @@ -81,6 +81,9 @@
>  #define T1_REG_BANK_SEL			8
>  #define T1_REG_ADDR_MASK		0xFF
>  
> +#define T1_MODE_STAT_REG		0x11
> +#define T1_LINK_UP_MSK			BIT(0)
> +
>  #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
>  #define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
>  
> @@ -435,6 +438,11 @@ static int lan_phy_config_init(struct phy_device *phydev)
>  	if (rc < 0)
>  		phydev_err(phydev, "failed to initialize phy\n");
>  
> +	phydev->duplex = DUPLEX_FULL;
> +	phydev->speed = SPEED_100;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;

Shouldn't this be done in lan937x_read_status()?

Have you tested this patch with various invocations of ethtool -s ?
E.g. autoneg on, autoneg off at various forced speeds, both suitable
for the PHY and unsuitable? Are all these sensibly handled?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
