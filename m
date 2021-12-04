Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D9468225
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 04:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354759AbhLDDh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 22:37:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:1145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354704AbhLDDh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 22:37:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="297890792"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="297890792"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 19:34:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="461125948"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 03 Dec 2021 19:34:30 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtLoj-000IP9-Dz; Sat, 04 Dec 2021 03:34:29 +0000
Date:   Sat, 4 Dec 2021 11:34:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Laight <David.Laight@ACULAB.COM>,
        David Lebrun <dlebrun@google.com>
Subject: Re: [PATCH net-next] net: fix recent csum changes
Message-ID: <202112041119.X8sqBWc9-lkp@intel.com>
References: <20211203185238.2011081-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203185238.2011081-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-fix-recent-csum-changes/20211204-025401
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 43332cf97425a3e5508c827c82201ecc5ddd54e0
config: arc-randconfig-s032-20211203 (https://download.01.org/0day-ci/archive/20211204/202112041119.X8sqBWc9-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/c13fbd113358fb59f76f76d25a1fdb57379c4b9c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-fix-recent-csum-changes/20211204-025401
        git checkout c13fbd113358fb59f76f76d25a1fdb57379c4b9c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arc SHELL=/bin/bash net/core/ net/ethernet/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/core/skbuff.c: note: in included file (through include/net/checksum.h, include/linux/skbuff.h, include/net/net_namespace.h, ...):
   arch/arc/include/asm/checksum.h:27:26: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:27:36: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:29:11: sparse: sparse: bad assignment (-=) to restricted __wsum
   arch/arc/include/asm/checksum.h:30:16: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:30:18: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got unsigned int @@
   arch/arc/include/asm/checksum.h:30:18: sparse:     expected restricted __sum16
   arch/arc/include/asm/checksum.h:30:18: sparse:     got unsigned int
   arch/arc/include/asm/checksum.h:27:26: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:27:36: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:29:11: sparse: sparse: bad assignment (-=) to restricted __wsum
   arch/arc/include/asm/checksum.h:30:16: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:30:18: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got unsigned int @@
   arch/arc/include/asm/checksum.h:30:18: sparse:     expected restricted __sum16
   arch/arc/include/asm/checksum.h:30:18: sparse:     got unsigned int
   arch/arc/include/asm/checksum.h:27:26: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:27:36: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:29:11: sparse: sparse: bad assignment (-=) to restricted __wsum
   arch/arc/include/asm/checksum.h:30:16: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:30:18: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got unsigned int @@
   arch/arc/include/asm/checksum.h:30:18: sparse:     expected restricted __sum16
   arch/arc/include/asm/checksum.h:30:18: sparse:     got unsigned int
   net/core/skbuff.c: note: in included file (through include/net/net_namespace.h, include/linux/inet.h):
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
   net/core/skbuff.c: note: in included file (through include/net/checksum.h, include/linux/skbuff.h, include/net/net_namespace.h, ...):
   arch/arc/include/asm/checksum.h:27:26: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:27:36: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:29:11: sparse: sparse: bad assignment (-=) to restricted __wsum
   arch/arc/include/asm/checksum.h:30:16: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:30:18: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got unsigned int @@
   arch/arc/include/asm/checksum.h:30:18: sparse:     expected restricted __sum16
   arch/arc/include/asm/checksum.h:30:18: sparse:     got unsigned int
   net/core/skbuff.c: note: in included file (through include/net/net_namespace.h, include/linux/inet.h):
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
--
   net/core/filter.c:5622:9: sparse: sparse: switch with no cases
   net/core/filter.c:5663:9: sparse: sparse: switch with no cases
   net/core/filter.c:1411:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sock_filter const *filter @@     got struct sock_filter [noderef] __user *filter @@
   net/core/filter.c:1411:39: sparse:     expected struct sock_filter const *filter
   net/core/filter.c:1411:39: sparse:     got struct sock_filter [noderef] __user *filter
   net/core/filter.c:1489:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sock_filter const *filter @@     got struct sock_filter [noderef] __user *filter @@
   net/core/filter.c:1489:39: sparse:     expected struct sock_filter const *filter
   net/core/filter.c:1489:39: sparse:     got struct sock_filter [noderef] __user *filter
   net/core/filter.c:10023:31: sparse: sparse: symbol 'cg_skb_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:10029:27: sparse: sparse: symbol 'cg_skb_prog_ops' was not declared. Should it be static?
   net/core/filter.c:10074:31: sparse: sparse: symbol 'cg_sock_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:10080:27: sparse: sparse: symbol 'cg_sock_prog_ops' was not declared. Should it be static?
   net/core/filter.c:10083:31: sparse: sparse: symbol 'cg_sock_addr_verifier_ops' was not declared. Should it be static?
   net/core/filter.c:10089:27: sparse: sparse: symbol 'cg_sock_addr_prog_ops' was not declared. Should it be static?
   net/core/filter.c:246:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:246:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:246:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:246:32: sparse: sparse: cast to restricted __be16
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:273:32: sparse: sparse: cast to restricted __be32
   net/core/filter.c:1910:43: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __wsum [usertype] diff @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1910:43: sparse:     expected restricted __wsum [usertype] diff
   net/core/filter.c:1910:43: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1913:36: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be16 [usertype] old @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1913:36: sparse:     expected restricted __be16 [usertype] old
   net/core/filter.c:1913:36: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1913:42: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be16 [usertype] new @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1913:42: sparse:     expected restricted __be16 [usertype] new
   net/core/filter.c:1913:42: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1916:36: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1916:36: sparse:     expected restricted __be32 [usertype] from
   net/core/filter.c:1916:36: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1916:42: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1916:42: sparse:     expected restricted __be32 [usertype] to
   net/core/filter.c:1916:42: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1961:59: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] diff @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1961:59: sparse:     expected restricted __wsum [usertype] diff
   net/core/filter.c:1961:59: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1964:52: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be16 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1964:52: sparse:     expected restricted __be16 [usertype] from
   net/core/filter.c:1964:52: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1964:58: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __be16 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1964:58: sparse:     expected restricted __be16 [usertype] to
   net/core/filter.c:1964:58: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:1967:52: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] from @@     got unsigned long long [usertype] from @@
   net/core/filter.c:1967:52: sparse:     expected restricted __be32 [usertype] from
   net/core/filter.c:1967:52: sparse:     got unsigned long long [usertype] from
   net/core/filter.c:1967:58: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __be32 [usertype] to @@     got unsigned long long [usertype] to @@
   net/core/filter.c:1967:58: sparse:     expected restricted __be32 [usertype] to
   net/core/filter.c:1967:58: sparse:     got unsigned long long [usertype] to
   net/core/filter.c:2013:28: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned long long @@     got restricted __wsum @@
   net/core/filter.c:2013:28: sparse:     expected unsigned long long
   net/core/filter.c:2013:28: sparse:     got restricted __wsum
   net/core/filter.c:2035:35: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned long long @@     got restricted __wsum [usertype] csum @@
   net/core/filter.c:2035:35: sparse:     expected unsigned long long
   net/core/filter.c:2035:35: sparse:     got restricted __wsum [usertype] csum
   net/core/filter.c: note: in included file (through include/linux/netlink.h, include/linux/sock_diag.h):
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
--
   net/core/dev.c:3207:23: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   net/core/dev.c:3207:23: sparse:     expected restricted __wsum [usertype] csum
   net/core/dev.c:3207:23: sparse:     got unsigned int
   net/core/dev.c:3207:23: sparse: sparse: cast from restricted __wsum
   net/core/dev.c: note: in included file (through include/linux/if_ether.h):
   include/linux/skbuff.h:3489:55: sparse: sparse: restricted __wsum degrades to integer
