Return-Path: <netdev+bounces-10751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F641730187
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA2528145E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E313DDC5;
	Wed, 14 Jun 2023 14:19:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E1DC2FF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:19:10 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10AE10D8;
	Wed, 14 Jun 2023 07:19:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-25e247414d9so340644a91.1;
        Wed, 14 Jun 2023 07:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686752348; x=1689344348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j45S64yVRtWNmXi9+AQpAX/jaYs8Bbc2x/KQu3uuygo=;
        b=lGNA8g/XUZhtMjdIGr5d3t83lKAAlZkr5+qkiFZuJ1870yee6pz6Ea/XZpsaogva4h
         Ie4KxBWdz2y02qLCLW4QTnS35H0IxGzNaR7Z7CZZf7ypBiMIkRyIlI/BjqFWvqYucfiY
         VBVsFuwHWRgxyL5m5ewLJZTN8xtU4bnccg0j3RSLnrS0qYrpYz5P+SuZvtfz5kNl1Ez8
         j6kr7dXOXrn3PibKwXTJNtZ7DsEuPPwxnxLjLoZ0GZD2MlwLZ7DV8qfT9EySXmjKTxP/
         pz0FGVN0MzfAQ4HlWrbCSnWvetd4/+0eGik/vTY5zezVtO+K7gEZczhkeY2ha2iWq7km
         OAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686752348; x=1689344348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j45S64yVRtWNmXi9+AQpAX/jaYs8Bbc2x/KQu3uuygo=;
        b=K7muAopsdrXsIGj4x3ZJdrMPN35Nt9zNVxzVM/1hl6fYqhMkvutCvzQNZOx1Bel2hb
         pCRlalS+X6Tnndlf9EHbUWedxj3LX0CKBJuFiU3NTTDalj9mXdCWW7gcfHOPibH7FN34
         +c2Fc19pA7pTWzWfuuMHNZ7qp7Pi7dld6c+qM/TeL9a4Xm6+swHOK0YI9WLReyGCK09/
         fEwhFPd2evSH1nA2KdGpt5PnSyL8dGc+qymhFmSmNerUyRb2WxgwfBSlkcRyFH8dkK8R
         0t9+oHvypthxKIuorg8eWD+EknumIPdDZDtJvUDbFGvkWoPfcWpfexQF8DEKvrvuG9Ao
         lW5Q==
X-Gm-Message-State: AC+VfDwNqMn+nRESL6CLoh98S0X7XjCww4gJI8NTvqUJJwLa6A0YCFIE
	lo9QpL4v7zNcK1fgmVyYcZebZnKaIV+UVfJmnfQ=
X-Google-Smtp-Source: ACHHUZ4roEXXepcOtSNdTNs0VwxnLll6tA0/2fTae80GaMgdp4nAlRuQJ/EuKIebK1XhccvRUJJiqy/YsYFns3wYIx8=
X-Received: by 2002:a17:90b:214:b0:259:17bc:1a3c with SMTP id
 fy20-20020a17090b021400b0025917bc1a3cmr1385035pjb.7.1686752347917; Wed, 14
 Jun 2023 07:19:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609131740.7496-1-linyunsheng@huawei.com> <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com> <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
In-Reply-To: <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Wed, 14 Jun 2023 07:18:31 -0700
Message-ID: <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
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

On Tue, Jun 13, 2023 at 8:51=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/6/13 22:36, Alexander Duyck wrote:
> > On Fri, Jun 9, 2023 at 6:20=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei=
.com> wrote:
>
> ...
>
> >>
> >> +static inline struct page *page_pool_alloc(struct page_pool *pool,
> >> +                                          unsigned int *offset,
> >> +                                          unsigned int *size, gfp_t g=
fp)
> >> +{
> >> +       unsigned int max_size =3D PAGE_SIZE << pool->p.order;
> >> +       struct page *page;
> >> +
> >> +       *size =3D ALIGN(*size, dma_get_cache_alignment());
> >> +
> >> +       if (WARN_ON(*size > max_size))
> >> +               return NULL;
> >> +
> >> +       if ((*size << 1) > max_size || PAGE_POOL_DMA_USE_PP_FRAG_COUNT=
) {
> >> +               *size =3D max_size;
> >> +               *offset =3D 0;
> >> +               return page_pool_alloc_pages(pool, gfp);
> >> +       }
> >> +
> >> +       page =3D __page_pool_alloc_frag(pool, offset, *size, gfp);
> >> +       if (unlikely(!page))
> >> +               return NULL;
> >> +
> >> +       /* There is very likely not enough space for another frag, so =
append the
> >> +        * remaining size to the current frag to avoid truesize undere=
stimate
> >> +        * problem.
> >> +        */
> >> +       if (pool->frag_offset + *size > max_size) {
> >> +               *size =3D max_size - *offset;
> >> +               pool->frag_offset =3D max_size;
> >> +       }
> >> +
> >
> > Rather than preventing a truesize underestimation this will cause one.
> > You are adding memory to the size of the page reserved and not
> > accounting for it anywhere as this isn't reported up to the network
> > stack. I would suggest dropping this from your patch.
>
> I was thinking about the driver author reporting it up to the network
> stack using the new API as something like below:
>
> int truesize =3D size;
> struct page *page;
> int offset;
>
> page =3D page_pool_dev_alloc(pool, &offset, &truesize);
> if (unlikely(!page))
>         goto err;
>
> skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
>                 offset, size, truesize);
>
> and similiar handling for *_build_skb() case too.
>
> Does it make senses for that? or did I miss something obvious here?

It is more the fact that you are creating a solution in search of a
problem. As I said before most of the drivers will deal with these
sorts of issues by just doing the fragmentation themselves or
allocating fixed size frags and knowing how it will be divided into
the page.

If you are going to go down this path then you should have a consumer
for the API and fully implement it instead of taking half measures and
making truesize underreporting worse by evicting pages earlier.

