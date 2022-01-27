Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6998149D717
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiA0BBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:01:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:32193 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbiA0BBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 20:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643245290; x=1674781290;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DAgA9YulK7fnXAcKv3+GS4wlxKo/uqt5AGyP2nVTVAI=;
  b=Zm0WhWBi1Fb+u4nSNuSHmro3ChNFUEYCjrwCTK2DG55yFbgn2YscinSJ
   PVU3D4e6lKXN4Lp39F5MEa1PyQrkw1cECl8rlQeZL9HYAhtwnvOGVL/Iy
   3zM+Dh8n2ABWFq/nkfisWYa8f5aMej8sAVyYWWB2/gBuMUhABuTFr9k3W
   ZUmg1udQetFLeIWcili3nxA527L/UodIOVwZ6j3JS9S2OR2GVLsnAJ5Wg
   StUu4dBdw53cKMh4Z4jR7guRvsHBLpjE0RMLtKtyaooQD/a3mQP0QLWS3
   pDgQ+hXzxjHsMPncSQGGaD0YhAjau4UFx2TbYrqVk7QOY3R/qlAwWb5qM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="271160733"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="271160733"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 17:01:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="532939487"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 26 Jan 2022 17:01:28 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCtAF-000Lt7-BD; Thu, 27 Jan 2022 01:01:27 +0000
Date:   Thu, 27 Jan 2022 09:00:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
Message-ID: <202201270807.HsUjGLC8-lkp@intel.com>
References: <20220126200518.990670-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126200518.990670-2-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/ipv4-less-uses-of-shared-IP-generator/20220127-040810
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 429c3be8a5e2695b5b92a6a12361eb89eb185495
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220127/202201270807.HsUjGLC8-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/37d3b618591c7c736c2ad3b3febe12779e01369c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/ipv4-less-uses-of-shared-IP-generator/20220127-040810
        git checkout 37d3b618591c7c736c2ad3b3febe12779e01369c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/ipv4/ip_output.c:175:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] id @@     got unsigned int @@
   net/ipv4/ip_output.c:175:33: sparse:     expected restricted __be16 [usertype] id
   net/ipv4/ip_output.c:175:33: sparse:     got unsigned int
   net/ipv4/ip_output.c: note: in included file (through include/net/ip.h):
   include/net/route.h:373:48: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned int [usertype] key @@     got restricted __be32 [usertype] daddr @@
   include/net/route.h:373:48: sparse:     expected unsigned int [usertype] key
   include/net/route.h:373:48: sparse:     got restricted __be32 [usertype] daddr
   include/net/route.h:373:48: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned int [usertype] key @@     got restricted __be32 [usertype] daddr @@
   include/net/route.h:373:48: sparse:     expected unsigned int [usertype] key
   include/net/route.h:373:48: sparse:     got restricted __be32 [usertype] daddr

vim +175 net/ipv4/ip_output.c

   140	
   141	/*
   142	 *		Add an ip header to a skbuff and send it out.
   143	 *
   144	 */
   145	int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
   146				  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt,
   147				  u8 tos)
   148	{
   149		struct inet_sock *inet = inet_sk(sk);
   150		struct rtable *rt = skb_rtable(skb);
   151		struct net *net = sock_net(sk);
   152		struct iphdr *iph;
   153	
   154		/* Build the IP header. */
   155		skb_push(skb, sizeof(struct iphdr) + (opt ? opt->opt.optlen : 0));
   156		skb_reset_network_header(skb);
   157		iph = ip_hdr(skb);
   158		iph->version  = 4;
   159		iph->ihl      = 5;
   160		iph->tos      = tos;
   161		iph->ttl      = ip_select_ttl(inet, &rt->dst);
   162		iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
   163		iph->saddr    = saddr;
   164		iph->protocol = sk->sk_protocol;
   165		/* Do not bother generating IPID for small packets (eg SYNACK) */
   166		if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
   167			iph->frag_off = htons(IP_DF);
   168			iph->id = 0;
   169		} else {
   170			iph->frag_off = 0;
   171			/* TCP packets here are SYNACK with fat IPv4/TCP options.
   172			 * Avoid using the hashed IP ident generator.
   173			 */
   174			if (sk->sk_protocol == IPPROTO_TCP)
 > 175				iph->id = prandom_u32();
   176			else
   177				__ip_select_ident(net, iph, 1);
   178		}
   179	
   180		if (opt && opt->opt.optlen) {
   181			iph->ihl += opt->opt.optlen>>2;
   182			ip_options_build(skb, &opt->opt, daddr, rt, 0);
   183		}
   184	
   185		skb->priority = sk->sk_priority;
   186		if (!skb->mark)
   187			skb->mark = sk->sk_mark;
   188	
   189		/* Send it out. */
   190		return ip_local_out(net, skb->sk, skb);
   191	}
   192	EXPORT_SYMBOL_GPL(ip_build_and_send_pkt);
   193	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
