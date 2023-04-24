Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A876ED512
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjDXTHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjDXTG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:06:59 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DA765B7;
        Mon, 24 Apr 2023 12:06:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63d4595d60fso30394995b3a.0;
        Mon, 24 Apr 2023 12:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682363217; x=1684955217;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=On6z1v0CEBu8SazDTKI/6J91w7vyc/N6ULGaQZAAQjc=;
        b=JMxXSkv7ACbPn835/viIqiIHMjJIJ4JqragmlmvsotIpoZXx9mr0ESLgBoOb5w+L6t
         5bVmW8w93UPifMjn8EUVe7j+Hps1j99dOtdB1Bzvqyt1N+a06u+Qv/vVg+XIrfjJCLvy
         Ufdndow3alHG/r0seZ+NaHUvJ3/+7PoTWbrUzObBCSAIpCguRc3DQV6/vck9H6LwNoaB
         sLbbVdyMZpatVdmt7ZM3FI7ousKKg62faySf8c6GjKNsatm1XtEduNnv0hdJ0pnDzk6W
         NJWOIFsh3cRod3yziPgGRPo1OGYaQBNZ6QJHNUUU5NLHGKZ5HVqalI0JNFM/S8s+gMBK
         tWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682363217; x=1684955217;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=On6z1v0CEBu8SazDTKI/6J91w7vyc/N6ULGaQZAAQjc=;
        b=YMd+ZufT+hGnLVOE5ntPPcKEE8elwSu8rCe7deT1DCxg4P5TI2VC7GNSPfK/FBRNcJ
         s+GP8/SFHYwrDDS1WqBtvOH2AFW54PuLkFk65ED72MaUbRnUnKclavuWLUcQrcCS5LUz
         EckqOdG/T27HotKgbNbkoxDD/7Z3HQCng5/ncVAJRIf5qgvbQEZzVsfGqit6BG0jU7WW
         AMV2cB8y7OfNsJQF3NykaU1t5LIxay7MnblTk9DoVh6zIO3n6DTwgtSyqYmtnOWu4P3b
         Uh9gVaEguZey4Mel+t1bmf0QSujSfpjQordcrzXg0ORGnLqlZmJyZ1GnZUzFF/UdXdgB
         bc7g==
X-Gm-Message-State: AC+VfDxhjYDy+73P/+s46bjkebc2yKiJb0gUKVOHw+V11YrpdIlhSXzN
        rsuJxZIJPpn5HW/HntJVnFI=
X-Google-Smtp-Source: ACHHUZ7+JEip9cUyrp7dZtXCcPb0zekDHEcbcVVwNv6m5XH0MNdt1lZyx9p/lLPGplSjEYOsXsteRQ==
X-Received: by 2002:a17:903:260e:b0:1a9:80a0:47ef with SMTP id jd14-20020a170903260e00b001a980a047efmr2272655plb.20.1682363217289;
        Mon, 24 Apr 2023 12:06:57 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:d8b6:344e:b81a:e8b5])
        by smtp.gmail.com with ESMTPSA id w24-20020a170902a71800b001a64dbfc5d7sm6859587plq.145.2023.04.24.12.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 12:06:56 -0700 (PDT)
Date:   Mon, 24 Apr 2023 12:06:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Kal Conley <kal.conley@dectris.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <6446d34f9568_338f220872@john.notmuch>
In-Reply-To: <20230423075335.92597-1-kal.conley@dectris.com>
References: <20230423075335.92597-1-kal.conley@dectris.com>
Subject: RE: [PATCH] xsk: Use pool->dma_pages to check for DMA
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Conley wrote:
> Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> active DMA mapping. pool->dma_pages needs to be read anyway to access
> the map so this compiles to more efficient code.

Was it noticable in some sort of performance test?

> 
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  include/net/xsk_buff_pool.h | 2 +-
>  net/xdp/xsk_buff_pool.c     | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index d318c769b445..a8d7b8a3688a 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>  	if (likely(!cross_pg))
>  		return false;
>  
> -	return pool->dma_pages_cnt &&
> +	return pool->dma_pages &&
>  	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
>  }
>  
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..26f6d304451e 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -350,7 +350,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  {
>  	struct xsk_dma_map *dma_map;
>  
> -	if (pool->dma_pages_cnt == 0)
> +	if (!pool->dma_pages)
>  		return;

This seems to be used in the setup/tear-down paths so your optimizing
a control side. Is there a fast path with this code? I walked the
ice driver. If its just setup code we should do whatever is more
readable.

>  
>  	dma_map = xp_find_dma_map(pool);
> @@ -364,6 +364,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  
>  	__xp_dma_unmap(dma_map, attrs);
>  	kvfree(pool->dma_pages);
> +	pool->dma_pages = NULL;
>  	pool->dma_pages_cnt = 0;
>  	pool->dev = NULL;
>  }
> @@ -503,7 +504,7 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
>  	if (pool->unaligned) {
>  		xskb = pool->free_heads[--pool->free_heads_cnt];
>  		xp_init_xskb_addr(xskb, pool, addr);
> -		if (pool->dma_pages_cnt)
> +		if (pool->dma_pages)
>  			xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
>  	} else {
>  		xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
> @@ -569,7 +570,7 @@ static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xd
>  		if (pool->unaligned) {
>  			xskb = pool->free_heads[--pool->free_heads_cnt];
>  			xp_init_xskb_addr(xskb, pool, addr);
> -			if (pool->dma_pages_cnt)
> +			if (pool->dma_pages)
>  				xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);

Both the _alloc_ cases read neighboring free_heads_cnt so your saving a load I guess?
This is so deep into micro-optimizing I'm curious if you could measure it?

>  		} else {
>  			xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];

I'm not actually against optimizing but maybe another idea. Why do we have to
check at all? Seems if the DMA has been disabled/unmapped the driver shouldn't
be trying to call xsk_buff_alloc_batch? Then you can just drop the 'if' check.

It feels to me the drivers shouldn't even be calling this after unmapping
the dma. WDYT?
