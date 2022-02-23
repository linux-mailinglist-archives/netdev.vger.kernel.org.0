Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7884C1B4E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbiBWTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiBWTC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 14:02:26 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ACE1CFFB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 11:01:58 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d6923bca1aso213759507b3.9
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 11:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T66elGWm5E1Jie1XvbzIi256mtS4uPCl8SGMEKJIIPg=;
        b=W68jDQLebLz4vx5WtQHihE4C9AVTdNfT7vUTI0/uySsALh0U0wPP8Tu/itJilScRn5
         FxLIQpcB0VLHAz4hrwNR4wKsVKE1WvGpYGPFcNm8kmcWFQFxDnLmfCxnCio1slx9vJA5
         +w0bvKtEi9F6p/zR7u3FmHlpW8KQAhAQGz8oAf+JgA9oAPnvOdTRg2DmvErWk3LKWdMj
         m3Z8O01rYTJ1KCH02LDedNNwyCL+x0xX6MxCziYiEMgK15L8sQwYwoNopLC5CmXpFRhn
         fJFh1TDZ6lpRKVmfMAVqzlZs5982sG2KyUhfp6Boxd6AMZJMf5/skQcs5929VvbgloYS
         qPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T66elGWm5E1Jie1XvbzIi256mtS4uPCl8SGMEKJIIPg=;
        b=w0QiNYsBEOs8CMCLX26ugLzTlbE1KZL52SY7EtMrHSx3R9xuhg99Ggw7fC7oZlOGxr
         LC6mh93BP+iRZwBtt3N7DuGKLnJ7UU5w0Twck6278qiVnyGi8YMcNIYmhlqSAL9FIJRe
         D3crcdyefb6yySNhZ2sIzDFv+quEuBnIH8dfuoph6qAiv9RHanAngNn1puObG8SqbKDj
         Sh2ZErarrSWrFCW46G7j5uA1bqDoHlg7bZBx04XO+xOwFq8H+Mw74ByMd/2tIPlFdnGi
         dgYyxO++GE5I5mHiVPe299wr1igj5QKv/ETNP/gCSOes8cK/wsiF7nRM+4g/0iPBWaJl
         u42w==
X-Gm-Message-State: AOAM532GV+aX0qY2VrqxbyYhaeV97IhgIgVhYAT0xWAKg/uTKSVWUiru
        cZnXeX/36qz0VtN8VrDOHwdKtiV4uG3i0R9uMJ7x0A==
X-Google-Smtp-Source: ABdhPJwbnFnuvV69POqIhVN70eF8CPPO4SK6FFDWU9U3BGMF2+0EkCUHs8VocVjFgAnDpLdlAlv2WlFmkDtHW0b6UTU=
X-Received: by 2002:a81:ff05:0:b0:2d6:8e83:e723 with SMTP id
 k5-20020a81ff05000000b002d68e83e723mr1025103ywn.382.1645642917934; Wed, 23
 Feb 2022 11:01:57 -0800 (PST)
MIME-Version: 1.0
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com> <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
In-Reply-To: <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 23 Feb 2022 21:01:21 +0200
Message-ID: <CAC_iWj+8hYruZce3MLucUiJmcF_0NWQUo7Q+1cqJJPYPjjrEBA@mail.gmail.com>
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all

[...]
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >   include/net/page_pool.h | 18 ++++++++++++++++++
> >   net/Kconfig             | 13 +++++++++++++
> >   net/core/page_pool.c    | 37 +++++++++++++++++++++++++++++++++----
> >   3 files changed, 64 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 97c3c19..bedc82f 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -135,7 +135,25 @@ struct page_pool {
> >       refcount_t user_cnt;
> >
> >       u64 destroy_cnt;
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     struct page_pool_stats __percpu *stats ____cacheline_aligned_in_smp;
> > +#endif
> > +};
>
> Adding this to the end of the struct and using attribute
> ____cacheline_aligned_in_smp cause the structure have a lot of wasted
> padding in the end.
>
> I recommend using the tool pahole to see the struct layout.
>
>
> > +
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +struct page_pool_stats {
> > +     struct {
> > +             u64 fast; /* fast path allocations */
> > +             u64 slow; /* slow-path order 0 allocations */
> > +             u64 slow_high_order; /* slow-path high order allocations */
> > +             u64 empty; /* failed refills due to empty ptr ring, forcing
> > +                         * slow path allocation
> > +                         */
> > +             u64 refill; /* allocations via successful refill */
> > +             u64 waive;  /* failed refills due to numa zone mismatch */
> > +     } alloc;
> >   };
> > +#endif
>
> All of these stats are for page_pool allocation "RX" side, which is
> protected by softirq/NAPI.
> Thus, I find it unnecessary to do __percpu stats.
>
>
> As Ilias have pointed out-before, the __percpu stats (first) becomes
> relevant once we want stats for the free/"return" path ... which is not
> part of this patchset.

Do we really mind though?  The point was to have the percpu variables
in order to plug in any stats that weren't napi-protected.  I think we
can always plug in the recycling stats later?  OTOH if you prefer
having them in now I can work with Joe and we can get that supported
as well.

Cheers
/Ilias
>
> --Jesper
>
