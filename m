Return-Path: <netdev+bounces-6839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 161DA7185FF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83A53281436
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B308C171B9;
	Wed, 31 May 2023 15:21:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A171616438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:21:12 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6591107;
	Wed, 31 May 2023 08:21:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d5b4c3ffeso4107997b3a.2;
        Wed, 31 May 2023 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685546467; x=1688138467;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IqLBTLdww5a5qlwx/ErHlmc0YW7ggTL+TwrPcGnVcX4=;
        b=bT1zvjsVW/ZrkiSShMdEqUra1jUkOaVgwIt/1jznhYZvXV6zCPFVA+l15MDE/OM0ZC
         QxlZ7IqcX+fbVhGL5MstdnbRIUyjoIM7ngh2tgimMtkkZcCzskyYdPxn8x2ye/n7P5pV
         j1NqLMYMliA95JkPluppdZ91Q19ncH7FWXLwLpG07jjn5BLRQFiMj5yhupdTZW+zE/2u
         3VKnEgkRQ30dkn8OxTBDhdX67TzbQrPJpL3wgQE+7SWM30Ck9HrZj8OeCZwHJFzVZjcI
         dA8ZtK3UEuGDAdo/JGD0tE0HnGC1SE2FkQUljcvAfzQwYhTKoQWTqamAY09SsK5PheSM
         anlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685546467; x=1688138467;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IqLBTLdww5a5qlwx/ErHlmc0YW7ggTL+TwrPcGnVcX4=;
        b=J9swOYcpxtKly318RKxJhRFvj4qHrO/v7vmJDY/M8DLS1lbBykKLXSYGvUlQaCflJO
         B8Empso52gc3dM01FUJh0VuXjivtWM+cX0EFH0X1sYoVSVHynxepP6lYwFXjFwC8hxWS
         A67jgBRjcRBEI7RAm4hEIYyI4PyKW/xIZbnGlqfJQvo3GRr/VmcXGt0hXTPBeFruKgjr
         oWxXFfAgRwQGGpcZa8MV1wk77GhcWs/T2Y/vUmvBkIK0BJkbWanjd49gzzlHVbW+/oov
         TdMKiZAwGOdiui3jC83ZcxlM2Ly76fycA6Q+t+sOZwp4SanQgBmn16AhFFbL7BGlCeiJ
         u32A==
X-Gm-Message-State: AC+VfDypECqjpvZ0cBprJgT+FsA697bs/ZoBpNy2AxVjtTe3AcRFxWaf
	Qhzw/htOEWnmgTiBXsavLCM=
X-Google-Smtp-Source: ACHHUZ7qWb5EJ1Vta3RUHbsEc0FnXIcF/1yY6AZHnCnRRKEUMs+5U3MNoBrgWvAyebdKfa9LW1rKcA==
X-Received: by 2002:a05:6a20:3d89:b0:101:6a2f:2a0e with SMTP id s9-20020a056a203d8900b001016a2f2a0emr5629189pzi.18.1685546467120;
        Wed, 31 May 2023 08:21:07 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id k184-20020a6324c1000000b0052cbd854927sm1415909pgk.18.2023.05.31.08.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 08:21:05 -0700 (PDT)
Message-ID: <81d8da838601a2029e97937a952652039285cb4e.camel@gmail.com>
Subject: Re: [PATCH net-next v3 06/12] net: skbuff: don't include
 <net/page_pool.h> into <linux/skbuff.h>
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
 netdev@vger.kernel.org,  intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Date: Wed, 31 May 2023 08:21:03 -0700
In-Reply-To: <20230530150035.1943669-7-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
	 <20230530150035.1943669-7-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 17:00 +0200, Alexander Lobakin wrote:
> Currently, touching <net/page_pool.h> triggers a rebuild of more than
> a half of the kernel. That's because it's included in <linux/skbuff.h>.
>=20
> In 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling"),
> Matteo included it to be able to call a couple functions defined there.
> Then, in 57f05bc2ab24 ("page_pool: keep pp info as long as page pool
> owns the page") one of the calls was removed, so only one left.
> It's call to page_pool_return_skb_page() in napi_frag_unref(). The
> function is external and doesn't have any dependencies. Having include
> of very niche page_pool.h only for that looks like an overkill.
> Instead, move the declaration of that function to skbuff.h itself, with
> a small comment that it's a special guest and should not be touched.
> Now, after a few include fixes in the drivers, touching page_pool.h
> only triggers rebuilding of the drivers using it and a couple core
> networking files.
>=20
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c               | 1 +
>  drivers/net/ethernet/freescale/fec_main.c                | 1 +
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/params.c      | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c         | 1 +
>  drivers/net/wireless/mediatek/mt76/mt76.h                | 1 +
>  include/linux/skbuff.h                                   | 4 +++-
>  include/net/page_pool.h                                  | 2 --
>  9 files changed, 10 insertions(+), 3 deletions(-)
>=20
>=20

<...>

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5951904413ab..6d5eee932b95 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -32,7 +32,6 @@
>  #include <linux/if_packet.h>
>  #include <linux/llist.h>
>  #include <net/flow.h>
> -#include <net/page_pool.h>
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #endif
> @@ -3422,6 +3421,9 @@ static inline void skb_frag_ref(struct sk_buff *skb=
, int f)
>  	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
>  }
> =20
> +/* Internal from net/core/page_pool.c, do not use in drivers directly */
> +bool page_pool_return_skb_page(struct page *page, bool napi_safe);
> +
>  static inline void
>  napi_frag_unref(skb_frag_t *frag, bool recycle, bool napi_safe)
>  {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 126f9e294389..2a9ce2aa6eb2 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -240,8 +240,6 @@ inline enum dma_data_direction page_pool_get_dma_dir(=
struct page_pool *pool)
>  	return pool->p.dma_dir;
>  }
> =20
> -bool page_pool_return_skb_page(struct page *page, bool napi_safe);
> -
>  struct page_pool *page_pool_create(const struct page_pool_params *params=
);
> =20
>  struct xdp_mem_info;

So the code as-is works, so I am providing my "Reviewed-by".
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Consider the rest of this a suggestion or a "nice to have".

I wonder if we shouldn't also look at restructuring the function and
just moving it to net/core/skbuff.c somewhere next to skb_pp_recycle.

I suspect we could look at pulling parts of it out as well. The
pp_magic check should always be succeeding unless we have pages getting
routed the wrong way somewhere. So maybe we should look at pulling it
out and moving it to another part of the path such as
__page_pool_put_page() and making it a bit more visible to catch those
cases.

