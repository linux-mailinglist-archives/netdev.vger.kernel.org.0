Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE46AF3B1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbjCGTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjCGTHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:07:40 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972A3C2D82;
        Tue,  7 Mar 2023 10:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678215136; i=frank-w@public-files.de;
        bh=JTGTLkZ8OoT+RqpyAx1sW9UaQMm0R5ZBqK9JTQc9Wc4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=b+QmKzfHv8rGk0ljlZiia03mXcX9YPLoQBedOXDh8wOm8154pyHvOo9m8uzMhFpz7
         Vk5N2ZeRsp2inDmS91qBkw/E8thjZoKu87XjyKFfUXPG3sBQUXATK4Ubn26D5JSb5M
         Fhbx+fFOdwP+AI0DNWFsfzF9Z1wYqaVYY0EsDYgS8Td9JUCRUcBc3dmhaB2zowbeWo
         HIs0hQ6NDVytqY8aYp2TKnq0LpvywaY1w/bgvHmj8LfvJdpmGTKGUPWEOMsG1srNgY
         GACR2+YD1eFxpDY9VZeB6eoGAU5tBnEK4oFRVm3qrURSaj4Gye2Q8MlWbgS780hAnH
         ZavwqdiHoqGJA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.156.24] ([217.61.156.24]) by web-mail.gmx.net
 (3c-app-gmx-bs16.server.lan [172.19.170.68]) (via HTTP); Tue, 7 Mar 2023
 19:52:16 +0100
MIME-Version: 1.0
Message-ID: <trinity-d2a4c07d-5278-494f-9e10-fd366d539604-1678215136485@3c-app-gmx-bs16>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
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
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: [PATCH net-next v12 11/18] net: pcs: add driver for MediaTek
 SGMII PCS
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Mar 2023 19:52:16 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <05e6d08bba07ab2462178e51bbc146bdea508f46.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <05e6d08bba07ab2462178e51bbc146bdea508f46.1678201958.git.daniel@makrotopia.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:PwtmZC5NIT1sqzXVXjKmB8ju6BS93xlMNGejBocvc9T1IS+s8osXo7fjoDMrpnGZXcQoo
 ZVBjFJeCbQBsCFnEYKc2UUAem12eiW8c996KCKdD5m/bQWp+7FK6LqKt4pUTdgUZ1ReSdPsbUE/p
 lMegGXMXFmoMnKLPeoDdr1UNIE+hEni2F+952KY7spa10Mzvx9EgODLqOaM/8mt48rE934OOsppQ
 XObs3vkdgVRuw9bTJX4xnRPxqI1McLrZdm58yLIIxsD4zO6ErxEtKBwzfh44gIFUDCswevyup7EX
 4U=
UI-OutboundReport: notjunk:1;M01:P0:Am6NJr4guOY=;WJNN6VHGMn/i+3O1d7Gc5MoWki9
 C2foELMSUwRbHwq6Z8uu9Wtjh/WEEGXkL/K/cmEP016qneV/GdE2jAbweZOEXEFPeI/AZzKgU
 sbSHxFsEl812pBkRVk5UMyNa1YdPNMLXuwMqTVw/YHk5EpXrge3y4mlb5yMNfGvpGevk/3Gb3
 5nNfbEiqCGSVu4DbzJ8Pd6R6TRijCUDDk1l7PhBedLe+F6Z0A+b43YNQ2HuI2PkeIXyvqhc4o
 HEadAC2mJHymigjDuoVKhYeA/9nlqjvxclSQsLV2gFVEftCRuiN8lP97wetwwVFd1j9O6ADVw
 9LOuQGYwerWI9tZZfdiMUuOPH2Ab5U+2xTndjHOuyEbGLKcQhu95Q5h379ZKBK95//HuT7UhH
 Gl/jeL3HvpiDhPtcg6Tg/vPyyR4l4v20oyWMEE+6sMAXzGY0gEl2CJo/+jSriwN9BiZHPpahS
 Wc4dmDy8OJnFN7MwSAoymsgB4LrdRutC8tFNE4ULdwH2dlw9DuliJwCtHUdLdqH0Qw6ziDR6C
 Tb0461FmjASVUx4x1HraIIiuRzxTLkEY1dxgtt+RfU+hsi989fsZNvseN2qwh1XXPSczHRncw
 ABlDRl9iYvL3IZC+Cl0EFlAtQFKSwbEwGuXAeZqo7sDbfVs0H+jz9cPTulZjNrAFyw99uofz3
 yAC0k1TmL+iz/DhXZHqp18cIc7pKhTA4o7YioGlRstCHGpjkBiPUWmWGR9nEMXL08ejg6hkHJ
 CKlCOZtsczSeVbfmHCEAqGep30mGAgXXV9e7REN7Wa5d5kmMbzq5CNno36BR+RHLDJ+NTmsvz
 RzH090yGyZRlOCzUOl6bA0mQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 07=2E M=C3=A4rz 2023 um 16:54 Uhr
> Von: "Daniel Golle" <daniel@makrotopia=2Eorg>
> The SGMII core found in several MediaTek SoCs is identical to what can
> also be found in MediaTek's MT7531 Ethernet switch IC=2E
> As this has not always been clear, both drivers developed different
> implementations to deal with the PCS=2E
> Recently Alexander Couzens pointed out this fact which lead to the
> development of this shared driver=2E
>=20
> Add a dedicated driver, mostly by copying the code now found in the
> Ethernet driver=2E The now redundant code will be removed by a follow-up
> commit=2E
Hi,

have tested Parts 1-12 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no =
2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Thx Daniel for working on SFP support :)

regards Frank
