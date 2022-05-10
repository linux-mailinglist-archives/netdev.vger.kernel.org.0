Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D928520BB8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiEJDMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiEJDM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:12:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C209E209557
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152112; x=1683688112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kdFOIkTh1cFfiFZjB/bGr5DGUxpuaQPCbERir24oWNc=;
  b=lhLb0Pmi0fEOkE7b+PK2OrePVvtIH+BcMg/LCB3CA1DXb5JIY89b0Orl
   aFXHC11ed5QuH+GKv2lYXJ9LXpHC/RUCcYKX/20dfvvw879O0fujVlrAd
   KaHnUBZr6kmwXRBqEo6vwH5Wj0yYqp6C7RVEvD+L7UicF5ZD9ZciA2DiR
   1A7cG3ehq/uUgnf+Bg1ocYuNsws2PIoJssD0bAmIAo3q6Pv5p+xIvvguA
   ruIP1Ycr2XAC23bocz1tt3MJVJc0HDdMRay8WuKUPKFT7ubdvjkgcjcwP
   DRUPY+Zz4hnrFe7sK8PblgZDfCgTgwZ2Oc2kAexV9tcOemNm6EOkrzR/D
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="329838299"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="329838299"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:08:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="541550824"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 09 May 2022 20:08:29 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noGEe-000HDw-VX;
        Tue, 10 May 2022 03:08:28 +0000
Date:   Tue, 10 May 2022 11:08:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v5 net-next 02/13] net: allow gso_max_size to exceed 65536
Message-ID: <202205101045.zaceqBiC-lkp@intel.com>
References: <20220509222149.1763877-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509222149.1763877-3-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220510-062530
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
config: arm-spear3xx_defconfig (https://download.01.org/0day-ci/archive/20220510/202205101045.zaceqBiC-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3abb68a626160e019c30a4860e569d7bc75e486a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/8f9b47ee99f57d1747010d002315092bfa17ed50
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220510-062530
        git checkout 8f9b47ee99f57d1747010d002315092bfa17ed50
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/core/sock.c:2317:51: error: no member named 'skc_v6_rcv_saddr' in 'struct sock_common'; did you mean 'skc_rcv_saddr'?
                                !sk_is_tcp(sk) || ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
                                                                          ^
   include/net/sock.h:389:37: note: expanded from macro 'sk_v6_rcv_saddr'
   #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                       ^
   include/net/sock.h:171:11: note: 'skc_rcv_saddr' declared here
                           __be32  skc_rcv_saddr;
                                   ^
   1 error generated.


vim +2317 net/core/sock.c

  2295	
  2296	void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
  2297	{
  2298		u32 max_segs = 1;
  2299	
  2300		sk_dst_set(sk, dst);
  2301		sk->sk_route_caps = dst->dev->features;
  2302		if (sk_is_tcp(sk))
  2303			sk->sk_route_caps |= NETIF_F_GSO;
  2304		if (sk->sk_route_caps & NETIF_F_GSO)
  2305			sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
  2306		if (unlikely(sk->sk_gso_disabled))
  2307			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
  2308		if (sk_can_gso(sk)) {
  2309			if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
  2310				sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
  2311			} else {
  2312				sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
  2313				/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
  2314				sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
  2315				if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
  2316				    (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family != AF_INET6 ||
> 2317				     !sk_is_tcp(sk) || ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
  2318					sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
  2319				sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
  2320				/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
  2321				max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
  2322			}
  2323		}
  2324		sk->sk_gso_max_segs = max_segs;
  2325	}
  2326	EXPORT_SYMBOL_GPL(sk_setup_caps);
  2327	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
