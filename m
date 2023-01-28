Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BDF67F7F3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbjA1NQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjA1NQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:16:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD9160CBD;
        Sat, 28 Jan 2023 05:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674911793; x=1706447793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xRkizNFLXRZLEBRhpHvIyAhu0m3+jrQc6zYlNa2K1+4=;
  b=gUtI+KO0nD6ndRN/DXR70lct+xldu+wYnyiu60NbuAmDAXaugmnQ71pQ
   aum8jtMHoSTpXAJ40EGEbue4N/1YLwz2DPxSlp6QOKOw5M2cGWz0Ui5e0
   F32IKtYPzwJ7Ql5feJgoUKmtUyfCyeAfkMhCSbng77lukUgP+RjVmuCBQ
   V9DPBO9b1yH9iUhBxVZoR6F7SAfugYdyZP4Ch4fYKCJJYtfVL1oVJzQRM
   sqqc/T1PJE31XEPy2iwxlCPk5K9sl0pcmflOuIPKBxCMvn4hA/1DuoCn4
   5K8lZnCeN0DxC1D+2nYRqiM14UigjAIbgk/FaPsNK2HQ1mnDq2oVnX9Ny
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="329417901"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="329417901"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 05:16:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="992378494"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="992378494"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2023 05:16:30 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLl4H-0000fb-20;
        Sat, 28 Jan 2023 13:16:29 +0000
Date:   Sat, 28 Jan 2023 21:15:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v8 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <202301282140.o95DpYWu-lkp@intel.com>
References: <20230126233439.3739120-4-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126233439.3739120-4-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/bpf-Allow-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230128-170947
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230126233439.3739120-4-joannelkoong%40gmail.com
patch subject: [PATCH v8 bpf-next 3/5] bpf: Add skb dynptrs
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230128/202301282140.o95DpYWu-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2581b1dec73f18fa2b7302a1a2ecd788b82f3680
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/bpf-Allow-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230128-170947
        git checkout 2581b1dec73f18fa2b7302a1a2ecd788b82f3680
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/filter.c:1866:5: warning: no previous prototype for 'bpf_dynptr_from_skb' [-Wmissing-prototypes]
    1866 | int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
         |     ^~~~~~~~~~~~~~~~~~~


vim +/bpf_dynptr_from_skb +1866 net/core/filter.c

  1865	
> 1866	int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
  1867				struct bpf_dynptr_kern *ptr, int is_rdonly)
  1868	{
  1869		if (flags) {
  1870			bpf_dynptr_set_null(ptr);
  1871			return -EINVAL;
  1872		}
  1873	
  1874		bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
  1875	
  1876		if (is_rdonly)
  1877			bpf_dynptr_set_rdonly(ptr);
  1878	
  1879		return 0;
  1880	}
  1881	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
