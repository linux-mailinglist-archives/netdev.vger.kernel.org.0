Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8133B124
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCOL36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:29:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhCOL3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1+7AUzrzm8HAwAnNkO+PDguvC47LB5o6Xz8fUn4oHzc=;
        b=cAVkKJghkyTwlNk4NqOLqTmWgkmXUrZnNWhVNe1TvNtp0pdjg7AN5GxKcEAIqyehLTLSHE
        xPrX+s9EVgOqnXdNQ33ogp7sBk1ymMfsTiGRP+A8TkRYo0F+91JfEFYuOm0nds3MLt8MZv
        p4B33M4LdYNvQuZ3sLESc2ZbbXzClCw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-oZ2RKxSSNiS481u474yJ6A-1; Mon, 15 Mar 2021 07:29:31 -0400
X-MC-Unique: oZ2RKxSSNiS481u474yJ6A-1
Received: by mail-wr1-f72.google.com with SMTP id 75so14849312wrl.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1+7AUzrzm8HAwAnNkO+PDguvC47LB5o6Xz8fUn4oHzc=;
        b=DKOYaQs031z3Q8HLrARgZuM/67+OQlgx2rWyuZfUa6PxWiRiQkEB5i+ElZBw0Uobz7
         SdvNgTOmuvBbYZIamQ0NkdpMw/VW5QWlxpNW+R+mVt6S/jzfSsaw0KWfL3os210yPkhn
         iwV2Jir690tng3THNKs8gcRmuDgyD9qrsh4O0Sgnz4q5S7+bBmwu3pc8eN0GhtcUnieb
         5sODp8AQn8W+pCdmmJQiqGnd8ZBzgznaPAjBUHbC0BySigZVW2XGFnOOlbCmkHiE0/H1
         M4Wy4ntgavXKBU9Dv/vHcljNmsvzJHKQ3DuitBhbkjjYqJDiyj8r76phYWQSsk4mrlbx
         cLfg==
X-Gm-Message-State: AOAM530XChVcsreqY72Y4vCEE3zq2bvkF7LwL2yGxkfCcTFGZbnvlexf
        eAaPp4sOnKQMVMJ+5sV0QIbYdosirWGz/3m93xti8krZstIZCug2XogiDReVE6uMQtrpBwbt/hz
        X/hSyFPlIhW+7kxDW
X-Received: by 2002:a5d:4d0f:: with SMTP id z15mr27172924wrt.192.1615807770754;
        Mon, 15 Mar 2021 04:29:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPaa1RsYizJWQVGBx3qj8UyDGlrRh47JNGjq0sqiNSmbivdESKClpUjnV47KEmVgApFQQIBA==
X-Received: by 2002:a5d:4d0f:: with SMTP id z15mr27172900wrt.192.1615807770597;
        Mon, 15 Mar 2021 04:29:30 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s16sm18201253wru.91.2021.03.15.04.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:29:30 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:29:27 +0100
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
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 17/22] virtio/vsock: SEQPACKET feature bit support
Message-ID: <20210315112927.4aygxeby2f7p3mju@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180404.3466602-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180404.3466602-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:04:01PM +0300, Arseny Krasnov wrote:
>This adds handling of SEQPACKET bit: guest tries to negotiate it
>with vhost.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport.c | 5 +++++
> 1 file changed, 5 insertions(+)

Also for this patch I think is better to move after we set the 
seqpackets ops.

>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..41c5d0a31e08 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -612,6 +612,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>+
>+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>+		virtio_transport.seqpacket_allow = true;
>+
> 	return 0;
>
> out:
>@@ -695,6 +699,7 @@ static struct virtio_device_id id_table[] = {
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

