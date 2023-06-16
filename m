Return-Path: <netdev+bounces-11480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B64B73341E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A28CB2817C9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134E51773F;
	Fri, 16 Jun 2023 15:01:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BA413AC9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:01:54 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223CC1FF9;
	Fri, 16 Jun 2023 08:01:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25bec2512f3so687515a91.0;
        Fri, 16 Jun 2023 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927703; x=1689519703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwOiF1tuQY0sMSzPSitIXKF3uUPCmzP49g6125H5nno=;
        b=iFSLtmOZxcYOYrhk8SjOyBfNSdHP6AxxWzy1ZOozDYnPcQghaoGALev11CBsXLS2oJ
         W1TblpdgaZjZFhzAjUdJr7Gm50KRcc6rVYkEzZYfX1SokDSLSRnFQHqd5JalEqOM18Ts
         84h3OHZV3xEWlkzCH27P0UJdHBP1r4S3d2pZLTm5yhCeO3WtQnOWAKzcipwkZAprXZ9t
         g0LKmiM/GmvN9axhV8Vo7vXmG/+3s6dro6zqfVJneOimcIxrBYfIuoMI16rU5yNmrYrZ
         E3O2Mplnv4X1vaPEQcTVZ6hJTbeVbFCYOw62zOSZITHBFAGXhVyzIY3yWAtnX/rVuXU3
         xKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927703; x=1689519703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwOiF1tuQY0sMSzPSitIXKF3uUPCmzP49g6125H5nno=;
        b=TFC/j2N+/6CHfidwTOl+CDbkywzQpBGkrcM9fim4Co5Xhi/YzOzSNvSPWMb7Wkv0su
         8A4td+5hQJKdfBkRLn9UdhNs54IqjTWpp9dH1jwL5ALNUHpM3CBRnlPHf6+QYCWKzlko
         vxcnTlNSDmnZDk+bTDwxZnjOf7IDkH+irZzlAiNrTSzYrhBsuwGCy6V8Mbxc9wX0C7xk
         bmvpDlgul57Dq6VRTQ9JRnXDVHGZl+hiuk17t2Rs6wkca3w+gDkUxwgLiuDnj/56f3Vo
         yhXWaRFjTVKQSSBmZ6IQNAYey2DRoClNWJiiCGq0CR5GmYyLnnw6IvFlPkmuS5nbsLH2
         3rdw==
X-Gm-Message-State: AC+VfDxJeY2TLlDnbqrrKkQfpxqushITZJCD5rtEG+HtPmpcOr7iqL5Q
	5rFns0S4YEgBMU0OCvrwPyFxsNE/dcthXhQv3A4=
X-Google-Smtp-Source: ACHHUZ77zEMr391VkMkn9d2iAhClJSSjtNS9e51eYfXDvhlQE+zZedlzrQdlBGNPeFhzQ6xAip3Q4qDF+0aRqQmqwIE=
X-Received: by 2002:a17:90a:7f05:b0:250:648b:781d with SMTP id
 k5-20020a17090a7f0500b00250648b781dmr10488732pjl.23.1686927703194; Fri, 16
 Jun 2023 08:01:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612130256.4572-1-linyunsheng@huawei.com> <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org> <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
 <20230615095100.35c5eb10@kernel.org> <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
 <908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
In-Reply-To: <908b8b17-f942-f909-61e6-276df52a5ad5@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 16 Jun 2023 08:01:06 -0700
Message-ID: <CAKgT0UeZfbxDYaeUntrQpxHmwCh6zy0dEpjxghiCNxPxv=kdoQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Yisen Zhuang <yisen.zhuang@huawei.com>, 
	Salil Mehta <salil.mehta@huawei.com>, Eric Dumazet <edumazet@google.com>, 
	Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, hariprasad <hkelam@marvell.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 5:21=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/6/16 2:26, Alexander Duyck wrote:
