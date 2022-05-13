Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13583525923
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359823AbiEMBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359821AbiEMBAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:00:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DBD25509E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652403623; x=1683939623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nCMhrol++DvUo1JFAinqrUh5iSHhc/PFqTDj7FIze9I=;
  b=Fe0VYHDsX+8Q2DrjdwPkbFCu5HRW8sGSJISkM7zWtgSiK+Tkysrg3E4J
   5YFIXbW6uwYDJAcoYKWeTwZZRWvDSfvcdlDNeS70yxal6otNNOteaWcHs
   ubmX3bwgw+wWAFhOEhlyiyqqm1nso1Wj57a3NtBFgzkJsHZMo0Rn5Tfwo
   yRfrB7eT/tki5WfFPCi7MFy3PLcwcCO9ak5520RcIwbfEO3t42BkbURct
   47Z8mLESYH6EqhVTVNkg13l3P36OivY87jqallw6Q9XyyBWHJBJumo19B
   UbCdFwynH6vjYAkTztf3Rz4+NwOzufvnuVfhDvY+Sf5TStQaOKj4JtQFw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="250079513"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="250079513"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 18:00:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="543032803"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2022 18:00:19 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1npJfH-000L7o-6Z;
        Fri, 13 May 2022 01:00:19 +0000
Date:   Fri, 13 May 2022 09:00:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 09/10] ipv6: add READ_ONCE(sk->sk_bound_dev_if)
 in INET6_MATCH()
Message-ID: <202205130816.Wo8OVaxg-lkp@intel.com>
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
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220513/202205130816.Wo8OVaxg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ba3ce839eb3de33511aa07e29cabb8e7ed4e0cf0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
        git checkout ba3ce839eb3de33511aa07e29cabb8e7ed4e0cf0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/sock_diag.h:8,
                    from net/core/filter.c:26:
   include/net/inet6_hashtables.h: In function 'INET6_MATCH':
>> include/net/sock.h:388:45: error: 'const struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
     388 | #define sk_v6_daddr             __sk_common.skc_v6_daddr
         |                                             ^~~~~~~~~~~~
   include/net/inet6_hashtables.h:119:35: note: in expansion of macro 'sk_v6_daddr'
     119 |             !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
         |                                   ^~~~~~~~~~~
>> include/net/sock.h:389:37: error: 'const struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
     389 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
         |                                     ^~~~~~~~~~~~~~~~
   include/net/inet6_hashtables.h:120:35: note: in expansion of macro 'sk_v6_rcv_saddr'
     120 |             !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
         |                                   ^~~~~~~~~~~~~~~


vim +388 include/net/sock.h

