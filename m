Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0071B524E05
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354102AbiELNQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354107AbiELNQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:16:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B08246422
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652361396; x=1683897396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ogSFe5+N4nfpX2ISTaJnUttdGEDRDowhdMQWekK35GQ=;
  b=kLI4OnOV/JT4uDpk46qel489qFFNYRCWfAKSBMZpzlPQ002VYVvIaSTr
   U7dyeI0UkzNFYS2k/eSgzBP/jk9AGIhbwP42R49WZ5z4XszrVqUeCz4ME
   gl+zjhUTD+ltn9pSHHcpoc8p2EhRrpTv4RolwDgbb8fdro9WFo67wzwNa
   TKuDnvdDdVm6nJQsxBHM8kqi0y/tIBbjIJo+aiT56md04cBVylxrFsfpa
   rSOFStu7M07EyVfRqY+vKGPDen5VV9QoC705nx1fiy/TzhtwFDKYvN9jq
   i91EAkQCr2zexSPbt5b9jnDN3JafJ5Sm4V9q9P6mdpD4/e8bsGiykeNDo
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="295246340"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="295246340"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 06:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="711912032"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 12 May 2022 06:15:21 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1np8f2-000KSQ-Ho;
        Thu, 12 May 2022 13:15:20 +0000
Date:   Thu, 12 May 2022 21:15:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 10/10] inet: add READ_ONCE(sk->sk_bound_dev_if)
 in INET_MATCH()
