Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E5E59B706
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 02:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiHVAYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 20:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiHVAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 20:24:43 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CA51F627
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:24:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy5so18311800ejc.3
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Eqv/19N5yEMgS5A7uMKIDvv+xbcnmfhfYxaJZgO8F20=;
        b=UicQpWpEmeF4kKoeqp/WmxAnf9tSyJSlCCvCKpoqea2kLCQ69aIPlMRNh8C+3XkGXM
         CKOhqFgao3DWFDsjsLNq8xeVqbewCc8NY9lCkqgwSywO8chlQH1+JVfwzfmlOpCeeddL
         ir8WDMIFe6sx2wEA55JyybCPBhEpqg/vfyoiWOWv7MhagbOKbO8lPdDqTDWvJscIAu6T
         g85dXRDbtNY6hSb/sZbRSHwGldG8kMBGLoi9Lcxh9F9wHALlSTO1M6IEA7bhddGDltAY
         uaPJXmxeBr/+rY0peyXTPwikF6BcvdKBZy1ivGuvz7hXUurZcqE3n6U9eAeqRYOQ8HXj
         ahsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Eqv/19N5yEMgS5A7uMKIDvv+xbcnmfhfYxaJZgO8F20=;
        b=SVNLEJdFBQkY/ibH95QHFqqPU8ZxX6cQC1hF/TAryj61AmdjkGOjH+KkECarfvfilI
         rRyvVFKxmRwUempfo2Y05iqFOgjk8M4pnjjuqRw1f7MHgXLRUf8Ous4lZnX7nzH7kSXt
         kybXqCDdXsuv87pBnhckPQ11w5Z0NSrVZxOUhvA0TMcaMYgD5isxbjjgfWDUU1pdvByy
         MYHNyzYlSwSFFVpRHKlu7+9Aeodpqrd6D5AP1pIuk+CPWKvCDFzg5AhbxRrRQnpEmaR6
         gHb65lrVl8pWRAMzWk5gPmZ3a3qbcYzShJC37C+t37zKWtzRvn32jOrvYf1Snzrdwunv
         Tnyg==
X-Gm-Message-State: ACgBeo26pdjRsjB8sZtUODxYgL3KxZEF19TnlPYpGbWDXHelfgT+X51p
        mECz+210X5I7edj02t+Uj1i8tgHvJXY6XyRshkaK4A==
X-Google-Smtp-Source: AA6agR74JWGl5DtIW8j+H1KQUaVqCL/3GicPtrTzXAVqrBl/z2Ksrr0mXRq26zG4EyxF4PdTnY+kAzRg6WDkfsMNnW4=
X-Received: by 2002:a17:907:2e0b:b0:730:8aee:d674 with SMTP id
 ig11-20020a1709072e0b00b007308aeed674mr11635721ejc.104.1661127880648; Sun, 21
 Aug 2022 17:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
In-Reply-To: <20220822001737.4120417-3-shakeelb@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sun, 21 Aug 2022 20:24:04 -0400
Message-ID: <CACSApvYU5gfbDv9dyaypu1oOPB58eT1inX9EX6gV5b2q3+qr6Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> With memcg v2 enabled, memcg->memory.usage is a very hot member for
> the workloads doing memcg charging on multiple CPUs concurrently.
> Particularly the network intensive workloads. In addition, there is a
> false cache sharing between memory.usage and memory.high on the charge
> path. This patch moves the usage into a separate cacheline and move all
> the read most fields into separate cacheline.
>
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
>
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
>
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              12413.7 Mbps (18.4% improvement)
>
> With the patch, the throughput improved by 18.4%.

Shakeel, for my understanding: is this on top of the gains from the
previous patch?

> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. However for the performance improvement, this additional
> size is worth it. In addition there are opportunities to reduce the size
> of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> and better packing.
>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> ---
>  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994..8ce99bde645f 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,15 +3,27 @@
>  #define _LINUX_PAGE_COUNTER_H
>
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
>
> +#if defined(CONFIG_SMP)
> +struct pc_padding {
> +       char x[0];
> +} ____cacheline_internodealigned_in_smp;
> +#define PC_PADDING(name)       struct pc_padding name
> +#else
> +#define PC_PADDING(name)
> +#endif
> +
>  struct page_counter {
> +       /*
> +        * Make sure 'usage' does not share cacheline with any other field. The
> +        * memcg->memory.usage is a hot member of struct mem_cgroup.
> +        */
> +       PC_PADDING(_pad1_);
>         atomic_long_t usage;
> -       unsigned long min;
> -       unsigned long low;
> -       unsigned long high;
> -       unsigned long max;
> +       PC_PADDING(_pad2_);
>
>         /* effective memory.min and memory.min usage tracking */
>         unsigned long emin;
> @@ -23,16 +35,16 @@ struct page_counter {
>         atomic_long_t low_usage;
>         atomic_long_t children_low_usage;
>
> -       /* legacy */
>         unsigned long watermark;
>         unsigned long failcnt;
>
> -       /*
> -        * 'parent' is placed here to be far from 'usage' to reduce
> -        * cache false sharing, as 'usage' is written mostly while
> -        * parent is frequently read for cgroup's hierarchical
> -        * counting nature.
> -        */
> +       /* Keep all the read most fields in a separete cacheline. */
> +       PC_PADDING(_pad3_);
> +
> +       unsigned long min;
> +       unsigned long low;
> +       unsigned long high;
> +       unsigned long max;
>         struct page_counter *parent;
>  };
>
> --
> 2.37.1.595.g718a3a8f04-goog
>
