Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28236C2B4F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCUHZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCUHZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:25:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE7E18D
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679383524; x=1710919524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p2vet62qBEFJp4Ns9Xa/OZTKVx5oyjfTIc88PsddBlg=;
  b=E7QqSRaTBnFqqymdG38U4TzR3iB7YKOd21yoEhSUY2+T+5yUi9PzU/ij
   u/hFQuppBIbw5n19pe7lynFBdNRJQ0+wlQvpN45BZI+AsHD+H/H//LWOf
   YMf0VGQFPCTMjSWvEG5+v/pLXipwUtxRVDjDe5kjWNCXJgUESBIcOChHQ
   xGmzhSRj7KBdWhbZFNCRwza6R3b7AnU3XrZzH0wG8xRjgu4+CUH505CxW
   J8h3wm/U+oeDQZUm6MtWwxOXh+px0rU+29Ehj0vv3tA0L/bSZMBzmGafG
   yu2cYn0vK0cMx0cQ9/A8OrFwkwRXPdV/VOHWZsInhplvgVHoKHdThq4f8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="341227747"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="341227747"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="1010827579"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="1010827579"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 21 Mar 2023 00:25:18 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peWMv-000BiZ-39;
        Tue, 21 Mar 2023 07:25:17 +0000
Date:   Tue, 21 Mar 2023 15:24:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303211526.aQcBIvfK-lkp@intel.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
patch link:    https://lore.kernel.org/r/20230321033704.936685-1-eric.dumazet%40gmail.com
patch subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: alpha-randconfig-r011-20230319 (https://download.01.org/0day-ci/archive/20230321/202303211526.aQcBIvfK-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d0eaa3eabce1c80d067a739749e4253546417722
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
        git checkout d0eaa3eabce1c80d067a739749e4253546417722
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash init/ kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211526.aQcBIvfK-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/net/net_namespace.h:43,
                    from init/main.c:104:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: warning: parameter 'i' set but not used [-Wunused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   init/main.c: At top level:
   init/main.c:775:20: warning: no previous prototype for 'arch_post_acpi_subsys_init' [-Wmissing-prototypes]
     775 | void __init __weak arch_post_acpi_subsys_init(void) { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
   init/main.c:787:20: warning: no previous prototype for 'mem_encrypt_init' [-Wmissing-prototypes]
     787 | void __init __weak mem_encrypt_init(void) { }
         |                    ^~~~~~~~~~~~~~~~
   init/main.c:789:20: warning: no previous prototype for 'poking_init' [-Wmissing-prototypes]
     789 | void __init __weak poking_init(void) { }
         |                    ^~~~~~~~~~~
--
   In file included from include/net/net_namespace.h:43,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:205,
                    from include/linux/sunrpc/auth.h:14,
                    from include/linux/nfs_fs.h:31,
                    from init/do_mounts.c:22:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: warning: parameter 'i' set but not used [-Wunused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
--
   In file included from include/linux/filter.h:12,
                    from kernel/bpf/core.c:21:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: warning: parameter 'i' set but not used [-Wunused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   kernel/bpf/core.c: At top level:
   kernel/bpf/core.c:1632:12: warning: no previous prototype for 'bpf_probe_read_kernel' [-Wmissing-prototypes]
    1632 | u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
         |            ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/filter.h:12,
                    from include/linux/bpf_verifier.h:9,
                    from kernel/bpf/btf.c:19:
   include/linux/skbuff.h:348:23: error: 'CONFIG_MAX_SKB_FRAGS' undeclared here (not in a function); did you mean 'MAX_SKB_FRAGS'?
     348 | #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:593:31: note: in expansion of macro 'MAX_SKB_FRAGS'
     593 |         skb_frag_t      frags[MAX_SKB_FRAGS];
         |                               ^~~~~~~~~~~~~
   include/linux/skbuff.h: In function '__skb_fill_page_desc_noacc':
>> include/linux/skbuff.h:2392:51: warning: parameter 'i' set but not used [-Wunused-but-set-parameter]
    2392 |                                               int i, struct page *page,
         |                                               ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_ref':
>> include/linux/skbuff.h:3380:58: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3380 | static inline void skb_frag_ref(struct sk_buff *skb, int f)
         |                                                      ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_unref':
   include/linux/skbuff.h:3411:60: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3411 | static inline void skb_frag_unref(struct sk_buff *skb, int f)
         |                                                        ~~~~^
   include/linux/skbuff.h: In function 'skb_frag_set_page':
   include/linux/skbuff.h:3478:63: warning: parameter 'f' set but not used [-Wunused-but-set-parameter]
    3478 | static inline void skb_frag_set_page(struct sk_buff *skb, int f,
         |                                                           ~~~~^
   In file included from <command-line>:
   include/linux/skmsg.h: In function 'sk_msg_init':
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler_types.h:377:23: note: in definition of macro '__compiletime_assert'
     377 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:397:9: note: in expansion of macro '_compiletime_assert'
     397 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/skmsg.h:177:9: note: in expansion of macro 'BUILD_BUG_ON'
     177 |         BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
         |         ^~~~~~~~~~~~
   include/linux/compiler.h:232:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     232 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:55:59: note: in expansion of macro '__must_be_array'
      55 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   include/linux/skmsg.h:177:22: note: in expansion of macro 'ARRAY_SIZE'
     177 |         BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
         |                      ^~~~~~~~~~
   In file included from kernel/bpf/btf.c:23:
   include/linux/skmsg.h: In function 'sk_msg_xfer':
>> include/linux/skmsg.h:183:36: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     183 |                                int which, u32 size)
         |                                ~~~~^~~~~
   include/linux/skmsg.h: In function 'sk_msg_elem':
   include/linux/skmsg.h:209:71: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     209 | static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
         |                                                                   ~~~~^~~~~
   include/linux/skmsg.h: In function 'sk_msg_elem_cpy':
   include/linux/skmsg.h:214:74: warning: parameter 'which' set but not used [-Wunused-but-set-parameter]
     214 | static inline struct scatterlist sk_msg_elem_cpy(struct sk_msg *msg, int which)
         |                                                                      ~~~~^~~~~
   kernel/bpf/btf.c: In function 'btf_seq_show':
   kernel/bpf/btf.c:7101:29: warning: function 'btf_seq_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    7101 |         seq_vprintf((struct seq_file *)show->target, fmt, args);
         |                             ^~~~~~~~
   kernel/bpf/btf.c: In function 'btf_snprintf_show':
   kernel/bpf/btf.c:7138:9: warning: function 'btf_snprintf_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    7138 |         len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
         |         ^~~


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
