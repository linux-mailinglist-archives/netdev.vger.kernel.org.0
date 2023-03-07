Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C816AD4E9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 03:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCGCl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 21:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCGClw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 21:41:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1530B46A
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 18:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678156910; x=1709692910;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V5fpbuqmVWnry+7VIMU4yY/4WzxardrUF5CX33Br85U=;
  b=Lg8u5Ym8ks6RleGbtDOsNanLSzoKO+26pS4XFx4C8K51yKYI3vxoTmwi
   wNjsaYoGf9iCKLoAYwRQlp7sn0mJpu6i8sAmd1/4DAWsT2/IRP9jc/14z
   unXNcIKxrZ3O++lwD8kJkqeYuelEtqfI2rR0IkUMhaeaSWEtjqBMPda2h
   OlYsrqnyRH3xSQ5jn9t8xStUjWHY0oiaFYfIBgNoztDGDR4yElxk06g9z
   aKzKDimMxCAEaUzznMVfGvI8y3Y9qot88ItfWOat6G13EgRh5X8ip8VTp
   fhSTpJG3vuhKOH7+OkDv33u0rBvsnaba6HL8ODjauxHE2jmP8Tr0AzDNK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315401789"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="315401789"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 18:41:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819557506"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="819557506"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 06 Mar 2023 18:41:47 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZNGs-0000sn-2e;
        Tue, 07 Mar 2023 02:41:46 +0000
Date:   Tue, 7 Mar 2023 10:40:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Vadim Fedorenko <vadfed@meta.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
Message-ID: <202303071016.BkAkCGA9-lkp@intel.com>
References: <20230306165344.350387-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306165344.350387-1-vadfed@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/bnxt_en-reset-PHC-frequency-in-free-running-mode/20230307-005700
patch link:    https://lore.kernel.org/r/20230306165344.350387-1-vadfed%40meta.com
patch subject: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
config: riscv-randconfig-r042-20230306 (https://download.01.org/0day-ci/archive/20230307/202303071016.BkAkCGA9-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/26d7b40eb9dd69f66a477fab7cf51d98c3fe63de
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/bnxt_en-reset-PHC-frequency-in-free-running-mode/20230307-005700
        git checkout 26d7b40eb9dd69f66a477fab7cf51d98c3fe63de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/broadcom/bnxt/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303071016.BkAkCGA9-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:948:4: error: call to undeclared function 'bnxt_ptp_adjfreq_rtc'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                           bnxt_ptp_adjfreq_rtc(bp, 0);
                           ^
   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:948:4: note: did you mean 'bnxt_ptp_adjfine_rtc'?
   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:208:12: note: 'bnxt_ptp_adjfine_rtc' declared here
   static int bnxt_ptp_adjfine_rtc(struct bnxt *bp, long scaled_ppm)
              ^
   1 error generated.


vim +/bnxt_ptp_adjfreq_rtc +948 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c

   919	
   920	int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
   921	{
   922		struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
   923		int rc;
   924	
   925		if (!ptp)
   926			return 0;
   927	
   928		rc = bnxt_map_ptp_regs(bp);
   929		if (rc)
   930			return rc;
   931	
   932		if (ptp->ptp_clock && bnxt_pps_config_ok(bp))
   933			return 0;
   934	
   935		bnxt_ptp_free(bp);
   936	
   937		atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
   938		spin_lock_init(&ptp->ptp_lock);
   939	
   940		if (BNXT_PTP_RTC(ptp->bp)) {
   941			bnxt_ptp_timecounter_init(bp, false);
   942			rc = bnxt_ptp_init_rtc(bp, phc_cfg);
   943			if (rc)
   944				goto out;
   945		} else {
   946			bnxt_ptp_timecounter_init(bp, true);
   947			if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
 > 948				bnxt_ptp_adjfreq_rtc(bp, 0);
   949		}
   950	
   951		ptp->ptp_info = bnxt_ptp_caps;
   952		if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
   953			if (bnxt_ptp_pps_init(bp))
   954				netdev_err(bp->dev, "1pps not initialized, continuing without 1pps support\n");
   955		}
   956		ptp->ptp_clock = ptp_clock_register(&ptp->ptp_info, &bp->pdev->dev);
   957		if (IS_ERR(ptp->ptp_clock)) {
   958			int err = PTR_ERR(ptp->ptp_clock);
   959	
   960			ptp->ptp_clock = NULL;
   961			rc = err;
   962			goto out;
   963		}
   964		if (bp->flags & BNXT_FLAG_CHIP_P5) {
   965			spin_lock_bh(&ptp->ptp_lock);
   966			bnxt_refclk_read(bp, NULL, &ptp->current_time);
   967			WRITE_ONCE(ptp->old_time, ptp->current_time);
   968			spin_unlock_bh(&ptp->ptp_lock);
   969			ptp_schedule_worker(ptp->ptp_clock, 0);
   970		}
   971		return 0;
   972	
   973	out:
   974		bnxt_ptp_free(bp);
   975		bnxt_unmap_ptp_regs(bp);
   976		return rc;
   977	}
   978	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
