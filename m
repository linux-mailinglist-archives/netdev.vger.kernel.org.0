Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BC752D1DA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiESLzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiESLzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:55:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244D8B82F8;
        Thu, 19 May 2022 04:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652961330; x=1684497330;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pqpAuufNqlRu8x4BlWLqz7TA3uPL/pl4sJ3q0/pCtlc=;
  b=XQSJHCo/VPXRRi2C1ioDZSl4CxpxCupIehBLjE6WvMbH8LRsCAJndONQ
   NCgYEsLtUP4pR0VjyALp8Cv4IMHivIHXf4fzoPxxn1dBuDAXvoWDy9/No
   5y8oPvNYfPYYpPDpZUbzsVDzCXjwH5GdcJEgXRZBGvOOZGuGlyBqJkroo
   1t3CRIElumiUq/8Z3X9d2oiZqjGtqvu3p4Z0o4HN+sr2SpQ4hxXE366h+
   2PgYR7ZVqcOQJMBK3OLCwudHbB1sxonCz7z2hFXaUXmqu62ygRsJV+XWH
   AQoPddW15BXswkg2MG7ZE8LlNeiB9vT1vvtKgkv3BQ5tVlwzQJmBjjkLR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="272126429"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="272126429"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 04:55:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="714943653"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2022 04:55:26 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrekX-0003Vx-AP;
        Thu, 19 May 2022 11:55:25 +0000
Date:   Thu, 19 May 2022 19:55:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: Re: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in atomic
 context bugs
Message-ID: <202205191932.qrHJI7FT-lkp@intel.com>
References: <20220519101656.44513-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519101656.44513-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Duoming,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Duoming-Zhou/net-wireless-marvell-mwifiex-fix-sleep-in-atomic-context-bugs/20220519-181826
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git fbb3abdf2223cd0dfc07de85fe5a43ba7f435bdf
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220519/202205191932.qrHJI7FT-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d11bfae513f24308f5315efe8ca56471eff8e76c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Duoming-Zhou/net-wireless-marvell-mwifiex-fix-sleep-in-atomic-context-bugs/20220519-181826
        git checkout d11bfae513f24308f5315efe8ca56471eff8e76c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/wait.h:7,
                    from drivers/net/wireless/marvell/mwifiex/decl.h:26,
                    from drivers/net/wireless/marvell/mwifiex/init.c:20:
   drivers/net/wireless/marvell/mwifiex/init.c: In function 'fw_dump_work':
>> include/linux/container_of.h:19:54: error: invalid use of undefined type 'struct mwfiex_adapter'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                                                      ^~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/net/wireless/marvell/mwifiex/init.c:69:17: note: in expansion of macro 'container_of'
      69 |                 container_of(work, struct mwfiex_adapter, devdump_work);
         |                 ^~~~~~~~~~~~
   include/linux/compiler_types.h:293:27: error: expression in static assertion is not an integer
     293 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:19:9: note: in expansion of macro 'static_assert'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:19:23: note: in expansion of macro '__same_type'
      19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   drivers/net/wireless/marvell/mwifiex/init.c:69:17: note: in expansion of macro 'container_of'
      69 |                 container_of(work, struct mwfiex_adapter, devdump_work);
         |                 ^~~~~~~~~~~~
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from ./arch/m68k/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:248,
                    from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/wait.h:7,
                    from drivers/net/wireless/marvell/mwifiex/decl.h:26,
                    from drivers/net/wireless/marvell/mwifiex/init.c:20:
>> include/linux/stddef.h:16:33: error: invalid use of undefined type 'struct mwfiex_adapter'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~
   include/linux/container_of.h:22:28: note: in expansion of macro 'offsetof'
      22 |         ((type *)(__mptr - offsetof(type, member))); })
         |                            ^~~~~~~~
   drivers/net/wireless/marvell/mwifiex/init.c:69:17: note: in expansion of macro 'container_of'
      69 |                 container_of(work, struct mwfiex_adapter, devdump_work);
         |                 ^~~~~~~~~~~~
>> drivers/net/wireless/marvell/mwifiex/init.c:71:36: error: passing argument 1 of 'mwifiex_upload_device_dump' from incompatible pointer type [-Werror=incompatible-pointer-types]
      71 |         mwifiex_upload_device_dump(adapter);
         |                                    ^~~~~~~
         |                                    |
         |                                    struct mwfiex_adapter *
   In file included from drivers/net/wireless/marvell/mwifiex/init.c:24:
   drivers/net/wireless/marvell/mwifiex/main.h:1688:57: note: expected 'struct mwifiex_adapter *' but argument is of type 'struct mwfiex_adapter *'
    1688 | void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
   cc1: some warnings being treated as errors


vim +19 include/linux/container_of.h

d2a8ebbf8192b8 Andy Shevchenko  2021-11-08   9  
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  10  /**
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  11   * container_of - cast a member of a structure out to the containing structure
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  12   * @ptr:	the pointer to the member.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  13   * @type:	the type of the container struct this is embedded in.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  14   * @member:	the name of the member within the struct.
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  15   *
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  16   */
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  17  #define container_of(ptr, type, member) ({				\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  18  	void *__mptr = (void *)(ptr);					\
e1edc277e6f6df Rasmus Villemoes 2021-11-08 @19  	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
e1edc277e6f6df Rasmus Villemoes 2021-11-08  20  		      __same_type(*(ptr), void),			\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  21  		      "pointer type mismatch in container_of()");	\
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  22  	((type *)(__mptr - offsetof(type, member))); })
d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  23  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
