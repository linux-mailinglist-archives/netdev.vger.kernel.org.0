Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20759398789
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFBLGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:06:10 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4284 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhFBLGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:06:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fw5dP70X8z1BGVR;
        Wed,  2 Jun 2021 18:59:37 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/6] net: hdlc_cisco: fix the code style issue about "foo* bar"
Date:   Wed, 2 Jun 2021 19:01:12 +0800
Message-ID: <1622631676-34037-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
References: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Fix the checkpatch error as "foo* bar" and should be "foo *bar",
and "(foo*)" should be "(foo *)".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_cisco.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 5fc0f8d..227939d 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -58,7 +58,7 @@ struct cisco_state {
 
 static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr);
 
-static inline struct cisco_state* state(hdlc_device *hdlc)
+static inline struct cisco_state *state(hdlc_device *hdlc)
 {
 	return (struct cisco_state *)hdlc->state;
 }
@@ -73,7 +73,7 @@ static int cisco_hard_header(struct sk_buff *skb, struct net_device *dev,
 #endif
 
 	skb_push(skb, sizeof(struct hdlc_header));
-	data = (struct hdlc_header*)skb->data;
+	data = (struct hdlc_header *)skb->data;
 	if (type == CISCO_KEEPALIVE)
 		data->address = CISCO_MULTICAST;
 	else
@@ -98,7 +98,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	}
 	skb_reserve(skb, 4);
 	cisco_hard_header(skb, dev, CISCO_KEEPALIVE, NULL, NULL, 0);
-	data = (struct cisco_packet*)(skb->data + 4);
+	data = (struct cisco_packet *)(skb->data + 4);
 
 	data->type = htonl(type);
 	data->par1 = par1;
@@ -118,7 +118,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 
 static __be16 cisco_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
-	struct hdlc_header *data = (struct hdlc_header*)skb->data;
+	struct hdlc_header *data = (struct hdlc_header *)skb->data;
 
 	if (skb->len < sizeof(struct hdlc_header))
 		return cpu_to_be16(ETH_P_HDLC);
@@ -143,7 +143,7 @@ static int cisco_rx(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct cisco_state *st = state(hdlc);
-	struct hdlc_header *data = (struct hdlc_header*)skb->data;
+	struct hdlc_header *data = (struct hdlc_header *)skb->data;
 	struct cisco_packet *cisco_data;
 	struct in_device *in_dev;
 	__be32 addr, mask;
@@ -172,7 +172,7 @@ static int cisco_rx(struct sk_buff *skb)
 			goto rx_error;
 		}
 
-		cisco_data = (struct cisco_packet*)(skb->data + sizeof
+		cisco_data = (struct cisco_packet *)(skb->data + sizeof
 						    (struct hdlc_header));
 
 		switch (ntohl (cisco_data->type)) {
-- 
2.8.1

