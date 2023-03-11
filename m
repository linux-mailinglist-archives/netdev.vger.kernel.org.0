Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D586B5B6E
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCKMG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 07:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCKMGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 07:06:25 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED51711F2F6;
        Sat, 11 Mar 2023 04:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678536337; i=frank-w@public-files.de;
        bh=y8NpMr5h/BZSeae8G0615RwCHg/Yf9kPUQfWwMLpyRU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nN7AJl2A84IYpQzDVqZm1MoPYUTkcJ3KKXTXwX7Hp7FuAiqDL/Wb3wp4PuxDsY2FL
         rkGmXdJUgRiOPS7iVS01ddzZUZBybEp0vYba8F4XwOxKJ2KO8N6JorlAa+T6ylkNRS
         cxfTg2vw09K95h4YUK+wWElrFya/V+MUTel3PJlV9vwravzfcbnmYva2ehyOzjun3t
         Hz7YKCi0p8JUcRbG565VroZIoI7s7JKOgHbqkcOVzQeeJSvaOuLITwKAb/1PY6ttXz
         5ddwBuy0EGlZ62FYgXlUZPM5mmCZ82RUH8Wk+/eSd20q3G44pT0EZBvsvpVpfu1xe+
         LGr5Gx2DgkrtQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.145.102] ([217.61.145.102]) by web-mail.gmx.net
 (3c-app-gmx-bs24.server.lan [172.19.170.76]) (via HTTP); Sat, 11 Mar 2023
 13:05:37 +0100
MIME-Version: 1.0
Message-ID: <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 11 Mar 2023 13:05:37 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZAioqp21521NsttV@shell.armlinux.org.uk>
References: <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org> <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org> <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk> <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:XZMJbNckEni/wVN/5y7f8ksObJ8a+W4WxiH41S/GBI19BcJRyTYWDu5YyvtIm2OJG7XKe
 RFOJ8RFs2sOnhtroJHFD+eLWJH8YrrvNEUyx3obdFcL/AfJTLZyFaklC8GYyEuzLMzPtTYiG5k24
 ThVNeurzFq7zM8CmglB+KYk1UmDXNUuZo1LmkoX2i9KbirUHks7THE7GmoGH4+YuQuVYqhqezvHy
 erukC+m8McT7w5x48+WKh0SSbIJrORotWMHcBCuknz/MfIhgLhl3OOT5wjZURRkVfFrm2lftIRxe
 Is=
UI-OutboundReport: notjunk:1;M01:P0:zO3BmWW+Yv0=;1tfqWJpmKmygc/JJhORnDDZAiNO
 HtmpF3Hf+EvsEg6TdzKsRXt0Kz46ERD98yW7gFDAUZDWcADh9fLjMfF3rz6FXOO8GB0riq39l
 UZPP7T3DH1Zgj58N7jIONZaOOcvwf+50wSHjv93fk0GPC8iaQ3oqtSWjyRQLUKIVRxUYkKQq7
 N/MZK8g6RysAjsEpfOm5Jeu9U9ly2eTRQU56OV/3NGeTNltwEU4jP8d2dD8d7e73Hzt7Nw+FW
 T2zI/E+id6kjwsxgJvoEh1Kzid8JRv0qu3Yb68ls+/iIycqieKbgWktDkn+/0k1negU4wuQiW
 lbGjTJ2VLa5slVYVhHlhBcFT5VMvYwWq/gSiHP0mUu02omwdfjG8+J54K/vBynUPRzKmok2PB
 zgwRFFDvSYazfheDx3sbNq4wLbS01QwBguKxMeM3x6LLdmYfYd1lFEk2PaGVujNnxziygA8kA
 YHpScgSWO8uOZ33oNNEbq24ni5eIaiBcHbydz9vYH+bXKV2Vcg6f219QNNV4WvNRx1XZPAfrQ
 xEfLF2NeNto9dFuBnWBH6HdzwA3XrTAMUd++srXV/ZopCbRmPTNcqwTJrJx5bczUf03d6li7h
 vOwlc6dgRUB9tbc4jI92t2sagl0a8zn0JYvcrmiygCTO5k5igx++1Zu3FKg3jFfjK4dL1rgUW
 /NF7eybDS8r9J91ckFTY0run9qlGxUp7F4GfGs+2MtGhjtXkXPBAxznY9M83Qtj88InlftQDk
 voVoGONmvZ9fXETj/ZsNFaApFM0s6c8ALBNbURtoNHRWcB0wsmhL7NJ8Jg3uLBPKXbNGWmhkp
 GQvc4Rjl5VOW5X8MHBt8RfCw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Mittwoch, 08=2E M=C3=A4rz 2023 um 16:24 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> > > It would be nice to add these to my database - please send me the
