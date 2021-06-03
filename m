Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59A2399BC9
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFCHqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:46:05 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3403 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhFCHqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:46:01 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fwd9B21DTz68DY;
        Thu,  3 Jun 2021 15:40:30 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 15:44:15 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 15:44:15 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v3 11/12] Bluetooth: sco: Use the correct print format
Date:   Thu, 3 Jun 2021 15:41:04 +0800
Message-ID: <1622706065-45409-12-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
References: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. Printing an unsigned int value should use %u
instead of %d. Otherwise printk() might end up displaying negative numbers.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/sco.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 3bd4156..d9a4e88 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -310,7 +310,7 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	if (!sk)
 		goto drop;
 
-	BT_DBG("sk %p len %d", sk, skb->len);
+	BT_DBG("sk %p len %u", sk, skb->len);
 
 	if (sk->sk_state != BT_CONNECTED)
 		goto drop;
@@ -905,7 +905,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 
 		opts.mtu = sco_pi(sk)->conn->mtu;
 
-		BT_DBG("mtu %d", opts.mtu);
+		BT_DBG("mtu %u", opts.mtu);
 
 		len = min_t(unsigned int, len, sizeof(opts));
 		if (copy_to_user(optval, (char *)&opts, len))
@@ -1167,7 +1167,7 @@ static void sco_connect_cfm(struct hci_conn *hcon, __u8 status)
 	if (hcon->type != SCO_LINK && hcon->type != ESCO_LINK)
 		return;
 
-	BT_DBG("hcon %p bdaddr %pMR status %d", hcon, &hcon->dst, status);
+	BT_DBG("hcon %p bdaddr %pMR status %u", hcon, &hcon->dst, status);
 
 	if (!status) {
 		struct sco_conn *conn;
@@ -1196,7 +1196,7 @@ void sco_recv_scodata(struct hci_conn *hcon, struct sk_buff *skb)
 	if (!conn)
 		goto drop;
 
-	BT_DBG("conn %p len %d", conn, skb->len);
+	BT_DBG("conn %p len %u", conn, skb->len);
 
 	if (skb->len) {
 		sco_recv_frame(conn, skb);
-- 
2.8.1

