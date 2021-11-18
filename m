Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A79455DB2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhKROQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:16:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:2848 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232816AbhKROQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:16:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="320404743"
X-IronPort-AV: E=Sophos;i="5.87,245,1631602800"; 
   d="gz'50?scan'50,208,50";a="320404743"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 06:13:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,245,1631602800"; 
   d="gz'50?scan'50,208,50";a="505802679"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2021 06:12:57 -0800
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mni9o-0003Be-Sa; Thu, 18 Nov 2021 14:12:56 +0000
Date:   Thu, 18 Nov 2021 22:12:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/9] net: constify netdev->dev_addr
Message-ID: <202111182225.l6EjruZJ-lkp@intel.com>
References: <20211118041501.3102861-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20211118041501.3102861-6-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jakub,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Kicinski/net-constify-netdev-dev_addr/20211118-121649
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 75082e7f46809432131749f4ecea66864d0f7438
config: x86_64-randconfig-s032-20211118 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/ea5373ba01c0915c0dceb67e2df2b05343642b84
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-constify-netdev-dev_addr/20211118-121649
        git checkout ea5373ba01c0915c0dceb67e2df2b05343642b84
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2820:55: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned char [usertype] *addr @@     got unsigned char const *dev_addr @@
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2820:55: sparse:     expected unsigned char [usertype] *addr
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2820:55: sparse:     got unsigned char const *dev_addr
--
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:121:25: sparse: sparse: symbol 'bnx2x_iov_wq' was not declared. Should it be static?
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:8555:57: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned char [usertype] *addr @@     got unsigned char const *dev_addr @@
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:8555:57: sparse:     expected unsigned char [usertype] *addr
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:8555:57: sparse:     got unsigned char const *dev_addr

vim +2820 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c

