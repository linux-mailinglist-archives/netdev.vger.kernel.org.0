Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C179948830C
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 11:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiAHKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 05:33:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:64919 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233889AbiAHKdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 05:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641638034; x=1673174034;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ppvjGqSoLVShHXC4YF5MxIx7sa8dFXIAqMsn1Zwu0ZE=;
  b=QWObpdq2j4E3xZ8JJ8oDPXiBTly9usEOu7wsIUTeowovb9O2QHPCd3ML
   o9SU7d6XCnhmnsmLqKDNTmM/1FIwwuAgMH9BDUUAqZwEVHwIoSXifqkRo
   0drjuonAgdEpWKbtHU3d69e8pU+aDvuJHsMCYxyyJE6ZbXMJDdIwnGiMg
   XWZLtL0oZnRvKBrQuJ/bPWh3vDCVZmbS5qTqyr5v0Oz+fTOCTGTDmG5tJ
   spPD1pX3JHlNUoJcDNTn9HW1nSkTebb6IdJgoR9h5o44RgGp5oCD3KhRM
   MxSD1LHSj9Ju1A+oo6Ac8ErMOILMZEpVOMpRSmaN0W336GQE7G4Uv1s6+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="243203606"
X-IronPort-AV: E=Sophos;i="5.88,272,1635231600"; 
   d="scan'208";a="243203606"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2022 02:33:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,272,1635231600"; 
   d="scan'208";a="489553265"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 08 Jan 2022 02:33:51 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n692k-0000W9-Nn; Sat, 08 Jan 2022 10:33:50 +0000
Date:   Sat, 8 Jan 2022 18:33:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Arthur Kiyanovski <akiyano@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>
Subject: Re: [PATCH V1 net-next 10/10] net: ena: Extract recurring driver
 reset code into a function
Message-ID: <202201081810.cbanKMEo-lkp@intel.com>
References: <20220106192915.22616-11-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106192915.22616-11-akiyano@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arthur,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Arthur-Kiyanovski/ENA-capabilities-field-and-cosmetic/20220107-034036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 710ad98c363a66a0cd8526465426c5c5f8377ee0
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220108/202201081810.cbanKMEo-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/fc12048d64c67fe13a46a2a3932df606c29ac4d9
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Arthur-Kiyanovski/ENA-capabilities-field-and-cosmetic/20220107-034036
        git checkout fc12048d64c67fe13a46a2a3932df606c29ac4d9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/ethernet/amazon/ena/ena_netdev.c:21:
   drivers/net/ethernet/amazon/ena/ena_netdev.h: In function 'ena_reset_device':
>> drivers/net/ethernet/amazon/ena/ena_netdev.h:399:31: warning: implicit conversion from 'enum ena_flags_t' to 'enum ena_regs_reset_reason_types' [-Wenum-conversion]
     399 |         adapter->reset_reason = reset_reason;
         |                               ^
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'ena_tx_timeout':
>> drivers/net/ethernet/amazon/ena/ena_netdev.c:106:35: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
     106 |         ena_reset_device(adapter, ENA_REGS_RESET_OS_NETDEV_WD);
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'ena_xmit_common':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:171:42: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
     171 |                                          ENA_REGS_RESET_DRIVER_INVALID_STATE);
         |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'handle_invalid_req_id':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:1280:41: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    1280 |         ena_reset_device(ring->adapter, ENA_REGS_RESET_INV_TX_REQ_ID);
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'ena_rx_skb':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:1444:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    1444 |                 ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ_ID);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'ena_clean_rx_irq':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:1777:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    1777 |                 ena_reset_device(adapter, ENA_REGS_RESET_TOO_MANY_RX_DESCS);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c:1781:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    1781 |                 ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ_ID);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'check_for_rx_interrupt_queue':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3701:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    3701 |                 ena_reset_device(adapter, ENA_REGS_RESET_MISS_INTERRUPT);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'check_missing_comp_in_tx_queue':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3738:51: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    3738 |                         ena_reset_device(adapter, ENA_REGS_RESET_MISS_INTERRUPT);
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3764:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    3764 |                 ena_reset_device(adapter, ENA_REGS_RESET_MISS_TX_CMPL);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'check_for_missing_keep_alive':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3885:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    3885 |                 ena_reset_device(adapter, ENA_REGS_RESET_KEEP_ALIVE_TO);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'check_for_admin_com_state':
   drivers/net/ethernet/amazon/ena/ena_netdev.c:3896:43: warning: implicit conversion from 'enum ena_regs_reset_reason_types' to 'enum ena_flags_t' [-Wenum-conversion]
    3896 |                 ena_reset_device(adapter, ENA_REGS_RESET_ADMIN_TO);
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from drivers/net/ethernet/amazon/ena/ena_ethtool.c:9:
   drivers/net/ethernet/amazon/ena/ena_netdev.h: In function 'ena_reset_device':
>> drivers/net/ethernet/amazon/ena/ena_netdev.h:399:31: warning: implicit conversion from 'enum ena_flags_t' to 'enum ena_regs_reset_reason_types' [-Wenum-conversion]
     399 |         adapter->reset_reason = reset_reason;
         |                               ^


vim +399 drivers/net/ethernet/amazon/ena/ena_netdev.h

   396	
   397	static inline void ena_reset_device(struct ena_adapter *adapter, enum ena_flags_t reset_reason)
   398	{
 > 399		adapter->reset_reason = reset_reason;
   400		/* Make sure reset reason is set before triggering the reset */
   401		smp_mb__before_atomic();
   402		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
   403	}
   404	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
