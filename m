Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9DD55CB8A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiF0Q0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbiF0Q0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:26:15 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AFF14011
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:26:13 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id d5so17641490yba.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0o8BHvdouHjDX6xouAXOA71Zh+Aq3Bg25pMCWdlg9b8=;
        b=coLTvVYf1AMKsLzXaSyW9avdObFVi9AfgpRcJ3zIuN2nVUgZoKqGl3XnOQ3w3IBd/1
         RT3FtAvVINKwpFTt77CkGAN8ynsuJpqn9OZRYUNEGRazUoVdLKZfpxVG9gl4cZukIK/s
         StqHeKVJ1Q6XWubOJBqkX+hUNXu5YbKyT9lGh906qe4hL/IkDHkwssiw2d3+fujLchaS
         hjx30y2d9tUGcp/U2ILmrakRTs3wOy2TXgxcM1wUZCcj9Uei71JzG8DUgS8/Npso+2Ue
         C/KXjBRMC8BIiyiRRnxp5o8G+yys/v8rZia0oajmilb3P1WiKR30Aw0D3J8u/hG+qZcz
         fMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0o8BHvdouHjDX6xouAXOA71Zh+Aq3Bg25pMCWdlg9b8=;
        b=J1KmoWrVuanbzvEsqR37IOAbO+VQCndsJDSMccROH1vYLDfoFCId5nhgRrCNrNYOE5
         ulGJ9JnsrKQhl9ei+DzXj/rVKf+jmusFBKwLczYEWm3UpDN7s/cjgH/La70s9lArsWcD
         yps7SgevGeRc45VYYh41mC6L+RiNi2HwKiwDUNzNftrA/OZgRbbzkYe/bIf0T0ohWjdM
         d9i6AgmRBu63VfQmgwVqsliqC/XRTw98hRcWeg9WT6LbDmqAcjWlBPaa713ewOimBgUq
         xWvTC602Wq2YJmQcAcc9AjbAWQAh3KIHotTU0xSyb5UBU9uenq3pZWIVmCCvARVtGZqe
         7EeQ==
X-Gm-Message-State: AJIora8OwEqHLDPy+tUQDfXs2sWHBLofuARKo6CH4jxwmBzN9Rh77M+y
        KFZzzGfJWXW/Qdk3bu59EY3VzftSxB7FjFroclIchQ==
X-Google-Smtp-Source: AGRyM1s0MqnD80CYxEr2lK9IvxFEYG/vi3Am7ZnmtVk6YJWfQ/VqVCGjeQpqkXoSL7sHEyiR5W9TioXepiFA50JNq2c=
X-Received: by 2002:a25:d957:0:b0:66c:9476:708f with SMTP id
 q84-20020a25d957000000b0066c9476708fmr11293785ybg.427.1656347172053; Mon, 27
 Jun 2022 09:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220623185730.25b88096@kernel.org> <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com> <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com> <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com> <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com>
In-Reply-To: <20220627144822.GA20878@shbuild999.sh.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 18:25:59 +0200
Message-ID: <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Feng Tang <feng.tang@intel.com>
Cc:     Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>,
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

