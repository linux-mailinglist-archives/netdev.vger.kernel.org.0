Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B3D3FFFC7
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349372AbhICMdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:33:13 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:60316 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349351AbhICMdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:33:12 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id B0CF476436;
        Fri,  3 Sep 2021 15:32:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630672330;
        bh=GfnUcJLo9U9m2eHeY1kiaWcphVfFjQ9hOr7Vf9qFRPY=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=6el+ilAitgD6og6E4I/eE3Kf5un/5AMky7Eku9MC/SxVrfB4Cj2J4VtBYCe/93Dtf
         jVjB/spd2jf0l3ye72mGQIFPk4Se4//J5we7SJwT4e0wsMJtBnqZo31ApQpo+VEK+k
         +F+/t3J2UkSPNI1SGxoiktKcUwuAYSgt2M7ZytBOjGeQK7WkmfKPFxUNlTo06IRIQI
         mvCQ0Ca4MPaQMpmWlYz5IH9WMexjtm0hVPLf1YKev4zYvOQul0hIds1nBgRAf0sYTU
         glPEuCswT21qNYM7ixNDsfcDofRhlqH7NZxOGJ6oEIlFCUtXUjPht+UyZsV7lN3XcF
         JO+6V9vgl76Nw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 6A48976432;
        Fri,  3 Sep 2021 15:32:10 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 3
 Sep 2021 15:31:31 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [PATCH net-next v5 1/6] virtio/vsock: rename 'EOR' to 'EOM' bit.
Date:   Fri, 3 Sep 2021 15:31:06 +0300
Message-ID: <20210903123109.3273053-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
References: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/03/2021 12:09:11
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165955 [Sep 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/03/2021 12:14:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.09.2021 6:49:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/09/03 11:02:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/09/03 06:49:00 #17152626
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This current implemented bit is used to mark end of messages
('EOM' - end of message), not records('EOR' - end of record).
Also rename 'record' to 'message' in implementation as it is
different things.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   | 12 ++++++------
 include/uapi/linux/virtio_vsock.h       |  2 +-
 net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f249622ef11b..feaf650affbe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -178,15 +178,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 * small rx buffers, headers of packets in rx queue are
 			 * created dynamically and are initialized with header
 			 * of current packet(except length). But in case of
-			 * SOCK_SEQPACKET, we also must clear record delimeter
-			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
-			 * packet with delimeter(which marks end of record),
+			 * SOCK_SEQPACKET, we also must clear message delimeter
+			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
+			 * packet with delimeter(which marks end of message),
 			 * there will be sequence of packets with delimeter
 			 * bit set. After initialized header will be copied to
 			 * rx buffer, this bit will be restored.
 			 */
-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 				restore_flag = true;
 			}
 		}
@@ -225,7 +225,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		if (pkt->off < pkt->len) {
 			if (restore_flag)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 3dd3555b2740..8485b004a5f8 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -97,7 +97,7 @@ enum virtio_vsock_shutdown {
 
 /* VIRTIO_VSOCK_OP_RW flags values */
 enum virtio_vsock_rw {
-	VIRTIO_VSOCK_SEQ_EOR = 1,
+	VIRTIO_VSOCK_SEQ_EOM = 1,
 };
 
 #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 081e7ae93cb1..4d5a93beceb0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -77,7 +77,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 
 		if (msg_data_left(info->msg) == 0 &&
 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -457,7 +457,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				dequeued_len += pkt_len;
 		}
 
-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
 			msg_ready = true;
 			vvs->msg_count--;
 		}
@@ -1029,7 +1029,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		goto out;
 	}
 
-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count++;
 
 	/* Try to copy small packets into the buffer of last packet queued,
@@ -1044,12 +1044,12 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 
 		/* If there is space in the last packet queued, we copy the
 		 * new packet in its buffer. We avoid this if the last packet
-		 * queued has VIRTIO_VSOCK_SEQ_EOR set, because this is
-		 * delimiter of SEQPACKET record, so 'pkt' is the first packet
-		 * of a new record.
+		 * queued has VIRTIO_VSOCK_SEQ_EOM set, because this is
+		 * delimiter of SEQPACKET message, so 'pkt' is the first packet
+		 * of a new message.
 		 */
 		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
-		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)) {
 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
 			       pkt->len);
 			last_pkt->len += pkt->len;
-- 
2.25.1

