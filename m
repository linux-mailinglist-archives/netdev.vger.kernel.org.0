Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4057EB9F
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 05:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiGWDFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 23:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWDE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 23:04:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4308A72EDC
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 20:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658545497; x=1690081497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AetxOnkwm8trlbQGo2LGtZBupkHlGDq9hG4G2kZFA4k=;
  b=ZIRqWp6gr+BSU2ERywbMVQHcNT5pq0n19xWo9oPzc3qcOTQGM39UhXfm
   KqHtGr84Ty66LwHWbw5dbw7/orvmWGHWeWNFTpwsbE/gOflb5z52SjCOJ
   z9o1ah+mR3pvm2iVGcIOQSLsJQKMkxOdswCnQQCHo6Srb5KPm0PG+kcj3
   3wlbYm7HBI+UYFzXbTubBBmcd2RIs7uMVV8udnpIJqp9PT7r/rtz05buW
   G07Y4o7ph/4q2RD7mfIVMmRdYIF1r+rBbGDjW+8K5TlTmFT2pBWJMEBCR
   z5QcKMUdki31I2t+29pehfg1NivHPwQQB9wnHlejPrHrrPhPIWyXVJg9g
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="288619316"
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="288619316"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 20:04:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="626785106"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 22 Jul 2022 20:04:54 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oF5Rl-00026H-2I;
        Sat, 23 Jul 2022 03:04:53 +0000
Date:   Sat, 23 Jul 2022 11:04:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     ecree@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-net-drivers@amd.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 04/14] sfc: determine wire m-port at EF100 PF
 probe time
Message-ID: <202207231002.Bimz8unB-lkp@intel.com>
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
config: mips-randconfig-s041-20220721 (https://download.01.org/0day-ci/archive/20220723/202207231002.Bimz8unB-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/f00d0e9f57792091c90518b98e8b722a4018f062
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ecree-xilinx-com/sfc-VF-representors-for-EF100-RX-side/20220723-001059
        git checkout f00d0e9f57792091c90518b98e8b722a4018f062
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   mips-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_probe_netdev_pf':
   ef100_nic.c:(.text+0x2904): undefined reference to `efx_mae_mport_wire'
>> mips-linux-ld: ef100_nic.c:(.text+0x2914): undefined reference to `efx_mae_lookup_mport'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
