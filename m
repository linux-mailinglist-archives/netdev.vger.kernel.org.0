Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071C25501D4
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383747AbiFRCCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFRCCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:02:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F006B7F0
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 19:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655517723; x=1687053723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jvu10h+sYyh7/7s2bgyGQ+s8/ke53P3C4qEHrc0pt6I=;
  b=Wa9QHTmNmzl/NaZ5E/sqAKabw8yoqLIXOU71JLa+iZvX22BQBwbnSU/D
   Og2Y+muGGbPZxVUkNGGwcq6khs9kURjzwbYtUCzl+aGTd3ot93p0iUSwZ
   Hru9LgHUmULDKTvR3ZMiQKY5oLw+3bYNiGro6DvmDlYBJUu19AKekchkv
   iQoPS6QHI6lp2QJNpm4Gg49cqxDXi/ribVvlAUJFpib4accVpLxtAkCm7
   2sh/3fRAk6E5Bpct+GTUJ6Nm+WJyHbKfOml2BqFXEEkltFbfkvBaIoqp2
   Z4/y++l/ZQ6dCPBCgvhr7cRQ8V6kpBST52KoBb9VaVta7wLfKxuXK79Wq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="305050191"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="305050191"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 19:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="642265817"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2022 19:02:01 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o2Nmj-000Pvh-1Z;
        Sat, 18 Jun 2022 02:02:01 +0000
Date:   Sat, 18 Jun 2022 10:01:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] raw: use more conventional iterators
Message-ID: <202206180947.vsH21eY4-lkp@intel.com>
References: <20220617201045.2659460-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617201045.2659460-2-eric.dumazet@gmail.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/raw-RCU-conversion/20220618-041145
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4875d94c69d5a4836c4225b51429d277c297aae8
config: x86_64-randconfig-a013 (https://download.01.org/0day-ci/archive/20220618/202206180947.vsH21eY4-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/6862039427583c2b85bdda50f45ece5b79ed5fa5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/raw-RCU-conversion/20220618-041145
        git checkout 6862039427583c2b85bdda50f45ece5b79ed5fa5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv4/ net/ipv6/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv4/raw.c: In function 'raw_v4_input':
>> net/ipv4/raw.c:167:9: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     167 |         int sdif = inet_sdif(skb);
         |         ^~~
   net/ipv4/raw.c: In function 'raw_icmp_error':
   net/ipv4/raw.c:268:9: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     268 |         int dif = skb->dev->ifindex;
         |         ^~~
--
   net/ipv6/raw.c: In function 'raw6_icmp_error':
>> net/ipv6/raw.c:338:40: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
     338 |         const struct in6_addr *saddr, *daddr;
         |                                        ^~~~~
>> net/ipv6/raw.c:338:32: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
     338 |         const struct in6_addr *saddr, *daddr;
         |                                ^~~~~


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
