Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA27C6EE900
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 22:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjDYU2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 16:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjDYU2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 16:28:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460C3D333;
        Tue, 25 Apr 2023 13:28:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-517bb11ca34so4540640a12.0;
        Tue, 25 Apr 2023 13:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682454481; x=1685046481;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HClbTR8/Md4oIQbDjI1UVYFnEcUHBgTLFPdIBJbwoe4=;
        b=LOIQu1LM630hAPwxig05wc3kZloLkcP9NWVZs+r9LPTWelh3OQjLDP1WRFsTSgnyXr
         E4zW4GGcu9zo+r6r5LzezYUb8gsY8ADpXpHw8lf/7M+4z5k94Nz3jx/d/9CV9RkFF3QA
         ymL2dXnfQkbHjH1ZTfPl5uVkfT8U7yxdhhX+f5m7hPygYTHbwFogFB/2G1i4+YbvVxzi
         F2sNLQgl0zNxXtI5gOUJLzMQzRGp7Pm3WbMakRtpW+qA17B1zVGobXnKSir8hHoK/cSC
         lo4Vvw73KXMr4lVTao2q9+iuwC0I6FIU1UlNeka8u6NDYxv0N1yNod8ZLMc1gZck/6GV
         4ZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682454481; x=1685046481;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HClbTR8/Md4oIQbDjI1UVYFnEcUHBgTLFPdIBJbwoe4=;
        b=F/R2PZWX77ShHXMNLdvtsgbo7Y+TyQAszhjSrpcsm+WvAthD3pVYvfXpy1mluiiTsT
         K2cl92ZLzmi7KGkKQMzn4yKY4BJkYRDTIyLajkFnLjO6i9wZ7dIrco9Pz4M45hXVt6xF
         zcyQZ4R95cLcBbvalBX93NEAwd2uTCUvbk/qq8krsmoYxbbXFMpuHS+10+BQAfnN2L9z
         dVsPdWThHvzEex+dpQla4Vs3p/gNupUM2+12S1NbFz4tjVCnGxHeVHzzoRKL1Dg7115o
         jzSZVnavUaMlnPI95APg1xb69zcTWWMeQX3h65VD35RBD7G9i4gqRM6YS4A9Ko1nxqWe
         ooWw==
X-Gm-Message-State: AAQBX9cd2Ws0wVnorzBa/7NKjQAz3vsFII1DSRdHOfOxgPvkl10/IVRi
        8m3KJdmSLNcG2E2BAtY9BTk=
X-Google-Smtp-Source: AKy350bSkAU2WzqfVixaP2iqAYe1jpSg3QojfZgeHGz8Sdm7hA1BeSc31mEXiipn958UNJLfW1xNNQ==
X-Received: by 2002:a17:90a:70cc:b0:233:ee67:8eb3 with SMTP id a12-20020a17090a70cc00b00233ee678eb3mr19262344pjm.24.1682454480610;
        Tue, 25 Apr 2023 13:28:00 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:12ca:f2ca:4701:f7ae])
        by smtp.gmail.com with ESMTPSA id iz1-20020a170902ef8100b001a987c4d3b9sm1957776plb.290.2023.04.25.13.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 13:27:59 -0700 (PDT)
Date:   Tue, 25 Apr 2023 13:27:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <644837cec75d1_8f94b20880@john.notmuch>
In-Reply-To: <CAHApi-=Vr4VARgoDNB1T906gfDNB5L5_U24zE=ZHQi+qd__e8w@mail.gmail.com>
References: <20230423075335.92597-1-kal.conley@dectris.com>
 <6446d34f9568_338f220872@john.notmuch>
 <CAHApi-=Vr4VARgoDNB1T906gfDNB5L5_U24zE=ZHQi+qd__e8w@mail.gmail.com>
Subject: Re: [PATCH] xsk: Use pool->dma_pages to check for DMA
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

Kal Cutter Conley wrote:
> > > Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> > > active DMA mapping. pool->dma_pages needs to be read anyway to access
> > > the map so this compiles to more efficient code.
> >
> > Was it noticable in some sort of performance test?
> 
> This patch is part of the patchset found at
> https://lore.kernel.org/all/20230412162114.19389-3-kal.conley@dectris.com/
> which is being actively discussed and needs to be resubmitted anyway
> because of a conflict. While the discussion continues, I am submitting
> this patch by itself because I think it's an improvement on its own
> (regardless of what happens with the rest of the linked patchset). On
> one system, I measured a performance regression of 2-3% with xdpsock
> and the linked changes without the current patch. With the current
> patch, the performance regression was no longer observed.

Would be nice to have in commit message so reader has an idea the
perf numbers are in fact better.

> 
> > > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > > index d318c769b445..a8d7b8a3688a 100644
> > > --- a/include/net/xsk_buff_pool.h
> > > +++ b/include/net/xsk_buff_pool.h
> > > @@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
> > >       if (likely(!cross_pg))
> > >               return false;
> > >
> > > -     return pool->dma_pages_cnt &&
> > > +     return pool->dma_pages &&
> > >              !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
> > >  }
> 
> I would consider the above code part of the "fast path". It may be
> executed approximately once per frame in unaligned mode.

In the unlikely case though is my reading. So really shouldn't
be called for every packet or we have other perf issues by that
likely() there.

I assume the above is where the perf is being gained because below
two things are in setup/tear down. But then we are benchmarking
an unlikely() path?

> 
> > This seems to be used in the setup/tear-down paths so your optimizing
> > a control side. Is there a fast path with this code? I walked the
> > ice driver. If its just setup code we should do whatever is more
> > readable.
> 
> It is not only used in setup/tear-down paths (see above).
> Additionally, I believe the code is also _more_ readable with this
> patch applied. In particular, this patch reduces cognitive complexity
> since people (and compilers) reading the code don't need to
> additionally think about pool->dma_pages_cnt.
> 
> > Both the _alloc_ cases read neighboring free_heads_cnt so your saving a load I guess?
> > This is so deep into micro-optimizing I'm curious if you could measure it?
> 
> It is saving a load which also reduces code size. This will affect
> other decisions such as what to inline. Also in the linked patchset,
> dma_pages and dma_pages_cnt do not share a cache line (on x86_64).

But again buried in an unlikely path. Sure but removing the conditional
altogether would be even better.

> 
> >
> > >               } else {
> > >                       xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
> >
> > I'm not actually against optimizing but maybe another idea. Why do we have to
> > check at all? Seems if the DMA has been disabled/unmapped the driver shouldn't
> > be trying to call xsk_buff_alloc_batch? Then you can just drop the 'if' check.
> >
> > It feels to me the drivers shouldn't even be calling this after unmapping
> > the dma. WDYT?
> 
> Many of these code paths are used both for ZC and copy modes. You
> might be right that this particular case is only used with DMA.

So my understanding is ZC is preferred and default mode and copy modes
are primarily fall back modes. So we are punishing the good case here
for a fallback to copy mode. I think overall refactoring the code to
avoid burdoning the fast case with a fallback slow case would be ideal
solution.

However, I agree just on readability the patch is fine and good. No
objection on my side. But I think if we are making performance
arguments for 2-3% here the better thing to do is remove the check
and unlikely() and we would see better benchmarks when using the
ZC mode which as I understand it is what performance aware folks should
be doing.

Just $0.02 here.
