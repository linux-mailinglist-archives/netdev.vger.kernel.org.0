Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F51E8B2B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbfJ2OsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:48:13 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:53372 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389510AbfJ2OsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 10:48:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id A4B8C23F4EC;
        Tue, 29 Oct 2019 15:48:11 +0100 (CET)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.075
X-Spam-Level: 
X-Spam-Status: No, score=-3.075 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.175, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7rlY4Dt-30TH; Tue, 29 Oct 2019 15:48:10 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 9761523F5D1;
        Tue, 29 Oct 2019 15:48:10 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Lars Poeschel <poeschel@lemonage.de>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v11 7/7] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Tue, 29 Oct 2019 15:48:02 +0100
Message-Id: <20191029144805.18439-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191029144320.17718-1-poeschel@lemonage.de>
References: <20191029144320.17718-1-poeschel@lemonage.de>
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
Changes in v10:
- Rebased the patch series on net-next 'Commit 503a64635d5e ("Merge
  branch 'DPAA-Ethernet-changes'")'

Changes in v9:
- Rebased the patch series on v5.4-rc2

Changes in v6:
- Rebased the patch series on v5.3-rc5

 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 1e35bf09faf2..46e5ff16f699 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -261,7 +261,7 @@ static int pn532_uart_probe(struct serdev_device *serdev)
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

