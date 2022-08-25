Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCB05A15B5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbiHYP2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242168AbiHYP12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:27:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A26BB6A1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 08:26:03 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c2so18829452plo.3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 08:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Zsqv9AykgJ+WV9feY4vZLdyL0HO37C5wC/zUOZBB/Rs=;
        b=HWnl7UrUYlzNgRl6uEFPplyGVawiIDXFH7m8PBsKuwLAyY4wVOH5/4W+KHE3cm4dmy
         4VKpGXbIOjUVTNJ5qTAEfFLY5j3Yf3cnEjwgexlgBZzwA/NZqy+OA837il6nxkXV5MZ8
         bWeOe7RYnCeBZeCaEDApmwAvBPMIcLaY9ZVBN4TcWiNWpqvDtnBHm4rNi4l+iIhXSBbt
         Vb5TpW9i3LVxD0fenWNvYo2kmlhk6MMD/fpNzQjOSsWwzJLxUQdlnEY1aV6QOjHMKsIC
         o6Aj0pItiOXOcalFXaXlzd4qp/y4sLZ4X8K4ywWFjTAOSTa/Uzz4A9Ct6uhXYJn4n24B
         gkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Zsqv9AykgJ+WV9feY4vZLdyL0HO37C5wC/zUOZBB/Rs=;
        b=5D8Xw4HL0dIR6icAW2jaFD4TlXSRr1qdh6+qyzqX3miOQEMV2NZ/SW1UKSA5GsoiU7
         1JOQ+akePPmudik0AcO1Ezpmyj8EA+fUf2+sCq5XYaoFd3hTtwha0exJsDio+tcdLMGh
         Vt/04+sHwL7KGN88HPp2uIf+xbXI9QTfsK6LHI6BtC0MRpA2fI4gipprRdeoi51kA6Mb
         heHxPB4pTgROz2nlcEJBYn+EzKOU+s70iYW+8ttdRRiPXBUbqnEJDGZZecCZB0ZQBjEY
         AmyRWNKyTJKy+VW9qATXiwAS2Uv+O0uhqFiGNHTXgk0PdxDJGoqcPCfl3Icjg9K1ca/x
         5QDw==
X-Gm-Message-State: ACgBeo1Ui8pzO0AL1rOT/sYxQoWYGSsua3oUFz22O1oC7Gl9DWRW16iB
        V2EqpthskA0Nts5FOenNSrhIZQe4Zq7c873vmx4LfQ==
X-Google-Smtp-Source: AA6agR7yKFRvtMiJWUoOhnBb6dODuZY59WJG0S4sLUXExTnTCnnQec25vcU6SQQtE/2OZn6xCtg2SViS0OjZjhqHnPQ=
X-Received: by 2002:a17:902:d58f:b0:173:75b:6ad with SMTP id
 k15-20020a170902d58f00b00173075b06admr4194683plh.172.1661441150947; Thu, 25
 Aug 2022 08:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220825000506.239406-1-shakeelb@google.com> <20220825000506.239406-3-shakeelb@google.com>
 <Ywca/EqpyQDAWlE2@dhcp22.suse.cz>
In-Reply-To: <Ywca/EqpyQDAWlE2@dhcp22.suse.cz>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 25 Aug 2022 08:25:38 -0700
Message-ID: <CALvZod6mqtZ+iELhg2Q+SbdcicGSbY4piymzFCOPsy5UxvtbRg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter fields
To:     Michal Hocko <mhocko@suse.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Aug 24, 2022 at 11:47 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Thu 25-08-22 00:05:05, Shakeel Butt wrote:
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy.
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
> > mem_cgroup. For example with this patch on 64 bit build, the size of
> > struct mem_cgroup increased from 4032 bytes to 4416 bytes. However for
> > the performance improvement, this additional size is worth it. In
> > addition there are opportunities to reduce the size of struct
> > mem_cgroup like deprecation of kmem and tcpmem page counters and
> > better packing.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Reviewed-by: Feng Tang <feng.tang@intel.com>
> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
>
> Acked-by: Michal Hocko <mhocko@suse.com>
>

Thanks.

> One nit below
>
> > ---
> > Changes since v1:
> > - Updated the commit message
> > - Make struct page_counter cache align.
> >
> >  include/linux/page_counter.h | 35 +++++++++++++++++++++++------------
> >  1 file changed, 23 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index 679591301994..78a1c934e416 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -3,15 +3,26 @@
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
> > +
> >  struct page_counter {
> > +     /*
> > +      * Make sure 'usage' does not share cacheline with any other field. The
> > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > +      */
> >       atomic_long_t usage;
> > -     unsigned long min;
> > -     unsigned long low;
> > -     unsigned long high;
> > -     unsigned long max;
> > +     PC_PADDING(_pad1_);
> >
> >       /* effective memory.min and memory.min usage tracking */
> >       unsigned long emin;
> > @@ -23,18 +34,18 @@ struct page_counter {
> >       atomic_long_t low_usage;
> >       atomic_long_t children_low_usage;
> >
> > -     /* legacy */
> >       unsigned long watermark;
> >       unsigned long failcnt;
>
> These two are also touched in the charging path so we could squeeze them
> into the same cache line as usage.
>
> 0-day machinery was quite good at hitting noticeable regression anytime
> we have changed layout so let's see what they come up with after this
> patch ;)

I will try this locally first (after some cleanups) to see if there is
any positive or negative impact and report here.

> --
> Michal Hocko
> SUSE Labs
