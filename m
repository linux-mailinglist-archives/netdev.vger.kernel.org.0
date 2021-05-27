Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D0E3929FB
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhE0Iu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbhE0IuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:50:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D59C0613CE
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgl-0002DY-Mx
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A82A762D4D4
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 78D0162D42B;
        Thu, 27 May 2021 08:45:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 34fe22dc;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 19/21] can: m_can: clean up CCCR reg defs, order by revs
Date:   Thu, 27 May 2021 10:45:30 +0200
Message-Id: <20210527084532.1384031-20-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

Ensures that the different CCCR regmasks for m_can revs 3.0.x, 3.1.x,
3.2.x and 3.3.x are clearly distinguishable. Removes incorrect
CCCR_CANFD define. Adds bit fields UTSU and WMM for rev 3.3.x, for
completeness.

Link: https://lore.kernel.org/r/20210504125123.500553-3-torin@maxiluxsystems.com
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 5bed59b1083f..cee542c0fdd5 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -102,14 +102,6 @@ enum m_can_reg {
 #define TEST_LBCK		BIT(4)
 
 /* CC Control Register(CCCR) */
-#define CCCR_CMR_MASK		GENMASK(11, 10)
-#define CCCR_CMR_CANFD		0x1
-#define CCCR_CMR_CANFD_BRS	0x2
-#define CCCR_CMR_CAN		0x3
-#define CCCR_CME_MASK		GENMASK(9, 8)
-#define CCCR_CME_CAN		0
-#define CCCR_CME_CANFD		0x1
-#define CCCR_CME_CANFD_BRS	0x2
 #define CCCR_TXP		BIT(14)
 #define CCCR_TEST		BIT(7)
 #define CCCR_DAR		BIT(6)
@@ -119,14 +111,25 @@ enum m_can_reg {
 #define CCCR_ASM		BIT(2)
 #define CCCR_CCE		BIT(1)
 #define CCCR_INIT		BIT(0)
-#define CCCR_CANFD		BIT(4)
+/* for version 3.0.x */
+#define CCCR_CMR_MASK		GENMASK(11, 10)
+#define CCCR_CMR_CANFD		0x1
+#define CCCR_CMR_CANFD_BRS	0x2
+#define CCCR_CMR_CAN		0x3
+#define CCCR_CME_MASK		GENMASK(9, 8)
+#define CCCR_CME_CAN		0
+#define CCCR_CME_CANFD		0x1
+#define CCCR_CME_CANFD_BRS	0x2
 /* for version >=3.1.x */
 #define CCCR_EFBI		BIT(13)
 #define CCCR_PXHD		BIT(12)
 #define CCCR_BRSE		BIT(9)
 #define CCCR_FDOE		BIT(8)
-/* only for version >=3.2.x */
+/* for version >=3.2.x */
 #define CCCR_NISO		BIT(15)
+/* for version >=3.3.x */
+#define CCCR_WMM		BIT(11)
+#define CCCR_UTSU		BIT(10)
 
 /* Nominal Bit Timing & Prescaler Register (NBTP) */
 #define NBTP_NSJW_MASK		GENMASK(31, 25)
-- 
2.30.2


