Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39655345F5E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhCWNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:17:16 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:32771 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhCWNPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:15:50 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 1F28575F88;
        Tue, 23 Mar 2021 16:15:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505340;
        bh=VSCxnZw85oFOR5beirnTrNKIrzH89/wNqojhy4GW7cg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=wRYmCRdwkqWH/80aBcicalYiFSKQJZEDxo/h1DfLh8Z9n/L8mXET5OXNpZkwiwkUV
         E9IIO12RKCsFsjjKrTKqHhLpjfAakHfPZ8J5ypms/XsvIUsJieN0d2Gk1OTqVqN+hN
         hN+BmEUsYxvp2Eb7HmPEYUHrhEAM0xbMHCDnp6XF02N4PYL6E1GysHySZ3hnCai7Vx
         INdoxzX4cRJ1EgzccTIaEzOG8scoBtEdU9Vjf4R48MVgt7EKZkl174mBiTZN56kfQw
         WrunYwtvz8i0H/vIILduQtUkjvkq+NEmP4mPeCCR8wIb+h5sYYBYOEYtx6cT239V2w
         PrDHtSjZyDjAQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id AA23E75FAD;
        Tue, 23 Mar 2021 16:15:39 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:15:39 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 22/22] virtio/vsock: update trace event for SEQPACKET
Date:   Tue, 23 Mar 2021 16:15:30 +0300
Message-ID: <20210323131534.2462334-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/23/2021 13:01:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162595 [Mar 23 2021]
X-KSE-AntiSpam-Info: LuaCore: 437 437 85ecb8eec06a7bf2f475f889e784f42bce7b4445
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/23/2021 13:03:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2021 11:46:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/23 11:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/23 11:40:00 #16480199
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates current implementation for trace event of virtio vsock:
SEQPACKET socket's type, SEQPACKET specific ops and SEQPACKET 'msg_len'
and 'msg_id' fields are added.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 .../events/vsock_virtio_transport_common.h    | 48 ++++++++++++++-----
 net/vmw_vsock/virtio_transport_common.c       | 25 +++++++++-
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/vsock_virtio_transport_common.h b/include/trace/events/vsock_virtio_transport_common.h
index 6782213778be..3254607eac04 100644
--- a/include/trace/events/vsock_virtio_transport_common.h
+++ b/include/trace/events/vsock_virtio_transport_common.h
@@ -9,9 +9,12 @@
 #include <linux/tracepoint.h>
 
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_SEQPACKET);
 
 #define show_type(val) \
-	__print_symbolic(val, { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" })
+	__print_symbolic(val, \
+				{ VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
+				{ VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })
 
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_INVALID);
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_REQUEST);
@@ -21,6 +24,8 @@ TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_SHUTDOWN);
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_RW);
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_CREDIT_UPDATE);
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_CREDIT_REQUEST);
+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_SEQ_BEGIN);
+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_SEQ_END);
 
 #define show_op(val) \
 	__print_symbolic(val, \
@@ -31,7 +36,9 @@ TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_CREDIT_REQUEST);
 			 { VIRTIO_VSOCK_OP_SHUTDOWN, "SHUTDOWN" }, \
 			 { VIRTIO_VSOCK_OP_RW, "RW" }, \
 			 { VIRTIO_VSOCK_OP_CREDIT_UPDATE, "CREDIT_UPDATE" }, \
