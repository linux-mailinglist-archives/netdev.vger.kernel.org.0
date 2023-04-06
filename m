Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A296D9863
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbjDFNiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjDFNiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:38:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE6659A;
        Thu,  6 Apr 2023 06:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680788271; x=1712324271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wcn89deEov4t8bGKdQnszOCDDOuu6H302REEEJ7Rz6I=;
  b=G76gaLYALkOX++JSPk0YxDpFF2ZR3pLiNNKNKbSnkE5IZf+1CheHzqFT
   Ls/FuPF5YjiWUsZWdrDf9/gc6nxl2dvVnqvcUPZ6YIgYMZMKncoKkqkr5
   5H2Dija2xaRE1AdYmbbYs2wThuuKUk5DCdGJ5IQeTempQlxQ2f9UYLqdL
   gbshG9WLuV2ZI6I3RlCM7Ii8/MaoEQtN/yoe3MvgPRwIeXg9n4cKCUIlR
   h+uJau+JAAtOP7OHzQRkJRgU0egMbQhZ7mNtawayEyyjTo460rQ7xtt3v
   AcwGO7ougZRKfSeuvRpj40svF58NgFCMwrgzgop4ynijVEc2Pnri7RvvT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="405540561"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="405540561"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 06:13:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="680664054"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="680664054"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2023 06:13:52 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkPR1-000ROA-2o;
        Thu, 06 Apr 2023 13:13:51 +0000
Date:   Thu, 6 Apr 2023 21:12:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        jasowang@redhat.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com, Gautam Dawar <gautam.dawar@amd.com>
Subject: Re: [PATCH net-next v3 04/14] sfc: evaluate vdpa support based on FW
 capability CLIENT_CMD_VF_PROXY
Message-ID: <202304062157.jUftzJPl-lkp@intel.com>
References: <20230406065706.59664-5-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406065706.59664-5-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gautam,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Dawar/sfc-add-function-personality-support-for-EF100-devices/20230406-151436
patch link:    https://lore.kernel.org/r/20230406065706.59664-5-gautam.dawar%40amd.com
patch subject: [PATCH net-next v3 04/14] sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
config: openrisc-randconfig-r025-20230403 (https://download.01.org/0day-ci/archive/20230406/202304062157.jUftzJPl-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1648cc5a817ed0b133554de429e9516dfdc18ddf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Gautam-Dawar/sfc-add-function-personality-support-for-EF100-devices/20230406-151436
        git checkout 1648cc5a817ed0b133554de429e9516dfdc18ddf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304062157.jUftzJPl-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/sfc/ef100_nic.c: In function 'efx_ef100_init_datapath_caps':
>> drivers/net/ethernet/sfc/ef100_nic.c:211:25: error: 'struct ef100_nic_data' has no member named 'vdpa_supported'
     211 |                 nic_data->vdpa_supported = efx->type->is_vf &&
         |                         ^~


vim +211 drivers/net/ethernet/sfc/ef100_nic.c

   164	
   165	static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
   166	{
   167		MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
   168		struct ef100_nic_data *nic_data = efx->nic_data;
   169		u8 vi_window_mode;
   170		size_t outlen;
   171		int rc;
   172	
   173		BUILD_BUG_ON(MC_CMD_GET_CAPABILITIES_IN_LEN != 0);
   174	
   175		rc = efx_mcdi_rpc(efx, MC_CMD_GET_CAPABILITIES, NULL, 0,
   176				  outbuf, sizeof(outbuf), &outlen);
   177		if (rc)
   178			return rc;
   179		if (outlen < MC_CMD_GET_CAPABILITIES_V4_OUT_LEN) {
   180			netif_err(efx, drv, efx->net_dev,
   181				  "unable to read datapath firmware capabilities\n");
   182			return -EIO;
   183		}
   184	
   185		nic_data->datapath_caps = MCDI_DWORD(outbuf,
   186						     GET_CAPABILITIES_OUT_FLAGS1);
   187		nic_data->datapath_caps2 = MCDI_DWORD(outbuf,
   188						      GET_CAPABILITIES_V2_OUT_FLAGS2);
   189		if (outlen < MC_CMD_GET_CAPABILITIES_V7_OUT_LEN)
   190			nic_data->datapath_caps3 = 0;
   191		else
   192			nic_data->datapath_caps3 = MCDI_DWORD(outbuf,
   193							      GET_CAPABILITIES_V7_OUT_FLAGS3);
   194	
   195		vi_window_mode = MCDI_BYTE(outbuf,
   196					   GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE);
   197		rc = efx_mcdi_window_mode_to_stride(efx, vi_window_mode);
   198		if (rc)
   199			return rc;
   200	
   201		efx->num_mac_stats = MCDI_WORD(outbuf,
   202					       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
   203		netif_dbg(efx, probe, efx->net_dev,
   204			  "firmware reports num_mac_stats = %u\n",
   205			  efx->num_mac_stats);
   206	
   207		/* Current EF100 hardware supports vDPA on VFs only, requires MCDI v2
   208		 * and Firmware's capability to proxy MCDI commands from PF to VF
   209		 */
   210		if (IS_ENABLED(CONFIG_SFC_VDPA)) {
 > 211			nic_data->vdpa_supported = efx->type->is_vf &&
   212						   (efx->type->mcdi_max_ver > 1) &&
   213					efx_ef100_has_cap(nic_data->datapath_caps3,
   214							  CLIENT_CMD_VF_PROXY);
   215		}
   216	
   217		return 0;
   218	}
   219	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
