Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523A357EBDB
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 06:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiGWEQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 00:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGWEQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 00:16:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29EB74DE0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 21:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658549771; x=1690085771;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rPCB1mqv3Wird5JeIr6KoQKEBunGxAe/DsLfpaXDJEs=;
  b=b5FGpG6OkWlpeWic5EmVBICpWftAdXf1Vij0zGFyBVyj4fjWUwl+FmPl
   rVour27sthfyDVQPWuXb+y+cMkpjJCVPNltcTCblNOjDX6/dELT9ODj8R
   4auvFAUJNHHyTRxcNSGCs6hpYJEin1HngYHpTrSr7oPXTPQJ+W93gmCAU
   oDK2W52njo4aO7NqNSNxBFxQJf4rDpviOo4iAXbG9fJmnV2B3Np1r3o8o
   PulQT5m9YVSQpZsLQDLG+PhI6wBPRgdf+/XnSPRXXwFnPStm4iCsDCG/F
   DWqgovHyoj7J0oeoBOIFkKlzOsX/y5CBFYpK6qNzewc+I8mx1bdM3Gthf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="349142216"
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="349142216"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 21:16:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="844966715"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jul 2022 21:16:07 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oF6Yb-0002Fd-2z;
        Sat, 23 Jul 2022 04:16:01 +0000
Date:   Sat, 23 Jul 2022 12:15:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     ecree@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-net-drivers@amd.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 04/14] sfc: determine wire m-port at EF100 PF
 probe time
Message-ID: <202207231215.nHYCJokG-lkp@intel.com>
References: <3d9db886be3f5dbf3da360f433ca961cb20c5b83.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d9db886be3f5dbf3da360f433ca961cb20c5b83.1658497661.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/ecree-xilinx-com/sfc-VF-representors-for-EF100-RX-side/20220723-001059
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 949d6b405e6160ae44baea39192d67b39cb7eeac
config: s390-randconfig-r003-20220721 (https://download.01.org/0day-ci/archive/20220723/202207231215.nHYCJokG-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f00d0e9f57792091c90518b98e8b722a4018f062
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ecree-xilinx-com/sfc-VF-representors-for-EF100-RX-side/20220723-001059
        git checkout f00d0e9f57792091c90518b98e8b722a4018f062
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   s390-linux-ld: s390-linux-ld: DWARF error: could not find abbrev number 5931
   drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_probe_netdev_pf':
   ef100_nic.c:(.text+0x2520): undefined reference to `efx_mae_mport_wire'
>> s390-linux-ld: ef100_nic.c:(.text+0x2534): undefined reference to `efx_mae_lookup_mport'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
