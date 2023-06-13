Return-Path: <netdev+bounces-10406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1307372E5E8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0261C1C209E8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CF9171BA;
	Tue, 13 Jun 2023 14:37:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C2A23DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:37:02 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52062189;
	Tue, 13 Jun 2023 07:36:58 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-66577752f05so1858835b3a.0;
        Tue, 13 Jun 2023 07:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686667017; x=1689259017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLlWFUrferj4g53iCG/BqiTgqM0UBmr45zNNhlToYsg=;
        b=sHHJ811WGZ0/KTLmPkqZTw5cwc+f5LM8YHBQMbgtDmanyn/amD0IFUH92FzMNGAXkC
         2XrjrXgN7rcDF05BXRObHVuCs8qiVLxe3Yh4t0nQlSibV3ZTN0FjAB3Sa7SEiJzKwiiR
         Q1kWNxNO3SXOCZ3b6xG/EiiuBsaxbnQVs7P/q/Pgugxx2eTJ7Z/BCWVp8WABZ61VFPD6
         QLT0amN7kPrcmyEZFDQcA0yULahj0reoNJQaXPvefaFDMBB5Wu4sNnnUIrDtoryyP3oK
         fFWkqiYla1FhB0vWv4TO5b2QHEEQ7l4ZrujV+JZk8ms7AaRMFDJSIXOybVHJQOsNoG42
         6yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667017; x=1689259017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLlWFUrferj4g53iCG/BqiTgqM0UBmr45zNNhlToYsg=;
        b=OMBiafQ7vfsNgoCRMAcC756zrLltI6obkE86GH1H/sxri34a2aiQOrm8nU299c3ITu
         Zxx1D0TTq3jjj7YF5N4KmwQU5il/9CPoFU8p/epD10znPgGM76nsruhSoPPlaeBerEvD
         xziwmZk66Qi11a/IT29MSbDaWGBHynGz8yuGEcxBr6vQkV5Y4CFJWuCz7T7LncPo/ttg
         3WQS5//QzPJ542NmGxwmW4WLH6g/X+8zRq4vp5wO2tCSy/xWrfLblnZ7Qnj4wAyYdRmE
         8PRtdo8xkTH0ppARtWVxFatrWorWztVazux2K3wf3rGXJ0cqx/D8+CkpHfWqT4lVlvxS
         WFJA==
X-Gm-Message-State: AC+VfDwT52E4F2qChy2/NdsXa88CykNbz3LRA+ZF3FWvzUSwT3iAeUUE
	0DkyHlMhP6t1RhdUdkkmVy+bmLmK4FTZ3TYwTfc=
X-Google-Smtp-Source: ACHHUZ6u0QPb/MLm3qUBJ+eJ+cQrRYBHsqNihv7qkWgiSmZWQA2adGcVjOOkPMF4ZK5+TbCH0xRRJeOmsBiNRsCcpF4=
X-Received: by 2002:a17:90b:3a86:b0:259:bdb:6956 with SMTP id
 om6-20020a17090b3a8600b002590bdb6956mr10601398pjb.7.1686667017272; Tue, 13
 Jun 2023 07:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609131740.7496-1-linyunsheng@huawei.com> <20230609131740.7496-4-linyunsheng@huawei.com>
In-Reply-To: <20230609131740.7496-4-linyunsheng@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Tue, 13 Jun 2023 07:36:20 -0700
Message-ID: <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc() API
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 6:20=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> Currently page pool supports the below use cases:
> use case 1: allocate page without page splitting using
>             page_pool_alloc_pages() API if the driver knows
>             that the memory it need is always bigger than
>             half of the page allocated from page pool.
> use case 2: allocate page frag with page splitting using
>             page_pool_alloc_frag() API if the driver knows
>             that the memory it need is always smaller than
>             or equal to the half of the page allocated from
>             page pool.
>
> There is emerging use case [1] & [2] that is a mix of the
> above two case: the driver doesn't know the size of memory it
> need beforehand, so the driver may use something like below to
> allocate memory with least memory utilization and performance
> penalty:
>
> if (size << 1 > max_size)
>         page =3D page_pool_alloc_pages();
> else
>         page =3D page_pool_alloc_frag();
>
> To avoid the driver doing something like above, add the
> page_pool_alloc() API to support the above use case, and update
> the true size of memory that is acctually allocated by updating
> '*size' back to the driver in order to avoid the truesize
> underestimate problem.
>
> 1. https://lore.kernel.org/all/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1=
683896626.git.lorenzo@kernel.org/
> 2. https://lore.kernel.org/all/20230526054621.18371-3-liangchen.linux@gma=
il.com/
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> ---
>  include/net/page_pool.h | 43 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 0b8cd2acc1d7..c135cd157cea 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -260,6 +260,49 @@ static inline struct page *page_pool_dev_alloc_frag(=
struct page_pool *pool,
>         return page_pool_alloc_frag(pool, offset, size, gfp);
>  }
>
> +static inline struct page *page_pool_alloc(struct page_pool *pool,
> +                                          unsigned int *offset,
> +                                          unsigned int *size, gfp_t gfp)
> +{
> +       unsigned int max_size =3D PAGE_SIZE << pool->p.order;
> +       struct page *page;
> +
> +       *size =3D ALIGN(*size, dma_get_cache_alignment());
> +
> +       if (WARN_ON(*size > max_size))
> +               return NULL;
> +
> +       if ((*size << 1) > max_size || PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +               *size =3D max_size;
> +               *offset =3D 0;
> +               return page_pool_alloc_pages(pool, gfp);
> +       }
> +
> +       page =3D __page_pool_alloc_frag(pool, offset, *size, gfp);
> +       if (unlikely(!page))
> +               return NULL;
> +
> +       /* There is very likely not enough space for another frag, so app=
end the
> +        * remaining size to the current frag to avoid truesize underesti=
mate
> +        * problem.
> +        */
> +       if (pool->frag_offset + *size > max_size) {
> +               *size =3D max_size - *offset;
> +               pool->frag_offset =3D max_size;
> +       }
> +

Rather than preventing a truesize underestimation this will cause one.
You are adding memory to the size of the page reserved and not
accounting for it anywhere as this isn't reported up to the network
stack. I would suggest dropping this from your patch.

> +       return page;
> +}
> +
> +static inline struct page *page_pool_dev_alloc(struct page_pool *pool,
> +                                              unsigned int *offset,
> +                                              unsigned int *size)
> +{
> +       gfp_t gfp =3D (GFP_ATOMIC | __GFP_NOWARN);
> +
> +       return page_pool_alloc(pool, offset, size, gfp);
> +}
> +
>  /* get the stored dma direction. A driver might decide to treat this loc=
ally and
>   * avoid the extra cache line from page_pool to determine the direction
>   */
> --
> 2.33.0
>

