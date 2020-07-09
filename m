Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184D4219822
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 07:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGIF6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 01:58:39 -0400
Received: from mout.gmx.net ([212.227.15.18]:41727 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGIF6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 01:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594274280;
        bh=TZyOZH4895BbG19FeNnP5yjeMPwsXxV4vbelAvplHBw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=QBkJqIQOi3Ezk6E5qvcxxXfpkAXw1PbdrY4RIcpGpU5Xwyf7W2vVjn0V1wZ6XjsdA
         VZ+SSuZIVEAZcahAE5LJyv8721HONnSS39X3UtDczbcWMBopJ4ujDXM+uRhaRISOtE
         UW60GY9lgNq5SPIAGgaCrcI9yfsT8ZZIwvTeeok0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([80.208.213.58]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MF3He-1k8ldY2LKS-00FSxk; Thu, 09 Jul 2020 07:58:00 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     linux-mediatek@lists.infradead.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Date:   Thu,  9 Jul 2020 07:57:42 +0200
Message-Id: <20200709055742.3425-1-frank-w@public-files.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Wiq1d0Rddq7HCel86HaixNIkmlj/ib233BDnqRUt+y8BT1RO3P0
 KCVI1KoqMaaeH+Jnk7aRF5LN5LWIrxCy5SoM6qHoojl1Y9q7hd4SEuQ9BsurAKmIh4IZ1zs
 UNKnFIkIvAaj38rFsVzNuw6Fm0S41lXvLr4TsfQFYfaz3gLFwQlhW+8EJwv0sZcbieLvfNY
 Hsx+dBl35UMvQTDEG5WYg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GJQnkQj6Nb8=:e3QUf6iX7w/bGxzDtL+VVs
 jk2SPQO+nbTdJvY/LeUEntYYjH3TMcN6x7qrdIoTQNRtcRp8uFpEzWVfgbMgOR78GudBWPBqP
 dFc58Yyab73JQqWzKHkdHkjOzTinxYTJVbcr9/6VurbXAgvDWlp2u2FzYn9pxt9hiRnk1IIUD
 VdaCFS/9O/UE/SiDsHv3HtlSSOBEfwjIALJG1sddZ8K5Vobmnz/LlXbrcjuSDl4a3cod1lyA0
 VKMdRPmN0hghIeUa6JMorwpfNyIOvG3+GL8s4lBYcwaUlccqqmKLYsyDXlPPkPcxjtYYKslwq
 xyyviK2P+SjjIcr7pWpDmfpDTmut7GDcMt4tI19E1JqLzscmj5Z37kB+pguQo4qit04Cdx/Y6
 flrAj2m5J+6B5ZCB9u2O4NObdlNrsso8y/XeC2QqaGCkA/eXFOSUuqkUGcDrNMPZfpvxFep3D
 flVKf1L9WALPO/Z4E9gG4hbdbLW+FXRss5Irq8a3oU9Eh94ia+0bv25QBpwKSm0Q9MSw109xr
 jJoflQJ+HVCMvmFNHfC1IDdfIfuyEFTgBG6UFMfULFPHXajROxympOid+ub/9ljPNu0J91aEu
 lc6nwOvsr0SIS4ccTmeGFrzLhPjsMmMvXfE9v2iQgKhkrjB7BKHIKsAbMvIUZmiW8M/VH0+BZ
 ZUix3SOI+7Sw2aQ9gGpmJETxzX/2q6lXqX90P37zgrX12W4X7OqeKIZ+DQCf0xfXYZ/RtD9Y/
 rMLeTb+LfP75ejDzQXkOr/Gsyzqw3tY6YuPHUqnAx2anFT0dLlBwKBotcvkYfxT33rldIp6t5
 FTL3SxA0e/wuLypT3Z01cKANwLl68V9VMLs4rzswRkkLI1YN3zjtQGMGSUhxbS468QnY/TiLN
 6ejRpplKpxtaMMG7GAa7WA5brKvg01i8UBOEfYbTq9O4TvfOhgDHn/3VWwSYFhjAWMg3nUfDD
 stPWVYQhiE/XIBqj3RzHWpQGnuwKEnlnWrDF/+uKtMKW03sbDpXGTSZOJzluW9ngLm4MsDFmw
 8Zpy93ahKjYC9IR0kGGmB9+tovjtJsVLVbG8Uydyf181xb+BTsoRDcuQOh2EC7KukQUEbLYhK
 l0XNKshQj4Q9mcZZIR7ul3ES+j6LMOgA9BXzj2985NZKHLkrvUdxnY2q31DrhHp4Q8Mhc/0GQ
 q+gvjrkhWqkIRUnTWKPe982fGbEGtmlu6V+YR/8V+DidFTv5whDsbyIPQGGFVZOual8DJksEh
 WOWsY314213II6zL7HloqXxJiwTRxprY8JVbDGQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ren=C3=A9 van Dorst <opensource@vdorst.com>

in recent Kernel-Versions there are warnings about incorrect MTU-Size
like these:

mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port x
eth0: mtu greater than device maximum
mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA o=
verhead

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the=
 MTU")
Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
=2D--
changes in v2:
  Fixes: tag show 12-chars of sha1 and moved above other tags
=2D--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/eth=
ernet/mediatek/mtk_eth_soc.c
index 85735d32ecb0..00e3d70f7d07 100644
=2D-- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2891,6 +2891,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct =
device_node *np)
 	eth->netdev[id]->irq =3D eth->irq[0];
 	eth->netdev[id]->dev.of_node =3D np;

+	eth->netdev[id]->mtu =3D 1536;
+	eth->netdev[id]->min_mtu =3D ETH_MIN_MTU;
+	eth->netdev[id]->max_mtu =3D 1536;
+
 	return 0;

 free_netdev:
=2D-
2.25.1

