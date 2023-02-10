Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB82E692978
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjBJVqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjBJVqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:46:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCA446738;
        Fri, 10 Feb 2023 13:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BjQumwk3nvQwR3Qjq3TUIc1Lnm3M+8mBL9xrBUbWiCU=; b=jME+vNuT0Oy/ihAHzQ1M6x8txM
        S4MR7MKYXvMiJMf3QlkAmkhOGKXFs3rR2HTlJUp733H2zv2FFSN5jY6cSQe1UwTuAnOa9vJfG/yiu
        ZbFJBvJDKdgkuNp5Ta/qDuFBH6v10Q1+nl++nRdBw++SNTwlPGH7lYy/S1eEOpBJJIIHXt6yW8/tW
        5U/mDZMCA6XbJcbs/DRZaYdFOxeVpebG6dICNFdeM0Yjh44k84jhidJ+eZKGSh0FtIWxPo7TTwhlO
        km4dWpSINKq2vedPR6k6d31FXJa0dbsWHeUiUZv6WVb+e2lSnrJqDX+xplYlypnK9nR6JYsMPQNsb
        z4Xaqx+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55920)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQbDR-0000i3-5A; Fri, 10 Feb 2023 21:45:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQbDP-0000VH-Rn; Fri, 10 Feb 2023 21:45:55 +0000
Date:   Fri, 10 Feb 2023 21:45:55 +0000
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
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v3 10/12] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y+a7E5n6QrD/Igdg@shell.armlinux.org.uk>
References: <cover.1675984550.git.daniel@makrotopia.org>
 <70f9c17b694173cdef5f74901e5d0bc037c1eded.1675984550.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70f9c17b694173cdef5f74901e5d0bc037c1eded.1675984550.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 11:34:47PM +0000, Daniel Golle wrote:
> The SGMII core found in several MediaTek SoCs is identical to what can
> also be found in MediaTek's MT7531 Ethernet switch IC.
> As this has not always been clear, both drivers developed different
> implementations to deal with the PCS.
> 
> Add a dedicated driver, mostly by copying the code now found in the
> Ethernet driver. The now redundant code will be removed by a follow-up
> commit.
> 
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Comments on v2 also apply to this version.

(this is mainly for net-next tracking review purposes.)
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
