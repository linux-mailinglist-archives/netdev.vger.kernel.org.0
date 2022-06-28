Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F90355E218
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiF1Dtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 23:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243577AbiF1Dte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 23:49:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399AC20BED;
        Mon, 27 Jun 2022 20:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656388173; x=1687924173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JCJ3t15hN0kX/PrCxPVD3oswwqwAU6aCjICQKC2sqZE=;
  b=l5N3Q/+iOgc6ZujH8OeWhX+z7eZZX9M6KmVGgHRpS4oyB/c1VZfUYoL6
   hCzyTKYKqFEoRpWOQHTpqJe2ZvtOYDEPd2HDng8aHF01KRZe9w1kimA3Y
   felQVH7z9egx7WHAbSDQi1wZiID6ef9vWyp8GYoRqgS5RnkqtGciyBoo4
   Ct89J93MfFMfQWxbWW0qffJRzWgNDQvk0ffhkus0tzWpMB2HwLTajiXLw
   Kd41XDT5uoUvCnDpa42Z/KuGZZ+tKhSOEChTjDC7Q7LtTFbYO3GS6/4qH
   zUXFezg/F9+pr9DUa8oH+fen71mJ7bs4g8tjoRPwIFVsC9Ttk6RRGeRnQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="280385326"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="280385326"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:49:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="564924431"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga006.jf.intel.com with ESMTP; 27 Jun 2022 20:49:27 -0700
Date:   Tue, 28 Jun 2022 11:49:26 +0800
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
Message-ID: <20220628034926.GA69004@shbuild999.sh.intel.com>
References: <CALvZod7kULCvHAuk53FE-XBOi4-BbLdY3HCg6jfCZTJDxYsZow@mail.gmail.com>
 <20220624070656.GE79500@shbuild999.sh.intel.com>
 <20220624144358.lqt2ffjdry6p5u4d@google.com>
 <20220625023642.GA40868@shbuild999.sh.intel.com>
 <20220627023812.GA29314@shbuild999.sh.intel.com>
 <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com>
 <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com>
 <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 06:25:59PM +0200, Eric Dumazet wrote:
> On Mon, Jun 27, 2022 at 4:48 PM Feng Tang <feng.tang@intel.com> wrote:
> >
> > Yes, I also analyzed the perf-profile data, and made some layout changes
> > which could recover the changes from 69% to 40%.
> >
> > 7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0
> > ---------------- --------------------------- ---------------------------
> >      15722           -69.5%       4792           -40.8%       9300        netperf.Throughput_Mbps
> >
> 
> I simply did the following and got much better results.
> 
> But I am not sure if updates to ->usage are really needed that often...
> 
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994d316062f92b275efa2459a8349c9..e267be4ba849760117d9fd041e22c2a44658ab36
> 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,12 +3,15 @@
>  #define _LINUX_PAGE_COUNTER_H
> 
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
> 
>  struct page_counter {
> -       atomic_long_t usage;
> -       unsigned long min;
> +       /* contended cache line. */
> +       atomic_long_t usage ____cacheline_aligned_in_smp;
> +
> +       unsigned long min ____cacheline_aligned_in_smp;
>         unsigned long low;
>         unsigned long high;
>         unsigned long max;
> @@ -27,12 +30,6 @@ struct page_counter {
>         unsigned long watermark;
>         unsigned long failcnt;
> 
> -       /*
> -        * 'parent' is placed here to be far from 'usage' to reduce
> -        * cache false sharing, as 'usage' is written mostly while
> -        * parent is frequently read for cgroup's hierarchical
> -        * counting nature.
> -        */
>         struct page_counter *parent;
>  };

I just tested it, it does perform better (the 4th is with your patch),
some perf-profile data is also listed.

 7c80b038d23e1f4c 4890b686f4088c90432149bd6de 332b589c49656a45881bca4ecc0 e719635902654380b23ffce908d 
---------------- --------------------------- --------------------------- --------------------------- 
     15722           -69.5%       4792           -40.8%       9300           -27.9%      11341        netperf.Throughput_Mbps

      0.00            +0.3        0.26 ±  5%      +0.5        0.51            +1.3        1.27 ±  2%pp.self.__sk_mem_raise_allocated
      0.00            +0.3        0.32 ± 15%      +1.7        1.74 ±  2%      +0.4        0.40 ±  2%  pp.self.propagate_protected_usage
      0.00            +0.8        0.82 ±  7%      +0.9        0.90            +0.8        0.84        pp.self.__mod_memcg_state
      0.00            +1.2        1.24 ±  4%      +1.0        1.01            +1.4        1.44        pp.self.try_charge_memcg
      0.00            +2.1        2.06            +2.1        2.13            +2.1        2.11        pp.self.page_counter_uncharge
      0.00            +2.1        2.14 ±  4%      +2.7        2.71            +2.6        2.60 ±  2%  pp.self.page_counter_try_charge
      1.12 ±  4%      +3.1        4.24            +1.1        2.22            +1.4        2.51        pp.self.native_queued_spin_lock_slowpath
      0.28 ±  9%      +3.8        4.06 ±  4%      +0.2        0.48            +0.4        0.68        pp.self.sctp_eat_data
      0.00            +8.2        8.23            +0.8        0.83            +1.3        1.26        pp.self.__sk_mem_reduce_allocated

And the size of 'mem_cgroup' is increased from 4224 Bytes to 4608.

Another info is the perf hotspos are slightly different between
tcp and sctp test cases.

Thanks,
Feng
