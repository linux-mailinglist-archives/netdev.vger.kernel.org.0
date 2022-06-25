Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F555A632
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiFYCgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiFYCgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:36:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D634B4FC6F;
        Fri, 24 Jun 2022 19:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656124607; x=1687660607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7UU7ei0p3fZSOJ/8dN+UbHzSxDz0FQ0Q5dZSwXjI5YY=;
  b=enZXhQdXu0gU926aT9UgsQGLe8rA0saF+NEhAHXPTheuT0nE504NBs5x
   QsJQKKNvAn0D2yP7U/ZKJwvwD6rd+Qkemw7rrt0Niu/sf8KSBn8NC06/X
   FNS+rjb6JFyQ0MFpwSEYa4XCB6lzemG/RobASaJGQtc5EdFCRGzHMNUH/
   ePlTNsJK5aLMbtVyx9bpzcX+yj40vFdHmD0onAVigxKHP0swqWGoIVPJh
   WD2LTUI4UUqh5ED/RyYbBC8/rYkoK/8RnXbPSP6zi+y3kJ5nCM3HrFPhW
   kR5ukeMtbMBko3nQEzHSpxig2VIVJDla217BDACSKe22wPZZItpMFZR2L
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="261557120"
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="261557120"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 19:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,221,1650956400"; 
   d="scan'208";a="678785905"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jun 2022 19:36:42 -0700
Date:   Sat, 25 Jun 2022 10:36:42 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>,
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
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
Message-ID: <20220625023642.GA40868@shbuild999.sh.intel.com>
References: <20220619150456.GB34471@xsang-OptiPlex-9020>
 <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org>
 <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com>
 <20220624144358.lqt2ffjdry6p5u4d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624144358.lqt2ffjdry6p5u4d@google.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:43:58PM +0000, Shakeel Butt wrote:
> On Fri, Jun 24, 2022 at 03:06:56PM +0800, Feng Tang wrote:
> > On Thu, Jun 23, 2022 at 11:34:15PM -0700, Shakeel Butt wrote:
> [...]
> > > 
> > > Feng, can you please explain the memcg setup on these test machines
> > > and if the tests are run in root or non-root memcg?
> > 
> > I don't know the exact setup, Philip/Oliver from 0Day can correct me.
> > 
> > I logged into a test box which runs netperf test, and it seems to be
> > cgoup v1 and non-root memcg. The netperf tasks all sit in dir:
> > '/sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service'
> > 
> 
> Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> sure that the netperf test has already run?

memory.kmem.tcp.max_usage_in_bytes:0

And here is more memcg stats (let me know if you want to check more)

/sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service# grep . memory.*
memory.failcnt:0
memory.kmem.failcnt:0
memory.kmem.limit_in_bytes:9223372036854771712
memory.kmem.max_usage_in_bytes:47861760
memory.kmem.tcp.failcnt:0
memory.kmem.tcp.limit_in_bytes:9223372036854771712
memory.kmem.tcp.max_usage_in_bytes:0
memory.kmem.tcp.usage_in_bytes:0
memory.kmem.usage_in_bytes:40730624
memory.limit_in_bytes:9223372036854771712
memory.max_usage_in_bytes:642424832
memory.memsw.failcnt:0
memory.memsw.limit_in_bytes:9223372036854771712
memory.memsw.max_usage_in_bytes:642424832
memory.memsw.usage_in_bytes:639549440
memory.move_charge_at_immigrate:0
memory.numa_stat:total=144073 N0=124819 N1=19254
memory.numa_stat:file=0 N0=0 N1=0
memory.numa_stat:anon=77721 N0=58502 N1=19219
memory.numa_stat:unevictable=66352 N0=66317 N1=35
memory.numa_stat:hierarchical_total=144073 N0=124819 N1=19254
memory.numa_stat:hierarchical_file=0 N0=0 N1=0
memory.numa_stat:hierarchical_anon=77721 N0=58502 N1=19219
memory.numa_stat:hierarchical_unevictable=66352 N0=66317 N1=35
memory.oom_control:oom_kill_disable 0
memory.oom_control:under_oom 0
memory.oom_control:oom_kill 0
grep: memory.pressure_level: Invalid argument
memory.soft_limit_in_bytes:9223372036854771712
memory.stat:cache 282562560
memory.stat:rss 307884032
memory.stat:rss_huge 239075328
memory.stat:shmem 10784768
memory.stat:mapped_file 3444736
memory.stat:dirty 0
memory.stat:writeback 0
memory.stat:swap 0
memory.stat:pgpgin 1018918
memory.stat:pgpgout 932902
memory.stat:pgfault 2130513
memory.stat:pgmajfault 0
memory.stat:inactive_anon 310272000
memory.stat:active_anon 8073216
memory.stat:inactive_file 0
memory.stat:active_file 0
memory.stat:unevictable 271777792
memory.stat:hierarchical_memory_limit 9223372036854771712
memory.stat:hierarchical_memsw_limit 9223372036854771712
memory.stat:total_cache 282562560
memory.stat:total_rss 307884032
memory.stat:total_rss_huge 239075328
memory.stat:total_shmem 10784768
memory.stat:total_mapped_file 3444736
memory.stat:total_dirty 0
memory.stat:total_writeback 0
memory.stat:total_swap 0
memory.stat:total_pgpgin 1018918
memory.stat:total_pgpgout 932902
memory.stat:total_pgfault 2130513
memory.stat:total_pgmajfault 0
memory.stat:total_inactive_anon 310272000
memory.stat:total_active_anon 8073216
memory.stat:total_inactive_file 0
memory.stat:total_active_file 0
memory.stat:total_unevictable 271777792
memory.swappiness:60
memory.usage_in_bytes:639549440
memory.use_hierarchy:1

> If this is non-zero then network memory accounting is enabled and the
> slowdown is expected.

From the perf-profile data in original report, both
__sk_mem_raise_allocated() and __sk_mem_reduce_allocated() are called
much more often, which call memcg charge/uncharge functions.

IIUC, the call chain is:

__sk_mem_raise_allocated
    sk_memory_allocated_add
    mem_cgroup_charge_skmem
        charge memcg->tcpmem (for cgroup v2)
	try_charge memcg (for v1)

Also from Eric's one earlier commit log:

"
net: implement per-cpu reserves for memory_allocated
...
This means we are going to call sk_memory_allocated_add()
and sk_memory_allocated_sub() more often.
...
"

So this slowdown is related to the more calling of charge/uncharge? 

Thanks,
Feng

> > And the rootfs is a debian based rootfs
> > 
> > Thanks,
> > Feng
> > 
> > 
> > > thanks,
> > > Shakeel
