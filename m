Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10C9AE6B9
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfIJJVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:21:10 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:55654 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727254AbfIJJVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 05:21:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id D640523FBA0;
        Tue, 10 Sep 2019 11:21:06 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.083
X-Spam-Level: 
X-Spam-Status: No, score=-3.083 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.183, BAYES_00=-1.9] autolearn=ham
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9xf1MQ0D5aTr; Tue, 10 Sep 2019 11:21:05 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPA id C639E23F2C2;
        Tue, 10 Sep 2019 11:21:04 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v7 7/7] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Tue, 10 Sep 2019 11:34:27 +0200
Message-Id: <20190910093431.2268-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches the pn532 UART phy driver from manually polling to the new
autopoll mechanism.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v6:
- Rebased the patch series on v5.3-rc5

 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index cce8f29eda8b..deb553017d82 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -262,7 +262,7 @@ static int pn532_uart_probe(struct serdev_device *serdev)
 	serdev_device_set_flow_control(serdev, false);
 	pn532->send_wakeup = PN532_SEND_WAKEUP;
 	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
-	priv = pn53x_common_init(PN533_DEVICE_PN532,
+	priv = pn53x_common_init(PN533_DEVICE_PN532_AUTOPOLL,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     pn532, &uart_phy_ops, NULL,
 				     &pn532->serdev->dev);
-- 
2.23.0

