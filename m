Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82C551D012
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 06:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355693AbiEFE1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 00:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiEFE1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 00:27:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C897F5E766
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 21:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651811021; x=1683347021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0Qyuei6A02ngfcIZQqQpOqzSaMBWZzOuMv4ad6qr3y8=;
  b=d9X8wEYu4LmDYLlu+ldevhBNw6j6pVAGjMIahskYYeT5cvzJx0ZoRZPm
   0+RQZwm7iXT3sICMtCbPbuGdeQJ3L+QTBqiEKRq0wOQmA6iQ2EBydIy45
   3KZ2cb8U3bJhDeuvxdIrMdgcwhAW5NCSuk3/IKBJPEM2xwgmNiBBWUqfD
   fYaJAkiHooUTl5JP6GxLjYJaw4ygoVpW8ry5iXNDEWq0hp1IRbOUYBt4D
   apYpPvDG0r6gkcWbMuHURX9KeMgtTgWrLRTRjBBy9g+D73v09BAdWBSH0
   6rDJPKsWKndRUFGGsb1/Z5YcvxO/18cyp9uL+2cDkab5jCMHhGymutL5e
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328889662"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328889662"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 21:23:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632758140"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 05 May 2022 21:23:39 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmpVC-000D5t-AW;
        Fri, 06 May 2022 04:23:38 +0000
Date:   Fri, 6 May 2022 12:19:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v1 06/10] ptp: ocp: vectorize the sma accessor
 functions
Message-ID: <202205061215.dxLP469b-lkp@intel.com>
References: <20220505234921.3728-7-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505234921.3728-7-jonathan.lemon@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jonathan-Lemon/ptp-ocp-various-updates/20220506-075044
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1c1ed5a48411e1686997157c21633653fbe045c6
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220506/202205061215.dxLP469b-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9bcda1415120b99c5ff40815417a85e485b1df3d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jonathan-Lemon/ptp-ocp-various-updates/20220506-075044
        git checkout 9bcda1415120b99c5ff40815417a85e485b1df3d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/ptp/ fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/ptp/ptp_ocp.c:365:32: warning: tentative definition of variable with internal linkage has incomplete non-array type 'const struct ocp_sma_op' [-Wtentative-definition-incomplete-type]
   static const struct ocp_sma_op ocp_fb_sma_op;
                                  ^
   drivers/ptp/ptp_ocp.c:334:15: note: forward declaration of 'struct ocp_sma_op'
           const struct ocp_sma_op *sma_op;
                        ^
   1 warning generated.


vim +365 drivers/ptp/ptp_ocp.c

   363	
   364	static const struct ocp_attr_group fb_timecard_groups[];
 > 365	static const struct ocp_sma_op ocp_fb_sma_op;
   366	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
