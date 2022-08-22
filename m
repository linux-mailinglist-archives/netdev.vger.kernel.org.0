Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E639859B89A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiHVE7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiHVE7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:59:33 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B99224F0D
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:59:32 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w13so3325190pgq.7
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9XhZmihVWYtN8pqGhGwupTf+AWRqtf1YyaQ/pGiog9k=;
        b=e4g+T2mMYZZcLZKVuyYTBE7KioYD6BNBNG1cLqDFZ5B9t0E6FIRD5EvbyAzLTCr3kJ
         rA6ZK7oCz9GEATt82qpw+2JFjAHNx6MWzrOEJkCcglpPUJI6hS1usRrjSP0PtvLaklzt
         2SWFQW3etXo3F8BRQXjkvsEAD1xWTy3389fS+y8cwwh/ZpGZYzfVQV4mAVDrVneI1RKY
         LqoHhaNoGRAKG4D6abLWZ4z6qaxhraGCM7tcAmHqKNXwMFf8R6WZS65/KM+mSpunicvW
         NoZagRqgMyd0mx1A/gtNa8G0tjAlwmRM7GukYQSHxRJh5NrCaUN7Ht0Ligb/wX1I4ajV
         MSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9XhZmihVWYtN8pqGhGwupTf+AWRqtf1YyaQ/pGiog9k=;
        b=z83MegHERDpPPSdW9QCqnTFL1X0sVf6q5AbJBaNffo0JVlDk4ahYeyxonjFQ50xSRq
         V1ZaDofVmfGMqOhjT3ngVsfJAaU1Q78LVOBo+Cag6DS3aC0e9fjMEx/KOSSvhhJMLWj4
         jBYjSOo3jCYjeHtivD1lwZ6HIrsAkHmQ0+7vEZLPz9fx01qgHyTw4cDNXYjYiv1eIqs8
         OqRC3xYHgTIFpBCyo9gtVMivSjdG555L2/W3dRbc5FF/QfuU+c2/vRfGEP0dQHcWXzKK
         hyhZchyudU5h0Qd9rtumYs0J2z5RWzyNSuAwbealG/CFVpMTOo+KsVqoWP5ED2CkHN2c
         vF+A==
X-Gm-Message-State: ACgBeo28AHfl5Lx9quFGtLRyn2kNycRDfZ05AZiYaypV/ks1wrNklpEq
        GOiwz1HNLTP0gMnqk/7UvHexIJbcVdWB+NKaDDGXXw==
X-Google-Smtp-Source: AA6agR4/1s7y++qNsA2/cfFgEIhAK4Q20RaQ1xUDhpnZDmYg93tgbnj5pntFlvFsEA9PvT9gkP9gZgjLoqCg32dK4EA=
X-Received: by 2002:a62:6497:0:b0:52e:e0cd:1963 with SMTP id
 y145-20020a626497000000b0052ee0cd1963mr19195169pfb.58.1661144371422; Sun, 21
 Aug 2022 21:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <YwLlsr0jNq5m6v8z@feng-clx>
In-Reply-To: <YwLlsr0jNq5m6v8z@feng-clx>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sun, 21 Aug 2022 21:59:20 -0700
Message-ID: <CALvZod6d_0ERWy3bsCaLwoNhn7H6YnGeJfs_S5H+Fy2xb3eM9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
To:     Feng Tang <feng.tang@intel.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        "Michal Koutn??" <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "Sang, Oliver" <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lkp@lists.01.org" <lkp@lists.01.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On Sun, Aug 21, 2022 at 7:12 PM Feng Tang <feng.tang@intel.com> wrote:
>
> On Mon, Aug 22, 2022 at 08:17:36AM +0800, Shakeel Butt wrote:
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
> >
> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)     10482.7 Mbps
> > With patch            12413.7 Mbps (18.4% improvement)
> >
> > With the patch, the throughput improved by 18.4%.
> >
> > One side-effect of this patch is the increase in the size of struct
> > mem_cgroup. However for the performance improvement, this additional
> > size is worth it. In addition there are opportunities to reduce the size
> > of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> > and better packing.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
>
> Looks good to me, with one nit below.
>
> Reviewed-by: Feng Tang <feng.tang@intel.com>

Thanks.

>
> > ---
> >  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index 679591301994..8ce99bde645f 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -3,15 +3,27 @@
> >  #define _LINUX_PAGE_COUNTER_H
> >
> >  #include <linux/atomic.h>
> > +#include <linux/cache.h>
> >  #include <linux/kernel.h>
> >  #include <asm/page.h>
> >
> > +#if defined(CONFIG_SMP)
> > +struct pc_padding {
> > +     char x[0];
> > +} ____cacheline_internodealigned_in_smp;
> > +#define PC_PADDING(name)     struct pc_padding name
> > +#else
> > +#define PC_PADDING(name)
> > +#endif
>
> There are 2 similar padding definitions in mmzone.h and memcontrol.h:
>
>         struct memcg_padding {
>                 char x[0];
>         } ____cacheline_internodealigned_in_smp;
>         #define MEMCG_PADDING(name)      struct memcg_padding name
>
>         struct zone_padding {
>                 char x[0];
>         } ____cacheline_internodealigned_in_smp;
>         #define ZONE_PADDING(name)      struct zone_padding name;
>
> Maybe we can generalize them, and lift it into include/cache.h? so
> that more places can reuse it in future.
>

This makes sense but let me do that in a separate patch.
