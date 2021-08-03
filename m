Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35F63DE7D1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhHCIDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234355AbhHCIDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627977789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oX9W5hbn1aUW9052DFy7xT6UwniQgZiOlZ+YGM5fx0A=;
        b=drQ3y0yYcOqB4qinQnLDe/UhmYQyIbaZmxCvAItHRe1ROT8eyKIznfLS2bbr6GT6sO8IRx
        2Wzv+A+gbvBSJTQVpFhVKZp5ndX2K6o07Mh05jZua0EZiWVHXZcnbVS43DBr4zJqYXTevp
        lZYtrn7a+VFkAQ4WUZVdm8hmPx5r8To=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-o6R74NuBNgCaX9C6GWaXdw-1; Tue, 03 Aug 2021 04:03:08 -0400
X-MC-Unique: o6R74NuBNgCaX9C6GWaXdw-1
Received: by mail-pj1-f70.google.com with SMTP id o38-20020a17090a0a29b02901772cd97277so1973125pjo.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 01:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oX9W5hbn1aUW9052DFy7xT6UwniQgZiOlZ+YGM5fx0A=;
        b=QWMx0Hw3bSDIZH3MFN4qyFbIaD76g/ba2mnmf+kSqD9oRQWHoXmMOBoOH0BuAMaJis
         0DcUcQcpz04eyvtNjN6IG8TgNRXkJLpuNqKwohQP3KxaPc/FWZy9Nz3mGE0nR2Anw1g5
         xNGOTRWBOFa9S9MPnciXPMcYuhL38rGk5oth8QnRT5LEUGOckwNJAfdh8hZ0qv9QyaRe
         jxZ76IiZv228qUwLBbHIaaTdNatZA953Gr2hxxlIojMQfIUDGQRslF20yQqSFGevmB4R
         WBEfQiDNgottaPSwwg2Nn+m21BkYqbJ67hhZQ3KjcusljfF6hmx+RrIg7Mtx4eykOiqL
         oM6w==
X-Gm-Message-State: AOAM5338cB79ZF/XWTGyJoldsStB2yoTddDQzmLRSEFRQMd6fR+hK5xI
        2n3SS3gsUovDrnnQMQ0tnGByatymEKR1rNbtmRoCFuvAZlDN/6s1YAS79ZvoDtilrp/eh44PpqC
        yt3vCoIzigT4b3pfO
X-Received: by 2002:a17:90a:784e:: with SMTP id y14mr5429392pjl.185.1627977787238;
        Tue, 03 Aug 2021 01:03:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ/4OMNA4Jyj5oD4cflZM/wOKB+qV8HVYA0Mg+fxcM5s95sTutq8PhHECERUYS65XO/92FRw==
X-Received: by 2002:a17:90a:784e:: with SMTP id y14mr5429356pjl.185.1627977786975;
        Tue, 03 Aug 2021 01:03:06 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n20sm7442877pfv.212.2021.08.03.01.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:03:06 -0700 (PDT)
Subject: Re: [PATCH v10 07/17] virtio: Don't set FAILED status bit on device
 index allocation failure
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-8-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <487ed840-f417-e1b6-edb3-15f19969de51@redhat.com>
Date:   Tue, 3 Aug 2021 16:02:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-8-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:34, Xie Yongji Ð´µÀ:
> We don't need to set FAILED status bit on device index allocation
> failure since the device initialization hasn't been started yet.
> This doesn't affect runtime, found in code review.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Does it really harm?

Thanks


> ---
>   drivers/virtio/virtio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 4b15c00c0a0a..a15beb6b593b 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device *dev)
>   	/* Assign a unique device index and hence name. */
>   	err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>   	if (err < 0)
> -		goto out;
> +		return err;
>   
>   	dev->index = err;
>   	dev_set_name(&dev->dev, "virtio%u", dev->index);

