Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9216B5C3C
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 14:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCKN07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 08:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCKN06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 08:26:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8A22E811;
        Sat, 11 Mar 2023 05:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678541173; i=frank-w@public-files.de;
        bh=GfeQcxRSDpppXTDqkLkRWUUGIORt/Rl/w0tLl2RwRTA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ae08vDRWb80wha93sFdiJMy3/QIbwfUF+ekqSCnaNV1LxdycZRhFaDJDGpm8SSFYw
         C/zYi3KXM7Yb/EzT8FtNDthQDkUbF/8QhZOdorQD2xxB7qfNeybFkeDbsxFNvUsVHL
         PK0h4f5iBbjMWwEZH8JsjtJZ07scSCzKATNFbpyROTPsfXu1yx8bqZQ23wa7jjrxlO
         8hsu5gufaHVOg34VdCLfukl5j4O6GllgSvkx8cgVjM0C68MbUk67e5Efh7XUULRtjN
         eYQ5DAH20dF8DS0B9z9bVokWcbbE61lhzak/7VpDoJIC926sfySZT3TnLcf7DZhX7b
         WYS5N6yMIZHsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.145.102] ([217.61.145.102]) by web-mail.gmx.net
 (3c-app-gmx-bs24.server.lan [172.19.170.76]) (via HTTP); Sat, 11 Mar 2023
 14:26:13 +0100
MIME-Version: 1.0
Message-ID: <trinity-a69cee2e-40c5-44b5-ac97-2cb35e1d2462-1678541173568@3c-app-gmx-bs24>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
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
Date:   Sat, 11 Mar 2023 14:26:13 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
References: <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org> <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org> <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
 <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
 <ZAiXvNT8EzHTmFPh@shell.armlinux.org.uk> <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Kc9ICzOu44s7goFfLFJZBh4sqSSCR1bEfXKU7KvNxd77I2rLqHXiBFWDWZN3pbuKsIkgT
 DofQ0atkdFF8Y7ZKoLmNkHSSSiRbD7cDES7e8UNmlDYEQBVF2FWtSNHecREYN/L0BIOtnzX2lz5m
 obU3ef80MykfQInKVPlCwTrhNOM1xzz+vAJT5PfzdI0PLJkENnBu81RaL5oFvZNMJTCfcMbALvdG
 aRlXCAfSO4045k3h0/frCPRcqy/OIq1NJljKdCTFHbNkGzbuki5zIHDDgeg9zOoM9iSUBs8ulVXo
 xw=
UI-OutboundReport: notjunk:1;M01:P0:WiHonH9Jyio=;7g0BzW/QdsYNqmUymabayQvJuKm
 qd8ALyczwuHBUQpeUdEWAokm/AFyf2qYyjUMa0PQs2VEpUQ9IGDLK0WRaXLcPXlkXnBBKOmdJ
 eO88rQao6bi7JIaLIhtNrR2icz8W/IYd7mIO5ow88Fvu4zAWgeBr8Ir5iC3jsQyx051hMdkI9
 3NoX6CpXDlPR77OalVpvmULMfQKC5WZPrRuiYZxp7B0X0eiuqp73go9DQIq7/RVgYqwduQX9R
 5ucydcQx0sE2g/wX5gnBAYT0AYgvMk6NRpVthwPiwHqVZp2mrqHftvac1so+VK6uv5LwGNo8g
 uNOTU6LhrjjK2oEmQov46yQikFTm1xFrcNQ/9MtjLgTw6E+34MS6f0Db2GdH9eXFW2l1fwW2l
 4/wDiPgLo8xwcU3depNi9vSV1eFGqZkqaS9O5r9aWUDcR4nQPqvp6lF4x5GDno8/QzMv+LjHt
 77264bUTkyuFIX8OJYGIZCTc0/mhiHgIZGlqeIlcntxw5zlgOEUHK6TFMbnqpq8T5Q2o6VIne
 FFRzN23WVzW7URkJop8YWAej+tXjGPxltXJPJgpUYQQSPKwsOWYHSi8rYK115xyoWJkSNw/pl
 8TC+jz7zCNa0fBLV57eSX4QnfgXebcYCaXF8WPfKiL3KwkUnTDctXwrkULybn5Gtx0gffmdX+
 JrzYtCythuhBGjFeMTeWdLPuJ/Fnkpz0hXyepoodMJ8emzmJzudTJTEP94NIvyq6PtnzTjcD5
 dkv0llk7qcmuFtIVVWBtkJrfiXgk+z6fvNOEFV3Rl1v2UqUqPTlz2AvV8yiZOMqhF2B22Zfp2
 XGoaxYKeSpGY63pxScycIc0ivK+aYSunlrQ9ny6bvx3DY=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 11=2E M=C3=A4rz 2023 um 13:05 Uhr
