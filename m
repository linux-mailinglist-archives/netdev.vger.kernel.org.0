Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB972B041C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgKLLmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:42:54 -0500
Received: from smtp-outgoing.laposte.net ([160.92.124.108]:48302 "EHLO
        smtp-outgoing.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbgKLLlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:22 -0500
X-mail-filterd: {"version":"1.1.4","queueID":"4CX0042YDYz10MQ4","contextId":"ebf0f8af-98db-4cff-8680-f1f8c0471f72"}
Received: from outgoing-mail.laposte.net (localhost.localdomain [127.0.0.1])
        by mlpnf0120.laposte.net (SMTP Server) with ESMTP id 4CX0042YDYz10MQ4;
        Thu, 12 Nov 2020 12:35:32 +0100 (CET)
X-mail-filterd: {"version":"1.1.4","queueID":"4CX0014104z10MQT","contextId":"0e7ca37c-c656-48c2-9d8a-64fa72269c86"}
X-lpn-mailing: LEGIT
X-lpn-spamrating: 36
X-lpn-spamlevel: not-spam
X-lpn-spamcause: OK, (-100)(0000)gggruggvucftvghtrhhoucdtuddrgedujedruddvfedgtdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecunfetrffquffvgfdpqfgfvfdpggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffogggtgfesthekredtredtjeenucfhrhhomhepgghinhgtvghnthcuufhtvghhlhoruceovhhinhgtvghnthdrshhtvghhlhgvsehlrghpohhsthgvrdhnvghtqeenucggtffrrghtthgvrhhnpeetiedvheeijedtgfelvdfghfevtdevjeehffdtueekueeiudduteejkedtueffteenucfkphepkeekrdduvddurddugeelrdegleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehrohhmuhgrlhgurdgsvghrghgvrhhivgdpihhnvghtpeekkedruddvuddrudegledrgeelpdhmrghilhhfrhhomhepvhhinhgtvghnthdrshhtvghhlhgvsehlrghpohhsthgvrdhnvghtpdhrtghpthhtohepsghgohhlrghsiigvfihskhhisegsrgihlhhisghrvgdrtghomhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepvhhinhgtvghnthdrshhtvghhlhgvsehlrghpohhsthgvrdhnvghtpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpt
 hhtoheplhhinhhugidqmhgvughirghtvghksehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Received: from romuald.bergerie (unknown [88.121.149.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mlpnf0120.laposte.net (SMTP Server) with ESMTPSA id 4CX0014104z10MQT;
        Thu, 12 Nov 2020 12:35:29 +0100 (CET)
Received: from radicelle.bergerie (radicelle.bergerie [192.168.124.12])
        by romuald.bergerie (Postfix) with ESMTPS id 6D2913D20EA2;
        Thu, 12 Nov 2020 09:48:56 +0100 (CET)
Received: from vincent by radicelle.bergerie with local (Exim 4.94)
        (envelope-from <vincent@radicelle.bergerie>)
        id 1kd8Ho-0005k4-55; Thu, 12 Nov 2020 09:48:56 +0100
From:   =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        "David S . Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] net: ethernet: mtk-star-emac: return ok when xmit drops
Date:   Thu, 12 Nov 2020 09:48:33 +0100
Message-Id: <20201112084833.21842-1-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=laposte.net; s=lpn-wlmd; t=1605181262; bh=ZqIXuytQtqNakK+uXCSUANljRRTY4GRLTUpiu+kdDGU=; h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding; b=TNdbcnQq5WonWKMYhSdC44fXdikMZVeTmScp4iQPA4v4oOPwRbOrJKQKYuSDtEyWZrz0Z9QKltkSjl0I/kc0c+459xMl1hOB3LY4XeVFqK5NjI/72zjaTQFxrvjdUH2V+OtdBl0G+tO6w85LmyFnmffRrrRv+lkg0Z9FJAAs+LbkZ8O+wrsYgBvh/LEFqaFxphTp/t3lKlSwPINLsCrpz5vfGNOEZ1gDa+w2jm9MBropTQV1APKGtd1N4pTgrWQNWKh15xkl2NwzyJNp/1ZNOu4Ade9LZ6BjJNnHy0Hq0x+XWzmTeRCWL7I6HMPDO8rK9RXuSQYdDIp4r5TmyyhPtw==;
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit() method must return NETDEV_TX_OK if the DMA mapping
fails, after freeing the socket buffer.
Fix the mtk_star_netdev_start_xmit() function accordingly.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/=
ethernet/mediatek/mtk_star_emac.c
index 13250553263b5..e56a26f797f28 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1053,7 +1053,7 @@ static int mtk_star_netdev_start_xmit(struct sk_buf=
f *skb,
 err_drop_packet:
 	dev_kfree_skb(skb);
 	ndev->stats.tx_dropped++;
-	return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
 }
=20
 /* Returns the number of bytes sent or a negative number on the first
--=20
2.28.0

