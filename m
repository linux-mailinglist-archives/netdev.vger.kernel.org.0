Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34927585F4A
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 16:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiGaOft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 10:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGaOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 10:35:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19162F585;
        Sun, 31 Jul 2022 07:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IuTVlloIOJRXiC5bMvv+29ddXC1np5Lf9kKXePRR13U=; b=vjEWo0wghmx5EFVLcWo9Oa2Mke
        QGIIXA+jx/OG9BUtoceyFoNs7lBg+EJqRs1l49PAQdgkiViROEiWjXMGDUjtaPTX+P+w7UxQeW61f
        2QZ32ZnTiXafCrZNOtJzD57NyjPTJ6Z9iie+YJWTU84GtXhPHF4JnYIyzchAD7oSiCik=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oIA2c-00C5ZZ-16; Sun, 31 Jul 2022 16:35:38 +0200
Date:   Sun, 31 Jul 2022 16:35:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet
Message-ID: <YuaTOglYjfTEVYvX@lunn.ch>
References: <20220727070827.1162-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727070827.1162-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Interrupt enable Register */
> +#define YTPHY_INTERRUPT_ENABLE_REG		0x12
> +#define YTPHY_IER_AUTONEG_ERR			BIT(15)
> +#define YTPHY_IER_SPEED_CHANGED			BIT(14)
> +#define YTPHY_IER_DUPLEX_CHANGED		BIT(13)
> +#define YTPHY_IER_PAGE_RECEIVED			BIT(12)
> +#define YTPHY_IER_LINK_FAILED			BIT(11)
> +#define YTPHY_IER_LINK_SUCCESSED		BIT(10)
> +#define YTPHY_IER_WOL				BIT(6)
> +#define YTPHY_IER_WIRESPEED_DOWNGRADE		BIT(5)
> +#define YTPHY_IER_SERDES_LINK_FAILED		BIT(3)
> +#define YTPHY_IER_SERDES_LINK_SUCCESSED		BIT(2)
> +#define YTPHY_IER_POLARITY_CHANGED		BIT(1)
> +#define YTPHY_IER_JABBER_HAPPENED		BIT(0)
> +
> +/* Interrupt Status Register */
> +#define YTPHY_INTERRUPT_STATUS_REG		0x13
> +#define YTPHY_ISR_AUTONEG_ERR			BIT(15)
> +#define YTPHY_ISR_SPEED_CHANGED			BIT(14)
> +#define YTPHY_ISR_DUPLEX_CHANGED		BIT(13)
> +#define YTPHY_ISR_PAGE_RECEIVED			BIT(12)
> +#define YTPHY_ISR_LINK_FAILED			BIT(11)
> +#define YTPHY_ISR_LINK_SUCCESSED		BIT(10)
> +#define YTPHY_ISR_WOL				BIT(6)
> +#define YTPHY_ISR_WIRESPEED_DOWNGRADE		BIT(5)
> +#define YTPHY_ISR_SERDES_LINK_FAILED		BIT(3)
> +#define YTPHY_ISR_SERDES_LINK_SUCCESSED		BIT(2)
> +#define YTPHY_ISR_POLARITY_CHANGED		BIT(1)
> +#define YTPHY_ISR_JABBER_HAPPENED		BIT(0)

> + * ytphy_set_wol() - turn wake-on-lan on or off
> + * @phydev: a pointer to a &struct phy_device
> + * @wol: a pointer to a &struct ethtool_wolinfo
> + *
> + * NOTE: YTPHY_WOL_CONFIG_REG, YTPHY_WOL_MACADDR2_REG, YTPHY_WOL_MACADDR1_REG
> + * and YTPHY_WOL_MACADDR0_REG are common ext reg. the YTPHY_INTERRUPT_ENABLE_REG
> + * of UTP is special, fiber also use this register.
> + *
> + * returns 0 or negative errno code
> + */
> +static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *p_attached_dev;
> +	const u16 mac_addr_reg[] = {
> +		YTPHY_WOL_MACADDR2_REG,
> +		YTPHY_WOL_MACADDR1_REG,
> +		YTPHY_WOL_MACADDR0_REG,
> +	};
> +	const u8 *mac_addr;
> +	int old_page;
> +	int ret = 0;
> +	u16 mask;
> +	u16 val;
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
> +		/* lock mdio bus then switch to utp reg space */
> +		old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
> +		if (old_page < 0)
> +			goto err_restore_page;
> +
> +		/* Store the device address for the magic packet */
> +		for (i = 0; i < 3; i++) {
> +			ret = ytphy_write_ext(phydev, mac_addr_reg[i],
> +					      ((mac_addr[i * 2] << 8)) |
> +						      (mac_addr[i * 2 + 1]));
> +			if (ret < 0)
> +				goto err_restore_page;
> +		}
> +
> +		/* Enable WOL feature */
> +		mask = YTPHY_WCR_PUSEL_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
> +		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
> +		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PUSEL_WIDTH_672MS;
> +		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, val);
> +		if (ret < 0)
> +			goto err_restore_page;
> +
> +		/* Enable WOL interrupt */
> +		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0,
> +				   YTPHY_IER_WOL);
> +		if (ret < 0)
> +			goto err_restore_page;

You have interrupt bits defined, you enable the WoL interrupt, but you
don't have an interrupt handler. PHY interrupts are generally level
interrupts, so on WoL, don't you end up with an interrupt storm,
because you don't have anything clearing the WoL interrupt?

	Andrew
