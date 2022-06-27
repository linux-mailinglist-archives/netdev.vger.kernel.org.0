Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D416F55B548
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 04:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiF0CiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 22:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiF0CiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 22:38:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D0E2DC3;
        Sun, 26 Jun 2022 19:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656297498; x=1687833498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vqAGO4WsqTcOAwT6UqFx9w0d7monXGB2WJM15gkxapM=;
  b=K5yHD85c2gy4fP3ooX36HshSVRTkjIeIUuTcWSC3zq6rt0xQeRtpOyvt
   3kipBQbA78Cbj2sdOakHd8pWZ+6MxWg15ePknogw59dSemxvyZy8xZJ7D
   Grv38keWv6B5ZEkOHh9gDHnBY+47XkAFwNRJ8tGodyMRTK7pFgVRORU9G
   4+uY5FIzwMUFFpfFV2IRNUgPsszGG5PjOhnc2Y9a0FL46bJ7+CcBI6JX0
   k7Y4EDCFrvP/H6uLOWYMkQlbhIOKBod9deVtw0GbG8CQcyady74bCzoFA
   3HH/cZGicV5BZAiq5L56Mf3zpk+c87Vo6c4o2jZDeaN6DipjO+Y6qJa+j
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="264381695"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="264381695"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 19:38:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="646203825"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jun 2022 19:38:13 -0700
Date:   Mon, 27 Jun 2022 10:38:12 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Linux MM <linux-mm@kvack.org>,
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
Message-ID: <20220627023812.GA29314@shbuild999.sh.intel.com>
References: <20220619150456.GB34471@xsang-OptiPlex-9020>
 <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org>
 <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com>
 <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625023642.GA40868@shbuild999.sh.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 10:36:42AM +0800, Feng Tang wrote:
> On Fri, Jun 24, 2022 at 02:43:58PM +0000, Shakeel Butt wrote:
> > On Fri, Jun 24, 2022 at 03:06:56PM +0800, Feng Tang wrote:
> > > On Thu, Jun 23, 2022 at 11:34:15PM -0700, Shakeel Butt wrote:
> > [...]
> > > > 
> > > > Feng, can you please explain the memcg setup on these test machines
> > > > and if the tests are run in root or non-root memcg?
> > > 
> > > I don't know the exact setup, Philip/Oliver from 0Day can correct me.
> > > 
> > > I logged into a test box which runs netperf test, and it seems to be
> > > cgoup v1 and non-root memcg. The netperf tasks all sit in dir:
> > > '/sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service'
> > > 
> > 
> > Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> > in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> > sure that the netperf test has already run?
> 
> memory.kmem.tcp.max_usage_in_bytes:0
 
Sorry, I made a mistake that in the original report from Oliver, it
was 'cgroup v2' with a 'debian-11.1' rootfs. 

When you asked about cgroup info, I tried the job on another tbox, and
the original 'job.yaml' didn't work, so I kept the 'netperf' test
parameters and started a new job which somehow run with a 'debian-10.4'
rootfs and acutally run with cgroup v1. 

And as you mentioned cgroup version does make a big difference, that
with v1, the regression is reduced to 1% ~ 5% on different generations
of test platforms. Eric mentioned they also got regression report,
but much smaller one, maybe it's due to the cgroup version?

Thanks,
Feng

> And here is more memcg stats (let me know if you want to check more)
> 
> > If this is non-zero then network memory accounting is enabled and the
> > slowdown is expected.
> 
> >From the perf-profile data in original report, both
> __sk_mem_raise_allocated() and __sk_mem_reduce_allocated() are called
> much more often, which call memcg charge/uncharge functions.
> 
> IIUC, the call chain is:
> 
> __sk_mem_raise_allocated
>     sk_memory_allocated_add
>     mem_cgroup_charge_skmem
>         charge memcg->tcpmem (for cgroup v2)
> 	try_charge memcg (for v1)
> 
> Also from Eric's one earlier commit log:
> 
> "
> net: implement per-cpu reserves for memory_allocated
> ...
> This means we are going to call sk_memory_allocated_add()
> and sk_memory_allocated_sub() more often.
> ...
> "
> 
> So this slowdown is related to the more calling of charge/uncharge? 
> 
> Thanks,
> Feng
> 
> > > And the rootfs is a debian based rootfs
> > > 
> > > Thanks,
> > > Feng
> > > 
> > > 
> > > > thanks,
> > > > Shakeel
