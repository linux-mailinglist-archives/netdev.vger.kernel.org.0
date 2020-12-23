Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6F2E1D0E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgLWOMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:12:15 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbgLWOMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:12:14 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D1FV44Tf3zkvJg;
        Wed, 23 Dec 2020 22:10:36 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 23 Dec 2020 22:11:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] atmel/at76c50x-usb: use DEFINE_MUTEX (and mutex_init() had been too late)
Date:   Wed, 23 Dec 2020 22:12:00 +0800
Message-ID: <20201223141200.32619-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 404257800033..7582761c61e2 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -101,7 +101,7 @@ do {									\
 static uint at76_debug = DBG_DEFAULTS;
 
 /* Protect against concurrent firmware loading and parsing */
-static struct mutex fw_mutex;
+static DEFINE_MUTEX(fw_mutex);
 
 static struct fwentry firmwares[] = {
 	[0] = { "" },
@@ -2572,8 +2572,6 @@ static int __init at76_mod_init(void)
 
 	printk(KERN_INFO DRIVER_DESC " " DRIVER_VERSION " loading\n");
 
-	mutex_init(&fw_mutex);
-
 	/* register this driver with the USB subsystem */
 	result = usb_register(&at76_driver);
 	if (result < 0)
-- 
2.22.0

