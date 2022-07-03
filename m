Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A055E5646C5
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiGCKoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGCKoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:44:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59C639E;
        Sun,  3 Jul 2022 03:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656845039; x=1688381039;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vTTAw9QKNXkaEQrbW3B9/sW65KKD9yPkaMxgTxRHzfs=;
  b=Ukh7hMR4R/XLx5q7QiUVXYlcTqMnxCuoVkyoyn2mrt7A4qu9tmBHNzp5
   TEgU2zwTOdsIYSV075ebgHRZahAnLQH5W2PJeFDaiBaaEcwyWfmUXoDLv
   Tc3egSQYCOO+vj6DERkODn0IXu7FD+WOt6X50dLuDUUpmSi4tcnyLoA3L
   o//zz+t6HBIMMfBR6rPB0ExchnUIRlOm20eyYIa57kNDC7WHTWfhrYu3/
   oCM/HRGbUYyXAldC/dSFKOdEQeUu/Z8VRY88VuZ40dQkvehrKz/pXgvq1
   bu6UYlDSYngF0NYHPUDSs+TlpBKUOMUlBR7JeZD6TtRL6gSZesanyGeRt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10396"; a="281693798"
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="281693798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 03:43:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="618916129"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga008.jf.intel.com with ESMTP; 03 Jul 2022 03:43:53 -0700
Date:   Sun, 3 Jul 2022 18:43:53 +0800
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
Message-ID: <20220703104353.GB62281@shbuild999.sh.intel.com>
References: <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com>
 <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com>
 <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com>
 <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
 <20220628034926.GA69004@shbuild999.sh.intel.com>
 <CALvZod71Fti8yLC08mdpDk-TLYJVyfVVauWSj1zk=BhN1-GPdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALvZod71Fti8yLC08mdpDk-TLYJVyfVVauWSj1zk=BhN1-GPdA@mail.gmail.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shakeel,

On Fri, Jul 01, 2022 at 08:47:29AM -0700, Shakeel Butt wrote:
> On Mon, Jun 27, 2022 at 8:49 PM Feng Tang <feng.tang@intel.com> wrote:
> > I just tested it, it does perform better (the 4th is with your patch),
> > some perf-profile data is also listed.
> >
> >  7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0 e719635902654380b23ffce908d
> > ---------------- --------------------------- --------------------------- ---------------------------
> >      15722           -69.5%       4792           -40.8%       9300           -27.9%      11341        netperf.Throughput_Mbps
> >
> >       0.00            +0.3        0.26 ±  5%      +0.5        0.51            +1.3        1.27 ±  2%pp.self.__sk_mem_raise_allocated
> >       0.00            +0.3        0.32 ± 15%      +1.7        1.74 ±  2%      +0.4        0.40 ±  2%  pp.self.propagate_protected_usage
> >       0.00            +0.8        0.82 ±  7%      +0.9        0.90            +0.8        0.84        pp.self.__mod_memcg_state
> >       0.00            +1.2        1.24 ±  4%      +1.0        1.01            +1.4        1.44        pp.self.try_charge_memcg
> >       0.00            +2.1        2.06            +2.1        2.13            +2.1        2.11        pp.self.page_counter_uncharge
> >       0.00            +2.1        2.14 ±  4%      +2.7        2.71            +2.6        2.60 ±  2%  pp.self.page_counter_try_charge
> >       1.12 ±  4%      +3.1        4.24            +1.1        2.22            +1.4        2.51        pp.self.native_queued_spin_lock_slowpath
> >       0.28 ±  9%      +3.8        4.06 ±  4%      +0.2        0.48            +0.4        0.68        pp.self.sctp_eat_data
> >       0.00            +8.2        8.23            +0.8        0.83            +1.3        1.26        pp.self.__sk_mem_reduce_allocated
> >
> > And the size of 'mem_cgroup' is increased from 4224 Bytes to 4608.
> 
> Hi Feng, can you please try two more configurations? Take Eric's patch
> of adding ____cacheline_aligned_in_smp in page_counter and for first
> increase MEMCG_CHARGE_BATCH to 64 and for second increase it to 128.
> Basically batch increases combined with Eric's patch.

With increasing batch to 128, the regression could be reduced to -12.4%.

Some more details with perf-profile data below:

7c80b038d23e1f4c 4890b686f4088c90432149bd6de  Eric's patch                 Eric's patch + batch-64   Eric's patch + batch-128
---------------- --------------------------- --------------------------- --------------------------- --------------------------- 
     15722           -69.5%       4792           -27.9%      11341           -14.0%      13521           -12.4%      13772        netperf.Throughput_Mbps
 
      0.05            +0.2        0.27 ± 18%      +0.0        0.08 ±  6%      -0.1        0.00            -0.0        0.03 ±100%  pp.self.timekeeping_max_deferment
      0.00            +0.3        0.26 ±  5%      +1.3        1.27 ±  2%      +1.8        1.82 ± 10%      +2.0        1.96 ±  9%  pp.self.__sk_mem_raise_allocated
      0.00            +0.3        0.32 ± 15%      +0.4        0.40 ±  2%      +0.1        0.10 ±  5%      +0.0        0.00        pp.self.propagate_protected_usage
      0.00            +0.8        0.82 ±  7%      +0.8        0.84            +0.5        0.48            +0.4        0.36 ±  2%  pp.self.__mod_memcg_state
      0.00            +1.2        1.24 ±  4%      +1.4        1.44            +0.4        0.40 ±  3%      +0.2        0.24 ±  6%  pp.self.try_charge_memcg
      0.00            +2.1        2.06            +2.1        2.11            +0.5        0.50            +0.2        0.18 ±  8%  pp.self.page_counter_uncharge
      0.00            +2.1        2.14 ±  4%      +2.6        2.60 ±  2%      +0.6        0.58            +0.2        0.20        pp.self.page_counter_try_charge
      1.12 ±  4%      +3.1        4.24            +1.4        2.51            +1.0        2.10 ±  2%      +1.0        2.10 ±  9%  pp.self.native_queued_spin_lock_slowpath
      0.28 ±  9%      +3.8        4.06 ±  4%      +0.4        0.68            +0.6        0.90 ±  9%      +0.7        1.00 ± 11%  pp.self.sctp_eat_data
      0.00            +8.2        8.23            +1.3        1.26            +1.7        1.72 ±  6%      +2.0        1.95 ± 10%  pp.self.__sk_mem_reduce_allocated
 
 Thanks,
 Feng