Message-ID: <202205122132.HUrst9JA-lkp@intel.com>
References: <20220511233757.2001218-11-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511233757.2001218-11-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b57c7e8b76c646cf77ce4353a779a8b781592209
config: hexagon-randconfig-r035-20220512 (https://download.01.org/0day-ci/archive/20220512/202205122132.HUrst9JA-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c92cfd9f3ecb483ff055edb02f7498494b96ba68
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
        git checkout c92cfd9f3ecb483ff055edb02f7498494b96ba68
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/inet_hashtables.c:413:34: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
                   if (likely(INET_MATCH(sk, net, acookie,
                                                  ^~~~~~~
   include/linux/compiler.h:77:40: note: expanded from macro 'likely'
   # define likely(x)      __builtin_expect(!!(x), 1)
                                               ^
   net/ipv4/inet_hashtables.c:398:2: note: variable 'acookie' is declared here
           INET_ADDR_COOKIE(acookie, saddr, daddr);
           ^
   include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
           const int __name __deprecated __always_unused
           ^
   net/ipv4/inet_hashtables.c:468:35: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
                   if (likely(INET_MATCH(sk2, net, acookie,
                                                   ^~~~~~~
   include/linux/compiler.h:77:40: note: expanded from macro 'likely'
   # define likely(x)      __builtin_expect(!!(x), 1)
                                               ^
   net/ipv4/inet_hashtables.c:452:2: note: variable 'acookie' is declared here
           INET_ADDR_COOKIE(acookie, saddr, daddr);
           ^
   include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
           const int __name __deprecated __always_unused
           ^
   net/ipv4/inet_hashtables.c:535:38: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
                           if (unlikely(INET_MATCH(esk, net, acookie,
                                                             ^~~~~~~
   include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                                               ^
   net/ipv4/inet_hashtables.c:529:2: note: variable 'acookie' is declared here
           INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
           ^
   include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
           const int __name __deprecated __always_unused
           ^
   3 warnings generated.
--
>> net/ipv4/udp.c:2566:27: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
                   if (INET_MATCH(sk, net, acookie, rmt_addr,
                                           ^~~~~~~
   net/ipv4/udp.c:2561:2: note: variable 'acookie' is declared here
           INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
           ^
   include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
           const int __name __deprecated __always_unused
           ^
   1 warning generated.


vim +/acookie +413 net/ipv4/inet_hashtables.c

2c13270b441054 Eric Dumazet     2015-03-15  391  
c67499c0e77206 Pavel Emelyanov  2008-01-31  392  struct sock *__inet_lookup_established(struct net *net,
c67499c0e77206 Pavel Emelyanov  2008-01-31  393  				  struct inet_hashinfo *hashinfo,
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  394  				  const __be32 saddr, const __be16 sport,
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  395  				  const __be32 daddr, const u16 hnum,
3fa6f616a7a4d0 David Ahern      2017-08-07  396  				  const int dif, const int sdif)
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  397  {
c7228317441f4d Joe Perches      2014-05-13  398  	INET_ADDR_COOKIE(acookie, saddr, daddr);
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  399  	const __portpair ports = INET_COMBINED_PORTS(sport, hnum);
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  400  	struct sock *sk;
3ab5aee7fe840b Eric Dumazet     2008-11-16  401  	const struct hlist_nulls_node *node;
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  402  	/* Optimize here for direct hit, only listening connections can
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  403  	 * have wildcards anyways.
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  404  	 */
9f26b3add3783c Pavel Emelyanov  2008-06-16  405  	unsigned int hash = inet_ehashfn(net, daddr, hnum, saddr, sport);
f373b53b5fe67a Eric Dumazet     2009-10-09  406  	unsigned int slot = hash & hashinfo->ehash_mask;
3ab5aee7fe840b Eric Dumazet     2008-11-16  407  	struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  408  
3ab5aee7fe840b Eric Dumazet     2008-11-16  409  begin:
3ab5aee7fe840b Eric Dumazet     2008-11-16  410  	sk_nulls_for_each_rcu(sk, node, &head->chain) {
ce43b03e888947 Eric Dumazet     2012-11-30  411  		if (sk->sk_hash != hash)
ce43b03e888947 Eric Dumazet     2012-11-30  412  			continue;
ce43b03e888947 Eric Dumazet     2012-11-30 @413  		if (likely(INET_MATCH(sk, net, acookie,
3fa6f616a7a4d0 David Ahern      2017-08-07  414  				      saddr, daddr, ports, dif, sdif))) {
41c6d650f6537e Reshetova, Elena 2017-06-30  415  			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
05dbc7b59481ca Eric Dumazet     2013-10-03  416  				goto out;
ce43b03e888947 Eric Dumazet     2012-11-30  417  			if (unlikely(!INET_MATCH(sk, net, acookie,
3fa6f616a7a4d0 David Ahern      2017-08-07  418  						 saddr, daddr, ports,
3fa6f616a7a4d0 David Ahern      2017-08-07  419  						 dif, sdif))) {
05dbc7b59481ca Eric Dumazet     2013-10-03  420  				sock_gen_put(sk);
3ab5aee7fe840b Eric Dumazet     2008-11-16  421  				goto begin;
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  422  			}
05dbc7b59481ca Eric Dumazet     2013-10-03  423  			goto found;
3ab5aee7fe840b Eric Dumazet     2008-11-16  424  		}
3ab5aee7fe840b Eric Dumazet     2008-11-16  425  	}
3ab5aee7fe840b Eric Dumazet     2008-11-16  426  	/*
3ab5aee7fe840b Eric Dumazet     2008-11-16  427  	 * if the nulls value we got at the end of this lookup is
3ab5aee7fe840b Eric Dumazet     2008-11-16  428  	 * not the expected one, we must restart lookup.
3ab5aee7fe840b Eric Dumazet     2008-11-16  429  	 * We probably met an item that was moved to another chain.
3ab5aee7fe840b Eric Dumazet     2008-11-16  430  	 */
3ab5aee7fe840b Eric Dumazet     2008-11-16  431  	if (get_nulls_value(node) != slot)
3ab5aee7fe840b Eric Dumazet     2008-11-16  432  		goto begin;
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  433  out:
05dbc7b59481ca Eric Dumazet     2013-10-03  434  	sk = NULL;
05dbc7b59481ca Eric Dumazet     2013-10-03  435  found:
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  436  	return sk;
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  437  }
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  438  EXPORT_SYMBOL_GPL(__inet_lookup_established);
77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  439  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
