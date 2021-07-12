Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961D93C61C3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbhGLRXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:23:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234771AbhGLRXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626110452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTa3P9ZWFrJfV2ObKCtTAuiG3I+N8Ir5qQrelfNdXg4=;
        b=Dq8tVSyxBYrF/i+jc+6IVNDjmN44NmMIcz7J7GcDFG6DQxgYIW3QjINNWcTANhM3p82l5v
        K5JjnyKzvRhyoMsqOeUjOUJQW81UFh+oKbl+yN6fqK7tHV3Ma8SS9XWz+FrxedVCr/LTdJ
        WRs+7hpbtwEbMUd9y6JTojyxxbD11pU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-cgDbOFEpMxeSowDgm7IMXQ-1; Mon, 12 Jul 2021 13:20:50 -0400
X-MC-Unique: cgDbOFEpMxeSowDgm7IMXQ-1
Received: by mail-wm1-f70.google.com with SMTP id m6-20020a05600c4f46b0290205f5e73b37so311196wmq.3
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 10:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GTa3P9ZWFrJfV2ObKCtTAuiG3I+N8Ir5qQrelfNdXg4=;
        b=KXtMrv6ARbYFltN8F6WD3oKF+zVgIV+zBUEDmgJTLrFUD7pujZcbnTe3rMh6hXN5FG
         K1rrqhUIpMYU4+/z3iKqgT07gQxEiT+OmkIpvYPE69n41GnS5IUU2TPhQ5gXf44RltU+
         nh3uGG0K5GQiQJ1cAuOrI8T3f0E3vgkovJCJb7VmxQKyBBLcK4VU3BGkRblXBrD+IE/y
         LuI79FrTFakm8Ntx0+pd4PQ046f3MsoaxsWU/As+2nVW+xDFuFVWfih9Jvj89pJP/uQz
         0MMQXcVwFw9BkWO5yjbQ2KxNk68ZOdTTs1moDNqt/Cg3w9ZqSTx/acXUbR8Dwad17TCa
         p2Aw==
X-Gm-Message-State: AOAM532cQQlfhzbe0fqIMOZSGLrvTpznBATxuDsiRcdr21TtZHnc7OuR
        d7c3EgwwsqSbyl5A8LGkYgiQI5Zpo/bxXaRshGuENwt2mOaJJXLcAZpxCtERwGo/VZ5s5FAUAX/
        twigVVWQvtCuPGMZh
X-Received: by 2002:adf:facf:: with SMTP id a15mr59272wrs.39.1626110449639;
        Mon, 12 Jul 2021 10:20:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+d/U8vl8SdYAtGo2IkkoAiNENGSESyGiWUbqzEMUERbu/JIM77t4J+I7Z2Njn7zh2uPwhcw==
X-Received: by 2002:adf:facf:: with SMTP id a15mr59222wrs.39.1626110449396;
        Mon, 12 Jul 2021 10:20:49 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id w15sm567272wmi.3.2021.07.12.10.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:20:48 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH rfc v3 2/4] page_pool: add interface for getting and
 setting pagecnt_bias
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com>
 <1626092196-44697-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf1W1H_0jK+zTDHdQnpa-dFSfcAtANqhPTJyZ21VeGmjg@mail.gmail.com>
Message-ID: <2d9a3d29-8e6b-8462-c410-6b7fd4518c9d@redhat.com>
Date:   Mon, 12 Jul 2021 19:20:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf1W1H_0jK+zTDHdQnpa-dFSfcAtANqhPTJyZ21VeGmjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/07/2021 18.02, Alexander Duyck wrote:
> On Mon, Jul 12, 2021 at 5:17 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> As suggested by Alexander, "A DMA mapping should be page
>> aligned anyway so the lower 12 bits would be reserved 0",
>> so it might make more sense to repurpose the lower 12 bits
>> of the dma address to store the pagecnt_bias for frag page
>> support in page pool.
>>
>> As newly added page_pool_get_pagecnt_bias() may be called
>> outside of the softirq context, so annotate the access to
>> page->dma_addr[0] with READ_ONCE() and WRITE_ONCE().
>>
>> And page_pool_get_pagecnt_bias_ptr() is added to implement
>> the pagecnt_bias atomic updating when a page is passsed to
>> the user.
>>
>> Other three interfaces using page->dma_addr[0] is only called
>> in the softirq context during normal rx processing, hopefully
>> the barrier in the rx processing will ensure the correct order
>> between getting and setting pagecnt_bias.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>   include/net/page_pool.h | 29 +++++++++++++++++++++++++++--
>>   net/core/page_pool.c    |  8 +++++++-
>>   2 files changed, 34 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 8d7744d..84cd972 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -200,17 +200,42 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>
>>   static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>   {
>> -       dma_addr_t ret = page->dma_addr[0];
>> +       dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>>          if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>                  ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
>>          return ret;
>>   }
>>
>> -static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>> +static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>>   {
>> +       if (WARN_ON(addr & ~PAGE_MASK))
>> +               return false;
>> +
>>          page->dma_addr[0] = addr;
>>          if (sizeof(dma_addr_t) > sizeof(unsigned long))
>>                  page->dma_addr[1] = upper_32_bits(addr);
>> +
>> +       return true;
>> +}
>> +
> 
> Rather than making this a part of the check here it might make more
> sense to pull this out and perform the WARN_ON after the check for
> dma_mapping_error.

I need to point out that I don't like WARN_ON and BUG_ON code in 
fast-path code, because compiler adds 'ud2' assembler instructions that 
influences the instruction-cache fetching in the CPU.  Yes, I have seen 
a measuresable impact from this before.


> Also it occurs to me that we only really have to do this in the case
> where dma_addr_t is larger than the size of a long. Otherwise we could
> just have the code split things so that dma_addr[0] is the dma_addr
> and dma_addr[1] is our pagecnt_bias value in which case we could
> probably just skip the check.

The dance to get 64-bit DMA addr on 32-bit systems is rather ugly and 
confusing, sadly.  We could take advantage of this, I just hope this 
will not make it uglier.


>> +static inline int page_pool_get_pagecnt_bias(struct page *page)
>> +{
>> +       return READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK;
>> +}
>> +
>> +static inline unsigned long *page_pool_pagecnt_bias_ptr(struct page *page)
>> +{
>> +       return page->dma_addr;
>> +}
>> +
>> +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
>> +{
>> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
>> +
>> +       dma_addr_0 &= PAGE_MASK;
>> +       dma_addr_0 |= bias;
>> +
>> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>>   }
>>
>>   static inline bool is_page_pool_compiled_in(void)
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 78838c6..1abefc6 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -198,7 +198,13 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>          if (dma_mapping_error(pool->p.dev, dma))
>>                  return false;
>>
> 
> So instead of adding to the function below you could just add your
> WARN_ON check here with the unmapping call.
> 
>> -       page_pool_set_dma_addr(page, dma);
>> +       if (unlikely(!page_pool_set_dma_addr(page, dma))) {
>> +               dma_unmap_page_attrs(pool->p.dev, dma,
>> +                                    PAGE_SIZE << pool->p.order,
>> +                                    pool->p.dma_dir,
>> +                                    DMA_ATTR_SKIP_CPU_SYNC);
>> +               return false;
>> +       }
>>
>>          if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>>                  page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
>> --
>> 2.7.4
>>
> 

