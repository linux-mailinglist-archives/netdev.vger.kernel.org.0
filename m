Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BFF27F3CE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgI3VBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:01:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:34649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3VBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601499662;
        bh=YXarB7DY326rmeK9BBd8N/5jBVtQpyfEj4T9FTjHcpA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=cI2/U8U7aEIWoqPj+TfvwKt5tro7eCyrCDG6n/+IDkWhXXlvPi2NNuOv07TfUwl8c
         ZuZk02BHjkbiJXHfF5wLhylGxibN5oJ7Yg3nwabGbGUx5wJSGSOaufegi8exdEOZXH
         fw3r4rXlmIpcA9YraxNXcEQTRUaVx6uD9AE8WY2o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.183.5]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MTABT-1jzAED01MN-00UXlN; Wed, 30 Sep 2020 23:01:02 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] lib8390: Use netif_msg_init to initialize msg_enable bits
Date:   Wed, 30 Sep 2020 23:00:16 +0200
Message-Id: <20200930210016.11607-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9w7JycksINjLfer6WGzGM8xyyDdnuiF0sI8nVF1YObTHwwexBpH
 UvjxVqqsZz0dCPW44Yx2r+oRze/Ae74TFpkdfOElRv+Ie3+1EiQb+AM9NKTPxx/LCH8OfGu
 d6W+gmD4KY5VjCm3WUtzQfc2g60G2rxV1fTIaVgy9VV7je8QIiB/GSp3G/64uWMDMvznPYN
 RVXw7LGVXKJGBBleYkiJg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6bz3787oOm8=:H9ORjUCp1xrfwW1cRePakD
 AozQ9r/uElAACwIk78MOG6PdxBfjEEb0zs4VrCiiaj91kdafmTeVL8U2b4E45+AY3C2BzdCS6
 gzRY0KluWUPhecPGiavaQ0sSpQLGPvEgfglMFH+Z5UYo/SS3NCyxh21ZuHX7f2hCVPNG7XGKR
 RS6vamoDaCS3AwUAWSNCg2BYsOSkJpJc/RVVKafX1MH7vBfqFpIje0lmBr5FscpX0d+L5puG7
 eL9c6BDZS7t6cJjb4aIwShgQSDbAQg6n33GKRfXzu1se3TZcE0yHUEmDIpmoUTfZLvkdTBzSq
 7HUDitptAiEOk28vCHaGCKCKEjg3BF+zwKj1M6Nj9oCLXWqnzNYa9cKV69uN0AsTjpK5CA0+R
 32PAD/lGPDyRo8ZobWBFW4b7lDdHJytzwcApmDcL1PdY0vhcQu5Y6vLq0RiP+KNmDGjQqhQV6
 thDjDgXueiTHAgHgEwZhTqn0e1Zb58UNskXuX8wskle0sSqNkq9dxkYdEVBr0pPJ6FNKgk1aW
 m6u3/No5zZAzfDfjhznLI5vk1AWcskVnYR9ycU63pDBLrMblkaGlJrZM+4ZB+K9VwSNBbNQhI
 GlK8pXE8DyuXcSsRlAbh5zqBReHGFeJjv1fdA598QyilNHXU6tP1ZtNRmrxJ5yo3d4D8FI5ti
 5lf5g9gP9uXiiTHd9gSE1Sj8zMEuyaMDcjWN0tiKUfEMaOIcG21DgWUGEfWL0RhtPUe2CnzLV
 lSQuS6Lin6+LVNFM+WXyKooP6H8fQ8jo3Jtnrghz6y8cIA/0plcKEe/eZl8xRJx+j4AKPOCNb
 WvjaS1VcDGINZdqL8/GKKDLH9KgjWDY4DehO07doU+XXVGmL0kI+LGCyhvL/6cfdOJj/CRYL/
 N7f3gg17G8VT5N+Wl2Cbcn8gNx7h8ucNOA027+ouAf0hTnhahTHeCEiSYmF2NsCzPDqgu2Sem
 xGBh3tGaes9SGjx1QJ+NV0EbERtNipESCZgMT5a1gJSCiuxkEQoP1Mz4R07nUZ3SZ93YfdA0F
 Iqc6ZN97/DX9HACWylOfFv0xdqt3QPQa/ymO0e+n/hBc1uxhSaiLRLiu3NiwNg1DORk0j0sx2
 xXoUPUMMLANXk7038AbI7tE93BGALiKMyKIRTO4Rv/r58zKDkBeiccVXgO1La3PA+Q156ZEa2
 SabQD7YhoucVqSKsd/REQF3BmEwKpYXsymcoGIuvwyGViCk2VLh49HWt8NMWIufXOitcmt8re
 trB8kgCuVL2uF/f5M
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_msg_init() to process param settings
and use only the proper initialized value of
ei_local->msg_enable for later processing;

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
v2 changes:
- confused ei_local-> msg_enable with default_msg_level
=2D--
 drivers/net/ethernet/8390/lib8390.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index deba94d2c909..e84021282edf 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -113,8 +113,10 @@ static void do_set_multicast_list(struct net_device *=
dev);
 static void __NS8390_init(struct net_device *dev, int startp);

 static unsigned version_printed;
-static u32 msg_enable;
-module_param(msg_enable, uint, 0444);
+static int msg_enable;
+static const int default_msg_level =3D (NETIF_MSG_DRV | NETIF_MSG_PROBE |=
 NETIF_MSG_RX_ERR |
+				     NETIF_MSG_TX_ERR);
+module_param(msg_enable, int, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h =
for bitmap)");

 /*
@@ -974,14 +976,14 @@ static void ethdev_setup(struct net_device *dev)
 {
 	struct ei_device *ei_local =3D netdev_priv(dev);

-	if ((msg_enable & NETIF_MSG_DRV) && (version_printed++ =3D=3D 0))
-		pr_info("%s", version);
-
 	ether_setup(dev);

 	spin_lock_init(&ei_local->page_lock);

-	ei_local->msg_enable =3D msg_enable;
+	ei_local->msg_enable =3D netif_msg_init(msg_enable, default_msg_level);
+
+	if (netif_msg_drv(ei_local) && (version_printed++ =3D=3D 0))
+		pr_info("%s", version);
 }

 /**
=2D-
2.20.1

