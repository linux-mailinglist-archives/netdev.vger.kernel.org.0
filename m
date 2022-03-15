Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FB74D98CA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbiCOKdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347152AbiCOKdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:33:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3674EA32
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647340309; x=1678876309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BKdKfUow0O5/kI9+9p24H9wMrL1nAtlaFqxWtERolQ4=;
  b=VPviXUZ22vqmt9O3TcMkyUwFLXpEhOTCUZpxB75FmgXztyyuYFBCoJiD
   jHsodp1J1/2M4pfa17rrc0twgL8einf+iI5+2Fxs6o6ZX2X2f9R2SG00K
   9zIHYhdJnKH9bbRKqdhy2R8a3mZd7V0F9AYqzQeIIHkBe0IMhonPOC1YP
   v96v7B5hxt3j95fA7lZ4ROTrN//aPB6lBg8MsrCJ5x6TbEbVqY569F+k/
   6/WrmykmdujYATFzYNqTxnoi4kol2jNZbMQTyQn7S6JGokQYM6QuqZlb1
   ns++1jBW6gZhG8DZO8ciUlRQQQT6zoEnA8Y20Pza9/98hB/wsrpn7i7ap
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255095726"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="255095726"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 03:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="497965885"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 15 Mar 2022 03:31:25 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nU4Sb-000AqZ-1q; Tue, 15 Mar 2022 10:31:25 +0000
Date:   Tue, 15 Mar 2022 18:30:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support for PTP-IO Event
 Input External Timestamp (extts)
Message-ID: <202203151830.yeCpaesp-lkp@intel.com>
References: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: i386-randconfig-a015-20220314 (https://download.01.org/0day-ci/archive/20220315/202203151830.yeCpaesp-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a6b2f50fb47da3baeee10b1906da6e30ac5d26ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/11e2990b814fce8f91e9aa9d11d9dc04869d6856
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Raju-Lakkaraju/net-lan743x-PCI11010-PCI11414-devices-Enhancements/20220315-141814
        git checkout 11e2990b814fce8f91e9aa9d11d9dc04869d6856
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/microchip/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/microchip/lan743x_ptp.c:776:24: warning: variable 'extts' set but not used [-Wunused-but-set-variable]
           struct lan743x_extts *extts;
                                 ^
   1 warning generated.


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
