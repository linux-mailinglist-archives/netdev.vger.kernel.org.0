Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711545E555B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiIUVoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIUVof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:44:35 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1D1F5AB
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:44:34 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e68so7331465pfe.1
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=xTBSupUlkRcHtdXmZjmy7VWWgoDWkCTOxj/pSzxTfCA=;
        b=fVhKV9siiwbHDPhDJTx5ftV3jAFrjmG7I7scwWFNNJZWvh297Xd0VcnJa28T7n+gUP
         t5Du8QSG/0YeHqqRQRwcIduWV2BH42fcl/zixKWqsfusI0LS/Z9O4cw9SOPI1zEAM22W
         J3ezbGibJdrJGwzNUO+wCkCgiGhPU8fdxJpm3jYNsN0Fa3MeH+VlH8aeIniKwX1aJ4sl
         g7ONiVLsixqYAubPX81FlPTNh6VLpktgF/O8IvAzRpFPyGmN1YVIYY/nG61oUV27Tm4A
         pzIRGCvZrBWZPa47lq8bHWmLI6RGngLf7kJYDs8inHVvK6iMMG3/f2J1Gk1id9jvSwLB
         5G/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xTBSupUlkRcHtdXmZjmy7VWWgoDWkCTOxj/pSzxTfCA=;
        b=5eOW2IG2LYjwqXF0sIB8+X/InWQUtX8bCqU6YV9LK8VXtUxnKUiX9AZLCIiByRSBzl
         A1vJjSU4QdrLOrAoN0kvtDjCuDU1MHhFJVZq2rNuN+RF1R24EQvGe3QSlys+phjkHHfU
         /n3WfCA29YZALBvIXqsKVQ/oAmNTYDBCxQNd/JGDj7w+6GJ4PEaadKNAz2jp+9FoCUWF
         jjuuW4cxM4+6VQ3iNZjqS5uowKSlIsEmDvVCKiVxkdqMtlHpMzsJpZ0UMkonvxY1U5ln
         18ruzE7+kGPuIp1BJSQasI132+1pq7Edc/Rb/h/NwnlAVtoto8sBwdDAhKrFSVDdG1k+
         0HrA==
X-Gm-Message-State: ACrzQf0l6uTurynEa++3JvNqqjz6OcBa2cN8Wacqu+2Hb+28nTxCV9WJ
        ojE3miQMLXcHaqxSn6A8jHKmKP162GAYjyKZoEOS4qkY
X-Google-Smtp-Source: AMsMyM5OtVm4OU17wo+F9KCrXgLis2v6RzvLkpoh4taCtOWY2d53SKaK5O4qIcf0VeJI4G4WN63U1+5bH8LbhcnosYc=
X-Received: by 2002:a63:4d4:0:b0:438:ce28:757f with SMTP id
 203-20020a6304d4000000b00438ce28757fmr189015pge.441.1663796674025; Wed, 21
 Sep 2022 14:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
 <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
 <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
 <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com> <d347ab0f1a1aaf370d7d2908122bd886c02ec983.camel@redhat.com>
In-Reply-To: <d347ab0f1a1aaf370d7d2908122bd886c02ec983.camel@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 21 Sep 2022 14:44:22 -0700
Message-ID: <CAKgT0Uf-fDHD_g75PSO591WVHdtHuUJ+L=aWBWoiM3vHyzxRtw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 1:52 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-09-21 at 13:23 -0700, Alexander H Duyck wrote:
> > On Wed, 2022-09-21 at 21:33 +0200, Paolo Abeni wrote:
> > > Nice! I'll use that in v2, with page_ref_add(page, offset / SZ_1K - 1);
> > > or we will leak the page.
> >
> > No, the offset already takes care of the -1 via the "- SZ_1K". What we
> > are adding is references for the unused offset.
>
> You are right. For some reasons I keep reading PAGE_SIZE instead of
> 'offset'.
>
> > > >
> > It occurs to me that I think you are missing the check for the gfp_mask
> > and the reclaim and DMA flags values as a result with your change. I
> > think we will need to perform that check before we can do the direct
> > page allocation based on size.
>
> Yes, the gtp_mask checks are required (it just stuck me a few moments
> ago ;). I will move the code as you originally suggested.
>
> > > >
> > > Why? in the end we will still use an ancillary variable and the
> > > napi_alloc_cache struct will be bigger (probaly not very relevant, but
> > > for no gain at all).
> >
> > It was mostly just about reducing instructions. The thought is we could
> > get rid of the storage of the napi cache entirely since the only thing
> > used is the page member, so if we just passed that around instead it
> > would save us the trouble and not really be another variable. Basically
> > we would be passing a frag cache pointer instead of a napi_alloc_cache.
>
> In that case we will still duplicate a bit of code  -
> this_cpu_ptr(&napi_alloc_cache) on both branches. gcc 11.3.1 here says
> that the generated code is smaller without this change.

Why do you need to duplicate it? I thought you would either be going
with nc->page or nc->page_small depending on the size so either way
you are accessing nc. Once you know you aren't going to be using the
slab cache you could basically fetch that and do the setting of
__GFP_MEMALLOC before you would even need to look at branching based
on the length. The branch on size would then assign the
page_frag_cache pointer, update the length, fetch the page frag, and
then resume the normal path.
