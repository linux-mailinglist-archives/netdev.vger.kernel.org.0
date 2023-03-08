Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4846B0735
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjCHMfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCHMfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:35:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A332FBCBB2;
        Wed,  8 Mar 2023 04:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A+9+kArDFqMD7qz6roFjTV8cDajCHtDUUSq0on75xa4=; b=tkvSd7snwbc/j+floPhhA+OFbE
        lEW0Z0C3FLUY4x7rFhSSgL9uJYCdnhcWvMkmL8sSiIysZB9h/EOjliF2QnOc+TZLjPIMk7D5yhWTO
        7HRMICviQC3dHR4WLuajtCr/nQpeNrE2iF/3a9IqUGpYHFlcgZGBkFjCzTWnf1qtUWdPLvN3KV0YT
        CDEQUw3weHTFvv7dBOfmOgReTLHbefdxrHguYWfoUIEz/6qSgxf5RT4REXXXdNt8V4YRhjj9s09J2
        ppOuVhAANR8Z9V2bv0gdUkZfubJHwyQZHUCMIKyFnzwig9SNrFGHEmidmEc7pW3Kghdw/FTwFiLM/
        vZQ+H2cQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45066)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZt0m-0002Tl-36; Wed, 08 Mar 2023 12:35:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZt0e-0002Zg-Jl; Wed, 08 Mar 2023 12:35:08 +0000
Date:   Wed, 8 Mar 2023 12:35:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Message-ID: <ZAiA/ExxgHPEY15h@shell.armlinux.org.uk>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
 <ZAhzt5eIZiJUyVm7@shell.armlinux.org.uk>
 <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B69026D7-E770-4168-B1CA-54E34D52C961@public-files.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:44:57PM +0100, Frank Wunderlich wrote:
> Am 8. März 2023 12:38:31 MEZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> >On Tue, Mar 07, 2023 at 03:54:11PM +0000, Daniel Golle wrote:
> >> Link partner advertised link modes are not reported by the SerDes
> >> hardware if not operating in SGMII mode. Hence we cannot use
> >> phylink_mii_c22_pcs_decode_state() in this case.
> >> Implement reporting link and an_complete only and use speed according to
> >> the interface mode.
> >> 
> >> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
> >> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> >
> >This has been proven to work by Frank Wunderlich last October, so by
> >making this change, you will be regressing his setup.
> 
> Hi
> 
> My tests were done with 1 kind of 1g fibre sfp as i only have these atm...have ordered some 2g5 rj54 ones,but don't have them yet. I'm not sure if they are working with/without sgmii (1000base-X) and if they have builtin phy.

Fiber SFPs do not have a built in PHY. They merely convert the serdes
electrical waveform into light and back again, possibly with some
retiming of the received waveform, and a bit of monitoring. They're
pretty simple devices.

They certainly do not change the protocol in any way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
