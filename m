Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A334599328
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbiHSCrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbiHSCrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:47:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2CACCD66
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660877254; x=1692413254;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jcKwrTNRwZ50GiiU+OeWOwCLdIPtugAJms3wzDX5Rd0=;
  b=CUvMjR6rsjfbcgC6p+Rl/NgNTi/Y05DwJ3EWoM71rJkiRKv4GiLppb5z
   a5tk5mia1DkIClamjDIDDvsULIjy3yOwIeSRyoKSZlR6GGPqV84TqUfqh
   XgxJI5Ayo3mmu/UwTSUX62mi60Uce2kHpaVJrl5HucKuD7SR3V1SDkM9w
   xE0hQWInkRbBs4VFyEX5X64WKwliinbHmdAgLvXxWhPbdLDjO/JLgJjpb
   Zq/5fFZqgaRMOkPrbFElKvtXCWB5jpvVVCr/LvWaPhqLPfPoOJ5vBRxkD
   nUaVGcgJ+lvmWB/XeSocjDxssHjhWyvYdiLPH9E6vG3tzHuup+UsQQTBO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="272691071"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="272691071"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 19:47:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="604464991"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 18 Aug 2022 19:47:26 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOs2f-0000yY-2h;
        Fri, 19 Aug 2022 02:47:25 +0000
Date:   Fri, 19 Aug 2022 10:47:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>
Subject: Re: [net-next 10/14] ptp: lan743x: convert to .adjfine and
 diff_by_scaled_ppm
Message-ID: <202208191003.18DiEs1l-lkp@intel.com>
References: <20220818222742.1070935-11-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818222742.1070935-11-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacob,

I love your patch! Yet something to improve:

[auto build test ERROR on 9017462f006c4b686cb1e1e1a3a52ea8363076e6]

url:    https://github.com/intel-lab-lkp/linux/commits/Jacob-Keller/ptp-convert-drivers-to-adjfine/20220819-063154
base:   9017462f006c4b686cb1e1e1a3a52ea8363076e6
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20220819/202208191003.18DiEs1l-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d3c6eac5778f2ce74e7d6d7be90a60f616551718
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jacob-Keller/ptp-convert-drivers-to-adjfine/20220819-063154
        git checkout d3c6eac5778f2ce74e7d6d7be90a60f616551718
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/microchip/lan743x_ptp.c:368:12: error: redefinition of 'lan743x_ptpci_adjfine'
   static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long delta)
              ^
   drivers/net/ethernet/microchip/lan743x_ptp.c:335:12: note: previous definition is here
   static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
              ^
>> drivers/net/ethernet/microchip/lan743x_ptp.c:386:3: error: use of undeclared identifier 'lan743_rate_adj'; did you mean 'lan743x_rate_adj'?
                   lan743_rate_adj = (u32)diff;
                   ^~~~~~~~~~~~~~~
                   lan743x_rate_adj
   drivers/net/ethernet/microchip/lan743x_ptp.c:374:6: note: 'lan743x_rate_adj' declared here
           u64 lan743x_rate_adj;
               ^
>> drivers/net/ethernet/microchip/lan743x_ptp.c:388:3: error: use of undeclared identifier 'lan74e_rage_adj'; did you mean 'lan743x_rate_adj'?
                   lan74e_rage_adj = (u32)diff | PTP_CLOCK_RATE_ADJ_DIR_;
                   ^~~~~~~~~~~~~~~
                   lan743x_rate_adj
   drivers/net/ethernet/microchip/lan743x_ptp.c:374:6: note: 'lan743x_rate_adj' declared here
           u64 lan743x_rate_adj;
               ^
   3 errors generated.


vim +386 drivers/net/ethernet/microchip/lan743x_ptp.c

   367	
   368	static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long delta)
   369	{
   370		struct lan743x_ptp *ptp =
   371			container_of(ptpci, struct lan743x_ptp, ptp_clock_info);
   372		struct lan743x_adapter *adapter =
   373			container_of(ptp, struct lan743x_adapter, ptp);
   374		u64 lan743x_rate_adj;
   375		s32 delta_ppb;
   376		u64 diff;
   377	
   378		delta_ppb = scaled_ppm_to_ppb(delta);
   379		if ((delta_ppb < (-LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB)) ||
   380		    delta_ppb > LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB) {
   381			return -EINVAL;
   382		}
   383	
   384		/* diff_by_scaled_ppm returns true if the difference is negative */
   385		if (diff_by_scaled_ppm(1ULL << 35, delta, &diff))
 > 386			lan743_rate_adj = (u32)diff;
   387		else
 > 388			lan74e_rage_adj = (u32)diff | PTP_CLOCK_RATE_ADJ_DIR_;
   389	
   390		lan743x_csr_write(adapter, PTP_CLOCK_RATE_ADJ,
   391				  lan743x_rate_adj);
   392	
   393		return 0;
   394	}
   395	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
