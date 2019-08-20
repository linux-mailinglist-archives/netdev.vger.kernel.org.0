Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3192695DE3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbfHTLw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:52:29 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:52410 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbfHTLw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:52:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 6ED5A23F1FF;
        Tue, 20 Aug 2019 13:52:26 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.121
X-Spam-Level: 
X-Spam-Status: No, score=-3.121 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.221, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IU0sJtfeQ23X; Tue, 20 Aug 2019 13:52:25 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 78E3823F187;
        Tue, 20 Aug 2019 13:52:25 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v6 7/7] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Tue, 20 Aug 2019 14:03:44 +0200
Message-Id: <20190820120345.22593-7-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190820120345.22593-1-poeschel@lemonage.de>
References: <20190820120345.22593-1-poeschel@lemonage.de>
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
index f1cc2354a4fd..e3085e5b2d4c 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -254,7 +254,7 @@ static int pn532_uart_probe(struct serdev_device *serdev)
 	serdev_device_set_flow_control(serdev, false);
 	pn532->send_wakeup = PN532_SEND_WAKEUP;
 	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
-	priv = pn53x_common_init(PN533_DEVICE_PN532,
+	priv = pn53x_common_init(PN533_DEVICE_PN532_AUTOPOLL,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     pn532, &uart_phy_ops, NULL,
 				     &pn532->serdev->dev);
-- 
2.23.0.rc1

