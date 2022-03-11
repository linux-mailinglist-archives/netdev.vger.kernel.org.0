Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4574D640B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbiCKOqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiCKOqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:46:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C34156C64;
        Fri, 11 Mar 2022 06:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647009915; x=1678545915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7LbjHEqhdCfxOUrQm6jFYDaSElmVbgEZZgNs9J2dKIY=;
  b=AfVRQ2qeKZwOM0Qip0lyBvmr8jA+aNDibWBjSKly3/jX27Oc+eqJK1tZ
   EF7L0paTFXv/41xP6I0e4MENo06ca9a4iKY51JkCS0i+DNLo7L0yk6mI+
   08D1EkxhcSzaU2B3hCJ1BBchMHEWXDRipqNNFO4RsAHgfMyzg+E2fI37c
   tbYkYpHawP43UckcW2SK/SuzkfJPmVAljIs0naQvT4KU2rk7WmYbakxeX
   O9afCCnhuT7tsd9TYEM7b2YTbFiGEnFtehDeGczJ97W0OO7XCuOL98Pcj
   1e19L/1Ju4g3wmlIKX5/4/Arw0XLYas3liuGjBjxApegFQcgCEnxV6NoB
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255771653"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="255771653"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 06:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="644947997"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 11 Mar 2022 06:45:11 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSgVy-0006ZV-LU; Fri, 11 Mar 2022 14:45:10 +0000
Date:   Fri, 11 Mar 2022 22:44:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH 1/3] net:ipv6:Add ndisc_bond_send_na to support sending
 na by slave directly
Message-ID: <202203112242.Gjf5MZjs-lkp@intel.com>
References: <20220311024958.7458-2-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311024958.7458-2-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 2a9eef868a997ec575c2e6ae885e91313f635d59]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
base:   2a9eef868a997ec575c2e6ae885e91313f635d59
config: mips-bmips_be_defconfig (https://download.01.org/0day-ci/archive/20220311/202203112242.Gjf5MZjs-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9bd4966a283f758f100bd97d09967edc92903c76
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
        git checkout 9bd4966a283f758f100bd97d09967edc92903c76
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv6/ndisc.c: In function 'ndisc_bond_send_na':
>> net/ipv6/ndisc.c:587:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
     587 |         int ret;
         |             ^~~


vim +/ret +587 net/ipv6/ndisc.c

   574	
   575	void ndisc_bond_send_na(struct net_device *dev, const struct in6_addr *daddr,
   576				const struct in6_addr *solicited_addr,
   577				bool router, bool solicited, bool override,
   578				bool inc_opt, unsigned short vlan_id,
   579				const void *mac_dst, const void *mac_src)
   580	{
   581		struct sk_buff *skb;
   582		const struct in6_addr *src_addr;
   583		struct nd_msg *msg;
   584		struct net *net = dev_net(dev);
   585		struct sock *sk = net->ipv6.ndisc_sk;
   586		int optlen = 0;
 > 587		int ret;
   588	
   589		src_addr = solicited_addr;
   590		if (!dev->addr_len)
   591			inc_opt = false;
   592		if (inc_opt)
   593			optlen += ndisc_opt_addr_space(dev,
   594						       NDISC_NEIGHBOUR_ADVERTISEMENT);
   595	
   596		skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
   597		if (!skb)
   598			return;
   599	
   600		msg = skb_put(skb, sizeof(*msg));
   601		*msg = (struct nd_msg) {
   602			.icmph = {
   603				.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT,
   604				.icmp6_router = router,
   605				.icmp6_solicited = solicited,
   606				.icmp6_override = override,
   607			},
   608			.target = *solicited_addr,
   609		};
   610	
   611		if (inc_opt)
   612			ndisc_fill_addr_option(skb, ND_OPT_TARGET_LL_ADDR,
   613					       dev->dev_addr,
   614					       NDISC_NEIGHBOUR_ADVERTISEMENT);
   615	
   616		if (vlan_id)
   617			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
   618					       vlan_id);
   619	
   620		msg->icmph.icmp6_cksum = csum_ipv6_magic(src_addr, daddr, skb->len,
   621							 IPPROTO_ICMPV6,
   622							 csum_partial(&msg->icmph,
   623								      skb->len, 0));
   624	
   625		ip6_nd_hdr(skb, src_addr, daddr, inet6_sk(sk)->hop_limit, skb->len);
   626	
   627		skb->protocol = htons(ETH_P_IPV6);
   628		skb->dev = dev;
   629		if (dev_hard_header(skb, dev, ETH_P_IPV6, mac_dst, mac_src, skb->len) < 0)
   630			return;
   631	
   632		ret = dev_queue_xmit(skb);
   633	}
   634	EXPORT_SYMBOL(ndisc_bond_send_na);
   635	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
