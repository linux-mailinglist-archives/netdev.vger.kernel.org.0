Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078F16D56AF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjDDCWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDDCWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:22:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70BF1BFB;
        Mon,  3 Apr 2023 19:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680574919; x=1712110919;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S9jlvO03mnmm15rtkefUHtXNrIuNeFHbwAHrntbkPhg=;
  b=b+GIowuRFxmSdRjWVTcBI0664n/9pnubNPbZLBN9ZnsYQvX2b1VoFztG
   0KpO9YS2HUUJmxCk0oPXfW80faoy4dqLsipzKKMEiLSvecD40cYybzezX
   w5Yh6CtUfNI7L+LbwotjXB+dnlqucpRbn7EbLjjx+I8MCL94C5K2n5H9U
   zrgJK68aBjkWclZTVr+6Ol+M6ipPtvRXLbJ9VtlmVe6QGSaYzU5Ki48Pc
   fAN8qO/lbhvrfwMk/hHgDJ3AkpeVJkj8zT1HD/lA4z3lO9TidSRPZ9Ozo
   7L6+RDzsO7eMm8WGILJxY7XysZ266dQbfQQMHPdXDE+6K1yg/GbBE3exO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340801865"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="340801865"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:21:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="810056483"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="810056483"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2023 19:21:53 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjWIy-000P2g-3A;
        Tue, 04 Apr 2023 02:21:52 +0000
Date:   Tue, 4 Apr 2023 10:21:14 +0800
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
Message-ID: <202304041030.rTLITKDY-lkp@intel.com>
References: <20230403213420.1576559-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403213420.1576559-2-dima@arista.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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
config: hexagon-randconfig-r041-20230403 (https://download.01.org/0day-ci/archive/20230404/202304041030.rTLITKDY-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/94408bb4cf5cbcc772ab4d70eeb73bda183c6124
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230404-054020
        git checkout 94408bb4cf5cbcc772ab4d70eeb73bda183c6124
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304041030.rTLITKDY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/ipv4/tcp_sigpool.c:10:
   In file included from include/net/tcp.h:20:
   In file included from include/linux/tcp.h:17:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from net/ipv4/tcp_sigpool.c:10:
   In file included from include/net/tcp.h:20:
   In file included from include/linux/tcp.h:17:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from net/ipv4/tcp_sigpool.c:10:
   In file included from include/net/tcp.h:20:
   In file included from include/linux/tcp.h:17:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
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
   7 warnings generated.


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