> > > output of ethtool -m $iface raw on > foo=2Ebin for each module=2E
>=20
> so if you can do that for me, then I can see whether it's likely that
> the patches that are already in mainline will do anything to solve
> the workaround you've had to add for the hw signals=2E

i got the 2=2E5G copper sfps, and tried them=2E=2E=2Ethey work well with t=
he v12 (including this patch), but not in v13=2E=2E=2E

i dumped the eeprom like you mention for your database:

$ hexdump -C 2g5_sfp=2Ebin=20
00000000  03 04 07 00 01 00 00 00  00 02 00 05 19 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000010  1e 14 00 00 4f 45 4d 20  20 20 20 20 20 20 20 20  |=2E=2E=2E=2EO=
EM         |
00000020  20 20 20 20 00 00 00 00  53 46 50 2d 32 2e 35 47  |    =2E=2E=2E=
=2ESFP-2=2E5G|
00000030  2d 54 20 20 20 20 20 20  31 2e 30 20 03 52 00 19  |-T      1=2E0=
 =2ER=2E=2E|
00000040  00 1a 00 00 53 4b 32 33  30 31 31 31 30 30 30 38  |=2E=2E=2E=2ES=
K2301110008|
00000050  20 20 20 20 32 33 30 31  31 30 20 20 68 f0 01 e8  |    230110  h=
=2E=2E=2E|
00000060  00 00 11 37 4f 7a dc ff  3d c0 6e 74 9b 7c 06 ca  |=2E=2E=2E7Oz=
=2E=2E=3D=2Ent=2E|=2E=2E|
00000070  e1 d0 f9 00 00 00 00 00  00 00 00 00 08 f0 fc 64  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2Ed|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
*
00000100  5f 00 ce 00 5a 00 d3 00  8c a0 75 30 88 b8 79 18  |_=2E=2E=2EZ=
=2E=2E=2E=2E=2Eu0=2E=2Ey=2E|
00000110  1d 4c 01 f4 19 64 03 e8  4d f0 06 30 3d e8 06 f2  |=2EL=2E=2E=2E=
d=2E=2EM=2E=2E0=3D=2E=2E=2E|
00000120  2b d4 00 c7 27 10 00 df  00 00 00 00 00 00 00 00  |+=2E=2E=2E'=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000140  00 00 00 00 3f 80 00 00  00 00 00 00 01 00 00 00  |=2E=2E=2E=2E?=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000150  01 00 00 00 01 00 00 00  01 00 00 00 00 00 00 f1  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000160  29 1a 82 41 0b b8 13 88  0f a0 ff ff ff ff 80 ff  |)=2E=2EA=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000170  00 00 ff ff 00 00 ff ff  04 ff ff ff ff ff ff 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
00000180  43 4e 53 38 54 55 54 41  41 43 33 30 2d 31 34 31  |CNS8TUTAAC30-=
141|
00000190  30 2d 30 34 56 30 34 20  49 fb 46 00 00 00 00 29  |0-04V04 I=2EF=
=2E=2E=2E=2E)|
000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 aa aa  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
000001c0  47 4c 43 2d 54 20 20 20  20 20 20 20 20 20 20 20  |GLC-T        =
   |
000001d0  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 97  |             =
  =2E|
000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
000001f0  00 00 00 00 00 00 00 00  00 40 00 40 00 00 00 00  |=2E=2E=2E=2E=
=2E=2E=2E=2E=2E@=2E@=2E=2E=2E=2E|

how can we add a quirk to support this?

some more information:

root@bpi-r3:~# ethtool eth1
Settings for eth1:
        Supported ports: [ FIBRE ]
        Supported link modes:   2500baseX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  2500baseX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 2500Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: yes
root@bpi-r3:~# ethtool -m eth1
        Identifier                                : 0x03 (SFP)
        Extended identifier                       : 0x04 (GBIC/SFP defined=
 by 2-wire interface ID)
        Connector                                 : 0x07 (LC)
        Transceiver codes                         : 0x00 0x01 0x00 0x00 0x=
