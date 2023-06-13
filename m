Return-Path: <netdev+bounces-10470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D27D072EA60
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB04280E9A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64B53C0BA;
	Tue, 13 Jun 2023 17:59:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9420C3C0B2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:59:21 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBD919B5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686679157; x=1718215157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hcZOCeLULNH2tRWacCblG67cCcgMTuAnr4Oi1y9GTiY=;
  b=msds7cxf2Ri8vz6MKiCmXqArL3fIzz7spuOZJY/fINsOAH5jQW2uPLF2
   it7KueD9KiJlhMh1ZPS1bvAPiqyrnh01RHZgYz+LKh4sCukwYMHt3PQqv
   WpNsYIpF8PrH4ZKeruCR5bY/g8xRkS7eU5yV9ozK36O+Kq+ZHcjjEjLB4
   EWANhHu/Eo8F8D6/GD0tUT35jZvydSXbVmRrR4DkqnzTeN7LhmydMd/R3
   9Y4o9MhszUPEkENoXAN4ONoS1dcqYtq/s+1hjMM+tKZ/xFJ1KeY6XeLjE
   m+ejK/t4vcgL9nbCXU2Vq0QTFxzxt9myEK9d3FJZvle+Wrmalze2L42Dz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338048856"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="338048856"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:59:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="801586773"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="801586773"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2023 10:59:14 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q98IU-0001cg-04;
	Tue, 13 Jun 2023 17:59:14 +0000
Date: Wed, 14 Jun 2023 01:58:35 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	intel-wired-lan@lists.osuosl.org
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
	fred@cloudflare.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH iwl-next] ice: allow hot-swapping XDP programs
Message-ID: <202306140113.21qLwv79-lkp@intel.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maciej,

kernel test robot noticed the following build errors:

