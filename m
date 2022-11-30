Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B8063D296
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiK3J4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiK3J4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:56:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C897B2B18F;
        Wed, 30 Nov 2022 01:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GVLyEqnOyLgzZX9E6rEEaMWO0mcMUM4Ki3SNZTd8s3I=; b=JoZ5+muE9jhUXGIc1rOcWjW5N1
        56AHpUVmIMNWFE/9Dup8JNBm+PRFGpqUH+ETJa0dGnOOJH1NKKXwdd1plcEpVW8t0zg3a9Kon+bEd
        Jm75Qb9h3X4YCrgSFeGzyqOY9Eg+dHqMT0w0cLYUkZAC2ARO9yjX24MFsg/QgdxN9JWRx3++IWZUH
        6eTkX+bp2jDnH/DjCpA0PulUHoDKODkXpPa7gsUZ8/fW2CiKk9USYE2pRHrCTIbSfgypjC/ve1Eat
        ndKCwLxe1njB6jMzoB9kNqZqm0mnWd3CdIXGeTjhB+jo/gvQbxgD4uG+yBO5pDNkBuVrHy+QY9LDm
        3Q15pC+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35490)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0Joo-0001Z9-13; Wed, 30 Nov 2022 09:55:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0Jok-0002Oj-Et; Wed, 30 Nov 2022 09:55:50 +0000
Date:   Wed, 30 Nov 2022 09:55:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4copjAzKpGSeunB@shell.armlinux.org.uk>
References: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 05:49:28PM +0800, Frank wrote:
> +/**
> + * yt8531_set_wol() - turn wake-on-lan on or off
> + * @phydev: a pointer to a &struct phy_device
> + * @wol: a pointer to a &struct ethtool_wolinfo
> + *
> + * NOTE: YTPHY_WOL_CONFIG_REG, YTPHY_WOL_MACADDR2_REG, YTPHY_WOL_MACADDR1_REG
> + * and YTPHY_WOL_MACADDR0_REG are common ext reg.
> + *
> + * returns 0 or negative errno code
> + */
> +static int yt8531_set_wol(struct phy_device *phydev,
> +			  struct ethtool_wolinfo *wol)
> +{

So this is called from the .set_wol method directly, and won't have the
MDIO bus lock taken...

> +	struct net_device *p_attached_dev;
> +	const u16 mac_addr_reg[] = {
> +		YTPHY_WOL_MACADDR2_REG,
> +		YTPHY_WOL_MACADDR1_REG,
> +		YTPHY_WOL_MACADDR0_REG,
> +	};
> +	const u8 *mac_addr;
> +	u16 mask;
> +	u16 val;
> +	int ret;
> +	u8 i;
> +
> +	if (wol->wolopts & WAKE_MAGIC) {
> +		p_attached_dev = phydev->attached_dev;
> +		if (!p_attached_dev)
> +			return -ENODEV;
> +
> +		mac_addr = (const u8 *)p_attached_dev->dev_addr;
> +		if (!is_valid_ether_addr(mac_addr))
> +			return -EINVAL;
> +
> +		/* Store the device address for the magic packet */
> +		for (i = 0; i < 3; i++) {
> +			ret = ytphy_write_ext(phydev, mac_addr_reg[i],
> +					      ((mac_addr[i * 2] << 8)) |
> +						      (mac_addr[i * 2 + 1]));

This accesses the MDIO bus without taking the lock.

> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		/* Enable WOL feature */
> +		mask = YTPHY_WCR_PULSE_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
> +		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
> +		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PULSE_WIDTH_672MS;
> +		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, val);

This accesses the MDIO bus without taking the lock.

> +		if (ret < 0)
> +			return ret;
> +
> +		/* Enable WOL interrupt */
> +		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0,
> +				   YTPHY_IER_WOL);

This accesses the MDIO bus without taking the lock.

> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		/* Disable WOL feature */
> +		mask = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
> +		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, 0);

This accesses the MDIO bus without taking the lock.

> +
> +		/* Disable WOL interrupt */
> +		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG,
> +				   YTPHY_IER_WOL, 0);

This accesses the MDIO bus without taking the lock.

> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

Which makes this function entirely unsafe as another thread can change
the YTPHY_PAGE_SELECT register between writing that register and
accessing the YTPHY_PAGE_DATA register.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
