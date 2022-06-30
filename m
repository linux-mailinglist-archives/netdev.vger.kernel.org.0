Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F61561968
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiF3Lmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiF3Lmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:42:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F6F58FCA;
        Thu, 30 Jun 2022 04:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pCVLDadV5ten+hI6vWRZbnBdPC+AeuTjF2D/qYD+soU=; b=URILelAHkP5sNj7GCPdqIAlP85
        mwvBvo7cYQFudtfKq7Jpu0ifkS6tR/bsjkiNEg87fn6Keur4eVCZBcbZLL1AlXLx0oiMVMwRRtjTz
        ucGVEQR4h4KZJNVUzHZdEuXXKsf17V5xOk3MNMmlSRcpojtU3gyJgOFN51+TtCNNNtGwFHLMCNLp6
        WIMjOqTrMoR6mXHI8/R+tfdHgGnfuhpB0rUUTTxzYikWBNOuV9hXNRPsbiih8vMB6vHVpYQdv3FY7
        mMhuAshVrIO6Qf/GegBaHIsZEH008S/x8aUhPNcPLhGclMW9aTWf2v0dZ+7gvBH0OK7eQ3lkBFI5n
        7ZffnVGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33116)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6sZ2-0004MZ-OK; Thu, 30 Jun 2022 12:42:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6sZ0-0006lS-Qs; Thu, 30 Jun 2022 12:42:26 +0100
Date:   Thu, 30 Jun 2022 12:42:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [Patch net-next v14 11/13] net: dsa: microchip: lan937x: add
 phylink_mac_link_up support
Message-ID: <Yr2MImcS9lzr3yx9@shell.armlinux.org.uk>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
 <20220630102041.25555-12-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630102041.25555-12-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 03:50:39PM +0530, Arun Ramadoss wrote:
> +static void lan937x_config_gbit(struct ksz_device *dev, bool gbit, u8 *data)
> +{
> +	if (gbit)
> +		*data &= ~PORT_MII_NOT_1GBIT;
> +	else
> +		*data |= PORT_MII_NOT_1GBIT;
> +}
> +
> +static void lan937x_config_interface(struct ksz_device *dev, int port,
> +				     int speed, int duplex,
> +				     bool tx_pause, bool rx_pause)
> +{
> +	u8 xmii_ctrl0, xmii_ctrl1;
> +
> +	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
> +	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		lan937x_config_gbit(dev, true, &xmii_ctrl1);
> +		break;
> +	case SPEED_100:
> +		lan937x_config_gbit(dev, false, &xmii_ctrl1);
> +		xmii_ctrl0 |= PORT_MII_100MBIT;
> +		break;
> +	case SPEED_10:
> +		lan937x_config_gbit(dev, false, &xmii_ctrl1);
> +		xmii_ctrl0 &= ~PORT_MII_100MBIT;
> +		break;
> +	default:
> +		dev_err(dev->dev, "Unsupported speed on port %d: %d\n",
> +			port, speed);
> +		return;
> +	}

Isn't this:

	if (speed == SPEED_1000)
		xmii_ctrl1 &= ~PORT_MII_NOT_1GBIT;
	else
		xmii_ctrl1 |= PORT_MII_NOT_1GBIT;

	if (speed == SPEED_100)
		xmii_ctrl0 |= PORT_MII_100MBIT;
	else
		xmii_ctrl0 &= ~PORT_MII_100MBIT;

There isn't much need to validate that "speed" is correct, you've
already told phylink that you only support 1G, 100M and 10M so you're
not going to get called with anything except one of those.

> +
> +	if (duplex)
> +		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
> +	else
> +		xmii_ctrl0 &= ~PORT_MII_FULL_DUPLEX;
> +
> +	if (tx_pause)
> +		xmii_ctrl0 |= PORT_MII_TX_FLOW_CTRL;
> +	else
> +		xmii_ctrl1 &= ~PORT_MII_TX_FLOW_CTRL;

It seems weird to set a bit in one register and clear it in a different
register. I suspect you mean xmii_ctrl0 here.

> +
> +	if (rx_pause)
> +		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
> +	else
> +		xmii_ctrl0 &= ~PORT_MII_RX_FLOW_CTRL;
> +
> +	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
> +	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);
> +}
> +

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
