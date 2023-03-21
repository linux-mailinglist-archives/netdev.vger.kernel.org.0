Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578B56C2B4E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCUHZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCUHZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:25:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09146CA2A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679383524; x=1710919524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vmP8YZkQCvk6GSCT/H6gnlYQENOHcmfT0tCph+Nlogs=;
  b=gUnWbc0o6VAXhMQo4qEKSE1l7+1ShzkOFFXC/xKw+m0wCXAF2aRapGKN
   EBD2Gtex9fwn6VimvrGs0moeC8fokr9VZdlPt9kNVN1X1qRIsdXNygMjj
   3D0fb4mUVk9m2wIWkZ2PowjpyJumF+MAGo1NC2tbpeWpLV/Ht8XmKSzWY
   VWd9LRDUb31EFGRNsq3k4x4gOfl7ZEp5rugemkKlNB6feDY3RlIIkp/AG
   YnzcCgAZUH+BfHLq0n8VkE/IJoitNc8RKUXQKIlfnKl4Ee6wxGC92BAqI
   fTgIJHhsjQtFTSkW5YaSnLA7GHcDUtHwRsVR6V6zQEpwhgmNVvERu/yCC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322711882"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="322711882"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="683748124"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="683748124"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 00:25:18 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peWMv-000Bib-3D;
        Tue, 21 Mar 2023 07:25:17 +0000
Date:   Tue, 21 Mar 2023 15:24:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303211526.EFNmCcfA-lkp@intel.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
patch link:    https://lore.kernel.org/r/20230321033704.936685-1-eric.dumazet%40gmail.com
patch subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: sparc-randconfig-r004-20230319 (https://download.01.org/0day-ci/archive/20230321/202303211526.EFNmCcfA-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d0eaa3eabce1c80d067a739749e4253546417722
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
        git checkout d0eaa3eabce1c80d067a739749e4253546417722
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash arch/sparc/kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211526.EFNmCcfA-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/net/net_namespace.h:43,
                    from include/linux/inet.h:42,
                    from arch/sparc/kernel/setup_64.c:27:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: error: parameter 'i' set but not used [-Werror=unused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   arch/sparc/kernel/setup_64.c: At top level:
   arch/sparc/kernel/setup_64.c:615:13: error: no previous prototype for 'alloc_irqstack_bootmem' [-Werror=missing-prototypes]
     615 | void __init alloc_irqstack_bootmem(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors
--
   In file included from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from arch/sparc/kernel/idprom.c:13:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: error: parameter 'i' set but not used [-Werror=unused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: error: parameter 'f' set but not used [-Werror=unused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   cc1: all warnings being treated as errors


vim +/i +2392 include/linux/skbuff.h

^1da177e4c3f41 Linus Torvalds 2005-04-16  2390  
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2391  static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
84ce071e38a6e2 Pavel Begunkov 2022-07-12 @2392  					      int i, struct page *page,
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2393  					      int off, int size)
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2394  {
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2395  	skb_frag_t *frag = &shinfo->frags[i];
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2396  
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2397  	/*
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2398  	 * Propagate page pfmemalloc to the skb if we can. The problem is
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2399  	 * that not all callers have unique ownership of the page but rely
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2400  	 * on page_is_pfmemalloc doing the right thing(tm).
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2401  	 */
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2402  	frag->bv_page		  = page;
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2403  	frag->bv_offset		  = off;
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2404  	skb_frag_size_set(frag, size);
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2405  }
84ce071e38a6e2 Pavel Begunkov 2022-07-12  2406  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
