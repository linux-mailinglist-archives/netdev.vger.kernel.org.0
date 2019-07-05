Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0F6049C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 12:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfGEKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 06:37:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40471 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGEKhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 06:37:37 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hjLav-0006Gs-0U; Fri, 05 Jul 2019 10:37:33 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wl3501_cs: remove redundant variable ret
Date:   Fri,  5 Jul 2019 11:37:32 +0100
Message-Id: <20190705103732.30568-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never
read and it is being updated later with a new value that is returned.
The variable is redundant and can be replaced with a return 0 as
there are no other return points in this function.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/wl3501_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index a25b17932edb..007bf6803293 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1226,7 +1226,6 @@ static int wl3501_init_firmware(struct wl3501_card *this)
 static int wl3501_close(struct net_device *dev)
 {
 	struct wl3501_card *this = netdev_priv(dev);
-	int rc = -ENODEV;
 	unsigned long flags;
 	struct pcmcia_device *link;
 	link = this->p_dev;
@@ -1241,10 +1240,9 @@ static int wl3501_close(struct net_device *dev)
 	/* Mask interrupts from the SUTRO */
 	wl3501_block_interrupt(this);
 
-	rc = 0;
 	printk(KERN_INFO "%s: WL3501 closed\n", dev->name);
 	spin_unlock_irqrestore(&this->lock, flags);
-	return rc;
+	return 0;
 }
 
 /**
-- 
2.20.1

