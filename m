Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE2F4EA500
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiC2CRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiC2CR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:17:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E298C63B1;
        Mon, 28 Mar 2022 19:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648520148; x=1680056148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cAAm64d/gf6El6yK8BRuZprVHc5ILVGkuEPyudyPfMc=;
  b=XAkgZtdLQXaeksC5MpNqXOxeHQHXsb/4QplNS5bMcu3BDgjpuj/zZ/3K
   bZnGxsPL8+iiQtg8/BcBcz1qAMwhtcJAArJUL+Cd148rG4bFUc/rVp9no
   2zSUCNoGdFoLH62hIrSGAQrJGWB322t0vXnHlp7mGtjYWvHDwf2s1NuHw
   T7E84NLlac+CUKS1XwE6ZMNOsgyWFhwuMVRO+o2Nz2v6sXP6tBb9W2tXb
   AMkNdkvgSl/DMzFA3KWTuMa5Bs81OHbcKvl8mkkY0p97CmmhwBqTzX3td
   rLloCYGCptzaL7L/6Zl4z6InPxeufMW7B3aCv9vqqOhBZuFta+yT8azbm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="322329824"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="322329824"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 19:15:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="585404916"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 28 Mar 2022 19:15:42 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nZ1OY-0002Wo-0U; Tue, 29 Mar 2022 02:15:42 +0000
Date:   Tue, 29 Mar 2022 10:15:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, corbet@lwn.net,
        viro@zeniv.linux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kpsingh@kernel.org, shuah@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        zohar@linux.ibm.com
Cc:     kbuild-all@lists.01.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 16/18] bpf-preload: Do kernel mount to ensure that pinned
 objects don't disappear
Message-ID: <202203291034.vCkMuZo5-lkp@intel.com>
References: <20220328175033.2437312-17-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328175033.2437312-17-roberto.sassu@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
[also build test ERROR on linus/master next-20220328]
[cannot apply to bpf/master v5.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: riscv-randconfig-c004-20220327 (https://download.01.org/0day-ci/archive/20220329/202203291034.vCkMuZo5-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/eddbb1ec1e92ba00c4acc9f123769265e17e8e40
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
        git checkout eddbb1ec1e92ba00c4acc9f123769265e17e8e40
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/bpf/inode.c:25:37: error: 'CONFIG_BPF_PRELOAD_LIST' undeclared here (not in a function)
      25 | static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/inode.c:1026:13: error: redefinition of 'mount_bpffs'
    1026 | void __init mount_bpffs(void)
         |             ^~~~~~~~~~~
   In file included from include/linux/filter.h:9,
                    from kernel/bpf/inode.c:20:
   include/linux/bpf.h:1146:27: note: previous definition of 'mount_bpffs' with type 'void(void)'
    1146 | static inline void __init mount_bpffs(void)
         |                           ^~~~~~~~~~~


vim +/mount_bpffs +1026 kernel/bpf/inode.c

  1025	
> 1026	void __init mount_bpffs(void)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
