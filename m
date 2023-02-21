Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E212469DCBA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjBUJSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjBUJSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:18:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA9D9010;
        Tue, 21 Feb 2023 01:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676971076; x=1708507076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fVVZpN8z4la7Rldt4b/vjh1vEtFuKmVaz0Vyg/Tpj9Y=;
  b=Zrh+BULLgi25gbiNf7g5fXnOCQe+FLAnoHB9K6bH/+xTlyUtXf4l+Cp0
   onzAIji1HaK/rhn3R+xfxLZo7vdWeX9oc1AM2vwOngs/logZH6BBOwK9e
   0FSdDd5V06fEOM3bLOuNXOfLsWr2/xa4tNNwPP81w05TuWiDvuooc6BXO
   sKu3hlMr26BOz7fvZ1edCFq+CX1DyVgwD64P+aLB+fiJqTMyGehTgInVJ
   m4hit9YSck1R7XUOJWRsB6Br8bNxCdB8ujr3kJH4pI6cBceYOctJbNnF9
   iikU8eJ6aL30oMvHDXfLnBVOCl59nOwzr1FKe35MU4vTD92unYDv/OK+g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="320715018"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="320715018"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 01:17:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="673611851"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="673611851"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 21 Feb 2023 01:17:54 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUOmX-000Ec9-0t;
        Tue, 21 Feb 2023 09:17:53 +0000
Date:   Tue, 21 Feb 2023 17:17:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on
 x86
Message-ID: <202302211746.oclm0ibu-lkp@intel.com>
References: <20230220130235.2603366-1-jpiotrowski@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220130235.2603366-1-jpiotrowski@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on mst-vhost/linux-next net/master net-next/master linus/master v6.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jeremi-Piotrowski/ptp-kvm-Use-decrypted-memory-in-confidential-guest-on-x86/20230220-210441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
patch link:    https://lore.kernel.org/r/20230220130235.2603366-1-jpiotrowski%40linux.microsoft.com
patch subject: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on x86
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230221/202302211746.oclm0ibu-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0dd1701fd254692af3d0ca051e092e8dcef190c4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jeremi-Piotrowski/ptp-kvm-Use-decrypted-memory-in-confidential-guest-on-x86/20230220-210441
        git checkout 0dd1701fd254692af3d0ca051e092e8dcef190c4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302211746.oclm0ibu-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/ptp/ptp_kvm_x86.c: In function 'kvm_arch_ptp_init':
>> drivers/ptp/ptp_kvm_x86.c:63:9: error: implicit declaration of function 'kvm_arch_ptp_exit'; did you mean 'kvm_arch_ptp_init'? [-Werror=implicit-function-declaration]
      63 |         kvm_arch_ptp_exit();
         |         ^~~~~~~~~~~~~~~~~
         |         kvm_arch_ptp_init
   drivers/ptp/ptp_kvm_x86.c: At top level:
   drivers/ptp/ptp_kvm_x86.c:68:6: warning: no previous prototype for 'kvm_arch_ptp_exit' [-Wmissing-prototypes]
      68 | void kvm_arch_ptp_exit(void)
         |      ^~~~~~~~~~~~~~~~~
   drivers/ptp/ptp_kvm_x86.c:68:6: warning: conflicting types for 'kvm_arch_ptp_exit'; have 'void(void)'
   drivers/ptp/ptp_kvm_x86.c:63:9: note: previous implicit declaration of 'kvm_arch_ptp_exit' with type 'void(void)'
      63 |         kvm_arch_ptp_exit();
         |         ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/ptp/ptp_kvm_common.c: In function 'ptp_kvm_exit':
>> drivers/ptp/ptp_kvm_common.c:133:9: error: implicit declaration of function 'kvm_arch_ptp_exit'; did you mean 'kvm_arch_ptp_init'? [-Werror=implicit-function-declaration]
     133 |         kvm_arch_ptp_exit();
         |         ^~~~~~~~~~~~~~~~~
         |         kvm_arch_ptp_init
   cc1: some warnings being treated as errors


vim +63 drivers/ptp/ptp_kvm_x86.c

    22	
    23	int kvm_arch_ptp_init(void)
    24	{
    25		struct page *p;
    26		long ret;
    27	
    28		if (!kvm_para_available())
    29			return -ENODEV;
    30	
    31		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
    32			p = alloc_page(GFP_KERNEL | __GFP_ZERO);
    33			if (!p)
    34				return -ENOMEM;
    35	
    36			clock_pair = page_address(p);
    37			ret = set_memory_decrypted((unsigned long)clock_pair, 1);
    38			if (ret) {
    39				__free_page(p);
    40				clock_pair = NULL;
    41				goto nofree;
    42			}
    43		} else {
    44			clock_pair = &clock_pair_glbl;
    45		}
    46	
    47		clock_pair_gpa = slow_virt_to_phys(clock_pair);
    48		if (!pvclock_get_pvti_cpu0_va()) {
    49			ret = -ENODEV;
    50			goto err;
    51		}
    52	
    53		ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
    54				     KVM_CLOCK_PAIRING_WALLCLOCK);
    55		if (ret == -KVM_ENOSYS) {
    56			ret = -ENODEV;
    57			goto err;
    58		}
    59	
    60		return ret;
    61	
    62	err:
  > 63		kvm_arch_ptp_exit();
    64	nofree:
    65		return ret;
    66	}
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
