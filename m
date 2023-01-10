Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D948F663C9E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbjAJJT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238296AbjAJJSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:18:35 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEAF544E6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:18:13 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bt23so17338667lfb.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qEoCk3QhrauPKQfPnLgsMlCCuaqye7yB7TAPrEhAW0Q=;
        b=SmLfVSZk27DK4OQLCkIGDJqmasEdY2jqL9Do4eojF94chWAOOID7gMTXazEgsOJltf
         sOytjJxEhG1XvZ/RePiudBCh4y7BTkGTrLcKVQBd3YS/tZ4+0lArj6yqR/5En3QV87DK
         APg5uqVR3URBqLt6XDOrJ9/cSeQc32UuPFI10onG+7NXMathsunAUc1pR7mCxffYZarj
         YiU4sw44fCTalcFPqvK2NFDao//m/RJCPauh1XkamMycJ6TvS7odjVLAdpqFpMtYC/Kx
         s9NInffydzYv12Picrqt5rAqdW7waGjgp1pk9qMUCw5h/dcy6npW9MeC7+ZwFQGOQxP7
         ehFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEoCk3QhrauPKQfPnLgsMlCCuaqye7yB7TAPrEhAW0Q=;
        b=GS0GxjZz7wrwQ2v2tJfYzILLLPgmxAAqmmwrhGqkKdNQIS2VQyqXcyE9FbUCg3PAbl
         gPOFRoGeO50u1gq61cui6FNx3vxuHHnriSTU4UdaGf2f2RffS4C97nZcU0AjEnBt014Y
         AGg55GmL8RPZ/qz2fevmDLG145/9IxK32j35Pvq4ouqqa+t/L7HaR4BZ7mOLeMUD99L7
         MduRxaStExQiceeYaSUI7dQBwJjqE9TXhLoVDKrf0AzDbfLXs/yInW0MSQziCvcsxYmv
         K0x5JnPoe/ptcGjWwU1rgClSnQ9gagnmhUARxDT5Cb1qcDf6RqlIeu2c83WkwsUJv662
         UNrA==
X-Gm-Message-State: AFqh2kqtAyEciN2YfEEw+olvhc7DhpKOTCN4WmAxABFypuC+hTG43c1I
        eo49LOWvmh06Wi6XLmnI9pNHePyplhifxFOWXKKwrw==
X-Google-Smtp-Source: AMrXdXtaPvkJOi7sGoCcfoQkbvLcLycNiUEJvGdIOGo2gFatG+L6ZV/ESPVZGyaIhf7zfsIp2Wr1lO/uPZWeKWDGeGw=
X-Received: by 2002:a19:6551:0:b0:4b6:eb4d:4b7f with SMTP id
 c17-20020a196551000000b004b6eb4d4b7fmr5759167lfj.530.1673342291818; Tue, 10
 Jan 2023 01:18:11 -0800 (PST)
MIME-Version: 1.0
References: <20230105214631.3939268-1-willy@infradead.org> <20230105214631.3939268-4-willy@infradead.org>
 <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
In-Reply-To: <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 10 Jan 2023 11:17:35 +0200
Message-ID: <CAC_iWjK38RHjaPfkBea68MOQHF2R_gUSsLjoHXniyW-ZRMHWMA@mail.gmail.com>
Subject: Re: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Jan 2023 at 19:30, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Matthew
>
> On Thu, 5 Jan 2023 at 23:46, Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
> >
> > Turn page_pool_set_dma_addr() and page_pool_get_dma_addr() into
> > wrappers.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  include/net/page_pool.h | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 84b4ea8af015..196b585763d9 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -449,21 +449,31 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> >  #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
> >                 (sizeof(dma_addr_t) > sizeof(unsigned long))
> >
> > -static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> > +static inline dma_addr_t netmem_get_dma_addr(struct netmem *nmem)
>
> Ideally, we'd like to avoid having people call these directly and use
> the page_pool_(get|set)_dma_addr wrappers.  Can we add a comment in
> v3?

Ignore this, I just saw the changes in mlx5.  This is fine as is

>
> >  {
> > -       dma_addr_t ret = page->dma_addr;
> > +       dma_addr_t ret = nmem->dma_addr;
> >
> >         if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > -               ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> > +               ret |= (dma_addr_t)nmem->dma_addr_upper << 16 << 16;
> >
> >         return ret;
> >  }
> >
> > -static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> > +static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> > +{
> > +       return netmem_get_dma_addr(page_netmem(page));
> > +}
> > +
> > +static inline void netmem_set_dma_addr(struct netmem *nmem, dma_addr_t addr)
> >  {
> > -       page->dma_addr = addr;
> > +       nmem->dma_addr = addr;
> >         if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > -               page->dma_addr_upper = upper_32_bits(addr);
> > +               nmem->dma_addr_upper = upper_32_bits(addr);
> > +}
> > +
> > +static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> > +{
> > +       netmem_set_dma_addr(page_netmem(page), addr);
> >  }
> >
> >  static inline bool is_page_pool_compiled_in(void)
> > --
> > 2.35.1
> >
>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
