Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7C39A474
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhFCPX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231917AbhFCPXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622733730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tk288Zz+uIifCmQruWzx1HX+KXbfFOTwP0kxM+VMUEc=;
        b=U8LwQwctwhWDGUPTzbAdEPnOu+DroSh7QMht5ehK558ivZu1syxHd+HELRIWnTeV+atK2x
        2+8R8m9EIcaPLA5zHQ5CcxMvyjrUD759HOdDZRTTHW7cuS7obrO9B1UST53p/qzOYVaijv
        cWgsyfgi8Q/LNNiX+O/6xA7GwADSO+o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-SVEoN1JhOPG87LCU7_8fdA-1; Thu, 03 Jun 2021 11:22:08 -0400
X-MC-Unique: SVEoN1JhOPG87LCU7_8fdA-1
Received: by mail-ed1-f71.google.com with SMTP id dd28-20020a056402313cb029038fc9850034so3457889edb.7
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tk288Zz+uIifCmQruWzx1HX+KXbfFOTwP0kxM+VMUEc=;
        b=MnI5T9ZGd24bMvnkzQrhgZ3jkbsaSZkBqiOCI+MNpIZ/DepZCa+dSOJf8iCm8HS5fM
         4UMk095RFqIoTauoXuuAc29X+yDVNEAmZnBIeb9TqlFpGH+2xqxiP7oaXEA+0FvnI10B
         5+H+6ogwSYg0OgVCoK38Sek69kYlrreisLWGHSxea/NEsH9VEkly063EqGGa9Znb9ePm
         iNBEaAiPLqqkp9FBlhHTwnXxxWoVLICWV0iiAsTj2lxa3sgtP/E79yP+wS2r2MKfD3vx
         Zk2wAsGhRSDGbNi0p0XsJoPEdkzqZXxmbQ3bFxLXUqZ3kYd8vcjiNil5Ma4dsbqrYTD6
         UbxA==
X-Gm-Message-State: AOAM532/7uYiNaRWTMLy51E5dB3K7OOGysylFKwd0tArrHU+FRJYHtQv
        MDf/Vgw7bOrbXODU46sEI/qBbevJo7sXnhUEKLQ2jlF0WKx2z/lrxga0SqEzqIWpDPILeo4NyMK
        f9B97D1Tl+8mrvl2h
X-Received: by 2002:a17:906:6c88:: with SMTP id s8mr125411ejr.129.1622733727730;
        Thu, 03 Jun 2021 08:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoln++JLRLzRUvRIPFKCkhnzbJCumWsfqvvpdAzdKrFm/EKznU/MHMYhIJo8u5lC88unTUOw==
X-Received: by 2002:a17:906:6c88:: with SMTP id s8mr125391ejr.129.1622733727545;
        Thu, 03 Jun 2021 08:22:07 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id z22sm1197140ejm.71.2021.06.03.08.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:22:07 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:22:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 14/18] virtio/vsock: enable SEQPACKET for transport
Message-ID: <20210603152203.gezrjp2xiv53eqpm@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191901.1272423-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191901.1272423-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:18:57PM +0300, Arseny Krasnov wrote:
>To make transport work with SOCK_SEQPACKET two updates were
>added:

Present is better, and you can also mention that we enable it only if 
the feature is negotiated with the device.

>1) SOCK_SEQPACKET ops for virtio transport and 'seqpacket_allow()'
>   callback.
>2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Use 'virtio_has_feature()' to check feature bit.
> 2) Move assignment to 'seqpacket_allow' before 'rcu_assign_pointer()'.
>
> net/vmw_vsock/virtio_transport.c | 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..bc5ee8df723a 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -62,6 +62,7 @@ struct virtio_vsock {
> 	struct virtio_vsock_event event_list[8];
>
> 	u32 guest_cid;
>+	bool seqpacket_allow;
> };
>
> static u32 virtio_transport_get_local_cid(void)
>@@ -443,6 +444,8 @@ static void virtio_vsock_rx_done(struct virtqueue 
>*vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>+
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -469,6 +472,10 @@ static struct virtio_transport virtio_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = 
>virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = virtio_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -485,6 +492,19 @@ static struct virtio_transport virtio_transport = {
> 	.send_pkt = virtio_transport_send_pkt,
> };
>
>+static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>+{
>+	struct virtio_vsock *vsock;
>+	bool seqpacket_allow;
>+
>+	rcu_read_lock();
>+	vsock = rcu_dereference(the_virtio_vsock);
>+	seqpacket_allow = vsock->seqpacket_allow;
>+	rcu_read_unlock();
>+
>+	return seqpacket_allow;
>+}
>+
> static void virtio_transport_rx_work(struct work_struct *work)
> {
> 	struct virtio_vsock *vsock =
>@@ -608,6 +628,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	vsock->event_run = true;
> 	mutex_unlock(&vsock->event_lock);
>
>+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>+		vsock->seqpacket_allow = true;
>+
> 	vdev->priv = vsock;
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
>@@ -695,6 +718,7 @@ static struct virtio_device_id id_table[] = {
> };
>
> static unsigned int features[] = {
>+	VIRTIO_VSOCK_F_SEQPACKET
> };
>
> static struct virtio_driver virtio_vsock_driver = {
>-- 
>2.25.1
>

