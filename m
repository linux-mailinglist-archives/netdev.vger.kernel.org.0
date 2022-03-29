Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74D84EA600
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 05:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiC2D3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 23:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiC2D3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 23:29:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5C923F380;
        Mon, 28 Mar 2022 20:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648524469; x=1680060469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SDWiiOQKn03Y32llGpgMdBJlnmtF9BNEmaXOUA7f4Q4=;
  b=cFOzN5FHxLDG09MdM3y+lStxE4j+iVOdhXYTPb+HXxo2uQz9UPcw1XGX
   39n3AJtXZQEUORV+dJqyRuDvNSiOhb223nkUlp3RbcU33frN00GZmJ2jI
   TEzult/fGqoSkv8PR2WkMgbPt2tN8bFEtvpEBoBGWkIy3xxUZDLnpdBBB
   /aMprSbWmsjogd1XzFfPfhXnymaLhWj6nCI7oZ7zxN78mRAOJm+ovaPXt
   3K4ypCEGh76Ihesiup1r8C/UEryadBWZOgtWV5mLvf7dvTBRfctBaWvRN
   P4L9U8vbL+OYHsH24DILf6YHut9wiWKZXcx978xTs9VzoGWzB3AYWASqH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="259338736"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="259338736"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 20:27:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="554122579"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 28 Mar 2022 20:27:44 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nZ2WF-0002aE-Ku; Tue, 29 Mar 2022 03:27:43 +0000
Date:   Tue, 29 Mar 2022 11:27:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, corbet@lwn.net,
        viro@zeniv.linux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kpsingh@kernel.org, shuah@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        zohar@linux.ibm.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 14/18] bpf-preload: Switch to new preload registration
 method
Message-ID: <202203291125.8NpccWn1-lkp@intel.com>
References: <20220328175033.2437312-15-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328175033.2437312-15-roberto.sassu@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]
[also build test ERROR on bpf/master linus/master next-20220328]
[cannot apply to v5.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: arm64-randconfig-r026-20220328 (https://download.01.org/0day-ci/archive/20220329/202203291125.8NpccWn1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0f6d9501cf49ce02937099350d08f20c4af86f3d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/2e0e81b0296abc384efb2a73520ce03c2a5344ea
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
        git checkout 2e0e81b0296abc384efb2a73520ce03c2a5344ea
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> kernel/bpf/inode.c:25:37: error: use of undeclared identifier 'CONFIG_BPF_PRELOAD_LIST'
   static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
                                       ^
   1 error generated.


vim +/CONFIG_BPF_PRELOAD_LIST +25 kernel/bpf/inode.c

    24	
  > 25	static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
    26	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
