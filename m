Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657DC6D569B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjDDCMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjDDCMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:12:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF22211B;
        Mon,  3 Apr 2023 19:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680574320; x=1712110320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TDGMjXEoOdfdpc8A+QvPYHDfLyIq7uSVZktWfPFiqD8=;
  b=bWrXh4bZ4EDJuTt+64E8ouMUc3RY3Sg8YXg6ClLmwWDXqWm4+gqqjL3b
   qB95Q5+AMN11ZyBDy9t9jCTRzxlt/WqqWWdKo5LWr1fWPcCG0TEsnG6BO
   1W/FQjv6pmaqZBed6nVNtptfUSLRUKlQJJpsRSSEm8DFkYO8HA0emu381
   vin9tOGg2sgIHsmjnLGRxYfBHePCTtKY4+fPLIjlEd/fyB22LD9eWJBvA
   QcB5ACjpKEGSAzomFltVV7EzBahfN4Srv1qijURIt/ZxoELXbKxsZqDhN
   eCaLalqy1WUKPmcYCF+cszbsXWaEhsoC9debvP93MieN/CoEE1sVGZ8Hx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="326085972"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="326085972"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:11:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="686188904"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="686188904"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2023 19:11:53 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjW9I-000P2K-2P;
        Tue, 04 Apr 2023 02:11:52 +0000
Date:   Tue, 4 Apr 2023 10:10:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v5 01/21] [draft] net/tcp: Prepare tcp_md5sig_pool for
 TCP-AO
Message-ID: <202304040916.I3rkyzLG-lkp@intel.com>
References: <20230403213420.1576559-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403213420.1576559-2-dima@arista.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7e364e56293bb98cae1b55fd835f5991c4e96e7d]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230404-054020
base:   7e364e56293bb98cae1b55fd835f5991c4e96e7d
patch link:    https://lore.kernel.org/r/20230403213420.1576559-2-dima%40arista.com
patch subject: [PATCH v5 01/21] [draft] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
config: i386-randconfig-a001-20230403 (https://download.01.org/0day-ci/archive/20230404/202304040916.I3rkyzLG-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/94408bb4cf5cbcc772ab4d70eeb73bda183c6124
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230404-054020
        git checkout 94408bb4cf5cbcc772ab4d70eeb73bda183c6124
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304040916.I3rkyzLG-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ipv4/tcp_sigpool.c:63:9: warning: comparison of distinct pointer types ('typeof (size) *' (aka 'unsigned int *') and 'typeof (__scratch_size) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
           size = max(size, __scratch_size);
                  ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:74:19: note: expanded from macro 'max'
   #define max(x, y)       __careful_cmp(x, y, >)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +63 net/ipv4/tcp_sigpool.c

    43	
    44	/*
    45	 * sigpool_reserve_scratch - re-allocates scratch buffer, slow-path
    46	 * @size: request size for the scratch/temp buffer
    47	 */
    48	static int sigpool_reserve_scratch(size_t size)
    49	{
    50		struct scratches_to_free *stf;
    51		size_t stf_sz = struct_size(stf, scratches, num_possible_cpus());
    52		int cpu, err = 0;
    53	
    54		lockdep_assert_held(&cpool_mutex);
    55		if (__scratch_size >= size)
    56			return 0;
    57	
    58		stf = kmalloc(stf_sz, GFP_KERNEL);
    59		if (!stf)
    60			return -ENOMEM;
    61		stf->cnt = 0;
    62	
  > 63		size = max(size, __scratch_size);
    64		cpus_read_lock();
    65		for_each_possible_cpu(cpu) {
    66			void *scratch, *old_scratch;
    67	
    68			scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
    69			if (!scratch) {
    70				err = -ENOMEM;
    71				break;
    72			}
    73	
    74			old_scratch = rcu_replace_pointer(per_cpu(sigpool_scratch, cpu), scratch, lockdep_is_held(&cpool_mutex));
    75			if (!cpu_online(cpu) || !old_scratch) {
    76				kfree(old_scratch);
    77				continue;
    78			}
    79			stf->scratches[stf->cnt++] = old_scratch;
    80		}
    81		cpus_read_unlock();
    82		if (!err)
    83			__scratch_size = size;
    84	
    85		call_rcu(&stf->rcu, free_old_scratches);
    86		return err;
    87	}
    88	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
