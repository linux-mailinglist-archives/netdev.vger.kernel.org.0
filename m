Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5265860DD
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiGaTVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiGaTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4EDF87
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUR-0007GH-Uo
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6623CBEC60
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C56FDBEC4B;
        Sun, 31 Jul 2022 19:20:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 292ea178;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/36] can: c_can: export c_can_ethtool_ops and remove c_can_set_ethtool_ops()
Date:   Sun, 31 Jul 2022 21:20:05 +0200
Message-Id: <20220731192029.746751-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The function c_can_set_ethtool_ops() does one thing: populate
net_device::ethtool_ops. Instead, it is possible to directly assign
this field and remove one function call and slightly reduce the object
size. To do so, export c_can_ethtool_ops so it becomes visible to
c_can_main.c.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727104939.279022-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.h         | 2 +-
 drivers/net/can/c_can/c_can_ethtool.c | 7 +------
 drivers/net/can/c_can/c_can_main.c    | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index bd2f6dc01194..f23a03300a81 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -223,7 +223,7 @@ int c_can_power_up(struct net_device *dev);
 int c_can_power_down(struct net_device *dev);
 #endif
 
-void c_can_set_ethtool_ops(struct net_device *dev);
+extern const struct ethtool_ops c_can_ethtool_ops;
 
 static inline u8 c_can_get_tx_head(const struct c_can_tx_ring *ring)
 {
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index 8a826a6813bd..36db2d9391d4 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -24,11 +24,6 @@ static void c_can_get_ringparam(struct net_device *netdev,
 	ring->tx_pending = priv->msg_obj_tx_num;
 }
 
-static const struct ethtool_ops c_can_ethtool_ops = {
+const struct ethtool_ops c_can_ethtool_ops = {
 	.get_ringparam = c_can_get_ringparam,
 };
-
-void c_can_set_ethtool_ops(struct net_device *netdev)
-{
-	netdev->ethtool_ops = &c_can_ethtool_ops;
-}
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index de38d8f7b5f7..dc8132862f33 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1364,7 +1364,7 @@ int register_c_can_dev(struct net_device *dev)
 
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
-	c_can_set_ethtool_ops(dev);
+	dev->ethtool_ops = &c_can_ethtool_ops;
 
 	return register_candev(dev);
 }
-- 
2.35.1


