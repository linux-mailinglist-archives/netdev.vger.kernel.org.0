Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744EB5670EE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiGEOYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiGEOW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:22:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5665E6;
        Tue,  5 Jul 2022 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657030975; x=1688566975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KxZS7Eqzucz3GLlm0/QQmLH1mpSw1o0eLbsqaMILkQs=;
  b=MgP6iRUPhVY8An5k4jNthWre4LakCC9yyz/ZKpXXdMnjuC2vY+LFlY2y
   57RhPPmc1iDKbbCcTINken1BeigND1PdF3WTH8DyBcB23XuHL1YG2GCI3
   O2DO4cS+fjzZlsoieJUlpLqWAH3i0KBp7Ux90Xb9lBT350O1AY7iVTFtl
   zOwKufi9WAxjU0f5XeW1Qjwsm9in3HxnHoPNxbsviFCXRiFnr+m557BXB
   nHqJsMMgw2OiH2xWrAndG6CAVThqjaBcTN5XSdqR8IXVjWCYOpr9M6GhX
   3RpQlM0T46lvwVVkjxdIvHcKWEEFuMekeRy9FKuAOajdBB724q1yVwSHB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="283393624"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="283393624"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 07:22:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="919738743"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jul 2022 07:22:52 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8jS0-000JA5-55;
        Tue, 05 Jul 2022 14:22:52 +0000
Date:   Tue, 5 Jul 2022 22:22:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V1 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <202207052211.ARFEDBEi-lkp@intel.com>
References: <20220705102740.29337-7-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705102740.29337-7-yishaih@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
[also build test ERROR on next-20220705]
[cannot apply to linus/master v5.19-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
base:   https://github.com/awilliam/linux-vfio.git next
config: m68k-randconfig-r035-20220703 (https://download.01.org/0day-ci/archive/20220705/202207052211.ARFEDBEi-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
        git checkout 12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   m68k-linux-ld: arch/m68k/kernel/machine_kexec.o: in function `machine_kexec':
   machine_kexec.c:(.text+0x58): undefined reference to `m68k_mmutype'
   m68k-linux-ld: machine_kexec.c:(.text+0x60): undefined reference to `m68k_cputype'
   m68k-linux-ld: arch/m68k/kernel/relocate_kernel.o:(.m68k_fixup+0x0): undefined reference to `M68K_FIXUP_MEMOFFSET'
   m68k-linux-ld: arch/m68k/kernel/relocate_kernel.o:(.m68k_fixup+0x8): undefined reference to `M68K_FIXUP_MEMOFFSET'
   m68k-linux-ld: drivers/vfio/vfio_main.o: in function `vfio_ioctl_device_feature_logging_start':
   vfio_main.c:(.text+0x105e): undefined reference to `interval_tree_iter_first'
>> m68k-linux-ld: vfio_main.c:(.text+0x1074): undefined reference to `interval_tree_insert'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
