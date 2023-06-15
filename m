Return-Path: <netdev+bounces-10999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E6573105E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 306651C204D6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE281371;
	Thu, 15 Jun 2023 07:17:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BB635
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:17:45 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518112D58;
	Thu, 15 Jun 2023 00:17:43 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QhYQf3z32z18LrV;
	Thu, 15 Jun 2023 15:12:42 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 15:17:40 +0800
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>, Yisen Zhuang
	<yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Eric Dumazet
	<edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya
	<gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>, hariprasad
	<hkelam@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, Ryder Lee
	<ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
	<sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-rdma@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
Date: Thu, 15 Jun 2023 15:17:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230614101954.30112d6e@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/15 1:19, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 21:02:55 +0800 Yunsheng Lin wrote:
>>  	struct page_pool_params pp_params = {
>> -		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG |
>> -				PP_FLAG_DMA_SYNC_DEV,
>> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>>  		.order = hns3_page_order(ring),
> 
> Does hns3_page_order() set a good example for the users?
> 
> static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
> {
> #if (PAGE_SIZE < 8192)
> 	if (ring->buf_size > (PAGE_SIZE / 2))
> 		return 1;
> #endif
> 	return 0;
> }
> 
> Why allocate order 1 pages for buffers which would fit in a single page?
> I feel like this soft of heuristic should be built into the API itself.

hns3 only support fixed buf size per desc by 512 byte, 1024 bytes, 2048 bytes
4096 bytes, see hns3_buf_size2type(), I think the order 1 pages is for buf size
with 4096 bytes and system page size with 4K, as hns3 driver still support the
per-desc ping-pong way of page splitting when page_pool_enabled is false.

With page pool enabled, you are right that order 0 pages is enough, and I am not
sure about the exact reason we use the some order as the ping-pong way of page
splitting now.
As 2048 bytes buf size seems to be the default one, and I has not heard any one
changing it. Also, it caculates the pool_size using something as below, so the
memory usage is almost the same for order 0 and order 1:

.pool_size = ring->desc_num * hns3_buf_size(ring) /
		(PAGE_SIZE << hns3_page_order(ring)),

I am not sure it worth changing it, maybe just change it to set good example for
the users:) anyway I need to discuss this with other colleague internally and do
some testing before doing the change.

> .
> 