>> include/linux/skbuff.h:3489:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/linux/skbuff.h:3489:55: sparse:     expected restricted __wsum [usertype] sum
   include/linux/skbuff.h:3489:55: sparse:     got unsigned int
   include/linux/skbuff.h:3489:29: sparse: sparse: restricted __wsum degrades to integer
   include/linux/skbuff.h:3489:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/linux/skbuff.h:3489:27: sparse:     expected restricted __wsum [usertype] csum
   include/linux/skbuff.h:3489:27: sparse:     got unsigned int
   net/core/dev.c: note: in included file (through include/net/checksum.h, include/linux/skbuff.h, include/linux/if_ether.h):
   arch/arc/include/asm/checksum.h:27:26: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:27:36: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:29:11: sparse: sparse: bad assignment (-=) to restricted __wsum
   arch/arc/include/asm/checksum.h:30:16: sparse: sparse: restricted __wsum degrades to integer
   arch/arc/include/asm/checksum.h:30:18: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __sum16 @@     got unsigned int @@
   arch/arc/include/asm/checksum.h:30:18: sparse:     expected restricted __sum16
   arch/arc/include/asm/checksum.h:30:18: sparse:     got unsigned int
   net/core/dev.c:3712:17: sparse: sparse: context imbalance in '__dev_queue_xmit' - different lock contexts for basic block
   net/core/dev.c: note: in included file (through arch/arc/include/asm/irqflags.h, include/linux/irqflags.h, include/linux/rcupdate.h, ...):
   arch/arc/include/asm/irqflags-arcv2.h:80:31: sparse: sparse: undefined identifier '__builtin_arc_lr'
   arch/arc/include/asm/irqflags-arcv2.h:83:17: sparse: sparse: undefined identifier '__builtin_arc_sr'
--
   net/ethernet/eth.c: note: in included file:
   include/net/gro.h:177:56: sparse: sparse: restricted __wsum degrades to integer
>> include/net/gro.h:177:56: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/net/gro.h:177:56: sparse:     expected restricted __wsum [usertype] sum
   include/net/gro.h:177:56: sparse:     got unsigned int
   include/net/gro.h:176:42: sparse: sparse: restricted __wsum degrades to integer
   include/net/gro.h:176:40: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __wsum [usertype] csum @@     got unsigned int @@
   include/net/gro.h:176:40: sparse:     expected restricted __wsum [usertype] csum
   include/net/gro.h:176:40: sparse:     got unsigned int

vim +3489 include/linux/skbuff.h

  3474	
  3475	/**
  3476	 *	skb_postpull_rcsum - update checksum for received skb after pull
  3477	 *	@skb: buffer to update
  3478	 *	@start: start of data before pull
  3479	 *	@len: length of data pulled
  3480	 *
  3481	 *	After doing a pull on a received packet, you need to call this to
  3482	 *	update the CHECKSUM_COMPLETE checksum, or set ip_summed to
  3483	 *	CHECKSUM_NONE so that it can be recomputed from scratch.
  3484	 */
  3485	static inline void skb_postpull_rcsum(struct sk_buff *skb,
  3486					      const void *start, unsigned int len)
  3487	{
  3488		if (skb->ip_summed == CHECKSUM_COMPLETE)
> 3489			skb->csum = -csum_partial(start, len, -skb->csum);
  3490		else if (skb->ip_summed == CHECKSUM_PARTIAL &&
  3491			 skb_checksum_start_offset(skb) < 0)
  3492			skb->ip_summed = CHECKSUM_NONE;
  3493	}
  3494	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
