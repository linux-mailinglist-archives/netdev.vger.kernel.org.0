Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B121B6B5D04
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCKOvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCKOvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:51:50 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B11F4EF3;
        Sat, 11 Mar 2023 06:51:48 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pb0ZG-0000dl-0v;
        Sat, 11 Mar 2023 15:51:30 +0100
Date:   Sat, 11 Mar 2023 14:51:27 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: Aw: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc:
 fix 1000Base-X and 2500Base-X modes
Message-ID: <ZAyVbzuKq2haFfQa@makrotopia.org>
References: <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
 <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk>
 <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <trinity-a69cee2e-40c5-44b5-ac97-2cb35e1d2462-1678541173568@3c-app-gmx-bs24>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-a69cee2e-40c5-44b5-ac97-2cb35e1d2462-1678541173568@3c-app-gmx-bs24>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 02:26:13PM +0100, Frank Wunderlich wrote:
> > Gesendet: Samstag, 11. März 2023 um 13:05 Uhr
> > Von: "Frank Wunderlich" <frank-w@public-files.de>
> > > Gesendet: Mittwoch, 08. März 2023 um 16:24 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > It would be nice to add these to my database - please send me the
> > > > > output of ethtool -m $iface raw on > foo.bin for each module.
> > > 
> > > so if you can do that for me, then I can see whether it's likely that
> > > the patches that are already in mainline will do anything to solve
> > > the workaround you've had to add for the hw signals.
> > 
> > i got the 2.5G copper sfps, and tried them...they work well with the v12 (including this patch), but not in v13...
> > 
> > i dumped the eeprom like you mention for your database:
> > 
> > $ hexdump -C 2g5_sfp.bin 
> > 00000000  03 04 07 00 01 00 00 00  00 02 00 05 19 00 00 00  |................|
> > 00000010  1e 14 00 00 4f 45 4d 20  20 20 20 20 20 20 20 20  |....OEM         |
> > 00000020  20 20 20 20 00 00 00 00  53 46 50 2d 32 2e 35 47  |    ....SFP-2.5G|
> > 00000030  2d 54 20 20 20 20 20 20  31 2e 30 20 03 52 00 19  |-T      1.0 .R..|
> > 00000040  00 1a 00 00 53 4b 32 33  30 31 31 31 30 30 30 38  |....SK2301110008|
> > 00000050  20 20 20 20 32 33 30 31  31 30 20 20 68 f0 01 e8  |    230110  h...|
> > 00000060  00 00 11 37 4f 7a dc ff  3d c0 6e 74 9b 7c 06 ca  |...7Oz..=.nt.|..|
> > 00000070  e1 d0 f9 00 00 00 00 00  00 00 00 00 08 f0 fc 64  |...............d|
> > 00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000100  5f 00 ce 00 5a 00 d3 00  8c a0 75 30 88 b8 79 18  |_...Z.....u0..y.|
> > 00000110  1d 4c 01 f4 19 64 03 e8  4d f0 06 30 3d e8 06 f2  |.L...d..M..0=...|
> > 00000120  2b d4 00 c7 27 10 00 df  00 00 00 00 00 00 00 00  |+...'...........|
> > 00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 00000140  00 00 00 00 3f 80 00 00  00 00 00 00 01 00 00 00  |....?...........|
> > 00000150  01 00 00 00 01 00 00 00  01 00 00 00 00 00 00 f1  |................|
> > 00000160  29 1a 82 41 0b b8 13 88  0f a0 ff ff ff ff 80 ff  |)..A............|
> > 00000170  00 00 ff ff 00 00 ff ff  04 ff ff ff ff ff ff 00  |................|
> > 00000180  43 4e 53 38 54 55 54 41  41 43 33 30 2d 31 34 31  |CNS8TUTAAC30-141|
> > 00000190  30 2d 30 34 56 30 34 20  49 fb 46 00 00 00 00 29  |0-04V04 I.F....)|
> > 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 aa aa  |................|
> > 000001c0  47 4c 43 2d 54 20 20 20  20 20 20 20 20 20 20 20  |GLC-T           |
> > 000001d0  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 97  |               .|
> > 000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000001f0  00 00 00 00 00 00 00 00  00 40 00 40 00 00 00 00  |.........@.@....|
> > 
> > how can we add a quirk to support this?
> 
> tried to add the quirk like this onto v13
> 
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -403,6 +403,8 @@ static const struct sfp_quirk sfp_quirks[] = {
>         SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
>         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
>         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
> +
> +       SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_2500basex),
>  };
> 
> but still no link...
> 
> how can i verify the quirk was applied? see only this in dmesg:
> 
> [    2.192274] sfp sfp-1: module OEM              SFP-2.5G-T       rev 1.0  sn SK2301110008     dc 230110  
> 
> also tried to force speed (module should support 100/1000/2500), but it seems i can set speed option only on
> gmac (eth1) and not on the sfp (phy).
> 
> i guess between mac and sfp speed is always 2500base-X and after the phy (if there is any) the link speed is
> maybe different.

As discussed in the previous iteration of the series where I suggested to
add work-arounds disabling in-band AN for 1000Base-X and 2500Base-X having
those will also affect fiber transceivers which transparently pass-through
the electrical SerDes signal into light. Russell explained it very well
and I now agree that a good solution would be to add a new SFP quirk
indicating that a SFP module got a "hidden" PHY which doesn't like in-band
autonegotiation.

tl;dr What you are seeing is the expected behavior.
Try 'ethtool -s eth1 autoneg off', and the link should come up.


Cheers


Daniel


> 
> regards Frank
> 
