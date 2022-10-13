Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD105FD3AE
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 06:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJMEFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 00:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJMEFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 00:05:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27C62CC95
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 21:05:11 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z20so719579plb.10
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 21:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8++WI2cB9cLDorIe3CMpDCvK7dTWV1cZarVzqx3Q8ko=;
        b=QoMAkPZR2s/9mh6z5NesmgaH9PxD8SZ0UocJKumuHdLnwHhyAgawHy+OKUMhF0su4+
         48C6vUCMIuys8ybRZyuyuv8rQD0YniayJkgetcaw3AAy/H41Z7Nk6EIMBwS+0CGkduLI
         A43TwjfVlB0qhSJNRwkUXf1GfQ8zeiLRwb3uefzWaMUK2pc36vJymFDjIYFO9fM6y/2A
         1exw9RUTaswJiNEbTcb/vyoWss0Ddz0QT8CsKGQotGK0Ixb1iFZ30REunvUU7mIsVf3O
         KV+Z/ToGGx5pPFDn2Mm+K/BwcE5B4uZu91SeuJN3+6khHwE8Ro/iEWbObwH1QYTBR+aJ
         IPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8++WI2cB9cLDorIe3CMpDCvK7dTWV1cZarVzqx3Q8ko=;
        b=5WG+QV9moF8FEJeqD/WIMjUloWJK6mr1kQGxX4euzr2mpzuANFyhNkXC/cu/gGPZLH
         CjFE1et9SvpzEcQELSJPNWWjz6MDKtaWsiRkXU8AUe1sbNBVz3cER32u77QN7XRJfcMI
         GpRRull4qSfQ5USWqglZf7oiOMSj5NV5kKX/R9HovqDGgq6INfdyMnZVGyVOkEMnyhZf
         iH7mU9De/UBJVdTKbJkvFVrswCeAL7OWGAu3cCvxjdGYqM1LA772Vl8jnq3UdidczUBC
         SQNyA73GXoc6o+TSf3nGIbsYKs6Ou+AqnrC6sGY6WeEFHLd/SIczdZXSaGSN6b3rJInR
         dfWA==
X-Gm-Message-State: ACrzQf1Jo/61oOL/5wiGHhZ5BmkfkcF+rrPESpPnW72/rBkT4S/VaZTO
        mEtqGlqy9JprcCo4vhKq54+A9fmLdiACOMhTJr9O9g==
X-Google-Smtp-Source: AMsMyM6d0+w31svVHcuaYHAg3BuV3ceMvwAiuUxuiWsJk9qimEic/dUD/yMrEwf4UJYpeMjbm/iUpYNmyukYK2LGrwo=
X-Received: by 2002:a17:90a:d390:b0:20d:3b10:3811 with SMTP id
 q16-20020a17090ad39000b0020d3b103811mr8909675pju.211.1665633911035; Wed, 12
 Oct 2022 21:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
 <20221012173825.45d6fbf2@kernel.org> <20221013005431.wzjurocrdoozykl7@google.com>
 <20221012184050.5a7f3bde@kernel.org> <20221012201650.3e55331d@kernel.org>
 <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com> <20221012204941.3223d205@kernel.org>
In-Reply-To: <20221012204941.3223d205@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 12 Oct 2022 21:04:59 -0700
Message-ID: <CAEA6p_BUUzhHVAyaD3semV84M+TeZzmrkyjpwb-gs8e6sQRCWw@mail.gmail.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 8:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Oct 2022 20:34:00 -0700 Wei Wang wrote:
> > > I pushed this little nugget to one affected machine via KLP:
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 03ffbb255e60..c1ca369a1b77 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> > >                 return true;
> > >         }
> > >
> > > +       if (gfp_mask == GFP_NOWAIT) {
> > > +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> > > +               refill_stock(memcg, nr_pages);
> > > +       }
> > >         return false;
> > >  }
> > >
> > AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
> > you should return true to tell the caller that the nr_pages is
> > actually being charged.
>
> Ack - not sure what the best thing to do is, tho. Always pass NOFAIL
> in softirq?
>
> It's not clear to me yet why doing the charge/uncharge actually helps,
> perhaps try_to_free_mem_cgroup_pages() does more when NOFAIL is passed?
>
I am curious to know as well.

> I'll do more digging tomorrow.
>
> > Although I am not very sure what refill_stock() does. Does that
> > "uncharge" those pages?
>
> I think so, I copied it from mem_cgroup_uncharge_skmem().
