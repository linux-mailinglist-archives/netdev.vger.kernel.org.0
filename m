Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDDE3F59A1
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhHXIFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:05:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18029 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbhHXIEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 04:04:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gv1jk3fb6zbhgf;
        Tue, 24 Aug 2021 15:59:54 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 16:03:43 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 24 Aug
 2021 16:03:36 +0800
Subject: Re: [Linuxarm] Re: [PATCH RFC 0/7] add socket to netdev page frag
 recycling support
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Tang, Feng" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <memxor@gmail.com>,
        <linux@rempel-privat.de>, Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        <aahringo@redhat.com>, <ceggers@arri.de>, <yangbo.lu@nxp.com>,
        "Florian Westphal" <fw@strlen.de>, <xiangxia.m.yue@gmail.com>,
        linmiaohe <linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
 <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com>
 <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
 <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fec320a4-7d35-fe79-5e07-7ac26b6dcd30@huawei.com>
Date:   Tue, 24 Aug 2021 16:03:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/23 23:04, Eric Dumazet wrote:
> On Mon, Aug 23, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/8/18 17:36, Yunsheng Lin wrote:
>>> On 2021/8/18 16:57, Eric Dumazet wrote:
>>>> On Wed, Aug 18, 2021 at 5:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>
>>>>> This patchset adds the socket to netdev page frag recycling
>>>>> support based on the busy polling and page pool infrastructure.
>>>>
>>>> I really do not see how this can scale to thousands of sockets.
>>>>
>>>> tcp_mem[] defaults to ~ 9 % of physical memory.
>>>>
>>>> If you now run tests with thousands of sockets, their skbs will
>>>> consume Gigabytes
>>>> of memory on typical servers, now backed by order-0 pages (instead of
>>>> current order-3 pages)
>>>> So IOMMU costs will actually be much bigger.
>>>
>>> As the page allocator support bulk allocating now, see:
>>> https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L252
>>>
>>> if the DMA also support batch mapping/unmapping, maybe having a
>>> small-sized page pool for thousands of sockets may not be a problem?
>>> Christoph Hellwig mentioned the batch DMA operation support in below
>>> thread:
>>> https://www.spinics.net/lists/netdev/msg666715.html
>>>
>>> if the batched DMA operation is supported, maybe having the
>>> page pool is mainly benefit the case of small number of socket?
>>>
>>>>
>>>> Are we planning to use Gigabyte sized page pools for NIC ?
>>>>
>>>> Have you tried instead to make TCP frags twice bigger ?
>>>
>>> Not yet.
>>>
>>>> This would require less IOMMU mappings.
>>>> (Note: This could require some mm help, since PAGE_ALLOC_COSTLY_ORDER
>>>> is currently 3, not 4)
>>>
>>> I am not familiar with mm yet, but I will take a look about that:)
>>
>>
>> It seems PAGE_ALLOC_COSTLY_ORDER is mostly related to pcp page, OOM, memory
>> compact and memory isolation, as the test system has a lot of memory installed
>> (about 500G, only 3-4G is used), so I used the below patch to test the max
>> possible performance improvement when making TCP frags twice bigger, and
>> the performance improvement went from about 30Gbit to 32Gbit for one thread
>> iperf tcp flow in IOMMU strict mode,
> 
> This is encouraging, and means we can do much better.
> 
> Even with SKB_FRAG_PAGE_ORDER  set to 4, typical skbs will need 3 mappings
> 
> 1) One for the headers (in skb->head)
> 2) Two page frags, because one TSO packet payload is not a nice power-of-two.
> 
> The first issue can be addressed using a piece of coherent memory (128
> or 256 bytes per entry in TX ring).
> Copying the headers can avoid one IOMMU mapping, and improve IOTLB
> hits, because all
> slots of the TX ring buffer will use one single IOTLB slot.

Acctually, the hns3 driver has implemented the bounce buffer for the
above case, see:
https://elixir.bootlin.com/linux/v5.14-rc7/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L2042

Enabling the header buffer copying, the performance only improve from
about 30Gbit to 32Gbit for one thread iperf tcp flow.

