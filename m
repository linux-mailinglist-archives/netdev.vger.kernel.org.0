Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F8E230A05
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgG1M2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:28:50 -0400
Received: from mout.gmx.net ([212.227.15.19]:33613 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgG1M2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 08:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595939299;
        bh=+Xhr2x2VYD1gWTmsb4Uofj+UiBxI7DdvuosyZzVaUM4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=KFWninAwHludxMxZQsuEzqYoXKBYCcGUd+YU82B6QxqADTgG0ZzR3Izd3f5yyROqS
         DVFscsUdxRXyCcMEnEZhgBs7sekWgeez0btr08FVEVoy9kh3bWZ8Zfqq5HMWWlhX/I
         9c5R1xKiSUgUrjjDyRr5JtBcQZcodpHMELOchWJo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([80.208.215.239]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MmlXA-1kScia3yWE-00jsa8; Tue, 28 Jul 2020 14:28:19 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Landen Chao <landen.chao@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH v3] net: ethernet: mtk_eth_soc: fix mtu warning
Date:   Tue, 28 Jul 2020 14:27:43 +0200
Message-Id: <20200728122743.78489-1-frank-w@public-files.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sc5b1pOFKi3FLEOULKn4OozLSQed687rhOjKqf+XCSsSamY2PgS
 2JzFzyIi+ztuNLr94TkKDcwv0V8CQVVgeRKACmKp1sOgDjY8lWDHTRhJEMdJ/ZdmLtdPzEY
 cpxqGiswcGavM06bTX+Y0XB7iBhQhFTK5u1HoAKmuv4zSkW3djqLkiVs66c7HgTDaGRA8G4
 K7il9Y7OEKrorNMSU9CNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6AZmNkrR0vY=:/2GNiK7U0djtOSALtwVhUo
 E4o95iSJIypzT+gKBd6jBwrAaoQaz4NPh+ydoyiRA5XRYp73aNToQ4CTIdCOAZFHPZ84jqiLy
 NJ4uY4TYfoXNU0uze2bhR8446EZ7sX3Mm0hn2MJHSFjS8xKNigGXiB63k8nIOFuT4F3jYtqLt
 kCA02I3FIT0j5RFMn+XCTY9PffplsrQT8yCM5xLQRJUxoo2a5rZIvzYenDz9tjUqejaJSYC8K
 5LMpCpZmYBsUR8Q0GhE/FM8/UFg+RqGQLWzmrtDBXFpddit4gTISIpZFYlddPeWo7EPXUZHK3
 41h2XWcEo4u8E9YSCkQQF9/6oeWbUZ/IxMygADgBbDbhaTtnXxcHcT8xf0/fqOHfsgRjtR3yl
 VoFYeMk4zt2IPl59t17+KyBf1b657Ejon1XSadfIcL1Xhe2TJGrymbaw1bYCPRAIdhwI2SE11
 Vj9Z4XkVrec242+SZ1NuiW4eGQjO0Ji2d0stOgqNsYQu5w6V01gmrg7hx2D6k9xN2ooj7aZ2M
 9+SGQ9x+QXp4cMI52AhkWpDMDOj8i2LVVjyQ8GrArJiSFJJv0702CbOI2rPl/DDrPI+zbiLL/
 FH4zO7I/uX2PGnMVUp6qG9nvd1f9xcddW8NhK8ndEpqkfWPWVyAq6IveDxkDe7G6gMF8LwVqx
 JRP22cnT4V3HI63ZM6f1N5UESv+/ALJV1u2qmZhRv1Zk5HNHzC4ZtKG2zbzRvD2uvMN50MKuh
 bDn84ONkh7kzG8lI7XSvXdVKch0w2iz4D1jjydW4SssG4suLpia2NWLWnQ/VZeIXT07Tw4hqM
 B7QCYyn0v/0bBuWLZJJ/qJR0v+n2hqqTqCBtZV82rwxZbTzFcKQr/0YrAbcnFxA2K6ewIf/FF
 O3McjzbzcLu7tdgUmNdj0DQrygPNbWL0jv/5Nur+z9n9njA1VI7pM6hJgTueVCN4hCP20CzY1
 CioTt5baNqnqbsny4bWUZlJrBFnt2Y62wKQqoitw+JlxkohUNNcIzpVftkaDFy3dsXSnVMek1
 dEc/0Gifpkh+MAm14rhp1jrDdzbd2wr4jMnoE2oRaFifjLzJ+RRL9hgpQ6GwLo7vXHLq2QuvV
 1pLSuqN1ZZ58QNBRuX5bBlKOQ2WNItFRnayXemW0ol4P+MCBF/xDWRGg85YsF+igQ2mkjwmP8
 WbAmRyqx7VfAqYTKkjjZQjqvaxiEIELx9vb7CjBM2xATxNxqfjUUOkGOfQKk5KVGLTUJgZoL8
 RnRK+yzwbJdlI5wj8ej0nI2mwXOi+wlp6q7pK9Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>

in recent Kernel-Versions there are warnings about incorrect MTU-Size
like these:

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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/eth=
ernet/mediatek/mtk_eth_soc.c
index 85735d32ecb0..a1c45b39a230 100644
=2D-- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2891,6 +2891,8 @@ static int mtk_add_mac(struct mtk_eth *eth, struct d=
evice_node *np)
 	eth->netdev[id]->irq =3D eth->irq[0];
 	eth->netdev[id]->dev.of_node =3D np;

+	eth->netdev[id]->max_mtu =3D MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+
 	return 0;

 free_netdev:
=2D-
2.25.1

