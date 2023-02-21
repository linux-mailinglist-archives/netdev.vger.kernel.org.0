Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2653869D7E5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjBUBJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbjBUBJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:09:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB05E9EF1;
        Mon, 20 Feb 2023 17:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676941778; x=1708477778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A+KGKw+5Btk54DfTXju4UW/yull7lBkhCraeVCjeaOk=;
  b=esAWOV/HZGFA8osgRZUkJ6U9bdeZ06JH+HDXaogN7VQvGHE3XnesuRZi
   Pg6BYKL9Cm+XjgRexIvDyJunKZebiiSo/c/8sY+8AcADGV9KGs5LGMoUa
   6XePTB/kScsc1t7mSP8O58xVvKaeGgcGOQF+lqdz9kPRCKzyrUEmh/OXf
   b7lSogEnNhnaJ9jUc9sUfmQwvCMsBNAvD59pZNbOOAQmQJglT8RL0WE6E
   byo8m0GuZw1/f/rcNxYiS5oTCDhiWLwpYG4v9dgvxG1L29KN8Sa/qNDPv
   T3mL8O4hDTb30Iu52J3YUKb30nkNiye4q0m1jf6FcwLtkoWy5D87rq2cX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="320644064"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="320644064"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 17:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="795327514"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="795327514"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 20 Feb 2023 17:09:36 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUH9z-000EIL-2c;
        Tue, 21 Feb 2023 01:09:35 +0000
Date:   Tue, 21 Feb 2023 09:08:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on
 x86
Message-ID: <202302210943.Xq84rrhU-lkp@intel.com>
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on horms-ipvs/master]
[also build test WARNING on mst-vhost/linux-next net/master net-next/master linus/master v6.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jeremi-Piotrowski/ptp-kvm-Use-decrypted-memory-in-confidential-guest-on-x86/20230220-210441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
patch link:    https://lore.kernel.org/r/20230220130235.2603366-1-jpiotrowski%40linux.microsoft.com
patch subject: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on x86
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230221/202302210943.Xq84rrhU-lkp@intel.com/config)
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
| Link: https://lore.kernel.org/oe-kbuild-all/202302210943.Xq84rrhU-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ptp/ptp_kvm_x86.c: In function 'kvm_arch_ptp_init':
   drivers/ptp/ptp_kvm_x86.c:63:9: error: implicit declaration of function 'kvm_arch_ptp_exit'; did you mean 'kvm_arch_ptp_init'? [-Werror=implicit-function-declaration]
      63 |         kvm_arch_ptp_exit();
         |         ^~~~~~~~~~~~~~~~~
         |         kvm_arch_ptp_init
   drivers/ptp/ptp_kvm_x86.c: At top level:
>> drivers/ptp/ptp_kvm_x86.c:68:6: warning: no previous prototype for 'kvm_arch_ptp_exit' [-Wmissing-prototypes]
      68 | void kvm_arch_ptp_exit(void)
         |      ^~~~~~~~~~~~~~~~~
>> drivers/ptp/ptp_kvm_x86.c:68:6: warning: conflicting types for 'kvm_arch_ptp_exit'; have 'void(void)'
   drivers/ptp/ptp_kvm_x86.c:63:9: note: previous implicit declaration of 'kvm_arch_ptp_exit' with type 'void(void)'
      63 |         kvm_arch_ptp_exit();
         |         ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/kvm_arch_ptp_exit +68 drivers/ptp/ptp_kvm_x86.c

    67	
  > 68	void kvm_arch_ptp_exit(void)
    69	{
    70		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
    71			WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
    72			free_page((unsigned long)clock_pair);
    73			clock_pair = NULL;
    74		}
    75	}
    76	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
