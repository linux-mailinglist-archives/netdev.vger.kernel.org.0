Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C4F6E2E1A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjDOBFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDOBFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:05:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C590B6EAC;
        Fri, 14 Apr 2023 18:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681520706; x=1713056706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YadCIFp7qXS3fGf+iESblqvLzbqgHuBEFkoxK4yjqMQ=;
  b=FHZkrstO+SUc7aHQNXeqO3jfMzoJztwIsKfLR3m0yZtW9BQnL5vOmGPD
   tfHLqwKcrmVmsHKnH1/YFXwd4vCzDLce7tCNIbx1itCKMDXO519nd1y17
   F3+86M3Oy5QRgfLM6Y2ifbWCvco+efV3ugN/b4olQbyqfOcgTzSr5S+fZ
   nNsgtOLVOFoGnEIOcftOP2groKL+z9g5jjKBX5LwIBjpDwAgo8eVYQXCK
   A/d+/homz9ABmI1DRaNZLB+6KAMMEz4cqNG3pIrw0FRFbFY3e+PeJSj/Z
   SnS00LwY/aAskgWT/SyzW6V3DC3GT3Wf6lpoy723JSMl9Y5JPvD5HWeHa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="324225308"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="324225308"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 18:05:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="640287600"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="640287600"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 14 Apr 2023 18:05:01 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnULd-000aD9-0c;
        Sat, 15 Apr 2023 01:05:01 +0000
Date:   Sat, 15 Apr 2023 09:04:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
Subject: Re: [PATCH bpf-next] bpf: Set skb redirect and from_ingress info in
 __bpf_tx_skb
Message-ID: <202304150811.bzx9niRq-lkp@intel.com>
References: <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Borkmann/bpf-Set-skb-redirect-and-from_ingress-info-in-__bpf_tx_skb/20230415-065912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/c68bf723-3406-d177-49b4-6d5b485048de%40iogearbox.net
patch subject: [PATCH bpf-next] bpf: Set skb redirect and from_ingress info in __bpf_tx_skb
config: x86_64-randconfig-a014-20230410 (https://download.01.org/0day-ci/archive/20230415/202304150811.bzx9niRq-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/91c0d1d0b071c23d95bf9747b89daf5ae378ad1a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Borkmann/bpf-Set-skb-redirect-and-from_ingress-info-in-__bpf_tx_skb/20230415-065912
        git checkout 91c0d1d0b071c23d95bf9747b89daf5ae378ad1a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304150811.bzx9niRq-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/core/filter.c: In function '__bpf_tx_skb':
>> net/core/filter.c:2125:44: error: 'struct sk_buff' has no member named 'tc_at_ingress'
    2125 |         skb_set_redirected_noclear(skb, skb->tc_at_ingress);
         |                                            ^~


vim +2125 net/core/filter.c

  2113	
  2114	static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  2115	{
  2116		int ret;
  2117	
  2118		if (dev_xmit_recursion()) {
  2119			net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
  2120			kfree_skb(skb);
  2121			return -ENETDOWN;
  2122		}
  2123	
  2124		skb->dev = dev;
> 2125		skb_set_redirected_noclear(skb, skb->tc_at_ingress);
  2126		skb_clear_tstamp(skb);
  2127	
  2128		dev_xmit_recursion_inc();
  2129		ret = dev_queue_xmit(skb);
  2130		dev_xmit_recursion_dec();
  2131	
  2132		return ret;
  2133	}
  2134	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
