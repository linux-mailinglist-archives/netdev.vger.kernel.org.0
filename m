Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D24607D6
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358596AbhK1RKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:10:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:10728 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhK1RIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 12:08:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="233342040"
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="233342040"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 09:05:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="594277331"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2021 09:05:32 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mrNcK-000Atp-2K; Sun, 28 Nov 2021 17:05:32 +0000
Date:   Mon, 29 Nov 2021 01:04:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs
 optional
Message-ID: <202111290026.HEuigppG-lkp@intel.com>
References: <20211128125522.23357-6-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128125522.23357-6-ryazanov.s.a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Sergey-Ryazanov/WWAN-debugfs-tweaks/20211128-210031
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d40ce48cb3a68b54be123a1f99157c5ac613e260
config: i386-randconfig-a001-20211128 (https://download.01.org/0day-ci/archive/20211129/202111290026.HEuigppG-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 5c64d8ef8cc0c0ed3e0f2ae693d99e7f70f20a84)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/89654e5e973a53b8375f37395c03359c59b63a99
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sergey-Ryazanov/WWAN-debugfs-tweaks/20211128-210031
        git checkout 89654e5e973a53b8375f37395c03359c59b63a99
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/wwan/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/wwan/wwan_core.c:171:14: warning: variable 'wwandev_name' set but not used [-Wunused-but-set-variable]
           const char *wwandev_name;
                       ^
   1 warning generated.


vim +/wwandev_name +171 drivers/net/wwan/wwan_core.c

c4804670026b93f M Chetan Kumar  2021-11-20  162  
9a44c1cc6388762 Loic Poulain    2021-04-16  163  /* This function allocates and registers a new WWAN device OR if a WWAN device
9a44c1cc6388762 Loic Poulain    2021-04-16  164   * already exist for the given parent, it gets a reference and return it.
9a44c1cc6388762 Loic Poulain    2021-04-16  165   * This function is not exported (for now), it is called indirectly via
9a44c1cc6388762 Loic Poulain    2021-04-16  166   * wwan_create_port().
9a44c1cc6388762 Loic Poulain    2021-04-16  167   */
9a44c1cc6388762 Loic Poulain    2021-04-16  168  static struct wwan_device *wwan_create_dev(struct device *parent)
9a44c1cc6388762 Loic Poulain    2021-04-16  169  {
9a44c1cc6388762 Loic Poulain    2021-04-16  170  	struct wwan_device *wwandev;
c4804670026b93f M Chetan Kumar  2021-11-20 @171  	const char *wwandev_name;
9a44c1cc6388762 Loic Poulain    2021-04-16  172  	int err, id;
9a44c1cc6388762 Loic Poulain    2021-04-16  173  
9a44c1cc6388762 Loic Poulain    2021-04-16  174  	/* The 'find-alloc-register' operation must be protected against
9a44c1cc6388762 Loic Poulain    2021-04-16  175  	 * concurrent execution, a WWAN device is possibly shared between
9a44c1cc6388762 Loic Poulain    2021-04-16  176  	 * multiple callers or concurrently unregistered from wwan_remove_dev().
9a44c1cc6388762 Loic Poulain    2021-04-16  177  	 */
9a44c1cc6388762 Loic Poulain    2021-04-16  178  	mutex_lock(&wwan_register_lock);
9a44c1cc6388762 Loic Poulain    2021-04-16  179  
9a44c1cc6388762 Loic Poulain    2021-04-16  180  	/* If wwandev already exists, return it */
9a44c1cc6388762 Loic Poulain    2021-04-16  181  	wwandev = wwan_dev_get_by_parent(parent);
9a44c1cc6388762 Loic Poulain    2021-04-16  182  	if (!IS_ERR(wwandev))
9a44c1cc6388762 Loic Poulain    2021-04-16  183  		goto done_unlock;
9a44c1cc6388762 Loic Poulain    2021-04-16  184  
9a44c1cc6388762 Loic Poulain    2021-04-16  185  	id = ida_alloc(&wwan_dev_ids, GFP_KERNEL);
d9d5b8961284b00 Andy Shevchenko 2021-08-11  186  	if (id < 0) {
d9d5b8961284b00 Andy Shevchenko 2021-08-11  187  		wwandev = ERR_PTR(id);
9a44c1cc6388762 Loic Poulain    2021-04-16  188  		goto done_unlock;
d9d5b8961284b00 Andy Shevchenko 2021-08-11  189  	}
9a44c1cc6388762 Loic Poulain    2021-04-16  190  
9a44c1cc6388762 Loic Poulain    2021-04-16  191  	wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
9a44c1cc6388762 Loic Poulain    2021-04-16  192  	if (!wwandev) {
d9d5b8961284b00 Andy Shevchenko 2021-08-11  193  		wwandev = ERR_PTR(-ENOMEM);
9a44c1cc6388762 Loic Poulain    2021-04-16  194  		ida_free(&wwan_dev_ids, id);
9a44c1cc6388762 Loic Poulain    2021-04-16  195  		goto done_unlock;
9a44c1cc6388762 Loic Poulain    2021-04-16  196  	}
9a44c1cc6388762 Loic Poulain    2021-04-16  197  
9a44c1cc6388762 Loic Poulain    2021-04-16  198  	wwandev->dev.parent = parent;
9a44c1cc6388762 Loic Poulain    2021-04-16  199  	wwandev->dev.class = wwan_class;
9a44c1cc6388762 Loic Poulain    2021-04-16  200  	wwandev->dev.type = &wwan_dev_type;
9a44c1cc6388762 Loic Poulain    2021-04-16  201  	wwandev->id = id;
9a44c1cc6388762 Loic Poulain    2021-04-16  202  	dev_set_name(&wwandev->dev, "wwan%d", wwandev->id);
9a44c1cc6388762 Loic Poulain    2021-04-16  203  
9a44c1cc6388762 Loic Poulain    2021-04-16  204  	err = device_register(&wwandev->dev);
9a44c1cc6388762 Loic Poulain    2021-04-16  205  	if (err) {
9a44c1cc6388762 Loic Poulain    2021-04-16  206  		put_device(&wwandev->dev);
d9d5b8961284b00 Andy Shevchenko 2021-08-11  207  		wwandev = ERR_PTR(err);
d9d5b8961284b00 Andy Shevchenko 2021-08-11  208  		goto done_unlock;
9a44c1cc6388762 Loic Poulain    2021-04-16  209  	}
9a44c1cc6388762 Loic Poulain    2021-04-16  210  
c4804670026b93f M Chetan Kumar  2021-11-20  211  	wwandev_name = kobject_name(&wwandev->dev.kobj);
89654e5e973a53b Sergey Ryazanov 2021-11-28  212  #ifdef CONFIG_WWAN_DEBUGFS
c4804670026b93f M Chetan Kumar  2021-11-20  213  	wwandev->debugfs_dir = debugfs_create_dir(wwandev_name,
c4804670026b93f M Chetan Kumar  2021-11-20  214  						  wwan_debugfs_dir);
89654e5e973a53b Sergey Ryazanov 2021-11-28  215  #endif
c4804670026b93f M Chetan Kumar  2021-11-20  216  
9a44c1cc6388762 Loic Poulain    2021-04-16  217  done_unlock:
9a44c1cc6388762 Loic Poulain    2021-04-16  218  	mutex_unlock(&wwan_register_lock);
9a44c1cc6388762 Loic Poulain    2021-04-16  219  
9a44c1cc6388762 Loic Poulain    2021-04-16  220  	return wwandev;
9a44c1cc6388762 Loic Poulain    2021-04-16  221  }
9a44c1cc6388762 Loic Poulain    2021-04-16  222  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
