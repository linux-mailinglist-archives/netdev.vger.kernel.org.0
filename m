Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6994B5EF2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiBOATi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:19:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBOATh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:19:37 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC94C12D0B2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644884368; x=1676420368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZSirIDvlIWHGucFV8M2Rio4bqMTvd2u/FR+TdqsQcwk=;
  b=TDWZbu8g7WgAA3NYGID3bGdezPo0JGrVvPmAL+fx8DDcIgFlu6AdACMP
   ytg4bZ3ZCanpMdicJyvchz3P8DdqO2vzmm5l2RUcmPw31gMLVLuRr82GK
   ZCUQcIRFn84VgAlz/yzHQc46Cnf6fNOsSkuOaW2tF+dVc4+NF8hjbLkdA
   +dA0+xJo5iDFpHD1ffTMFthEzS6aVJrz0a+9qSxGlJ1j13B87OqDGarOC
   4hgnVPqQibNHHVn0hZlSV6HTAjEQ2lgb3oD4AYJcVyD86gwOgjjOP4vS4
   RwLI6CQsiaruE4grDPOBRUgnXDRzpcIbv8EhSiRPjF5zOrhW5rzWR5sDN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="274789373"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="274789373"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 16:19:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="570547087"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2022 16:19:26 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJlYz-000951-HR; Tue, 15 Feb 2022 00:19:25 +0000
Date:   Tue, 15 Feb 2022 08:18:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, Willem de Bruijn <willemb@google.com>,
        Congyu Liu <liu3101@purdue.edu>
Subject: Re: [PATCH net] ipv6: per-netns exclusive flowlabel checks
Message-ID: <202202150837.bGbeRjWx-lkp@intel.com>
References: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Willem-de-Bruijn/ipv6-per-netns-exclusive-flowlabel-checks/20220215-042330
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 86006f996346e8a5a1ea80637ec949ceeea4ecbc
config: hexagon-randconfig-r036-20220214 (https://download.01.org/0day-ci/archive/20220215/202202150837.bGbeRjWx-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ea071884b0cc7210b3cc5fe858f0e892a779a23b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5d3936d3544b4cdd6d63c896d158d4975a4822c3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Willem-de-Bruijn/ipv6-per-netns-exclusive-flowlabel-checks/20220215-042330
        git checkout 5d3936d3544b4cdd6d63c896d158d4975a4822c3
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ceph/ net/sched/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:314:10: note: expanded from macro '__native_word'
            sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
                   ^
   include/linux/compiler_types.h:346:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:334:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:326:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
   In file included from net/sched/cls_flow.c:24:
   In file included from include/net/ip.h:30:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
   include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:314:38: note: expanded from macro '__native_word'
            sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
                                               ^
   include/linux/compiler_types.h:346:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:334:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:326:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
   In file included from net/sched/cls_flow.c:24:
   In file included from include/net/ip.h:30:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
   include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:48: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                                         ^
   include/linux/compiler_types.h:346:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:334:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:326:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
   In file included from net/sched/cls_flow.c:24:
   In file included from include/net/ip.h:30:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
   include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                    ^
   include/linux/compiler_types.h:302:13: note: expanded from macro '__unqual_scalar_typeof'
                   _Generic((x),                                           \
                             ^
   In file included from net/sched/cls_flow.c:24:
   In file included from include/net/ip.h:30:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
   include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                           ^
   In file included from net/sched/cls_flow.c:24:
   In file included from include/net/ip.h:30:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
   include/net/ipv6.h:402:60: error: invalid operands to binary expression ('long' and 'void')
           if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
>> net/sched/cls_flow.c:63:52: warning: shift count >= width of type [-Wshift-count-overflow]
           return (a & 0xFFFFFFFF) ^ (BITS_PER_LONG > 32 ? a >> 32 : 0);
                                                             ^  ~~
   1 warning and 8 errors generated.


vim +63 net/sched/cls_flow.c

e5dfb815181fcb Patrick McHardy 2008-01-31  58  
e5dfb815181fcb Patrick McHardy 2008-01-31  59  static inline u32 addr_fold(void *addr)
e5dfb815181fcb Patrick McHardy 2008-01-31  60  {
e5dfb815181fcb Patrick McHardy 2008-01-31  61  	unsigned long a = (unsigned long)addr;
e5dfb815181fcb Patrick McHardy 2008-01-31  62  
e5dfb815181fcb Patrick McHardy 2008-01-31 @63  	return (a & 0xFFFFFFFF) ^ (BITS_PER_LONG > 32 ? a >> 32 : 0);
e5dfb815181fcb Patrick McHardy 2008-01-31  64  }
e5dfb815181fcb Patrick McHardy 2008-01-31  65  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
