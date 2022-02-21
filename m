Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA504BD3A0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 03:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbiBUCMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 21:12:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240648AbiBUCM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 21:12:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F05065FE
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 18:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645409526; x=1676945526;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yobwH7ooFl46ZNYvRs2OIMJHVkI1RHDpLaPzG2BDUkA=;
  b=Yn/hJ8qRczmOCMbRdKUtBUoUuIOL0iXwiXo8Qfwyt9IXb0AD0QPi2I5h
   R23GNnFmfEsBDZwbA2nhBRaeFNlE708FWSbJ0ZUxK1B80wHle/em0kgLV
   40S8yhvkOzSFtNLPerxCPslQcPGyFxOuGpjZuts2hCzB1T+hjRM79eAiM
   JBvlmHACGNuCt4rLBiKp2lAg6ZfEGx5s/sX9h2mYq7w2e+MLZoa5tSi9y
   y80fvDjYbz6c7LGpFhyCoHuseMQSY5AIqUEtCEaH/tMdV05WDAJd+bu7E
   Figlo7yzXK9+D01SohFpjHYBcscF+FkIPFNqYrwrzdP2U44eLaYhUWwKa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251368097"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251368097"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 18:12:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="636500725"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 20 Feb 2022 18:12:02 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLyBG-0001BH-2s; Mon, 21 Feb 2022 02:12:02 +0000
Date:   Mon, 21 Feb 2022 10:11:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roopa Prabhu <roopa@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com, idosch@nvidia.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 11/12] drivers: vxlan: vnifilter: per vni stats
Message-ID: <202202211055.sxjukMsT-lkp@intel.com>
References: <20220220140405.1646839-12-roopa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220140405.1646839-12-roopa@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roopa,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Roopa-Prabhu/vxlan-metadata-device-vnifiltering-support/20220220-220748
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 129c77b5692d4a95a00aa7d58075afe77179623e
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220221/202202211055.sxjukMsT-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ebc9d58021bf3de80a5f6b094758abc46d3cd4c4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Roopa-Prabhu/vxlan-metadata-device-vnifiltering-support/20220220-220748
        git checkout ebc9d58021bf3de80a5f6b094758abc46d3cd4c4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/vxlan/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/vxlan/vxlan_core.c:948:5: warning: no previous prototype for function 'vxlan_fdb_update_existing' [-Wmissing-prototypes]
   int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
       ^
   drivers/net/vxlan/vxlan_core.c:948:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
   ^
   static 
   drivers/net/vxlan/vxlan_core.c:2437:14: warning: variable 'label' set but not used [-Wunused-but-set-variable]
           __be32 vni, label;
                       ^
