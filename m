Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085D1350156
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhCaNfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:35:40 -0400
Received: from mout.gmx.net ([212.227.15.19]:56175 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235545AbhCaNfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 09:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617197689;
        bh=ibhtJylvLZbLVTdi5GGJTxnMI6oVXL6m7a7MF8mWkPg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HduMZJ2SHdWqRJv3jdKbJddOUTup1rLzkBZrjzbNUZA1rzOHVqaRtaOvNax8+d/Iu
         Y6X2Ww9veTHcH1AyCxUMrJeuIzm7mLQjxXwLE8drWLUmO89hOzvecWfbN4WEwdI0oy
         PUhlhqr7KDwabBkqS8Jx+NpL/fSc3rKM73vZhJN0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([217.61.148.91]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1N0X8o-1lmYBh1L6K-00wVIp; Wed, 31 Mar 2021 15:34:49 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     netdev@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, davem@davemloft.net,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH][net-next] net: mediatek: add flow offload for mt7623
Date:   Wed, 31 Mar 2021 15:34:37 +0200
Message-Id: <20210331133437.75269-1-frank-w@public-files.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HPmPr6jTaU43AppMP5/aiJa5Sh3rTHe9vTWbrw6fgj27gpFLtPo
 RB8jAfpYdIuUWWhlQ7Avihs9EqqiGgffrsqZl+rIT2rowIjU2DmieK7uVJMFOBx7uZVoYOg
 GXSmnz7dBLQq+pPOr5RBtCWd3MIO9l6f4Ioa2CBjgtq4on9IHdnu4OQcmjbFAlekZtSFRSb
 XzRgT+fOvWgjoZatX9rCw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aUESrT1sTvA=:bbw19/M6xSRsQGZVRWjg/Q
 tjsOOYyf4//ERAFPKI5ktz4h/K8agFPFJBeC0THwCL6xjh5FAnzaUpVB1D8dDD1azZ/x+eBQt
 yqCVFiuhDz/UcLFpVSu4HiBulctG57QHL18MzhYuDktEAfWsLWUYbxUaAbSUkkmEA5Lc7vyOq
 MduVhlSQSrzFYf5t8QXc8BjqKvIamjNtpIVfqsdwzqviZmfR0t2weGJzFHSjByKlDzJ7G7Lnb
 0SestJlEs/OhqWFHK0ZaCbRNdMLB3X+u6h6QHs4XCsJQc+SYinf27sitxBKdM/JMDC81j2voM
 Bo6vLQlRRfx2vNOZfr0wL/SgBf45jzDo3g9x6XqPTbz+E2uz8C5ghujlV1jU8jglZM4aiWUeE
 p5AxxCFS/ZhCN+Z0ZUk9EATBfy7GF9wQxF1MXAFfaq1T3CSaWTI3HLPZqjeMQi5dbgi/B5Sww
 RK6/1Hk9NXuQQqXrjbvD3Vhh8SjKkLE4eUKwk6NTBqntO1eOIudv88XgY8jGudSVclJyGhI0/
 6vQlZtt7GxiL62hLTqQVcufwQWSMu1LhTaBVENmzjwE0Zb0uXTR4VCyAepLeB/OBcKpsZYGV5
 JOYaHBpd2lq4akdtqmlzZdhchYM/v3a8SIzePNHPc73CW2hWZTDhGZzoZUE83Wo1lb/cS+/F5
 JrwHKnSRtW9vmDeTERCzuFEYGQfaKJeKZTFDMGJGXYvKqFU9+VuTJ3lNs8dYMitzHd+Jfc8E+
 3+0KuoLI6bKoXA0EaOYleszB0CXy9ufYut01JgSiv8ZcoQfyn4TMNLTHHM+gtGOSazEl8gjSm
 F+dtnHm1EcMb16DoQaXQkd7pUzjgqGiOLaxA3XV+QqQ9ve5G29dKxj9cR3xx1SHdXSa4uQylh
 WJwuioNimKKPk60RcAZx1CSOb8GQqUHnxYAAJ5FHNhoLuZdkQdYLt/6QuIkWoncryDXBluy4p
 oia9575QcUBH6LeGXyvUv1f8AP/yLLc2ybAlRDGQz8I7Pm8z3yR5z5qgxOz0tNxujza8Nhaqz
 CGH3xLIdSMeoq95FLcOSC1SWj771ROEy8hPZFwjsqaYpOlA1eR8I1/Cxi966lV/5c3ERBK6fs
 k/8L71t5zlkjKDKss+lknl9cgo8Ro78ThtVpUQKwLoXPNi2kqbztYnrjLeItLhy7Lnhj7oPfc
 NqYU+XdGbiNCbkk2kE4Xf14su/nkC6yqPZImlF+yEzV5/2yHYKhVQqFsJypHB23w+MQF348OH
 2fPDrxWiTCXSTWhJG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mt7623 uses offload version 2 too

tested on Bananapi-R2

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
=2D--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/eth=
ernet/mediatek/mtk_eth_soc.c
index 0396f0db855f..810def064f11 100644
=2D-- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3202,6 +3202,7 @@ static const struct mtk_soc_data mt7623_data =3D {
 	.hw_features =3D MTK_HW_FEATURES,
 	.required_clks =3D MT7623_CLKS_BITMAP,
 	.required_pctl =3D true,
+	.offload_version =3D 2,
 };

 static const struct mtk_soc_data mt7629_data =3D {
=2D-
2.25.1

