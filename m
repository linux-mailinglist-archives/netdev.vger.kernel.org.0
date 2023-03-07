Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F069A6AF390
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjCGTGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbjCGTGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:06:10 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA90C082B;
        Tue,  7 Mar 2023 10:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678215040; i=frank-w@public-files.de;
        bh=nWexxL308BH6z9moewgL9uYihCpYFK54dVeZ2PBn3f8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tIoGoyJqs2OkjReYZUq7R4DzCHsQfWQztFQt0KYgB3j4czOZiXbqyOTrzPbm6KFVZ
         liwK94XYdcyqvarEYpALo+sYdLpNoDD9pVUn+Dh2f/9ygzrIXfdxNkH/lIy/5puhO9
         2PJg2Bme9jBtXursaPmy8+5WeNnFNQPmT4C4sWL0ARLoOegq85fkCjDQ79meY4TSrq
         HI+AL1OH3onxeqhHLrlfXUHOp2T/BpEUbuXY35JZhegNDwMbdjuzSq93wfFtFP1/+b
         9L+vkQmVV3sgFqOxjxVubm0L4dOE6IilYta8ILPWjY1ohwOWSj5Bx/NsbHGkQ6gRL0
         mh9l3rfxnbiYg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.156.24] ([217.61.156.24]) by web-mail.gmx.net
 (3c-app-gmx-bs16.server.lan [172.19.170.68]) (via HTTP); Tue, 7 Mar 2023
 19:50:40 +0100
MIME-Version: 1.0
Message-ID: <trinity-19cb78f9-24ee-4cab-a24d-5c431d154e43-1678215039980@3c-app-gmx-bs16>
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
Subject: Aw: [PATCH net-next v12 09/18] net: ethernet: mtk_eth_soc: Fix link
 status for none-SGMII modes
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Mar 2023 19:50:40 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <1590fb0e69f6243ac6a961b16bf7ae7534f46949.1678201958.git.daniel@makrotopia.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:76gtEPPKbw3oW5Vh9Br7sY/0upYihofaodLeF5Poo1oqibixMOcL2y0Fehhg3y1CanIwj
 i5ak/DrOGWMtDkAYTL930BJHMzxlrPSD2RbFOg1hZRZSQNQhey/uFIOTm3zkeR1tT5latxzmDT+R
 ornMPbIXSbhTma8tYRTXgrgq9yEciDBGKHnfKhUD4rF9mztF2FgFZj88rHLE0511TZGh4Q3XxDfh
 +RLVZaxpaN91URF6IUIDZ9pozauNCiX0MQ/ER24URfXEoXWLDYpb024n4rMKi5LvTM/hpuX4DO1B
 AI=
UI-OutboundReport: notjunk:1;M01:P0:oYTl1d60MWg=;C4x3bNHaagBMTR7qFsMFz764oFC
 jJLFXAfjjvaBoce70TTO7nh0M+WdDbscQzSasa9/SVoIR72+oR2P1GgL50WxyPdJv7GW3jgSE
 E0BDP8nKyWbC/fgxe09oIJvEUyrxiT9KYQ8r0wW4hVwz0maIvWO4MDymQ8XZpf4jqSmISLh7I
 LtwFvVINAheIPWzHwsDGpwnLrg+fVJnG2EFknNv2X74RfPTyjS2yr7sOm9TlGMFP1wudgMG2E
 +kvs20B3TwakSQUJkYPK7OWbRXk80KyKKYPAbGuhEc3g0S1poZZVKUOjl0aIAc13/xdW0J5F4
 fR2VS8+xWT00FOggTPtn2l9+56qDd3grvNKEqzrWPmgRf0pctgFChlJ7rKiRYsysC2uq+31j3
 m96NS+N0oukLakr9dG1gzJFtk+p9demgwiG9zrU/CpC93y0i2CQktk4BBPHNGBP6Mfj/r1B3Q
 AIfiFJ4OWoywMTZ24UWNgJeY5KnXT1BsdI/iXym4LhpHwD+KOCftR1UXY6OLPxoGYe5U6O63M
 mlZEyG5zqlx+FmopGHsSC28luN0cCQegFCzpmBC1F/FUEa2PODTQrj5NVYxqcLz7xujEjRBcO
 PJ2usGtkhRAKkRZ+zAejstj/9sG2Nc/hLY2fwFyIVoGLBBRjInZFeFElBXD4rJk2CFP48X5Uc
 gxyZLoFkcVG/rIhr2PylXTzTif/AUtcUPTkwT/+tDn3Ros7LXKmvmLqz2ukq7SnhwLhPK4Obs
 OrJRtP4FVmMOnhISR2Z+et3AuEKc+Xwmk06cxMSLQtDiOQDUTxSNF8JcRfcgxmCyrpU0VPwZf
 2r/3kTJb1FQ+1YQB21okVMcg==
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
> Link partner advertised link modes are not reported by the SerDes
> hardware if not operating in SGMII mode=2E Hence we cannot use
> phylink_mii_c22_pcs_decode_state() in this case=2E
> Implement reporting link and an_complete only and use speed according to
> the interface mode=2E

Hi,

have tested Parts 1-12 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no =
2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Thx Daniel for working on SFP support :)

regards Frank