>> drivers/net/vxlan/vxlan_core.c:2483:7: warning: variable 'vni' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                   if (!info) {
                       ^~~~~
   drivers/net/vxlan/vxlan_core.c:2662:31: note: uninitialized use occurs here
           vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_DROPS, 0);
                                        ^~~
   drivers/net/vxlan/vxlan_core.c:2483:3: note: remove the 'if' if its condition is always false
                   if (!info) {
                   ^~~~~~~~~~~~
>> drivers/net/vxlan/vxlan_core.c:2450:8: warning: variable 'vni' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                           if (did_rsc) {
                               ^~~~~~~
   drivers/net/vxlan/vxlan_core.c:2662:31: note: uninitialized use occurs here
           vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_DROPS, 0);
                                        ^~~
   drivers/net/vxlan/vxlan_core.c:2450:4: note: remove the 'if' if its condition is always true
                           if (did_rsc) {
                           ^~~~~~~~~~~~~
   drivers/net/vxlan/vxlan_core.c:2437:12: note: initialize the variable 'vni' to silence this warning
           __be32 vni, label;
                     ^
                      = 0
   4 warnings generated.


vim +2483 drivers/net/vxlan/vxlan_core.c

fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2421  
4ad169300a7350 drivers/net/vxlan.c            Stephen Hemminger   2013-06-17  2422  static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
3ad7a4b141ebd6 drivers/net/vxlan.c            Roopa Prabhu        2017-01-31  2423  			   __be32 default_vni, struct vxlan_rdst *rdst,
3ad7a4b141ebd6 drivers/net/vxlan.c            Roopa Prabhu        2017-01-31  2424  			   bool did_rsc)
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2425  {
d71785ffc7e7ca drivers/net/vxlan.c            Paolo Abeni         2016-02-12  2426  	struct dst_cache *dst_cache;
3093fbe7ff4bc7 drivers/net/vxlan.c            Thomas Graf         2015-07-21  2427  	struct ip_tunnel_info *info;
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2428  	struct vxlan_dev *vxlan = netdev_priv(dev);
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2429  	const struct iphdr *old_iph = ip_hdr(skb);
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2430  	union vxlan_addr *dst;
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2431  	union vxlan_addr remote_ip, local_ip;
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2432  	struct vxlan_metadata _md;
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2433  	struct vxlan_metadata *md = &_md;
ebc9d58021bf3d drivers/net/vxlan/vxlan_core.c Nikolay Aleksandrov 2022-02-20  2434  	unsigned int pkt_len = skb->len;
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2435  	__be16 src_port = 0, dst_port;
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2436  	struct dst_entry *ndst = NULL;
e7f70af111f086 drivers/net/vxlan.c            Daniel Borkmann     2016-03-09  2437  	__be32 vni, label;
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2438  	__u8 tos, ttl;
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2439  	int ifindex;
0e6fbc5b6c6218 drivers/net/vxlan.c            Pravin B Shelar     2013-06-17  2440  	int err;
dc5321d79697db drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2441  	u32 flags = vxlan->cfg.flags;
b4ed5cad24c107 drivers/net/vxlan.c            Jiri Benc           2016-02-02  2442  	bool udp_sum = false;
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2443  	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
e4f67addf158f9 drivers/net/vxlan.c            David Stevens       2012-11-20  2444  
61adedf3e3f1d3 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2445  	info = skb_tunnel_info(skb);
3093fbe7ff4bc7 drivers/net/vxlan.c            Thomas Graf         2015-07-21  2446  
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2447  	if (rdst) {
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2448  		dst = &rdst->remote_ip;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2449  		if (vxlan_addr_any(dst)) {
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13 @2450  			if (did_rsc) {
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2451  				/* short-circuited back to local bridge */
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2452  				vxlan_encap_bypass(skb, vxlan, vxlan,
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2453  						   default_vni, true);
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2454  				return;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2455  			}
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2456  			goto drop;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2457  		}
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2458  
0dfbdf4102b930 drivers/net/vxlan.c            Thomas Graf         2015-07-21  2459  		dst_port = rdst->remote_port ? rdst->remote_port : vxlan->cfg.dst_port;
3ad7a4b141ebd6 drivers/net/vxlan.c            Roopa Prabhu        2017-01-31  2460  		vni = (rdst->remote_vni) ? : default_vni;
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2461  		ifindex = rdst->remote_ifindex;
1158632b5a2dcc drivers/net/vxlan.c            Brian Russell       2017-02-24  2462  		local_ip = vxlan->cfg.saddr;
d71785ffc7e7ca drivers/net/vxlan.c            Paolo Abeni         2016-02-12  2463  		dst_cache = &rdst->dst_cache;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2464  		md->gbp = skb->mark;
72f6d71e491e6c drivers/net/vxlan.c            Hangbin Liu         2018-04-17  2465  		if (flags & VXLAN_F_TTL_INHERIT) {
72f6d71e491e6c drivers/net/vxlan.c            Hangbin Liu         2018-04-17  2466  			ttl = ip_tunnel_get_ttl(old_iph, skb);
72f6d71e491e6c drivers/net/vxlan.c            Hangbin Liu         2018-04-17  2467  		} else {
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2468  			ttl = vxlan->cfg.ttl;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2469  			if (!ttl && vxlan_addr_multicast(dst))
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2470  				ttl = 1;
72f6d71e491e6c drivers/net/vxlan.c            Hangbin Liu         2018-04-17  2471  		}
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2472  
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2473  		tos = vxlan->cfg.tos;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2474  		if (tos == 1)
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2475  			tos = ip_tunnel_get_dsfield(old_iph, skb);
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2476  
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2477  		if (dst->sa.sa_family == AF_INET)
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2478  			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM_TX);
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2479  		else
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2480  			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2481  		label = vxlan->cfg.label;
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2482  	} else {
435be28b0789b3 drivers/net/vxlan.c            Jakub Kicinski      2020-09-25 @2483  		if (!info) {
435be28b0789b3 drivers/net/vxlan.c            Jakub Kicinski      2020-09-25  2484  			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
435be28b0789b3 drivers/net/vxlan.c            Jakub Kicinski      2020-09-25  2485  				  dev->name);
435be28b0789b3 drivers/net/vxlan.c            Jakub Kicinski      2020-09-25  2486  			goto drop;
435be28b0789b3 drivers/net/vxlan.c            Jakub Kicinski      2020-09-25  2487  		}
b1be00a6c39fda drivers/net/vxlan.c            Jiri Benc           2015-09-24  2488  		remote_ip.sa.sa_family = ip_tunnel_info_af(info);
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2489  		if (remote_ip.sa.sa_family == AF_INET) {
c1ea5d672aaff0 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2490  			remote_ip.sin.sin_addr.s_addr = info->key.u.ipv4.dst;
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2491  			local_ip.sin.sin_addr.s_addr = info->key.u.ipv4.src;
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2492  		} else {
a725e514dbb444 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2493  			remote_ip.sin6.sin6_addr = info->key.u.ipv6.dst;
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2494  			local_ip.sin6.sin6_addr = info->key.u.ipv6.src;
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2495  		}
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2496  		dst = &remote_ip;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2497  		dst_port = info->key.tp_dst ? : vxlan->cfg.dst_port;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2498  		vni = tunnel_id_to_key32(info->key.tun_id);
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2499  		ifindex = 0;
d71785ffc7e7ca drivers/net/vxlan.c            Paolo Abeni         2016-02-12  2500  		dst_cache = &info->dst_cache;
eadf52cf185219 drivers/net/vxlan.c            Xin Long            2019-10-29  2501  		if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
eadf52cf185219 drivers/net/vxlan.c            Xin Long            2019-10-29  2502  			if (info->options_len < sizeof(*md))
eadf52cf185219 drivers/net/vxlan.c            Xin Long            2019-10-29  2503  				goto drop;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2504  			md = ip_tunnel_info_opts(info);
eadf52cf185219 drivers/net/vxlan.c            Xin Long            2019-10-29  2505  		}
7c383fb2254c44 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2506  		ttl = info->key.ttl;
7c383fb2254c44 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2507  		tos = info->key.tos;
e7f70af111f086 drivers/net/vxlan.c            Daniel Borkmann     2016-03-09  2508  		label = info->key.label;
b4ed5cad24c107 drivers/net/vxlan.c            Jiri Benc           2016-02-02  2509  		udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2510  	}
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2511  	src_port = udp_flow_src_port(dev_net(dev), skb, vxlan->cfg.port_min,
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2512  				     vxlan->cfg.port_max, true);
ee122c79d4227f drivers/net/vxlan.c            Thomas Graf         2015-07-21  2513  
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2514  	rcu_read_lock();
a725e514dbb444 drivers/net/vxlan.c            Jiri Benc           2015-08-20  2515  	if (dst->sa.sa_family == AF_INET) {
c6fcc4fc5f8b59 drivers/net/vxlan.c            pravin shelar       2016-10-28  2516  		struct vxlan_sock *sock4 = rcu_dereference(vxlan->vn4_sock);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2517  		struct rtable *rt;
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2518  		__be16 df = 0;
c6fcc4fc5f8b59 drivers/net/vxlan.c            pravin shelar       2016-10-28  2519  
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2520  		if (!ifindex)
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2521  			ifindex = sock4->sock->sk->sk_bound_dev_if;
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2522  
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2523  		rt = vxlan_get_route(vxlan, dev, sock4, skb, ifindex, tos,
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2524  				     dst->sin.sin_addr.s_addr,
1158632b5a2dcc drivers/net/vxlan.c            Brian Russell       2017-02-24  2525  				     &local_ip.sin.sin_addr.s_addr,
4ecb1d83f6abe8 drivers/net/vxlan.c            Martynas Pumputis   2017-01-11  2526  				     dst_port, src_port,
d71785ffc7e7ca drivers/net/vxlan.c            Paolo Abeni         2016-02-12  2527  				     dst_cache, info);
8ebd115bb23ac4 drivers/net/vxlan.c            David S. Miller     2016-11-15  2528  		if (IS_ERR(rt)) {
8ebd115bb23ac4 drivers/net/vxlan.c            David S. Miller     2016-11-15  2529  			err = PTR_ERR(rt);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2530  			goto tx_error;
8ebd115bb23ac4 drivers/net/vxlan.c            David S. Miller     2016-11-15  2531  		}
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2532  
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2533  		if (!info) {
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2534  			/* Bypass encapsulation if the destination is local */
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2535  			err = encap_bypass_if_local(skb, dev, vxlan, dst,
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2536  						    dst_port, ifindex, vni,
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2537  						    &rt->dst, rt->rt_flags);
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2538  			if (err)
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2539  				goto out_unlock;
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2540  
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2541  			if (vxlan->cfg.df == VXLAN_DF_SET) {
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2542  				df = htons(IP_DF);
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2543  			} else if (vxlan->cfg.df == VXLAN_DF_INHERIT) {
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2544  				struct ethhdr *eth = eth_hdr(skb);
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2545  
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2546  				if (ntohs(eth->h_proto) == ETH_P_IPV6 ||
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2547  				    (ntohs(eth->h_proto) == ETH_P_IP &&
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2548  				     old_iph->frag_off & htons(IP_DF)))
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2549  					df = htons(IP_DF);
b4d3069783bccf drivers/net/vxlan.c            Stefano Brivio      2018-11-08  2550  			}
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2551  		} else if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT) {
6ceb31ca5f65ac drivers/net/vxlan.c            Alexander Duyck     2016-02-19  2552  			df = htons(IP_DF);
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2553  		}
6ceb31ca5f65ac drivers/net/vxlan.c            Alexander Duyck     2016-02-19  2554  
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2555  		ndst = &rt->dst;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2556  		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM,
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2557  					    netif_is_any_bridge_port(dev));
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2558  		if (err < 0) {
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2559  			goto tx_error;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2560  		} else if (err) {
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2561  			if (info) {
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2562  				struct ip_tunnel_info *unclone;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2563  				struct in_addr src, dst;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2564  
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2565  				unclone = skb_tunnel_info_unclone(skb);
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2566  				if (unlikely(!unclone))
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2567  					goto tx_error;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2568  
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2569  				src = remote_ip.sin.sin_addr;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2570  				dst = local_ip.sin.sin_addr;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2571  				unclone->key.u.ipv4.src = src.s_addr;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2572  				unclone->key.u.ipv4.dst = dst.s_addr;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2573  			}
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2574  			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2575  			dst_release(ndst);
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2576  			goto out_unlock;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2577  		}
a93bf0ff449064 drivers/net/vxlan.c            Xin Long            2017-12-18  2578  
a0dced17ad9dc0 drivers/net/vxlan.c            Hangbin Liu         2020-08-05  2579  		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
0e6fbc5b6c6218 drivers/net/vxlan.c            Pravin B Shelar     2013-06-17  2580  		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2581  		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
54bfd872bf16d4 drivers/net/vxlan.c            Jiri Benc           2016-02-16  2582  				      vni, md, flags, udp_sum);
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2583  		if (err < 0)
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2584  			goto tx_error;
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2585  
1158632b5a2dcc drivers/net/vxlan.c            Brian Russell       2017-02-24  2586  		udp_tunnel_xmit_skb(rt, sock4->sock->sk, skb, local_ip.sin.sin_addr.s_addr,
af33c1adae1e09 drivers/net/vxlan.c            Tom Herbert         2015-01-20  2587  				    dst->sin.sin_addr.s_addr, tos, ttl, df,
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2588  				    src_port, dst_port, xnet, !udp_sum);
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2589  #if IS_ENABLED(CONFIG_IPV6)
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2590  	} else {
c6fcc4fc5f8b59 drivers/net/vxlan.c            pravin shelar       2016-10-28  2591  		struct vxlan_sock *sock6 = rcu_dereference(vxlan->vn6_sock);
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2592  
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2593  		if (!ifindex)
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2594  			ifindex = sock6->sock->sk->sk_bound_dev_if;
aab8cc3630e325 drivers/net/vxlan.c            Alexis Bauvin       2018-12-03  2595  
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2596  		ndst = vxlan6_get_route(vxlan, dev, sock6, skb, ifindex, tos,
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2597  					label, &dst->sin6.sin6_addr,
1158632b5a2dcc drivers/net/vxlan.c            Brian Russell       2017-02-24  2598  					&local_ip.sin6.sin6_addr,
4ecb1d83f6abe8 drivers/net/vxlan.c            Martynas Pumputis   2017-01-11  2599  					dst_port, src_port,
db3c6139e6ead9 drivers/net/vxlan.c            Daniel Borkmann     2016-03-04  2600  					dst_cache, info);
e5d4b29fe86a91 drivers/net/vxlan.c            Jiri Benc           2015-12-07  2601  		if (IS_ERR(ndst)) {
8ebd115bb23ac4 drivers/net/vxlan.c            David S. Miller     2016-11-15  2602  			err = PTR_ERR(ndst);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2603  			ndst = NULL;
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2604  			goto tx_error;
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2605  		}
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2606  
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2607  		if (!info) {
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2608  			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2609  
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2610  			err = encap_bypass_if_local(skb, dev, vxlan, dst,
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2611  						    dst_port, ifindex, vni,
49f810f00fa347 drivers/net/vxlan.c            Matthias Schiffer   2017-06-19  2612  						    ndst, rt6i_flags);
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2613  			if (err)
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2614  				goto out_unlock;
fee1fad7c73dd0 drivers/net/vxlan.c            pravin shelar       2016-11-13  2615  		}
35e2d1152b22ea drivers/net/vxlan.c            Jesse Gross         2016-01-20  2616  
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2617  		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM,
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2618  					    netif_is_any_bridge_port(dev));
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2619  		if (err < 0) {
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2620  			goto tx_error;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2621  		} else if (err) {
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2622  			if (info) {
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2623  				struct ip_tunnel_info *unclone;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2624  				struct in6_addr src, dst;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2625  
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2626  				unclone = skb_tunnel_info_unclone(skb);
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2627  				if (unlikely(!unclone))
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2628  					goto tx_error;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2629  
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2630  				src = remote_ip.sin6.sin6_addr;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2631  				dst = local_ip.sin6.sin6_addr;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2632  				unclone->key.u.ipv6.src = src;
30a93d2b7d5a7c drivers/net/vxlan.c            Antoine Tenart      2021-03-25  2633  				unclone->key.u.ipv6.dst = dst;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2634  			}
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2635  
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2636  			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2637  			dst_release(ndst);
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2638  			goto out_unlock;
fc68c99577cc66 drivers/net/vxlan.c            Stefano Brivio      2020-08-04  2639  		}
a93bf0ff449064 drivers/net/vxlan.c            Xin Long            2017-12-18  2640  
a0dced17ad9dc0 drivers/net/vxlan.c            Hangbin Liu         2020-08-05  2641  		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2642  		ttl = ttl ? : ip6_dst_hoplimit(ndst);
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2643  		skb_scrub_packet(skb, xnet);
f491e56dba511d drivers/net/vxlan.c            Jiri Benc           2016-02-02  2644  		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
54bfd872bf16d4 drivers/net/vxlan.c            Jiri Benc           2016-02-16  2645  				      vni, md, flags, udp_sum);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2646  		if (err < 0)
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2647  			goto tx_error;
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2648  
0770b53bd276a7 drivers/net/vxlan.c            pravin shelar       2016-11-13  2649  		udp_tunnel6_xmit_skb(ndst, sock6->sock->sk, skb, dev,
1158632b5a2dcc drivers/net/vxlan.c            Brian Russell       2017-02-24  2650  				     &local_ip.sin6.sin6_addr,
272d96a5ab1066 drivers/net/vxlan.c            pravin shelar       2016-08-05  2651  				     &dst->sin6.sin6_addr, tos, ttl,
e7f70af111f086 drivers/net/vxlan.c            Daniel Borkmann     2016-03-09  2652  				     label, src_port, dst_port, !udp_sum);
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2653  #endif
e4c7ed415387cf drivers/net/vxlan.c            Cong Wang           2013-08-31  2654  	}
ebc9d58021bf3d drivers/net/vxlan/vxlan_core.c Nikolay Aleksandrov 2022-02-20  2655  	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX, pkt_len);
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2656  out_unlock:
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2657  	rcu_read_unlock();
4ad169300a7350 drivers/net/vxlan.c            Stephen Hemminger   2013-06-17  2658  	return;
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2659  
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2660  drop:
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2661  	dev->stats.tx_dropped++;
ebc9d58021bf3d drivers/net/vxlan/vxlan_core.c Nikolay Aleksandrov 2022-02-20  2662  	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_DROPS, 0);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2663  	dev_kfree_skb(skb);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2664  	return;
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2665  
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2666  tx_error:
56de859e9967c0 drivers/net/vxlan.c            Jakub Kicinski      2017-02-24  2667  	rcu_read_unlock();
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2668  	if (err == -ELOOP)
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2669  		dev->stats.collisions++;
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2670  	else if (err == -ENETUNREACH)
655c3de16540b8 drivers/net/vxlan.c            pravin shelar       2016-11-13  2671  		dev->stats.tx_carrier_errors++;
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2672  	dst_release(ndst);
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2673  	dev->stats.tx_errors++;
ebc9d58021bf3d drivers/net/vxlan/vxlan_core.c Nikolay Aleksandrov 2022-02-20  2674  	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_ERRORS, 0);
c46b7897ad5ba4 drivers/net/vxlan.c            pravin shelar       2016-11-13  2675  	kfree_skb(skb);
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2676  }
d342894c5d2f8c drivers/net/vxlan.c            stephen hemminger   2012-10-01  2677  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