> > On Thu, Jun 15, 2023 at 9:51=E2=80=AFAM Jakub Kicinski <kuba@kernel.org=
> wrote:
> >>
> >> On Thu, 15 Jun 2023 15:17:39 +0800 Yunsheng Lin wrote:
> >>>> Does hns3_page_order() set a good example for the users?
> >>>>
> >>>> static inline unsigned int hns3_page_order(struct hns3_enet_ring *ri=
ng)
> >>>> {
> >>>> #if (PAGE_SIZE < 8192)
> >>>>     if (ring->buf_size > (PAGE_SIZE / 2))
> >>>>             return 1;
> >>>> #endif
> >>>>     return 0;
> >>>> }
> >>>>
> >>>> Why allocate order 1 pages for buffers which would fit in a single p=
age?
> >>>> I feel like this soft of heuristic should be built into the API itse=
lf.
> >>>
> >>> hns3 only support fixed buf size per desc by 512 byte, 1024 bytes, 20=
48 bytes
> >>> 4096 bytes, see hns3_buf_size2type(), I think the order 1 pages is fo=
r buf size
> >>> with 4096 bytes and system page size with 4K, as hns3 driver still su=
pport the
> >>> per-desc ping-pong way of page splitting when page_pool_enabled is fa=
lse.
> >>>
> >>> With page pool enabled, you are right that order 0 pages is enough, a=
nd I am not
> >>> sure about the exact reason we use the some order as the ping-pong wa=
y of page
> >>> splitting now.
> >>> As 2048 bytes buf size seems to be the default one, and I has not hea=
rd any one
> >>> changing it. Also, it caculates the pool_size using something as belo=
w, so the
> >>> memory usage is almost the same for order 0 and order 1:
> >>>
> >>> .pool_size =3D ring->desc_num * hns3_buf_size(ring) /
> >>>               (PAGE_SIZE << hns3_page_order(ring)),
> >>>
> >>> I am not sure it worth changing it, maybe just change it to set good =
example for
> >>> the users:) anyway I need to discuss this with other colleague intern=
ally and do
> >>> some testing before doing the change.
> >>
> >> Right, I think this may be a leftover from the page flipping mode of
> >> operation. But AFAIU we should leave the recycling fully to the page
> >> pool now. If we make any improvements try to make them at the page poo=
l
> >> level.
>
> I checked, the per-desc buf with 4096 bytes for hnse does not seem to
> be used mainly because of the larger memory usage you mentioned below.
>
> >>
> >> I like your patches as they isolate the drivers from having to make th=
e
> >> fragmentation decisions based on the system page size (4k vs 64k but
> >> we're hearing more and more about ARM w/ 16k pages). For that use case
> >> this is great.
>
> Yes, That is my point. For hw case, the page splitting in page pool is
> mainly to enble multi-descs to use the same page as my understanding.
>
> >>
> >> What we don't want is drivers to start requesting larger page sizes
> >> because it looks good in iperf on a freshly booted, idle system :(
> >
> > Actually that would be a really good direction for this patch set to
> > look at going into. Rather than having us always allocate a "page" it
> > would make sense for most drivers to allocate a 4K fragment or the
> > like in the case that the base page size is larger than 4K. That might
> > be a good use case to justify doing away with the standard page pool
> > page and look at making them all fragmented.
>
> I am not sure if I understand the above, isn't the frag API able to
> support allocating a 4K fragment when base page size is larger than
> 4K before or after this patch? what more do we need to do?

I'm not talking about the frag API. I am talking about the
non-fragmented case. Right now standard page_pool will allocate an
order 0 page. So if a driver is using just pages expecting 4K pages
that isn't true on these ARM or PowerPC systems where the page size is
larger than 4K.

For a bit of historical reference on igb/ixgbe they had a known issue
where they would potentially run a system out of memory when page size
was larger than 4K. I had originally implemented things with just the
refcounting hack and at the time it worked great on systems with 4K
pages. However on a PowerPC it would trigger OOM errors because they
could run with 64K pages. To fix that I started adding all the
PAGE_SIZE checks in the driver and moved over to a striping model for
those that would free the page when it reached the end in order to
force it to free the page and make better use of the available memory.

> >
> > In the case of the standard page size being 4K a standard page would
> > just have to take on the CPU overhead of the atomic_set and
> > atomic_read for pp_ref_count (new name) which should be minimal as on
> > most sane systems those just end up being a memory write and read.
>
> If I understand you correctly, I think what you are trying to do
> may break some of Jesper' benchmarking:)
>
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/l=
ib/bench_page_pool_simple.c

So? If it breaks an out-of-tree benchmark the benchmark can always be
fixed. The point is enabling a use case that can add value across the
board instead of trying to force the community to support a niche use
case.

Ideally we should get away from using the pages directly for most
cases in page pool. In my mind the page pool should start operating
more like __get_free_pages where what you get is a virtual address
instead of the actual page. That way we could start abstracting it
away and eventually get to something more like a true page_pool api
instead of what feels like a set of add-ons for the page allocator.
Although at the end of the day this still feels more like we are just
reimplementing slab so it is hard for me to say this is necessarily
the best solution either.

