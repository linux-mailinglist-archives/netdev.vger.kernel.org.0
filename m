Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658396B605D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCKUAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKUAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:00:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64AE6C8B4;
        Sat, 11 Mar 2023 12:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oxQBQ/iYwJaiqGFLxQQATPCED2i75wotjOsicLf0y90=; b=ZCpNkFBXTjLIGZ9M3z3A0YEb9z
        o7FRN8Szck+iHfgpI6OvW58wNFqtDntjUvt1RS44x9VxYs+7UKJeIMcnUyEKiK57n6KFSNlM+Q1Zl
        domKOWdmZwdF2EdXalsFBr+vrDYIpxnk33vH7VszEtGrIKTNcmQSINR06J11NKJUo5M9KaJvhRZy9
        D/lmZa7/pwaQv6sgB+uujicM0l8jpkLcNazWEovdVjY1WTx1bwOwz8gHGxHOMR/ngBjsO3rvMD4Rp
        R8urUWxpjRYekA2jPtDLAR91ta1dZ5lQHNl2j/Gs/NvkRCbeVgjyA1FAHk4vM1Ao+C2U8Tjq+pul7
        sJiCa9hQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52694)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pb5OI-0000M3-5Q; Sat, 11 Mar 2023 20:00:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pb5O8-0005yI-LM; Sat, 11 Mar 2023 20:00:20 +0000
Date:   Sat, 11 Mar 2023 20:00:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>,
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
Subject: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
References: <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk>
 <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk>
 <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 01:05:37PM +0100, Frank Wunderlich wrote:
> Hi
> 
> > Gesendet: Mittwoch, 08. März 2023 um 16:24 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > It would be nice to add these to my database - please send me the
> > > > output of ethtool -m $iface raw on > foo.bin for each module.
> > 
> > so if you can do that for me, then I can see whether it's likely that
> > the patches that are already in mainline will do anything to solve
> > the workaround you've had to add for the hw signals.
> 
> i got the 2.5G copper sfps, and tried them...they work well with the v12 (including this patch), but not in v13...
> 
> i dumped the eeprom like you mention for your database:
> 
> $ hexdump -C 2g5_sfp.bin 
> 00000000  03 04 07 00 01 00 00 00  00 02 00 05 19 00 00 00  |................|
> 00000010  1e 14 00 00 4f 45 4d 20  20 20 20 20 20 20 20 20  |....OEM         |
> 00000020  20 20 20 20 00 00 00 00  53 46 50 2d 32 2e 35 47  |    ....SFP-2.5G|
> 00000030  2d 54 20 20 20 20 20 20  31 2e 30 20 03 52 00 19  |-T      1.0 .R..|
> 00000040  00 1a 00 00 53 4b 32 33  30 31 31 31 30 30 30 38  |....SK2301110008|
> 00000050  20 20 20 20 32 33 30 31  31 30 20 20 68 f0 01 e8  |    230110  h...|
> 00000060  00 00 11 37 4f 7a dc ff  3d c0 6e 74 9b 7c 06 ca  |...7Oz..=.nt.|..|
> 00000070  e1 d0 f9 00 00 00 00 00  00 00 00 00 08 f0 fc 64  |...............d|
> 00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000100  5f 00 ce 00 5a 00 d3 00  8c a0 75 30 88 b8 79 18  |_...Z.....u0..y.|
> 00000110  1d 4c 01 f4 19 64 03 e8  4d f0 06 30 3d e8 06 f2  |.L...d..M..0=...|
> 00000120  2b d4 00 c7 27 10 00 df  00 00 00 00 00 00 00 00  |+...'...........|
> 00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000140  00 00 00 00 3f 80 00 00  00 00 00 00 01 00 00 00  |....?...........|
> 00000150  01 00 00 00 01 00 00 00  01 00 00 00 00 00 00 f1  |................|
> 00000160  29 1a 82 41 0b b8 13 88  0f a0 ff ff ff ff 80 ff  |)..A............|
> 00000170  00 00 ff ff 00 00 ff ff  04 ff ff ff ff ff ff 00  |................|
> 00000180  43 4e 53 38 54 55 54 41  41 43 33 30 2d 31 34 31  |CNS8TUTAAC30-141|
> 00000190  30 2d 30 34 56 30 34 20  49 fb 46 00 00 00 00 29  |0-04V04 I.F....)|
> 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 aa aa  |................|
> 000001c0  47 4c 43 2d 54 20 20 20  20 20 20 20 20 20 20 20  |GLC-T           |
> 000001d0  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 97  |               .|
> 000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000001f0  00 00 00 00 00 00 00 00  00 40 00 40 00 00 00 00  |.........@.@....|
> 
> how can we add a quirk to support this?

