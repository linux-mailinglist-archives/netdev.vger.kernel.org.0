Return-Path: <netdev+bounces-11551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8A27338A5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B89E1280CC8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD361DCB9;
	Fri, 16 Jun 2023 19:00:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A0B1DCA8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:00:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759453C13
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686941957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjmzfQ64PaDZl/zNxOmcx+GiAABq8ykFQF94nXy/DjI=;
	b=Zn6R8GWJOyrd43gUSc6wbqCRyX+eCda2d/XtjRxvjqTj0zhG22F3A2/CSJHLWX2GJAOuqx
	Tpc57FLa2pUCrbSbcxd8VQCugbGLCqQL7xlIfNOWsqexL5rk/u08ZBCEV0Jr39rGsnwClA
	+MNudUlvWpqPGAjNRG1SHrCJ1ItmAgY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-M0BJS5w3M1SuQGe85J_WJQ-1; Fri, 16 Jun 2023 14:59:16 -0400
X-MC-Unique: M0BJS5w3M1SuQGe85J_WJQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-513f337d478so601630a12.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686941955; x=1689533955;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zjmzfQ64PaDZl/zNxOmcx+GiAABq8ykFQF94nXy/DjI=;
        b=LY0ixpORuAlGdmaLhRQT6+mDcS+WY8vs8BaM26+GssTgPo0jLgWwGqFQdAZVFYnglk
         lmEbdiMuiQGX51Nw8dGqRVpuxK1c5tNTjiHzc+FOWMG2+W6EnQr0tLzkDAok1G915pFk
         giouugnwm/dxN/OoYvB81kX7l5VJaE40fKikKlx6hlvhsVnUHtibD43JdD/nv4lfP9lb
         J9+zQWmdQBYJH1rs5aA/ZOYMdcaWT9cw4t1mfMp1xdILi3tzQrFrPWocCn/sdsw95FKM
         jtt+hLn7ArY8FeuJJ0vdNgT44bh6T9YhJY/vhXEEZkPRGSrtOSAo7G05ZHwQc739Rota
         +PIg==
X-Gm-Message-State: AC+VfDyQW+xsDCJ4jBLiqqzpT2/0vdVr8Yn8MOZPWbuB/8WOmr2TQkBv
	PyPEPEOlnOIPGj7nFCxMVHZzBCDdKWEBWh6Jer7eiGcmEpLgr3MuiscedWQ1bOewr8krQ5Mde7e
	r+fjluOMrZO0x/Uuj
X-Received: by 2002:a05:6402:28c:b0:518:6bb9:1d5e with SMTP id l12-20020a056402028c00b005186bb91d5emr2072100edv.8.1686941955584;
        Fri, 16 Jun 2023 11:59:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7vlBCAtmkvYL1Wt50Zt/pUXvHXtQyLrJjFLIR+365bedhzoAme9s2GbKhNhGuAwS9jK5D0SQ==
X-Received: by 2002:a05:6402:28c:b0:518:6bb9:1d5e with SMTP id l12-20020a056402028c00b005186bb91d5emr2072085edv.8.1686941955188;
        Fri, 16 Jun 2023 11:59:15 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7c90d000000b0051879590e06sm495742edt.24.2023.06.16.11.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 11:59:14 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <72ccf224-7b45-76c5-5ca9-83e25112c9c6@redhat.com>
Date: Fri, 16 Jun 2023 20:59:12 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>, Yisen Zhuang
 <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
 Eric Dumazet <edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>,
 Geetha sowjanya <gakula@marvell.com>, Subbaraya Sundeep
 <sbhatta@marvell.com>, hariprasad <hkelam@marvell.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Kalle Valo <kvalo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-rdma@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org>
 <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
 <20230615095100.35c5eb10@kernel.org>
 <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
 <908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
 <CAKgT0UeZfbxDYaeUntrQpxHmwCh6zy0dEpjxghiCNxPxv=kdoQ@mail.gmail.com>
In-Reply-To: <CAKgT0UeZfbxDYaeUntrQpxHmwCh6zy0dEpjxghiCNxPxv=kdoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 16/06/2023 17.01, Alexander Duyck wrote:
> On Fri, Jun 16, 2023 at 5:21 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2023/6/16 2:26, Alexander Duyck wrote:
>>> On Thu, Jun 15, 2023 at 9:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Thu, 15 Jun 2023 15:17:39 +0800 Yunsheng Lin wrote:
[...]
>>>>
>>>> I like your patches as they isolate the drivers from having to make the
>>>> fragmentation decisions based on the system page size (4k vs 64k but
>>>> we're hearing more and more about ARM w/ 16k pages). For that use case
>>>> this is great.

+1

[...]
>>>
>>> In the case of the standard page size being 4K a standard page would
>>> just have to take on the CPU overhead of the atomic_set and
>>> atomic_read for pp_ref_count (new name) which should be minimal as on
>>> most sane systems those just end up being a memory write and read.
>>
>> If I understand you correctly, I think what you are trying to do
>> may break some of Jesper' benchmarking:)
>>
>> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> 
> So? If it breaks an out-of-tree benchmark the benchmark can always be
> fixed. 

It doesn't matter if this is out-of-tree (I should have upstreamed it 
when AKPM asked me to.)

