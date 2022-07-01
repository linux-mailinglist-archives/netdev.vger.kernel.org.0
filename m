Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B356E562AAE
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiGAE4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGAE4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:56:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D670677E3;
        Thu, 30 Jun 2022 21:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656651390; x=1688187390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CrIYIf0a1cqjSWMnrAcca4kVYNqSSfezjSi2ARPubUY=;
  b=HJoASXP7bvtK5WTJ6epwaeftLYpvwxIKrcp5T9F6G4C6gJdc+qxSwR2Y
   SJqbtGJsBcSAw5L6M4bmX71RdNBq2p55KUMFtA4kVeYhYxHD+3J8E3WTP
   15pe9VpwtNPeRrfpvvya8ptL3L+OvgAR+GD3vCRZld1HhIqdiDkKKMBxM
   FeYTMQczxISyVihIGAAgPHJsyCSD5jXlnhvRbWJRA9BdGd24IStvKAtXC
   kAd4AlK83IdEIZjLPWNaKhgzvY0qYBdgCAZ6vVmesHUckRYvkPspsitR3
   vh8rX/0v+be2ZW7DyZZp3NHIH4VE1ffKMCyQGk/KKZIjWtB7rRn3KqC3I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="344238376"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="344238376"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 21:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="596101169"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2022 21:56:26 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o78he-000DZ0-7k;
        Fri, 01 Jul 2022 04:56:26 +0000
Date:   Fri, 1 Jul 2022 12:55:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH vfio 08/13] vfio: Introduce the DMA logging feature
 support
Message-ID: <202207011231.1oPQhSzo-lkp@intel.com>
References: <20220630102545.18005-9-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630102545.18005-9-yishaih@nvidia.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yishai,

I love your patch! Yet something to improve:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on linus/master v5.19-rc4 next-20220630]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220630-182957
base:   https://github.com/awilliam/linux-vfio.git next
config: arm-randconfig-r005-20220629 (https://download.01.org/0day-ci/archive/20220701/202207011231.1oPQhSzo-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fea20efca2795fd8480cb0755c54062bad2ea322
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220630-182957
        git checkout fea20efca2795fd8480cb0755c54062bad2ea322
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: drivers/vfio/vfio_main.o: in function `vfio_ioctl_device_feature_logging_start':
>> vfio_main.c:(.text+0x61a): undefined reference to `interval_tree_iter_first'
>> arm-linux-gnueabi-ld: vfio_main.c:(.text+0x62e): undefined reference to `interval_tree_insert'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
