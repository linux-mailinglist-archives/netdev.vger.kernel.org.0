Return-Path: <netdev+bounces-11661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BECF7733D5B
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB2DC1C210C7
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CF5652;
	Sat, 17 Jun 2023 00:56:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC39637
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:56:07 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182083AAF
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686963365; x=1718499365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NC34Xt1Ps0wgxir38XPM++lYlRAx4kIA1Xg6FyjHaag=;
  b=Wyb0CtGPfXOciB+N+Wt/d8/wS/Uv9y3LA+3VJgSst1K3NoNwzWbE7BkR
   +VD8CCZ1Scw6GmrbouB4KMdbtLNKvsS5S2uXdUTsSszyFhV9TufOHtpbw
   drcw7IogscfYcTFW1SM6MLVT/0bDG3qA4uTJFVP8em2zHE/jaNuPZHsZT
   w15XfJkO3xVF6PVXU6LPl5o7NMYULJRvPBNzpNTKqzeXxw8Pwv3JCGrYO
   BPlJEJrhagYm6lWtGUiJzp0pRln+fmPa402KXhVVBvNU0uUZu6zReQMxa
   wuX8TNVUtTyZUNI60sznE2ZNUgGeVdT3B5Hj+h96g2iJa7l+gRf1k3nr8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="356836641"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="356836641"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 17:56:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="825940910"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="825940910"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jun 2023 17:56:02 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qAKEU-00020e-01;
	Sat, 17 Jun 2023 00:56:02 +0000
Date: Sat, 17 Jun 2023 08:55:46 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dqs: add NIC stall detector based on BQL
Message-ID: <202306170803.0prwmKyK-lkp@intel.com>
References: <20230616213236.2379935-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616213236.2379935-1-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-dqs-add-NIC-stall-detector-based-on-BQL/20230617-053320
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230616213236.2379935-1-kuba%40kernel.org
patch subject: [PATCH net-next] net: dqs: add NIC stall detector based on BQL
config: arm-randconfig-r025-20230616 (https://download.01.org/0day-ci/archive/20230617/202306170803.0prwmKyK-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce: (https://download.01.org/0day-ci/archive/20230617/202306170803.0prwmKyK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306170803.0prwmKyK-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/dynamic_queue_limits.c:18:6: warning: no previous prototype for function 'dql_check_stall' [-Wmissing-prototypes]
   void dql_check_stall(struct dql *dql)
        ^
   lib/dynamic_queue_limits.c:18:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void dql_check_stall(struct dql *dql)
   ^
   static 
   1 warning generated.


vim +/dql_check_stall +18 lib/dynamic_queue_limits.c

    17	
  > 18	void dql_check_stall(struct dql *dql)
    19	{
    20		unsigned long stall_thrs, now;
    21	
    22		/* If we detect a stall see if anything was queued */
    23		stall_thrs = READ_ONCE(dql->stall_thrs);
    24		if (!stall_thrs)
    25			return;
    26	
    27		now = jiffies;
    28		if (time_after_eq(now, dql->last_reap + stall_thrs)) {
    29			unsigned long hist_head, t, start, end;
    30	
    31			/* We are trying to detect a period of at least @stall_thrs
    32			 * jiffies without any Tx completions, but during first half
    33			 * of which some Tx was posted.
    34			 */
    35	dqs_again:
    36			hist_head = READ_ONCE(dql->history_head);
    37			smp_rmb();
    38			/* oldest sample since last reap */
    39			start = (hist_head - DQL_HIST_LEN + 1) * BITS_PER_LONG;
    40			if (time_before(start, dql->last_reap + 1))
    41				start = dql->last_reap + 1;
    42			/* newest sample we should have already seen a completion for */
    43			end = hist_head * BITS_PER_LONG + (BITS_PER_LONG - 1);
    44			if (time_before(now, end + stall_thrs / 2))
    45				end = now - stall_thrs / 2;
    46	
    47			for (t = start; time_before_eq(t, end); t++)
    48				if (test_bit(t % (DQL_HIST_LEN * BITS_PER_LONG),
    49					     dql->history))
    50					break;
    51			if (!time_before_eq(t, end))
    52				goto no_stall;
    53			if (hist_head != READ_ONCE(dql->history_head))
    54				goto dqs_again;
    55	
    56			dql->stall_cnt++;
    57			dql->stall_max = max_t(unsigned int, dql->stall_max, now - t);
    58	
    59			trace_dql_stall_detected(dql->stall_thrs, now - t,
    60						 dql->last_reap, dql->history_head,
    61						 now, dql->history);
    62		}
    63	no_stall:
    64		dql->last_reap = now;
    65	}
    66	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

