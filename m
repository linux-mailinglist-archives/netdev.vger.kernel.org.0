Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6CB57EC6D
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiGWHTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 03:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiGWHTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 03:19:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C58431389
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 00:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658560751; x=1690096751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B3iwwI3EkH2+qKKVmp5t2oKFiWzJvOJC83hW/8+PVDQ=;
  b=CFHGumHM6yslDmfy40X1Wp7fnb7CuFMNMkc/35LEw8lUHuC6YB03mhH5
   LgaXzrCX6Kacftszd19omN8d7pE6fAV/sBmicoa8j4QA3DcuSx7N8rccC
   Upog9dYdjLj3Fo5HqzhqCn9ui1X1QBmV12N/OyfY5XkV/wKpUDgI45GsI
   EJMX7IG8ljGXWCkpros3Iy5BmhzfppcbI/OyiHl3oY0y/lNNYuN8q0ubV
   oEgn1pgcgxiMNQrRUQTMqJPYZcqh2oT0h1/uPzJzDUlcNjuZJGnsXFCwS
   oWCzVox/pngzBIFIqEvbJGjhxe0aNcfCzba4ap8HOKVY7QBYGdfUJJ9eQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="373756988"
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="373756988"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 00:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,187,1654585200"; 
   d="scan'208";a="741284920"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jul 2022 00:19:09 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oF9Po-0002Nf-1T;
        Sat, 23 Jul 2022 07:19:08 +0000
Date:   Sat, 23 Jul 2022 15:18:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     ecree@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-net-drivers@amd.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 06/14] sfc: receive packets from EF100 VFs into
 representors
Message-ID: <202207231534.YefS8hZX-lkp@intel.com>
References: <539b243ca106075d1ed1b78e4eb6b38ba3b92ec1.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539b243ca106075d1ed1b78e4eb6b38ba3b92ec1.1658497661.git.ecree.xilinx@gmail.com>
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
config: s390-randconfig-r003-20220721 (https://download.01.org/0day-ci/archive/20220723/202207231534.YefS8hZX-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9c27ea557e7daaf1ef637c760e2ea4b29e5141b0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ecree-xilinx-com/sfc-VF-representors-for-EF100-RX-side/20220723-001059
        git checkout 9c27ea557e7daaf1ef637c760e2ea4b29e5141b0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   s390-linux-ld: s390-linux-ld: DWARF error: could not find abbrev number 119
   drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_probe_netdev_pf':
   ef100_nic.c:(.text+0x2520): undefined reference to `efx_mae_mport_wire'
   s390-linux-ld: ef100_nic.c:(.text+0x2534): undefined reference to `efx_mae_lookup_mport'
   s390-linux-ld: s390-linux-ld: DWARF error: could not find abbrev number 13089
   drivers/net/ethernet/sfc/ef100_rx.o: in function `__ef100_rx_packet':
   ef100_rx.c:(.text+0x1f8): undefined reference to `efx_ef100_find_rep_by_mport'
>> s390-linux-ld: ef100_rx.c:(.text+0x240): undefined reference to `efx_ef100_rep_rx_packet'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
