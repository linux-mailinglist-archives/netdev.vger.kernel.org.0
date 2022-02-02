Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18F4A6F1D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiBBKq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:46:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:8663 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbiBBKq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 05:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643798816; x=1675334816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+0frq3/pxSbf/XvLi5+RhsXZXIGjY/DHMNgJEUnWoi4=;
  b=gRmgf1IK5BVtkK15hHmJ+WR14VFeMffOQ+ETP0t6KlkMkIx4c5H3kQsp
   aTnvjdP2T0EqT06RCHThUiRnwyEFDMmVj7BeJCSO5ZAlAji85GLl6Cicg
   pvJy3xj+OnCsUi4cVRH5of5ui1MJgQQmKJ+Xy29iXZzOhD2q1cd2q9W0T
   1Avufh5+1wezQhOGZcsn2M7NzPJZ4LJLdpjEjLf47kbkmpKX5UK0VuX1C
   ruWtn4WdFbRAywyL5o73zloGMs9unD3W8tNbm8dZ0SZpCWx2+ofBRagky
   v+ePj2L9Jn5/5HeScP8e7NbdDfVdT57M/dtNAwV5eYQ2E1hBQH73OVny9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="235287987"
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="235287987"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 02:46:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="771401008"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2022 02:46:52 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFDA3-000UTg-UZ; Wed, 02 Feb 2022 10:46:51 +0000
Date:   Wed, 2 Feb 2022 18:46:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: net: Replace acpi_bus_get_device()
Message-ID: <202202021810.82z7OPTR-lkp@intel.com>
References: <11918902.O9o76ZdvQC@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11918902.O9o76ZdvQC@kreacher>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Rafael,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v5.17-rc2 next-20220202]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Rafael-J-Wysocki/drivers-net-Replace-acpi_bus_get_device/20220202-035902
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 881cc731df6af99a21622e9be25a23b81adcd10b
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20220202/202202021810.82z7OPTR-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 6b1e844b69f15bb7dffaf9365cd2b355d2eb7579)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1d2a29e30eb391a02f25f551e6f4242e32f5b01f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Rafael-J-Wysocki/drivers-net-Replace-acpi_bus_get_device/20220202-035902
        git checkout 1d2a29e30eb391a02f25f551e6f4242e32f5b01f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/media/cec/platform/seco/ drivers/net/ethernet/cavium/thunder/ drivers/net/wireless/ath/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/cavium/thunder/thunder_bgx.c:1409:24: error: use of undeclared identifier 'bgx'
           struct device *dev = &bgx->pdev->dev;
                                 ^
   1 error generated.


vim +/bgx +1409 drivers/net/ethernet/cavium/thunder/thunder_bgx.c

46b903a01c053d0 David Daney       2015-08-10  1403  
46b903a01c053d0 David Daney       2015-08-10  1404  /* Currently only sets the MAC address. */
46b903a01c053d0 David Daney       2015-08-10  1405  static acpi_status bgx_acpi_register_phy(acpi_handle handle,
46b903a01c053d0 David Daney       2015-08-10  1406  					 u32 lvl, void *context, void **rv)
46b903a01c053d0 David Daney       2015-08-10  1407  {
1d2a29e30eb391a Rafael J. Wysocki 2022-02-01  1408  	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
1d82efaca87ecf5 Robert Richter    2016-02-11 @1409  	struct device *dev = &bgx->pdev->dev;
1d2a29e30eb391a Rafael J. Wysocki 2022-02-01  1410  	struct bgx *bgx = context;
46b903a01c053d0 David Daney       2015-08-10  1411  
1d2a29e30eb391a Rafael J. Wysocki 2022-02-01  1412  	if (!adev)
46b903a01c053d0 David Daney       2015-08-10  1413  		goto out;
46b903a01c053d0 David Daney       2015-08-10  1414  
7aa4865506a26c6 Vadim Lomovtsev   2017-01-12  1415  	acpi_get_mac_address(dev, adev, bgx->lmac[bgx->acpi_lmac_idx].mac);
46b903a01c053d0 David Daney       2015-08-10  1416  
7aa4865506a26c6 Vadim Lomovtsev   2017-01-12  1417  	SET_NETDEV_DEV(&bgx->lmac[bgx->acpi_lmac_idx].netdev, dev);
46b903a01c053d0 David Daney       2015-08-10  1418  
7aa4865506a26c6 Vadim Lomovtsev   2017-01-12  1419  	bgx->lmac[bgx->acpi_lmac_idx].lmacid = bgx->acpi_lmac_idx;
7aa4865506a26c6 Vadim Lomovtsev   2017-01-12  1420  	bgx->acpi_lmac_idx++; /* move to next LMAC */
46b903a01c053d0 David Daney       2015-08-10  1421  out:
46b903a01c053d0 David Daney       2015-08-10  1422  	return AE_OK;
46b903a01c053d0 David Daney       2015-08-10  1423  }
46b903a01c053d0 David Daney       2015-08-10  1424  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
