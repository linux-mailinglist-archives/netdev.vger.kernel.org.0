Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A480E318D71
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBKOdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:33:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232210AbhBKOa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613053768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lW/IdNqoQWH6t/JJ7uY6HVGKpmhmOv+VfmaelHA2RZg=;
        b=SthqQPB4rS1IWRYDcQ5zOLPQJfZWJRL/EK28VOVVOT8gR1yo5jFjIOX+26pGRZW4CgLpil
        tHofE+JSfMf7PuzpgIdNNCCSxUR6no5wP5sRmnw5QLsMF9dwLPqYwv4xJxHLRAk4/GS8O4
        xHSEsMzh80sysABdaaNPcFEQKHdba8U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-mWaIDVtZOJy5SyhlVvwUBw-1; Thu, 11 Feb 2021 09:29:26 -0500
X-MC-Unique: mWaIDVtZOJy5SyhlVvwUBw-1
Received: by mail-ej1-f71.google.com with SMTP id w16so4901054ejk.7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 06:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lW/IdNqoQWH6t/JJ7uY6HVGKpmhmOv+VfmaelHA2RZg=;
        b=DCdjnGA3nPhTtdUb+0fHxrthyOVlDH6YzCKckvN3fA6vOL7jaCgNHWkaP98bCOSEMc
         sCMkLtAvXp7nFUGdKmbRUCef+JRLzjHaWlHCQOmXpgi9HSPUzfxp0VjhZuUTwrt6x1Bt
         OcRvVCuoSGOeKxnuiihBjESaLE3T6t26grJHp/OsjIrC//9pGi/AAT8sMFbPdb9nnjT2
         GZx1LozQboQEDVBEGgaoTqS540AtvRVSmWRvHJiudxN0qXx+mPVeu4Qc2XHInUMFC9fI
         jTpyfboDmwWGk9OQ5BuXAH4yW+RUsCcPK8EStenczK7Nx/98TOaVfbG1NViM3MUfDI4f
         Q6Rw==
X-Gm-Message-State: AOAM531s4iULsdX+OOzIvDEdR2xz661ns78bym0DpObQ8/3+l5ZjxTmk
        fRHB8DK4OCmz5R39GUylG1Xub3SrJt7RB7BGhSbi/2ZzAfoftLbZsnAMrAcJC3+vC4sF0V3NBOu
        ARPnIRpTh0feMWgGd
X-Received: by 2002:a50:c88d:: with SMTP id d13mr8667756edh.206.1613053765525;
        Thu, 11 Feb 2021 06:29:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznAyPLBmRbTrAtsfoXI6wrxWQX7kS7AYx9cUSHIaxtMN8RgxFlMSUWsMBn6tza9ZZLHYyDug==
X-Received: by 2002:a50:c88d:: with SMTP id d13mr8667734edh.206.1613053765324;
        Thu, 11 Feb 2021 06:29:25 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id kz4sm4532925ejc.38.2021.02.11.06.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 06:29:24 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:29:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 12/17] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210211142921.ne5ics7b42gndc2a@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151747.805754-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151747.805754-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:17:44PM +0300, Arseny Krasnov wrote:
>This adds rest of logic for SEQPACKET:
>1) Packet's type is now set in 'virtio_send_pkt_info()' using
>   type of socket.
>2) SEQPACKET specific functions which send SEQ_BEGIN/SEQ_END.
>   Note that both functions may sleep to wait enough space for
>   SEQPACKET header.
>3) SEQ_BEGIN/SEQ_END to TAP packet capture.
>4) Send SHUTDOWN on socket close for SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  9 +++
> net/vmw_vsock/virtio_transport_common.c | 99 +++++++++++++++++++++----
> 2 files changed, 95 insertions(+), 13 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index a5e8681bfc6a..c4a39424686d 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -41,6 +41,7 @@ struct virtio_vsock_sock {
> 	u32 user_read_seq_len;
> 	u32 user_read_copied;
> 	u32 curr_rx_msg_cnt;
>+	u32 next_tx_msg_cnt;
> };
>
> struct virtio_vsock_pkt {
>@@ -85,7 +86,15 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+int virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len, int flags);
>+int virtio_transport_seqpacket_seq_send_eor(struct vsock_sock *vsk, int flags);
> size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
>+int
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
>+
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 51b66f8dd7c7..0aa0fd33e9d6 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -139,6 +139,8 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 		break;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
>+	case VIRTIO_VSOCK_OP_SEQ_END:
> 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
> 		break;
> 	default:
>@@ -165,6 +167,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
>
>+static u16 virtio_transport_get_type(struct sock *sk)
>+{
>+	if (sk->sk_type == SOCK_STREAM)
>+		return VIRTIO_VSOCK_TYPE_STREAM;
>+	else
>+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>+}
>+

