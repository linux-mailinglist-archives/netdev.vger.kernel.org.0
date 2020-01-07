Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5391322A1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgAGJiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:38:05 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbgAGJiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 04:38:04 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E0FEF457812A5B5BC153;
        Tue,  7 Jan 2020 17:38:02 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 7 Jan 2020 17:37:53 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <khc@pm.waw.pl>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH next] drivers: net: cisco_hdlc: use __func__ in debug message
Date:   Tue, 7 Jan 2020 17:33:46 +0800
Message-ID: <20200107093346.99855-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __func__ to print the function name instead of hard coded string.
BTW, replace printk(KERN_DEBUG, ...) with netdev_dbg.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/wan/hdlc_cisco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index a030f5a..d8cba36 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -75,7 +75,7 @@ static int cisco_hard_header(struct sk_buff *skb, struct net_device *dev,
 {
 	struct hdlc_header *data;
 #ifdef DEBUG_HARD_HEADER
-	printk(KERN_DEBUG "%s: cisco_hard_header called\n", dev->name);
+	netdev_dbg(dev, "%s called\n", __func__);
 #endif
 
 	skb_push(skb, sizeof(struct hdlc_header));
@@ -101,7 +101,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	skb = dev_alloc_skb(sizeof(struct hdlc_header) +
 			    sizeof(struct cisco_packet));
 	if (!skb) {
-		netdev_warn(dev, "Memory squeeze on cisco_keepalive_send()\n");
+		netdev_warn(dev, "Memory squeeze on %s()\n", __func__);
 		return;
 	}
 	skb_reserve(skb, 4);
-- 
2.7.4

