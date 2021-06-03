Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8339A4A8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFCPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229844AbhFCPgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622734507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HHcM+IgNoZ1DlGmkHUu2OKnC00B3Yz63C0t0xp+6d/4=;
        b=DdF0vWcGiUdmDTPoL9Zv/FvYlpMwaon6lGPgAaQJrkesNStC0gYajfaPOZfqbfw98/BfNr
        qhlWtigtt/nVefUg1jHbAG8zY+mCkQh++wUSLu6WOW0B97mP+DK+c5T9bzwvbj1dCt2x+G
        5hix03+/ZXUT77C2otGnXEXqGfNOAeI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-fdQde3XEO-CyaCU-05JxFw-1; Thu, 03 Jun 2021 11:35:05 -0400
X-MC-Unique: fdQde3XEO-CyaCU-05JxFw-1
Received: by mail-ed1-f69.google.com with SMTP id h16-20020a0564020950b029038cbdae8cbaso3451572edz.6
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HHcM+IgNoZ1DlGmkHUu2OKnC00B3Yz63C0t0xp+6d/4=;
        b=chzGwx5OimjZZR1JzjKbFRBydEdN/QPGChHIgdq6sIMWfLffliKTze5YEkfb4Npvfi
         9IhcJLWwqx/46/7U1//Qvd6Lrl/SzU8ZjvRnpkgR3sK+doTlmmJWRpj0NbOOGlaPUEFY
         gnBQLZniTmyMgg6IK3RzeSlQ1jDyuB+ChXOkjsBe4Cr9cdwUHqE7Woh0TFl865dOp20I
         kp5WOqD6zjIjE6nJ0tKLGJFLEd++PhViziGnn1wCEK9P9HcZS99iyTHbOwvGx40yr9Om
         ZhxnyWP1x/RM86l7LYpBCNGvQFcozJKYbXQevQR8JBYNJ8VeL0/6Dt8Rp7pED5ZP09XE
         zang==
X-Gm-Message-State: AOAM530Zd4QKOGFdmiFmcFi+IfIeOyK8HZNjmplnj4biuYdNF8gX01xf
        IZ1g2TGccYYyAcM+zWjXHX42aP8fYEe/M7NxrTx3HJBQfPv32mWNXas9n04xoVO9d4ESs0x1IID
        qFeOx+7aUaFypkgGJ
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr66151edx.189.1622734504255;
        Thu, 03 Jun 2021 08:35:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqFolPWO7BwpcoKlZ9srf0hFGk5LbsUjrn2R3ivE3G00+T3IVZ522WwOzS0fxGTdmkJwWkVw==
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr66134edx.189.1622734504040;
        Thu, 03 Jun 2021 08:35:04 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id p13sm1920100edq.67.2021.06.03.08.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:35:03 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:34:59 +0200
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
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 15/18] vhost/vsock: support SEQPACKET for transport
Message-ID: <20210603153459.4qncp25nssuby4vp@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191916.1272540-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191916.1272540-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:19:13PM +0300, Arseny Krasnov wrote:

Please describe better the changes included in this patch in the first 
part of the commit message.

>As vhost places data in buffers of guest's rx queue, keep SEQ_EOR
>bit set only when last piece of data is copied. Otherwise we get
>sequence packets for one socket in guest's rx queue with SEQ_EOR bit
>set. Also remove ignore of non-stream type of packets, handle SEQPACKET
>feature bit.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Move 'restore_flag' handling to 'payload_len' calculation
>    block.
>
> drivers/vhost/vsock.c | 44 +++++++++++++++++++++++++++++++++++++++----
> 1 file changed, 40 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..63d15beaad05 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -31,7 +31,8 @@
>
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> };
>
> enum {
>@@ -56,6 +57,7 @@ struct vhost_vsock {
> 	atomic_t queued_replies;
>
> 	u32 guest_cid;
>+	bool seqpacket_allow;
> };
>
> static u32 vhost_transport_get_local_cid(void)
>@@ -112,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t nbytes;
> 		size_t iov_len, payload_len;
> 		int head;
>+		bool restore_flag = false;
>
> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -168,9 +171,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		/* If the packet is greater than the space available in the
> 		 * buffer, we split it using multiple buffers.
> 		 */
>-		if (payload_len > iov_len - sizeof(pkt->hdr))
>+		if (payload_len > iov_len - sizeof(pkt->hdr)) {
> 			payload_len = iov_len - sizeof(pkt->hdr);
>

Please, add a comment here to explain why we need this.

>+			if (le32_to_cpu(pkt->hdr.flags) & 
>VIRTIO_VSOCK_SEQ_EOR) {
>+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+				restore_flag = true;
>+			}
>+		}
>+
> 		/* Set the correct length in the header */
> 		pkt->hdr.len = cpu_to_le32(payload_len);
>
>@@ -181,6 +190,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock 
>*vsock,
> 			break;
> 		}
>
>+		if (restore_flag)
>+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+

Maybe we can restore the flag only if we are queueing again the same 
packet, I mean in the `if (pkt->off < pkt->len) {` branch below.

What do you think?

> 		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
> 				      &iov_iter);
> 		if (nbytes != payload_len) {
>@@ -354,8 +366,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>-		pkt->len = le32_to_cpu(pkt->hdr.len);
>+	pkt->len = le32_to_cpu(pkt->hdr.len);
>
> 	/* No payload */
> 	if (!pkt->len)
>@@ -398,6 +409,8 @@ static bool vhost_vsock_more_replies(struct 
>vhost_vsock *vsock)
> 	return val < vq->num;
> }
>
>+static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>+
> static struct virtio_transport vhost_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -424,6 +437,10 @@ static struct virtio_transport vhost_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -441,6 +458,22 @@ static struct virtio_transport vhost_transport = {
> 	.send_pkt = vhost_transport_send_pkt,
> };
>
>+static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>+{
>+	struct vhost_vsock *vsock;
>+	bool seqpacket_allow = false;
>+
>+	rcu_read_lock();
>+	vsock = vhost_vsock_get(remote_cid);
>+
>+	if (vsock)
>+		seqpacket_allow = vsock->seqpacket_allow;
>+
>+	rcu_read_unlock();
>+
>+	return seqpacket_allow;
>+}
>+
> static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> {
> 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
>@@ -785,6 +818,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> 			goto err;
> 	}
>
>+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>+		vsock->seqpacket_allow = true;
>+
> 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> 		vq = &vsock->vqs[i];
> 		mutex_lock(&vq->mutex);
>-- 
>2.25.1
>