[auto build test ERROR on tnguy-next-queue/dev-queue]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Fijalkowski/ice-allow-hot-swapping-XDP-programs/20230613-231046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
patch link:    https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski%40intel.com
patch subject: [PATCH iwl-next] ice: allow hot-swapping XDP programs
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20230614/202306140113.21qLwv79-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add tnguy-next-queue https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git
        git fetch tnguy-next-queue dev-queue
        git checkout tnguy-next-queue/dev-queue
        b4 shazam https://lore.kernel.org/r/20230613151005.337462-1-maciej.fijalkowski@intel.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/intel/ice/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140113.21qLwv79-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4417:13: error: invalid storage class for function 'ice_decfg_netdev'
    4417 | static void ice_decfg_netdev(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4424:12: error: invalid storage class for function 'ice_start_eth'
    4424 | static int ice_start_eth(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4439:13: error: invalid storage class for function 'ice_stop_eth'
    4439 | static void ice_stop_eth(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4445:12: error: invalid storage class for function 'ice_init_eth'
    4445 | static int ice_init_eth(struct ice_pf *pf)
         |            ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4494:13: error: invalid storage class for function 'ice_deinit_eth'
    4494 | static void ice_deinit_eth(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4508:12: error: invalid storage class for function 'ice_init_dev'
    4508 | static int ice_init_dev(struct ice_pf *pf)
         |            ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4589:13: error: invalid storage class for function 'ice_deinit_dev'
    4589 | static void ice_deinit_dev(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4601:13: error: invalid storage class for function 'ice_init_features'
    4601 | static void ice_init_features(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4631:13: error: invalid storage class for function 'ice_deinit_features'
    4631 | static void ice_deinit_features(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4643:13: error: invalid storage class for function 'ice_init_wakeup'
    4643 | static void ice_init_wakeup(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4658:12: error: invalid storage class for function 'ice_init_link'
    4658 | static int ice_init_link(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4705:12: error: invalid storage class for function 'ice_init_pf_sw'
    4705 | static int ice_init_pf_sw(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4744:13: error: invalid storage class for function 'ice_deinit_pf_sw'
    4744 | static void ice_deinit_pf_sw(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4755:12: error: invalid storage class for function 'ice_alloc_vsis'
    4755 | static int ice_alloc_vsis(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4785:13: error: invalid storage class for function 'ice_dealloc_vsis'
    4785 | static void ice_dealloc_vsis(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4795:12: error: invalid storage class for function 'ice_init_devlink'
    4795 | static int ice_init_devlink(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4809:13: error: invalid storage class for function 'ice_deinit_devlink'
    4809 | static void ice_deinit_devlink(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4816:12: error: invalid storage class for function 'ice_init'
    4816 | static int ice_init(struct ice_pf *pf)
         |            ^~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4868:13: error: invalid storage class for function 'ice_deinit'
    4868 | static void ice_deinit(struct ice_pf *pf)
         |             ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:4946:1: error: invalid storage class for function 'ice_probe'
    4946 | ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
         | ^~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5052:13: error: invalid storage class for function 'ice_set_wake'
    5052 | static void ice_set_wake(struct ice_pf *pf)
         |             ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5075:13: error: invalid storage class for function 'ice_setup_mc_magic_wake'
    5075 | static void ice_setup_mc_magic_wake(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5111:13: error: invalid storage class for function 'ice_remove'
    5111 | static void ice_remove(struct pci_dev *pdev)
         |             ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5151:13: error: invalid storage class for function 'ice_shutdown'
    5151 | static void ice_shutdown(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5170:13: error: invalid storage class for function 'ice_prepare_for_shutdown'
    5170 | static void ice_prepare_for_shutdown(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5201:12: error: invalid storage class for function 'ice_reinit_interrupt_scheme'
    5201 | static int ice_reinit_interrupt_scheme(struct ice_pf *pf)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5251:27: error: invalid storage class for function 'ice_suspend'
    5251 | static int __maybe_unused ice_suspend(struct device *dev)
         |                           ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5318:27: error: invalid storage class for function 'ice_resume'
    5318 | static int __maybe_unused ice_resume(struct device *dev)
         |                           ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5380:1: error: invalid storage class for function 'ice_pci_err_detected'
    5380 | ice_pci_err_detected(struct pci_dev *pdev, pci_channel_state_t err)
         | ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5409:25: error: invalid storage class for function 'ice_pci_err_slot_reset'
    5409 | static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
         |                         ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5445:13: error: invalid storage class for function 'ice_pci_err_resume'
    5445 | static void ice_pci_err_resume(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5472:13: error: invalid storage class for function 'ice_pci_err_reset_prepare'
    5472 | static void ice_pci_err_reset_prepare(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5490:13: error: invalid storage class for function 'ice_pci_err_reset_done'
    5490 | static void ice_pci_err_reset_done(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_main.c:5533:1: warning: 'alias' attribute ignored [-Wattributes]
    5533 | MODULE_DEVICE_TABLE(pci, ice_pci_tbl);
         | ^~~~~~~~~~~~~~~~~~~
   In file included from drivers/net/ethernet/intel/ice/ice.h:9,
                    from drivers/net/ethernet/intel/ice/ice_main.c:9:
   include/linux/kernel.h:58:33: error: initializer element is not constant
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:313:20: note: in expansion of macro 'pm_sleep_ptr'
     313 |         .suspend = pm_sleep_ptr(suspend_fn), \
         |                    ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: note: (near initialization for 'ice_pm_ops.suspend')
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:313:20: note: in expansion of macro 'pm_sleep_ptr'
     313 |         .suspend = pm_sleep_ptr(suspend_fn), \
         |                    ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: error: initializer element is not constant
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:314:19: note: in expansion of macro 'pm_sleep_ptr'
     314 |         .resume = pm_sleep_ptr(resume_fn), \
         |                   ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: note: (near initialization for 'ice_pm_ops.resume')
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:314:19: note: in expansion of macro 'pm_sleep_ptr'
     314 |         .resume = pm_sleep_ptr(resume_fn), \
         |                   ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: error: initializer element is not constant
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:315:19: note: in expansion of macro 'pm_sleep_ptr'
     315 |         .freeze = pm_sleep_ptr(suspend_fn), \
         |                   ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: note: (near initialization for 'ice_pm_ops.freeze')
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
--
         |                     ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: note: (near initialization for 'ice_pm_ops.poweroff')
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:317:21: note: in expansion of macro 'pm_sleep_ptr'
     317 |         .poweroff = pm_sleep_ptr(suspend_fn), \
         |                     ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: error: initializer element is not constant
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:318:20: note: in expansion of macro 'pm_sleep_ptr'
     318 |         .restore = pm_sleep_ptr(resume_fn),
         |                    ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kernel.h:58:33: note: (near initialization for 'ice_pm_ops.restore')
      58 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^
   include/linux/pm.h:452:28: note: in expansion of macro 'PTR_IF'
     452 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~
   include/linux/pm.h:318:20: note: in expansion of macro 'pm_sleep_ptr'
     318 |         .restore = pm_sleep_ptr(resume_fn),
         |                    ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:426:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
     426 |         SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5535:23: note: in expansion of macro 'SIMPLE_DEV_PM_OPS'
    5535 | static __maybe_unused SIMPLE_DEV_PM_OPS(ice_pm_ops, ice_suspend, ice_resume);
         |                       ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5538:27: error: initializer element is not constant
    5538 |         .error_detected = ice_pci_err_detected,
         |                           ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5538:27: note: (near initialization for 'ice_pci_err_handler.error_detected')
   drivers/net/ethernet/intel/ice/ice_main.c:5539:23: error: initializer element is not constant
    5539 |         .slot_reset = ice_pci_err_slot_reset,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5539:23: note: (near initialization for 'ice_pci_err_handler.slot_reset')
   drivers/net/ethernet/intel/ice/ice_main.c:5540:26: error: initializer element is not constant
    5540 |         .reset_prepare = ice_pci_err_reset_prepare,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5540:26: note: (near initialization for 'ice_pci_err_handler.reset_prepare')
   drivers/net/ethernet/intel/ice/ice_main.c:5541:23: error: initializer element is not constant
    5541 |         .reset_done = ice_pci_err_reset_done,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5541:23: note: (near initialization for 'ice_pci_err_handler.reset_done')
   drivers/net/ethernet/intel/ice/ice_main.c:5542:19: error: initializer element is not constant
    5542 |         .resume = ice_pci_err_resume
         |                   ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5542:19: note: (near initialization for 'ice_pci_err_handler.resume')
   drivers/net/ethernet/intel/ice/ice_main.c:5548:18: error: initializer element is not constant
    5548 |         .probe = ice_probe,
         |                  ^~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5548:18: note: (near initialization for 'ice_driver.probe')
   drivers/net/ethernet/intel/ice/ice_main.c:5549:19: error: initializer element is not constant
    5549 |         .remove = ice_remove,
         |                   ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5549:19: note: (near initialization for 'ice_driver.remove')
   drivers/net/ethernet/intel/ice/ice_main.c:5553:21: error: initializer element is not constant
    5553 |         .shutdown = ice_shutdown,
         |                     ^~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5553:21: note: (near initialization for 'ice_driver.shutdown')
   drivers/net/ethernet/intel/ice/ice_main.c:5564:19: error: invalid storage class for function 'ice_module_init'
    5564 | static int __init ice_module_init(void)
         |                   ^~~~~~~~~~~~~~~
   In file included from drivers/net/ethernet/intel/ice/ice.h:10:
>> include/linux/module.h:131:49: error: invalid storage class for function '__inittest'
     131 |         static inline initcall_t __maybe_unused __inittest(void)                \
         |                                                 ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5585:1: note: in expansion of macro 'module_init'
    5585 | module_init(ice_module_init);
         | ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5585:1: warning: 'alias' attribute ignored [-Wattributes]
   drivers/net/ethernet/intel/ice/ice_main.c:5593:20: error: invalid storage class for function 'ice_module_exit'
    5593 | static void __exit ice_module_exit(void)
         |                    ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5593:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    5593 | static void __exit ice_module_exit(void)
         | ^~~~~~
>> include/linux/module.h:139:49: error: invalid storage class for function '__exittest'
     139 |         static inline exitcall_t __maybe_unused __exittest(void)                \
         |                                                 ^~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5599:1: note: in expansion of macro 'module_exit'
    5599 | module_exit(ice_module_exit);
         | ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5599:1: warning: 'alias' attribute ignored [-Wattributes]
   drivers/net/ethernet/intel/ice/ice_main.c:5608:12: error: invalid storage class for function 'ice_set_mac_address'
    5608 | static int ice_set_mac_address(struct net_device *netdev, void *pi)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5608:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    5608 | static int ice_set_mac_address(struct net_device *netdev, void *pi)
         | ^~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5699:13: error: invalid storage class for function 'ice_set_rx_mode'
    5699 | static void ice_set_rx_mode(struct net_device *netdev)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5728:1: error: invalid storage class for function 'ice_set_tx_maxrate'
    5728 | ice_set_tx_maxrate(struct net_device *netdev, int queue_index, u32 maxrate)
         | ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5778:1: error: invalid storage class for function 'ice_fdb_add'
    5778 | ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
         | ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5817:1: error: invalid storage class for function 'ice_fdb_del'
    5817 | ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
         | ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5887:1: error: invalid storage class for function 'ice_fix_features'
    5887 | ice_fix_features(struct net_device *netdev, netdev_features_t features)
         | ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5953:1: error: invalid storage class for function 'ice_set_vlan_offload_features'
    5953 | ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:5997:1: error: invalid storage class for function 'ice_set_vlan_filtering_features'
    5997 | ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6023:1: error: invalid storage class for function 'ice_set_vlan_features'
    6023 | ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
         | ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6062:12: error: invalid storage class for function 'ice_set_loopback'
    6062 | static int ice_set_loopback(struct ice_vsi *vsi, bool ena)
         |            ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6089:1: error: invalid storage class for function 'ice_set_features'
    6089 | ice_set_features(struct net_device *netdev, netdev_features_t features)
         | ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6168:12: error: invalid storage class for function 'ice_vsi_vlan_setup'
    6168 | static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6249:13: error: invalid storage class for function 'ice_tx_dim_work'
    6249 | static void ice_tx_dim_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6269:13: error: invalid storage class for function 'ice_rx_dim_work'
    6269 | static void ice_rx_dim_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6301:13: error: invalid storage class for function 'ice_init_moderation'
    6301 | static void ice_init_moderation(struct ice_q_vector *q_vector)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6335:13: error: invalid storage class for function 'ice_napi_enable_all'
    6335 | static void ice_napi_enable_all(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6358:12: error: invalid storage class for function 'ice_up_complete'
    6358 | static int ice_up_complete(struct ice_vsi *vsi)
         |            ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6443:1: error: invalid storage class for function 'ice_update_vsi_tx_ring_stats'
    6443 | ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6471:13: error: invalid storage class for function 'ice_update_vsi_ring_stats'
    6471 | static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6745:6: error: invalid storage class for function 'ice_get_stats64'
    6745 | void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
         |      ^~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:6785:13: error: invalid storage class for function 'ice_napi_disable_all'
    6785 | static void ice_napi_disable_all(struct ice_vsi *vsi)
         |             ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7076:13: error: invalid storage class for function 'ice_vsi_release_all'
    7076 | static void ice_vsi_release_all(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7104:12: error: invalid storage class for function 'ice_vsi_rebuild_by_type'
    7104 | static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7155:13: error: invalid storage class for function 'ice_update_pf_netdev_link'
    7155 | static void ice_update_pf_netdev_link(struct ice_pf *pf)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7187:13: error: invalid storage class for function 'ice_rebuild'
    7187 | static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
         |             ^~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7378:12: error: invalid storage class for function 'ice_change_mtu'
    7378 | static int ice_change_mtu(struct net_device *netdev, int new_mtu)
         |            ^~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7454:12: error: invalid storage class for function 'ice_eth_ioctl'
    7454 | static int ice_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
         |            ^~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7629:1: error: invalid storage class for function 'ice_bridge_getlink'
    7629 | ice_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
         | ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7650:12: error: invalid storage class for function 'ice_vsi_update_bridge_mode'
    7650 | static int ice_vsi_update_bridge_mode(struct ice_vsi *vsi, u16 bmode)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7700:1: error: invalid storage class for function 'ice_bridge_setlink'
    7700 | ice_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
         | ^~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/ice/ice_main.c:7762:13: error: invalid storage class for function 'ice_tx_timeout'


vim +/alias +5533 drivers/net/ethernet/intel/ice/ice_main.c

5995b6d0c6fcdb Brett Creeley          2019-02-13  5494  
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5495  /* ice_pci_tbl - PCI Device ID Table
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5496   *
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5497   * Wildcard entries (PCI_ANY_ID) should come last
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5498   * Last entry must be all 0s
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5499   *
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5500   * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5501   *   Class, Class Mask, private data (not used) }
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5502   */
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5503  static const struct pci_device_id ice_pci_tbl[] = {
633d7449a30133 Anirudh Venkataramanan 2018-10-18  5504  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_BACKPLANE), 0 },
633d7449a30133 Anirudh Venkataramanan 2018-10-18  5505  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
633d7449a30133 Anirudh Venkataramanan 2018-10-18  5506  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
7dcf78b870be64 Tony Nguyen            2021-10-19  5507  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_BACKPLANE), 0 },
7dcf78b870be64 Tony Nguyen            2021-10-19  5508  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_QSFP), 0 },
195fb97766da1b Bruce Allan            2020-02-13  5509  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_SFP), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5510  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_BACKPLANE), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5511  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_QSFP), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5512  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_SFP), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5513  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_10G_BASE_T), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5514  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_SGMII), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5515  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_BACKPLANE), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5516  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_QSFP), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5517  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SFP), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5518  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_10G_BASE_T), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5519  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SGMII), 0 },
2fbfa9668bbf4c Bruce Allan            2020-02-13  5520  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_BACKPLANE), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5521  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SFP), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5522  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_10G_BASE_T), 0 },
5d9e618cbb54f5 Jacob Keller           2019-12-17  5523  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SGMII), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5524  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_BACKPLANE), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5525  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_SFP), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5526  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_10G_BASE_T), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5527  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_1GBE), 0 },
e36aeec0f4e551 Bruce Allan            2020-02-13  5528  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_QSFP), 0 },
f52d166819a4d8 Paul M Stillwell Jr    2022-06-08  5529  	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822_SI_DFLT), 0 },
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5530  	/* required last entry */
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5531  	{ 0, }
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5532  };
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20 @5533  MODULE_DEVICE_TABLE(pci, ice_pci_tbl);
837f08fdecbe4b Anirudh Venkataramanan 2018-03-20  5534  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

