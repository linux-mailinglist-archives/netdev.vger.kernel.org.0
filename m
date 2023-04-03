Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E586D4BF4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjDCPbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjDCPbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:31:34 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFAD10E7
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:31:33 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a11so30772011lji.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680535891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4QXatD0Ej06QWYKscKaNPxPrTBfxQw31B0elDwoBg/s=;
        b=G/70bMXBr5pYOf3IF5Rh0VpnETGMVNSYpJQ1CQd+gF+xwmIS1nIhOPMRCFc13HOO22
         zuX00nmJ5Ew24qMsgcNgg3BTvrHMEXq5NvQso7xICpVNowaQ3eFmVma3cDU5zNCatO4t
         OAt/N0WGsbVYidStswMM92GRIxWxW+6Ze0L7eDKcRK3kvJ4xhONDWZKXo6OlrFWFopCb
         u90GemRYmfl0JED+G5xkDtuQ+B5tBqfWVTEbcg4ippObuZWOe2ITgeNeLyoDSgvJnYYF
         6xNrKAXO0QPpfOWB73Pkpo1HbKMQxb6wm412cONoJMjx7wz32tWFpmknrFszd1P+i58J
         ZXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680535891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4QXatD0Ej06QWYKscKaNPxPrTBfxQw31B0elDwoBg/s=;
        b=oXgFdUr7DlGEJW1aLYD8XwQNFzIKirESRX8eaMoC1K1gJSNZJVJC2O9agfMOLBxrOL
         EL6IDK3Mpd0F0LV5DB3iVoSTE6XO0UkTckq5gBiuff0GO/AL19oj2RMetLPMzz+rRNe2
         ISiB+SS0UEXj5vxGwSEnzR+jYiAtrpsKAKFDPrj9uvGg1sn7dbsRxK3eroA8gpCf/dPo
         u2iJThpXhysvxDzQJ5wtI7Rjh/21hVHNS85EEUeybBnOy9QlzgtkQldlUS7YAo6mFJb2
         ykgYsWqNjqfpwn+3Oc1trNBi2M0ymWsSZGzuqh/0yS/Eo3CZayG2DMix5VnUovpzwyEi
         3vHg==
X-Gm-Message-State: AAQBX9dVhwV1W36mf1lVCxmms0p4BIO/yOR7pi6VovflBRsCZaxmRLy8
        glvstzGu/wwE9xHBjKLSFSg6bdieS6a3DU5bw56W/B1eKJJRrkh9m8c=
X-Google-Smtp-Source: AKy350bO+eFVIjc/n8y7pZQQyKRY2xMpQc8k6txeL6ocNupCDlL9w38SCuAKUvy+gY6yDdfeCzDQRM2Bmr+leI1zVFc=
X-Received: by 2002:a2e:9ad0:0:b0:2a6:32bf:6745 with SMTP id
 p16-20020a2e9ad0000000b002a632bf6745mr1668378ljj.2.1680535891614; Mon, 03 Apr
 2023 08:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230331043906.3015706-1-kuba@kernel.org> <ZCqZVNvhjLqBh2cv@hera> <20230403080545.390f51ce@kernel.org>
In-Reply-To: <20230403080545.390f51ce@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 3 Apr 2023 18:30:55 +0300
Message-ID: <CAC_iWjJiTddh7cKo-18LGGE+XQS_H8B5ieXLW6+uSq6uBNPnDw@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized NAPI
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 at 18:05, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 3 Apr 2023 12:16:04 +0300 Ilias Apalodimas wrote:
> > >  /* If the page refcnt == 1, this will try to recycle the page.
> > >   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
> > >   * the configured size min(dma_sync_size, pool->max_len).
> > > @@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> > >                     page_pool_dma_sync_for_device(pool, page,
> > >                                                   dma_sync_size);
> > >
> > > +           if (!allow_direct)
> > > +                   allow_direct = page_pool_safe_producer(pool);
> > > +
> >
> > Do we want to hide the decision in __page_pool_put_page().  IOW wouldn't it
> > be better for this function to honor whatever allow_direct dictates and
> > have the allow_direct = page_pool_safe_producer(pool); in callers?
>
> Meaning in page_pool_return_skb_page() or all the way from
> napi_consume_skb()? The former does indeed sounds like a good idea!

page_pool_return_skb_page() (and maybe page_pool_put_full_page()).
FWIW we completely agree on napi_consume_skb().  We are trying to keep
page_pool and the net layer as disjoint as possible.  The only point
we 'pollute' networking code is the recycle bit checking and we'd
prefer keeping it like that

Regards
/Ilias