Point is don't break my page_pool fast-path!!! :-P

> The point is enabling a use case that can add value across the
> board instead of trying to force the community to support a niche use
> case.

I'm all for creating a new API, lets call it netmem, that takes care of 
this use-case.
I'm *not* okay with this new API slowing down the page_pool fast-path.

Why not multiplex on a MEM_TYPE, like XDP_MEM_TYPE is prepared for?!?
Meaning the caller can choose which is the correct API call.
(thus, we can stay away from adding code to fast-path case)

See below, copy-paste of code that shows what I mean by multiplex on a 
MEM_TYPE.

> 
> Ideally we should get away from using the pages directly for most
> cases in page pool. In my mind the page pool should start operating
> more like __get_free_pages where what you get is a virtual address
> instead of the actual page. That way we could start abstracting it
> away and eventually get to something more like a true page_pool api
> instead of what feels like a set of add-ons for the page allocator.

Yes, I agree with Alex Duyck here.
Like when I looked at veth proposed changes, it also felt like a virtual 
address would be better than a page.

  addr = netmem_alloc(rq->page_pool, &truesize);

> Although at the end of the day this still feels more like we are just
> reimplementing slab so it is hard for me to say this is necessarily
> the best solution either.

Yes, we have to be careful not to re-implement the MM layer in network 
land ;-)

(below code copy-paste broke whitespaces)

$ git show
commit fe38c642d629f8361f76b25aa8732e5e331d0925 (HEAD -> pp_rm_workqueue04)
Author: Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Fri Jun 16 20:54:08 2023 +0200

     page_pool: code examplifying multiplexing on mem_type

     Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

diff --git a/include/net/xdp.h b/include/net/xdp.h
index d1c5381fc95f..c02ac82a1d79 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -42,6 +42,7 @@ enum xdp_mem_type {
         MEM_TYPE_PAGE_ORDER0,     /* Orig XDP full page model */
         MEM_TYPE_PAGE_POOL,
         MEM_TYPE_XSK_BUFF_POOL,
+       MEM_TYPE_PP_NETMEM,
         MEM_TYPE_MAX,
  };

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d03448a4c411..68be76efef00 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -353,7 +353,7 @@ static void page_pool_set_pp_info(struct page_pool 
*pool,
                                   struct page *page)
  {
         page->pp = pool;
-       page->pp_magic |= PP_SIGNATURE;
+       page->pp_magic |= PP_SIGNATURE | (MEM_TYPE_PAGE_POOL << 8);
         if (pool->p.init_callback)
                 pool->p.init_callback(page, pool->p.init_arg);
  }
@@ -981,6 +981,7 @@ bool page_pool_return_skb_page(struct page *page, 
bool napi_safe)
         struct napi_struct *napi;
         struct page_pool *pp;
         bool allow_direct;
+       int mem_type;

         page = compound_head(page);

@@ -991,9 +992,10 @@ bool page_pool_return_skb_page(struct page *page, 
bool napi_safe)
          * and page_is_pfmemalloc() is checked in __page_pool_put_page()
          * to avoid recycling the pfmemalloc page.
          */
-       if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
+       if (unlikely((page->pp_magic & ~0xF03UL) != PP_SIGNATURE))
                 return false;

+       mem_type = (page->pp_magic & 0xF00) >> 8;
         pp = page->pp;

         /* Allow direct recycle if we have reasons to believe that we are
@@ -1009,7 +1011,10 @@ bool page_pool_return_skb_page(struct page *page, 
bool napi_safe)
          * The page will be returned to the pool here regardless of the
          * 'flipped' fragment being in use or not.
          */
-       page_pool_put_full_page(pp, page, allow_direct);
+       if (mem_type == MEM_TYPE_PP_NETMEM)
+               pp_netmem_put_page(pp, page, allow_direct);
+       else
+               page_pool_put_full_page(pp, page, allow_direct);

         return true;
  }
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 41e5ca8643ec..dc4bfbe8f002 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -380,6 +380,11 @@ void __xdp_return(void *data, struct xdp_mem_info 
*mem, bool napi_direct,
         struct page *page;

         switch (mem->type) {
+       case MEM_TYPE_PP_NETMEM:
+               if (napi_direct && xdp_return_frame_no_direct())
+                       napi_direct = false;
+               pp_netmem_put(page->pp, data, napi_direct);
+               break;
         case MEM_TYPE_PAGE_POOL:
                 page = virt_to_head_page(data);
                 if (napi_direct && xdp_return_frame_no_direct())


