Return-Path: <netdev+bounces-11614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E3C733B19
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C29928135A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30CB6139;
	Fri, 16 Jun 2023 20:42:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C798946B9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:42:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2029B30EF
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686948160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NSJLIyj9LMYS53Im9VxxQ75KAnWRMymE9tH9+QGjBNs=;
	b=c2RjwrsRtZ2UodpnaZbHhL1TvE4NnmjHTU8PAXlk+MDxCNF+4KMo8woWaasYPRG/isZm2b
	Jx5UtHLQT7DEuy/lPpUq4RKPj20J2xI8rQp5bsbqbNlITqygBs9z1wkpjNZ/IIQX4JCcPk
	6ACfiwSoN9+sO9psN1htuoJt7FqQyYg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-Vc2Bsm-IMR-o_6cyKGX0Rw-1; Fri, 16 Jun 2023 16:42:39 -0400
X-MC-Unique: Vc2Bsm-IMR-o_6cyKGX0Rw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso77179266b.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686948158; x=1689540158;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NSJLIyj9LMYS53Im9VxxQ75KAnWRMymE9tH9+QGjBNs=;
        b=NrjWngyIUlNJm7/6Fr0cw/vLWaFF/wSN3Sm0GBBu/iORtYRh4R/SpbBuUdx9wZKc9P
         9qS0iBRGc81yQJrLO+5aLA1E9h92H6G5NJ3gu9M2U//bkQgRSW8gLAxA9xxPLSylllOf
         gwXKX5Ls+H5lLJIUpQwerAYE7rwVZoTS9g2VjbxsnZMd79WB/TNt8FZyJ96FK6cZMomm
         tuR1KlxVXbxICJ3RyTvbtY9WLe+uy/tVNKoeIOC0d/vpuxXBKayS18woX2E8Z+doO1GS
         Da+9EqagfwX6kMP86FPKs6V+8ZmgKPgtb1MWPbuKV+PGowLYgrg8jmKDWc3T5PrXyBoc
         M14A==
X-Gm-Message-State: AC+VfDyRf9BR2S+ks4QRdcP4Wv8DdjlD1EX4pGPOMzEucinxnac2JIxB
	0JItc0UKh6hIriCs3mPVM2VU4y4Dh5yWbs5HvjsB1gTFFBTmC4oxz2KrBRKsbvN7xP6UENS/aHP
	mHC31jVV4aD13mWMW
X-Received: by 2002:a17:907:97cb:b0:969:f9e8:a77c with SMTP id js11-20020a17090797cb00b00969f9e8a77cmr2710822ejc.64.1686948158074;
        Fri, 16 Jun 2023 13:42:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ehYaK04S4/TY2b/iTlXKHTkxro6SsSNCPMtcO8/kHNHdFogckXjJZEm+Tpaj5nWU8CSFc3g==
X-Received: by 2002:a17:907:97cb:b0:969:f9e8:a77c with SMTP id js11-20020a17090797cb00b00969f9e8a77cmr2710788ejc.64.1686948157766;
        Fri, 16 Jun 2023 13:42:37 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id b19-20020a170906491300b00985036aced0sm1439806ejq.163.2023.06.16.13.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 13:42:37 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <eadebd58-d79a-30b6-87aa-1c77acb2ec17@redhat.com>
Date: Fri, 16 Jun 2023 22:42:35 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
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
 linux-mediatek@lists.infradead.org, Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Memory providers multiplexing (Was: [PATCH net-next v4 4/5]
 page_pool: remove PP_FLAG_PAGE_FRAG flag)
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org>
 <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
 <20230615095100.35c5eb10@kernel.org>
 <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
 <908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
 <CAKgT0UeZfbxDYaeUntrQpxHmwCh6zy0dEpjxghiCNxPxv=kdoQ@mail.gmail.com>
 <72ccf224-7b45-76c5-5ca9-83e25112c9c6@redhat.com>
 <20230616122140.6e889357@kernel.org>
In-Reply-To: <20230616122140.6e889357@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 16/06/2023 21.21, Jakub Kicinski wrote:
> On Fri, 16 Jun 2023 20:59:12 +0200 Jesper Dangaard Brouer wrote:
>> +       if (mem_type == MEM_TYPE_PP_NETMEM)
>> +               pp_netmem_put_page(pp, page, allow_direct);
>> +       else
>> +               page_pool_put_full_page(pp, page, allow_direct);
> 
> Interesting, what is the netmem type? I was thinking about extending
> page pool for other mem providers and what came to mind was either
> optionally replacing the free / alloc with a function pointer:
> 
> https://github.com/torvalds/linux/commit/578ebda5607781c0abb26c1feae7ec8b83840768
> 
> or wrapping the PP calls with static inlines which can direct to
> a different implementation completely (like zctap / io_uring zc).
> 

I *LOVE* this idea!!!
It have been my master plan since day-1 to have other mem providers.
Notice how ZC xsk/AF_XDP have it's own memory allocator implementation.

The page_pool was never meant to be the final and best solution, I want
to see other, better and faster solutions competing with page_pool and
maybe some day replacing page_pool (I even see it as a success if PP get
depreciated and remove from the kernel due to a better solution).

See[1] how net/core/xdp.c simply have a switch statement
(is fast, because ASM wise it becomes a jump table):

  [1] 
https://github.com/torvalds/linux/blob/v6.4-rc6/net/core/xdp.c#L382-L402

> Former is better for huge pages, latter is better for IO mem
> (peer-to-peer DMA). I wonder if you have different use case which
> requires a different model :(
> 

I want for the network stack SKBs (and XDP) to support different memory
types for the "head" frame and "data-frags". Eric have described this
idea before, that hardware will do header-split, and we/he can get TCP
data part is another page/frag, making it faster for TCP-streams, but
this can be used for much more.

My proposed use-cases involves more that TCP.  We can easily imagine
NVMe protocol header-split, and the data-frag could be a mem_type that
actually belongs to the harddisk (maybe CPU cannot even read this).  The
same scenario goes for GPU memory, which is for the AI use-case.  IIRC
then Jonathan have previously send patches for the GPU use-case.

I really hope we can work in this direction together,
--Jesper


