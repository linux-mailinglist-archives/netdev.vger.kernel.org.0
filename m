Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E1C499EAB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345643AbiAXWlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:41:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:63722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1589198AbiAXWfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 17:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643063716; x=1674599716;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gs5uFgkarw9TrpxSXanR98HstBe7M+jbd4pZwSe/TDA=;
  b=eGBlceNs3vwAthJZMi902BjXo5ZAau7U48CAiDhPpkjb/7/M1KF3Ylpp
   aNQGEXMY6b8urGq39pPDML3qLji5Ev4LNOKa4htrENh91ISIkJqTubGRl
   kkFQgdR23R2xXGCbRkwq+EY1rNdORS/6GJUGgg7mbpxQmHCbX7F211yUz
   znWgbew10zUs98j3tEwwIbyAduw9a1v9ErOEpZCjiXMBwqw5wGk5Zg0DT
   1o8oF9G/AqqLZOZQstp8WRUlv/k4MpPq9GIPFA/D5Zt2n8eDZS/53sS5q
   fbB39xuuwLZii33M6kEIy13sNZofFJqdVqV6hhiylmeFsiTNXbMicgW9D
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="306877364"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="306877364"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 14:25:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="627671702"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 24 Jan 2022 14:25:10 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC7lt-000J0O-QV; Mon, 24 Jan 2022 22:25:09 +0000
Date:   Tue, 25 Jan 2022 06:24:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyjilinux@gmail.com, jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
Message-ID: <202201250449.tTXEfxm8-lkp@intel.com>
References: <20220122000301.1872828-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122000301.1872828-1-jeffreyji@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeffrey,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jeffrey-Ji/net-core-add-InMacErrors-counter/20220122-080455
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8aaaf2f3af2ae212428f4db1af34214225f5cec3
config: mips-maltaaprp_defconfig (https://download.01.org/0day-ci/archive/20220125/202201250449.tTXEfxm8-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 7b3d30728816403d1fd73cc5082e9fb761262bce)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/0day-ci/linux/commit/f8ea346d278c116f830459bae2a910fdc5e96a35
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jeffrey-Ji/net-core-add-InMacErrors-counter/20220122-080455
        git checkout f8ea346d278c116f830459bae2a910fdc5e96a35
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv6/ip6_input.c:153:24: warning: variable 'idev' is uninitialized when used here [-Wuninitialized]
                   __IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
                                        ^~~~
   include/net/ipv6.h:256:26: note: expanded from macro '__IP6_INC_STATS'
                   _DEVINC(net, ipv6, __, idev, field)
                                          ^~~~
   include/net/ipv6.h:211:29: note: expanded from macro '_DEVINC'
           struct inet6_dev *_idev = (idev);                               \
                                      ^~~~
   net/ipv6/ip6_input.c:150:24: note: initialize the variable 'idev' to silence this warning
           struct inet6_dev *idev;
                                 ^
                                  = NULL
   1 warning generated.


vim +/idev +153 net/ipv6/ip6_input.c

   144	
   145	static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
   146					    struct net *net)
   147	{
   148		const struct ipv6hdr *hdr;
   149		u32 pkt_len;
   150		struct inet6_dev *idev;
   151	
   152		if (skb->pkt_type == PACKET_OTHERHOST) {
 > 153			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
   154			kfree_skb(skb);
   155			return NULL;
   156		}
   157	
   158		rcu_read_lock();
   159	
   160		idev = __in6_dev_get(skb->dev);
   161	
   162		__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
   163	
   164		if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
   165		    !idev || unlikely(idev->cnf.disable_ipv6)) {
   166			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
   167			goto drop;
   168		}
   169	
   170		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
   171	
   172		/*
   173		 * Store incoming device index. When the packet will
   174		 * be queued, we cannot refer to skb->dev anymore.
   175		 *
   176		 * BTW, when we send a packet for our own local address on a
   177		 * non-loopback interface (e.g. ethX), it is being delivered
   178		 * via the loopback interface (lo) here; skb->dev = loopback_dev.
   179		 * It, however, should be considered as if it is being
   180		 * arrived via the sending interface (ethX), because of the
   181		 * nature of scoping architecture. --yoshfuji
   182		 */
   183		IP6CB(skb)->iif = skb_valid_dst(skb) ? ip6_dst_idev(skb_dst(skb))->dev->ifindex : dev->ifindex;
   184	
   185		if (unlikely(!pskb_may_pull(skb, sizeof(*hdr))))
   186			goto err;
   187	
   188		hdr = ipv6_hdr(skb);
   189	
   190		if (hdr->version != 6)
   191			goto err;
   192	
   193		__IP6_ADD_STATS(net, idev,
   194				IPSTATS_MIB_NOECTPKTS +
   195					(ipv6_get_dsfield(hdr) & INET_ECN_MASK),
   196				max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
   197		/*
   198		 * RFC4291 2.5.3
   199		 * The loopback address must not be used as the source address in IPv6
   200		 * packets that are sent outside of a single node. [..]
   201		 * A packet received on an interface with a destination address
   202		 * of loopback must be dropped.
   203		 */
   204		if ((ipv6_addr_loopback(&hdr->saddr) ||
   205		     ipv6_addr_loopback(&hdr->daddr)) &&
   206		    !(dev->flags & IFF_LOOPBACK) &&
   207		    !netif_is_l3_master(dev))
   208			goto err;
   209	
   210		/* RFC4291 Errata ID: 3480
   211		 * Interface-Local scope spans only a single interface on a
   212		 * node and is useful only for loopback transmission of
   213		 * multicast.  Packets with interface-local scope received
   214		 * from another node must be discarded.
   215		 */
   216		if (!(skb->pkt_type == PACKET_LOOPBACK ||
   217		      dev->flags & IFF_LOOPBACK) &&
   218		    ipv6_addr_is_multicast(&hdr->daddr) &&
   219		    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 1)
   220			goto err;
   221	
   222		/* If enabled, drop unicast packets that were encapsulated in link-layer
   223		 * multicast or broadcast to protected against the so-called "hole-196"
   224		 * attack in 802.11 wireless.
   225		 */
   226		if (!ipv6_addr_is_multicast(&hdr->daddr) &&
   227		    (skb->pkt_type == PACKET_BROADCAST ||
   228		     skb->pkt_type == PACKET_MULTICAST) &&
   229		    idev->cnf.drop_unicast_in_l2_multicast)
   230			goto err;
   231	
   232		/* RFC4291 2.7
   233		 * Nodes must not originate a packet to a multicast address whose scope
   234		 * field contains the reserved value 0; if such a packet is received, it
   235		 * must be silently dropped.
   236		 */
   237		if (ipv6_addr_is_multicast(&hdr->daddr) &&
   238		    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 0)
   239			goto err;
   240	
   241		/*
   242		 * RFC4291 2.7
   243		 * Multicast addresses must not be used as source addresses in IPv6
   244		 * packets or appear in any Routing header.
   245		 */
   246		if (ipv6_addr_is_multicast(&hdr->saddr))
   247			goto err;
   248	
   249		skb->transport_header = skb->network_header + sizeof(*hdr);
   250		IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
   251	
   252		pkt_len = ntohs(hdr->payload_len);
   253	
   254		/* pkt_len may be zero if Jumbo payload option is present */
   255		if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
   256			if (pkt_len + sizeof(struct ipv6hdr) > skb->len) {
   257				__IP6_INC_STATS(net,
   258						idev, IPSTATS_MIB_INTRUNCATEDPKTS);
   259				goto drop;
   260			}
   261			if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr))) {
   262				__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
   263				goto drop;
   264			}
   265			hdr = ipv6_hdr(skb);
   266		}
   267	
   268		if (hdr->nexthdr == NEXTHDR_HOP) {
   269			if (ipv6_parse_hopopts(skb) < 0) {
   270				__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
   271				rcu_read_unlock();
   272				return NULL;
   273			}
   274		}
   275	
   276		rcu_read_unlock();
   277	
   278		/* Must drop socket now because of tproxy. */
   279		if (!skb_sk_is_prefetched(skb))
   280			skb_orphan(skb);
   281	
   282		return skb;
   283	err:
   284		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
   285	drop:
   286		rcu_read_unlock();
   287		kfree_skb(skb);
   288		return NULL;
   289	}
   290	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
