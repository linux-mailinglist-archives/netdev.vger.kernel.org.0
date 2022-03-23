Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287724E4FCB
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 10:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbiCWJ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 05:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239268AbiCWJz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 05:55:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0A73981F;
        Wed, 23 Mar 2022 02:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648029269; x=1679565269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Pq3Mxa4sYWX4SOyl+DQncQHs2F6Qt9ZYcjkHglN9/g=;
  b=hFF6t0f9+RECjBin6KpVmaxBSRYSXbMBNSs1+dgszSC/lTln/PuZfDuC
   GJna0ZXQEt9mmvrYn5Y99pRaxbYgYs4J3xMAYv2dZlomooapHRblGlJep
   kgsH+6nBFwHA6k3jNkxMvwOPDKFOtiv2Y2EuYkrjtU/x/Jh4ZtUPscsel
   9KAYizhb+wCjFq2Z5edj7QWpWNnSoEtPRe/NF6IN1kcd0neNbd/Ne33Ui
   dbxQQSGc+h8t0tVtgJEC+b2qbDyqeel2zgtJ+vuY1SZ+C89Gg7+JLCscQ
   0buxxbfM7GhREKpF6fkh0NemQ16K+TSmp9MddM9zmLZciWvP1sbbXsUKy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="240231810"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="240231810"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:54:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="500947205"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2022 02:54:25 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWxhA-000Jvt-Np; Wed, 23 Mar 2022 09:54:24 +0000
Date:   Wed, 23 Mar 2022 17:54:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Haowen Bai <baihaowen@meizu.com>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen@meizu.com>
Subject: Re: [PATCH] netfilter: ipset: Fix duplicate included
 ip_set_hash_gen.h
Message-ID: <202203231755.kTKFL9CC-lkp@intel.com>
References: <1648005894-28708-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648005894-28708-1-git-send-email-baihaowen@meizu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haowen,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on nf-next/master]
[also build test ERROR on nf/master horms-ipvs/master linus/master v5.17 next-20220322]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Haowen-Bai/netfilter-ipset-Fix-duplicate-included-ip_set_hash_gen-h/20220323-112624
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: hexagon-buildonly-randconfig-r002-20220323 (https://download.01.org/0day-ci/archive/20220323/202203231755.kTKFL9CC-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 902f4708fe1d03b0de7e5315ef875006a6adc319)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/72385b9d8008746d7517220588291a692dd0d8c3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Haowen-Bai/netfilter-ipset-Fix-duplicate-included-ip_set_hash_gen-h/20220323-112624
        git checkout 72385b9d8008746d7517220588291a692dd0d8c3
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/usb/dwc3/ net/netfilter/ipset/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/ipset/ip_set_hash_ipportip.c:341:17: error: incomplete definition of type 'struct hash_ipportip6'
                   port = ntohs(h->next.port);
                                ~^
   include/linux/byteorder/generic.h:142:27: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                             ^
   include/linux/byteorder/generic.h:137:35: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                                     ^
   include/uapi/linux/byteorder/little_endian.h:43:59: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                                                             ^
   include/uapi/linux/swab.h:105:32: note: expanded from macro '__swab16'
           (__builtin_constant_p((__u16)(x)) ?     \
                                         ^
   net/netfilter/ipset/ip_set_hash_ipportip.c:279:15: note: forward declaration of 'struct hash_ipportip6'
           const struct hash_ipportip6 *h = set->data;
                        ^
>> net/netfilter/ipset/ip_set_hash_ipportip.c:341:17: error: incomplete definition of type 'struct hash_ipportip6'
                   port = ntohs(h->next.port);
                                ~^
   include/linux/byteorder/generic.h:142:27: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                             ^
   include/linux/byteorder/generic.h:137:35: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                                     ^
   include/uapi/linux/byteorder/little_endian.h:43:59: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:15:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0x00ffU) << 8) |                  \
                     ^
   net/netfilter/ipset/ip_set_hash_ipportip.c:279:15: note: forward declaration of 'struct hash_ipportip6'
           const struct hash_ipportip6 *h = set->data;
                        ^
