Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7574318CFE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhBKOHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:07:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232100AbhBKOFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=18myQGQLnK7BH7Rw5XJwML6ZVL0hP7cTmzt6Wmuy4xU=;
        b=MVB3PqCd4/fTgMUFP616UQZTMmm/Z88xvvgA1DSPGByWJSw8GwFTdOgbnHKPLfGE6UCt0j
        s85Mymu7wyQ4m2bnRuv4f3TwnGy0DIRQ/b7eLdTTuMqLwCvKzOCpKSAvc/0Var0hKwpn0O
        IWQ3S6hY/e1Y+p3OOQmnhoFGWUPr1jo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-mhkpcLy4O5SVc1FWe-O20Q-1; Thu, 11 Feb 2021 09:03:33 -0500
X-MC-Unique: mhkpcLy4O5SVc1FWe-O20Q-1
Received: by mail-ej1-f70.google.com with SMTP id aq28so4827113ejc.20
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 06:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=18myQGQLnK7BH7Rw5XJwML6ZVL0hP7cTmzt6Wmuy4xU=;
        b=HFI0QuAt68AhxYjxyHU5sVlhq49Fq8Pqvv0aoV/AM1pnNsiQfsdOjOlhetxcQrHwBa
         CIEgIS6cmzEqy7maETcf1M+OKqgcbyPF2Vl55p7csQaFBItUEJerFRf8/riAd5AbBPg9
         QhvGNI2OABcBG7g7iKJgstRV9go3MfDt1WCARxohYkj7syLK54pdk4OCifi1jmdQCq9v
         ii6pGJssYQbViaY/Vv1zVpYSH8aJaBxTFFfJMChDG4uAaH1DVQEAumSC0FDIDiD5sxDc
         NmP+DBDCwJ4oXHNxpdWf/TXP6ID3U6PYTV/ctVSLPTbI/mxdOe8srIN/VhB59yQMe/CZ
         rSJQ==
X-Gm-Message-State: AOAM530YTDhnGIffpEphLA0TMaPCcpjSdlzMZTa9RyDWCCy3wxnMefEj
        VtCoK25HI4PJ0rEvsNubh6XBKrCkRfx7ct5dYz0xKyjhgqg9agSvr/srj50kp142XGTuc8DSW8g
        6p+DHfZNIhb212YNQ
X-Received: by 2002:a17:906:aec6:: with SMTP id me6mr8516282ejb.163.1613052211088;
        Thu, 11 Feb 2021 06:03:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBiH9SvgCAiqbC2qOJb6Mrpwjew9mxmT6XitiTd8tQdiVlLxB2zcepRrlBr2ebP9Qsdf3+wQ==
X-Received: by 2002:a17:906:aec6:: with SMTP id me6mr8516178ejb.163.1613052203085;
        Thu, 11 Feb 2021 06:03:23 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id i4sm4440606eje.90.2021.02.11.06.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 06:03:21 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:03:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 09/17] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210211140319.ptqgrj5nvjn4snc7@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151649.805359-1-arseny.krasnov@kaspersky.com>
 <20210211135428.k6cncu3m7ee4odhl@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210211135428.k6cncu3m7ee4odhl@steredhat>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 02:54:28PM +0100, Stefano Garzarella wrote:
