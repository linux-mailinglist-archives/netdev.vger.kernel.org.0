Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD17F55DC9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFZBg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:36:58 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43123 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfFZBg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:36:56 -0400
Received: by mail-yb1-f194.google.com with SMTP id 5so370591ybj.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 18:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTYwKuXPT5ALk6Fdrn6IzuSHliH6LA0lPjX35sqNWXk=;
        b=LEllaoY4m3xHWsTf7N+j4EKZmEHnZurpJaQ4DfOFpDq5VCrh/Gz2Ay+qnaw+/VsjPx
         NdSVVQpJr40BZE6Igeny8QytRZGs2Q/pWaDuYl3MfRlk2BCtw4EoH94czkdBkZEkG2U2
         pEpjPktRmpofIUWGYnET5+J9dWWu1Nr5Z5HkvrveWaTFPl4wzPfG8fKjVuQDtov0ywD4
         yJc4bdyE/f1Z5EZXXaOuPkm/TbXG//FaJ9D1n/wYXeX9UeS6Nl8vpsriv+kRzCGIiI80
         v6GAgaz0IchTKo6kTwjApTZ4Ga/8zRr/MuhlYpouM1wn78rpueWlK4a5wddrIlqHdaUd
         cyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTYwKuXPT5ALk6Fdrn6IzuSHliH6LA0lPjX35sqNWXk=;
        b=bIqF7DKDcMRQmYC0u/qqeIrEATFYFQU/g2o2Y/oeUOXXxLupO+xkfDF5+ZO71rsBSt
         oXBOgDYATpITmw/v7u3FwkYkWnGisJjlZX4g9yim2yPrJwesUXGSDPJSbr172orA344l
         bcQ2zSVHjSR6Ts5xk9hyhHq8qPMTB6jfaXEeCW/rzgxaAljDEk76AooGPqzP66x+5B28
         cdumgBHzDEyoNqcWm9dQEf4VkezyR7hbQFp0irz0M9BvaOA/4hyyYOfeb3ZVr115q1p+
         /BGFminSQlM753eC0c0v/K9VKY6oolrOuLYdJXZXUZgn3b8qVJKsobS3j0arP2eo3LLx
         5ulA==
X-Gm-Message-State: APjAAAVTNhBn96djrtUcQViRf9Zq6+/c3mTZPbSyn2euX0J6aPPnRr4K
        iA/2WFymWH9AHrul9IlOJd67goDB
X-Google-Smtp-Source: APXvYqwPIXbfl9c6ilJXZ7bKfPEIfqEnq2u/iR4ITvDGhpiD46M/qh69iWgzBx664YD3WzLqmTCALg==
X-Received: by 2002:a25:550b:: with SMTP id j11mr940441ybb.223.1561513014109;
        Tue, 25 Jun 2019 18:36:54 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id 15sm4000069ywo.74.2019.06.25.18.36.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 18:36:53 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id n3so405354ybn.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 18:36:52 -0700 (PDT)
X-Received: by 2002:a25:21c2:: with SMTP id h185mr1028553ybh.125.1561513012633;
 Tue, 25 Jun 2019 18:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org> <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 21:36:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTSff=+zqxxmCv3+bNxraigNgx_1Wm5Kn2FM7TTSZV4dnOg@mail.gmail.com>
Message-ID: <CA+FuTSff=+zqxxmCv3+bNxraigNgx_1Wm5Kn2FM7TTSZV4dnOg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     David Miller <davem@davemloft.net>, grygorii.strashko@ti.com,
        hawk@kernel.org, brouer@redhat.com, saeedm@mellanox.com,
        leon@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        jakub.kicinski@netronome.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 2:00 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Add user counter allowing to delete pool only when no users.
> It doesn't prevent pool from flush, only prevents freeing the
> pool instance. Helps when no need to delete the pool and now
> it's user responsibility to free it by calling page_pool_free()
> while destroying procedure. It also makes to use page_pool_free()
> explicitly, not fully hidden in xdp unreg, which looks more
> correct after page pool "create" routine.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index f07c518ef8a5..1ec838e9927e 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -101,6 +101,7 @@ struct page_pool {
>         struct ptr_ring ring;
>
>         atomic_t pages_state_release_cnt;
> +       atomic_t user_cnt;

refcount_t?

>  };
>
>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> @@ -183,6 +184,12 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>         return page->dma_addr;
>  }
>
> +/* used to prevent pool from deallocation */
> +static inline void page_pool_get(struct page_pool *pool)
> +{
> +       atomic_inc(&pool->user_cnt);
> +}
> +
>  static inline bool is_page_pool_compiled_in(void)
>  {
>  #ifdef CONFIG_PAGE_POOL
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index b366f59885c1..169b0e3c870e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -48,6 +48,7 @@ static int page_pool_init(struct page_pool *pool,
>                 return -ENOMEM;
>
>         atomic_set(&pool->pages_state_release_cnt, 0);
> +       atomic_set(&pool->user_cnt, 0);
>
>         if (pool->p.flags & PP_FLAG_DMA_MAP)
>                 get_device(pool->p.dev);
> @@ -70,6 +71,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>                 kfree(pool);
>                 return ERR_PTR(err);
>         }
> +
> +       page_pool_get(pool);
>         return pool;
>  }
>  EXPORT_SYMBOL(page_pool_create);
> @@ -356,6 +359,10 @@ static void __warn_in_flight(struct page_pool *pool)
>
>  void __page_pool_free(struct page_pool *pool)
>  {
> +       /* free only if no users */
> +       if (!atomic_dec_and_test(&pool->user_cnt))
> +               return;
> +
>         WARN(pool->alloc.count, "API usage violation");
>         WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 829377cc83db..04bdcd784d2e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -372,6 +372,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>
>         mutex_unlock(&mem_id_lock);
>
> +       if (type == MEM_TYPE_PAGE_POOL)
> +               page_pool_get(xdp_alloc->page_pool);
> +

need an analogous page_pool_put in xdp_rxq_info_unreg_mem_model? mlx5
does not use that inverse function, but intel drivers do.

>         trace_mem_connect(xdp_alloc, xdp_rxq);
>         return 0;
>  err:
> --
> 2.17.1
>
