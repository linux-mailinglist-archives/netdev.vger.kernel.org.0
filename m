Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7DF67FA1F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjA1Rz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 12:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjA1Rzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 12:55:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7801CAF5
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 09:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674928553; x=1706464553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tBMeJ/H1qBPJqR0ibr8cYabA/aeo+lAbhGkqwxRcOPU=;
  b=HTW3NY6ar5Q7WxgvhozUl7F6vixP4x3myEUdGWlhWMud8BVdJkj798Er
   MjtzOHt+jHOATtM1QHuRI8p/rG+/f8Fqx3wzxEVEuoY4BJPk4VIkt236P
   VqRqmDcwgxui4bthTsrdziIqAxJPeQlnnaCpUDZXMsTycT15n5Mo7rZ+C
   jmGvD+jx5jB6fL+QHt+ywzIoSLUl/nK6uCdRnc9k2JhH6197KNyxlWQCe
   LpSbsCIZxCAZ07jfAUrT5E2P0z6iW7yW98HFDzOz9qZ2vZ1gK/2m0XL+U
   GSnTDDeFxatiN6EirKRMP/om6QvyJsSkRN24DKHvBKd6hO+QSSGVfM0DV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="391871828"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="391871828"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 09:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="656969412"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="656969412"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 28 Jan 2023 09:55:50 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLpQW-0000xz-38;
        Sat, 28 Jan 2023 17:55:44 +0000
Date:   Sun, 29 Jan 2023 01:55:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <202301290138.HFiMVZzA-lkp@intel.com>
References: <20230126010206.13483-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
patch link:    https://lore.kernel.org/r/20230126010206.13483-3-vfedorenko%40novek.ru
patch subject: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo use-after-free
config: openrisc-randconfig-r014-20230123 (https://download.01.org/0day-ci/archive/20230129/202301290138.HFiMVZzA-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2516a9785583b92ac82262a813203de696096ccd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
        git checkout 2516a9785583b92ac82262a813203de696096ccd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/timer.h:5,
                    from include/linux/netdevice.h:24,
                    from include/linux/if_vlan.h:10,
                    from drivers/net/ethernet/mellanox/mlx5/core/en.h:35,
                    from drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h:7,
                    from drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:4:
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c: In function 'mlx5e_ptp_skb_fifo_ts_cqe_resync':
>> include/linux/compiler.h:56:23: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      56 | #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
         |                       ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:97:9: note: in expansion of macro 'if'
      97 |         if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
         |         ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:99:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      99 |                 return false;
         |                 ^~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:93:25: warning: unused variable 'skb' [-Wunused-variable]
      93 |         struct sk_buff *skb;
         |                         ^~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:92:37: warning: unused variable 'hwts' [-Wunused-variable]
      92 |         struct skb_shared_hwtstamps hwts = {};
         |                                     ^~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c: At top level:
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:102:9: error: expected identifier or '(' before 'while'
     102 |         while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
         |         ^~~~~
>> include/linux/compiler.h:56:23: error: expected identifier or '(' before 'if'
      56 | #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
         |                       ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:110:9: note: in expansion of macro 'if'
     110 |         if (!skb)
         |         ^~
>> include/linux/compiler.h:72:2: error: expected identifier or '(' before ')' token
      72 | })
         |  ^
   include/linux/compiler.h:58:69: note: in expansion of macro '__trace_if_value'
      58 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                                     ^~~~~~~~~~~~~~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
      56 | #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
         |                            ^~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:110:9: note: in expansion of macro 'if'
     110 |         if (!skb)
         |         ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:113:9: error: expected identifier or '(' before 'return'
     113 |         return true;
         |         ^~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:114:1: error: expected identifier or '(' before '}' token
     114 | }
         | ^


vim +56 include/linux/compiler.h

2bcd521a684cc9 Steven Rostedt 2008-11-21  50  
2bcd521a684cc9 Steven Rostedt 2008-11-21  51  #ifdef CONFIG_PROFILE_ALL_BRANCHES
2bcd521a684cc9 Steven Rostedt 2008-11-21  52  /*
2bcd521a684cc9 Steven Rostedt 2008-11-21  53   * "Define 'is'", Bill Clinton
2bcd521a684cc9 Steven Rostedt 2008-11-21  54   * "Define 'if'", Steven Rostedt
2bcd521a684cc9 Steven Rostedt 2008-11-21  55   */
a15fd609ad53a6 Linus Torvalds 2019-03-20 @56  #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
a15fd609ad53a6 Linus Torvalds 2019-03-20  57  
a15fd609ad53a6 Linus Torvalds 2019-03-20  58  #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
a15fd609ad53a6 Linus Torvalds 2019-03-20  59  
a15fd609ad53a6 Linus Torvalds 2019-03-20  60  #define __trace_if_value(cond) ({			\
2bcd521a684cc9 Steven Rostedt 2008-11-21  61  	static struct ftrace_branch_data		\
e04462fb82f8dd Miguel Ojeda   2018-09-03  62  		__aligned(4)				\
33def8498fdde1 Joe Perches    2020-10-21  63  		__section("_ftrace_branch")		\
a15fd609ad53a6 Linus Torvalds 2019-03-20  64  		__if_trace = {				\
2bcd521a684cc9 Steven Rostedt 2008-11-21  65  			.func = __func__,		\
2bcd521a684cc9 Steven Rostedt 2008-11-21  66  			.file = __FILE__,		\
2bcd521a684cc9 Steven Rostedt 2008-11-21  67  			.line = __LINE__,		\
2bcd521a684cc9 Steven Rostedt 2008-11-21  68  		};					\
a15fd609ad53a6 Linus Torvalds 2019-03-20  69  	(cond) ?					\
a15fd609ad53a6 Linus Torvalds 2019-03-20  70  		(__if_trace.miss_hit[1]++,1) :		\
a15fd609ad53a6 Linus Torvalds 2019-03-20  71  		(__if_trace.miss_hit[0]++,0);		\
a15fd609ad53a6 Linus Torvalds 2019-03-20 @72  })
a15fd609ad53a6 Linus Torvalds 2019-03-20  73  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