00 0x00 0x02 0x00 0x00
        Transceiver type                          : SONET: OC-48, short re=
ach
        Encoding                                  : 0x05 (SONET Scrambled)
        BR, Nominal                               : 2500MBd
        Rate identifier                           : 0x00 (unspecified)
        Length (SMF,km)                           : 0km
        Length (SMF)                              : 0m
        Length (50um)                             : 300m
        Length (62=2E5um)                           : 200m
        Length (Copper)                           : 0m
        Length (OM3)                              : 0m
        Laser wavelength                          : 850nm
        Vendor name                               : OEM
        Vendor OUI                                : 00:00:00
        Vendor PN                                 : SFP-2=2E5G-T
        Vendor rev                                : 1=2E0
        Option values                             : 0x00 0x1a
        Option                                    : RX_LOS implemented
        Option                                    : TX_FAULT implemented
        Option                                    : TX_DISABLE implemented
        BR margin, max                            : 0%
        BR margin, min                            : 0%
        Vendor SN                                 : SK2301110008
        Date code                                 : 230110
        Optical diagnostics support               : Yes
        Laser bias current                        : 6=2E000 mA
        Laser output power                        : 0=2E5000 mW / -3=2E01 =
dBm
        Receiver signal average optical power     : 0=2E4000 mW / -3=2E98 =
dBm
        Module temperature                        : 28=2E21 degrees C / 82=
=2E78 degrees F
        Module voltage                            : 3=2E3067 V
        Alarm/warning flags implemented           : Yes
        Laser bias current high alarm             : Off
        Laser bias current low alarm              : Off
        Laser bias current high warning           : Off
        Laser bias current low warning            : Off
        Laser output power high alarm             : Off
        Laser output power low alarm              : Off
        Laser output power high warning           : Off
        Laser output power low warning            : Off
        Module temperature high alarm             : Off
        Module temperature low alarm              : Off
        Module temperature high warning           : Off
        Module temperature low warning            : Off
        Module voltage high alarm                 : Off
        Module voltage low alarm                  : Off
        Module voltage high warning               : Off
        Module voltage low warning                : Off
        Laser rx power high alarm                 : Off
        Laser rx power low alarm                  : Off
        Laser rx power high warning               : Off
        Laser rx power low warning                : Off
        Laser bias current high alarm threshold   : 15=2E000 mA
        Laser bias current low alarm threshold    : 1=2E000 mA
        Laser bias current high warning threshold : 13=2E000 mA
        Laser bias current low warning threshold  : 2=2E000 mA
        Laser output power high alarm threshold   : 1=2E9952 mW / 3=2E00 d=
Bm
        Laser output power low alarm threshold    : 0=2E1584 mW / -8=2E00 =
dBm
        Laser output power high warning threshold : 1=2E5848 mW / 2=2E00 d=
Bm
        Laser output power low warning threshold  : 0=2E1778 mW / -7=2E50 =
dBm
        Module temperature high alarm threshold   : 95=2E00 degrees C / 20=
3=2E00 degrees F
        Module temperature low alarm threshold    : -50=2E00 degrees C / -=
58=2E00 degrees F
        Module temperature high warning threshold : 90=2E00 degrees C / 19=
4=2E00 degrees F
        Module temperature low warning threshold  : -45=2E00 degrees C / -=
49=2E00 degrees F
        Module voltage high alarm threshold       : 3=2E6000 V
        Module voltage low alarm threshold        : 3=2E0000 V
        Module voltage high warning threshold     : 3=2E5000 V
        Module voltage low warning threshold      : 3=2E1000 V
        Laser rx power high alarm threshold       : 1=2E1220 mW / 0=2E50 d=
Bm
        Laser rx power low alarm threshold        : 0=2E0199 mW / -17=2E01=
 dBm
        Laser rx power high warning threshold     : 1=2E0000 mW / 0=2E00 d=
Bm
        Laser rx power low warning threshold      : 0=2E0223 mW / -16=2E52=
 dBm

i guess this sfp have a phy as it can operate in 100/1000/2500 mode like d=
escribed on the module=2E

but only tested in 2500base-T mode only=2E

regards Frank