So it seems the IOMMU overhead does not only related to how many
frag does a skb have, but also related to the length of each frag,
as the IOMMU mapping is based on 4K/2M granularity(for arm64), so it
may still take a lot of time to write each 4K page entry to the page
table when mapping and invalidate each 4K page entry when unmapping.

Also, hns3 driver implement the dma_map_sg() to reduce the number of
IOMMU mapping/unmapping, the peformance is only about 10%, possibly
due to the above reason too, see:
https://lkml.org/lkml/2021/6/16/134

> 
> The second issue can be solved by tweaking a bit
> skb_page_frag_refill() to accept an additional parameter
> so that the whole skb payload fits in a single order-4 page.

I am not sure I understand the above. Are you suggesting passing
'copy' to skb_page_frag_refill(), so that it will allocate a new
pages if there is no enough buffer for the caller?

> 
> 
>  and using the pfrag pool, the improvement
>> went from about 30Gbit to 40Gbit for the same testing configuation:
> 
> Yes, but you have not provided performance number when 200 (or 1000+)
> concurrent flows are running.

As the iperf seems to only support 200 concurrent flows(running more
threads seems to cause "Connection timed out"), any other performance
tool supporting 1000+ concurrent flows?

There is 32 cpus on the numa where the nic hw exists, and using taskset
to run the iperf in the same numa, as the page pool support page frag for
rx now, so the allocating the multi-order pages as skb_page_frag_refill()
does won't waste memory any more.

The below is the performance data for 200 concurrent iperf tcp flows for
one tx queue:
                          throughput      node cpu usages
pfrag_pool disabled:        31Gbit            5%
pfrag_pool-page order 0:    43Gbit            8%
pfrag_pool-page order 1:    50Gbit            8%
pfrag_pool-page order 2:    70Gbit            10%
pfrag_pool-page order 3:    90Gbit            11%


The below is the performance data for 200 concurrent iperf tcp flows for
32 tx queues(94.1Gbit is tcp flow line speed for 100Gbit port with mtu 1500):
                          throughput      node cpu usages
pfrag_pool disabled:        94.1Gbit            23%%
pfrag_pool-page order 0:    93.9Gbit            31%
pfrag_pool-page order 1:    94.1Gbit            24%
pfrag_pool-page order 2:    94.1Gbit            23%
pfrag_pool-page order 3:    94.1Gbit            16%

So it seems page pool for tx seems promising for large number of sockets
too?

> 
> Optimizing singe flow TCP performance while killing performance for
> the more common case is not an option.
> 
> 
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index fcb5355..dda20f9 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -37,7 +37,7 @@
>>   * coalesce naturally under reasonable reclaim pressure and those which
>>   * will not.
>>   */
>> -#define PAGE_ALLOC_COSTLY_ORDER 3
>> +#define PAGE_ALLOC_COSTLY_ORDER 4
>>
>>  enum migratetype {
>>         MIGRATE_UNMOVABLE,
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 870a3b7..b1e0dfc 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2580,7 +2580,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
>>         }
>>  }
>>
>> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
>> +#define SKB_FRAG_PAGE_ORDER    get_order(65536)
>>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>>
>>  /**
>>
>>>
>>>>
>>>> diff --git a/net/core/sock.c b/net/core/sock.c
>>>> index a3eea6e0b30a7d43793f567ffa526092c03e3546..6b66b51b61be9f198f6f1c4a3d81b57fa327986a
>>>> 100644
>>>> --- a/net/core/sock.c
>>>> +++ b/net/core/sock.c
>>>> @@ -2560,7 +2560,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
>>>>         }
>>>>  }
>>>>
>>>> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
>>>> +#define SKB_FRAG_PAGE_ORDER    get_order(65536)
>>>>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>>>>
>>>>  /**
>>>>
>>>>
>>>>
>>>>>
>>> _______________________________________________
>>> Linuxarm mailing list -- linuxarm@openeuler.org
>>> To unsubscribe send an email to linuxarm-leave@openeuler.org
>>>
> .
> 
