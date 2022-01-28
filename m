Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB10949F9B0
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348625AbiA1MlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:41:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:60606 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348612AbiA1MlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 07:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643373685; x=1674909685;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TljAc77cIYPobouXpV0TYuPSSZj/Npa/4BeXqUL/45g=;
  b=SvDGT5EbKr26RzDw4SA16sDPv7WiVA53J9LTzwU2tds6ydxWzR3LNILH
   Nxzb/mJaUnRG5jMya3B7gILWqGECSwrO25PnPJhs6lq943CrICWB8u/r+
   HeSZy50nYIZUmcdWvjSdS4jg4SwlIpYebW+Pev4QGPLwm/30Een13lcC9
   RJ4HkSRumfykbw9WgjAMY5YWqRts+R40gIBpfVwVBKfSGaE3eE/0tQFZ3
   tVdQvmrs9fMtECd+YTbOeobo4xowW2fVeQt/4Bge2MU25r7lcvXBfeF8k
   oUTvDVSvvM3j+p/fbJRg2+NSNOz8QTQK/w+Ie8WNtgyf5dB22lE9tHJab
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="227783727"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="227783727"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 04:41:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="598197569"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jan 2022 04:41:20 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDQZ6-000Nrr-4J; Fri, 28 Jan 2022 12:41:20 +0000
Date:   Fri, 28 Jan 2022 20:40:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, jiri@resnulli.us
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ivecera@redhat.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/switchdev: use struct_size over open coded arithmetic
Message-ID: <202201282035.8dNEcULs-lkp@intel.com>
References: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc1 next-20220128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/net-switchdev-use-struct_size-over-open-coded-arithmetic/20220128-155848
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 23a46422c56144939c091c76cf389aa863ce9c18
config: arm-orion5x_defconfig (https://download.01.org/0day-ci/archive/20220128/202201282035.8dNEcULs-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 33b45ee44b1f32ffdbc995e6fec806271b4b3ba4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/bf0e33a8c3deb700b95173a37dd16754341ba70e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/net-switchdev-use-struct_size-over-open-coded-arithmetic/20220128-155848
        git checkout bf0e33a8c3deb700b95173a37dd16754341ba70e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/switchdev/switchdev.c:88:19: error: member reference type 'struct switchdev_deferred_item' is not a pointer; did you mean to use '.'?
           dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:18: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                               ~~~^
>> net/switchdev/switchdev.c:88:19: error: indirection requires pointer operand ('unsigned long[]' invalid)
           dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                              ^~~~~~~~~~~~
>> net/switchdev/switchdev.c:88:19: error: member reference type 'struct switchdev_deferred_item' is not a pointer; did you mean to use '.'?
           dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:59: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/compiler_types.h:287:63: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                 ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/switchdev/switchdev.c:88:19: error: member reference type 'struct switchdev_deferred_item' is not a pointer; did you mean to use '.'?
           dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:65: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
   include/linux/compiler_types.h:287:74: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                            ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/switchdev/switchdev.c:88:19: error: indirection requires pointer operand ('struct switchdev_deferred_item' invalid)
           dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:195:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)))
                              ^~~~
   5 errors generated.


vim +88 net/switchdev/switchdev.c

    81	
    82	static int switchdev_deferred_enqueue(struct net_device *dev,
    83					      const void *data, size_t data_len,
    84					      switchdev_deferred_func_t *func)
    85	{
    86		struct switchdev_deferred_item *dfitem;
    87	
  > 88		dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
    89		if (!dfitem)
    90			return -ENOMEM;
    91		dfitem->dev = dev;
    92		dfitem->func = func;
    93		memcpy(dfitem->data, data, data_len);
    94		dev_hold_track(dev, &dfitem->dev_tracker, GFP_ATOMIC);
    95		spin_lock_bh(&deferred_lock);
    96		list_add_tail(&dfitem->list, &deferred);
    97		spin_unlock_bh(&deferred_lock);
    98		schedule_work(&deferred_process_work);
    99		return 0;
   100	}
   101	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
