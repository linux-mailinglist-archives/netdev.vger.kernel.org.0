Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D536955C57C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbiF0PZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbiF0PZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:25:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7993718B29;
        Mon, 27 Jun 2022 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656343532; x=1687879532;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xJP9OefAMxCTgdzZDCaOuKXFij4QIj41i5jxXMS1AdM=;
  b=f+F119vY0+Oa3b+eLjeAwSBqKVjPEWXrHqBv6amHvJPB4/H1Kn/2k3Zh
   hopZmpI/JyDcOMxE7OoyZdVNZFW5Bf9xiVO0BjTZP/m3d7l1zBd3dD0Z+
   fBLQj5Q/KmkEKaCKmb9mSHOMmE765RCvNQA1OIUsyhw7XPyZdrjIv0pB9
   eOPq3CBIsj0KypMKzc76MTyRfFNo2digNiMOiHI2+70WiJf1LOk1HXYf1
   gQ29WwDOaoaOu/B1PT/GvnkZuzmOpPlm24jTax0eS7qPUU8dkUgUvOAX2
   7tofhsMkbcEHKBhD1JW4kqgYl7m/L24q3k4LaTbSfrjN6nMSqrcReG/VU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279013691"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="279013691"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 08:13:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="766731304"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga005.jf.intel.com with ESMTP; 27 Jun 2022 08:12:58 -0700
Date:   Mon, 27 Jun 2022 23:12:58 +0800
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
Message-ID: <20220627151258.GB20878@shbuild999.sh.intel.com>
References: <20220623185730.25b88096@kernel.org>
 <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com>
 <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com>
 <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com>
 <CALvZod7i_=7bNZR-LAXBPXJFxj-1KBuYs+rmG0iABAE1T90BPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7i_=7bNZR-LAXBPXJFxj-1KBuYs+rmG0iABAE1T90BPg@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 07:52:55AM -0700, Shakeel Butt wrote:
> On Mon, Jun 27, 2022 at 5:34 AM Feng Tang <feng.tang@intel.com> wrote:
> > Yes, 1% is just around noise level for a microbenchmark.
> >
> > I went check the original test data of Oliver's report, the tests was
> > run 6 rounds and the performance data is pretty stable (0Day's report
> > will show any std deviation bigger than 2%)
> >
> > The test platform is a 4 sockets 72C/144T machine, and I run the
> > same job (nr_tasks = 25% * nr_cpus) on one CascadeLake AP (4 nodes)
> > and one Icelake 2 sockets platform, and saw 75% and 53% regresson on
> > them.
> >
> > In the first email, there is a file named 'reproduce', it shows the
> > basic test process:
> >
> > "
> >   use 'performane' cpufre  governor for all CPUs
> >
> >   netserver -4 -D
> >   modprobe sctp
> >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> >   netperf -4 -H 127.0.0.1 -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K  &
> >   (repeat 36 times in total)
> >   ...
> >
> > "
> >
> > Which starts 36 (25% of nr_cpus) netperf clients. And the clients number
> > also matters, I tried to increase the client number from 36 to 72(50%),
> > and the regression is changed from 69.4% to 73.7%
> >
> 
> Am I understanding correctly that this 69.4% (or 73.7%) regression is
> with cgroup v2?

Yes.

> Eric did the experiments on v2 but on real hardware where the
> performance impact was negligible.
> 
> BTW do you see similar regression for tcp as well or just sctp?

Yes, I run TCP_SENDFILE case with 'send_size'==10K, it hits a
70%+ regressioin. 

Thanks,
Feng