4dc6dc7162c08b9 Eric Dumazet             2009-07-15  368  
68835aba4d9b74e Eric Dumazet             2010-11-30  369  #define sk_dontcopy_begin	__sk_common.skc_dontcopy_begin
68835aba4d9b74e Eric Dumazet             2010-11-30  370  #define sk_dontcopy_end		__sk_common.skc_dontcopy_end
4dc6dc7162c08b9 Eric Dumazet             2009-07-15  371  #define sk_hash			__sk_common.skc_hash
5080546682bae3d Eric Dumazet             2013-10-02  372  #define sk_portpair		__sk_common.skc_portpair
05dbc7b59481ca8 Eric Dumazet             2013-10-03  373  #define sk_num			__sk_common.skc_num
05dbc7b59481ca8 Eric Dumazet             2013-10-03  374  #define sk_dport		__sk_common.skc_dport
5080546682bae3d Eric Dumazet             2013-10-02  375  #define sk_addrpair		__sk_common.skc_addrpair
5080546682bae3d Eric Dumazet             2013-10-02  376  #define sk_daddr		__sk_common.skc_daddr
5080546682bae3d Eric Dumazet             2013-10-02  377  #define sk_rcv_saddr		__sk_common.skc_rcv_saddr
^1da177e4c3f415 Linus Torvalds           2005-04-16  378  #define sk_family		__sk_common.skc_family
^1da177e4c3f415 Linus Torvalds           2005-04-16  379  #define sk_state		__sk_common.skc_state
^1da177e4c3f415 Linus Torvalds           2005-04-16  380  #define sk_reuse		__sk_common.skc_reuse
055dc21a1d1d219 Tom Herbert              2013-01-22  381  #define sk_reuseport		__sk_common.skc_reuseport
9fe516ba3fb29b6 Eric Dumazet             2014-06-27  382  #define sk_ipv6only		__sk_common.skc_ipv6only
26abe14379f8e2f Eric W. Biederman        2015-05-08  383  #define sk_net_refcnt		__sk_common.skc_net_refcnt
^1da177e4c3f415 Linus Torvalds           2005-04-16  384  #define sk_bound_dev_if		__sk_common.skc_bound_dev_if
^1da177e4c3f415 Linus Torvalds           2005-04-16  385  #define sk_bind_node		__sk_common.skc_bind_node
8feaf0c0a5488b3 Arnaldo Carvalho de Melo 2005-08-09  386  #define sk_prot			__sk_common.skc_prot
07feaebfcc10cd3 Eric W. Biederman        2007-09-12  387  #define sk_net			__sk_common.skc_net
efe4208f47f907b Eric Dumazet             2013-10-03 @388  #define sk_v6_daddr		__sk_common.skc_v6_daddr
efe4208f47f907b Eric Dumazet             2013-10-03 @389  #define sk_v6_rcv_saddr	__sk_common.skc_v6_rcv_saddr
33cf7c90fe2f97a Eric Dumazet             2015-03-11  390  #define sk_cookie		__sk_common.skc_cookie
70da268b569d32a Eric Dumazet             2015-10-08  391  #define sk_incoming_cpu		__sk_common.skc_incoming_cpu
8e5eb54d303b7cb Eric Dumazet             2015-10-08  392  #define sk_flags		__sk_common.skc_flags
ed53d0ab761f5c7 Eric Dumazet             2015-10-08  393  #define sk_rxhash		__sk_common.skc_rxhash
efe4208f47f907b Eric Dumazet             2013-10-03  394  
43f51df41729559 Eric Dumazet             2021-11-15  395  	/* early demux fields */
8b3f91332291fa2 Jakub Kicinski           2021-12-23  396  	struct dst_entry __rcu	*sk_rx_dst;
43f51df41729559 Eric Dumazet             2021-11-15  397  	int			sk_rx_dst_ifindex;
43f51df41729559 Eric Dumazet             2021-11-15  398  	u32			sk_rx_dst_cookie;
43f51df41729559 Eric Dumazet             2021-11-15  399  
^1da177e4c3f415 Linus Torvalds           2005-04-16  400  	socket_lock_t		sk_lock;
9115e8cd2a0c6ea Eric Dumazet             2016-12-03  401  	atomic_t		sk_drops;
9115e8cd2a0c6ea Eric Dumazet             2016-12-03  402  	int			sk_rcvlowat;
9115e8cd2a0c6ea Eric Dumazet             2016-12-03  403  	struct sk_buff_head	sk_error_queue;
b178bb3dfc30d95 Eric Dumazet             2010-11-16  404  	struct sk_buff_head	sk_receive_queue;
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  405  	/*
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  406  	 * The backlog queue is special, it is always used with
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  407  	 * the per-socket spinlock held and requires low latency
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  408  	 * access. Therefore we special case it's implementation.
b178bb3dfc30d95 Eric Dumazet             2010-11-16  409  	 * Note : rmem_alloc is in this structure to fill a hole
b178bb3dfc30d95 Eric Dumazet             2010-11-16  410  	 * on 64bit arches, not because its logically part of
b178bb3dfc30d95 Eric Dumazet             2010-11-16  411  	 * backlog.
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  412  	 */
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  413  	struct {
b178bb3dfc30d95 Eric Dumazet             2010-11-16  414  		atomic_t	rmem_alloc;
b178bb3dfc30d95 Eric Dumazet             2010-11-16  415  		int		len;
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  416  		struct sk_buff	*head;
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  417  		struct sk_buff	*tail;
fa438ccfdfd3f6d Eric Dumazet             2007-03-04  418  	} sk_backlog;
f35f821935d8df7 Eric Dumazet             2021-11-15  419  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