>> net/netfilter/ipset/ip_set_hash_ipportip.c:341:17: error: incomplete definition of type 'struct hash_ipportip6'
                   port = ntohs(h->next.port);
                                ~^
   include/linux/byteorder/generic.h:142:27: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                             ^
   include/linux/byteorder/generic.h:137:35: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                                     ^
   include/uapi/linux/byteorder/little_endian.h:43:59: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                                                             ^
   include/uapi/linux/swab.h:106:21: note: expanded from macro '__swab16'
           ___constant_swab16(x) :                 \
                              ^
   include/uapi/linux/swab.h:16:12: note: expanded from macro '___constant_swab16'
           (((__u16)(x) & (__u16)0xff00U) >> 8)))
                     ^
   net/netfilter/ipset/ip_set_hash_ipportip.c:279:15: note: forward declaration of 'struct hash_ipportip6'
           const struct hash_ipportip6 *h = set->data;
                        ^
>> net/netfilter/ipset/ip_set_hash_ipportip.c:341:17: error: incomplete definition of type 'struct hash_ipportip6'
                   port = ntohs(h->next.port);
                                ~^
   include/linux/byteorder/generic.h:142:27: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                             ^
   include/linux/byteorder/generic.h:137:35: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                                     ^
   include/uapi/linux/byteorder/little_endian.h:43:59: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                                                             ^
   include/uapi/linux/swab.h:107:12: note: expanded from macro '__swab16'
           __fswab16(x))
                     ^
   net/netfilter/ipset/ip_set_hash_ipportip.c:279:15: note: forward declaration of 'struct hash_ipportip6'
           const struct hash_ipportip6 *h = set->data;
                        ^
>> net/netfilter/ipset/ip_set_hash_ipportip.c:363:13: error: use of undeclared identifier 'hash_ipportip_create'
           .create         = hash_ipportip_create,
                             ^
   5 errors generated.


vim +341 net/netfilter/ipset/ip_set_hash_ipportip.c