9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2626  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2627  	bp->state = BNX2X_STATE_OPENING_WAIT4_LOAD;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2628  
16a5fd9265e757 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-06-02  2629  	/* zero the structure w/o any lock, before SP handler is initialized */
2ae17f666099c9 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-05-04  2630  	memset(&bp->last_reported_link, 0, sizeof(bp->last_reported_link));
2ae17f666099c9 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-05-04  2631  	__set_bit(BNX2X_LINK_REPORT_LINK_DOWN,
2ae17f666099c9 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-05-04  2632  		&bp->last_reported_link.link_report_flags);
2ae17f666099c9 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-05-04  2633  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2634  	if (IS_PF(bp))
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2635  		/* must be called before memory allocation and HW init */
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2636  		bnx2x_ilt_set_info(bp);
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2637  
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2638  	/*
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2639  	 * Zero fastpath structures preserving invariants like napi, which are
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2640  	 * allocated only once, fp index, max_cos, bp pointer.
7e6b4d440b0ae9 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Schmidt          2015-04-28  2641  	 * Also set fp->mode and txdata_ptr.
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2642  	 */
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2643  	DP(NETIF_MSG_IFUP, "num queues: %d", bp->num_queues);
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2644  	for_each_queue(bp, i)
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2645  		bnx2x_bz_fp(bp, i);
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2646  	memset(bp->bnx2x_txq, 0, (BNX2X_MAX_RSS_COUNT(bp) * BNX2X_MULTI_TX_COS +
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2647  				  bp->num_cnic_queues) *
65565884fba67d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-06-19  2648  				  sizeof(struct bnx2x_fp_txdata));
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2649  
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2650  	bp->fcoe_init = false;
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2651  
a8c94b9188bf60 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-02-06  2652  	/* Set the receive queues buffer size */
a8c94b9188bf60 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-02-06  2653  	bnx2x_set_rx_buf_size(bp);
a8c94b9188bf60 drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-02-06  2654  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2655  	if (IS_PF(bp)) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2656  		rc = bnx2x_alloc_mem(bp);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2657  		if (rc) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2658  			BNX2X_ERR("Unable to allocate bp memory\n");
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2659  			return rc;
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2660  		}
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2661  	}
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2662  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2663  	/* need to be done after alloc mem, since it's self adjusting to amount
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2664  	 * of memory available for RSS queues
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2665  	 */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2666  	rc = bnx2x_alloc_fp_mem(bp);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2667  	if (rc) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2668  		BNX2X_ERR("Unable to allocate memory for fps\n");
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2669  		LOAD_ERROR_EXIT(bp, load_error0);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2670  	}
d6214d7aaa9a82 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2671  
e3ed4eaef4932f drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2013-10-27  2672  	/* Allocated memory for FW statistics  */
fb653827c75872 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dan Carpenter           2021-08-05  2673  	rc = bnx2x_alloc_fw_stats_mem(bp);
fb653827c75872 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dan Carpenter           2021-08-05  2674  	if (rc)
e3ed4eaef4932f drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2013-10-27  2675  		LOAD_ERROR_EXIT(bp, load_error0);
e3ed4eaef4932f drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2013-10-27  2676  
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2677  	/* request pf to initialize status blocks */
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2678  	if (IS_VF(bp)) {
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2679  		rc = bnx2x_vfpf_init(bp);
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2680  		if (rc)
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2681  			LOAD_ERROR_EXIT(bp, load_error0);
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2682  	}
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2683  
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2684  	/* As long as bnx2x_alloc_mem() may possibly update
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2685  	 * bp->num_queues, bnx2x_set_real_num_queues() should always
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2686  	 * come after it. At this stage cnic queues are not counted.
b3b83c3f3c640b drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-05-04  2687  	 */
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2688  	rc = bnx2x_set_real_num_queues(bp, 0);
d6214d7aaa9a82 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2689  	if (rc) {
ec6ba945211b1c drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2010-12-13  2690  		BNX2X_ERR("Unable to set real_num_queues\n");
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2691  		LOAD_ERROR_EXIT(bp, load_error0);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2692  	}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2693  
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2694  	/* configure multi cos mappings in kernel.
16a5fd9265e757 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-06-02  2695  	 * this configuration may be overridden by a multi class queue
16a5fd9265e757 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-06-02  2696  	 * discipline or by a dcbx negotiation result.
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2697  	 */
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2698  	bnx2x_setup_tc(bp->dev, bp->max_cos);
6383c0b35b48bf drivers/net/bnx2x/bnx2x_cmn.c                   Ariel Elior             2011-07-14  2699  
26614ba5445fe3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-08-27  2700  	/* Add all NAPI objects */
26614ba5445fe3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-08-27  2701  	bnx2x_add_all_napi(bp);
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2702  	DP(NETIF_MSG_IFUP, "napi added\n");
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2703  	bnx2x_napi_enable(bp);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2704  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2705  	if (IS_PF(bp)) {
889b9af34f9861 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2012-01-26  2706  		/* set pf load just before approaching the MCP */
889b9af34f9861 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2012-01-26  2707  		bnx2x_set_pf_load(bp);
889b9af34f9861 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2012-01-26  2708  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2709  		/* if mcp exists send load request and analyze response */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2710  		if (!BP_NOMCP(bp)) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2711  			/* attempt to load pf */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2712  			rc = bnx2x_nic_load_request(bp, &load_code);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2713  			if (rc)
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2714  				LOAD_ERROR_EXIT(bp, load_error1);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2715  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2716  			/* what did mcp say? */
91ebb929b6f802 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-12-26  2717  			rc = bnx2x_compare_fw_ver(bp, load_code, true);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2718  			if (rc) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2719  				bnx2x_fw_command(bp, DRV_MSG_CODE_LOAD_DONE, 0);
d1e2d9660e6bca drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2012-01-26  2720  				LOAD_ERROR_EXIT(bp, load_error2);
d1e2d9660e6bca drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2012-01-26  2721  			}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2722  		} else {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2723  			load_code = bnx2x_nic_load_no_mcp(bp, port);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2724  		}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2725  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2726  		/* mark pmf if applicable */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2727  		bnx2x_nic_load_pmf(bp, load_code);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2728  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2729  		/* Init Function state controlling object */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2730  		bnx2x__init_func_obj(bp);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2731  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2732  		/* Initialize HW */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2733  		rc = bnx2x_init_hw(bp, load_code);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2734  		if (rc) {
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2735  			BNX2X_ERR("HW init failed, aborting\n");
a22f078867ef36 drivers/net/bnx2x/bnx2x_cmn.c                   Yaniv Rosner            2010-09-07  2736  			bnx2x_fw_command(bp, DRV_MSG_CODE_LOAD_DONE, 0);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2737  			LOAD_ERROR_EXIT(bp, load_error2);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2738  		}
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2739  	}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2740  
ecf01c22be0346 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-04-22  2741  	bnx2x_pre_irq_nic_init(bp);
ecf01c22be0346 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-04-22  2742  
d6214d7aaa9a82 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2743  	/* Connect to IRQs */
d6214d7aaa9a82 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2744  	rc = bnx2x_setup_irqs(bp);
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2745  	if (rc) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2746  		BNX2X_ERR("setup irqs failed\n");
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2747  		if (IS_PF(bp))
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2748  			bnx2x_fw_command(bp, DRV_MSG_CODE_LOAD_DONE, 0);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2749  		LOAD_ERROR_EXIT(bp, load_error2);
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2750  	}
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2751  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2752  	/* Init per-function objects */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2753  	if (IS_PF(bp)) {
ecf01c22be0346 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-04-22  2754  		/* Setup NIC internals and enable interrupts */
ecf01c22be0346 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-04-22  2755  		bnx2x_post_irq_nic_init(bp, load_code);
ecf01c22be0346 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-04-22  2756  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2757  		bnx2x_init_bp_objs(bp);
b56e9670ffa4de drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2758  		bnx2x_iov_nic_init(bp);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2759  
a334872224a67b drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-04-23  2760  		/* Set AFEX default VLAN tag to an invalid value */
a334872224a67b drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-04-23  2761  		bp->afex_def_vlan_tag = -1;
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2762  		bnx2x_nic_load_afex_dcc(bp, load_code);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2763  		bp->state = BNX2X_STATE_OPENING_WAIT4_PORT;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2764  		rc = bnx2x_func_start(bp);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2765  		if (rc) {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2766  			BNX2X_ERR("Function start failed!\n");
c636322b24eb69 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-07-19  2767  			bnx2x_fw_command(bp, DRV_MSG_CODE_LOAD_DONE, 0);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2768  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2769  			LOAD_ERROR_EXIT(bp, load_error3);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2770  		}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2771  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2772  		/* Send LOAD_DONE command to MCP */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2773  		if (!BP_NOMCP(bp)) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2774  			load_code = bnx2x_fw_command(bp,
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2775  						     DRV_MSG_CODE_LOAD_DONE, 0);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2776  			if (!load_code) {
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2777  				BNX2X_ERR("MCP response failure, aborting\n");
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2778  				rc = -EBUSY;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2779  				LOAD_ERROR_EXIT(bp, load_error3);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2780  			}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2781  		}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2782  
0c14e5ced26462 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-04-17  2783  		/* initialize FW coalescing state machines in RAM */
0c14e5ced26462 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-04-17  2784  		bnx2x_update_coalesce(bp);
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2785  	}
0c14e5ced26462 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-04-17  2786  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2787  	/* setup the leading queue */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2788  	rc = bnx2x_setup_leading(bp);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2789  	if (rc) {
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2790  		BNX2X_ERR("Setup leading failed!\n");
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2791  		LOAD_ERROR_EXIT(bp, load_error3);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2792  	}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2793  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2794  	/* set up the rest of the queues */
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2795  	for_each_nondefault_eth_queue(bp, i) {
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2796  		if (IS_PF(bp))
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2797  			rc = bnx2x_setup_queue(bp, &bp->fp[i], false);
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2798  		else /* VF */
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2799  			rc = bnx2x_vfpf_setup_q(bp, &bp->fp[i], false);
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2800  		if (rc) {
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2801  			BNX2X_ERR("Queue %d setup failed\n", i);
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2802  			LOAD_ERROR_EXIT(bp, load_error3);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2803  		}
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2804  	}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2805  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2806  	/* setup rss */
60cad4e67bd6ff drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-09-04  2807  	rc = bnx2x_init_rss(bp);
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2808  	if (rc) {
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2809  		BNX2X_ERR("PF RSS init failed\n");
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2810  		LOAD_ERROR_EXIT(bp, load_error3);
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2811  	}
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2812  
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2813  	/* Now when Clients are configured we are ready to work */
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2814  	bp->state = BNX2X_STATE_OPEN;
523224a3b3cd40 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-10-06  2815  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2816  	/* Configure a ucast MAC */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2817  	if (IS_PF(bp))
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2818  		rc = bnx2x_set_eth_mac(bp, true);
8d9ac297d18dbe drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2819  	else /* vf */
f8f4f61a5a3588 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2013-04-24 @2820  		rc = bnx2x_vfpf_config_mac(bp, bp->dev->dev_addr, bp->fp->index,
f8f4f61a5a3588 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2013-04-24  2821  					   true);
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2822  	if (rc) {
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2823  		BNX2X_ERR("Setting Ethernet MAC failed\n");
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2824  		LOAD_ERROR_EXIT(bp, load_error3);
51c1a580b1e07d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-03-18  2825  	}
6e30dd4e3935dd drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-02-06  2826  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2827  	if (IS_PF(bp) && bp->pending_max) {
e3835b99333eb3 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-03-06  2828  		bnx2x_update_max_mf_config(bp, bp->pending_max);
e3835b99333eb3 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-03-06  2829  		bp->pending_max = 0;
e3835b99333eb3 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-03-06  2830  	}
e3835b99333eb3 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2011-03-06  2831  
484c016d939278 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Sudarsana Reddy Kalluru 2018-06-28  2832  	bp->force_link_down = false;
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2833  	if (bp->port.pmf) {
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2834  		rc = bnx2x_initial_phy_init(bp, load_mode);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2835  		if (rc)
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2836  			LOAD_ERROR_EXIT(bp, load_error3);
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2837  	}
c63da990cd6315 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-12-05  2838  	bp->link_params.feature_config_flags &= ~FEATURE_CONFIG_BOOT_FROM_SAN;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2839  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2840  	/* Start fast path */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2841  
05cc5a39ddb74d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-29  2842  	/* Re-configure vlan filters */
05cc5a39ddb74d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-29  2843  	rc = bnx2x_vlan_reconfigure_vid(bp);
05cc5a39ddb74d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-29  2844  	if (rc)
05cc5a39ddb74d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-29  2845  		LOAD_ERROR_EXIT(bp, load_error3);
05cc5a39ddb74d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-29  2846  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2847  	/* Initialize Rx filter. */
8b09be5f173759 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-08-01  2848  	bnx2x_set_rx_mode_inner(bp);
6e30dd4e3935dd drivers/net/bnx2x/bnx2x_cmn.c                   Vladislav Zolotarov     2011-02-06  2849  
eeed018cbfa30c drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Kalderon         2014-08-17  2850  	if (bp->flags & PTP_SUPPORTED) {
07f12622a66320 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Sudarsana Reddy Kalluru 2018-12-12  2851  		bnx2x_register_phc(bp);
eeed018cbfa30c drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Kalderon         2014-08-17  2852  		bnx2x_init_ptp(bp);
eeed018cbfa30c drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Kalderon         2014-08-17  2853  		bnx2x_configure_ptp_filters(bp);
eeed018cbfa30c drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Kalderon         2014-08-17  2854  	}
eeed018cbfa30c drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Michal Kalderon         2014-08-17  2855  	/* Start Tx */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2856  	switch (load_mode) {
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2857  	case LOAD_NORMAL:
16a5fd9265e757 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2013-06-02  2858  		/* Tx queue should be only re-enabled */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2859  		netif_tx_wake_all_queues(bp->dev);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2860  		break;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2861  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2862  	case LOAD_OPEN:
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2863  		netif_tx_start_all_queues(bp->dev);
4e857c58efeb99 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Peter Zijlstra          2014-03-17  2864  		smp_mb__after_atomic();
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2865  		break;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2866  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2867  	case LOAD_DIAG:
8970b2e4393a34 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-06-19  2868  	case LOAD_LOOPBACK_EXT:
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2869  		bp->state = BNX2X_STATE_DIAG;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2870  		break;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2871  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2872  	default:
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2873  		break;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2874  	}
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2875  
00253a8cf3119a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2011-11-13  2876  	if (bp->port.pmf)
4c704899328bcb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-12-02  2877  		bnx2x_update_drv_flags(bp, 1 << DRV_FLAGS_PORT_MASK, 0);
00253a8cf3119a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Dmitry Kravkov          2011-11-13  2878  	else
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2879  		bnx2x__link_status_update(bp);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2880  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2881  	/* start the timer */
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2882  	mod_timer(&bp->timer, jiffies + bp->current_interval);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2883  
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2884  	if (CNIC_ENABLED(bp))
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2885  		bnx2x_load_cnic(bp);
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2886  
42f8277f56cf4a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2014-03-23  2887  	if (IS_PF(bp))
42f8277f56cf4a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2014-03-23  2888  		bnx2x_schedule_sp_rtnl(bp, BNX2X_SP_RTNL_GET_DRV_VERSION, 0);
42f8277f56cf4a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2014-03-23  2889  
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2890  	if (IS_PF(bp) && SHMEM2_HAS(bp, drv_capabilities_flag)) {
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2891  		/* mark driver is loaded in shmem2 */
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2892  		u32 val;
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2893  		val = SHMEM2_RD(bp, drv_capabilities_flag[BP_FW_MB_IDX(bp)]);
230d00eb4bfe0d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2894  		val &= ~DRV_FLAGS_MTU_MASK;
230d00eb4bfe0d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2895  		val |= (bp->dev->mtu << DRV_FLAGS_MTU_SHIFT);
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2896  		SHMEM2_WR(bp, drv_capabilities_flag[BP_FW_MB_IDX(bp)],
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2897  			  val | DRV_FLAGS_CAPABILITIES_LOADED_SUPPORTED |
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2898  			  DRV_FLAGS_CAPABILITIES_LOADED_L2);
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2899  	}
9ce392d4fa43c3 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-03-12  2900  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2901  	/* Wait for all pending SP commands to complete */
ad5afc89365e98 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Ariel Elior             2013-01-01  2902  	if (IS_PF(bp) && !bnx2x_wait_sp_comp(bp, ~0x0UL)) {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2903  		BNX2X_ERR("Timeout waiting for SP elements to complete\n");
5d07d8680692a2 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2012-09-13  2904  		bnx2x_nic_unload(bp, UNLOAD_CLOSE, false);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2905  		return -EBUSY;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_cmn.c                   Vlad Zolotarov          2011-06-14  2906  	}
6891dd25d3f82e drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-08-03  2907  
c48f350ff5e75a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2908  	/* Update driver data for On-Chip MFW dump. */
c48f350ff5e75a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2909  	if (IS_PF(bp))
c48f350ff5e75a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2910  		bnx2x_update_mfw_dump(bp);
c48f350ff5e75a drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2911  
9876879fce3081 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-06-19  2912  	/* If PMF - send ADMIN DCBX msg to MFW to initiate DCBX FSM */
9876879fce3081 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-06-19  2913  	if (bp->port.pmf && (bp->state != BNX2X_STATE_DIAG))
9876879fce3081 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-06-19  2914  		bnx2x_dcbx_init(bp, false);
9876879fce3081 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Barak Witkowski         2012-06-19  2915  
230d00eb4bfe0d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2916  	if (!IS_MF_SD_STORAGE_PERSONALITY_ONLY(bp))
230d00eb4bfe0d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2917  		bnx2x_set_os_driver_state(bp, OS_DRIVER_STATE_ACTIVE);
230d00eb4bfe0d drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Yuval Mintz             2015-07-22  2918  
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2919  	DP(NETIF_MSG_IFUP, "Ending successfully NIC load\n");
55c11941e382cb drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c Merav Sicron            2012-11-07  2920  
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2921  	return 0;
9f6c925889ad92 drivers/net/bnx2x/bnx2x_cmn.c                   Dmitry Kravkov          2010-07-27  2922  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--XsQoSWH+UP9D9v3l
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ljqvbVJ1slUFLKqtxCGi/wHmfHEEIWUCAA==

--XsQoSWH+UP9D9v3l--
