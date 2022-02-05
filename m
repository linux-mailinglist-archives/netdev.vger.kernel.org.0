Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654BA4AA544
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 02:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378865AbiBEBSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 20:18:08 -0500
Received: from mga17.intel.com ([192.55.52.151]:9433 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378852AbiBEBSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 20:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644023888; x=1675559888;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ip96Kk+B8NCtyuD3J6oy4zW0E5ywo/h2S31i9208Fr0=;
  b=VWFOVeRqIWewKkHPYQ5+dIHA+QLgOYkY/iBjYuIYaWczYSAq+RQt8MfJ
   AagBwEsbKhdSFiVMo248WKfsRFLtolts03tGFoSXaTCbJOm4Nb02yp4pJ
   m3BlottUGyN9AIZFsf+ivgL5xgEELAMAI542aFzJCkue9Vzj8C3N0ME5N
   NpiBJrkolJqk35koFumBYp30SIPiAi6V54O0yCci8+RvjOzvu+lwPZT+a
   hXvRDn7EsuImtHwFDZ3NJG9maq9fPtbjnybgypHixomdgNxbsC5wxzti5
   1/n1ulDo876EI0Pt7o/TOHwtJp5rBl1o3iYP6QIP/GJmwpDRSYvWI4K2v
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229122186"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229122186"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 17:18:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="631867830"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 04 Feb 2022 17:18:04 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG9iG-000YQ0-3d; Sat, 05 Feb 2022 01:18:04 +0000
Date:   Sat, 5 Feb 2022 09:17:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_cmp: optimize comparison for up
 to 16-bytes
Message-ID: <202202050944.nFxizuBh-lkp@intel.com>
References: <20220204151903.320786-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204151903.320786-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/netfilter-nft_cmp-optimize-comparison-for-up-to-16-bytes/20220204-232030
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220205/202202050944.nFxizuBh-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/91cb7a051c24382b5a7252e59fc5a6a6e2d62332
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/netfilter-nft_cmp-optimize-comparison-for-up-to-16-bytes/20220204-232030
        git checkout 91cb7a051c24382b5a7252e59fc5a6a6e2d62332
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/netfilter/nft_cmp.c:129:31: sparse: sparse: cast to restricted __be16
   net/netfilter/nft_cmp.c:132:31: sparse: sparse: cast to restricted __be32
   net/netfilter/nft_cmp.c:135:31: sparse: sparse: cast to restricted __be64
>> net/netfilter/nft_cmp.c:211:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int @@     got restricted __le32 [usertype] @@
   net/netfilter/nft_cmp.c:211:33: sparse:     expected unsigned int
   net/netfilter/nft_cmp.c:211:33: sparse:     got restricted __le32 [usertype]

vim +211 net/netfilter/nft_cmp.c

   199	
   200	static void nft_cmp16_fast_mask(struct nft_data *data, unsigned int bitlen)
   201	{
   202		int len = bitlen / BITS_PER_BYTE;
   203		int i, words = len / sizeof(u32);
   204	
   205		for (i = 0; i < words; i++) {
   206			data->data[i] = 0xffffffff;
   207			bitlen -= sizeof(u32) * BITS_PER_BYTE;
   208		}
   209	
   210		if (len % sizeof(u32))
 > 211			data->data[i++] = cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
   212	
   213		for (; i < 4; i++)
   214			data->data[i] = 0;
   215	}
   216	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
