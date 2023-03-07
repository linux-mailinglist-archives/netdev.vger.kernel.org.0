Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094916AF44E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjCGTP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCGTPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:15:35 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A340CD647;
        Tue,  7 Mar 2023 10:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678215540; i=frank-w@public-files.de;
        bh=k9ls87AUqXtQuQdmuxvYZphUw05BBFcV2MURS2q3dHo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PtKB/92XDzY0GWt8hZXlK8GslfNV1TTVOc4jqXirgsGO+ZD3rVds+6xc0P/VTh9od
         IkPytmJXWLTOmy3ussLeBptofN4/5otgPZquOvttxp5RdmVhEQz0hIi8n7V7sgur6B
         4uY7G6FRE1pFamw7LehtT3UTFeZ9opMu2R2qjWI8o7CKRrCv9Ah2oed3Ayr57hhl4h
         GUU9c8ZE/20vzemeDT8ZaKU30arjoXH3SCe5/8CdfWfzBuvt8WrgHvWzaoStYRn57H
         uZ5z6o+S20B4RthHYl1fvScprh0FUTq/UKIeWwyEA330IDo9JUZuYrhLj1IHaunIdQ
         A5rHLggvoXZrQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.156.24] ([217.61.156.24]) by web-mail.gmx.net
 (3c-app-gmx-bs16.server.lan [172.19.170.68]) (via HTTP); Tue, 7 Mar 2023
 19:52:54 +0100
MIME-Version: 1.0
Message-ID: <trinity-4b8f5f5f-55fe-4c7c-9ba6-d903c722d0d8-1678215174716@3c-app-gmx-bs16>
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
Subject: Aw: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Mar 2023 19:52:54 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:ES5k/UBa3QqaRIr9k0VcmOXcFh0bykQJLKCIgGmd/YebGxi28WQ/EcN+n7mMf+t0YkaCy
 Y4897TVRC1SPVCFsi/uYPVwNKBdUpeRan3iRALEpNX1BKVJ7NWo7tZm//nuGZPenHExqoeI+dKKN
 VN6Cu2y+0iYztONsYUKBmW9UoqsHg/XLbwmDdbXOAo1i1FVhz6i9OvdB6Q2zmHE7u4xNzAxyTYsH
 OxyamxZFKelQJuufRPUa5QumyakVh0qvBi71r/B98Fa0QqgnObZiX3Scg7b9G54HL02TLA9kel/y
 G8=
UI-OutboundReport: notjunk:1;M01:P0:FKFSpgLdtoE=;ggl2He6pfDHWCL4A66ZEN11V2xU
 GjxyNVfMJ/61dmO3ZncoXdVglmIC82xVOp+4YvojI5h3T+PatvIfHWkDQftqu4wNaCe7ASo3U
 y9L8Mhp6FwVrSEDcy75LcTiKxzAD5g/DjOxWylP9eptnnK5SAOgiAJOBEvZhwDWf1SGAMEAj0
 Mrwp4Gdcovx7sBRJmUj/bdfcAbn7Id6GW9bgUTfPzOVuIeWexW2/IInsGl63R7mmXZykSZghP
 SA7YxToaoBy8Lm7H90L2+N8+XPuYyor59xipAJWmndVd4hd7dbxqn3iHpKOkFtfWFHvtxzaBL
 714WMsGX9G7/U6EEaTTT2ngDU0SxLm3cv+x44Bl0XULxoZRYziVFF6d8534IFaqFntZCgfBpg
 iRieo0uX4m84nf5rIxDaa7yBb5pm5Ez140pz4JVRVASlTm/DLem1Ls8Ml1XORAx/eXOgZVyHw
 7vze7jkQRR8Oqx5dMAwPdgABN+mosNIH9kICwTV7MeCFETWnrwQNpT2tlS24lclOWtpKjWXL3
 Q7dqiFe/DVuJFE9i+JzZTThMNpwltcJmbky7s+H3IwyHywUpHcYn1SEJ3VXT4/Jc1OMWZqS7Y
 iEx/xGT2adxKChTNEWWrIxqAYOQDTGGAwMls0rhCbVYBU/0sPp1IpO4XuxEw4YrEicuf1Nf/s
 xqsJiSX2vPixB9d7EhOb0YYlox5uzs/N+VxVgx2aDw0V75jmLQXNoYw/BNA6Z0t+C9tQ2RJ6M
 z/I+0AWwSmC9lx+rIEPMUW0c+Uf8j3X1yvVS4fRUAXtnkQcAg7EV8+mzoTlEuz7zZg2xkNJE4
 9zG7ZVoGjBs4GBKcaYhBgFbQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 07=2E M=C3=A4rz 2023 um 16:53 Uhr
> Von: "Daniel Golle" <daniel@makrotopia=2Eorg>
>
> After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
> would work only after `ethtool -s eth1 autoneg off`=2E
> As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
> to control auto-negotiation on the external interface it doesn't make
> much sense to use it to control on-board SGMII auto-negotiation between
> MAC and PHY=2E
> Set correct values to really only enable SGMII auto-negotiation when
> actually operating in SGMII mode=2E For 1000Base-X and 2500Base-X mode,
> enable remote-fault detection only if in-band-status is enabled=2E
> This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
> board and also makes it possible to use interface-mode-switching PHYs
> operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
> 2500M mode on other boards=2E

Hi,

have tested Parts 1-12 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no =
2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Thx Daniel for working on SFP support :)

regards Frank
