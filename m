Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09916B060E
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCHLgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjCHLfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:35:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12FDAFBBF;
        Wed,  8 Mar 2023 03:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7q5WRUhB8xv0RmSiXrjbZQTqBS/OimwrA3VM7RORVD0=; b=AMlDmF0qS7/JM218n5xSc6B/il
        0fN2kNupiUXxRe+kzYu2XBBq403g9gC55gVLbJ/sN3USW+t3cMnbjVMv1cQxEBMuYjeiAPI8PhDtD
        lIYeO9dz7RVb4vkk7cu5AOr4RrSvza1Tikl2KyxdqvclclEP1pKICKtbtHcivpmP9idHEpaStDG31
        QXFsFdAJfWILtRrn4Z1dr009qSE8DUVGILTTUqq9JKpELdqm/W+u6Z+fwhim3k366hBAwodhKKTRE
        A5A7x75q3eKme2IVkQgndmFwAs/tm4/Ex79eraWChy7xrqv0uZIMR+qrTTdaiMLJVlvVomq8jymKb
        aaWjx07w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34522)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZs5C-0002MJ-Ax; Wed, 08 Mar 2023 11:35:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZs57-0002XC-0y; Wed, 08 Mar 2023 11:35:41 +0000
Date:   Wed, 8 Mar 2023 11:35:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 03:53:58PM +0000, Daniel Golle wrote:
> After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
> would work only after `ethtool -s eth1 autoneg off`.
> As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
> to control auto-negotiation on the external interface it doesn't make
> much sense to use it to control on-board SGMII auto-negotiation between
> MAC and PHY.
> Set correct values to really only enable SGMII auto-negotiation when
> actually operating in SGMII mode. For 1000Base-X and 2500Base-X mode,
> enable remote-fault detection only if in-band-status is enabled.
> This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
> board and also makes it possible to use interface-mode-switching PHYs
> operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
> 2500M mode on other boards.
> 
> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

NAK.

There are PHYs out there which operate in SGMII mode but do not
exchange the SGMII 16-bit configuration word. The code implemented
here by me was explicitly to allow such a configuration to work,
which is defined as:

	SGMII *without* mode == inband

An example of this is the Broadcom 84881 PHY which can be found on
SFP modules.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
