Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B6C3DE081
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhHBUOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:14:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhHBUOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627935230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvAKbFSCFU59TOTJPC3/cAvD7UXJ3lZqXOvWWs7Do/0=;
        b=hSuLcPG1CJzhYeh0bNxDwujwAgNKqr623VzF/Ngsv6byu2CweCHJyJYIGqyOE/NLYLdBzg
        s2gdJzx2ylRLI/Ad+0LC6Q4JelJ/myCBj8tBsPT80ieY/JgyF2pBWj6pmTwYHAz3i4bis+
        DnatKFXq764j6x6kR8wo7K0pDn8frw4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-r56jux-rNBKUFZm9nSOMmA-1; Mon, 02 Aug 2021 16:13:49 -0400
X-MC-Unique: r56jux-rNBKUFZm9nSOMmA-1
Received: by mail-ed1-f71.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso9438575edb.8
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:13:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lvAKbFSCFU59TOTJPC3/cAvD7UXJ3lZqXOvWWs7Do/0=;
        b=U3nNgdp+6SrgBIZ+oSh9xlnB2I85Ag0y3LsFGMBJ6LXFXnLsbIoUEFKrVevMqHT8aE
         LVy0o0ERmkbh6SSazvAu96LIBcsSLpsdobj7b6DKxALbP0iZ3q/TbhnvhVrRQ2qGLk99
         RQw95NZoUscUlUHggsBBe9x7l1Tals1vrYUO4YoRFNuZ0c4YStg4d0AbFX2zJME+5yrY
         //XlV6TeUNumYrNvSS7s43UBjnWTNdfY8aUFKRYDIRc3bXQZ3o2pvXch0HmJVykgJ3RH
         ADwIOj6Z9dBU3WdQmTWTvtZliPV4QZyZacfWWy0tRy9v4J26JsEniM/zptMolXiaJfOP
         M/qQ==
X-Gm-Message-State: AOAM530HF3ltKm58VRR+mZYturECIcOEVp0CanbTtASlTWgsVajjNCa5
        vkWRJhAh1DD7DasM9xXwgrk+3XmWl6todTzct4zQx027dfed8TgEjIH8qamM5lTKtYXasSV0h8Y
        ynRd6cNCo0tKnJAtH
X-Received: by 2002:a50:9350:: with SMTP id n16mr21099672eda.176.1627935228271;
        Mon, 02 Aug 2021 13:13:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU6tBMdbFDrItN+Pjs2g1o8FRDEi2q6zyU0jPrfqeUAovxmkXpeJ8x0MoP+XNjVZM/InUOOA==
X-Received: by 2002:a50:9350:: with SMTP id n16mr21099649eda.176.1627935228137;
        Mon, 02 Aug 2021 13:13:48 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id yc29sm5141187ejb.104.2021.08.02.13.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:13:47 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:13:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] VSOCK DRIVER: support communication using additional
 guest cid
Message-ID: <20210802161257-mutt-send-email-mst@kernel.org>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
 <20210802120720.547894-3-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-3-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:18PM +0800, fuguancheng wrote:
> Changes in this patch are made to allow the guest communicate
> with the host using the additional cids specified when
> creating the guest.
> 
> In original settings, the packet sent with the additional CIDS will
> be rejected when received by the host, the newly added function
> vhost_vsock_contain_cid will fix this error.
> 
> Now that we have multiple CIDS, the VMADDR_CID_ANY now behaves like
> this:
> 1. The client will use the first available cid specified in the cids
> array if VMADDR_CID_ANY is used.
> 2. The host will still use the original default CID.
> 3. If a guest server binds to VMADDR_CID_ANY, then the server can
> choose to connect to any of the available CIDs for this guest.
> 
> Signed-off-by: fuguancheng <fuguancheng@bytedance.com>
> ---
>  drivers/vhost/vsock.c                   | 14 +++++++++++++-
>  net/vmw_vsock/af_vsock.c                |  2 +-
>  net/vmw_vsock/virtio_transport_common.c |  5 ++++-
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f66c87de91b8..013f8ebf8189 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -74,6 +74,18 @@ struct vhost_vsock {
>  	bool seqpacket_allow;
>  };
>  
> +static bool
> +vhost_vsock_contain_cid(struct vhost_vsock *vsock, u32 cid)
> +{
> +	u32 index;
> +
> +	for (index = 0; index < vsock->num_cid; index++) {
> +		if (cid == vsock->cids[index])
> +			return true;
> +	}
> +	return false;
> +}
> +
>  static u32 vhost_transport_get_local_cid(void)
>  {
>  	return VHOST_VSOCK_DEFAULT_HOST_CID;

Doing this linear scan on data path is not going to scale
well with lots of CIDs.

> @@ -584,7 +596,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  
>  		/* Only accept correctly addressed packets */
>  		if (vsock->num_cid > 0 &&
> -		    (pkt->hdr.src_cid) == vsock->cids[0] &&
> +			vhost_vsock_contain_cid(vsock, pkt->hdr.src_cid) &&
>  		    le64_to_cpu(pkt->hdr.dst_cid) == vhost_transport_get_local_cid())
>  			virtio_transport_recv_pkt(&vhost_transport, pkt);
>  		else
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 4e1fbe74013f..c22ae7101e55 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -251,7 +251,7 @@ static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>  	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
>  			    connected_table) {
>  		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
> -		    dst->svm_port == vsk->local_addr.svm_port) {
> +		    vsock_addr_equals_addr(&vsk->local_addr, dst)) {
>  			return sk_vsock(vsk);
>  		}
>  	}
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 169ba8b72a63..cb45e2f801f1 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -197,7 +197,10 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  	if (unlikely(!t_ops))
>  		return -EFAULT;
>  
> -	src_cid = t_ops->transport.get_local_cid();
> +	if (vsk->local_addr.svm_cid != VMADDR_CID_ANY)
> +		src_cid = vsk->local_addr.svm_cid;
> +	else
> +		src_cid = t_ops->transport.get_local_cid();
>  	src_port = vsk->local_addr.svm_port;
>  	if (!info->remote_cid) {
>  		dst_cid	= vsk->remote_addr.svm_cid;
> -- 
> 2.11.0
> 
> 

