Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C53A4B2DEC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352942AbiBKTmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:42:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiBKTmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:42:10 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E68CFA;
        Fri, 11 Feb 2022 11:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644608528; x=1676144528;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EiCSs2kWJXbzTK79rbOFxGrhnm7bfaJipIrZL+urUfc=;
  b=DgMp8UTgboxAJLM6zSKWzqxemqhHHgT3HtpQmoioC1GS3Hmulcpvesb9
   iRm4gzpA1kR+cMOdNqehCL7EBRfNghlwTd7V5EtH8fpXdfcbbP4d/c/5o
   06DBEVDFRyoSHEHXTr2aP0PbwMBloAMzMTsKCGVCWxhxIxPvfL1AVNnwG
   IyjTRTcUHitVVY6jGY93rgXW+IOosYZXtwvdOhQxF5m0WDzkAUA22YaQL
   o3EE4Jy37UZiDelbFNM9mR43J80i99GHZeXOIV7RCXHhkAUKHN6kexZUU
   3T9V/I40Bbx2YLE94zi8B0nJaDN/+00GoiSdgAVYuMgcEXABcapI8V7DL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="230440027"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="230440027"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 11:42:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="702217409"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 11 Feb 2022 11:42:06 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nIbnx-00056T-HZ; Fri, 11 Feb 2022 19:42:05 +0000
Date:   Sat, 12 Feb 2022 03:42:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>
Subject: Re: [PATCH] net: Fix build when CONFIG_INET is not enabled
Message-ID: <202202120329.TB5XJjoH-lkp@intel.com>
References: <20220211164026.409225-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211164026.409225-1-ribalda@chromium.org>
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

Hi Ricardo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.17-rc3 next-20220211]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ricardo-Ribalda/net-Fix-build-when-CONFIG_INET-is-not-enabled/20220212-004127
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5b91c5cc0e7be4e41567cb2a6e21a8bb682c7cc5
config: arc-randconfig-r043-20220211 (https://download.01.org/0day-ci/archive/20220212/202202120329.TB5XJjoH-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f9b7fbd36ce386e1b9fb64f316878a4e011c1a09
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ricardo-Ribalda/net-Fix-build-when-CONFIG_INET-is-not-enabled/20220212-004127
        git checkout f9b7fbd36ce386e1b9fb64f316878a4e011c1a09
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/sock.c:2061:6: warning: no previous prototype for '__sk_defer_free_flush' [-Wmissing-prototypes]
    2061 | void __sk_defer_free_flush(struct sock *sk)
         |      ^~~~~~~~~~~~~~~~~~~~~


vim +/__sk_defer_free_flush +2061 net/core/sock.c

  2060	
> 2061	void __sk_defer_free_flush(struct sock *sk)
  2062	{
  2063		struct llist_node *head;
  2064		struct sk_buff *skb, *n;
  2065	
  2066		head = llist_del_all(&sk->defer_list);
  2067		llist_for_each_entry_safe(skb, n, head, ll_node) {
  2068			prefetch(n);
  2069			skb_mark_not_on_list(skb);
  2070			__kfree_skb(skb);
  2071		}
  2072	}
  2073	EXPORT_SYMBOL(__sk_defer_free_flush);
  2074	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
