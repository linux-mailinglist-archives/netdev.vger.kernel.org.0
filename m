Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D0525196
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348964AbiELPtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346355AbiELPti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:49:38 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D85E52B4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652370576; x=1683906576;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=56NGd/S3wyd8nrG+XjJF8hnfs1wOWj6NGs9wjgCkwIo=;
  b=JVjCp8kjkifZYMXFrxY8vLNaibSqAjm5rCI8ZV76IGaX7zRt6PlzOSFS
   0wRzcNX5qhLQWhc1bkaN71AFG1JPJOB8wYtCnty/8+toJl2tzlNV2Fduu
   oc8lBlI1qr0ycp23mdPwZsH3WqWVhy9bew9HOJRchPHsaWZbNTYx6TQGP
   A7Z7eZZnK0XY8O8VzRqTcLUE07n7U4PyMOG9b3etuKLG4/3aHxNFeZ2Uw
   w/nQevbXnYrEF2AiiRpFTkyhI2XDc8Vk2LwS7RlEFCdniNwMHOliMPBEi
   KEkU/Y++eee+4EvQcGmmywAzNfMcSV0tdn9b8Hu/hCPTZqZcD0l2B4sVt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="249935588"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="249935588"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 08:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="553818982"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 12 May 2022 08:49:34 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1npB4H-000KdU-8I;
        Thu, 12 May 2022 15:49:33 +0000
Date:   Thu, 12 May 2022 23:48:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 09/10] ipv6: add READ_ONCE(sk->sk_bound_dev_if)
 in INET6_MATCH()
Message-ID: <202205122338.qp5zlcyC-lkp@intel.com>
References: <20220511233757.2001218-10-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511233757.2001218-10-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b57c7e8b76c646cf77ce4353a779a8b781592209
config: riscv-randconfig-r032-20220512 (https://download.01.org/0day-ci/archive/20220512/202205122338.qp5zlcyC-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/ba3ce839eb3de33511aa07e29cabb8e7ed4e0cf0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
        git checkout ba3ce839eb3de33511aa07e29cabb8e7ed4e0cf0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/core/filter.c:26:
   In file included from include/linux/sock_diag.h:5:
   In file included from include/linux/netlink.h:7:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from net/core/filter.c:26:
   In file included from include/linux/sock_diag.h:5:
   In file included from include/linux/netlink.h:7:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from net/core/filter.c:26:
   In file included from include/linux/sock_diag.h:5:
   In file included from include/linux/netlink.h:7:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:1024:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
                                                     ~~~~~~~~~~ ^
   In file included from net/core/filter.c:64:
>> include/net/inet6_hashtables.h:119:28: error: no member named 'skc_v6_daddr' in 'struct sock_common'; did you mean 'skc_daddr'?
               !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
                                     ^
   include/net/sock.h:388:34: note: expanded from macro 'sk_v6_daddr'
   #define sk_v6_daddr             __sk_common.skc_v6_daddr
                                               ^
   include/net/sock.h:170:11: note: 'skc_daddr' declared here
                           __be32  skc_daddr;
                                   ^
   In file included from net/core/filter.c:64:
>> include/net/inet6_hashtables.h:120:28: error: no member named 'skc_v6_rcv_saddr' in 'struct sock_common'; did you mean 'skc_rcv_saddr'?
               !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
                                     ^
   include/net/sock.h:389:37: note: expanded from macro 'sk_v6_rcv_saddr'
   #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                       ^
   include/net/sock.h:171:11: note: 'skc_rcv_saddr' declared here
                           __be32  skc_rcv_saddr;
                                   ^
   7 warnings and 2 errors generated.


vim +119 include/net/inet6_hashtables.h

   107	
   108	static inline bool INET6_MATCH(const struct sock *sk, struct net *net,
   109				       const struct in6_addr *saddr,
   110				       const struct in6_addr *daddr,
   111				       const __portpair ports,
   112				       const int dif, const int sdif)
   113	{
   114		int bound_dev_if;
   115	
   116		if (!net_eq(sock_net(sk), net) ||
   117		    sk->sk_family != AF_INET6 ||
   118		    sk->sk_portpair != ports ||
 > 119		    !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
 > 120		    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
