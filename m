Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2350B686
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447184AbiDVLwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345685AbiDVLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:51:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80D56411;
        Fri, 22 Apr 2022 04:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650628145; x=1682164145;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P8V+nwtbjH2d63rlunKLb90J3pF9jlzTPbzeYVpv6mQ=;
  b=Hwivak+QVFdkj56XtNmTZtwc9sdJ6bdnHYAH/2Jo2qRbx874LJDq4Ocn
   zMDGimR17vE+2BujR060dUYNXuEf4xovyyLOnAgzqZiB103QgWE+l/DAx
   1hM49HO86mdeFzvwySvNJBjbCcpM7EjVD++vietZZ+uJ6NpjruB57W/kc
   nC1HWN+A7qnSNYlBvUjW6GGXR1qzQUwhqXQyJE/bL3jqytvlHeX7EeXpn
   +nffj/1jEhXF4ggk21a+K5UbSS6ncDxW2ULfgvxEUtENKAhO3DoX2BhXO
   L+4AR4LU2HHuKoAN849HNQH4qFoN8cmMB51n0bdQ1XP4FM7ZG/7nxltTe
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="327571427"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="327571427"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 04:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="534204064"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 22 Apr 2022 04:49:02 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhrmX-000A45-Jv;
        Fri, 22 Apr 2022 11:49:01 +0000
Date:   Fri, 22 Apr 2022 19:48:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Message-ID: <202204221937.SbSpkzXW-lkp@intel.com>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-Leroy/net-Use-csum_replace_-and-csum_sub-helpers-instead-of-opencoding/20220217-234555
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c8b441d2fbd0e005541c7363fd5346971b6febcb
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220422/202204221937.SbSpkzXW-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/cec9ed7cf59fe6dafcec0a30811024d22fad8cbd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christophe-Leroy/net-Use-csum_replace_-and-csum_sub-helpers-instead-of-opencoding/20220217-234555
        git checkout cec9ed7cf59fe6dafcec0a30811024d22fad8cbd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/netfilter/nft_payload.c: note: in included file (through include/net/sctp/sctp.h, include/net/sctp/checksum.h):
   include/net/sctp/structs.h:335:41: sparse: sparse: array of flexible structures
>> net/netfilter/nft_payload.c:560:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:560:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:560:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:560:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:560:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:560:34: sparse:     got restricted __wsum [usertype] tsum
>> net/netfilter/nft_payload.c:560:28: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __be32 [usertype] from @@     got restricted __wsum [usertype] fsum @@
   net/netfilter/nft_payload.c:560:28: sparse:     expected restricted __be32 [usertype] from
   net/netfilter/nft_payload.c:560:28: sparse:     got restricted __wsum [usertype] fsum
>> net/netfilter/nft_payload.c:560:34: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be32 [usertype] to @@     got restricted __wsum [usertype] tsum @@
   net/netfilter/nft_payload.c:560:34: sparse:     expected restricted __be32 [usertype] to
   net/netfilter/nft_payload.c:560:34: sparse:     got restricted __wsum [usertype] tsum

vim +560 net/netfilter/nft_payload.c

   557	
   558	static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
   559	{
 > 560		csum_replace4(sum, fsum, tsum);
   561		if (*sum == 0)
   562			*sum = CSUM_MANGLED_0;
   563	}
   564	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
