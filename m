Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1A42E710A
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgL2Nty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:49:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9942 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgL2Nty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:49:54 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D4wjs5V2Tzhyy0;
        Tue, 29 Dec 2020 21:48:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:49:02 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: usb: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 29 Dec 2020 21:49:27 +0800
Message-ID: <20201229134927.23251-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/usb/hso.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 2bb28db89432..ef6dd012b8c4 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -370,7 +370,7 @@ static struct usb_driver hso_driver;
 static struct tty_driver *tty_drv;
 static struct hso_device *serial_table[HSO_SERIAL_TTY_MINORS];
 static struct hso_device *network_table[HSO_MAX_NET_DEVICES];
-static spinlock_t serial_table_lock;
+static DEFINE_SPINLOCK(serial_table_lock);
 
 static const s32 default_port_spec[] = {
 	HSO_INTF_MUX | HSO_PORT_NETWORK,
@@ -3236,7 +3236,6 @@ static int __init hso_init(void)
 	pr_info("%s\n", version);
 
 	/* Initialise the serial table semaphore and table */
-	spin_lock_init(&serial_table_lock);
 	for (i = 0; i < HSO_SERIAL_TTY_MINORS; i++)
 		serial_table[i] = NULL;
 
-- 
2.22.0

