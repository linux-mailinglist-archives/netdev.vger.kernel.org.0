Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E696AF3EB
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjCGTL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjCGTKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:10:50 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD4BC85A2;
        Tue,  7 Mar 2023 10:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678215228; i=frank-w@public-files.de;
        bh=+owYiX7jswArKs3fL+HnoSgqSO+sE7J8CBPiU44HSVA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ud9W7IEd/03xmWP/ai64n/sHBhn0fBsP6DlJXdr5l0uNkSfa4zEU/lAo34Tm/y6RP
         bJNoR3KxCBkO9chRoQSPcSMDRyajidiVJgYrgfB6KEnrCLgdWahy7vkNS6AVC9MGFk
         +sQf/9G03qLckfMgAPncpMxMwS1fu9OraROpcVONaOkMIKqsd2YbtOi7nrxGN5y6G0
         iF7zovhxIvx+TbxQ8kAUZztBSNez95df01rwHNs6piXujUsggN5qxuwMecDtI7XRTj
         I0uxYTTwaFFn7ef/eVODUgVKUVwrSkGYmMY6r5++ywCI/21cTfqMt3UjX7gZWcN6gz
         iheRYz9g6tmiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.156.24] ([217.61.156.24]) by web-mail.gmx.net
 (3c-app-gmx-bs16.server.lan [172.19.170.68]) (via HTTP); Tue, 7 Mar 2023
 19:53:48 +0100
MIME-Version: 1.0
Message-ID: <trinity-c28f2d1c-6730-416a-ad34-6e03182c2cd5-1678215227989@3c-app-gmx-bs16>
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
Subject: Aw: [PATCH net-next v12 07/18] net: ethernet: mtk_eth_soc: only
 write values if needed
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Mar 2023 19:53:48 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <d2db725199011ec06082926830cf9fb2a8aeb147.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <d2db725199011ec06082926830cf9fb2a8aeb147.1678201958.git.daniel@makrotopia.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:pkz3K6WA6EmNJMhsiAcvkx7bjekeiDSDQDd8tCucyVIXTL57c1OwHykxVgZKG1lGsNyg1
 0cWV/hriObkPzyLS+0mGKLemW65VGLyO2iap2e1yYSL0GICfo5VbTKwQ8DkKaGAEY1NspIXVaseU
 lDoQX7fOwYvYMS2ZGrGAg+YIjOJiAkww3nvUJWFN21/EG7AIU5SydbGcwR6Y+xK9xx0tsk+cUGZr
 kB+K7tsWcuBEK5/xd/TbPnoqFd097MJDgdQbXT7+bzEicx/1VLzODjxPMN3Gn1Yui8bM/sKvC6QH
 Lo=
UI-OutboundReport: notjunk:1;M01:P0:mxzF7MLmkLI=;/RFfM47ZWNU2XSMGrw0gxKEoCRi
 xN13YE1EvN8VdTw8rS/2cyFNG+AoWNsqWM9YR7IhvFNPKeYDE+SoLwGeXs0oagtNQLQf9EOxk
 gcgJkOXmEIJDd41Gv1DnWJ13fAIj+FBM6XIDYbsi/IwJw+mDYvsRYxk5RT9uUeTx7uAirIAEc
 kdVMqy37arAgw1BjHnWZWh4wR57GDqgkvAK13qPvyiFAfPusc3lNFxTPJIU7n3NmS08WNbpDF
 FMjMuUZuJ5JgMNXGRVg5quf+z+P2FgkMNDtm6c8aaiFshuZ0b0lAlyR3z2HJhQDgzC+zytIub
 foMFAK1Dikg24AkfeeQP7qE/9yZBoZnk9C3/xsyPKr3GmWzzh3MbLXVU3J8eosodFg249eIHn
 7lJNSEr7aAERqaWXOcKNaSUBLAmmin6sKHBSvTwlSCXE7fMjMsgGTDXWM2Vm1pCbkKRDn2aUB
 ZK9E+ZYWu7cca711Q8/UjOi0C6DxiYPH2W1CNNhNRh/I9V1J/bGAJY9aTzbl3+3LZDmW9DjIm
 mZKFLid0r+020WWqHU6Dyz/T36itBN2wwOtQR/kQ6hk+Gw6KBJKepHXUZ3J53aW8FWtJrZ0cR
 cT89vsQa06PLXUF2PimUVABhFLki555V+5YGQJRPEHrYFdD0DY966B66ovTLwK11S7ZXTQhXc
 naFm23TpAk2anx7XQmJteQnGAiPI+v0l1XFdiaJVVZRUxgcBpUzY4p747w2C573ynKluLEP0U
 fSwj+7zOjp4QIY8zNNFmfEX/gr3PcIXslEVP/By46T9tK+LhX9OfkQyo6OFlr4hPHpa5SNtaS
 125/WcdSyvOnLbZ8kXoo7R9Mhw2WRgQp92LxqvW+KULJk=
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
> Only restart auto-negotiation and write link timer if actually
> necessary=2E This prevents loosing the link in case of minor
> changes=2E

Hi,

have tested Parts 1-12 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no =
2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Thx Daniel for working on SFP support :)

regards Frank
