Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E7047F43E
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 19:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhLYSau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 13:30:50 -0500
Received: from mga05.intel.com ([192.55.52.43]:41701 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhLYSat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Dec 2021 13:30:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640457049; x=1671993049;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OVE9TRA+bNJZniOgx5+yTsSXDdWXbWMruv+MitYmk0o=;
  b=idDyo/5LM8Pe/Dq9KBafz+X4Bjebx9dbYbifzgkR+Xg+IABno6Q05r1V
   Lmpz1m9uog29ub7z7CppXfOEJOYmO7FwjaHVSgtExtnTdTzR3YSYz92Zo
   xCvJmKjClzFPkHBfg9PuvrCT+QkU5lmmKGhCzgI3IsPdeGbkuZavzQzK7
   M4zKy8vXLRist9rOo3dFg2EpBMRJp3mgoBHF68aPirmt8GOKlq3V+5Jp2
   ENdF8CEB4gf0dRyeliCPsv0m0uNuaIAq51Uuav1BZRbOx1NcuFpAtTy3q
   BiTgN1zkXMBIhQOvDTQRYp+QjosZ4m8m9hKtCo8NzTivBk5B7cTlNLZIn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10208"; a="327387539"
X-IronPort-AV: E=Sophos;i="5.88,235,1635231600"; 
   d="scan'208";a="327387539"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2021 10:30:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,235,1635231600"; 
   d="scan'208";a="588035340"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 25 Dec 2021 10:30:46 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n1Bob-0004bW-ST; Sat, 25 Dec 2021 18:30:45 +0000
Date:   Sun, 26 Dec 2021 02:30:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yan Yan <evitayan@google.com>, steffen.klassert@secunet.com
Cc:     kbuild-all@lists.01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org, nharold@google.com,
        benedictwong@google.com, maze@google.com, lorenzo@google.com,
        Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v1 1/2] xfrm: Check if_id in xfrm_migrate
