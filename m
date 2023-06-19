Return-Path: <netdev+bounces-12053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A847735D41
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F25281182
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8933B1426B;
	Mon, 19 Jun 2023 18:07:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4458F13AF9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85C3C433C8;
	Mon, 19 Jun 2023 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687198027;
	bh=XNrWx0e+VFb0jaH8wmeXcZNg0osk8eDrh+qYB5nAfyk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hnq0AOiprtBC3qrex4NKnoSCrfoj8sJY8nyfDOYmMWS+LAdWlLROaAKj8NrHdAqKV
	 gVhM8EURFdB3wFLNb5+cKug0R7eGHAYnxKLQtws1cQD1w4jy4qo3Hb7J1+QEk+tsBU
	 CwaUfd+n40I3VQBfJ115llahzE5XrSWAEPqImjrhQ0Q9+4yBUo9WuCwv+e9Jgp1nFc
	 JK4Y6V1bPN+wKsKswtz5r475G3cj3+O1jsBSXMG326is1pnTd64o/YSXvOjdb2TDxy
	 /MScaTumbH45kNF4b2HPmMzPaXxYXkmbDyTzbrZl34qcyt4Si2iWxAdohcw8Fn2wxj
	 eAVJ5xQrBneyw==
Date: Mon, 19 Jun 2023 11:07:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: brouer@redhat.com, Alexander Duyck <alexander.duyck@gmail.com>, Yunsheng
 Lin <linyunsheng@huawei.com>, davem@davemloft.net, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Bianconi
 <lorenzo@kernel.org>, Yisen Zhuang <yisen.zhuang@huawei.com>, Salil Mehta
 <salil.mehta@huawei.com>, Eric Dumazet <edumazet@google.com>, Sunil Goutham
 <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>, Subbaraya
 Sundeep <sbhatta@marvell.com>, hariprasad <hkelam@marvell.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Felix
 Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen
 <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Kalle Valo
 <kvalo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, linux-rdma@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, Jonathan Lemon
 <jonathan.lemon@gmail.com>
Subject: Re: Memory providers multiplexing (Was: [PATCH net-next v4 4/5]
 page_pool: remove PP_FLAG_PAGE_FRAG flag)
Message-ID: <20230619110705.106ec599@kernel.org>
In-Reply-To: <eadebd58-d79a-30b6-87aa-1c77acb2ec17@redhat.com>
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
	<eadebd58-d79a-30b6-87aa-1c77acb2ec17@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 22:42:35 +0200 Jesper Dangaard Brouer wrote:
> > Former is better for huge pages, latter is better for IO mem
> > (peer-to-peer DMA). I wonder if you have different use case which
> > requires a different model :(
> 
> I want for the network stack SKBs (and XDP) to support different memory
> types for the "head" frame and "data-frags". Eric have described this
> idea before, that hardware will do header-split, and we/he can get TCP
> data part is another page/frag, making it faster for TCP-streams, but
> this can be used for much more.
> 
> My proposed use-cases involves more that TCP.  We can easily imagine
> NVMe protocol header-split, and the data-frag could be a mem_type that
> actually belongs to the harddisk (maybe CPU cannot even read this).  The
> same scenario goes for GPU memory, which is for the AI use-case.  IIRC
> then Jonathan have previously send patches for the GPU use-case.
> 
> I really hope we can work in this direction together,

Perfect, that's also the use case I had in mind. The huge page thing
was just a quick thing to implement as a PoC (although useful in its
own right, one day I'll find the time to finish it, sigh).

That said I couldn't convince myself that for a peer-to-peer setup we
have enough space in struct page to store all the information we need.
Or that we'd get a struct page at all, and not just a region of memory
with no struct page * allocated :S

That'd require serious surgery on the page pool's fast paths to work
around.

I haven't dug into the details, tho. If you think we can use page pool
as a frontend for iouring and/or p2p memory that'd be awesome!

The workaround solution I had in mind would be to create a narrower API
for just data pages. Since we'd need to sprinkle ifs anyway, pull them
up close to the call site. Allowing to switch page pool for a
completely different implementation, like the one Jonathan coded up for
iouring. Basically

$name_alloc_page(queue)
{
	if (queue->pp)
		return page_pool_dev_alloc_pages(queue->pp);
	else if (queue->iouring..)
		...
}

