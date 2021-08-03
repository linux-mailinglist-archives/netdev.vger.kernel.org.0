Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F43DE757
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhHCHlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234253AbhHCHlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 03:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627976491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXZLExcEITdntTYG0Of03HReF9Mx2BfGVrCdJE4PA5o=;
        b=C9wNBvp7uY+fMwiLY79ZG9HwKKwLLBPLcQahjva50Tp6iH3XjsHTILyMiOjkS2KTdHNntJ
        UwfK7D7NhXZcLQXk+IWt7yxmD2zLHDdMDYoAcTgMKp7azFAyS4TIVXbXQVVH3gddjBsKpl
        2DBigBWPnpu+DMc8KARoRiIz9b5kiVg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-5GmOjOKaMIyZuGLGkyiFPA-1; Tue, 03 Aug 2021 03:41:30 -0400
X-MC-Unique: 5GmOjOKaMIyZuGLGkyiFPA-1
Received: by mail-pl1-f199.google.com with SMTP id x7-20020a170902b407b029012c8cffc695so9954394plr.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 00:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XXZLExcEITdntTYG0Of03HReF9Mx2BfGVrCdJE4PA5o=;
        b=lfuVPXzR1hylb14miESnkyCZ69OWSNiAE2m7Sme3zWcfZjTStUnp3/kxl1bS8MDyfO
         5AyxnNwuRE2xpO5Mi4evT2TTcmKpWGcSDCwcZRV9zyppPCO8Lv9las7lkx34WiuWBZ1B
         o6dSbzVAY/QgxoEbtmhCH/n6cgg4cWWD4amNz9zaclKk1N4h84xDHGuO2XOGrRovSibM
         nsUreRzlov/Hd6ypNihIw6OEWPbvyUIGYcMd+LezjXy1N4rfbHz5TIz6YMcTTlXkSqap
         FzKGJVxdZSoIZ+CYIuSsuBDeeE1daNLKhVO602t2O5rD/0NTjYMw8acjeEwUqaYGn5DY
         fGOQ==
X-Gm-Message-State: AOAM533wOlnnJ9YZOFDIZXQm9hcFx1xRSxwoDuSvFt4JdjAkgc7na2K2
        Rk9dKCKMIP6f7vaOUt6DHke40RiXO9vSsEhkkrbPX0KVVzBm4CR0GJ05GSbekvSL69ksMVR8hh0
        kZ1IiX2MULBLpYXpV
X-Received: by 2002:aa7:961d:0:b029:3bc:dbdd:7a9b with SMTP id q29-20020aa7961d0000b02903bcdbdd7a9bmr9608169pfg.32.1627976489056;
        Tue, 03 Aug 2021 00:41:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwjX4aE2G2A/KT25YRVhvLPWveCcGvZhYValWvnC/74smyorfbkjI1EnjKESaebAF3OLAkpg==
X-Received: by 2002:aa7:961d:0:b029:3bc:dbdd:7a9b with SMTP id q29-20020aa7961d0000b02903bcdbdd7a9bmr9608133pfg.32.1627976488686;
        Tue, 03 Aug 2021 00:41:28 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j6sm16132108pgq.0.2021.08.03.00.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:41:28 -0700 (PDT)
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and
 free_iova_fast()
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
 <20210729073503.187-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4eb84e87-21ef-608f-ae15-3e9bc442971c@redhat.com>
Date:   Tue, 3 Aug 2021 15:41:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:34, Xie Yongji Ð´µÀ:
> Export alloc_iova_fast() and free_iova_fast() so that
> some modules can use it to improve iova allocation efficiency.


It's better to explain which alloc_iova() is not sufficient here.

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/iommu/iova.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b6cf5f16123b..3941ed6bb99b 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   
>   	return new_iova->pfn_lo;
>   }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>   
>   /**
>    * free_iova_fast - free iova pfn range into rcache
> @@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
>   
>   	free_iova(iovad, pfn);
>   }
> +EXPORT_SYMBOL_GPL(free_iova_fast);
>   
>   #define fq_ring_for_each(i, fq) \
>   	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)