On Mon, Jun 27, 2022 at 4:48 PM Feng Tang <feng.tang@intel.com> wrote:
>
> On Mon, Jun 27, 2022 at 04:07:55PM +0200, Eric Dumazet wrote:
> > On Mon, Jun 27, 2022 at 2:34 PM Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > On Mon, Jun 27, 2022 at 10:46:21AM +0200, Eric Dumazet wrote:
> > > > On Mon, Jun 27, 2022 at 4:38 AM Feng Tang <feng.tang@intel.com> wrote:
> > > [snip]
> > > > > > >
> > > > > > > Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> > > > > > > in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> > > > > > > sure that the netperf test has already run?
> > > > > >
> > > > > > memory.kmem.tcp.max_usage_in_bytes:0
> > > > >
> > > > > Sorry, I made a mistake that in the original report from Oliver, it
> > > > > was 'cgroup v2' with a 'debian-11.1' rootfs.
> > > > >
> > > > > When you asked about cgroup info, I tried the job on another tbox, and
> > > > > the original 'job.yaml' didn't work, so I kept the 'netperf' test
> > > > > parameters and started a new job which somehow run with a 'debian-10.4'
> > > > > rootfs and acutally run with cgroup v1.
> > > > >
> > > > > And as you mentioned cgroup version does make a big difference, that
> > > > > with v1, the regression is reduced to 1% ~ 5% on different generations
> > > > > of test platforms. Eric mentioned they also got regression report,
> > > > > but much smaller one, maybe it's due to the cgroup version?
> > > >
> > > > This was using the current net-next tree.
> > > > Used recipe was something like:
> > > >
> > > > Make sure cgroup2 is mounted or mount it by mount -t cgroup2 none $MOUNT_POINT.
> > > > Enable memory controller by echo +memory > $MOUNT_POINT/cgroup.subtree_control.
> > > > Create a cgroup by mkdir $MOUNT_POINT/job.
> > > > Jump into that cgroup by echo $$ > $MOUNT_POINT/job/cgroup.procs.
> > > >
> > > > <Launch tests>
> > > >
> > > > The regression was smaller than 1%, so considered noise compared to
> > > > the benefits of the bug fix.
> > >
> > > Yes, 1% is just around noise level for a microbenchmark.
> > >
> > > I went check the original test data of Oliver's report, the tests was
> > > run 6 rounds and the performance data is pretty stable (0Day's report
> > > will show any std deviation bigger than 2%)
> > >
> > > The test platform is a 4 sockets 72C/144T machine, and I run the
> > > same job (nr_tasks = 25% * nr_cpus) on one CascadeLake AP (4 nodes)
> > > and one Icelake 2 sockets platform, and saw 75% and 53% regresson on
> > > them.
> > >
> > > In the first email, there is a file named 'reproduce', it shows the
> > > basic test process:
> > >
> > > "
> > >   use 'performane' cpufre  governor for all CPUs
> > >
> > >   netserver -4 -D
> > >   modprobe sctp
> > >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> > >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> > >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> > >   (repeat 36 times in total)
> > >   ...
> > >
> > > "
> > >
> > > Which starts 36 (25% of nr_cpus) netperf clients. And the clients number
> > > also matters, I tried to increase the client number from 36 to 72(50%),
> > > and the regression is changed from 69.4% to 73.7%"
> > >
> >
> > This seems like a lot of opportunities for memcg folks :)
> >
> > struct page_counter has poor field placement [1], and no per-cpu cache.
> >
> > [1] "atomic_long_t usage" is sharing cache line with read mostly fields.
> >
> > (struct mem_cgroup also has poor field placement, mainly because of
> > struct page_counter)
> >
> >     28.69%  [kernel]       [k] copy_user_enhanced_fast_string
> >     16.13%  [kernel]       [k] intel_idle_irq
> >      6.46%  [kernel]       [k] page_counter_try_charge
> >      6.20%  [kernel]       [k] __sk_mem_reduce_allocated
> >      5.68%  [kernel]       [k] try_charge_memcg
> >      5.16%  [kernel]       [k] page_counter_cancel
>
> Yes, I also analyzed the perf-profile data, and made some layout changes
> which could recover the changes from 69% to 40%.
>
> 7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0
> ---------------- --------------------------- ---------------------------
>      15722           -69.5%       4792           -40.8%       9300        netperf.Throughput_Mbps
>
>
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 1bfcfb1af352..aa37bd39116c 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -179,14 +179,13 @@ struct cgroup_subsys_state {
>         atomic_t online_cnt;
>
>         /* percpu_ref killing and RCU release */
> -       struct work_struct destroy_work;
>         struct rcu_work destroy_rwork;
> -
> +       struct cgroup_subsys_state *parent;
> +       struct work_struct destroy_work;
>         /*
>          * PI: the parent css.  Placed here for cache proximity to following
>          * fields of the containing structure.
>          */
> -       struct cgroup_subsys_state *parent;
>  };
>
>  /*
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 9ecead1042b9..963b88ab9930 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -239,9 +239,6 @@ struct mem_cgroup {
>         /* Private memcg ID. Used to ID objects that outlive the cgroup */
>         struct mem_cgroup_id id;
>
> -       /* Accounted resources */
> -       struct page_counter memory;             /* Both v1 & v2 */
> -
>         union {
>                 struct page_counter swap;       /* v2 only */
>                 struct page_counter memsw;      /* v1 only */
> @@ -251,6 +248,9 @@ struct mem_cgroup {
>         struct page_counter kmem;               /* v1 only */
>         struct page_counter tcpmem;             /* v1 only */
>
> +       /* Accounted resources */
> +       struct page_counter memory;             /* Both v1 & v2 */
> +
>         /* Range enforcement for interrupt charges */
>         struct work_struct high_work;
>
> @@ -313,7 +313,6 @@ struct mem_cgroup {
>         atomic_long_t           memory_events[MEMCG_NR_MEMORY_EVENTS];
>         atomic_long_t           memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>
> -       unsigned long           socket_pressure;
>
>         /* Legacy tcp memory accounting */
>         bool                    tcpmem_active;
> @@ -349,6 +348,7 @@ struct mem_cgroup {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         struct deferred_split deferred_split_queue;
>  #endif
> +       unsigned long           socket_pressure;
>
>         struct mem_cgroup_per_node *nodeinfo[];
>  };
>

I simply did the following and got much better results.

But I am not sure if updates to ->usage are really needed that often...


diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 679591301994d316062f92b275efa2459a8349c9..e267be4ba849760117d9fd041e22c2a44658ab36
100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -3,12 +3,15 @@
 #define _LINUX_PAGE_COUNTER_H

 #include <linux/atomic.h>
+#include <linux/cache.h>
 #include <linux/kernel.h>
 #include <asm/page.h>

 struct page_counter {
-       atomic_long_t usage;
-       unsigned long min;
+       /* contended cache line. */
+       atomic_long_t usage ____cacheline_aligned_in_smp;
+
+       unsigned long min ____cacheline_aligned_in_smp;
        unsigned long low;
        unsigned long high;
        unsigned long max;
@@ -27,12 +30,6 @@ struct page_counter {
        unsigned long watermark;
        unsigned long failcnt;

-       /*
-        * 'parent' is placed here to be far from 'usage' to reduce
-        * cache false sharing, as 'usage' is written mostly while
-        * parent is frequently read for cgroup's hierarchical
-        * counting nature.
-        */
        struct page_counter *parent;
 };



> And some of these are specific for network and may not be a universal
> win, though I think the 'cgroup_subsys_state' could keep the
> read-mostly 'parent' away from following written-mostly counters.
>
> Btw, I tried your debug patch which compiled fail with 0Day's kbuild
> system, but it did compile ok on my local machine.
>
> Thanks,
> Feng
>
> >
> > > Thanks,
> > > Feng
> > >
> > > > >
> > > > > Thanks,
> > > > > Feng
