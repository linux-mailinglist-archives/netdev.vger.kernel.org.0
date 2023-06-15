Return-Path: <netdev+bounces-11217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C17EA731FED
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81EB32813D6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975292E0F6;
	Thu, 15 Jun 2023 18:27:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8348F2E0D8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 18:27:25 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDA710F7;
	Thu, 15 Jun 2023 11:27:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-25ea33087aaso447547a91.3;
        Thu, 15 Jun 2023 11:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686853641; x=1689445641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WL0vbTcVwidL9IJpT5c9YMdj81KxvnL+DV21KunorIQ=;
        b=pBF6z9g3n47UdBw717OPav7WsEL/+ISkgHV7FaBke5m/SJwmaxVd0Bdu3+FUOEiBHL
         8imrfw5ybVT9p8ew4VlPRczrTz1fQfwBuMpwpYdTEAQ3SBo0ImZ9E+TOSEe0FLprT5aZ
         XovTUQgYW/BYJ3CgChp9UN+d1oVf+BDMTfSa1G0g9/GXTww2tH/+dJMm+Vi51kSAXuAg
         ZR3d+r2mncc7yp58MqrC1wXLpQKieYxt5wWRly+tTLVlkgKj4zgwkgzdPQAlOCyfirx4
         +tHrK7qgk0wK0bm8E6eCeWDLNzCqBuBGuUNIiPMP8o8k0HIz1X87pQIRVx1hasK9r1Ar
         OPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686853641; x=1689445641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WL0vbTcVwidL9IJpT5c9YMdj81KxvnL+DV21KunorIQ=;
        b=M+Kq5bSWa7yJXrTErGDUnLg14yoh9kcjndIFxcptoW4R6TVcKZn2H0K6OqM7R2DZwH
         SLuXs4ioNWL+KmQfItBaUpxzP1Ybn3KKqxmIT89G1k7XaGQK+/3e9WdO8iAq8kate0vT
         3RGQXa7+R2W31uWc8k286BX1HnOA+eGZ2NmIDdhwOWZEWd2tVo8o4ZI8M3M50wuhwzAr
         U8nLMGXZBFr3hoUgeX6O7yxxvqxOViQxqf9KJOuQN8BPclHU1t7YHRENrogsX9fYvaWS
         Gl70CR2CoPEl2TvEVylXfFUCn82sBIStGNr6wP/D0E0/0ru9vf9ViIM9EQ/dh/WAitJw
         JmZQ==
X-Gm-Message-State: AC+VfDwAxbdzIqKxqBcxz3A6llwk1FfIJinu5Vq0zq53uRRe8dgWPAE0
	nFrLK23VYM5hXqvbd8oAqi+5dSb4AZ20ARw95YQ=
X-Google-Smtp-Source: ACHHUZ7W/fay7a5zhoaquRDXMXuhr/x2Z1DcfHV31Rrp9dYAWBYrZb7M3EGp7RzaB/+ml0JAorgPkb0OwUfa8kds+vg=
X-Received: by 2002:a17:90a:ab12:b0:24d:f59a:d331 with SMTP id
 m18-20020a17090aab1200b0024df59ad331mr5114572pjq.26.1686853640525; Thu, 15
 Jun 2023 11:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612130256.4572-1-linyunsheng@huawei.com> <20230612130256.4572-5-linyunsheng@huawei.com>
 <20230614101954.30112d6e@kernel.org> <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
 <20230615095100.35c5eb10@kernel.org>
In-Reply-To: <20230615095100.35c5eb10@kernel.org>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 15 Jun 2023 11:26:44 -0700
Message-ID: <CAKgT0Uc6Xoyh3Edgt+83b+HTM5j4JDr3fuxcyL9qDk+Wwt9APg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG flag
To: Jakub Kicinski <kuba@kernel.org>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, pabeni@redhat.com, 
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

On Thu, Jun 15, 2023 at 9:51=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 15 Jun 2023 15:17:39 +0800 Yunsheng Lin wrote:
> > > Does hns3_page_order() set a good example for the users?
> > >
> > > static inline unsigned int hns3_page_order(struct hns3_enet_ring *rin=
g)
> > > {
> > > #if (PAGE_SIZE < 8192)
> > >     if (ring->buf_size > (PAGE_SIZE / 2))
> > >             return 1;
> > > #endif
> > >     return 0;
> > > }
> > >
> > > Why allocate order 1 pages for buffers which would fit in a single pa=
ge?
> > > I feel like this soft of heuristic should be built into the API itsel=
f.
> >
> > hns3 only support fixed buf size per desc by 512 byte, 1024 bytes, 2048=
 bytes
> > 4096 bytes, see hns3_buf_size2type(), I think the order 1 pages is for =
buf size
> > with 4096 bytes and system page size with 4K, as hns3 driver still supp=
ort the
> > per-desc ping-pong way of page splitting when page_pool_enabled is fals=
e.
> >
> > With page pool enabled, you are right that order 0 pages is enough, and=
 I am not
> > sure about the exact reason we use the some order as the ping-pong way =
of page
> > splitting now.
> > As 2048 bytes buf size seems to be the default one, and I has not heard=
 any one
> > changing it. Also, it caculates the pool_size using something as below,=
 so the
> > memory usage is almost the same for order 0 and order 1:
> >
> > .pool_size =3D ring->desc_num * hns3_buf_size(ring) /
> >               (PAGE_SIZE << hns3_page_order(ring)),
> >
> > I am not sure it worth changing it, maybe just change it to set good ex=
ample for
> > the users:) anyway I need to discuss this with other colleague internal=
ly and do
> > some testing before doing the change.
>
> Right, I think this may be a leftover from the page flipping mode of
> operation. But AFAIU we should leave the recycling fully to the page
> pool now. If we make any improvements try to make them at the page pool
> level.
>
> I like your patches as they isolate the drivers from having to make the
> fragmentation decisions based on the system page size (4k vs 64k but
> we're hearing more and more about ARM w/ 16k pages). For that use case
> this is great.
>
> What we don't want is drivers to start requesting larger page sizes
> because it looks good in iperf on a freshly booted, idle system :(

Actually that would be a really good direction for this patch set to
look at going into. Rather than having us always allocate a "page" it
would make sense for most drivers to allocate a 4K fragment or the
like in the case that the base page size is larger than 4K. That might
be a good use case to justify doing away with the standard page pool
page and look at making them all fragmented.

In the case of the standard page size being 4K a standard page would
just have to take on the CPU overhead of the atomic_set and
atomic_read for pp_ref_count (new name) which should be minimal as on
most sane systems those just end up being a memory write and read.

