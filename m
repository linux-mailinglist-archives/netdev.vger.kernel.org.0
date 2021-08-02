Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169BE3DE046
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhHBTqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhHBTqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 15:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627933574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u4LSyR/0hL97TpqHNN7IRSJmq939orqyXRewz9/HhmU=;
        b=DnsxoZIr7cBwKawm3gdKJJmiFfByy0pbZZ0dI3n5SpMT+mrwlWhG0JOQGTGOAyVb5EyBk/
        gmN6DXD5wwEbYEgc7YkeNgWOgVmxB5++E7sr/Wt6JdTM4nHUkWSs+s0SNEZB9R9o4MwfAM
        1Wf9sUobgbAECXcTjmnSuiZIdya9YBk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-7nACE5CUMZaBYX_UPnwkAw-1; Mon, 02 Aug 2021 15:46:12 -0400
X-MC-Unique: 7nACE5CUMZaBYX_UPnwkAw-1
Received: by mail-ed1-f69.google.com with SMTP id eg53-20020a05640228b5b02903bd6e6f620cso1999302edb.23
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 12:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4LSyR/0hL97TpqHNN7IRSJmq939orqyXRewz9/HhmU=;
        b=FwHdDzC6IInZYND3bATWAS/MWZbfEn6K9Ocq0Vn5dPctI2TMBg42MAMBiP3KVih7l8
         cI7PhPp/nwZjIc7NID0IvBOJ/ALAgrC7s5U4QQZIAESsEXS8JfIu8FoYeAAnc7/KEjnV
         XfxeT6FESdUD1Db4PWp3pt1bfvGDfLkPprN1BDoHU/XV8YPcNwvwSZacRBlcgkaxklSB
         voo9orz7YTakeSEIunL2dPwZpEeRf3G3Wli84l6v0dd5p49GEZviUyxqKyHpGP7O3C9J
         wVqNIwo5SdYofnHXQ4pcQYti8gIuFBXSikAwjC8+7Odx5hS7VTPRa3wWyLlKOOyRInlc
         T/nQ==
X-Gm-Message-State: AOAM532t5EWRK8sd40eYAT4gJo52exxRTFkO78fQSSN9i+TR2ObUl/j8
        cQ1rYJspZulnZOp6unraKHNfYN7aZ2JSWCu8vOPiaZEmpaQ5Oa0qGqilUp2ruWw0kmDYe/cQOnv
        wAuE1ZX72rZG7DTRq
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr22009504edd.126.1627933571723;
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUxeZQ8QWOaFM+a5MHs53Gufa4vyRbkQJ+aLrM7GKCmZ6HoO4YrMab1RKippOjDtVlBAYgBQ==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr22009484edd.126.1627933571594;
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id b3sm5036362ejb.7.2021.08.02.12.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:46:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, asias@redhat.com, imbrenda@linux.vnet.ibm.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
Message-ID: <20210802152624-mutt-send-email-mst@kernel.org>
References: <20210802173506.2383-1-harshanavkis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802173506.2383-1-harshanavkis@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 07:35:06PM +0200, Harshavardhan Unnibhavi wrote:
> The original implementation of the virtio-vsock driver does not
> handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
> virtio-vsock specification. The vsock device emulated by
> vhost-vsock and the virtio-vsock driver never uses this request,
> which was probably why nobody noticed it. However, another
> implementation of the device may use this request type.
> 
> Hence, this commit introduces a way to handle an explicit credit
> request by responding with a corresponding credit update as
> required by the virtio-vsock specification.
> 
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> 
> Signed-off-by: Harshavardhan Unnibhavi <harshanavkis@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  net/vmw_vsock/virtio_transport_common.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 169ba8b72a63..081e7ae93cb1 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1079,6 +1079,9 @@ virtio_transport_recv_connected(struct sock *sk,
>  		virtio_transport_recv_enqueue(vsk, pkt);
>  		sk->sk_data_ready(sk);
>  		return err;
> +	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
> +		virtio_transport_send_credit_update(vsk);
> +		break;
>  	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
>  		sk->sk_write_space(sk);
>  		break;
> -- 
> 2.17.1

