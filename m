Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115176B0C93
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCHPYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCHPYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:24:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53C8CD649;
        Wed,  8 Mar 2023 07:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CQH39Di29dr/Gqo5tr4azRM7bV/jn6BroV0Z6GxcVTQ=; b=nt4eGNU1vpmMG5CMd/ToMMa/GR
        RqB54MsLk8c/5naFCaUuHwjQcuBI4PoZTksLoj+MlH9AnAbRCEUKeHR3BXKX3/3Eask+mj+NOjsk0
        CDoaxiCdDHUJuJfQ0NEBnoSn9Gu19Do+TVwWbO/1nBaLD1e10I0YPIRL4oYkgBT9t8GZ8p4S3E1Op
        jU8I3YBVKWCyQ4e5To2juv1IZ46o+rKOnRyzu7rgawD0YHypPS8u/3/GDWPfwfdlpWECVJkLRrHFT
        eMK4SHu66d2q2ehrEqAS4j/AoNSzRv5GLIVjC9zscqbBubbsHZmDKEGVLHCcGZ3nNgt4lLGnK3Bgy
        Pxgvt0SQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41704)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZved-0002qq-BO; Wed, 08 Mar 2023 15:24:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZveU-0002h7-N4; Wed, 08 Mar 2023 15:24:26 +0000
Date:   Wed, 8 Mar 2023 15:24:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
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
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAioqp21521NsttV@shell.armlinux.org.uk>
References: <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
 <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk>
 <ZAik+I1Ei+grJdUQ@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAik+I1Ei+grJdUQ@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 03:08:55PM +0000, Daniel Golle wrote:
> On Wed, Mar 08, 2023 at 03:01:07PM +0000, Russell King (Oracle) wrote:
> > > FYI:
> > > TP-LINK TL-SM410U 2500Base-T module:
> > > 
> > > sfp EE: 00000000: 03 04 07 00 00 00 00 00 00 40 00 01 1f 00 00 00  .........@......
> > > sfp EE: 00000010: 00 00 00 00 54 50 2d 4c 49 4e 4b 20 20 20 20 20  ....TP-LINK     
> > > sfp EE: 00000020: 20 20 20 20 00 30 b5 c2 54 4c 2d 53 4d 34 31 30      .0..TL-SM410
> > > sfp EE: 00000030: 55 20 20 20 20 20 20 20 32 2e 30 20 00 00 00 1b  U       2.0 ....
> > > sfp EE: 00000040: 00 08 01 00 80 ff ff ff 40 3d f0 0d c0 ff ff ff  ........@=......
> > > sfp EE: 00000050: c8 39 7a 08 c0 ff ff ff 50 3d f0 0d c0 ff ff ff  .9z.....P=......
> > > sfp sfp2: module TP-LINK          TL-SM410U        rev 2.0  sn 12260M4001782    dc 220622  
> > 
> > I'm guessing this is a module with a checksum problem...
> 
> No, the checksum of the TL-SM410U is correct. I have patched the kernel
> to always dump the EEPROM, so I can share it with you.

Bear in mind that I haven't spent time with the spec to manually decode
the above, when I have tools to do that for me when given the EEPROM in
the correct form, which is:

> > It would be nice to add these to my database - please send me the
> > output of ethtool -m $iface raw on > foo.bin for each module.

so if you can do that for me, then I can see whether it's likely that
the patches that are already in mainline will do anything to solve
the workaround you've had to add for the hw signals.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
