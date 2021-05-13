Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD37C37F832
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhEMMup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:50:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233927AbhEMMua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 08:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620910159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSrjqlQIJu1uxoxnuhMrvLQLzbH8gXslRcYpELalTPg=;
        b=e7dXwUSFI96vbLYa3PgAFgor6NPbkEE4LFJ/FKXEzXtC48NQuOSz4FckURGUOLYx2vIcLF
        IP/oNywB06GZFJzfeQObnpXCev2Lq0rckUDaZ2FL2LHCOpNuDXJB91lL6z0g/mhNtUf2tG
        JyNz9TZBDXxq7nUQ4U4jqgktwMNcHkI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-jM6nwERMN22OgNoL6nBGPA-1; Thu, 13 May 2021 08:49:16 -0400
X-MC-Unique: jM6nwERMN22OgNoL6nBGPA-1
Received: by mail-ed1-f69.google.com with SMTP id i3-20020aa7dd030000b029038ce772ffe4so181213edv.12
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 05:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NSrjqlQIJu1uxoxnuhMrvLQLzbH8gXslRcYpELalTPg=;
        b=uM+XLzrv9lTqsniTBURt0Nhv69a7T1bFgZuctd/jEcQo60s5eewZ7lzk4i0QNeWeWz
         QBfSgmaVL/d+oHJydm6DCISyapQ2XIBU/tTDx3qSfeewnv4zcJpNTZl9Us4o/OzRCosd
         RSC1NxWaEdoZ5SlIdrUxz5d6//JpI9eHDjdWxU9H7tSi27svfguS7Jsv4GNdQPnc1S43
         0bBU3668Ugttc+TCeSPLwrA1WMZGjWiLA+EgcLyu4QDqj5gaDTNQZKp8yyCJ5zGwY09e
         eJjoBp5yM9ZC/kjN1uaAKdZxAO9oQI5yBJApMoug8r4ybKCy5Jy/OWgeKqOj28z1CHEG
         iKew==
X-Gm-Message-State: AOAM532joJV2RwSg8sU1aVHgHbIBxgUVS44qD3ZiAfgI4Dpye7+UroJ2
        rniIDLFqUbFdASPlFn+bqBQsRhGvN+G5oWHjKCYdxlq/Yh4RlpWy6mBix4PXoh9j4qdWzyD4av7
        yMYbe88gC/M/TdZcb
X-Received: by 2002:a17:906:144d:: with SMTP id q13mr45360838ejc.458.1620910155410;
        Thu, 13 May 2021 05:49:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoWSdvzLm133gY1yGZQzxSLocSHvkGSmNAzGowvENZeAXfZJswxcWVjdFLnXw30TfArShrKw==
X-Received: by 2002:a17:906:144d:: with SMTP id q13mr45360828ejc.458.1620910155258;
        Thu, 13 May 2021 05:49:15 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id j22sm1873651ejt.11.2021.05.13.05.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:49:14 -0700 (PDT)
Date:   Thu, 13 May 2021 14:49:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 14/19] virtio/vsock: enable SEQPACKET for transport
Message-ID: <20210513124912.sw4rea75re7xwjdz@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163617.3432380-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163617.3432380-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:36:14PM +0300, Arseny Krasnov wrote:
>This adds
>1) SEQPACKET ops for virtio transport and 'seqpacket_allow()' callback.
>2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Move 'seqpacket_allow' to 'struct virtio_vsock'.
>
> net/vmw_vsock/virtio_transport.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..f714c16af65d 100644
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
>@@ -443,6 +444,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
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
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
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
>@@ -612,6 +632,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>+
>+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))

We should use virtio_has_feature() to check the device features.

>+		vsock->seqpacket_allow = true;

When we assign the_virtio_vsock pointer, we should already set all the 
fields, so please move this code before the following block:

	# here

	vdev->priv = vsock;
	rcu_assign_pointer(the_virtio_vsock, vsock);

