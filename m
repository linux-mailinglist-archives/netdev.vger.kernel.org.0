Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A354D9870
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbiCOKLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbiCOKLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:11:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EE74FC63
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647339027; x=1678875027;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dyO6cJ7nxQB3Iumj74G/BSyRknWn8/ENJUPhOhBNoqc=;
  b=VXuSOwdSW2lpDrAdVvMCD8nHMPHy2pFowYyRPqZKnwFlqEjt5F6VSL4Q
   JJsNeAnOj5Ny++s2QqsmcoC4d1HhXxosXg0l9+/tU2Xh2tBgnacpODrAk
   hTg/hsNeCdeBRzu3y8o3syrFZLE6UD0MzGki7m3DXk3kcQ/k4xTeVkqTK
   OBRtyEFKhcC1jBZmMsnfb1vv1TEz/lxvMVYRzMTe5EPUv0fMlEVFADogq
   QwDVTZkDzsEWYgN0MG9DudyC2dbRvJJTQ8UBvsK2tPMPtFRmOYe1ccG9W
   zd+hCWBZ9j0wWFhe0oEpgHZ6sf1ubMJ0IURrZwszyH3QMNHOhUwgP/6gW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238429346"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="238429346"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 03:10:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="512554983"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 15 Mar 2022 03:10:24 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nU48G-000Ape-8u; Tue, 15 Mar 2022 10:10:24 +0000
Date:   Tue, 15 Mar 2022 18:09:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support for PTP-IO Event
 Input External Timestamp (extts)
Message-ID: <202203151833.ngWkLpqo-lkp@intel.com>
References: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Raju,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Raju-Lakkaraju/net-lan743x-PCI11010-PCI11414-devices-Enhancements/20220315-141814
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git bdd6a89de44b9e07d0b106076260d2367fe0e49a
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220315/202203151833.ngWkLpqo-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/11e2990b814fce8f91e9aa9d11d9dc04869d6856
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Raju-Lakkaraju/net-lan743x-PCI11010-PCI11414-devices-Enhancements/20220315-141814
        git checkout 11e2990b814fce8f91e9aa9d11d9dc04869d6856
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/ethernet/microchip/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/microchip/lan743x_ptp.c: In function 'lan743x_ptp_io_extts':
>> drivers/net/ethernet/microchip/lan743x_ptp.c:776:31: warning: variable 'extts' set but not used [-Wunused-but-set-variable]
     776 |         struct lan743x_extts *extts;
         |                               ^~~~~


vim +/extts +776 drivers/net/ethernet/microchip/lan743x_ptp.c

   769	
   770	static int lan743x_ptp_io_extts(struct lan743x_adapter *adapter, int on,
   771					struct ptp_extts_request *extts_request)
   772	{
   773		struct lan743x_ptp *ptp = &adapter->ptp;
   774		u32 flags = extts_request->flags;
   775		u32 index = extts_request->index;
 > 776		struct lan743x_extts *extts;
   777		int extts_pin;
   778		int ret = 0;
   779	
   780		extts = &ptp->extts[index];
   781	
   782		if (on) {
   783			extts_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS, index);
   784			if (extts_pin < 0)
   785				return -EBUSY;
   786	
   787			ret = lan743x_ptp_io_event_cap_en(adapter, flags, index);
   788		} else {
   789			lan743x_ptp_io_extts_off(adapter, index);
   790		}
   791	
   792		return ret;
   793	}
   794	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
