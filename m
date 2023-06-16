Return-Path: <netdev+bounces-11556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3869A7339B3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D3ED1C20ACA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAC01DDDB;
	Fri, 16 Jun 2023 19:21:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FE11B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D73FC433C0;
	Fri, 16 Jun 2023 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686943302;
	bh=hUURytXlMcDfitAbduozrB5DyB72nWHC+HvK485KkJY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ad6swJdWo1IwISr5c/t9icf18UMj2lCExyhlgLv+O+KgaYu/qZg8ZZ19ks7CRln5E
	 th4SmFbPGuTwMIGWdBPmtnkEM1h2OX6Nib1afv4AR2f2DybEiJNrBhoHPj7vetKS+D
	 RcEols5/yqQmNho1ySddtpAimBACwAUt7LSdNXjRvv3zf2+ztH5QxDP7FrFynityCd
	 WEcYDgO2xfbntUyjU4vDS/KZxH/Y5WpDdFnzn7ZNIBTuOYk7HBxSz12lldH6KT9VV4
	 FIMWxf5Rxd7oFaVbCxDughxs/4yROiz12DdTIU7tVLWKYHhXtEt8eESRjH8vAEURe4
	 nw+TGWsF+9gZg==
Date: Fri, 16 Jun 2023 12:21:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Yunsheng Lin
 <linyunsheng@huawei.com>, brouer@redhat.com, davem@davemloft.net,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>, Yisen Zhuang
 <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Eric
 Dumazet <edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
 hariprasad <hkelam@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, Ryder Lee
 <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
 <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, Matthias Brugger
 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG
 flag
Message-ID: <20230616122140.6e889357@kernel.org>
In-Reply-To: <72ccf224-7b45-76c5-5ca9-83e25112c9c6@redhat.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-5-linyunsheng@huawei.com>
	<20230614101954.30112d6e@kernel.org>
	<8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
	<20230615095100.35c5eb10@kernel.org>
	<CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
	<908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
	<CAKgT0UeZfbxDYaeUntrQpxHmwCh6zy0dEpjxghiCNxPxv=kdoQ@mail.gmail.com>
	<72ccf224-7b45-76c5-5ca9-83e25112c9c6@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 20:59:12 +0200 Jesper Dangaard Brouer wrote:
> +       if (mem_type == MEM_TYPE_PP_NETMEM)
> +               pp_netmem_put_page(pp, page, allow_direct);
> +       else
> +               page_pool_put_full_page(pp, page, allow_direct);

Interesting, what is the netmem type? I was thinking about extending
page pool for other mem providers and what came to mind was either
optionally replacing the free / alloc with a function pointer:

https://github.com/torvalds/linux/commit/578ebda5607781c0abb26c1feae7ec8b83840768

or wrapping the PP calls with static inlines which can direct to 
a different implementation completely (like zctap / io_uring zc).

Former is better for huge pages, latter is better for IO mem
(peer-to-peer DMA). I wonder if you have different use case which
requires a different model :(