> Von: "Frank Wunderlich" <frank-w@public-files=2Ede>
> > Gesendet: Mittwoch, 08=2E M=C3=A4rz 2023 um 16:24 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> > > > It would be nice to add these to my database - please send me the
> > > > output of ethtool -m $iface raw on > foo=2Ebin for each module=2E
> >=20
> > so if you can do that for me, then I can see whether it's likely that
> > the patches that are already in mainline will do anything to solve
> > the workaround you've had to add for the hw signals=2E
>=20
> i got the 2=2E5G copper sfps, and tried them=2E=2E=2Ethey work well with=
 the v12 (including this patch), but not in v13=2E=2E=2E
>=20
> i dumped the eeprom like you mention for your database:
>=20
> $ hexdump -C 2g5_sfp=2Ebin=20
> 00000000  03 04 07 00 01 00 00 00  00 02 00 05 19 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000010  1e 14 00 00 4f 45 4d 20  20 20 20 20 20 20 20 20  |=2E=2E=2E=
=2EOEM         |
> 00000020  20 20 20 20 00 00 00 00  53 46 50 2d 32 2e 35 47  |    =2E=2E=
=2E=2ESFP-2=2E5G|
> 00000030  2d 54 20 20 20 20 20 20  31 2e 30 20 03 52 00 19  |-T      1=
=2E0 =2ER=2E=2E|
> 00000040  00 1a 00 00 53 4b 32 33  30 31 31 31 30 30 30 38  |=2E=2E=2E=
=2ESK2301110008|
> 00000050  20 20 20 20 32 33 30 31  31 30 20 20 68 f0 01 e8  |    230110 =
 h=2E=2E=2E|
> 00000060  00 00 11 37 4f 7a dc ff  3d c0 6e 74 9b 7c 06 ca  |=2E=2E=2E7O=
z=2E=2E=3D=2Ent=2E|=2E=2E|
> 00000070  e1 d0 f9 00 00 00 00 00  00 00 00 00 08 f0 fc 64  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2Ed|
> 00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> *
> 00000100  5f 00 ce 00 5a 00 d3 00  8c a0 75 30 88 b8 79 18  |_=2E=2E=2EZ=
=2E=2E=2E=2E=2Eu0=2E=2Ey=2E|
> 00000110  1d 4c 01 f4 19 64 03 e8  4d f0 06 30 3d e8 06 f2  |=2EL=2E=2E=
=2Ed=2E=2EM=2E=2E0=3D=2E=2E=2E|
> 00000120  2b d4 00 c7 27 10 00 df  00 00 00 00 00 00 00 00  |+=2E=2E=2E'=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000140  00 00 00 00 3f 80 00 00  00 00 00 00 01 00 00 00  |=2E=2E=2E=
=2E?=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000150  01 00 00 00 01 00 00 00  01 00 00 00 00 00 00 f1  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000160  29 1a 82 41 0b b8 13 88  0f a0 ff ff ff ff 80 ff  |)=2E=2EA=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000170  00 00 ff ff 00 00 ff ff  04 ff ff ff ff ff ff 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 00000180  43 4e 53 38 54 55 54 41  41 43 33 30 2d 31 34 31  |CNS8TUTAAC3=
0-141|
> 00000190  30 2d 30 34 56 30 34 20  49 fb 46 00 00 00 00 29  |0-04V04 I=
=2EF=2E=2E=2E=2E)|
> 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 aa aa  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 000001c0  47 4c 43 2d 54 20 20 20  20 20 20 20 20 20 20 20  |GLC-T      =
     |
> 000001d0  20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 97  |           =
    =2E|
> 000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E|
> 000001f0  00 00 00 00 00 00 00 00  00 40 00 40 00 00 00 00  |=2E=2E=2E=
=2E=2E=2E=2E=2E=2E@=2E@=2E=2E=2E=2E|
>=20
> how can we add a quirk to support this?

tried to add the quirk like this onto v13

--- a/drivers/net/phy/sfp=2Ec
+++ b/drivers/net/phy/sfp=2Ec
@@ -403,6 +403,8 @@ static const struct sfp_quirk sfp_quirks[] =3D {
        SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
        SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
        SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
+
+       SFP_QUIRK_M("OEM", "SFP-2=2E5G-T", sfp_quirk_2500basex),
 };

but still no link=2E=2E=2E

how can i verify the quirk was applied? see only this in dmesg:

[    2=2E192274] sfp sfp-1: module OEM              SFP-2=2E5G-T       rev=
 1=2E0  sn SK2301110008     dc 230110 =20

also tried to force speed (module should support 100/1000/2500), but it se=
ems i can set speed option only on
gmac (eth1) and not on the sfp (phy)=2E

i guess between mac and sfp speed is always 2500base-X and after the phy (=
if there is any) the link speed is
maybe different=2E

regards Frank
