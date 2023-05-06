Return-Path: <netdev+bounces-688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D861D6F908D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D40280ED3
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861831FCF;
	Sat,  6 May 2023 08:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768681FC8
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:24:12 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE96E5D
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683361449; x=1714897449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qHtoQ8f88xfiDScpCeePJyKEYCE+foPeXQGNZedey7M=;
  b=l/uoLAzCMMuo5s9NpBMbCuk8Qw0Mq9kbWj9sqUdBCwdOrTO5Zk9I3wKQ
   b8RpcKkVz1ozCtKmMJHa5VTigNcDxtcjlmfJB14KDprfZWOM+6Oppmdsk
   iFLrcSnh5QycNMynoTYcoVj4XbRukHiAszLczMumAx9FOes0XhEHirB8K
   HEOqQQNOeDUq8rGqaHc20d44e4ca11b0oqvrICqC5KIHF38EPlXi5Yqx6
   iivl9TnQfpovJH+K+ndLdxVl1AvTuX6S36dBHSLGnrqnpIlwK4ZUlXYJq
   AKCSefmF1Z4hcBx99olOspaRh+KFjAxmprjSC3buPmTZ+Z6yELk0vEKZV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="435679906"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="435679906"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 01:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="700774937"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="700774937"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 06 May 2023 01:24:06 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pvDD3-00003N-1c;
	Sat, 06 May 2023 08:24:05 +0000
Date: Sat, 6 May 2023 16:24:00 +0800
From: kernel test robot <lkp@intel.com>
To: Cathy Zhang <cathy.zhang@intel.com>, edumazet@google.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
	tim.c.chen@intel.com, lizhen.you@intel.com, cathy.zhang@intel.com,
	eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add sysctl_reclaim_threshold
Message-ID: <202305061623.xkekJbaH-lkp@intel.com>
References: <20230506042958.15051-3-cathy.zhang@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506042958.15051-3-cathy.zhang@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Cathy,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]
[also build test ERROR on net/main horms-ipvs/master linus/master v6.3 next-20230505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Cathy-Zhang/net-Keep-sk-sk_forward_alloc-as-a-proper-size/20230506-123121
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230506042958.15051-3-cathy.zhang%40intel.com
patch subject: [PATCH 2/2] net: Add sysctl_reclaim_threshold
config: s390-randconfig-r034-20230504 (https://download.01.org/0day-ci/archive/20230506/202305061623.xkekJbaH-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/24beb0b9f6d299a34b853699e5bcaa28a74cad5f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cathy-Zhang/net-Keep-sk-sk_forward_alloc-as-a-proper-size/20230506-123121
        git checkout 24beb0b9f6d299a34b853699e5bcaa28a74cad5f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305061623.xkekJbaH-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux.o: section mismatch in reference: __next_mem_range (section: .text) -> memblock (section: .meminit.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: __next_mem_range (section: .text) -> memblock (section: .meminit.data)
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!
>> ERROR: modpost: "sysctl_reclaim_threshold" [net/sctp/sctp.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

