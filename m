Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B125B9623
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiIOIU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiIOIUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD7E97B25
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6l-0004Lc-IW
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5CE5DE3993
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C5792E3937;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 428201c5;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/23] can: kvaser_pciefd: remove redundant variable ret
Date:   Thu, 15 Sep 2022 10:19:58 +0200
Message-Id: <20220915082013.369072-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from readl_poll_timeout() instead of
getting value from redundant variable ret.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
Link: https://lore.kernel.org/all/20220831150805.305106-1-cui.jinpeng2@zte.com.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/kvaser_pciefd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index ed54c0b3c7d4..4e9680c8eb34 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -329,12 +329,9 @@ MODULE_DEVICE_TABLE(pci, kvaser_pciefd_id_table);
 static int kvaser_pciefd_spi_wait_loop(struct kvaser_pciefd *pcie, int msk)
 {
 	u32 res;
-	int ret;
-
-	ret = readl_poll_timeout(pcie->reg_base + KVASER_PCIEFD_SPI_STATUS_REG,
-				 res, res & msk, 0, 10);
 
-	return ret;
+	return readl_poll_timeout(pcie->reg_base + KVASER_PCIEFD_SPI_STATUS_REG,
+			res, res & msk, 0, 10);
 }
 
 static int kvaser_pciefd_spi_cmd(struct kvaser_pciefd *pcie, const u8 *tx,
-- 
2.35.1


