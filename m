Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3809E58AC87
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiHEOy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiHEOy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:54:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBE95C34F;
        Fri,  5 Aug 2022 07:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659711264; x=1691247264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=85sOUquFlJ/tQRW7uPa7MBnstCcG8G62zfua8oflet0=;
  b=IORpVpnuQXPIfGcNeEV56RA6tIZf/m1C01dn2CKUCuKLKxaslMzMvhn6
   IWgL+MJFB9I+7mxw4UwbB7P/Xd23a00BboHDU7kofXp/p1bvX3Kjs1mKS
   nzzT7Bht9knHltVm2ubxEaPkKYfj88YoKQvwsh0gK93WZWbTM4g2IHuT/
   tUxpTc/thhq7w0+1cYVJJ8KZs9QciNqkg7mxKLbAAQf62RtlA59Uc1KtT
   85sSoCrHFW6TXAbyyDDo0M+Pww9glUhA5JylW5MKqjd3q5WlxIsUeeFY1
   Rxv12zj05OMIHGar5LMyMA7m59nlAuAb+Z2olmNmSPIMnyPzBavA0ekMR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="376511085"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="376511085"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 07:54:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="671709650"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2022 07:54:21 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oJyiT-000JSh-0Q;
        Fri, 05 Aug 2022 14:54:21 +0000
Date:   Fri, 5 Aug 2022 22:53:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     AceLan Kao <acelan.kao@canonical.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitrii Tarakanov <Dmitrii.Tarakanov@aquantia.com>,
        Alexander Loktionov <Alexander.Loktionov@aquantia.com>,
        David VomLehn <vomlehn@texas.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: fix aq_vec index out of range error
Message-ID: <202208052211.yWBUaHIc-lkp@intel.com>
References: <20220805093319.3722179-1-acelan.kao@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805093319.3722179-1-acelan.kao@canonical.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi AceLan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master horms-ipvs/master v5.19 next-20220804]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/AceLan-Kao/net-atlantic-fix-aq_vec-index-out-of-range-error/20220805-173434
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220805/202208052211.yWBUaHIc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/23a65a8ebdb1e74cf7fc03a89741246de646622b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review AceLan-Kao/net-atlantic-fix-aq_vec-index-out-of-range-error/20220805-173434
        git checkout 23a65a8ebdb1e74cf7fc03a89741246de646622b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/aquantia/atlantic/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/aquantia/atlantic/aq_nic.c: In function 'aq_nic_polling_timer_cb':
>> drivers/net/ethernet/aquantia/atlantic/aq_nic.c:268:26: warning: variable 'aq_vec' set but not used [-Wunused-but-set-variable]
     268 |         struct aq_vec_s *aq_vec = NULL;
         |                          ^~~~~~
   drivers/net/ethernet/aquantia/atlantic/aq_nic.c: In function 'aq_nic_stop':
   drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1384:26: warning: variable 'aq_vec' set but not used [-Wunused-but-set-variable]
    1384 |         struct aq_vec_s *aq_vec = NULL;
         |                          ^~~~~~


vim +/aq_vec +268 drivers/net/ethernet/aquantia/atlantic/aq_nic.c

97bde5c4f909a55a David VomLehn         2017-01-23  264  
e99e88a9d2b06746 Kees Cook             2017-10-16  265  static void aq_nic_polling_timer_cb(struct timer_list *t)
97bde5c4f909a55a David VomLehn         2017-01-23  266  {
e99e88a9d2b06746 Kees Cook             2017-10-16  267  	struct aq_nic_s *self = from_timer(self, t, polling_timer);
97bde5c4f909a55a David VomLehn         2017-01-23 @268  	struct aq_vec_s *aq_vec = NULL;
97bde5c4f909a55a David VomLehn         2017-01-23  269  	unsigned int i = 0U;
97bde5c4f909a55a David VomLehn         2017-01-23  270  
97bde5c4f909a55a David VomLehn         2017-01-23  271  	for (i = 0U, aq_vec = self->aq_vec[0];
23a65a8ebdb1e74c Chia-Lin Kao (AceLan  2022-08-05  272) 		self->aq_vecs > i; ++i)
23a65a8ebdb1e74c Chia-Lin Kao (AceLan  2022-08-05  273) 		aq_vec_isr(i, (void *)self->aq_vec[i]);
97bde5c4f909a55a David VomLehn         2017-01-23  274  
97bde5c4f909a55a David VomLehn         2017-01-23  275  	mod_timer(&self->polling_timer, jiffies +
97bde5c4f909a55a David VomLehn         2017-01-23  276  		  AQ_CFG_POLLING_TIMER_INTERVAL);
97bde5c4f909a55a David VomLehn         2017-01-23  277  }
97bde5c4f909a55a David VomLehn         2017-01-23  278  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
