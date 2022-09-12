Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F825B6245
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 22:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiILUgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 16:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiILUge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 16:36:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1224A12A
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 13:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663014993; x=1694550993;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4BJYF1bd77SD6tn2NnM61W0IQj2Yv3kWjTUu2xYQ1FU=;
  b=BEvaZIgGl5efHoXtZWGa9rVX6rZUB2cNBs8l4gZ8IFTeJ/WHZNNBiH14
   WBbT1J3QeZPwqtZ78hqjBYgYXnlD70afEuHnyHThEUxAN8jSXHa6CahKO
   FpMlIqZ43WponKgyxiSvpmJKcORuSadM+vt+p9XIwiTDh9LhpY9MazVnK
   fp3BpigzkA4+cR97mDOE90/PEvFWhZcgRVSkHZSJ7QrTmMdg+LDiIWYuP
   5LYvF8va6Lp0P9kYsPVMhrNkqNLv9orIdk3El/9KYRAUn4ZEeWHt4W2KD
   KchlqSBZshF/n3T+M6rQi5jTO12NJKpLlQKglIIQhAjNKCTLRM7Fxiypw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="299303514"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="299303514"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 13:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="944781648"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 12 Sep 2022 13:36:29 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXqAP-0002q3-10;
        Mon, 12 Sep 2022 20:36:29 +0000
Date:   Tue, 13 Sep 2022 04:35:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next v9 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <202209130407.qiDGG9Fc-lkp@intel.com>
References: <20220912112855.339804-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912112855.339804-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattias,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mattias-Forsblad/net-dsa-qca8k-mv88e6xxx-rmon-Add-RMU-support/20220912-193037
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 169ccf0e40825d9e465863e4707d8e8546d3c3cb
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220913/202209130407.qiDGG9Fc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/b03ebbb0863a615ff974c10aab6dac036db63459
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-dsa-qca8k-mv88e6xxx-rmon-Add-RMU-support/20220912-193037
        git checkout b03ebbb0863a615ff974c10aab6dac036db63459
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/dsa/mv88e6xxx/chip.c:45:
>> drivers/net/dsa/mv88e6xxx/rmu.h:20:17: warning: 'mv88e6xxx_rmu_dest_addr' defined but not used [-Wunused-const-variable=]
      20 | static const u8 mv88e6xxx_rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
         |                 ^~~~~~~~~~~~~~~~~~~~~~~


vim +/mv88e6xxx_rmu_dest_addr +20 drivers/net/dsa/mv88e6xxx/rmu.h

    19	
  > 20	static const u8 mv88e6xxx_rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
    21	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
