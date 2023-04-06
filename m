Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04FC6D99A4
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbjDFO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbjDFO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:29:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7093C5;
        Thu,  6 Apr 2023 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680791357; x=1712327357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OpYHkeX595afcgkzZpsu41PvdqQrhRD1hTWyXGZwSZQ=;
  b=VWpy1TuKtAlfR7W9sz2MeM9tK5QqxFZWkb80bySS2HHnxyGQROVKkUMj
   PaW/DBN5N99HMy0x5GJCZro7pibrYLO8tT0zYel4RSN70mqdzRy2CBmak
   W38XBeD+hfLiPmverYCsIY/nZz/3qmHKfa+tac4BPqlafMoImsDsIhU21
   WG8WBxiRerVH7Fhq/5B9CjTv6Go31R2kLMNUL2lV/lKI1gu/vJNiwN+ly
   HXp2w81f7cwjBbM6yG5h2CpXJi2cGBKPhamK+UsJopLxMsnkT4MfUK2+n
   +WOv99Mw8ntksk0xPUnUFBIqUgZrskQgDG9zyVQYvgBB3Gyx1pKMJKqCg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="342754597"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="342754597"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 07:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="751659355"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="751659355"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2023 07:26:00 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkQYk-000RQq-2Z;
        Thu, 06 Apr 2023 14:25:54 +0000
Date:   Thu, 6 Apr 2023 22:25:07 +0800
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
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, eperezma@redhat.com,
        harpreet.anand@amd.com, tanuj.kamde@amd.com, koushik.dutta@amd.com,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: Re: [PATCH net-next v3 06/14] sfc: implement vDPA management device
 operations
Message-ID: <202304062258.oIHz9siw-lkp@intel.com>
References: <20230406065706.59664-7-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406065706.59664-7-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gautam,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Dawar/sfc-add-function-personality-support-for-EF100-devices/20230406-151436
patch link:    https://lore.kernel.org/r/20230406065706.59664-7-gautam.dawar%40amd.com
patch subject: [PATCH net-next v3 06/14] sfc: implement vDPA management device operations
config: x86_64-randconfig-a002-20230403 (https://download.01.org/0day-ci/archive/20230406/202304062258.oIHz9siw-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0887a40c60d1983214d417491dc9ef46191ab1ac
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Gautam-Dawar/sfc-add-function-personality-support-for-EF100-devices/20230406-151436
        git checkout 0887a40c60d1983214d417491dc9ef46191ab1ac
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304062258.oIHz9siw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/ef100_vdpa.c:184:12: warning: variable 'efx' is uninitialized when used here [-Wuninitialized]
                           pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
                                   ^~~
   include/linux/pci.h:2548:46: note: expanded from macro 'pci_err'
   #define pci_err(pdev, fmt, arg...)      dev_err(&(pdev)->dev, fmt, ##arg)
                                                     ^~~~
   include/linux/dev_printk.h:144:44: note: expanded from macro 'dev_err'
           dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                     ^~~
   include/linux/dev_printk.h:110:11: note: expanded from macro 'dev_printk_index_wrap'
                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
                           ^~~
   drivers/net/ethernet/sfc/ef100_vdpa.c:179:21: note: initialize the variable 'efx' to silence this warning
           struct efx_nic *efx;
                              ^
                               = NULL
   1 warning generated.


vim +/efx +184 drivers/net/ethernet/sfc/ef100_vdpa.c

   171	
   172	static int ef100_vdpa_net_dev_add(struct vdpa_mgmt_dev *mgmt_dev,
   173					  const char *name,
   174					  const struct vdpa_dev_set_config *config)
   175	{
   176		struct ef100_vdpa_nic *vdpa_nic;
   177		struct ef100_nic_data *nic_data;
   178		const u8 *mac = NULL;
   179		struct efx_nic *efx;
   180		int rc, err;
   181	
   182		if (config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
   183			if (!is_valid_ether_addr(config->net.mac)) {
 > 184				pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
   185					config->net.mac);
   186				return -EINVAL;
   187			}
   188			mac = (const u8 *)config->net.mac;
   189		}
   190	
   191		efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
   192		if (efx->vdpa_nic) {
   193			pci_warn(efx->pci_dev,
   194				 "vDPA device already exists on this VF\n");
   195			return -EEXIST;
   196		}
   197	
   198		nic_data = efx->nic_data;
   199	
   200		rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_VDPA);
   201		if (rc) {
   202			pci_err(efx->pci_dev,
   203				"set_bar_config vDPA failed, err: %d\n", rc);
   204			goto err_set_bar_config;
   205		}
   206	
   207		vdpa_nic = ef100_vdpa_create(efx, name, EF100_VDPA_CLASS_NET, mac);
   208		if (IS_ERR(vdpa_nic)) {
   209			pci_err(efx->pci_dev,
   210				"vDPA device creation failed, vf: %u, err: %ld\n",
   211				nic_data->vf_index, PTR_ERR(vdpa_nic));
   212			rc = PTR_ERR(vdpa_nic);
   213			goto err_set_bar_config;
   214		} else {
   215			pci_dbg(efx->pci_dev,
   216				"vdpa net device created, vf: %u\n",
   217				nic_data->vf_index);
   218		}
   219	
   220		return 0;
   221	
   222	err_set_bar_config:
   223		err = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
   224		if (err)
   225			pci_err(efx->pci_dev,
   226				"set_bar_config EF100 failed, err: %d\n", err);
   227	
   228		return rc;
   229	}
   230	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
