Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B5377598
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 07:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhEIFNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 01:13:49 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32241 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhEIFNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 01:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620537165; x=1652073165;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=XVtQRWhA4CuXLzObdTcbpeSXr8ZueHXWK6PH9f+p+0w=;
  b=v1WPo1YHYOKGrHFhZjvvAWMzbEDpvW1UOzGpiw4sJHHElau0nbELpCbG
   o4mg3/gFXyC8+nYa8Dxhjc7IrLPzLqW5QxtSdX3JBWds7y2cub0iSgwqs
   hR3C/Vl0uT2tb68ja6H9+d4CC4GVlK0/WTt27aPFHf4zvO+D16locrgkV
   M=;
X-IronPort-AV: E=Sophos;i="5.82,284,1613433600"; 
   d="scan'208";a="134015522"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 09 May 2021 05:12:39 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 51476A17D3;
        Sun,  9 May 2021 05:12:22 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.119) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 9 May 2021 05:11:57 +0000
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
 <YJPn5t2mdZKC//dp@apalos.home>
 <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
 <YJTm4uhvqCy2lJH8@apalos.home>
 <bdd97ac5-f932-beec-109e-ace9cd62f661@huawei.com>
 <20210507121953.59e22aa8@carbon>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Russell King" <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "Cong Wang" <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
In-Reply-To: <20210507121953.59e22aa8@carbon>
Date:   Sun, 9 May 2021 08:11:35 +0300
Message-ID: <pj41zl4kfclce0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.119]
X-ClientProxiedBy: EX13D13UWB002.ant.amazon.com (10.43.161.21) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Fri, 7 May 2021 16:28:30 +0800
> Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
>> On 2021/5/7 15:06, Ilias Apalodimas wrote:
>> > On Fri, May 07, 2021 at 11:23:28AM +0800, Yunsheng Lin wrote:  
>> >> On 2021/5/6 20:58, Ilias Apalodimas wrote:  
>> >>>>>>  
>> >>>>>
> ...
>> > 
>> > 
>> > I think both choices are sane.  What I am trying to explain 
>> > here, is
>> > regardless of what we choose now, we can change it in the 
>> > future without
>> > affecting the API consumers at all.  What will change 
>> > internally is the way we
>> > lookup the page pool pointer we are trying to recycle.  
>> 
>> It seems the below API need changing?
>> +static inline void skb_mark_for_recycle(struct sk_buff *skb, 
>> struct page *page,
>> +					struct xdp_mem_info *mem)
>
> I don't think we need to change this API, to support future 
> memory
> models.  Notice that xdp_mem_info have a 'type' member.

Hi,
Providing that we will (possibly as a future optimization) store 
the pointer to the page pool in struct page instead of strcut 
xdp_mem_info, passing
xdp_mem_info * instead of struct page_pool * would mean that for 
every packet we'll need to call
             xa = rhashtable_lookup(mem_id_ht, &mem->id, 
             mem_id_rht_params);
             xa->page_pool;

which might pressure the Dcache to fetch a pointer that might be 
present already in cache as part of driver's data-structures.

I tend to agree with Yunsheng that it makes more sense to adjust 
the API for the clear use-case now rather than using xdp_mem_info 
indirection. It seems to me like
the page signature provides the same information anyway and allows 
to support different memory types.

Shay

>
> Naming in Computer Science is a hard problem ;-). Something that 
> seems
> to confuse a lot of people is the naming of the struct 
> "xdp_mem_info".  
> Maybe we should have named it "mem_info" instead or 
> "net_mem_info", as
> it doesn't indicate that the device is running XDP.
>
> I see XDP as the RX-layer before the network stack, that helps 
> drivers
> to support different memory models, also for handling normal 
> packets
> that doesn't get process by XDP, and the drivers doesn't even 
> need to
> support XDP to use the "xdp_mem_info" type.

