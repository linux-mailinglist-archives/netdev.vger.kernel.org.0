Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37968498D98
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 20:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353287AbiAXTdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 14:33:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:25935 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353011AbiAXTbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 14:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643052707; x=1674588707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5XG7X738CWvd7suN2wlyDFHC/wjdaa796xjLxBwionw=;
  b=IOXOBzWnzHIypJQ7BMvnS8hJOvXGnVStfQ5OCPLIZizn9QPTxscXZkVu
   WCvT09dBd7wjcPvcpK/n7Hf1ZVu3Tyl2syTLDXEcOWm4ugmxvgcxPKX8p
   gYV/B6uRZ9hPt0PLvrY3ofJK2RrKMbG98nQqrz7VdR1w4Rghb0Cn1ZevO
   WvfWdSGKv+CPv/p9OjiyB0D2WQElBlrn8KN3qUC8MlVnpTgGAIsH2QVh5
   JegTTmH+mOvyZgLrjXebv8JVWdIrm07W5FFn0w2ih8jwi3L+57+0F0O1U
   PcvotWPCjJG9o4Ww9Cxz8AL3kTdb+jmPiM+36P72L+AXc9VB9PZ61MhMj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="270567026"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="270567026"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 11:24:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="596884144"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2022 11:24:03 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC4wc-000Inp-KR; Mon, 24 Jan 2022 19:24:02 +0000
Date:   Tue, 25 Jan 2022 03:23:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com
Cc:     kbuild-all@lists.01.org, dsahern@gmail.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] ipv6: gro: flush instead of assuming different flows
 on hop_limit mismatch
Message-ID: <202201250210.roaIok2H-lkp@intel.com>
References: <20220121011941.1123392-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121011941.1123392-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/ipv6-gro-flush-instead-of-assuming-different-flows-on-hop_limit-mismatch/20220121-092033
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 57afdc0aab094b4c811b3fe030b2567812a495f3
config: x86_64-randconfig-s022 (https://download.01.org/0day-ci/archive/20220125/202201250210.roaIok2H-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/6f8f3e541288381a67df8b670068d5add231d082
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/ipv6-gro-flush-instead-of-assuming-different-flows-on-hop_limit-mismatch/20220121-092033
        git checkout 6f8f3e541288381a67df8b670068d5add231d082
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/ipv6/ip6_offload.c:264:57: sparse: sparse: restricted __be32 degrades to integer
>> net/ipv6/ip6_offload.c:263:48: sparse: sparse: dubious: x | !y

vim +264 net/ipv6/ip6_offload.c

   182	
   183	INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
   184								 struct sk_buff *skb)
   185	{
   186		const struct net_offload *ops;
   187		struct sk_buff *pp = NULL;
   188		struct sk_buff *p;
   189		struct ipv6hdr *iph;
   190		unsigned int nlen;
   191		unsigned int hlen;
   192		unsigned int off;
   193		u16 flush = 1;
   194		int proto;
   195	
   196		off = skb_gro_offset(skb);
   197		hlen = off + sizeof(*iph);
   198		iph = skb_gro_header_fast(skb, off);
   199		if (skb_gro_header_hard(skb, hlen)) {
   200			iph = skb_gro_header_slow(skb, hlen, off);
   201			if (unlikely(!iph))
   202				goto out;
   203		}
   204	
   205		skb_set_network_header(skb, off);
   206		skb_gro_pull(skb, sizeof(*iph));
   207		skb_set_transport_header(skb, skb_gro_offset(skb));
   208	
   209		flush += ntohs(iph->payload_len) != skb_gro_len(skb);
   210	
   211		proto = iph->nexthdr;
   212		ops = rcu_dereference(inet6_offloads[proto]);
   213		if (!ops || !ops->callbacks.gro_receive) {
   214			__pskb_pull(skb, skb_gro_offset(skb));
   215			skb_gro_frag0_invalidate(skb);
   216			proto = ipv6_gso_pull_exthdrs(skb, proto);
   217			skb_gro_pull(skb, -skb_transport_offset(skb));
   218			skb_reset_transport_header(skb);
   219			__skb_push(skb, skb_gro_offset(skb));
   220	
   221			ops = rcu_dereference(inet6_offloads[proto]);
   222			if (!ops || !ops->callbacks.gro_receive)
   223				goto out;
   224	
   225			iph = ipv6_hdr(skb);
   226		}
   227	
   228		NAPI_GRO_CB(skb)->proto = proto;
   229	
   230		flush--;
   231		nlen = skb_network_header_len(skb);
   232	
   233		list_for_each_entry(p, head, list) {
   234			const struct ipv6hdr *iph2;
   235			__be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
   236	
   237			if (!NAPI_GRO_CB(p)->same_flow)
   238				continue;
   239	
   240			iph2 = (struct ipv6hdr *)(p->data + off);
   241			first_word = *(__be32 *)iph ^ *(__be32 *)iph2;
   242	
   243			/* All fields must match except length and Traffic Class.
   244			 * XXX skbs on the gro_list have all been parsed and pulled
   245			 * already so we don't need to compare nlen
   246			 * (nlen != (sizeof(*iph2) + ipv6_exthdrs_len(iph2, &ops)))
   247			 * memcmp() alone below is sufficient, right?
   248			 */
   249			 if ((first_word & htonl(0xF00FFFFF)) ||
   250			     !ipv6_addr_equal(&iph->saddr, &iph2->saddr) ||
   251			     !ipv6_addr_equal(&iph->daddr, &iph2->daddr) ||
   252			     iph->nexthdr != iph2->nexthdr) {
   253	not_same_flow:
   254				NAPI_GRO_CB(p)->same_flow = 0;
   255				continue;
   256			}
   257			if (unlikely(nlen > sizeof(struct ipv6hdr))) {
   258				if (memcmp(iph + 1, iph2 + 1,
   259					   nlen - sizeof(struct ipv6hdr)))
   260					goto not_same_flow;
   261			}
   262			/* flush if Traffic Class fields are different */
 > 263			NAPI_GRO_CB(p)->flush |= flush |
 > 264						 !!((first_word & htonl(0x0FF00000)) |
   265						    (iph->hop_limit ^ iph2->hop_limit));
   266	
   267			/* If the previous IP ID value was based on an atomic
   268			 * datagram we can overwrite the value and ignore it.
   269			 */
   270			if (NAPI_GRO_CB(skb)->is_atomic)
   271				NAPI_GRO_CB(p)->flush_id = 0;
   272		}
   273	
   274		NAPI_GRO_CB(skb)->is_atomic = true;
   275		NAPI_GRO_CB(skb)->flush |= flush;
   276	
   277		skb_gro_postpull_rcsum(skb, iph, nlen);
   278	
   279		pp = indirect_call_gro_receive_l4(tcp6_gro_receive, udp6_gro_receive,
   280						 ops->callbacks.gro_receive, head, skb);
   281	
   282	out:
   283		skb_gro_flush_final(skb, pp, flush);
   284	
   285		return pp;
   286	}
   287	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
