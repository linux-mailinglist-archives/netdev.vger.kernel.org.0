Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880325A2CB2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344850AbiHZQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344827AbiHZQqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:46:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A126A2B630;
        Fri, 26 Aug 2022 09:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1+qrU9950QfzNnLy0WDyq6B9ElOQ/hOzcQZFWjhLUSY=; b=DlSwWLoexpRsAd5rM+5oPmPbtA
        LYXDunXdQNtLVpyDSrjeR3EwECgk27UzGIrYOmkQH404X3qICozaO049ARu9AKHmjefl2co9PkToN
        otQ1nc5OCMdQbYMyhP6R5CiMDfjHb0izpE8oB2BOZ3e0svblbCrwd/RprEDzUpRhZ1RZahgm5oJXF
        pyXpiPNsXBrDu6QnqB0cD28tCVcEPOsfU8xGdMeXfnJszqX8mcYQPG+T/f+oO+KOTYLIW7E02qmvt
        RCdh6lj/3xaEAeUc09mxuFu12yd58MhPzvdh2foQsY5f3BsncoEr9xt3Ed63qo3NHN3SGLskRLsW6
        Ug7ATD/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33948)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oRcSK-0006Un-7r; Fri, 26 Aug 2022 17:45:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oRcSH-0006Dj-J4; Fri, 26 Aug 2022 17:45:13 +0100
Date:   Fri, 26 Aug 2022 17:45:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: pcs: add new PCS driver for altera TSE
 PCS
Message-ID: <Ywj4mQDyLzwbvxt8@shell.armlinux.org.uk>
References: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
 <20220826135451.526756-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826135451.526756-4-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 03:54:49PM +0200, Maxime Chevallier wrote:
> +
> +/* SGMII PCS register addresses
> + */
> +#define SGMII_PCS_SCRATCH	0x10
> +#define SGMII_PCS_REV		0x11
> +#define SGMII_PCS_LINK_TIMER_0	0x12
> +#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))
> +#define SGMII_PCS_LINK_TIMER_1	0x13
> +#define SGMII_PCS_IF_MODE	0x14
> +#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
> +#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
> +#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
> +#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
> +#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
> +#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)
> +#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
> +#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)

This looks very similar to pcs-lynx's register layout. I wonder if it's
the same underlying hardware.

> +static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			      phy_interface_t interface,
> +			      const unsigned long *advertising,
> +			      bool permit_pause_to_mac)
> +{
> +	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
> +	u32 ctrl, if_mode;
> +
> +	if (interface != PHY_INTERFACE_MODE_SGMII &&
> +	    interface != PHY_INTERFACE_MODE_1000BASEX)
> +		return 0;

I would suggest doing this check in .pcs_validate() to catch anyone
attaching the PCS with an unsupported interface mode.

> +static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
> +	u16 bmcr;
> +
> +	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> +	bmcr |= BMCR_ANRESTART;
> +	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> +
> +	tse_pcs_reset(tse_pcs);

Any ideas why a reset is necessary after setting BMCR_ANRESTART?
Normally, this is not required.

> diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
> new file mode 100644
> index 000000000000..9c85e7c8ef70
> --- /dev/null
> +++ b/include/linux/pcs-altera-tse.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2022 Bootlin
> + *
> + * Maxime Chevallier <maxime.chevallier@bootlin.com>
> + */
> +
> +#ifndef __LINUX_PCS_ALTERA_TSE_H
> +#define __LINUX_PCS_ALTERA_TSE_H
> +
> +struct phylink;

Don't you want "struct phylink_pcs;" here?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
