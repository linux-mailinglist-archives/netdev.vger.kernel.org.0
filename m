Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282CA55609
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfFYRhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:37:03 -0400
Received: from sessmg22.ericsson.net ([193.180.251.58]:42008 "EHLO
        sessmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbfFYRhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1561484221; x=1564076221;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lEM7Je4rhOETOUZPdxrlLfv5tFvnnk7w3trQ71WsSmQ=;
        b=UD35IGKt2uyIPoE08gI4n0hmVSgqLJA24Bshmvh40BZ/hE0tOh48szA8hXDWPkg0
        8UIIMYRIxpHVWEQ3ZtGyKnN1bzXpnBoDVpqF+4ufzhl8RW2vCIorxQgc3jVQmN/l
        ftzMjIoFHgSIkEiX/IxIFXfVC7PVvXPLiFYZDB1fQ+g=;
X-AuditID: c1b4fb3a-6f1ff7000000189f-1b-5d125bbd5f31
Received: from ESESSMB502.ericsson.se (Unknown_Domain [153.88.183.120])
        by sessmg22.ericsson.net (Symantec Mail Security) with SMTP id 7C.87.06303.DBB521D5; Tue, 25 Jun 2019 19:37:01 +0200 (CEST)
Received: from ESESBMB503.ericsson.se (153.88.183.170) by
 ESESSMB502.ericsson.se (153.88.183.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 25 Jun 2019 19:37:00 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.186) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 25 Jun 2019 19:37:00 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <jon.maloy@ericsson.com>,
        <canh.d.luu@dektech.com.au>, <ying.xue@windriver.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: rename function msg_get_wrapped() to msg_inner_hdr()
Date:   Tue, 25 Jun 2019 19:37:00 +0200
Message-ID: <1561484220-22814-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsUyM2J7he7eaKFYg2kvRSxuNPQwW8w538Ji
        sWL3JFaLt69msVscWyBmseV8lsWV9rPsFo+vX2d24PDYsvImk8e7K2weuxd8ZvL4vEnOY/2W
        rUwBrFFcNimpOZllqUX6dglcGVOW/GArmC5a0dDznLmBcaNgFyMnh4SAicSNg1PYQWwhgaOM
        Eive+XUxcgHZ3xglXuzohkpcYJTYPy8DxGYT0JB4Oa2DEcQWETCWeLWykwmkgVngMaPEl/ur
        2EASwgLBEt8n7WYFsVkEVCWmrDgOFucVcJM4dOs2M8RmOYnzx38yQyxQlpj7YRoTRI2gxMmZ
        T1hAbGYBCYmDL14wT2Dkm4UkNQtJagEj0ypG0eLU4uLcdCMjvdSizOTi4vw8vbzUkk2MwBA9
        uOW31Q7Gg88dDzEKcDAq8fCujRSKFWJNLCuuzD3EKMHBrCTCuzRRIFaINyWxsiq1KD++qDQn
        tfgQozQHi5I473rvfzFCAumJJanZqakFqUUwWSYOTqkGxk7zPE9pszk65bUSpd17H1TMuRDM
        HbPP0qA+dGGq8pK/XY9FtUsq/U5M/R+7lOnLLcNjWp4fbOJ0rfnnx874ViQgcy3FMS/1x8kH
        T+yXcX7vVVEqi+bOebA/5obXZM11S/U6l/73mtJmuI17g6rQrPUf5TIvai+sf//Hem31fVb+
        y2t7z2x8o8RSnJFoqMVcVJwIADYYNLBNAgAA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We rename the inline function msg_get_wrapped() to the more
comprehensible msg_inner_hdr().

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/bcast.c | 4 ++--
 net/tipc/link.c  | 2 +-
 net/tipc/msg.h   | 4 ++--
 net/tipc/node.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 6c997d4..1336f3c 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -323,7 +323,7 @@ static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 
 	hdr = buf_msg(skb);
 	if (msg_user(hdr) == MSG_FRAGMENTER)
-		hdr = msg_get_wrapped(hdr);
+		hdr = msg_inner_hdr(hdr);
 	if (msg_type(hdr) != TIPC_MCAST_MSG)
 		return 0;
 
@@ -392,7 +392,7 @@ int tipc_mcast_xmit(struct net *net, struct sk_buff_head *pkts,
 		skb = skb_peek(pkts);
 		hdr = buf_msg(skb);
 		if (msg_user(hdr) == MSG_FRAGMENTER)
-			hdr = msg_get_wrapped(hdr);
+			hdr = msg_inner_hdr(hdr);
 		msg_set_is_rcast(hdr, method->rcast);
 
 		/* Switch method ? */
diff --git a/net/tipc/link.c b/net/tipc/link.c
index aa79bf8..f8bf63b 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -732,7 +732,7 @@ static void link_profile_stats(struct tipc_link *l)
 	if (msg_user(msg) == MSG_FRAGMENTER) {
 		if (msg_type(msg) != FIRST_FRAGMENT)
 			return;
-		length = msg_size(msg_get_wrapped(msg));
+		length = msg_size(msg_inner_hdr(msg));
 	}
 	l->stats.msg_lengths_total += length;
 	l->stats.msg_length_counts++;
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 8de02ad..da509f0 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -308,7 +308,7 @@ static inline unchar *msg_data(struct tipc_msg *m)
 	return ((unchar *)m) + msg_hdr_sz(m);
 }
 
-static inline struct tipc_msg *msg_get_wrapped(struct tipc_msg *m)
+static inline struct tipc_msg *msg_inner_hdr(struct tipc_msg *m)
 {
 	return (struct tipc_msg *)msg_data(m);
 }
@@ -486,7 +486,7 @@ static inline void msg_set_prevnode(struct tipc_msg *m, u32 a)
 static inline u32 msg_origport(struct tipc_msg *m)
 {
 	if (msg_user(m) == MSG_FRAGMENTER)
-		m = msg_get_wrapped(m);
+		m = msg_inner_hdr(m);
 	return msg_word(m, 4);
 }
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 550581d..324a1f9 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1649,7 +1649,7 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 	int usr = msg_user(hdr);
 	int mtyp = msg_type(hdr);
 	u16 oseqno = msg_seqno(hdr);
-	u16 iseqno = msg_seqno(msg_get_wrapped(hdr));
+	u16 iseqno = msg_seqno(msg_inner_hdr(hdr));
 	u16 exp_pkts = msg_msgcnt(hdr);
 	u16 rcv_nxt, syncpt, dlv_nxt, inputq_len;
 	int state = n->state;
-- 
2.1.4

