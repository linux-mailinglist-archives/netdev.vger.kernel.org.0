Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0633DE099
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhHBUVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:21:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhHBUVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627935704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZJ2bhBWwA0LZ+VBVsgySygKSYSWVNXAFAku40qnCTw=;
        b=KBAWnuKUDvr1WSF3sQsTXHCuR5GbVJDBDRWjpYmtV1xAHwjjuM2b3yd0+yOJ8dQYWgKEtT
        v+of01pJdxUrZS0vXJ0QqKNO1zlokt+U1oyADmLXjWtyXSnXAu1OyBK7ZjzhtMC0j5XrJb
        NOGmIlaFaPUXY3dgjvcMWXqyqQzmgCs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-CZ4EvMjLMdeY_WAjzjdxLw-1; Mon, 02 Aug 2021 16:21:43 -0400
X-MC-Unique: CZ4EvMjLMdeY_WAjzjdxLw-1
Received: by mail-ed1-f69.google.com with SMTP id v26-20020aa7d9da0000b02903bda706c753so341010eds.18
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZJ2bhBWwA0LZ+VBVsgySygKSYSWVNXAFAku40qnCTw=;
        b=OoIJly6MULU+aPQ/0oS6wRckJssjUZl3FHbVVDEusTqfEmM2QKEVShW6qcXlrKML/V
         HaCd3Ms7xrslQl8YYjQSSk7sjkdbeL9HhgeMjZ4hfmpHBNxzcr1US+wAazIipXgZaOsY
         xVQPZ/ucLX0qKQ1ushI/oZoR0BmKJ8/nLfNKvsnazpnUe8rLlbb3gQykPfN7CWP1BAJS
         x0XysuT+tTBFgVmjl8E39QXgrqYZ5myZyGE9nsbzjkriyRKgbyrrZcJZ9m5zX9oMHG9h
         DrLvL3sPgXl/4jdTdsMbiZVku53qDXxNIn4jtH0gDZgYh+cqZsUfzJvhGEsTXoLvK1Ug
         Gecw==
X-Gm-Message-State: AOAM5336FOjbCvYk1h6f92GtoNzpJIlvH9qX5DlkjAP4u8k0YFqyNML+
        Prt/qQSu74u9BV7UJEi6JoU5IMdYZuA6DtLdSjclvTVLCkKckXkxheorNXxqYHxAkhOksZNbOVA
        nFhd+WBkYDpCYbIdC
X-Received: by 2002:a05:6402:514e:: with SMTP id n14mr21858770edd.129.1627935702047;
        Mon, 02 Aug 2021 13:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLxuoBXOKeZ2Gk3OBbPWhzbkg9zy7nptJari08wguyDBRuf7wpsWw8MvrrZcTEuWohqALx5A==
X-Received: by 2002:a05:6402:514e:: with SMTP id n14mr21858756edd.129.1627935701885;
        Mon, 02 Aug 2021 13:21:41 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id k20sm5085851ejr.93.2021.08.02.13.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:21:41 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:21:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Add multi-cid support for vsock driver
Message-ID: <20210802162038-mutt-send-email-mst@kernel.org>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-1-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:16PM +0800, fuguancheng wrote:
> This patchset enables the user to specify additional CIDS for host and
> guest when booting up the guest machine. The guest's additional CIDS cannot
> be repeated, and can be used to communicate with the host. The user can
> also choose to specify a set of additional host cids, which can be
> used to communicate with the guest who specify them. The original
> CID(VHOST_DEFAULT_CID) is still available for host. The guest cid field is
> deleted.
> 
> To ensure that multiple guest CID maps to the same vhost_vsock struct,
> a struct called vhost_vsock_ref is added.  The function of vhost_vsock_ref
> is simply used to allow multiple guest CIDS map to the
> same vhost_vsock struct.
> 
> If not specified, the host and guest will now use the first CID specified
> in the array for connect operation. If the host or guest wants to use
> one specific CID, the bind operation can be performed before the connect
> operation so that the vsock_auto_bind operation can be avoided.
> 
> Hypervisors such as qemu needs to be modified to use this feature. The
> required changes including at least the following:
> 1. Invoke the modified ioctl call with the request code
> VHOST_VSOCK_SET_GUEST_CID. Also see struct multi_cid_message for
> arguments used in this ioctl call.
> 2. Write new arguments to the emulated device config space.
> 3. Modify the layout of the data written to the device config space.
> See struct virtio_vsock_config for reference.
> 
> I have tested this setup with iperf3.  The communication between host
> and guest using original CID or additional CIDS worked normally.
> Not tested in extreme conditions where memory is insufficient.
> 
> Linux kernel newbies here, any suggestions are welcomed.
> Thanks in advance!

Could you supply a bit info about the motivation for this feature?
I wonder whether it's be better to have multiple VQs
instead of tweaking the CID in the message header.


> fuguancheng (4):
>   VSOCK DRIVER: Add multi-cid support for guest
>   VSOCK DRIVER: support communication using additional guest cid
>   VSOCK DRIVER: support specifying additional cids for host
>   VSOCK DRIVER: support communication using host additional cids
> 
>  drivers/vhost/vsock.c                   | 338 ++++++++++++++++++++++++++++----
>  include/net/af_vsock.h                  |   5 +
>  include/uapi/linux/vhost.h              |   9 +
>  include/uapi/linux/virtio_vsock.h       |   8 +-
>  net/vmw_vsock/af_vsock.c                |  28 ++-
>  net/vmw_vsock/virtio_transport.c        | 129 +++++++++++-
>  net/vmw_vsock/virtio_transport_common.c |   5 +-
>  net/vmw_vsock/vsock_loopback.c          |   8 +
>  8 files changed, 471 insertions(+), 59 deletions(-)
> 
> -- 
> 2.11.0
> 
> 