Why does it need a quirk?

> 
> some more information:
> 
> root@bpi-r3:~# ethtool eth1
> Settings for eth1:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   2500baseX/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  2500baseX/Full
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Speed: 2500Mb/s
>         Duplex: Full
>         Auto-negotiation: on
>         Port: FIBRE
>         PHYAD: 0
>         Transceiver: internal
>         Current message level: 0x000000ff (255)
>                                drv probe link timer ifdown ifup rx_err tx_err
>         Link detected: yes
> root@bpi-r3:~# ethtool -m eth1
>         Identifier                                : 0x03 (SFP)
>         Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
>         Connector                                 : 0x07 (LC)
>         Transceiver codes                         : 0x00 0x01 0x00 0x00 0x00 0x00 0x02 0x00 0x00
>         Transceiver type                          : SONET: OC-48, short reach
>         Encoding                                  : 0x05 (SONET Scrambled)
>         BR, Nominal                               : 2500MBd
>         Rate identifier                           : 0x00 (unspecified)
>         Length (SMF,km)                           : 0km
>         Length (SMF)                              : 0m
>         Length (50um)                             : 300m
>         Length (62.5um)                           : 200m
>         Length (Copper)                           : 0m
>         Length (OM3)                              : 0m
>         Laser wavelength                          : 850nm
>         Vendor name                               : OEM
>         Vendor OUI                                : 00:00:00
>         Vendor PN                                 : SFP-2.5G-T
>         Vendor rev                                : 1.0
>         Option values                             : 0x00 0x1a
>         Option                                    : RX_LOS implemented
>         Option                                    : TX_FAULT implemented
>         Option                                    : TX_DISABLE implemented
>         BR margin, max                            : 0%
>         BR margin, min                            : 0%
>         Vendor SN                                 : SK2301110008
>         Date code                                 : 230110
>         Optical diagnostics support               : Yes
>         Laser bias current                        : 6.000 mA
>         Laser output power                        : 0.5000 mW / -3.01 dBm
>         Receiver signal average optical power     : 0.4000 mW / -3.98 dBm
>         Module temperature                        : 28.21 degrees C / 82.78 degrees F
>         Module voltage                            : 3.3067 V
>         Alarm/warning flags implemented           : Yes
>         Laser bias current high alarm             : Off
>         Laser bias current low alarm              : Off
>         Laser bias current high warning           : Off
>         Laser bias current low warning            : Off
>         Laser output power high alarm             : Off
>         Laser output power low alarm              : Off
>         Laser output power high warning           : Off
>         Laser output power low warning            : Off
>         Module temperature high alarm             : Off
>         Module temperature low alarm              : Off
>         Module temperature high warning           : Off
>         Module temperature low warning            : Off
>         Module voltage high alarm                 : Off
>         Module voltage low alarm                  : Off
>         Module voltage high warning               : Off
>         Module voltage low warning                : Off
>         Laser rx power high alarm                 : Off
>         Laser rx power low alarm                  : Off
>         Laser rx power high warning               : Off
>         Laser rx power low warning                : Off
>         Laser bias current high alarm threshold   : 15.000 mA
>         Laser bias current low alarm threshold    : 1.000 mA
>         Laser bias current high warning threshold : 13.000 mA
>         Laser bias current low warning threshold  : 2.000 mA
>         Laser output power high alarm threshold   : 1.9952 mW / 3.00 dBm
>         Laser output power low alarm threshold    : 0.1584 mW / -8.00 dBm
>         Laser output power high warning threshold : 1.5848 mW / 2.00 dBm
>         Laser output power low warning threshold  : 0.1778 mW / -7.50 dBm
>         Module temperature high alarm threshold   : 95.00 degrees C / 203.00 degrees F
>         Module temperature low alarm threshold    : -50.00 degrees C / -58.00 degrees F
>         Module temperature high warning threshold : 90.00 degrees C / 194.00 degrees F
>         Module temperature low warning threshold  : -45.00 degrees C / -49.00 degrees F
>         Module voltage high alarm threshold       : 3.6000 V
>         Module voltage low alarm threshold        : 3.0000 V
>         Module voltage high warning threshold     : 3.5000 V
>         Module voltage low warning threshold      : 3.1000 V
>         Laser rx power high alarm threshold       : 1.1220 mW / 0.50 dBm
>         Laser rx power low alarm threshold        : 0.0199 mW / -17.01 dBm
>         Laser rx power high warning threshold     : 1.0000 mW / 0.00 dBm
>         Laser rx power low warning threshold      : 0.0223 mW / -16.52 dBm
> 
> i guess this sfp have a phy as it can operate in 100/1000/2500 mode like described on the module.

It would help to know the kernel messages.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
