Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7923CF477
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhGTFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:45:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233384AbhGTFo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626762337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pFjrkcG2ZRzROzSDXE/qK9WLlZjt36K6e23WeKajZ8=;
        b=cfEzMyi4dscivap6mZVQ4CYHeSuu/QvSwU+v+ncbOTvPfbMyG7o4VNOXdzVToTHF2Krw4h
        nR2WIewAC3V380eEeWMjma+PgViEwVPofS6XSIxTInaYIbg3eKARlcyGvggWqO60GdVBxH
        a5zpDokfKyC0bdFWcZvCq/Jgy/tLvo4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-KRI8qeYrMZuUu6fMklb34A-1; Tue, 20 Jul 2021 02:25:35 -0400
X-MC-Unique: KRI8qeYrMZuUu6fMklb34A-1
Received: by mail-pf1-f199.google.com with SMTP id h6-20020a62b4060000b02903131bc4a1acso15410339pfn.4
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 23:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+pFjrkcG2ZRzROzSDXE/qK9WLlZjt36K6e23WeKajZ8=;
        b=twHo0L0CiVMAVVmTsBEd6ziYAah9acSm2GBmVLw4dS+9EpE80y5N8HvJ8POO4B93Vp
         3OvUYCKTONnfOvtnVaP9P3v1sfr3JqGjncx1yJbC8Kx1Gvn2aL+9QwRH6dgRAyGjT9/S
         A4/sx+eTPvsbozSovHg6iPPdYb0BWpAeJumIis+NzgTydN9L+1K2nAN4f852VY4ycca6
         BoQ34Akm7G4pxqn8xN1fdgd4IN+Om9W7vWEgzd7KYvEIE5TqFbdYePIOQ0Xlk5L6WUjg
         oa/Jfqm6MyO/HKhSVzgNK/bsCCoKzr0CylkQ8y8gAg9I9ix7b/Wp5D7Y/nPbLrvK+CAv
         aMxg==
X-Gm-Message-State: AOAM5313QDMyiCcjsBgC00IqpaUFetHYwROwgJddMi0UHX9M8Mm/Xvy2
        8jdFNM7nhWhR4LW0tzDk3kP5oPYxsbb7IuKbH4XpZ6IkuG9TJ/mMb9lvU9AoE7iPyfbICQd1nae
        UZV++9DankS39kyRC
X-Received: by 2002:a63:2041:: with SMTP id r1mr14924109pgm.59.1626762334871;
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJFTlgkaKXwIn+1kT2a5RmA050X86XDvyy0tTwV3OcM/kDFkzn7QDPYu1L0FUL3OWMF00cPA==
X-Received: by 2002:a63:2041:: with SMTP id r1mr14924097pgm.59.1626762334630;
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d13sm21831104pfn.136.2021.07.19.23.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720034039.1351-1-tianxianting.txt@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9a790a52-8f14-1a9a-51e0-9c35a03d33dd@redhat.com>
Date:   Tue, 20 Jul 2021 14:25:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720034039.1351-1-tianxianting.txt@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/20 ÉÏÎç11:40, Xianting Tian Ð´µÀ:
> Add the missed virtio_device_ready() to set vsock frontend ready.
>
> Signed-off-by: Xianting Tian <tianxianting.txt@linux.alibaba.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e0c2c992a..eb4c607c4 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -637,6 +637,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   	vdev->priv = vsock;
>   	rcu_assign_pointer(the_virtio_vsock, vsock);
>   
> +	virtio_device_ready(vdev);
> +
>   	mutex_unlock(&the_virtio_vsock_mutex);


It's better to do this after the mutex.

Thanks


>   
>   	return 0;

