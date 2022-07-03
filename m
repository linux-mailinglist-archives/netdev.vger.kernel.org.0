Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE98564A69
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 00:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiGCWzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGCWzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 18:55:42 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2652ADF;
        Sun,  3 Jul 2022 15:55:41 -0700 (PDT)
Date:   Sun, 3 Jul 2022 15:55:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656888940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UsoL24ELETfF3MSNiDW9I/K0Flpmei9riTSH6+si7ig=;
        b=iUInCXasIip4wHrtoL/0lzsYtRCZFSsRqfLRPjoYwSOtiqscSWuPjZHfbG97LiaP3BzDIe
        0ZXrzFwfVL/E2wq4AmYs4coUwxW0GVnJ6RLTvBjOWag7XFKXgSSe9R92erWjn2FlZkzP5K
        kLcNL3GRn8tg7m+p4Hc6FjL36mprR04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Feng Tang <feng.tang@intel.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <YsIeYzEuj95PWMWO@castle>
References: <20220625023642.GA40868@shbuild999.sh.intel.com>
 <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com>
 <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com>
 <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
 <20220628034926.GA69004@shbuild999.sh.intel.com>
 <CALvZod71Fti8yLC08mdpDk-TLYJVyfVVauWSj1zk=BhN1-GPdA@mail.gmail.com>
 <20220703104353.GB62281@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220703104353.GB62281@shbuild999.sh.intel.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 06:43:53PM +0800, Feng Tang wrote:
> Hi Shakeel,
> 
> On Fri, Jul 01, 2022 at 08:47:29AM -0700, Shakeel Butt wrote:
> > On Mon, Jun 27, 2022 at 8:49 PM Feng Tang <feng.tang@intel.com> wrote:
> > > I just tested it, it does perform better (the 4th is with your patch),
> > > some perf-profile data is also listed.
> > >
> > >  7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0 e719635902654380b23ffce908d
> > > ---------------- --------------------------- --------------------------- ---------------------------
> > >      15722           -69.5%       4792           -40.8%       9300           -27.9%      11341        netperf.Throughput_Mbps
> > >
> > >       0.00            +0.3        0.26 ±  5%      +0.5        0.51            +1.3        1.27 ±  2%pp.self.__sk_mem_raise_allocated
> > >       0.00            +0.3        0.32 ± 15%      +1.7        1.74 ±  2%      +0.4        0.40 ±  2%  pp.self.propagate_protected_usage
> > >       0.00            +0.8        0.82 ±  7%      +0.9        0.90            +0.8        0.84        pp.self.__mod_memcg_state
> > >       0.00            +1.2        1.24 ±  4%      +1.0        1.01            +1.4        1.44        pp.self.try_charge_memcg
> > >       0.00            +2.1        2.06            +2.1        2.13            +2.1        2.11        pp.self.page_counter_uncharge
> > >       0.00            +2.1        2.14 ±  4%      +2.7        2.71            +2.6        2.60 ±  2%  pp.self.page_counter_try_charge
> > >       1.12 ±  4%      +3.1        4.24            +1.1        2.22            +1.4        2.51        pp.self.native_queued_spin_lock_slowpath
> > >       0.28 ±  9%      +3.8        4.06 ±  4%      +0.2        0.48            +0.4        0.68        pp.self.sctp_eat_data
> > >       0.00            +8.2        8.23            +0.8        0.83            +1.3        1.26        pp.self.__sk_mem_reduce_allocated
> > >
> > > And the size of 'mem_cgroup' is increased from 4224 Bytes to 4608.
> > 
> > Hi Feng, can you please try two more configurations? Take Eric's patch
> > of adding ____cacheline_aligned_in_smp in page_counter and for first
> > increase MEMCG_CHARGE_BATCH to 64 and for second increase it to 128.
> > Basically batch increases combined with Eric's patch.
> 
> With increasing batch to 128, the regression could be reduced to -12.4%.

If we're going to bump it, I wonder if we should scale it dynamically depending
on the size of the memory cgroup?

Thanks!
