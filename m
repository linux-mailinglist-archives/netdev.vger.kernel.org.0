Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDE3D3937
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhGWKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:32:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12245 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhGWKcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:32:25 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GWRNW5d7Tz1CMyh;
        Fri, 23 Jul 2021 19:07:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:12:57 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 23 Jul
 2021 19:12:56 +0800
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, "Salil Mehta" <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Will Deacon" <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Vlastimil Babka" <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Alexander Lobakin" <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com>
 <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com>
 <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com>
Date:   Fri, 23 Jul 2021 19:12:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/22 23:18, Alexander Duyck wrote:
>>>
>>>> You are right that that may cover up the reference count errors. How about
>>>> something like below:
>>>>
>>>> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>>>                                                           long nr)
>>>> {
>>>> #ifdef CONFIG_DEBUG_PAGE_REF
>>>>         long ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>
>>>>         WARN_ON(ret < 0);
>>>>
>>>>         return ret;
>>>> #else
>>>>         if (atomic_long_read(&page->pp_frag_count) == nr)
>>>>                 return 0;
>>>>
>>>>         return atomic_long_sub_return(nr, &page->pp_frag_count);
>>>> #end
>>>> }
>>>>
>>>> Or any better suggestion?
>>>
>>> So the one thing I might change would be to make it so that you only
>>> do the atomic_long_read if nr is a constant via __builtin_constant_p.
>>> That way you would be performing the comparison in
>>> __page_pool_put_page and in the cases of freeing or draining the
>>> page_frags you would be using the atomic_long_sub_return which should
>>> be paths where you would not expect it to match or that are slowpath
>>> anyway.
>>>
>>> Also I would keep the WARN_ON in both paths just to be on the safe side.
>>
>> If I understand it correctly, we should change it as below, right?
>>
>> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>                                                           long nr)
>> {
>>         long ret;
>>
>>         /* As suggested by Alexander, atomic_long_read() may cover up the
>>          * reference count errors, so avoid calling atomic_long_read() in
>>          * the cases of freeing or draining the page_frags, where we would
>>          * not expect it to match or that are slowpath anyway.
>>          */
>>         if (__builtin_constant_p(nr) &&
>>             atomic_long_read(&page->pp_frag_count) == nr)
>>                 return 0;
>>
>>         ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>         WARN_ON(ret < 0);
>>         return ret;
>> }
> 
> Yes, that is what I had in mind.
> 
> One thought I had for a future optimization is that we could look at
> reducing the count by 1 so that we could essentially combine the
> non-frag and frag cases.Then instead of testing for 1 we would test
> for 0 at thee start of the function and test for < 0 to decide if we
> want to free it or not instead of testing for 0. With that we can
> essentially reduce the calls to the WARN_ON since we should only have
> one case where we actually return a value < 0, and we can then check
> to see if we overshot -1 which would be the WARN_ON case.
> 
> With that a value of 0 instead of 1 would indicate page frag is not in
> use for the page *AND/OR* that the page has reached the state where
> there are no other frags present so the page can be recycled. In
> effect it would allow us to mix page frags and no frags within the
> same pool. The added bonus would be we could get rid of the check for
> PP_FLAG_PAGE_FRAG flag check in the __page_pool_put_page function and
> replace it with a check for PAGE_POOL_DMA_USE_PP_FRAG_COUNT since we
> cannot read frag_count in that case.

Let's leave it for a future optimization.
I am not sure if there is use case to support both frag page and non-frag
page for the same page pool. If there is, maybe we can use "page->pp_frag_count
> 0" to indicate that the page is frag page, and "page->pp_frag_count == 0"
to indicate that the page is non-frag page, so that we can support frag page and
non-frag page for the same page pool instead of disabling non-frag page support
when PP_FLAG_PAGE_FRAG flag is set, which might be conflit with the above
optimization?


Also, I am prototyping the tx recycling based on page pool in order to see
if there is any value supporting the tx recycling.
As the busypoll has enable the one-to-one relation between NAPI and sock,
and there is one-to-one relation between NAPI and page pool, perhaps it make
senses that we use page pool to recycle the tx page too?

There are possibly below problems when doing that as I am aware of now:
1. busypoll is for rx, and tx may not be using the same queue as rx even if
   there are *technically* the same flow， so I am not sure it is ok to use
   busypoll infrastructure to get the page pool ptr for a specific sock.

2. There may be multi socks using the same page pool ptr to allocate page for
   multi flow, so we can not assume the same NAPI polling protection as rx,
   which might mean we can only use the recyclable page from pool->ring under the
   r->consumer_lock protection.

3. Right now tcp_sendmsg_locked() use sk_page_frag_refill() to refill the page
   frag for tcp xmit, when implementing a similar sk_page_pool_frag_refill()
   based on page pool, I found that tcp coalesce in tcp_mtu_probe() and
   tcp fragment in tso_fragment() might mess with the page_ref_count directly.

As the above the problem I am aware of(I believe there are other problems I am not
aware of yet), I am not sure if the tcp tx page recycling based on page pool is
doable or not, I would like to hear about your opinion about tcp tx recycling support
based on page pool first, in case it is a dead end to support that.

> .
> 