Message-ID: <202112260218.oyI4rj2f-lkp@intel.com>
References: <20211223004555.1284666-2-evitayan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223004555.1284666-2-evitayan@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on klassert-ipsec-next/master]
[also build test ERROR on klassert-ipsec/master net-next/master net/master v5.16-rc6 next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Yan-Yan/Fix-issues-in-xfrm_migrate/20211223-084725
base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20211226/202112260218.oyI4rj2f-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/a1b1a05814d4ac913aa4af753da7e116a3d58342
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Yan-Yan/Fix-issues-in-xfrm_migrate/20211223-084725
        git checkout a1b1a05814d4ac913aa4af753da7e116a3d58342
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/gpio/ net/key/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/key/af_key.c: In function 'pfkey_migrate':
>> net/key/af_key.c:2625:9: error: too few arguments to function 'xfrm_migrate'
    2625 |  return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
         |         ^~~~~~~~~~~~
   In file included from net/key/af_key.c:28:
   include/net/xfrm.h:1683:5: note: declared here
    1683 | int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
         |     ^~~~~~~~~~~~


vim +/xfrm_migrate +2625 net/key/af_key.c

08de61beab8a21 Shinta Sugimoto   2007-02-08  2539  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2540  static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
4c93fbb0626080 David S. Miller   2011-02-25  2541  			 const struct sadb_msg *hdr, void * const *ext_hdrs)
08de61beab8a21 Shinta Sugimoto   2007-02-08  2542  {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2543  	int i, len, ret, err = -EINVAL;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2544  	u8 dir;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2545  	struct sadb_address *sa;
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2546  	struct sadb_x_kmaddress *kma;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2547  	struct sadb_x_policy *pol;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2548  	struct sadb_x_ipsecrequest *rq;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2549  	struct xfrm_selector sel;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2550  	struct xfrm_migrate m[XFRM_MAX_DEPTH];
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2551  	struct xfrm_kmaddress k;
8d549c4f5d92d8 Fan Du            2013-11-07  2552  	struct net *net = sock_net(sk);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2553  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2554  	if (!present_and_same_family(ext_hdrs[SADB_EXT_ADDRESS_SRC - 1],
08de61beab8a21 Shinta Sugimoto   2007-02-08  2555  				     ext_hdrs[SADB_EXT_ADDRESS_DST - 1]) ||
08de61beab8a21 Shinta Sugimoto   2007-02-08  2556  	    !ext_hdrs[SADB_X_EXT_POLICY - 1]) {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2557  		err = -EINVAL;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2558  		goto out;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2559  	}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2560  
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2561  	kma = ext_hdrs[SADB_X_EXT_KMADDRESS - 1];
08de61beab8a21 Shinta Sugimoto   2007-02-08  2562  	pol = ext_hdrs[SADB_X_EXT_POLICY - 1];
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2563  
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2564  	if (pol->sadb_x_policy_dir >= IPSEC_DIR_MAX) {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2565  		err = -EINVAL;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2566  		goto out;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2567  	}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2568  
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2569  	if (kma) {
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2570  		/* convert sadb_x_kmaddress to xfrm_kmaddress */
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2571  		k.reserved = kma->sadb_x_kmaddress_reserved;
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2572  		ret = parse_sockaddr_pair((struct sockaddr *)(kma + 1),
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2573  					  8*(kma->sadb_x_kmaddress_len) - sizeof(*kma),
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2574  					  &k.local, &k.remote, &k.family);
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2575  		if (ret < 0) {
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2576  			err = ret;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2577  			goto out;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2578  		}
13c1d18931ebb5 Arnaud Ebalard    2008-10-05  2579  	}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2580  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2581  	dir = pol->sadb_x_policy_dir - 1;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2582  	memset(&sel, 0, sizeof(sel));
08de61beab8a21 Shinta Sugimoto   2007-02-08  2583  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2584  	/* set source address info of selector */
08de61beab8a21 Shinta Sugimoto   2007-02-08  2585  	sa = ext_hdrs[SADB_EXT_ADDRESS_SRC - 1];
08de61beab8a21 Shinta Sugimoto   2007-02-08  2586  	sel.family = pfkey_sadb_addr2xfrm_addr(sa, &sel.saddr);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2587  	sel.prefixlen_s = sa->sadb_address_prefixlen;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2588  	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2589  	sel.sport = ((struct sockaddr_in *)(sa + 1))->sin_port;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2590  	if (sel.sport)
582ee43dad8e41 Al Viro           2007-07-26  2591  		sel.sport_mask = htons(0xffff);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2592  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2593  	/* set destination address info of selector */
47162c0b7e26ef Himangi Saraogi   2014-05-30  2594  	sa = ext_hdrs[SADB_EXT_ADDRESS_DST - 1];
08de61beab8a21 Shinta Sugimoto   2007-02-08  2595  	pfkey_sadb_addr2xfrm_addr(sa, &sel.daddr);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2596  	sel.prefixlen_d = sa->sadb_address_prefixlen;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2597  	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2598  	sel.dport = ((struct sockaddr_in *)(sa + 1))->sin_port;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2599  	if (sel.dport)
582ee43dad8e41 Al Viro           2007-07-26  2600  		sel.dport_mask = htons(0xffff);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2601  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2602  	rq = (struct sadb_x_ipsecrequest *)(pol + 1);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2603  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2604  	/* extract ipsecrequests */
08de61beab8a21 Shinta Sugimoto   2007-02-08  2605  	i = 0;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2606  	len = pol->sadb_x_policy_len * 8 - sizeof(struct sadb_x_policy);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2607  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2608  	while (len > 0 && i < XFRM_MAX_DEPTH) {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2609  		ret = ipsecrequests_to_migrate(rq, len, &m[i]);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2610  		if (ret < 0) {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2611  			err = ret;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2612  			goto out;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2613  		} else {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2614  			rq = (struct sadb_x_ipsecrequest *)((u8 *)rq + ret);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2615  			len -= ret;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2616  			i++;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2617  		}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2618  	}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2619  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2620  	if (!i || len > 0) {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2621  		err = -EINVAL;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2622  		goto out;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2623  	}
08de61beab8a21 Shinta Sugimoto   2007-02-08  2624  
13c1d18931ebb5 Arnaud Ebalard    2008-10-05 @2625  	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
4ab47d47af20ad Antony Antony     2017-06-06  2626  			    kma ? &k : NULL, net, NULL);
08de61beab8a21 Shinta Sugimoto   2007-02-08  2627  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2628   out:
08de61beab8a21 Shinta Sugimoto   2007-02-08  2629  	return err;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2630  }
08de61beab8a21 Shinta Sugimoto   2007-02-08  2631  #else
08de61beab8a21 Shinta Sugimoto   2007-02-08  2632  static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
7f6daa635c28ed Stephen Hemminger 2011-03-01  2633  			 const struct sadb_msg *hdr, void * const *ext_hdrs)
08de61beab8a21 Shinta Sugimoto   2007-02-08  2634  {
08de61beab8a21 Shinta Sugimoto   2007-02-08  2635  	return -ENOPROTOOPT;
08de61beab8a21 Shinta Sugimoto   2007-02-08  2636  }
08de61beab8a21 Shinta Sugimoto   2007-02-08  2637  #endif
08de61beab8a21 Shinta Sugimoto   2007-02-08  2638  
08de61beab8a21 Shinta Sugimoto   2007-02-08  2639  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
