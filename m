Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA8322B99
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhBWNnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:43:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232628AbhBWNng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:43:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614087729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T755Caf6XtrQLBTeIFHgN6zyFn1ttppOwK8TU+o0JY4=;
        b=egiM21JAgBMEvb94EDBCSfTXqm6la5oIvCFi13h3ZGdZEHpYWON26ok5WIy2Vj0MIiwVYX
        au9Yjtt9kRI74ALpVrgbXEZc64BJ9KfxB15IwxsYPtY3O+qNUmouypFjxBPC5N+MPBI8X+
        8wsjmh9jLulsmX45GDc8xo3jxGi2dPY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-AIyCoWPEMyyNQshpZoN8Pw-1; Tue, 23 Feb 2021 08:42:07 -0500
X-MC-Unique: AIyCoWPEMyyNQshpZoN8Pw-1
Received: by mail-wm1-f71.google.com with SMTP id p8so1208473wmq.7
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T755Caf6XtrQLBTeIFHgN6zyFn1ttppOwK8TU+o0JY4=;
        b=C1R/vC8G9IfOvz1E7gC/fnDGkEj5A8MB5sXkbxnW7lDc1wytRrv4l/WUtnOEtTm01m
         LAttLFoZPWaCosnCo0VeggSbML3yDmJ9E3SXG55A7lG31XnhrZpVZhaaBHaWybBqwE2t
         EWzhyLTmi+sMlxQMxx5ZUZSq4d0Q5Rc0+x8k4hdV3C0JXiwbPQFZJqtpWOrvo2/WEeX1
         LugFtP0BA5Ugn1A1TktC3clcMwBJh02g6Hyzy6NT5cj2CVAJHk01gbuoV8srIJwMndtr
         NXvWlt2vC+JeRkCetBJr9JRYShTHrGqxokSaqsOQmbgn9nXOk+yk0r5dB3UV8W5N/JmT
         rzkg==
X-Gm-Message-State: AOAM531gkr7NGhE2JbedWlFMQOt6lZEY1I5bJZ4WHxC5eBN58HWbGwIs
        1gUzsY2gRrIMr3wtE+Kt+c39jEJVtmGLhkqljglgKg9ZlM+B6uYqH9kKJtO++kZonoqOuNbRID2
        /XIDKqBsvdYf9f7Tl
X-Received: by 2002:adf:ee84:: with SMTP id b4mr26135699wro.339.1614087726316;
        Tue, 23 Feb 2021 05:42:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZVU1NvopjmxfatT6LCxEP+oMjLr10zL2agkulUPEA937Vn2kT6c6DL5dAaA4iEyqUcHv2ig==
X-Received: by 2002:adf:ee84:: with SMTP id b4mr26135672wro.339.1614087726037;
        Tue, 23 Feb 2021 05:42:06 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id 6sm40195921wra.63.2021.02.23.05.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 05:42:05 -0800 (PST)
Date:   Tue, 23 Feb 2021 14:42:02 +0100
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
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 09/19] virtio/vsock: set packet's type in send
Message-ID: <20210223134202.qepkmphp34onaesw@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053906.1067920-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053906.1067920-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The title is a little cryptic, maybe a something like:

virtio/vsock: set packet's type in virtio_transport_send_pkt_info()

On Thu, Feb 18, 2021 at 08:39:02AM +0300, Arseny Krasnov wrote:
>This moves passing type of packet from 'info' srtucture to send

Also here replace send with the function name.

>function. There is no sense to set type of packet which differs
>from type of socket, and since at current time only stream type
>is supported, so force to use this type.

I'm not a native speaker, but I would rephrase a bit the commit message:

     There is no need to set type of packet which differs from type of 
     socket. Since at current time only stream type is supported, set
     it directly in virtio_transport_send_pkt_info(), so callers don't 
     need to set it.

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)

If I haven't missed something, we can remove 'type' parameter also from 
virtio_transport_send_credit_update(), right?


>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index e4370b1b7494..1c9d71ca5e8e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -179,6 +179,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	struct virtio_vsock_pkt *pkt;
> 	u32 pkt_len = info->pkt_len;
>
>+	info->type = VIRTIO_VSOCK_TYPE_STREAM;
>+
> 	t_ops = virtio_transport_get_ops(vsk);
> 	if (unlikely(!t_ops))
> 		return -EFAULT;
>@@ -624,7 +626,6 @@ int virtio_transport_connect(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_REQUEST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.vsk = vsk,
> 	};
>
>@@ -636,7 +637,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.flags = (mode & RCV_SHUTDOWN ?
> 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
> 			 (mode & SEND_SHUTDOWN ?
>@@ -665,7 +665,6 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RW,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.msg = msg,
> 		.pkt_len = len,
> 		.vsk = vsk,
>@@ -688,7 +687,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RST,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.reply = !!pkt,
> 		.vsk = vsk,
> 	};
>@@ -990,7 +988,6 @@ virtio_transport_send_response(struct vsock_sock *vsk,
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RESPONSE,
>-		.type = VIRTIO_VSOCK_TYPE_STREAM,
> 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
> 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
> 		.reply = true,
>-- 
>2.25.1
>

