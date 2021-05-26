Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16A6390E58
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhEZCh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 22:37:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhEZChz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 22:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621996584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IJC3K6l6gJPi4CUzLhheMs0LRbWxiui4b9xku04/3mg=;
        b=FLTML3az9GlmnIZWqYMuqNDvbo0kAbcKdtWA/qQOtP61hXvjCRvJbYxmobEYwQDKmY6umM
        CMe6gi/fjyBY5zthf+zP1YJl0HGmBeB1IAY7/x9edoBsTt7D8QmHGLw7N91wm00e1nbpex
        dp1rdxIvq45sG53RU8N+vKjVcPTav40=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-yh5-9cQ1ME2Zbl087hl1YQ-1; Tue, 25 May 2021 22:36:22 -0400
X-MC-Unique: yh5-9cQ1ME2Zbl087hl1YQ-1
Received: by mail-pg1-f200.google.com with SMTP id s5-20020a63d0450000b029021cb0aff563so1394856pgi.18
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 19:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IJC3K6l6gJPi4CUzLhheMs0LRbWxiui4b9xku04/3mg=;
        b=gCKNjOiz+MWGGbvrOVULqRTTruvcxrfc5M7QZk/d6S9uQi3ItmsIPHN8jrqnB5AOx2
         HHFWbrvdLkJNL/Xxoxl6vDS+idVmxWoC+ITN62eoAi3sgvwLXCNtRyrGRd4pxZYXqjkX
         RQdY62o5WuKExkFF8WX2LlBxHr2VsoDFpkQzTx6laGeWKX7exJHc0R+R7xhN21WQMG1P
         LgqczYwWBGjkTZ08ZvjYTCviIBcGhjMt1WR9YZiVQU8I15WEHmgy3ah4qoI8Y2z+fD1W
         CDK90Fcow/7TWFr0sUyZmfv2eKJXR03Vt9JXONmxiuQqMieYrMrlKXl04PdB+6bFePCE
         n0rw==
X-Gm-Message-State: AOAM530+6dHjn+d9kl1tIyq3LOQoscBUkTxLiVpdnEJFF7oRXDff6gcR
        Ug6Wv7RrnFqxQ1kgD8aH1YfRyxN9xVtG5cXjdZMFFvuWFp1HGB/+lpTfZnjGrjI55y/gFgFF2fW
        +NOfN6vzJkasQbX6X
X-Received: by 2002:a17:902:f281:b029:f0:bdf2:2fe5 with SMTP id k1-20020a170902f281b02900f0bdf22fe5mr32724319plc.68.1621996581540;
        Tue, 25 May 2021 19:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylcchXGFUiLMl0CERc9pjyfUvd7s5BV6gdMSkLdsrvpEyh07CtgmlI9vttP0fXdJsLVzRn5Q==
X-Received: by 2002:a17:902:f281:b029:f0:bdf2:2fe5 with SMTP id k1-20020a170902f281b02900f0bdf22fe5mr32724300plc.68.1621996581246;
        Tue, 25 May 2021 19:36:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b12sm2984392pjd.22.2021.05.25.19.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 19:36:20 -0700 (PDT)
Subject: Re: [PATCH v7 01/12] iova: Export alloc_iova_fast()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6ca337fe-2c8c-95c9-672e-0d4f104f66eb@redhat.com>
Date:   Wed, 26 May 2021 10:36:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210517095513.850-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/17 ÏÂÎç5:55, Xie Yongji Ð´µÀ:
> Export alloc_iova_fast() so that some modules can use it
> to improve iova allocation efficiency.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/iommu/iova.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index e6e2fa85271c..317eef64ffef 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -450,6 +450,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   
>   	return new_iova->pfn_lo;
>   }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>   
>   /**
>    * free_iova_fast - free iova pfn range into rcache


Interesting, do we need export free_iova_fast() as well?

Thanks


