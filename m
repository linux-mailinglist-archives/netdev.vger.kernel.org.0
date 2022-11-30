Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C79763E10B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiK3Tvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK3Tvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:51:48 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED9186588;
        Wed, 30 Nov 2022 11:51:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d18so6949126pls.4;
        Wed, 30 Nov 2022 11:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rm61ltPf4IuMIek7hP38S0fd3od46k0u59OV/A4SUFE=;
        b=YPf0G8XJ72iHOC7HvWB7gUt6vwg2o+gvktb7yvputiaCaIey4xljHaDirr04vtz4nk
         w/kbuvDTJlraxX6CW7xM9IpLSWKiU+jd42zuI2twiV5dt9AmqgLE6nBiYTQC5hd0p3Mj
         NyYaNrTXkAuB+v42dOmyRgt+w4kMdLN6aoI9F/BTqbP8PT/xmvdRoWXbOc5I++Uv2qiH
         bQm7t259LLSxycIL8fRvm/FVyC/PbHbVLu9Bo/8LtDp7/hoei2igJRiHDSanP23h4WDG
         1eHs83TWLRWjHjRaDb0H9uimCzZvnGIH89l7KHvu+kE0mGYqSbNJ27+VKISbjBQrWg78
         rXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rm61ltPf4IuMIek7hP38S0fd3od46k0u59OV/A4SUFE=;
        b=jEa168algQajv+s7aFiPxt40RBDgL3RpYWs2RR8B5zwoMmVrlzWkVxq7uSQHENkNsC
         sC5W5OV2y4oe+9zdIooAWY2EKk0N+LwbsNLSMk+zCe7zXHHHfAJ0LTrbs3F6OwIr6nRv
         YX+DOQwXLteULAvwrejN1ze2eazzgoskwKztNIPK0u32pl9fMcuKqsX0P/uYCF8kOFGi
         xSH3N8sYovRPOLTp4RQwJz/z9mdJZQtW29QDQvqMiF+4GsditJ8aBc4KX+e7JLo9kgDl
         /6NxZSMT/fuc+M06oOR8u07FxRr+rAUCtQYSbXXYVbvW3HyBqTkvUBpVefGtmSdgLmhN
         O0vw==
X-Gm-Message-State: ANoB5pn9HXsMYu9NsOQxZX3ovheH/SbeQHmDUPFL8deoHtxlkgzpg0R6
        4JmPq7D2sWMOI0Syah/i2g/odiXCpwgJTOarcuA=
X-Google-Smtp-Source: AA0mqf446LWZq/SOD5Gg304JaLNU8xF7uR55IfibkGOcKLkjM/1PSNgGbWfF8JiqPIvtLyB43VrzvncGd5yIJWHo9fE=
X-Received: by 2002:a17:90a:5298:b0:217:e054:9ac8 with SMTP id
 w24-20020a17090a529800b00217e0549ac8mr73320400pjh.246.1669837906527; Wed, 30
 Nov 2022 11:51:46 -0800 (PST)
MIME-Version: 1.0
References: <4c341c5609ed09ad6d52f937eeec28d142ff1f46.1669489329.git.andreyknvl@google.com>
 <CANpmjNODh5mjyPDGpkLyj1MZWHr1eimRSDpX=WYFQRG_sn5JRA@mail.gmail.com>
In-Reply-To: <CANpmjNODh5mjyPDGpkLyj1MZWHr1eimRSDpX=WYFQRG_sn5JRA@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Wed, 30 Nov 2022 20:51:35 +0100
Message-ID: <CA+fCnZeuSVKLy7g9mAiV=2J5eTU6XisFA_byMSqKsopKr7EaQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kasan: allow sampling page_alloc allocations for HW_TAGS
To:     Marco Elver <elver@google.com>
Cc:     andrey.konovalov@linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        kasan-dev@googlegroups.com, Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Florian Mayer <fmayer@google.com>,
        Jann Horn <jannh@google.com>,
        Mark Brand <markbrand@google.com>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>
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

.On Tue, Nov 29, 2022 at 12:30 PM Marco Elver <elver@google.com> wrote:
>
> On Sat, 26 Nov 2022 at 20:12, <andrey.konovalov@linux.dev> wrote:
> >
> > From: Andrey Konovalov <andreyknvl@google.com>
> >
> > Add a new boot parameter called kasan.page_alloc.sample, which makes
> > Hardware Tag-Based KASAN tag only every Nth page_alloc allocation for
> > allocations marked with __GFP_KASAN_SAMPLE.
>
> This is new - why was it decided that this is a better design?

Sampling all page_alloc allocations (with the suggested frequency of 1
out of 10) effectively means that KASAN/MTE is no longer mitigation
for page_alloc corruptions. The idea here was to only apply sampling
to selected allocations, so that all others are still checked
deterministically.

However, it's hard to say whether this is critical from the security
perspective. Most exploits today corrupt slab objects, not page_alloc.

> This means we have to go around introducing the GFP_KASAN_SAMPLE flag
> everywhere where we think it might cause a performance degradation.
>
> This depends on accurate benchmarks. Yet, not everyone's usecases will
> be the same. I fear we might end up with marking nearly all frequent
> and large page-alloc allocations with GFP_KASAN_SAMPLE.
>
> Is it somehow possible to make the sampling decision more automatic?
>
> E.g. kasan.page_alloc.sample_order -> only sample page-alloc
> allocations with order greater or equal to sample_order.

Hm, perhaps this could be a good middle ground between sampling all
allocations and sprinkling GFP_KASAN_SAMPLE.

Looking at the networking code, most multi-page data allocations are
done with the order of 3 (either via PAGE_ALLOC_COSTLY_ORDER or
SKB_FRAG_PAGE_ORDER). So this would be the required minimum value for
kasan.page_alloc.sample_order to alleviate the performance impact for
the networking workloads.

I measured the number of allocations for each order from 0 to 8 during
boot in my test build:

7299 867 318 206 86 8 7 5 2

So sampling with kasan.page_alloc.sample_order=3 would affect only ~7%
of page_alloc allocations that happen normally, which is not bad. (Of
course, if an attacker can control the size of the allocation, they
can increase the order to enable sampling.)

I'll do some more testing and either send a v3 with this approach or
get back to this discussion.

Thanks for the suggestion!
