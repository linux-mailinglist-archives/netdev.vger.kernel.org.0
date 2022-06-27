Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF94C55D7B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiF0QsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiF0QsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:48:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A55C04
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:48:13 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x8so5011294pgj.13
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D9X7Baf6YEccScfwTHV2+DoPAKr+D06FDzhDesIrDHU=;
        b=TY2iLMl+iHQtwwgqdID5GGR/WgTM934LvGgTG5bdqshKdHchwFWk1/f7YcudfG28C1
         9svXGsq3ZBUdpFHkuir48kWdUp3+pk7zV9uR3pX3gssgb3g7T4Uld0Y5GC+YNwjiyyUi
         JaQ614mZjho9lPRJILtdry1rGOBttSD/YqxwDAQgnUoUa0wg4Jg73a4zXCRzF1KjrIyd
         6WOLmF0GeKCQ+uyS14AIDBC8y9PCeYTPXlWFWNAlUpXJJxnaFWk41qgGu1NyepGq/BCn
         rOr2Kt4QaK+ajKmOKpIMCnONrGRHdxChGIF3ol6MkzFrpF0tJ1PFYirMMNa2s5PESFwE
         xDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D9X7Baf6YEccScfwTHV2+DoPAKr+D06FDzhDesIrDHU=;
        b=s8qUNoihYzhDVtCEWZaq1htG6OAeg7KASJAubnmfiUT0L+CSaOCoo7s1gjEGifAUVS
         6m0j6zTvxONgFgxI4sOQjYBjUwEuGyKifh9QItnIsXrmcJAEITx8Z82n49wn9TS+pwD8
         Ll7sZbSwC/oKqdVESrlbPd5/6O0zZfaPSvy5v6yPclweJ+0G32wXKGsLqLOa+P7rqgID
         yOXNvGAnjGzkSjNUMIc1T8hEhMMu+FO5eUVL/bspQx8UAXyv/EX9ERAOoJeoFV+yhnBf
         NJdjVFaHF8bih+O/2A0IdyOjAvtTVUKUP50+UAjzIbF+nBG/P/XsPL7bf1xgrSph8IwN
         HR8Q==
X-Gm-Message-State: AJIora/DeFoqZp1Hph5eV2+WEqyCMB+Az4nknHH2hzAPu3kwa/aEeoxm
        drnRCtaiw3Ibt43IcSITSDibiO9XAo2NHUOMV4k9JQ==
X-Google-Smtp-Source: AGRyM1towA5pHVttt57ZXcLFZBHO5p9LUL8cqF9G7ljmFR23cWoIMilVj+6dSITeXoJrr0H4tquCuyHDp9ibcsb2nz8=
X-Received: by 2002:a63:6cc8:0:b0:40d:e553:f200 with SMTP id
 h191-20020a636cc8000000b0040de553f200mr6817388pgc.166.1656348492366; Mon, 27
 Jun 2022 09:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220623185730.25b88096@kernel.org> <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com> <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com> <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com> <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com> <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
In-Reply-To: <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 27 Jun 2022 09:48:01 -0700
Message-ID: <CALvZod60OHC4iQnyBd16evCHXa_8ucpHiRnm9iNErQeUOycGZw@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Eric Dumazet <edumazet@google.com>
Cc:     Feng Tang <feng.tang@intel.com>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, MPTCP Upstream <mptcp@lists.linux.dev>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Yin Fengwei <fengwei.yin@intel.com>, Ying Xu <yinxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 9:26 AM Eric Dumazet <edumazet@google.com> wrote:
>
[...]
> >
>
> I simply did the following and got much better results.
>
> But I am not sure if updates to ->usage are really needed that often...

I suspect we need to improve the per-cpu memcg stock usage here. Were
the updates mostly from uncharge path or charge path or that's
irrelevant?

I think doing full drain (i.e. drain_stock()) within __refill_stock()
when the local cache is larger than MEMCG_CHARGE_BATCH is not best.
Rather we should always keep at least MEMCG_CHARGE_BATCH for such
scenarios.

>
>
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994d316062f92b275efa2459a8349c9..e267be4ba849760117d9fd041e22c2a44658ab36
> 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,12 +3,15 @@
>  #define _LINUX_PAGE_COUNTER_H
>
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
>
>  struct page_counter {
> -       atomic_long_t usage;
> -       unsigned long min;
> +       /* contended cache line. */
> +       atomic_long_t usage ____cacheline_aligned_in_smp;
> +
> +       unsigned long min ____cacheline_aligned_in_smp;

Do we need to align 'min' too?

>         unsigned long low;
>         unsigned long high;
>         unsigned long max;
> @@ -27,12 +30,6 @@ struct page_counter {
>         unsigned long watermark;
>         unsigned long failcnt;
>
> -       /*
> -        * 'parent' is placed here to be far from 'usage' to reduce
> -        * cache false sharing, as 'usage' is written mostly while
> -        * parent is frequently read for cgroup's hierarchical
> -        * counting nature.
> -        */
>         struct page_counter *parent;
>  };
>
>
>
