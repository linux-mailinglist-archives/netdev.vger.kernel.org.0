Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7F25BA379
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 02:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIPAYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 20:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIPAYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 20:24:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CEB474DC;
        Thu, 15 Sep 2022 17:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663287846; x=1694823846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cAdd5+vVt/BW9KNFn2eov/Wj/eJTa5EkJwrQunlSkfY=;
  b=E/WsYcLL5FxHqXnDOvSq/QFq8wTC5l5unjCEMZRkNJ361fyVQGJrlJRQ
   zx0/ELfn9Itys0VPXPl08nKAaMrOWffEXZZeJKZOEwQLSprR3NfWwwBt5
   wyoyIz2RKgiv8HmG0PiEDKqH7nn79aZIPwlBi2ZK0LLSBAf/+i1o13rK4
   AbrDLovpXsq5eN0VPd1A+T4ywcelwdDy0IO7ikzkugVuIkIkTGHaslrt0
   0uKZgnkLy9QKLt97VStTVvktXX6b0nyqzWNDaJnbowqsIcBn0mz1qsYM/
   ncjKfUUiOKWTvp7dkAqlB8ttHwcrR/ypmNhUuwLN4KMPh2nAFFAmDDPG5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="362840653"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="362840653"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 17:24:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="706566192"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2022 17:23:58 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oYz9C-0001DR-05;
        Fri, 16 Sep 2022 00:23:58 +0000
Date:   Fri, 16 Sep 2022 08:22:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: deny offload of tc-based TSN features on
 VF interfaces
Message-ID: <202209160845.t6gOLc8N-lkp@intel.com>
References: <20220915173813.2759394-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915173813.2759394-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vladimir-Oltean/net-enetc-deny-offload-of-tc-based-TSN-features-on-VF-interfaces/20220916-013912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 0727a9a5fbc1151fcaebfa9772e9f68f5e38ba9e
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220916/202209160845.t6gOLc8N-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1f0bd337274106be7953b9b310312bafb2ae3618
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vladimir-Oltean/net-enetc-deny-offload-of-tc-based-TSN-features-on-VF-interfaces/20220916-013912
        git checkout 1f0bd337274106be7953b9b310312bafb2ae3618
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "enetc_psfp_clean" [drivers/net/ethernet/freescale/enetc/fsl-enetc-vf.ko] undefined!
>> ERROR: modpost: "enetc_psfp_init" [drivers/net/ethernet/freescale/enetc/fsl-enetc-vf.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
