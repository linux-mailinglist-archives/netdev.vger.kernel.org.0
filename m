Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA56D3F5AA3
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbhHXJNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235600AbhHXJNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:13:40 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B616C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:12:56 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r4so39635398ybp.4
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 02:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=huAU7IQdORym8oK+zccFwhOKQZXlhfkQ9a2q6rve3Bk=;
        b=lieYGEYLvqSYqlw/lpkJ7o7uAWJtlF9YY/IknLJFfeNVZYqqsRnDZo93eJhqhJZ1Gw
         EbxW6pUpyOSwh3MarKbZQ+U9lQVsNtNXJpnKRKihuHSWeyW9s0He8dkyn1cjEXUi7hxS
         XfnccJrudCVBpV5YCTDPhYXsR8F+NFZAzQeMHZpA+BbiSUub8wKmERNKGYOAAgotn+sM
         H6mqeyV2zdTXt9ji5OA31UTfOChSGw+ziYK7lBtDV7OQzH3rGdR2Ks5ape6QAsOYYahE
         9lV8pem2PCNqr7K5HmD5hnH9JuAsaLUlz8LjvGzIB/6C/o4PbUKql8aGZaR8z9/9W6aQ
         ngoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=huAU7IQdORym8oK+zccFwhOKQZXlhfkQ9a2q6rve3Bk=;
        b=iP5iE3CWc7vNBAkdqruHd2IKPV8D7w3rmzItFm/SyVHBF97YukEScuAIkmUsdZof5l
         C7gfgnialIkfxESkHWGhx0Qkm28BBBXJaN2JTKPEeqNci0fk+3zT86fnxjWhAW7pOONK
         Pt5Ti/uZeOkKyPMKI2l5awL+Wa8SWQbWATgD8N/OSFftkn94x31rytiZAtsrYHpo2SMF
         jqS+QeGCAfwgLLIzv4EiYt6JstdjfcbRluXosyuuACLeMaxTyIs2glwnbcF5py0j5ywf
         S0UeIgGjNiB1i2XdyuUMuXuODGfUozYlrUJ89uKL2JcnIldnoewHEnUpEl5WstzEJi8Q
         mqOg==
X-Gm-Message-State: AOAM531mgadpqU14vDkhwO6tt1Uf5Ch9YWVhlbpvH87xInSqSsI0MKxq
        F1XBENQz6EEW7b1t+gzKIIr+iUh4eKTU7dLXjwWIMQ==
X-Google-Smtp-Source: ABdhPJwTbFhQPoBh96+9Kgb/aYiLo+tmbq+pa5PiL7XNFW9PZQToPdxaKub14wTDcraj8wSNE2oTCV+Uo8tNaQgMf48=
X-Received: by 2002:a25:1f46:: with SMTP id f67mr49945031ybf.421.1629796375758;
 Tue, 24 Aug 2021 02:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 24 Aug 2021 12:12:17 +0300
Message-ID: <CAC_iWj+UefbRUdd9m_Mb6G=KvEV0TpTH9SAN1PSYAvQObL6ZRA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] page_pool: use relaxed atomic for release
 side accounting
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 at 12:07, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> There is no need to synchronize the account updating, so
> use the relaxed atomic to avoid some memory barrier in the
> data path.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3: Drop patch 2.
> V2: Remove unnecessary unliky() mark as pointed out by
>     Heiner.
> ---
>  net/core/page_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e140905..1a69784 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -370,7 +370,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>         /* This may be the last page returned, releasing the pool, so
>          * it is not safe to reference pool afterwards.
>          */
> -       count = atomic_inc_return(&pool->pages_state_release_cnt);
> +       count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
>         trace_page_pool_state_release(pool, page, count);
>  }
>  EXPORT_SYMBOL(page_pool_release_page);
> --
> 2.7.4
>
