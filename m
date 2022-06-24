Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA55593F2
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiFXHH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiFXHHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:07:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45746808E;
        Fri, 24 Jun 2022 00:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656054444; x=1687590444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I94Jl9kETqNl2DSK3suPqG7/Oh9kRDrmgsP9ccLnRJ8=;
  b=NHwn0VA1SCb+2v7HJs8W8ycTWM4+TfCn4rOvjdR2sCT8JjQf00WlVXlf
   oZeGWxe1CczlbFZjZxl14W7ciPKPN3z3GqQMwnJuwQKXSIyk2dGI31cmX
   0oEPONk8waBaIUHoKt5sXhDSll0ccOaUzNJONqobx9TJQ2Fnx6oT2B7OP
   P2ANCVOdX7U8bOsx/rAgQqDM3KDMH3XEODtNcxoKt2UMr1bpv296YL/GU
   /DjW+WxNe+C9iGjlzmC/ofgyPK0akwFLqwBp6xfnOwSKzf7tDWNrk4/ww
   uu5MkUM9KCfxhxBl8ormCnxGeNUVrQoKWtnfQWqaTEHzwliaIl0y5G7P8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="261366468"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="261366468"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 00:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="691408221"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jun 2022 00:06:56 -0700
Date:   Fri, 24 Jun 2022 15:06:56 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Shakeel Butt <shakeelb@google.com>
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
Message-ID: <20220624070656.GE79500@shbuild999.sh.intel.com>
References: <20220619150456.GB34471@xsang-OptiPlex-9020>
 <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org>
 <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 11:34:15PM -0700, Shakeel Butt wrote:
> CCing memcg folks.
> 
> The thread starts at
> https://lore.kernel.org/all/20220619150456.GB34471@xsang-OptiPlex-9020/
> 
> On Thu, Jun 23, 2022 at 9:14 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 3:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 23 Jun 2022 18:50:07 -0400 Xin Long wrote:
> > > > From the perf data, we can see __sk_mem_reduce_allocated() is the one
> > > > using CPU the most more than before, and mem_cgroup APIs are also
> > > > called in this function. It means the mem cgroup must be enabled in
> > > > the test env, which may explain why I couldn't reproduce it.
> > > >
> > > > The Commit 4890b686f4 ("net: keep sk->sk_forward_alloc as small as
> > > > possible") uses sk_mem_reclaim(checking reclaimable >= PAGE_SIZE) to
> > > > reclaim the memory, which is *more frequent* to call
> > > > __sk_mem_reduce_allocated() than before (checking reclaimable >=
> > > > SK_RECLAIM_THRESHOLD). It might be cheap when
> > > > mem_cgroup_sockets_enabled is false, but I'm not sure if it's still
> > > > cheap when mem_cgroup_sockets_enabled is true.
> > > >
> > > > I think SCTP netperf could trigger this, as the CPU is the bottleneck
> > > > for SCTP netperf testing, which is more sensitive to the extra
> > > > function calls than TCP.
> > > >
> > > > Can we re-run this testing without mem cgroup enabled?
> > >
> > > FWIW I defer to Eric, thanks a lot for double checking the report
> > > and digging in!
> >
> > I did tests with TCP + memcg and noticed a very small additional cost
> > in memcg functions,
> > because of suboptimal layout:
> >
> > Extract of an internal Google bug, update from June 9th:
> >
> > --------------------------------
> > I have noticed a minor false sharing to fetch (struct
> > mem_cgroup)->css.parent, at offset 0xc0,
> > because it shares the cache line containing struct mem_cgroup.memory,
> > at offset 0xd0
> >
> > Ideally, memcg->socket_pressure and memcg->parent should sit in a read
> > mostly cache line.
> > -----------------------
> >
> > But nothing that could explain a "-69.4% regression"
> >
> > memcg has a very similar strategy of per-cpu reserves, with
> > MEMCG_CHARGE_BATCH being 32 pages per cpu.
> >
> > It is not clear why SCTP with 10K writes would overflow this reserve constantly.
> >
> > Presumably memcg experts will have to rework structure alignments to
> > make sure they can cope better
> > with more charge/uncharge operations, because we are not going back to
> > gigantic per-socket reserves,
> > this simply does not scale.
> 
> Yes I agree. As you pointed out there are fields which are mostly
> read-only but sharing cache lines with fields which get updated and
> definitely need work.
> 
> However can we first confirm if memcg charging is really the issue
> here as I remember these intel lkp tests are configured to run in root
> memcg and the kernel does not associate root memcg to any socket (see
> mem_cgroup_sk_alloc()).
> 
> If these tests are running in non-root memcg, is this cgroup v1 or v2?
> The memory counter and the 32 pages per cpu stock are only used on v2.
> For v1, there is no per-cpu stock and there is a separate tcpmem page
> counter and on v1 the network memory accounting has to be enabled
> explicitly i.e. not enabled by default.
> 
> There is definite possibility of slowdown on v1 but let's first
> confirm the memcg setup used for this testing environment.
> 
> Feng, can you please explain the memcg setup on these test machines
> and if the tests are run in root or non-root memcg?

I don't know the exact setup, Philip/Oliver from 0Day can correct me.

I logged into a test box which runs netperf test, and it seems to be
cgoup v1 and non-root memcg. The netperf tasks all sit in dir:
'/sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service'

And the rootfs is a debian based rootfs

Thanks,
Feng


> thanks,
> Shakeel
