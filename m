Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D142FA6A7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405931AbhARQr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:47:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405597AbhARPRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xcaqopXIlvlEXLRCW3l9OfviX/eFyfP/wopbLVj233M=;
        b=CHJN1lWwx3j9+36/QougdnoqRJ30s7ZYBWXt9hFgKyJisYfsT0hI7ceNQn+W+5JMjUdcTA
        w5VPnuLr+FU2z8PrUFz0bcqMfpBTN1h99BnqOtkpFOdXcgY12QtEPJCHd7fIvbyRCEXLKY
        02jUdT1uqTdqsx0eSx9rIrs9uf5JKLU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-rNow4s20NmSnC1eEaeJbNA-1; Mon, 18 Jan 2021 10:15:39 -0500
X-MC-Unique: rNow4s20NmSnC1eEaeJbNA-1
Received: by mail-wr1-f72.google.com with SMTP id g17so8410359wrr.11
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:15:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xcaqopXIlvlEXLRCW3l9OfviX/eFyfP/wopbLVj233M=;
        b=LDjIk1bqyvuRgr4ECk7Vef6BXaMTyqkwgM8402NFVkpKqOtVuoCjh3BilfPuxDKz2D
         tLi7oU2Jo6mDBz/trpXaNGe3bRbcDJh5GYW5gXDTMNBlkUkF6CAH4TwUvxn6aY4BL/Yr
         u7wLnZM57BcEiwgjhQq8+Bf3Qn9yt78NxQiAV8sfU34O/qx+Vt2Ey12rBFfZjTa06Fxd
         d5cdMqIgMnA9D8wWoLz2gc4V0OkwoyZkv80Bi04LLeoXQxlABhZMc/vetEPoRPx35iRT
         rV4Q9poNaFQv8K9Nv6Y2rDRg9bQjakXUlFE2B+j77x9q+QNXOENWabefzUPDmclDB3Q+
         cIgQ==
X-Gm-Message-State: AOAM531HXrRywrJHLu21AibJkA/KxD9BkL8dNqC+3yKty/t61oXDzc9g
        vlL0Cninw4wCwXKHBKl8pEUG1A4zNLtOAdmPnyVujmA/V0ucPWcB6NGapnQnqteWcVhcE6pL1nV
        5xxgN8V36l99nUGdJ
X-Received: by 2002:adf:8342:: with SMTP id 60mr26549270wrd.140.1610982938684;
        Mon, 18 Jan 2021 07:15:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwc7QTOAkMvdn8bwe1eCaMlvVb/4VRCysRSLWf+/IRHgXNYr1i0nxD/bAnSmDlH1IG2U6GWxQ==
X-Received: by 2002:adf:8342:: with SMTP id 60mr26549247wrd.140.1610982938516;
        Mon, 18 Jan 2021 07:15:38 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id h13sm29904915wrm.28.2021.01.18.07.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:15:37 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:15:35 +0100
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
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 11/13] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210118151535.ugjshvej3lrpnp3d@steredhat>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <20210115054426.1457041-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115054426.1457041-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:44:22AM +0300, Arseny Krasnov wrote:
>This adds rest of logic for SEQPACKET:
>1) Shared functions for packet sending now set valid type of packet
>   according socket type.
>2) SEQPACKET specific function like SEQ_BEGIN send and data dequeue.
>3) Ops for virtio transport.
>4) TAP support for SEQPACKET is not so easy if it is necessary to send
>   whole record to TAP interface. This could be done by allocating
>   new packet when whole record is received, data of record must be
>   copied to TAP packet.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  7 ++++
> net/vmw_vsock/virtio_transport.c        |  4 ++
> net/vmw_vsock/virtio_transport_common.c | 54 ++++++++++++++++++++++---
> 3 files changed, 59 insertions(+), 6 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index af8705ea8b95..ad9783df97c9 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -84,7 +84,14 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len);
> size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len,
>+				   int type);
>+
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..5a7ab1befee8 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -469,6 +469,10 @@ static struct virtio_transport virtio_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
>+		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index c3e07eb1c666..5fdf1adfdaab 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -139,6 +139,7 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 		break;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
> 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
> 		break;
> 	default:
>@@ -157,6 +158,10 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>
> void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
> {
>+	/* TODO: implement tap support for SOCK_SEQPACKET. */
>+	if (le32_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_SEQPACKET)
             ^
hdr.type is __le16, so please use le16_to_cpu()

>+		return;
>+
> 	if (pkt->tap_delivered)
> 		return;
>
>@@ -405,6 +410,19 @@ static u16 virtio_transport_get_type(struct sock *sk)
> 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
> }
>
>+bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len)
>+{
>+	struct virtio_vsock_pkt_info info = {
>+		.type = VIRTIO_VSOCK_TYPE_SEQPACKET,
>+		.op = VIRTIO_VSOCK_OP_SEQ_BEGIN,
>+		.vsk = vsk,
>+		.flags = len
>+	};
>+
>+	return virtio_transport_send_pkt_info(vsk, &info);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_len);
>+
> static inline void virtio_transport_del_n_free_pkt(struct virtio_vsock_pkt *pkt)
> {
> 	list_del(&pkt->list);
>@@ -576,6 +594,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len, int flags)
>+{
>+	if (flags & MSG_PEEK)
>+		return -EOPNOTSUPP;
>+
>+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, len);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>@@ -659,13 +689,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
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
>+	type = virtio_transport_get_type(sk_vsock(vsk));
>+	virtio_transport_send_credit_update(vsk, type,
> 					    NULL);

With this change, you can move 'NULL' in the previous line.

> }
> EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
>@@ -793,10 +825,11 @@ int virtio_transport_connect(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_REQUEST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.vsk = vsk,
> 	};
>
>+	info.type = virtio_transport_get_type(sk_vsock(vsk));
>+
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_connect);
>@@ -805,7 +838,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.flags = (mode & RCV_SHUTDOWN ?
> 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> 			 (mode & SEND_SHUTDOWN ?
>@@ -813,6 +845,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> 		.vsk = vsk,
> 	};
>
>+	info.type = virtio_transport_get_type(sk_vsock(vsk));
>+
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
>@@ -834,12 +868,18 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RW,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.msg = msg,
> 		.pkt_len = len,
> 		.vsk = vsk,
>+		.flags = 0,
> 	};
>
>+	info.type = virtio_transport_get_type(sk_vsock(vsk));
>+
>+	if (info.type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
>+	    msg->msg_flags & MSG_EOR)
>+		info.flags |= VIRTIO_VSOCK_RW_EOR;
>+
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_enqueue);
>@@ -857,7 +897,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.reply = !!pkt,
> 		.vsk = vsk,
> 	};
>@@ -866,6 +905,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
> 	if (pkt && le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
> 		return 0;
>
>+	info.type = virtio_transport_get_type(sk_vsock(vsk));
>+
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
>
>@@ -1177,13 +1218,14 @@ virtio_transport_send_response(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RESPONSE,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
> 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
> 		.reply = true,
> 		.vsk = vsk,
> 	};
>
>+	info.type = virtio_transport_get_type(sk_vsock(vsk));
>+
> 	return virtio_transport_send_pkt_info(vsk, &info);
> }
>
>-- 
>2.25.1
>

