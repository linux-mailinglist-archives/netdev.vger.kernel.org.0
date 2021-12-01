Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDAA464D6E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 13:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243389AbhLAMHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 07:07:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:1209 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349112AbhLAMHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 07:07:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="217137355"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="217137355"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 04:04:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="560480341"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2021 04:04:27 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1msOLa-000Esp-QI; Wed, 01 Dec 2021 12:04:26 +0000
Date:   Wed, 1 Dec 2021 20:04:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: add error handling code for
 dpaa2_eth_dl_register
Message-ID: <202112012029.0sSjB1Bn-lkp@intel.com>
References: <20211130042021.869529-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130042021.869529-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.16-rc3 next-20211201]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Dongliang-Mu/dpaa2-eth-add-error-handling-code-for-dpaa2_eth_dl_register/20211130-122101
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git d58071a8a76d779eedab38033ae4c821c30295a5
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20211201/202112012029.0sSjB1Bn-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/8c2f20e67d1f8605b042655d121a18f5ce61faa7
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Dongliang-Mu/dpaa2-eth-add-error-handling-code-for-dpaa2_eth_dl_register/20211130-122101
        git checkout 8c2f20e67d1f8605b042655d121a18f5ce61faa7
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function 'dpaa2_eth_probe':
>> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:4465:13: error: void value not ignored as it ought to be
    4465 |         err = dpaa2_eth_dl_register(priv);
         |             ^


vim +4465 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c

  4464	
> 4465		err = dpaa2_eth_dl_register(priv);
  4466		if (err < 0) {
  4467			dev_err(dev, "dpaa2_eth_dl_register failed\n");
  4468			goto err_dl_register;
  4469		}
  4470		dev_info(dev, "Probed interface %s\n", net_dev->name);
  4471		return 0;
  4472	
  4473	err_dl_register:
  4474	#ifdef CONFIG_DEBUG_FS
  4475		dpaa2_dbg_remove(priv);
  4476	#endif
  4477		unregister_netdev(net_dev);
  4478	err_netdev_reg:
  4479		dpaa2_eth_dl_port_del(priv);
  4480	err_dl_port_add:
  4481		dpaa2_eth_dl_traps_unregister(priv);
  4482	err_dl_trap_register:
  4483		dpaa2_eth_dl_free(priv);
  4484	err_dl_alloc:
  4485		dpaa2_eth_disconnect_mac(priv);
  4486	err_connect_mac:
  4487		if (priv->do_link_poll)
  4488			kthread_stop(priv->poll_thread);
  4489		else
  4490			fsl_mc_free_irqs(dpni_dev);
  4491	err_poll_thread:
  4492		dpaa2_eth_free_rings(priv);
  4493	err_alloc_rings:
  4494	err_csum:
  4495	err_netdev_init:
  4496		free_percpu(priv->sgt_cache);
  4497	err_alloc_sgt_cache:
  4498		free_percpu(priv->percpu_extras);
  4499	err_alloc_percpu_extras:
  4500		free_percpu(priv->percpu_stats);
  4501	err_alloc_percpu_stats:
  4502		dpaa2_eth_del_ch_napi(priv);
  4503	err_bind:
  4504		dpaa2_eth_free_dpbp(priv);
  4505	err_dpbp_setup:
  4506		dpaa2_eth_free_dpio(priv);
  4507	err_dpio_setup:
  4508		dpaa2_eth_free_dpni(priv);
  4509	err_dpni_setup:
  4510		fsl_mc_portal_free(priv->mc_io);
  4511	err_portal_alloc:
  4512		destroy_workqueue(priv->dpaa2_ptp_wq);
  4513	err_wq_alloc:
  4514		dev_set_drvdata(dev, NULL);
  4515		free_netdev(net_dev);
  4516	
  4517		return err;
  4518	}
  4519	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
