Return-Path: <netdev+bounces-9336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0D67288A0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF12D1C21061
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0DC1F191;
	Thu,  8 Jun 2023 19:33:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4211EA64
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:33:47 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773FC18C;
	Thu,  8 Jun 2023 12:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686252825; x=1717788825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F+OxDi++6B6OT7qYKbXPAOLDtvQSIYmKdr7y1Cz75FI=;
  b=Nq9TDjJQNtCinP5XbULtlGexzuZMXiuZ+rmE2lfeLAffNoHDgTzjmyus
   psg8JdCF9XUpV1mOG/fn0ezt2IhhOl6lhyGYxfkq7s7xkFL9q4GdLL8LE
   MxOMw4CufvzguLExcVwJE8Eb9DoFUja8NnTCQvVXvJuWKykx6HslkFY5Z
   hr72UOGA4K2Us9uXazY3J8Jtd2dKNP0uAsKP0pL7I06hepSgqmCqIToOC
   US3TIcfFYjQZDl4ThbQg0ZTehLNS/LThijbc9HuZpManNBHmCNKfS7hXC
   uBS0V+pONJOnZ5zzYj+Vm1Wj9ggB5/ze4yhoqIFalp1g2PXNDKe4Cyhwz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="420998008"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="420998008"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 12:33:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="854468968"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="854468968"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jun 2023 12:33:42 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q7LO9-0008CA-1w;
	Thu, 08 Jun 2023 19:33:41 +0000
Date: Fri, 9 Jun 2023 03:33:04 +0800
From: kernel test robot <lkp@intel.com>
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
	kernel-team@fb.com
Cc: oe-kbuild-all@lists.linux.dev, shr@devkernel.io, axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
	olivier@trillion01.com
Subject: Re: [PATCH v15 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <202306090341.ShxjwRn1-lkp@intel.com>
References: <20230608163839.2891748-2-shr@devkernel.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608163839.2891748-2-shr@devkernel.io>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Stefan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f026be0e1e881e3395c3d5418ffc8c2a2203c3f3]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/net-split-off-__napi_busy_poll-from-napi_busy_poll/20230609-010104
base:   f026be0e1e881e3395c3d5418ffc8c2a2203c3f3
patch link:    https://lore.kernel.org/r/20230608163839.2891748-2-shr%40devkernel.io
patch subject: [PATCH v15 1/7] net: split off __napi_busy_poll from napi_busy_poll
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230609/202306090341.ShxjwRn1-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout f026be0e1e881e3395c3d5418ffc8c2a2203c3f3
        b4 shazam https://lore.kernel.org/r/20230608163839.2891748-2-shr@devkernel.io
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash net/core/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306090341.ShxjwRn1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/core/dev.c:6182:6: warning: no previous prototype for '__napi_busy_loop' [-Wmissing-prototypes]
    6182 | void __napi_busy_loop(unsigned int napi_id,
         |      ^~~~~~~~~~~~~~~~


vim +/__napi_busy_loop +6182 net/core/dev.c

  6181	
> 6182	void __napi_busy_loop(unsigned int napi_id,
  6183			      bool (*loop_end)(void *, unsigned long),
  6184			      void *loop_end_arg, bool prefer_busy_poll, u16 budget,
  6185			      bool rcu)
  6186	{
  6187		unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
  6188		int (*napi_poll)(struct napi_struct *napi, int budget);
  6189		void *have_poll_lock = NULL;
  6190		struct napi_struct *napi;
  6191	
  6192	restart:
  6193		napi_poll = NULL;
  6194	
  6195		if (!rcu)
  6196			rcu_read_lock();
  6197	
  6198		napi = napi_by_id(napi_id);
  6199		if (!napi)
  6200			goto out;
  6201	
  6202		preempt_disable();
  6203		for (;;) {
  6204			int work = 0;
  6205	
  6206			local_bh_disable();
  6207			if (!napi_poll) {
  6208				unsigned long val = READ_ONCE(napi->state);
  6209	
  6210				/* If multiple threads are competing for this napi,
  6211				 * we avoid dirtying napi->state as much as we can.
  6212				 */
  6213				if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
  6214					   NAPIF_STATE_IN_BUSY_POLL)) {
  6215					if (prefer_busy_poll)
  6216						set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
  6217					goto count;
  6218				}
  6219				if (cmpxchg(&napi->state, val,
  6220					    val | NAPIF_STATE_IN_BUSY_POLL |
  6221						  NAPIF_STATE_SCHED) != val) {
  6222					if (prefer_busy_poll)
  6223						set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
  6224					goto count;
  6225				}
  6226				have_poll_lock = netpoll_poll_lock(napi);
  6227				napi_poll = napi->poll;
  6228			}
  6229			work = napi_poll(napi, budget);
  6230			trace_napi_poll(napi, work, budget);
  6231			gro_normal_list(napi);
  6232	count:
  6233			if (work > 0)
  6234				__NET_ADD_STATS(dev_net(napi->dev),
  6235						LINUX_MIB_BUSYPOLLRXPACKETS, work);
  6236			local_bh_enable();
  6237	
  6238			if (!loop_end || loop_end(loop_end_arg, start_time))
  6239				break;
  6240	
  6241			if (unlikely(need_resched())) {
  6242				if (rcu)
  6243					break;
  6244				if (napi_poll)
  6245					busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
  6246				preempt_enable();
  6247				rcu_read_unlock();
  6248				cond_resched();
  6249				if (loop_end(loop_end_arg, start_time))
  6250					return;
  6251				goto restart;
  6252			}
  6253			cpu_relax();
  6254		}
  6255		if (napi_poll)
  6256			busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
  6257		preempt_enable();
  6258	out:
  6259		if (!rcu)
  6260			rcu_read_unlock();
  6261	}
  6262	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

