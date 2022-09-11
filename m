Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E665B50F6
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiIKT6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 15:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIKT6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 15:58:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1628A27DD9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 12:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dBXcTqRXIyzn6/VpGTEqpFLugw8xANRV30xtPRjF4JM=; b=kgEnqC12NPmUW9Ab1FHNXV48HK
        fJ5s/kqjoO97QIJAGaJ1ipS1CmsJPmyoyRjWBHvhhuXePuWMqk1PXWZXqMkQbnoDNlB74lrHLq17f
        DukCVxbGvebqKAnLEJkljmbPBHBQZvQB9/IuIpse5n/2qTjKdLFfxeUTZwTco+uF3L0fde1xlyIG0
        jiEST458X8TcQJwuHtd6FeBAkte3JlTc22WMx7RV9qyDE5uCwzKOmJX1ehDeLLjouaFnbRnCw6gqy
        e4Wmh3qF9G7KLGhapLBTNoxmTkxV1j84c6fyClQoq8expCmYMriR6RQtXubHmuQ97qMRQiDqiwerS
        R7wO7KFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34244)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXT5z-0000uu-NL; Sun, 11 Sep 2022 20:58:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXT5r-0007P8-G9; Sun, 11 Sep 2022 20:58:15 +0100
Date:   Sun, 11 Sep 2022 20:58:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH] net: dsa: mt7530: add support for in-band link status
Message-ID: <Yx4910YC6/Y7ghfm@shell.armlinux.org.uk>
References: <YxvkbO9PoNi86BZa@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxvkbO9PoNi86BZa@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just two points please:

On Sat, Sep 10, 2022 at 02:12:12AM +0100, Daniel Golle wrote:
> +static void
> +mt7531_sgmii_pcs_get_state_inband(struct mt7530_priv *priv, int port,
> +				  struct phylink_link_state *state)
> +{
> +	unsigned int val;
> +
> +	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
> +	state->link = !!(val & MT7531_SGMII_LINK_STATUS);
> +	if (!state->link)
> +		return;
> +
> +	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
> +		state->speed = SPEED_2500;
> +	else
> +		state->speed = SPEED_1000;
> +
> +	state->duplex = DUPLEX_FULL;
> +	state->pause = 0;

MLO_PAUSE_NONE please.

Also, please set state->an_complete appropriately.


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
