Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C80355DC37
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiF0MeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiF0MeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:34:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409ECBC90;
        Mon, 27 Jun 2022 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656333261; x=1687869261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3cZhrIXL/31n4yULxyK6MSoWTderF7rYg/64LrImcrE=;
  b=l8Ek+mVAIYB77pTxT3xHwJOrlKPN4ZrqO6g4PMZfW3yWZ5dhKW5aRNrY
   AuhGC9X5i6JisqKxIoQ0kQc1CvRomRcPKcXgpNFdODLhM4x/t5KFa4+Lj
   FY2ne7/Fbikw+Jwxuxy1H2NrO96+0BxVvPKwEo9oaDo0b0jzoiGMey4s6
   zkouTkaHzUMtQB+/b0Kn72CxPzHEmTbkmFqIqq6sNtPdceuoin1DUqPWv
   TQpOx9K40n0LvlTp5/Nx31mfU0i7SD37c4I34adDkn1I/qhJPa+oTjfhX
   afsyuaEFkl0fEW/+og9+h9I7aHp5h9FiWeOevMVIVQ6H2nZFN0Cjsdn1u
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="367753998"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="367753998"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 05:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="679565746"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2022 05:34:16 -0700
Date:   Mon, 27 Jun 2022 20:34:15 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Eric Dumazet <edumazet@google.com>
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
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
Message-ID: <20220627123415.GA32052@shbuild999.sh.intel.com>
References: <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org>
 <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com>
 <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com>
 <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:46:21AM +0200, Eric Dumazet wrote:
> On Mon, Jun 27, 2022 at 4:38 AM Feng Tang <feng.tang@intel.com> wrote:
[snip]
> > > >
> > > > Thanks Feng. Can you check the value of memory.kmem.tcp.max_usage_in_bytes
> > > > in /sys/fs/cgroup/memory/system.slice/lkp-bootstrap.service after making
> > > > sure that the netperf test has already run?
> > >
> > > memory.kmem.tcp.max_usage_in_bytes:0
> >
> > Sorry, I made a mistake that in the original report from Oliver, it
> > was 'cgroup v2' with a 'debian-11.1' rootfs.
> >
> > When you asked about cgroup info, I tried the job on another tbox, and
> > the original 'job.yaml' didn't work, so I kept the 'netperf' test
> > parameters and started a new job which somehow run with a 'debian-10.4'
> > rootfs and acutally run with cgroup v1.
> >
> > And as you mentioned cgroup version does make a big difference, that
> > with v1, the regression is reduced to 1% ~ 5% on different generations
> > of test platforms. Eric mentioned they also got regression report,
> > but much smaller one, maybe it's due to the cgroup version?
> 
> This was using the current net-next tree.
> Used recipe was something like:
> 
> Make sure cgroup2 is mounted or mount it by mount -t cgroup2 none $MOUNT_POINT.
> Enable memory controller by echo +memory > $MOUNT_POINT/cgroup.subtree_control.
> Create a cgroup by mkdir $MOUNT_POINT/job.
> Jump into that cgroup by echo $$ > $MOUNT_POINT/job/cgroup.procs.
> 
> <Launch tests>
> 
> The regression was smaller than 1%, so considered noise compared to
> the benefits of the bug fix.
 
Yes, 1% is just around noise level for a microbenchmark.

I went check the original test data of Oliver's report, the tests was
run 6 rounds and the performance data is pretty stable (0Day's report
will show any std deviation bigger than 2%)

The test platform is a 4 sockets 72C/144T machine, and I run the
same job (nr_tasks = 25% * nr_cpus) on one CascadeLake AP (4 nodes)
and one Icelake 2 sockets platform, and saw 75% and 53% regresson on
them.

In the first email, there is a file named 'reproduce', it shows the
basic test process:

"
  use 'performane' cpufre  governor for all CPUs

  netserver -4 -D
  modprobe sctp
  netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
  netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
  netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
  (repeat 36 times in total) 
  ...

"

Which starts 36 (25% of nr_cpus) netperf clients. And the clients number
also matters, I tried to increase the client number from 36 to 72(50%),
and the regression is changed from 69.4% to 73.7%

Thanks,
Feng

> >
> > Thanks,
> > Feng
