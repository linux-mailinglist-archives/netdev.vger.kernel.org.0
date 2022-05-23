Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC621531775
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiEWUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiEWUKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:10:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36CD985AC
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:10:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ntEOA-0002zp-7T
        for netdev@vger.kernel.org; Mon, 23 May 2022 22:10:50 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EE548848E2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 20:10:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 51CD4848D6;
        Mon, 23 May 2022 20:10:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6dc26c57;
        Mon, 23 May 2022 20:10:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>
Subject: [PATCH net-next 3/3] can: ctucanfd: platform: add missing dependency to HAS_IOMEM
Date:   Mon, 23 May 2022 22:10:45 +0200
Message-Id: <20220523201045.1708855-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220523201045.1708855-1-mkl@pengutronix.de>
References: <20220523201045.1708855-1-mkl@pengutronix.de>
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

The kernel test robot noticed that the ctucanfd platform driver fails
during modpost on platforms that don't support IOMEM.

| ERROR: modpost: "devm_ioremap_resource" [drivers/net/can/ctucanfd/ctucanfd_platform.ko] undefined!

This patch adds the missing HAS_IOMEM dependency.

Link: https://lore.kernel.org/all/20220523123720.1656611-1-mkl@pengutronix.de
Fixes: e8f0c23a2415 ("can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.")
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Ondrej Ille <ondrej.ille@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 3c383612eb17..6e2073351a8f 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -23,7 +23,7 @@ config CAN_CTUCANFD_PCI
 
 config CAN_CTUCANFD_PLATFORM
 	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
-	depends on OF || COMPILE_TEST
+	depends on HAS_IOMEM && (OF || COMPILE_TEST)
 	select CAN_CTUCANFD
 	help
 	  The core has been tested together with OpenCores SJA1000
-- 
2.35.1


