Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB49553964D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347050AbiEaS3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347047AbiEaS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:29:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0597532FF;
        Tue, 31 May 2022 11:29:12 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t5so18710789edc.2;
        Tue, 31 May 2022 11:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DgNqW4//ddECki3dc1mKGiHL7tQBiKwjHn92jkr+JC8=;
        b=d1WWUT5CdthQk2XN9McJR10DNsns2iAqPovkQCkpfZLnlhdh7wC2dFlNszNMcqD3Ij
         YYfgROZFScvyXQKZjxYps4O1VcDZYwwtiFedp0WlGwmE05VLMT2osLDfo/l/4Ulky0Dt
         VtDPTstUcwrukbKqFlF3YyfyIPyFul6ylsK+B8yoFnrxRq8hBq37p0xr+dpp18g65qZL
         V8yFX6N1IAeYjC0i4Gf/WokNIglZiTghMk4Uy3cfy1nfOGWHwxFLIGnKP2qeVbNtmZxO
         K5JexoUXnO4BW7VDoBp3/2DR/lOlBhN43cIaVqRslZslUnmQOlLA4CM+9qzjK9hFbu79
         SzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DgNqW4//ddECki3dc1mKGiHL7tQBiKwjHn92jkr+JC8=;
        b=QjX2v4Mv44PcnLvenJiWfGuEf1knuEeNSTBdSP70LwQLl2roa4kN+zwaMZkN8amixu
         3oJLf1tj6Pt/k8c7crzPxoPXN1hRbOp/VRzN0+n9F0CEGjZ99wfOLioTvv8q+kHL+TqY
         x5LJVtGeSSeEb1O1DZnTWmj4WXLQCfHsdiWsFFf8Li5E4wP9F7RAAZdCdQoRE8WLMg/z
         Q7Vm5vHmx8S/wbq9ARvvzZAogjyL+TvFjru8IHDzSmh552S9FDULlcuhP9/0FPhrvAIY
         jUvTLbaSzDwtEYyDLVdKwc8ByLEPSz10LR2UlW4FSy7+iLSgyBWHUe3ea3eneMmHLj5X
         8E6w==
X-Gm-Message-State: AOAM5306ry3lD1q/9FTvfYTEdXkpKzNrqIOpsIAf7+Q4R5dRYU6h5qkw
        JtXLd/QeyMVXxff15kWTJO5j4SN2mjUW4hxzVoOxxJTc67Q=
X-Google-Smtp-Source: ABdhPJyP2gZhuAqixr/6FoMnvMAXWzGNQii4hUkd7cJZdqEJN85R+/aL+b0BXRG1cK6OXGqvVswk5XuE6jwaBYPB1nY=
X-Received: by 2002:a05:6402:3299:b0:42d:d630:7ce1 with SMTP id
 f25-20020a056402329900b0042dd6307ce1mr9998252eda.136.1654021751120; Tue, 31
 May 2022 11:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220531081412.22db88cc@kernel.org> <1654011382-2453-1-git-send-email-chen45464546@163.com>
 <20220531084704.480133fa@kernel.org>
In-Reply-To: <20220531084704.480133fa@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 31 May 2022 11:28:59 -0700
Message-ID: <CAKgT0UfQsbAzsJ1e__irHY2xBRevpB9m=FBYDis3C1fMua+Zag@mail.gmail.com>
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is bigger
 than PAGE_SIZE
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chen Lin <chen45464546@163.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 8:47 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 May 2022 23:36:22 +0800 Chen Lin wrote:
> > At 2022-05-31 22:14:12, "Jakub Kicinski" <kuba@kernel.org> wrote:
> > >On Tue, 31 May 2022 22:41:12 +0800 Chen Lin wrote:
> > >> The sample code above cannot completely solve the current problem.
> > >> For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE(32768),
> > >> __page_frag_cache_refill will return a memory of only 32768 bytes, so
> > >> should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe more
> > >> work needs to be done
> > >
> > >Right, but I can think of two drivers off the top of my head which will
> > >allocate <=32k frags but none which will allocate more.
> >
> > In fact, it is rare to apply for more than one page, so is it necessary to
> > change it to support?
>
> I don't really care if it's supported TBH, but I dislike adding
> a branch to the fast path just to catch one or two esoteric bad
> callers.
>
> Maybe you can wrap the check with some debug CONFIG_ so it won't
> run on production builds?

Also the example used here to define what is triggering the behavior
is seriously flawed. The code itself is meant to allow for order0 page
reuse, and the 32K page was just an optimization. So the assumption
that you could request more than 4k is a bad assumption in the driver
that is making this call.

So I am in agreement with Kuba. We shouldn't be needing to add code in
the fast path to tell users not to shoot themselves in the foot.

We already have code in place in __netdev_alloc_skb that is calling
the slab allocator if "len > SKB_WITH_OVERHEAD(PAGE_SIZE)". We could
probably just add a DEBUG wrapped BUG_ON to capture those cases where
a driver is making that mistake with __netdev_alloc_frag_align.
