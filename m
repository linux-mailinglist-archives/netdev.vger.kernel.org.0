Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB06B80E4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCMSlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCMSlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:41:21 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099994EDF;
        Mon, 13 Mar 2023 11:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678732740; i=frank-w@public-files.de;
        bh=vnVRR7H0dRwp116/xX+I5PhqibcTnq0j1/I79a6rbt4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bAYgS+SOutp5qT7W189Mtkc/EoCKBYaYiOk7mJhTFnnWzQnI2BaBDc3xmC7xEjR55
         Oqgy98Xc4DvUC4wNHlnYoDuFEKlyhuftCu04f12kp/g5P4NOSrHNPkIBWIpPCXeO/w
         24I3jL7tx6CbdBu04xnzL9qyrmS+a2yquhN9XCty6iIB5E8wGhkZ1NYPG/eq97sFl+
         68xdKYZryviFvQ4MaAvrKAK3x1HNRwcVG8SaUnglbXtV2ldXuOym1LzHXY65ZrpB6l
         a71LWsYYIar84zB5/joWn9CiZ2TW7eS2OZhl5Qmn4dt4a771C17IUIjfKKlLfW6vWd
         kl0aLAL0suL1A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.158.159] ([217.61.158.159]) by web-mail.gmx.net
 (3c-app-gmx-bs66.server.lan [172.19.170.210]) (via HTTP); Mon, 13 Mar 2023
 19:39:00 +0100
MIME-Version: 1.0
Message-ID: <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
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
Subject: Aw: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet:
 mtk_eth_soc: fix 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 13 Mar 2023 19:39:00 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
References: <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk> <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:F36nI6lCjaGvE9iW/olT5af3T1lus8s5NdMk0i96PzDNje8Vgi1yT25FZOFvH+go4cfu8
 YF62npVZCcSjOJ13eNpaTbRKX3znmrvyt0mqt4/MNYM9b0KhSLgyhOwmIZhZmZ9epDly86fXGEqq
 XKnvQWEubkZhGuY33qIcJSsLMb19ufLMD+ZxxazCKVZkAMpUCW2nYR6yJKUlCzlD1lzJuhJjZquy
 97SP44YGQ9o0fYSgebLfZoWAN6YaEayFRJFdQ4JRhq+IHExjdFa6PYn1LlLdyorC908iZ73wivem
 Bs=
UI-OutboundReport: notjunk:1;M01:P0:A3Bhvf3YgSA=;DYQ3ENw4UTM7sRf0hpJwY5A5OQ6
 U71Dm0loE5cbRcAVkWmRiLqeImB56sd3lV0XbRk+El2+yb8MCcznUrZaPN7eSa2jD+enh12Kx
 eQv9w4r7TSedZw5NOI5QC8E9Tvhkc+RVvy12JVtknPdR7VqTR2lVZE/QnqwBViym5XiYEIZJx
 ei+wB43UaImFCUAliSsArVDSJU2CxsIWPhuFVXnYsaVkxSeHuwvSRbAqUJQtwO4oSfZFhL6+r
 3//nmLzSe+tOCY8377SUPRTX+dcVFveo1g+RWLLAnsRjsGVxfzjURTWfSNq8ibRC6if33tCw5
 fUSlsIOhHS98X5R/eUnBzMJkHQiXKva8g3XLNISQQWNiBfC82m9VZvyTFPiO2BxnEeJRHJPI0
 E+m5K+h0a445r9k2ozN/llRggXrZbA3TraY1EbWbqOYLp5P7T9ipjcndX8xMooye8w1VtOmgG
 jgf6KynlEyYXJl9WvlfHpqsj0HtweQV7wILLoawvdQHLRqB+Mk8yOggKPBMrecaK+smnSa4UU
 fQKpJRRHccWf9qaykgWsD1As18vUl9krRuLefH9VxKZZVt1fHgELxlF5oHRhzaKBuOEXzPTka
 G7QTGsETK3ziOUJwEzHVCk8Kb4Q5chZTNCm6YH/LE1v2Wjc6BPkut94nQMADSwsIi07ywq0eU
 rTDLiIGYwKFG6dAe4x3DGzGgEfsR/SJOmITMr5xd+Bd6rY9G6tZvoA/fds4vPVgB1aT1GDiZr
 hkwPKRlwOHOJODPAkJ3ziACrxxGtJmh37NymUdCid84MwRKLOJS2UgZXuC+PuNTB4wO+kCx4A
 2yUIjwRzH4WUmfD+UwG96AUrk5Vlpso1drid14mPw0qfg=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Montag, 13=2E M=C3=A4rz 2023 um 11:59 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>

> Since describing what I wanted you to test didn't work, here's a patch
> instead, based upon the quirk that you provided (which is what I'd have
> written anyway)=2E Add a "#define DEBUG" to the top of
> drivers/net/phy/phylink=2Ec in addition to applying this patch, and plea=
se
> test the resulting kernel, sending me the resulting kernel messages, and
> also reporting whether this works or not=2E

Hi

thx for the patch=2E=2E=2Esorry for misunderstanding=2E i thought the sfp =
quirk only sets a flag and i need to change
something in phylink=2Ec to do the same as done on userspace, so i tried t=
o simulate the userspace call there only for testing=2E

here relevant parts of debug

[    1=2E990637] sfp sfp-1: module OEM              SFP-2=2E5G-T       rev=
 1=2E0  sn SK2301110008     dc 230110 =20
[    2=2E000147] mtk_soc_eth 15100000=2Eethernet eth1: optical SFP: interf=
aces=3D[mac=3D2-4,21-22, sfp=3D]

[   56=2E321102] mtk_soc_eth 15100000=2Eethernet eth1: configuring for inb=
and/2500base-x link mode
[   56=2E329543] mtk_soc_eth 15100000=2Eethernet eth1: major config 2500ba=
se-x
[   56=2E336144] mtk_soc_eth 15100000=2Eethernet eth1: phylink_mac_config:=
 mode=3Dinband/2500base-x/Unknown/Unknown/none adv=3D00,00000000,00000000,0=
000e240 pause=3D04 link=3D0 an=3D1

full log here:

https://pastebin=2Ecom/vaXtXFY8

unfortunately this does not bring link up

root@bpi-r3:~# ethtool eth1
Settings for eth1:
        Supported ports: [ MII ]
        Supported link modes:   2500baseX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  2500baseX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_=
err
        Link detected: no

also after calling this link does not came up

root@bpi-r3:~# ethtool -s eth1 autoneg off
[  542=2E690293] mtk_soc_eth 15100000=2Eethernet eth1: phylink_change_inba=
nd_advert: mode=3Dinband/2500base-x adv=3D00,00000000,00000000,0000e200 pau=
se=3D04

so it looks like it needs to be configured first in inband mode and then a=
utoneg needs to be disabled=2E

regards Frank

