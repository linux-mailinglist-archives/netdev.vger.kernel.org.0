Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FA75646B6
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiGCK0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiGCK0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699E3632D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnv-0006LZ-H9
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:15 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E191CA6936
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4687CA691D;
        Sun,  3 Jul 2022 10:14:32 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ef79ca7a;
        Sun, 3 Jul 2022 10:14:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net-next 01/15] tty: Add N_CAN327 line discipline ID for ELM327 based CAN driver
Date:   Sun,  3 Jul 2022 12:14:15 +0200
Message-Id: <20220703101430.1306048-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220703101430.1306048-1-mkl@pengutronix.de>
References: <20220703101430.1306048-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Staudt <max@enpas.org>

The actual driver will be added via the CAN tree.

Link: https://lore.kernel.org/all/20220618180134.9890-1-max@enpas.org
Link: https://lore.kernel.org/all/Yrm9Ezlw1dLmIxyS@kroah.com
Signed-off-by: Max Staudt <max@enpas.org>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/tty.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
index 9d0f06bfbac3..68aeae2addec 100644
--- a/include/uapi/linux/tty.h
+++ b/include/uapi/linux/tty.h
@@ -38,8 +38,9 @@
 #define N_NULL		27	/* Null ldisc used for error handling */
 #define N_MCTP		28	/* MCTP-over-serial */
 #define N_DEVELOPMENT	29	/* Manual out-of-tree testing */
+#define N_CAN327	30	/* ELM327 based OBD-II interfaces */
 
 /* Always the newest line discipline + 1 */
-#define NR_LDISCS	30
+#define NR_LDISCS	31
 
 #endif /* _UAPI_LINUX_TTY_H */

base-commit: 0fcae3c8b1b32d79cb4bbf841023757358fb0413
-- 
2.35.1


