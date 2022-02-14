Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1EE4B5E6C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiBNXtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:49:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiBNXtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:49:22 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263D81402E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644882553; x=1676418553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=06tmGudHz31nq+18iqRjT9pi8sBK3LuB78ri/HwR/wc=;
  b=G8CNOlaKudObWzn8XssXDsFwdCI0tY+PQhPcOjNYvrlo4m68vcF8SuCu
   JpYupixDT/4WosIs6MmqE1mXg3d3InRwzX4cxV3Rg/gBWjtQXMPqfO6r5
   u2prSPx2Ku/nd496wdctdoRIJRI+KEAGyR3w2b7umZmbjidWTf8DZvrXG
   ZzooK2H4zbWwEj5PT2ad3as28X0Jjb0FfVvr0eT7RvqzfsLyN75p+8/Vd
   wO3xovFKBBB9oHFkm4Lu8SHDsq7Tsqh1NMU0BK47yxWj0t9inPQlhi8EO
   eL7ZFFL5WXAhK+f7vgDidHSzwFurOHyi6BTs0SVoZUdL0aIGA3SJAKf+K
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="336639184"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="336639184"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 15:48:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="543990889"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2022 15:48:22 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJl4w-00092r-6z; Mon, 14 Feb 2022 23:48:22 +0000
Date:   Tue, 15 Feb 2022 07:48:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, Willem de Bruijn <willemb@google.com>,
        Congyu Liu <liu3101@purdue.edu>
Subject: Re: [PATCH net] ipv6: per-netns exclusive flowlabel checks
Message-ID: <202202150740.uPYefwp7-lkp@intel.com>
References: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/0day-ci/linux/commits/Willem-de-Bruijn/ipv6-per-netns-exclusive-flowlabel-checks/20220215-042330
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 86006f996346e8a5a1ea80637ec949ceeea4ecbc
config: arm-netwinder_defconfig (https://download.01.org/0day-ci/archive/20220215/202202150740.uPYefwp7-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ea071884b0cc7210b3cc5fe858f0e892a779a23b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/5d3936d3544b4cdd6d63c896d158d4975a4822c3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Willem-de-Bruijn/ipv6-per-netns-exclusive-flowlabel-checks/20220215-042330
        git checkout 5d3936d3544b4cdd6d63c896d158d4975a4822c3
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/mptcp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:313:10: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:313:39: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                           ^
   In file included from net/mptcp/protocol.c:16:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:402:60: error: invalid operands to binary expression ('long' and 'void')
           if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
   8 errors generated.
--
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:313:10: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:313:39: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
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
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
               READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                         ~~~~~~~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                           ^
   In file included from net/mptcp/options.c:11:
   In file included from include/net/tcp.h:32:
   In file included from include/net/inet_hashtables.h:27:
   In file included from include/net/route.h:24:
   In file included from include/net/inetpeer.h:16:
>> include/net/ipv6.h:402:60: error: invalid operands to binary expression ('long' and 'void')
           if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
   net/mptcp/options.c:552:21: warning: parameter 'remaining' set but not used [-Wunused-but-set-parameter]
                                             unsigned int remaining,
                                                          ^
   1 warning and 8 errors generated.


vim +403 include/net/ipv6.h

   397	
   398	extern struct static_key_false_deferred ipv6_flowlabel_exclusive;
   399	static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
   400							    __be32 label)
   401	{
 > 402		if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
 > 403		    READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
   404			return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);
   405	
   406		return NULL;
   407	}
   408	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
