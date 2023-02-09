Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FA8690618
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBILGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBILGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:06:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EFE210D;
        Thu,  9 Feb 2023 03:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675940803; x=1707476803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lt1cRuAg8Zq2HTRCDVLJzG8U5PiiH/Kis3+YbDWZ9Ew=;
  b=HATosqjnVAiSlALJHWodlUMJz8OM7+VT/fff/vk8hgdueIW/hAbliGCR
   Iox06rHyr3LkeDPevt/ck1CrngfEp/X3UqzCWMS2CKrHDvuPHPWhc8iFQ
   yv5deiJRqh5Ji5W0NObxkkDj61YPhkP5UPqHa4RjqJYwr5PwhluYDGtVo
   4Dtm2fmxoDhueN2VqXh9NNR3lR7kQS1De8ZutWrxs+iP78+3XXM0YbyQ9
   gp5yewxWYCrQM9HP1EFWZ7Zwk7kURFkPGo9lfhskOTP/vAw5RV68KMnR7
   HHvmMfiLt0vlWRyxB42t0cejcgkXqgqvo60QqUSPBi08NIGNFsRZqqDIi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="330100579"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="330100579"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 03:06:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="791571325"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="791571325"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 09 Feb 2023 03:06:38 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQ4lB-00051a-36;
        Thu, 09 Feb 2023 11:06:37 +0000
Date:   Thu, 9 Feb 2023 19:06:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] xsk: support use vaddr as ring
Message-ID: <202302091850.0HBmsDAq-lkp@intel.com>
References: <20230209092436.87795-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209092436.87795-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/xsk-support-use-vaddr-as-ring/20230209-172553
patch link:    https://lore.kernel.org/r/20230209092436.87795-1-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH net-next] xsk: support use vaddr as ring
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20230209/202302091850.0HBmsDAq-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4a7734a008a4c9739f0abcc596455e4b76b601ec
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/xsk-support-use-vaddr-as-ring/20230209-172553
        git checkout 4a7734a008a4c9739f0abcc596455e4b76b601ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302091850.0HBmsDAq-lkp@intel.com

All warnings (new ones prefixed by >>):

   net/xdp/xsk_queue.c: In function 'xskq_create':
   net/xdp/xsk_queue.c:46:19: error: implicit declaration of function 'vmalloc_user' [-Werror=implicit-function-declaration]
      46 |         q->ring = vmalloc_user(size);
         |                   ^~~~~~~~~~~~
>> net/xdp/xsk_queue.c:46:17: warning: assignment to 'struct xdp_ring *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      46 |         q->ring = vmalloc_user(size);
         |                 ^
   net/xdp/xsk_queue.c: In function 'xskq_destroy':
   net/xdp/xsk_queue.c:60:17: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
      60 |                 vfree(q->ring);
         |                 ^~~~~
         |                 kvfree
   cc1: some warnings being treated as errors


vim +46 net/xdp/xsk_queue.c

    22	
    23	struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
    24	{
    25		struct xsk_queue *q;
    26		gfp_t gfp_flags;
    27		size_t size;
    28	
    29		q = kzalloc(sizeof(*q), GFP_KERNEL);
    30		if (!q)
    31			return NULL;
    32	
    33		q->nentries = nentries;
    34		q->ring_mask = nentries - 1;
    35	
    36		gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
    37			    __GFP_COMP  | __GFP_NORETRY;
    38		size = xskq_get_ring_size(q, umem_queue);
    39	
    40		q->ring_size = size;
    41		q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
    42							      get_order(size));
    43		if (q->ring)
    44			return q;
    45	
  > 46		q->ring = vmalloc_user(size);
    47		if (q->ring)
    48			return q;
    49	
    50		kfree(q);
    51		return NULL;
    52	}
    53	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