-			 { VIRTIO_VSOCK_OP_CREDIT_REQUEST, "CREDIT_REQUEST" })
+			 { VIRTIO_VSOCK_OP_CREDIT_REQUEST, "CREDIT_REQUEST" }, \
+			 { VIRTIO_VSOCK_OP_SEQ_BEGIN, "SEQ_BEGIN" }, \
+			 { VIRTIO_VSOCK_OP_SEQ_END, "SEQ_END" })
 
 TRACE_EVENT(virtio_transport_alloc_pkt,
 	TP_PROTO(
@@ -40,7 +47,9 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
 		 __u32 len,
 		 __u16 type,
 		 __u16 op,
-		 __u32 flags
+		 __u32 flags,
+		 __u32 msg_len,
+		 __u32 msg_id
 	),
 	TP_ARGS(
 		src_cid, src_port,
@@ -48,7 +57,9 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
 		len,
 		type,
 		op,
-		flags
+		flags,
+		msg_len,
+		msg_id
 	),
 	TP_STRUCT__entry(
 		__field(__u32, src_cid)
@@ -59,6 +70,8 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
 		__field(__u16, type)
 		__field(__u16, op)
 		__field(__u32, flags)
+		__field(__u32, msg_len)
+		__field(__u32, msg_id)
 	),
 	TP_fast_assign(
 		__entry->src_cid = src_cid;
@@ -69,14 +82,18 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
 		__entry->type = type;
 		__entry->op = op;
 		__entry->flags = flags;
+		__entry->msg_len = msg_len;
+		__entry->msg_id = msg_id;
 	),
-	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x",
+	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x msg_len=%u msg_id=%u",
 		  __entry->src_cid, __entry->src_port,
 		  __entry->dst_cid, __entry->dst_port,
 		  __entry->len,
 		  show_type(__entry->type),
 		  show_op(__entry->op),
-		  __entry->flags)
+		  __entry->flags,
+		  __entry->msg_len,
+		  __entry->msg_id)
 );
 
 TRACE_EVENT(virtio_transport_recv_pkt,
@@ -88,7 +105,9 @@ TRACE_EVENT(virtio_transport_recv_pkt,
 		 __u16 op,
 		 __u32 flags,
 		 __u32 buf_alloc,
-		 __u32 fwd_cnt
+		 __u32 fwd_cnt,
+		 __u32 msg_len,
+		 __u32 msg_id
 	),
 	TP_ARGS(
 		src_cid, src_port,
@@ -98,7 +117,9 @@ TRACE_EVENT(virtio_transport_recv_pkt,
 		op,
 		flags,
 		buf_alloc,
-		fwd_cnt
+		fwd_cnt,
+		msg_len,
+		msg_id
 	),
 	TP_STRUCT__entry(
 		__field(__u32, src_cid)
@@ -111,6 +132,8 @@ TRACE_EVENT(virtio_transport_recv_pkt,
 		__field(__u32, flags)
 		__field(__u32, buf_alloc)
 		__field(__u32, fwd_cnt)
+		__field(__u32, msg_len)
+		__field(__u32, msg_id)
 	),
 	TP_fast_assign(
 		__entry->src_cid = src_cid;
@@ -123,9 +146,10 @@ TRACE_EVENT(virtio_transport_recv_pkt,
 		__entry->flags = flags;
 		__entry->buf_alloc = buf_alloc;
 		__entry->fwd_cnt = fwd_cnt;
+		__entry->msg_len = msg_len;
+		__entry->msg_id = msg_id;
 	),
-	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x "
-		  "buf_alloc=%u fwd_cnt=%u",
+	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x buf_alloc=%u fwd_cnt=%u msg_len=%u msg_id=%u",
 		  __entry->src_cid, __entry->src_port,
 		  __entry->dst_cid, __entry->dst_port,
 		  __entry->len,
@@ -133,7 +157,9 @@ TRACE_EVENT(virtio_transport_recv_pkt,
 		  show_op(__entry->op),
 		  __entry->flags,
 		  __entry->buf_alloc,
-		  __entry->fwd_cnt)
+		  __entry->fwd_cnt,
+		  __entry->msg_len,
+		  __entry->msg_id)
 );
 
 #endif /* _TRACE_VSOCK_VIRTIO_TRANSPORT_COMMON_H */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 01a56c7da8bd..9e27c0c67ee2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -47,6 +47,8 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 {
 	struct virtio_vsock_pkt *pkt;
 	int err;
+	u32 msg_len = 0;
+	u32 msg_id = 0;
 
 	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
 	if (!pkt)
@@ -74,6 +76,14 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 		err = memcpy_from_msg(pkt->buf, info->msg, len);
 		if (err)
 			goto out;
+
+		if (info->op == VIRTIO_VSOCK_OP_SEQ_BEGIN ||
+		    info->op == VIRTIO_VSOCK_OP_SEQ_END) {
+			struct virtio_vsock_seq_hdr *seq_hdr = pkt->buf;
+
+			msg_len = le32_to_cpu(seq_hdr->msg_len);
+			msg_id = le32_to_cpu(seq_hdr->msg_id);
+		}
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -81,7 +91,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 					 len,
 					 info->type,
 					 info->op,
-					 info->flags);
+					 info->flags, msg_len, msg_id);
 
 	return pkt;
 
@@ -1372,12 +1382,22 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	struct vsock_sock *vsk;
 	struct sock *sk;
 	bool space_available;
+	u32 msg_len = 0;
+	u32 msg_id = 0;
 
 	vsock_addr_init(&src, le64_to_cpu(pkt->hdr.src_cid),
 			le32_to_cpu(pkt->hdr.src_port));
 	vsock_addr_init(&dst, le64_to_cpu(pkt->hdr.dst_cid),
 			le32_to_cpu(pkt->hdr.dst_port));
 
+	if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN ||
+	    le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_END) {
+		struct virtio_vsock_seq_hdr *seq_hdr = pkt->buf;
+
+		msg_len = le32_to_cpu(seq_hdr->msg_len);
+		msg_id = le32_to_cpu(seq_hdr->msg_id);
+	}
+
 	trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
 					dst.svm_cid, dst.svm_port,
 					le32_to_cpu(pkt->hdr.len),
@@ -1385,7 +1405,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le16_to_cpu(pkt->hdr.op),
 					le32_to_cpu(pkt->hdr.flags),
 					le32_to_cpu(pkt->hdr.buf_alloc),
-					le32_to_cpu(pkt->hdr.fwd_cnt));
+					le32_to_cpu(pkt->hdr.fwd_cnt),
+					msg_len, msg_id);
 
 	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
-- 
2.25.1

