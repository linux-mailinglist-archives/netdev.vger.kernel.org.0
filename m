Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8C4854DA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiAEOoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241004AbiAEOoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01FC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WO-00042S-Tp
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D89CA6D1AED
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DF6CE6D1ABD;
        Wed,  5 Jan 2022 14:44:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 37fe350d;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/15] can: kvaser_usb: make use of units.h in assignment of frequency
Date:   Wed,  5 Jan 2022 15:43:50 +0100
Message-Id: <20220105144402.1174191-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

Use the MEGA define plus the comment /* Hz */ when assigning
frequencies.

Link: https://lore.kernel.org/all/20211210075803.343841-1-mkl@pengutronix.de
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 7 ++++---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 9 +++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index dcee8dc828ec..cec36295fdc5 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/units.h>
 #include <linux/usb.h>
 
 #include <linux/can.h>
@@ -2040,7 +2041,7 @@ const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_kcan = {
 	.clock = {
-		.freq = 80000000,
+		.freq = 80 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 80,
 	.bittiming_const = &kvaser_usb_hydra_kcan_bittiming_c,
@@ -2049,7 +2050,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_kcan = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 	.clock = {
-		.freq = 24000000,
+		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
@@ -2057,7 +2058,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
 	.clock = {
-		.freq = 80000000,
+		.freq = 80 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 24,
 	.bittiming_const = &kvaser_usb_hydra_rt_bittiming_c,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index f7af1bf5ab46..aed271d5f3bb 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -19,6 +19,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/units.h>
 #include <linux/usb.h>
 
 #include <linux/can.h>
@@ -356,7 +357,7 @@ static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
 	.clock = {
-		.freq = 8000000,
+		.freq = 8 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
@@ -364,7 +365,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
 	.clock = {
-		.freq = 16000000,
+		.freq = 16 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
@@ -372,7 +373,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
 	.clock = {
-		.freq = 24000000,
+		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
@@ -380,7 +381,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
 	.clock = {
-		.freq = 32000000,
+		.freq = 32 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
-- 
2.34.1


