Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487EB53B04C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiFAWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 18:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiFAWCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 18:02:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494A2B842;
        Wed,  1 Jun 2022 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654120960; x=1685656960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TTojbk3zhQLGZQY5ZUmuvOKg1nRm4x/zxYu3AiWIBHA=;
  b=HD8/O/JXngM1pZQO0wu/NbV9NVYGHPxHRO8TCIUsjbMELpHG0Ln3fqYN
   WtUnvLwZ/XBsOtSYB+0pwMidYQMM1Z8Tfe90AJg5Ri6umRXzS5iX/JTSF
   7dw3w0Vr1M3fnxbc+gSzEXaRsEixSrqgbM9K4GDrkeXG1pMQadyT4b5aV
   Uhz8yfzWc8tCXJcm/4Q4Ye7wxQx4DaqRncbKL/V3EhfxrIee4gnfmDTdW
   7xbKhmg8JNawJHnFOIbF3YYXW8+UjK2AHlZawGvrsCXcRtPYPFIo1pDzR
   AIISsdRoCwGkWFGj4WgSFzXzsiM/33ygmo3wxp/ZezJBgurxWC4mMAuaj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="255614614"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="255614614"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 15:02:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="707266896"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 01 Jun 2022 15:02:24 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwWQ4-0004SU-38;
        Wed, 01 Jun 2022 22:02:24 +0000
Date:   Thu, 2 Jun 2022 06:01:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, rostedt@goodmis.org,
        jolsa@kernel.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <202206020533.bBh0IXx6-lkp@intel.com>
References: <20220601175749.3071572-4-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601175749.3071572-4-song@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: parisc-randconfig-r005-20220531 (https://download.01.org/0day-ci/archive/20220602/202206020533.bBh0IXx6-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a710d92bb10a7a0376af57af15208ea1b4396545
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
        git checkout a710d92bb10a7a0376af57af15208ea1b4396545
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash kernel/trace/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/trace/ftrace.c: In function 'prepare_direct_functions_for_ipmodify':
   kernel/trace/ftrace.c:8005:21: error: 'direct_mutex' undeclared (first use in this function); did you mean 'event_mutex'?
    8005 |         mutex_lock(&direct_mutex);
         |                     ^~~~~~~~~~~~
         |                     event_mutex
   kernel/trace/ftrace.c:8005:21: note: each undeclared identifier is reported only once for each function it appears in
>> kernel/trace/ftrace.c:8007:19: error: 'struct ftrace_ops' has no member named 'func_hash'
    8007 |         hash = ops->func_hash->filter_hash;
         |                   ^~
>> kernel/trace/ftrace.c:8020:37: error: implicit declaration of function 'ops_references_ip' [-Werror=implicit-function-declaration]
    8020 |                                 if (ops_references_ip(op, ip)) {
         |                                     ^~~~~~~~~~~~~~~~~
>> kernel/trace/ftrace.c:8028:40: error: 'struct ftrace_ops' has no member named 'ops_func'
    8028 |                                 if (!op->ops_func) {
         |                                        ^~
   kernel/trace/ftrace.c:8032:41: error: 'struct ftrace_ops' has no member named 'ops_func'
    8032 |                                 ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
         |                                         ^~
   kernel/trace/ftrace.c: In function 'register_ftrace_function':
   kernel/trace/ftrace.c:8084:31: error: 'direct_mutex' undeclared (first use in this function); did you mean 'event_mutex'?
    8084 |                 mutex_unlock(&direct_mutex);
         |                               ^~~~~~~~~~~~
         |                               event_mutex
   cc1: some warnings being treated as errors


vim +8007 kernel/trace/ftrace.c

  7974	
  7975	/*
  7976	 * When registering ftrace_ops with IPMODIFY (not direct), it is necessary
  7977	 * to make sure it doesn't conflict with any direct ftrace_ops. If there is
  7978	 * existing direct ftrace_ops on a kernel function being patched, call
  7979	 * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY on it to enable sharing.
  7980	 *
  7981	 * @ops:     ftrace_ops being registered.
  7982	 *
  7983	 * Returns:
  7984	 *         0 - @ops does have IPMODIFY or @ops itself is DIRECT, no change
  7985	 *             needed;
  7986	 *         1 - @ops has IPMODIFY, hold direct_mutex;
  7987	 *         -EBUSY - currently registered DIRECT ftrace_ops does not support
  7988	 *                  SHARE_IPMODIFY, we need to abort the register.
  7989	 *         -EAGAIN - cannot make changes to currently registered DIRECT
  7990	 *                   ftrace_ops at the moment, but we can retry later. This
  7991	 *                   is needed to avoid potential deadlocks.
  7992	 */
  7993	static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
  7994		__acquires(&direct_mutex)
  7995	{
  7996		struct ftrace_func_entry *entry;
  7997		struct ftrace_hash *hash;
  7998		struct ftrace_ops *op;
  7999		int size, i, ret;
  8000	
  8001		if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY) ||
  8002		    (ops->flags & FTRACE_OPS_FL_DIRECT))
  8003			return 0;
  8004	
  8005		mutex_lock(&direct_mutex);
  8006	
> 8007		hash = ops->func_hash->filter_hash;
  8008		size = 1 << hash->size_bits;
  8009		for (i = 0; i < size; i++) {
  8010			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
  8011				unsigned long ip = entry->ip;
  8012				bool found_op = false;
  8013	
  8014				mutex_lock(&ftrace_lock);
  8015				do_for_each_ftrace_op(op, ftrace_ops_list) {
  8016					if (!(op->flags & FTRACE_OPS_FL_DIRECT))
  8017						continue;
  8018					if (op->flags & FTRACE_OPS_FL_SHARE_IPMODIFY)
  8019						break;
> 8020					if (ops_references_ip(op, ip)) {
  8021						found_op = true;
  8022						break;
  8023					}
  8024				} while_for_each_ftrace_op(op);
  8025				mutex_unlock(&ftrace_lock);
  8026	
  8027				if (found_op) {
> 8028					if (!op->ops_func) {
  8029						ret = -EBUSY;
  8030						goto err_out;
  8031					}
  8032					ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
  8033					if (ret)
  8034						goto err_out;
  8035				}
  8036			}
  8037		}
  8038	
  8039		/*
  8040		 * Didn't find any overlap with any direct function, or the direct
  8041		 * function can share with ipmodify. Hold direct_mutex to make sure
  8042		 * this doesn't change until we are done.
  8043		 */
  8044		return 1;
  8045	
  8046	err_out:
  8047		mutex_unlock(&direct_mutex);
  8048		return ret;
  8049	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
