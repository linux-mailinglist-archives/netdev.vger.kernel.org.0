Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8473B1276
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFWDvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWDvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624420130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8mq8LxfuDXyJ+pHOiIlGCAFqRNvKwNqM3X44uV2r1M=;
        b=gbbAZ/aD2/e03+dCht50ritGjchETo+mTAYrd/x6WfVFsVJiuc0T2HhmVivAO4fPYMsEt+
        tG2ud8zIqVOl8zblSOtd7Y6uiMPFAjKaLMoHW8tCWMBj1PuYJDpbYLHQxXpyk31uC0Q+tg
        Pf4CcCOOJeUha2y1HLjQqeSSa8qMjZQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-6q5bk-ftPi2LaJQg_HYGdQ-1; Tue, 22 Jun 2021 23:48:47 -0400
X-MC-Unique: 6q5bk-ftPi2LaJQg_HYGdQ-1
Received: by mail-pj1-f72.google.com with SMTP id bv6-20020a17090af186b029016fb0e27fe2so3026668pjb.4
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=v8mq8LxfuDXyJ+pHOiIlGCAFqRNvKwNqM3X44uV2r1M=;
        b=SNm58v2GLz5EhG8pT7RV1u2MIvHL1K6uhXatfdu/Hkc/ZnW3rpKa6AKQxrofL0hLr2
         x7IdwXrqMOq03Y7HVNy5CfC+7T/zWQkEQyRjuVwta1zpp8P7MMNmPm3wesPlZJNT0b6K
         YY3uqJ5JjfF74jPz7pUzYMnnZcHHUStd3OEdwZdF98AcuyJ/PVeOerMED++oWp4f+xDt
         jrtPDSly/YxqrwOlFZVQU2lVqV/uh6wzG0NuNL9BMtLDTUjvQp4eqIvUV/SJYNTU/k0E
         qFWmQ0Gno/GfB/5xmzmKiqeeUT1KGrxUT1XT31PR6Y0970cX5iwcCafKMFlWYk9KzTtr
         vpKQ==
X-Gm-Message-State: AOAM530OJy5aDyHfQ/B+q9DnrhsYss+CVvqC7GluD+5IvYeiYflg0iwH
        c5wQrXPenZ224F2xNLGXR0qFdFPeKVJ5ztlEYO8xHKLp0ecB4iVHpuglkBrx00zre6uNvAYc2NJ
        XPHmg/0N5jAS5kjKv
X-Received: by 2002:a17:90a:73ca:: with SMTP id n10mr7387637pjk.16.1624420126783;
        Tue, 22 Jun 2021 20:48:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvKYOqKbCzxHiBVXvmOhnEn/KiRgVFsZHCCRJglu7QNbTZ0GR4vMU2m4PbKylW4RmgAEnH7g==
X-Received: by 2002:a17:90a:73ca:: with SMTP id n10mr7387626pjk.16.1624420126615;
        Tue, 22 Jun 2021 20:48:46 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p24sm746279pfh.17.2021.06.22.20.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:48:46 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] vhost_net: validate virtio_net_hdr only if it
 exists
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <20210622161533.1214662-3-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cbac7eca-c72f-2e64-5ec1-45ce414f0d7b@redhat.com>
Date:   Wed, 23 Jun 2021 11:48:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622161533.1214662-3-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/23 ÉÏÎç12:15, David Woodhouse Ð´µÀ:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> When the underlying socket doesn't handle the virtio_net_hdr, the
> existing code in vhost_net_build_xdp() would attempt to validate stack
> noise, by copying zero bytes into the local copy of the header and then
> validating that. Skip the whole pointless pointer arithmetic and partial
> copy (of zero bytes) in this case.
>
> Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/net.c | 43 ++++++++++++++++++++++---------------------
>   1 file changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index df82b124170e..1e3652eb53af 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -690,7 +690,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>   					     dev);
>   	struct socket *sock = vhost_vq_get_backend(vq);
>   	struct page_frag *alloc_frag = &net->page_frag;
> -	struct virtio_net_hdr *gso;
>   	struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
>   	struct tun_xdp_hdr *hdr;
>   	size_t len = iov_iter_count(from);
> @@ -715,29 +714,31 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>   		return -ENOMEM;
>   
>   	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> -	copied = copy_page_from_iter(alloc_frag->page,
> -				     alloc_frag->offset +
> -				     offsetof(struct tun_xdp_hdr, gso),
> -				     sock_hlen, from);
> -	if (copied != sock_hlen)
> -		return -EFAULT;
> -
>   	hdr = buf;
> -	gso = &hdr->gso;
> -
> -	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> -	    vhost16_to_cpu(vq, gso->csum_start) +
> -	    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
> -	    vhost16_to_cpu(vq, gso->hdr_len)) {
> -		gso->hdr_len = cpu_to_vhost16(vq,
> -			       vhost16_to_cpu(vq, gso->csum_start) +
> -			       vhost16_to_cpu(vq, gso->csum_offset) + 2);
> -
> -		if (vhost16_to_cpu(vq, gso->hdr_len) > len)
> -			return -EINVAL;
> +	if (sock_hlen) {
> +		struct virtio_net_hdr *gso = &hdr->gso;
> +
> +		copied = copy_page_from_iter(alloc_frag->page,
> +					     alloc_frag->offset +
> +					     offsetof(struct tun_xdp_hdr, gso),
> +					     sock_hlen, from);
> +		if (copied != sock_hlen)
> +			return -EFAULT;
> +
> +		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> +		    vhost16_to_cpu(vq, gso->csum_start) +
> +		    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
> +		    vhost16_to_cpu(vq, gso->hdr_len)) {
> +			gso->hdr_len = cpu_to_vhost16(vq,
> +						      vhost16_to_cpu(vq, gso->csum_start) +
> +						      vhost16_to_cpu(vq, gso->csum_offset) + 2);
> +
> +			if (vhost16_to_cpu(vq, gso->hdr_len) > len)
> +				return -EINVAL;
> +		}
> +		len -= sock_hlen;
>   	}
>   
> -	len -= sock_hlen;
>   	copied = copy_page_from_iter(alloc_frag->page,
>   				     alloc_frag->offset + pad,
>   				     len, from);

