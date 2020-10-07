Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DC3286A27
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgJGVcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgJGVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894ACC0613DA
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:11 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2f-0005qi-LF; Wed, 07 Oct 2020 23:32:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 06/17] can: dev: fix type of get_can_dlc() and get_canfd_dlc() macros
Date:   Wed,  7 Oct 2020 23:31:48 +0200
Message-Id: <20201007213159.1959308-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The macros get_can_dlc() and get_canfd_dlc() are not visible in
userland. As such, type u8 should be preferred over type __u8.

Reference: https://lkml.org/lkml/2020/10/1/708
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20201002154219.4887-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/dev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index ed0482b2f4b2..f8975d0b90bb 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -84,13 +84,13 @@ struct can_priv {
 
 /*
  * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
- * to __u8 and ensure the dlc value to be max. 8 bytes.
+ * to u8 and ensure the dlc value to be max. 8 bytes.
  *
  * To be used in the CAN netdriver receive path to ensure conformance with
  * ISO 11898-1 Chapter 8.4.2.3 (DLC field)
  */
-#define get_can_dlc(i)		(min_t(__u8, (i), CAN_MAX_DLC))
-#define get_canfd_dlc(i)	(min_t(__u8, (i), CANFD_MAX_DLC))
+#define get_can_dlc(i)		(min_t(u8, (i), CAN_MAX_DLC))
+#define get_canfd_dlc(i)	(min_t(u8, (i), CANFD_MAX_DLC))
 
 /* Check for outgoing skbs that have not been created by the CAN subsystem */
 static inline bool can_skb_headroom_valid(struct net_device *dev,
-- 
2.28.0