5663bc30e6114b Jozsef Kadlecsik 2011-02-01  274  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  275  static int
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  276  hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
3d14b171f004f7 Jozsef Kadlecsik 2011-06-16  277  		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  278  {
21956ab290f7f3 Jozsef Kadlecsik 2015-06-26  279  	const struct hash_ipportip6 *h = set->data;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  280  	ipset_adtfn adtfn = set->variant->adt[adt];
94729f8a1e9d38 Mark Rustad      2014-08-05  281  	struct hash_ipportip6_elem e = {  .ip = { .all = { 0 } } };
ca134ce86451f3 Jozsef Kadlecsik 2013-09-07  282  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  283  	u32 port, port_to;
5e0c1eb7e6b619 Jozsef Kadlecsik 2011-03-20  284  	bool with_ports = false;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  285  	int ret;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  286  
a212e08e8e0a5c Sergey Popovich  2015-06-12  287  	if (tb[IPSET_ATTR_LINENO])
a212e08e8e0a5c Sergey Popovich  2015-06-12  288  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
a212e08e8e0a5c Sergey Popovich  2015-06-12  289  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  290  	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  291  		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
2c227f278a92ca Sergey Popovich  2015-06-12  292  		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  293  		return -IPSET_ERR_PROTOCOL;
2c227f278a92ca Sergey Popovich  2015-06-12  294  	if (unlikely(tb[IPSET_ATTR_IP_TO]))
2c227f278a92ca Sergey Popovich  2015-06-12  295  		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
2c227f278a92ca Sergey Popovich  2015-06-12  296  	if (unlikely(tb[IPSET_ATTR_CIDR])) {
2c227f278a92ca Sergey Popovich  2015-06-12  297  		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
2c227f278a92ca Sergey Popovich  2015-06-12  298  
2c227f278a92ca Sergey Popovich  2015-06-12  299  		if (cidr != HOST_MASK)
2c227f278a92ca Sergey Popovich  2015-06-12  300  			return -IPSET_ERR_INVALID_CIDR;
2c227f278a92ca Sergey Popovich  2015-06-12  301  	}
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  302  
8e55d2e5903e46 Sergey Popovich  2015-05-02  303  	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
8e55d2e5903e46 Sergey Popovich  2015-05-02  304  	if (ret)
8e55d2e5903e46 Sergey Popovich  2015-05-02  305  		return ret;
8e55d2e5903e46 Sergey Popovich  2015-05-02  306  
8e55d2e5903e46 Sergey Popovich  2015-05-02  307  	ret = ip_set_get_extensions(set, tb, &ext);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  308  	if (ret)
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  309  		return ret;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  310  
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  311  	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip2);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  312  	if (ret)
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  313  		return ret;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  314  
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  315  	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  316  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  317  	if (tb[IPSET_ATTR_PROTO]) {
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  318  		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  319  		with_ports = ip_set_proto_with_ports(e.proto);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  320  
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  321  		if (e.proto == 0)
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  322  			return -IPSET_ERR_INVALID_PROTO;
ca0f6a5cd99e0c Jozsef Kadlecsik 2015-06-13  323  	} else {
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  324  		return -IPSET_ERR_MISSING_PROTO;
ca0f6a5cd99e0c Jozsef Kadlecsik 2015-06-13  325  	}
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  326  
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  327  	if (!(with_ports || e.proto == IPPROTO_ICMPV6))
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  328  		e.port = 0;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  329  
5e0c1eb7e6b619 Jozsef Kadlecsik 2011-03-20  330  	if (adt == IPSET_TEST || !with_ports || !tb[IPSET_ATTR_PORT_TO]) {
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  331  		ret = adtfn(set, &e, &ext, &ext, flags);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  332  		return ip_set_eexist(ret, flags) ? 0 : ret;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  333  	}
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  334  
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  335  	port = ntohs(e.port);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  336  	port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  337  	if (port > port_to)
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  338  		swap(port, port_to);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  339  
3d14b171f004f7 Jozsef Kadlecsik 2011-06-16  340  	if (retried)
6e27c9b4ee8f34 Jozsef Kadlecsik 2012-09-21 @341  		port = ntohs(h->next.port);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  342  	for (; port <= port_to; port++) {
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  343  		e.port = htons(port);
5d50e1d88336a9 Jozsef Kadlecsik 2013-04-08  344  		ret = adtfn(set, &e, &ext, &ext, flags);
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  345  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  346  		if (ret && !ip_set_eexist(ret, flags))
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  347  			return ret;
ca0f6a5cd99e0c Jozsef Kadlecsik 2015-06-13  348  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  349  		ret = 0;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  350  	}
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  351  	return ret;
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  352  }
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  353  
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  354  static struct ip_set_type hash_ipportip_type __read_mostly = {
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  355  	.name		= "hash:ip,port,ip",
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  356  	.protocol	= IPSET_PROTOCOL,
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  357  	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT | IPSET_TYPE_IP2,
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  358  	.dimension	= IPSET_DIM_THREE,
c15f1c83251049 Jan Engelhardt   2012-02-14  359  	.family		= NFPROTO_UNSPEC,
35b8dcf8c3a0be Jozsef Kadlecsik 2013-04-30  360  	.revision_min	= IPSET_TYPE_REV_MIN,
35b8dcf8c3a0be Jozsef Kadlecsik 2013-04-30  361  	.revision_max	= IPSET_TYPE_REV_MAX,
ccf0a4b7fc6885 Jozsef Kadlecsik 2020-10-29  362  	.create_flags[IPSET_TYPE_REV_MAX] = IPSET_CREATE_FLAG_BUCKETSIZE,
5663bc30e6114b Jozsef Kadlecsik 2011-02-01 @363  	.create		= hash_ipportip_create,
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  364  	.create_policy	= {
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  365  		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  366  		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
3976ca101990ca Jozsef Kadlecsik 2020-10-29  367  		[IPSET_ATTR_INITVAL]	= { .type = NLA_U32 },
ccf0a4b7fc6885 Jozsef Kadlecsik 2020-10-29  368  		[IPSET_ATTR_BUCKETSIZE]	= { .type = NLA_U8 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  369  		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  370  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
00d71b270eedac Jozsef Kadlecsik 2013-04-08  371  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  372  	},
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  373  	.adt_policy	= {
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  374  		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  375  		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  376  		[IPSET_ATTR_IP2]	= { .type = NLA_NESTED },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  377  		[IPSET_ATTR_PORT]	= { .type = NLA_U16 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  378  		[IPSET_ATTR_PORT_TO]	= { .type = NLA_U16 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  379  		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  380  		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  381  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  382  		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
00d71b270eedac Jozsef Kadlecsik 2013-04-08  383  		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
00d71b270eedac Jozsef Kadlecsik 2013-04-08  384  		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
037261866c8dd1 Sergey Popovich  2015-05-02  385  		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
037261866c8dd1 Sergey Popovich  2015-05-02  386  					    .len  = IPSET_MAX_COMMENT_SIZE },
af331419d34e2f Anton Danilov    2014-08-28  387  		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
af331419d34e2f Anton Danilov    2014-08-28  388  		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
af331419d34e2f Anton Danilov    2014-08-28  389  		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  390  	},
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  391  	.me		= THIS_MODULE,
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  392  };
5663bc30e6114b Jozsef Kadlecsik 2011-02-01  393  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
