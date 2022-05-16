Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30028529215
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348248AbiEPUwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348536AbiEPUvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCD62AE07
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIe-00069I-Mb
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9F8A27FB53
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 257F97FB43;
        Mon, 16 May 2022 20:26:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4f9a73d5;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 5/9] can: ctucanfd: Let users select instead of depend on CAN_CTUCANFD
Date:   Mon, 16 May 2022 22:26:21 +0200
Message-Id: <20220516202625.1129281-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

The CTU CAN-FD IP core is only useful when used with one of the
corresponding PCI/PCIe or platform (FPGA, SoC) drivers, which depend on
PCI resp. OF.

Hence make the users select the core driver code, instead of letting
then depend on it.  Keep the core code config option visible when
compile-testing, to maintain compile-coverage.

Link: https://lore.kernel.org/all/887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 48963efc7f19..3c383612eb17 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -1,5 +1,5 @@
 config CAN_CTUCANFD
-	tristate "CTU CAN-FD IP core"
+	tristate "CTU CAN-FD IP core" if COMPILE_TEST
 	help
 	  This driver adds support for the CTU CAN FD open-source IP core.
 	  More documentation and core sources at project page
@@ -13,8 +13,8 @@ config CAN_CTUCANFD
 
 config CAN_CTUCANFD_PCI
 	tristate "CTU CAN-FD IP core PCI/PCIe driver"
-	depends on CAN_CTUCANFD
 	depends on PCI
+	select CAN_CTUCANFD
 	help
 	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
 	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
@@ -23,8 +23,8 @@ config CAN_CTUCANFD_PCI
 
 config CAN_CTUCANFD_PLATFORM
 	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
-	depends on CAN_CTUCANFD
 	depends on OF || COMPILE_TEST
+	select CAN_CTUCANFD
 	help
 	  The core has been tested together with OpenCores SJA1000
 	  modified to be CAN FD frames tolerant on MicroZed Zynq based
-- 
2.35.1


