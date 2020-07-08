Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D4218C30
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgGHPr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:47:26 -0400
Received: from mout.gmx.net ([212.227.17.20]:45163 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgGHPrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 11:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594223208;
        bh=LU0N738Cta16L6YXG8KR0rGDYWQO7GyOF1FHDDiJg24=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Cki45PwWYQXuV+25zw+Sl0pjGy0r9ir66J5aJ3ClBXIXKJMSV7qabQS5dl8jY2Stf
         2xL6jRcsZTrOzKig9oyv4+VfBwNDd317enh4Cj4OLeRV0jYfrwjFWiTivMg7uBPAMq
         MwfB9oag27ZURwafMW1QZ9d0tt4ORT1/ucEdzcFM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([80.208.213.58]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MyKDU-1kpIgO2BeG-00yiQp; Wed, 08 Jul 2020 17:46:48 +0200
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
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix mtu warning
Date:   Wed,  8 Jul 2020 17:46:34 +0200
Message-Id: <20200708154634.9565-1-frank-w@public-files.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:f4eGLoM7b59LlVnF7QAav5q/YJIcx9clM2yM7+NqTv9tBkejQqs
 au1gdA7QoPd0PPprJTzRKzybOTMmD14heF0qGnjwaABpo+XISVHKv5rw99O2S0ojFe9uDQL
 Qxu2lOqi+kzvKyOBpfLYcfelq6iI7x0aHD2bo1rK4OYlfxeRe2f4NPCAwZXbWjcYfAUryJJ
 xAsnWzoMdvXQ0LmII42Zg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QZLgElE1BP0=:Gqhv8ZkYtw7DnMAyPRXD/X
 fJu6mohnMnpQAAYTv10zZw8JRMNqC10986RlCPTmKdzhQdheUmQlpzYByPQES1xWVq9/ZLpiJ
 nE63xOKvJKwimVxIK8rufuTT3ERB5ELpRSWN4Bh6r8ZCGvMAK/FlY0NzZeUUsE+jAprL/qKN4
 AI2dSf9H+nQEOTzhJ1AF+4URZzWlPL1HYaynWfijqXHenaimeCtP7cQdi/13F0CAkTN1XCPNX
 WRuheRfGgFeiXmhyhXlVNd4/2gujkPQKn/26b2ucv6cJDhzl1uUs3sGq/c9kkI/LjL3aZQtED
 gc+br4VzoFlVXavHhQVmnqgWXSL+EA2TrR9stXkiDOI/cyM3MwvVVPZ50TEq2/Q2OAbzZWTqC
 NsPs6REaRJ17OKkESZFOPNgWu+Ic+pBDDc3nsZXWVZMqdJSM/JJI7id8Xx+DurJ8smNs8oulk
 9y+/MZ850QkTnee8j9A6FkCXnBDGJwygDDPQCNJqLAdCPPD/QaHHw/6/Ah3dUfILQ6+sPevQO
 WwwCJHST3FdSMuCiJCiGLASeIEit2k3dAeL+KivcJPyM3Yame9Zi+CoiCY1rW0qLimxGCtw81
 VIdfTIYIDCU8EItB3W2jvdmVzkFlgDxwuXGgI1+ige4LUD1zGtcGzaL+PDGNN6YflzYKrcw28
 +fV5pzvXRJ7Z0h3Fv2FUQrbRn/EA837e+W4VXdAWYwh59XBHd03TTz4NSWu/omcRDa3Khb5+P
 ESAtYO8iU/yQvq7FB9YBwlj5JdkMW6FyHf8M7cg4IHXlZJI3CnSIK/oOfppeafAsgsS4+2uAX
 bXOzrchGMjm58CILJfqJ+KLsuggzdT8fmMSnFLnpyVvtWT6VHl+EZhCDY44WR+FLC6b5emPpg
 tOychoZgk6LNTlFDnVXOshmOiinrWeXVHV63j/dcw4fH6XZDaQ3OzBR68OBPvKZSH1EO5muYM
 y9x0idwevvzCpNm0FkEt7o1dY+lbwGBpXc70X/opvL51o/JxflVmZnP371AhguXCAV/UYFU3+
 Y/BUCdCsL7gMBIfLOXlp4Lk4AVX3+5drM35UdAhB3lRDfkmmBCQtahquQh2y+PVdLKigx+XAK
 Jje0lEOvgFGkQS0Jbi77PO2BTCoVBby4pXdDJs1kdVlRAVEK3/K9ODG8WdvrsLo6n6M5IquA3
 1mk+gzN6UbhUJT18/Szb7ULP+oFhp42bjbH2FBY5wU43ihVOlQGJfBEW7FJNBARX1ihjrghqk
 8siqjKpS75EovVn3BF1tgkeCRZialzpwFNk4W/A==
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

Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

Fixes: bfcb813203 ("net: dsa: configure the MTU for switch ports")
Fixes: 72579e14a1 ("net: dsa: don't fail to probe if we couldn't set the M=
TU")
Fixes: 7a4c53bee3 ("net: report invalid mtu value via netlink extack")
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

