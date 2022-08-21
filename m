Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1E59B503
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiHUPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 11:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHUPXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 11:23:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42952237D9
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 08:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661095380; x=1692631380;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8/iNi7dL+X0JQfBLWYDScHJZL12LFVVUc4/cZIXyHxU=;
  b=XnNK4aKZtqGAGY9FD6FeLe5ZZxuNApje47NhJ/n7pxK9lVlC2M7z2gMM
   hJnWgTFvdS3vbz18SINEZzDPby6ljVFCtu49u06vzBgxCHy5r4dQt1n3T
   J+VrNhubDoN++dpV0hFxg4ILSNgZK7FfuywQkgSrlz/4GAD/LbB1IoNT7
   /HCOopirxlGTxiKmAeXZoQWXkHB+Y55lYL1/uG1/I9SH3XECTZTTxJYd+
   7kAy6txmqYbfz5OPsjECPhbaDIZDIgKfpszget5fhJi4I91sQSXCADnIS
   RfUWdQFH6Wy0l7j2UwhUPLVgkavxgzE+L7nkdIhcVA3xkCx6k+xCZTANd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="294540666"
X-IronPort-AV: E=Sophos;i="5.93,253,1654585200"; 
   d="scan'208";a="294540666"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 08:22:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,252,1654585200"; 
   d="scan'208";a="698022770"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Aug 2022 08:22:53 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oPmmq-0004EZ-1s;
        Sun, 21 Aug 2022 15:22:52 +0000
Date:   Sun, 21 Aug 2022 23:22:22 +0800
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
Message-ID: <202208212326.87xlsbQB-lkp@intel.com>
References: <20220818222742.1070935-11-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818222742.1070935-11-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20220821/202208212326.87xlsbQB-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 01ffe31cbb54bfd8e38e71b3cf804a1d67ebf9c1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/d3c6eac5778f2ce74e7d6d7be90a60f616551718
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jacob-Keller/ptp-convert-drivers-to-adjfine/20220819-063154
        git checkout d3c6eac5778f2ce74e7d6d7be90a60f616551718
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/microchip/lan743x_ptp.c:368:12: error: redefinition of 'lan743x_ptpci_adjfine'
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


vim +/lan743x_ptpci_adjfine +368 drivers/net/ethernet/microchip/lan743x_ptp.c

   367	
 > 368	static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long delta)
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