Maybe add this function in this part of the file from the first patch, 
so you don't need to move it in this series.

> /* This function can only be used on connecting/connected sockets,
>  * since a socket assigned to a transport is required.
>  *
>@@ -179,6 +189,13 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	struct virtio_vsock_pkt *pkt;
> 	u32 pkt_len = info->pkt_len;
>
>+	info->type = virtio_transport_get_type(sk_vsock(vsk));

I'd this change in another patch before this one, since this touch also 
the stream part.

>+
>+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
>+	    info->msg &&
>+	    info->msg->msg_flags & MSG_EOR)
>+		info->flags |= VIRTIO_VSOCK_RW_EOR;
>+
> 	t_ops = virtio_transport_get_ops(vsk);
> 	if (unlikely(!t_ops))
> 		return -EFAULT;
>@@ -397,13 +414,61 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>-static u16 virtio_transport_get_type(struct sock *sk)
>+static int virtio_transport_seqpacket_send_ctrl(struct vsock_sock *vsk,
>+						int type,
>+						size_t len,
>+						int flags)
> {
>-	if (sk->sk_type == SOCK_STREAM)
>-		return VIRTIO_VSOCK_TYPE_STREAM;
>-	else
>-		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt_info info = {
>+		.op = type,
>+		.vsk = vsk,
>+		.pkt_len = sizeof(struct virtio_vsock_seq_hdr)
>+	};
>+
>+	struct virtio_vsock_seq_hdr seq_hdr = {
>+		.msg_cnt = vvs->next_tx_msg_cnt,
>+		.msg_len = len
>+	};
>+
>+	struct kvec seq_hdr_kiov = {
>+		.iov_base = (void *)&seq_hdr,
>+		.iov_len = sizeof(struct virtio_vsock_seq_hdr)
>+	};
>+
>+	struct msghdr msg = {0};
>+
>+	//XXX: do we need 'vsock_transport_send_notify_data' pointer?
>+	if (vsock_wait_space(sk_vsock(vsk),
>+			     sizeof(struct virtio_vsock_seq_hdr),
>+			     flags, NULL))
>+		return -1;
>+
>+	iov_iter_kvec(&msg.msg_iter, WRITE, &seq_hdr_kiov, 1, sizeof(seq_hdr));
>+
>+	info.msg = &msg;
>+	vvs->next_tx_msg_cnt++;
>+
>+	return virtio_transport_send_pkt_info(vsk, &info);
>+}
>+
>+int virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len, int flags)
>+{
>+	return virtio_transport_seqpacket_send_ctrl(vsk,
>+						    VIRTIO_VSOCK_OP_SEQ_BEGIN,
>+						    len,
>+						    flags);
> }
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_len);
>+
>+int virtio_transport_seqpacket_seq_send_eor(struct vsock_sock *vsk, int flags)
>+{
>+	return virtio_transport_seqpacket_send_ctrl(vsk,
>+						    VIRTIO_VSOCK_OP_SEQ_END,
>+						    0,
>+						    flags);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_eor);
>
> static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
> {
>@@ -577,6 +642,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>
>+int
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags, bool *msg_ready)
>+{
>+	if (flags & MSG_PEEK)
>+		return -EOPNOTSUPP;
>+
>+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>@@ -658,14 +735,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
> void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>+	int type;
>
> 	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> 		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
>
> 	vvs->buf_alloc = *val;
>
>-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
>-					    NULL);
>+	type = virtio_transport_get_type(sk_vsock(vsk));
>+	virtio_transport_send_credit_update(vsk, type, NULL);

I think we can remove the 'type' parameter of 
virtio_transport_send_credit_update() since 
virtio_transport_send_pkt_info() will overwrite it.

> }
> EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
>
>@@ -792,7 +870,6 @@ int virtio_transport_connect(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_REQUEST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.vsk = vsk,
> 	};
>
>@@ -804,7 +881,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.flags = (mode & RCV_SHUTDOWN ?
> 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> 			 (mode & SEND_SHUTDOWN ?
>@@ -833,7 +909,6 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RW,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.msg = msg,
> 		.pkt_len = len,
> 		.vsk = vsk,
>@@ -856,7 +931,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.reply = !!pkt,
> 		.vsk = vsk,
> 	};

These changes could go with the new patch to handle the type directly in 
the virtio_transport_send_pkt_info().


>@@ -1001,7 +1075,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
> 	struct sock *sk = &vsk->sk;
> 	bool remove_sock = true;
>
>-	if (sk->sk_type == SOCK_STREAM)
>+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
> 		remove_sock = virtio_transport_close(vsk);
>
> 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
>@@ -1164,7 +1238,6 @@ virtio_transport_send_response(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RESPONSE,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
> 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
> 		.reply = true,

Also this one.

Thanks,
Stefano

