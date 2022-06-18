Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF91255017E
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383561AbiFRA6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 20:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiFRA6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:58:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5414119F95
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 17:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655513884; x=1687049884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+KN9gez3gxQswyoKt22AOTbDHVUxQmSEnDp+s0L0DBA=;
  b=BM5gFygevwEofGlXpyWTYzd9U9kSOiXtPIcKz6JJMBbgKv06J38CjLkN
   ingztYA9nZRshhxH1hLOMotneRxTvvI+cVEu54PYlzymITdhn95m0l/+c
   I5XUmQwVde8EG/8+FHFd5h2VzcZFiBJoR29Y6UO01XICiXYydYsZnN1PF
   a+HNgjvJ94/rxIsRDIJRua9GesiiS1hrH1yyTe7sO8rtz/xitGYq260EZ
   oCdtZdjrvIRJRW3h1Bs7j0iiHXMrgGB5tIBIZD5XU9Cu/7Av7bHuZKwz3
   l0ZqQngXhjfgaFC6PmdvUyYIIMdwDryPJm85oFCknaL54xbkNaz5lHwIb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343606679"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343606679"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 17:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="619440733"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 17 Jun 2022 17:58:00 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2Mmm-000Ptx-3y;
        Sat, 18 Jun 2022 00:58:00 +0000
Date:   Sat, 18 Jun 2022 08:57:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] raw: use more conventional iterators
Message-ID: <202206180819.fn7MTnwO-lkp@intel.com>
References: <20220617201045.2659460-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617201045.2659460-2-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/raw-RCU-conversion/20220618-041145
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4875d94c69d5a4836c4225b51429d277c297aae8
config: hexagon-randconfig-r045-20220617 (https://download.01.org/0day-ci/archive/20220618/202206180819.fn7MTnwO-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d764aa7fc6b9cc3fbe960019018f5f9e941eb0a6)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6862039427583c2b85bdda50f45ece5b79ed5fa5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/raw-RCU-conversion/20220618-041145
        git checkout 6862039427583c2b85bdda50f45ece5b79ed5fa5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/raw.c:167:6: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
           int sdif = inet_sdif(skb);
               ^
   net/ipv4/raw.c:268:6: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
           int dif = skb->dev->ifindex;
               ^
   2 warnings generated.


vim +167 net/ipv4/raw.c

^1da177e4c3f41 Linus Torvalds   2005-04-16  157  
^1da177e4c3f41 Linus Torvalds   2005-04-16  158  /* IP input processing comes here for RAW socket delivery.
^1da177e4c3f41 Linus Torvalds   2005-04-16  159   * Caller owns SKB, so we must make clones.
^1da177e4c3f41 Linus Torvalds   2005-04-16  160   *
^1da177e4c3f41 Linus Torvalds   2005-04-16  161   * RFC 1122: SHOULD pass TOS value up to the transport layer.
^1da177e4c3f41 Linus Torvalds   2005-04-16  162   * -> It does. And not only TOS, but all IP header.
^1da177e4c3f41 Linus Torvalds   2005-04-16  163   */
b71d1d426d263b Eric Dumazet     2011-04-22  164  static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
^1da177e4c3f41 Linus Torvalds   2005-04-16  165  {
6862039427583c Eric Dumazet     2022-06-17  166  	struct net *net = dev_net(skb->dev);;
67359930e185c4 David Ahern      2017-08-07 @167  	int sdif = inet_sdif(skb);
19e4e768064a87 David Ahern      2019-05-07  168  	int dif = inet_iif(skb);
^1da177e4c3f41 Linus Torvalds   2005-04-16  169  	struct hlist_head *head;
d13964f4490157 Patrick McHardy  2005-08-09  170  	int delivered = 0;
6862039427583c Eric Dumazet     2022-06-17  171  	struct sock *sk;
^1da177e4c3f41 Linus Torvalds   2005-04-16  172  
b673e4dfc8f29e Pavel Emelyanov  2007-11-19  173  	head = &raw_v4_hashinfo.ht[hash];
^1da177e4c3f41 Linus Torvalds   2005-04-16  174  	if (hlist_empty(head))
6862039427583c Eric Dumazet     2022-06-17  175  		return 0;
6862039427583c Eric Dumazet     2022-06-17  176  	read_lock(&raw_v4_hashinfo.lock);
6862039427583c Eric Dumazet     2022-06-17  177  	sk_for_each(sk, head) {
6862039427583c Eric Dumazet     2022-06-17  178  		if (!raw_v4_match(net, sk, iph->protocol,
6862039427583c Eric Dumazet     2022-06-17  179  				  iph->saddr, iph->daddr, dif, sdif))
6862039427583c Eric Dumazet     2022-06-17  180  			continue;
d13964f4490157 Patrick McHardy  2005-08-09  181  		delivered = 1;
f5220d63991f3f Quentin Armitage 2014-07-23  182  		if ((iph->protocol != IPPROTO_ICMP || !icmp_filter(sk, skb)) &&
f5220d63991f3f Quentin Armitage 2014-07-23  183  		    ip_mc_sf_allow(sk, iph->daddr, iph->saddr,
60d9b031412435 David Ahern      2017-08-07  184  				   skb->dev->ifindex, sdif)) {
^1da177e4c3f41 Linus Torvalds   2005-04-16  185  			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
^1da177e4c3f41 Linus Torvalds   2005-04-16  186  
^1da177e4c3f41 Linus Torvalds   2005-04-16  187  			/* Not releasing hash table! */
^1da177e4c3f41 Linus Torvalds   2005-04-16  188  			if (clone)
^1da177e4c3f41 Linus Torvalds   2005-04-16  189  				raw_rcv(sk, clone);
^1da177e4c3f41 Linus Torvalds   2005-04-16  190  		}
^1da177e4c3f41 Linus Torvalds   2005-04-16  191  	}
b673e4dfc8f29e Pavel Emelyanov  2007-11-19  192  	read_unlock(&raw_v4_hashinfo.lock);
d13964f4490157 Patrick McHardy  2005-08-09  193  	return delivered;
^1da177e4c3f41 Linus Torvalds   2005-04-16  194  }
^1da177e4c3f41 Linus Torvalds   2005-04-16  195  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
