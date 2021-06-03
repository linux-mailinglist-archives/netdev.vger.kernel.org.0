Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9D399BC5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFCHqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:46:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2972 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCHqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:46:00 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FwdB31n7Rz6trS;
        Thu,  3 Jun 2021 15:41:15 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 15:44:13 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 15:44:13 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v3 02/12] Bluetooth: cmtp: Use the correct print format
Date:   Thu, 3 Jun 2021 15:40:55 +0800
Message-ID: <1622706065-45409-3-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/cmtp/capi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/cmtp/capi.c b/net/bluetooth/cmtp/capi.c
index eb415560..f3bedc3 100644
--- a/net/bluetooth/cmtp/capi.c
+++ b/net/bluetooth/cmtp/capi.c
@@ -74,7 +74,7 @@ static struct cmtp_application *cmtp_application_add(struct cmtp_session *sessio
 {
 	struct cmtp_application *app = kzalloc(sizeof(*app), GFP_KERNEL);
 
-	BT_DBG("session %p application %p appl %d", session, app, appl);
+	BT_DBG("session %p application %p appl %u", session, app, appl);
 
 	if (!app)
 		return NULL;
@@ -135,7 +135,7 @@ static void cmtp_send_capimsg(struct cmtp_session *session, struct sk_buff *skb)
 {
 	struct cmtp_scb *scb = (void *) skb->cb;
 
-	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
+	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
 	scb->id = -1;
 	scb->data = (CAPIMSG_COMMAND(skb->data) == CAPI_DATA_B3);
@@ -152,7 +152,7 @@ static void cmtp_send_interopmsg(struct cmtp_session *session,
 	struct sk_buff *skb;
 	unsigned char *s;
 
-	BT_DBG("session %p subcmd 0x%02x appl %d msgnum %d", session, subcmd, appl, msgnum);
+	BT_DBG("session %p subcmd 0x%02x appl %u msgnum %u", session, subcmd, appl, msgnum);
 
 	skb = alloc_skb(CAPI_MSG_BASELEN + 6 + len, GFP_ATOMIC);
 	if (!skb) {
@@ -188,7 +188,7 @@ static void cmtp_recv_interopmsg(struct cmtp_session *session, struct sk_buff *s
 	__u16 appl, msgnum, func, info;
 	__u32 controller;
 
-	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
+	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
 	switch (CAPIMSG_SUBCOMMAND(skb->data)) {
 	case CAPI_CONF:
@@ -321,7 +321,7 @@ void cmtp_recv_capimsg(struct cmtp_session *session, struct sk_buff *skb)
 	__u16 appl;
 	__u32 contr;
 
-	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
+	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
 	if (skb->len < CAPI_MSG_BASELEN)
 		return;
@@ -344,7 +344,7 @@ void cmtp_recv_capimsg(struct cmtp_session *session, struct sk_buff *skb)
 		appl = application->appl;
 		CAPIMSG_SETAPPID(skb->data, appl);
 	} else {
-		BT_ERR("Can't find application with id %d", appl);
+		BT_ERR("Can't find application with id %u", appl);
 		kfree_skb(skb);
 		return;
 	}
@@ -385,8 +385,8 @@ static void cmtp_register_appl(struct capi_ctr *ctrl, __u16 appl, capi_register_
 	unsigned char buf[8];
 	int err = 0, nconn, want = rp->level3cnt;
 
-	BT_DBG("ctrl %p appl %d level3cnt %d datablkcnt %d datablklen %d",
-		ctrl, appl, rp->level3cnt, rp->datablkcnt, rp->datablklen);
+	BT_DBG("ctrl %p appl %u level3cnt %u datablkcnt %u datablklen %u",
+	       ctrl, appl, rp->level3cnt, rp->datablkcnt, rp->datablklen);
 
 	application = cmtp_application_add(session, appl);
 	if (!application) {
@@ -450,7 +450,7 @@ static void cmtp_release_appl(struct capi_ctr *ctrl, __u16 appl)
 	struct cmtp_session *session = ctrl->driverdata;
 	struct cmtp_application *application;
 
-	BT_DBG("ctrl %p appl %d", ctrl, appl);
+	BT_DBG("ctrl %p appl %u", ctrl, appl);
 
 	application = cmtp_application_get(session, CMTP_APPLID, appl);
 	if (!application) {
@@ -483,7 +483,7 @@ static u16 cmtp_send_message(struct capi_ctr *ctrl, struct sk_buff *skb)
 
 	application = cmtp_application_get(session, CMTP_APPLID, appl);
 	if ((!application) || (application->state != BT_CONNECTED)) {
-		BT_ERR("Can't find application with id %d", appl);
+		BT_ERR("Can't find application with id %u", appl);
 		return CAPI_ILLAPPNR;
 	}
 
@@ -515,7 +515,7 @@ static int cmtp_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "ctrl %d\n", session->num);
 
 	list_for_each_entry(app, &session->applications, list) {
-		seq_printf(m, "appl %d -> %d\n", app->appl, app->mapping);
+		seq_printf(m, "appl %u -> %u\n", app->appl, app->mapping);
 	}
 
 	return 0;
-- 
2.8.1

