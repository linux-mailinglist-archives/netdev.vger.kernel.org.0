Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA055655FC
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiGDMwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiGDMwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE0711C34
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LYt-00011M-PZ
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1DD0FA794F
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B0B6BA7924;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ecf7788f;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 02/15] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Mon,  4 Jul 2022 14:26:00 +0200
Message-Id: <20220704122613.1551119-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

This reverts commit 05ca14fdb6fe65614e0652d03e44b02748d25af7.

On early silicon engineering samples observed bit shrinking issue when
we use brp as 1. Hence updated brp_min as 2. As in production silicon
this issue is fixed, so reverting the patch.

Link: https://lore.kernel.org/all/20220609082433.1191060-2-srinivas.neeli@xilinx.com
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 8a3b7b103ca4..e179d311aa28 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -258,7 +258,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -271,7 +271,7 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
-- 
2.35.1


