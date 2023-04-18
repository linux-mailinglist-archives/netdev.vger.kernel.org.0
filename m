Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94EF6E5D70
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDRJda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjDRJd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:33:29 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C77AD
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:33:24 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a10so12876686ljr.5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681810403; x=1684402403;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UkJRiG6xBagkkbHONkrh8XGPSkiHk+zGZ5JXRxSS1c0=;
        b=pvSGk9F7AD9cr6KUMyfjGrgG3aBsNzakie8ULZZMIiBlvQ1TT9WLwzFRMXVV/d0XMZ
         i5HW1U4mjIXIed0FtMu7A683wMNvwEV54rUPaTSH61c/d0EmN13PxHO13f8oCe3M5xv/
         w0F7EerJNHJ6xjzM3vXBe8djBuyEdZ1Qpk0zEndpVwrZbsxD2U6PL15QfUHRIbJPNyD7
         1WBfonFSrSYm/47d7DUmDl1MTWt34wkE50evktcDmwStRJHSe7JJmSzjVS4SvysiRx6Z
         w78/8SOyXuQVDOl1fFAKWlgXe533TrJWUz7EY5RGZBJLOKe03865LxGL0QOKg7x3MWuF
         M8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681810403; x=1684402403;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkJRiG6xBagkkbHONkrh8XGPSkiHk+zGZ5JXRxSS1c0=;
        b=C1MnkjefWwC3esSAKwiPjWpFDwAmbNkiQ5EVA1JHU2ibyFqXWEjB0R0eNWta3ogzop
         29WKGZA/r8wYQ2i0zol3ZnEvm04FzBkf9vMGn6or+eo+sHUuvjlV34xHFxBmYSeSYHBF
         NMMuZtxcPLcl6Mwov8GAIHUECbaCMSLh7DX6/FGsLJJm4l15w3zdZDWPdRWyYKMFCSfc
         /YAvO0kPBmi9S9oRhthmcH3clLGXClUtmRbON0eZB/kx6Rqft75VAx7eWDTrwhAUs9xn
         /mYp1kuMWGjCywGYG2Kx8+0kO8MKQSUw/8QWHcCnYfCdnmEdhxY3CWbUjlE3Lv/jysxH
         0B7Q==
X-Gm-Message-State: AAQBX9eCAqPQvzJkCMZdFT3Sp7ivKEazaMmTtRaTpalND/7aK6q6mEeZ
        Ap/P4FV7zAuJ+QH8S1gldIH5BUklIl1MUdBuKKacTQ==
X-Google-Smtp-Source: AKy350aZchPtYSzQUuwcCsZ5uHAbJunAC83LRC6+2j6gb03cKt7XDH9OkxmYKraH3ej3FmPeu1vTI4llrVQvf7HSycY=
X-Received: by 2002:a2e:8753:0:b0:2a7:7470:4ebc with SMTP id
 q19-20020a2e8753000000b002a774704ebcmr590028ljj.2.1681810403169; Tue, 18 Apr
 2023 02:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230417152805.331865-1-kuba@kernel.org>
In-Reply-To: <20230417152805.331865-1-kuba@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 18 Apr 2023 12:32:47 +0300
Message-ID: <CAC_iWjLXL_FbCsCvuhqhz_i8j_yOgAs3gn2DAVktV0aZqT3QYg@mail.gmail.com>
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all mappings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This seems sane to me, especially since we use page pool on the Rx
path for normal drivers.  If anyone has a different opinion please
shout\

On Mon, 17 Apr 2023 at 18:28, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
> to a few more drivers (possibly as a copy'n'paste).
>
> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
> the rarity of these platforms is likely why we never bothered adding
> the attribute in the page pool, even though it should be safe to add.
>
> To make the page pool migration in drivers which set this flag less
> of a risk (of regressing the precious sparc database workloads or
> whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
> page pool DMA mappings.
>
> We could make this a driver opt-in but frankly I don't think it's
> worth complicating the API. I can't think of a reason why device
> accesses to packet memory would have to be ordered.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> ---
>  net/core/page_pool.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 2f6bf422ed30..97f20f7ff4fc 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>          */
>         dma = dma_map_page_attrs(pool->p.dev, page, 0,
>                                  (PAGE_SIZE << pool->p.order),
> -                                pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +                                pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC |
> +                                                 DMA_ATTR_WEAK_ORDERING);
>         if (dma_mapping_error(pool->p.dev, dma))
>                 return false;
>
> @@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>         /* When page is unmapped, it cannot be returned to our pool */
>         dma_unmap_page_attrs(pool->p.dev, dma,
>                              PAGE_SIZE << pool->p.order, pool->p.dma_dir,
> -                            DMA_ATTR_SKIP_CPU_SYNC);
> +                            DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
>         page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
>         page_pool_clear_pp_info(page);
> --
> 2.39.2
>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