>On Sun, Feb 07, 2021 at 06:16:46PM +0300, Arseny Krasnov wrote:
>>This adds transport callback and it's logic for SEQPACKET dequeue.
>>Callback fetches RW packets from rx queue of socket until whole record
>>is copied(if user's buffer is full, user is not woken up). This is done
>>to not stall sender, because if we wake up user and it leaves syscall,
>>nobody will send credit update for rest of record, and sender will wait
>>for next enter of read syscall at receiver's side. So if user buffer is
>>full, we just send credit update and drop data. If during copy SEQ_BEGIN
>>was found(and not all data was copied), copying is restarted by reset
>>user's iov iterator(previous unfinished data is dropped).
>>
>>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>---
>>include/linux/virtio_vsock.h            |   5 +
>>include/uapi/linux/virtio_vsock.h       |  16 ++++
>>net/vmw_vsock/virtio_transport_common.c | 120 ++++++++++++++++++++++++
>>3 files changed, 141 insertions(+)
>>
>>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>index dc636b727179..4d0de3dee9a4 100644
>>--- a/include/linux/virtio_vsock.h
>>+++ b/include/linux/virtio_vsock.h
>>@@ -36,6 +36,11 @@ struct virtio_vsock_sock {
>>	u32 rx_bytes;
>>	u32 buf_alloc;
>>	struct list_head rx_queue;
>>+
>>+	/* For SOCK_SEQPACKET */
>>+	u32 user_read_seq_len;
>>+	u32 user_read_copied;
>>+	u32 curr_rx_msg_cnt;
>>};
>>
>>struct virtio_vsock_pkt {
>>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>>index 1d57ed3d84d2..cf9c165e5cca 100644
>>--- a/include/uapi/linux/virtio_vsock.h
>>+++ b/include/uapi/linux/virtio_vsock.h
>>@@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
>>	__le32	fwd_cnt;
>>} __attribute__((packed));
>>
>>+struct virtio_vsock_seq_hdr {
>>+	__le32  msg_cnt;

Maybe it's better 'msg_id' for this field, since we use it to identify a 
message. Then whether we use a counter or a random number, I think it's 
just an implementation detail.

As Michael said, perhaps this detail should be discussed in the proposal 
for VIRTIO spec changes.

>>+	__le32  msg_len;
>>+} __attribute__((packed));
>>+
>>enum virtio_vsock_type {
>>	VIRTIO_VSOCK_TYPE_STREAM = 1,
>>+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>>};
>>
>>enum virtio_vsock_op {
>>@@ -83,6 +89,11 @@ enum virtio_vsock_op {
>>	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
>>	/* Request the peer to send the credit info to us */
>>	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
>>+
>>+	/* Record begin for SOCK_SEQPACKET */
>>+	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>>+	/* Record end for SOCK_SEQPACKET */
>>+	VIRTIO_VSOCK_OP_SEQ_END = 9,
>>};
>>
>>/* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
>>@@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
>>	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>>};
>>
>>+/* VIRTIO_VSOCK_OP_RW flags values */
>>+enum virtio_vsock_rw {
>>+	VIRTIO_VSOCK_RW_EOR = 1,
>>+};
>>+
>>#endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>index 5956939eebb7..4572d01c8ea5 100644
>>--- a/net/vmw_vsock/virtio_transport_common.c
>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>@@ -397,6 +397,126 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>	return err;
>>}
>>
>>+static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
>>+{
>>+	list_del(&pkt->list);
>>+	virtio_transport_free_pkt(pkt);
>>+}
>>+
>>+static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
>>+{
>
>This function is not used here, but in the next patch, so I'd add this 
>with the next patch.
>
>>+	struct virtio_vsock_pkt *pkt, *n;
>>+	size_t bytes_dropped = 0;
>>+
>>+	list_for_each_entry_safe(pkt, n, &vvs->rx_queue, list) {
>>+		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN)
>>+			break;
>>+
>>+		bytes_dropped += le32_to_cpu(pkt->hdr.len);
>>+		virtio_transport_dec_rx_pkt(vvs, pkt);
>>+		virtio_transport_remove_pkt(pkt);
>>+	}
>>+
>>+	return bytes_dropped;
>>+}
>>+
>>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>+						 struct msghdr *msg,
>>+						 bool *msg_ready)
>>+{
>
>Also this function is not used, maybe you can add in this patch the 
>virtio_transport_seqpacket_dequeue() implementation.
>
>>+	struct virtio_vsock_sock *vvs = vsk->trans;
>>+	struct virtio_vsock_pkt *pkt;
>>+	int err = 0;
>>+	size_t user_buf_len = msg->msg_iter.count;
>>+
>>+	*msg_ready = false;
>>+	spin_lock_bh(&vvs->rx_lock);
>>+
>>+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && !err) {
>>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>+
>>+		switch (le16_to_cpu(pkt->hdr.op)) {
>>+		case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
>>+			/* Unexpected 'SEQ_BEGIN' during record copy:
>>+			 * Leave receive loop, 'EAGAIN' will restart it from
>>+			 * outer receive loop, packet is still in queue and
>>+			 * counters are cleared. So in next loop enter,
>>+			 * 'SEQ_BEGIN' will be dequeued first. User's iov
>>+			 * iterator will be reset in outer loop. Also
>>+			 * send credit update, because some bytes could be
>>+			 * copied. User will never see unfinished record.
>>+			 */
>>+			err = -EAGAIN;
>>+			break;
>>+		}
>>+		case VIRTIO_VSOCK_OP_SEQ_END: {
>>+			struct virtio_vsock_seq_hdr *seq_hdr;
>>+
>>+			seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
>>+			/* First check that whole record is received. */
>>+
>>+			if (vvs->user_read_copied != vvs->user_read_seq_len ||
>>+			    (le32_to_cpu(seq_hdr->msg_cnt) - vvs->curr_rx_msg_cnt) != 1) {
>>+				/* Tail of current record and head of next missed,
>>+				 * so this EOR is from next record. Restart receive.
>>+				 * Current record will be dropped, next headless will
>>+				 * be dropped on next attempt to get record length.
>>+				 */
>>+				err = -EAGAIN;
>>+			} else {
>>+				/* Success. */
>>+				*msg_ready = true;
>>+			}
>>+
>>+			break;
>>+		}
>>+		case VIRTIO_VSOCK_OP_RW: {
>>+			size_t bytes_to_copy;
>>+			size_t pkt_len;
>>+
>>+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>+			bytes_to_copy = min(user_buf_len, pkt_len);
>>+
>>+			/* sk_lock is held by caller so no one else can dequeue.
>>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>+			 */
>>+			spin_unlock_bh(&vvs->rx_lock);
>>+
>>+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
>>+				spin_lock_bh(&vvs->rx_lock);
>>+				err = -EINVAL;
>>+				break;
>>+			}
>>+
>>+			spin_lock_bh(&vvs->rx_lock);
>>+			user_buf_len -= bytes_to_copy;
>>+			vvs->user_read_copied += pkt_len;
>>+
>>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_RW_EOR)
>>+				msg->msg_flags |= MSG_EOR;
>>+			break;
>>+		}
>>+		default:
>>+			;
>>+		}
>>+
>>+		/* For unexpected 'SEQ_BEGIN', keep such packet in queue,
>>+		 * but drop any other type of packet.
>>+		 */
>>+		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN) {
>>+			virtio_transport_dec_rx_pkt(vvs, pkt);
>>+			virtio_transport_remove_pkt(pkt);
>>+		}
>>+	}
>>+
>>+	spin_unlock_bh(&vvs->rx_lock);
>>+
>>+	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
>>+					    NULL);
>>+
>>+	return err;
>>+}
>>+
>>ssize_t
>>virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>>				struct msghdr *msg,
>>-- 
>>2.25.1
>>

