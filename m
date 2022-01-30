Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABEC4A3302
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 02:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353644AbiA3BVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 20:21:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:26646 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353633AbiA3BVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 20:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643505675; x=1675041675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r+UndQ1T578rPOdJL5bqdLK8JUgvuQSEksEyo5ytApM=;
  b=WwB8dIq4wqIdypTFkbQMTJlhCO/LXGuAHznxUmRltwXdaeNMMiy6c9e5
   bg6Ar8cFRxIqZ7FxWhUWFZZfGOwPH2ln0IrUREgQ70ZWvIpd4qbxrcyO1
   Ru2bOlDcv4djs0SL8NSOXXxLA7pAAQGlDeYFQ+kkzrX4VPkWs6LYIpNSJ
   DPVUSlxegsEZxV6RXq5GbcV0hKSzZpjquIe4frOYDOMNCe7/gVRhYgfjy
   oVRh+55kx+9zhv3QzHTRA0PG9VAbwxKo+dyWQ1idSnuK/37gNCPJUxDDv
   E6EQ0yVFBthVaBYO1X9AESlSOytUOyGw6tASbzCz8QbnaOL2Nuz4nAMU2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10242"; a="230882077"
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; 
   d="scan'208";a="230882077"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2022 17:21:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,327,1635231600"; 
   d="scan'208";a="478661771"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 29 Jan 2022 17:21:12 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDytz-000Ps7-Kg; Sun, 30 Jan 2022 01:21:11 +0000
Date:   Sun, 30 Jan 2022 09:20:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Joe Damato <jdamato@fastly.com>
Subject: Re: [net-next v2 10/10] net-procfs: Show page pool stats in proc
Message-ID: <202201300928.UoQgv8PS-lkp@intel.com>
References: <1643499540-8351-11-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643499540-8351-11-git-send-email-jdamato@fastly.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Joe-Damato/page_pool-Add-page_pool-stat-counters/20220130-074147
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git ff58831fa02deb42fd731f830d8d9ec545573c7c
config: arm-randconfig-r016-20220130 (https://download.01.org/0day-ci/archive/20220130/202201300928.UoQgv8PS-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 33b45ee44b1f32ffdbc995e6fec806271b4b3ba4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/5f0fd838269d51e7a97662eaf54868a248b8bd42
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Joe-Damato/page_pool-Add-page_pool-stat-counters/20220130-074147
        git checkout 5f0fd838269d51e7a97662eaf54868a248b8bd42
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/net-procfs.c:399:1: warning: unused label 'out_ptype' [-Wunused-label]
   out_ptype:
   ^~~~~~~~~~
   1 warning generated.


vim +/out_ptype +399 net/core/net-procfs.c

5f0fd838269d51 Joe Damato 2022-01-29  398  
900ff8c6321418 Cong Wang  2013-02-18 @399  out_ptype:
900ff8c6321418 Cong Wang  2013-02-18  400  	remove_proc_entry("ptype", net->proc_net);
900ff8c6321418 Cong Wang  2013-02-18  401  out_softnet:
900ff8c6321418 Cong Wang  2013-02-18  402  	remove_proc_entry("softnet_stat", net->proc_net);
900ff8c6321418 Cong Wang  2013-02-18  403  out_dev:
900ff8c6321418 Cong Wang  2013-02-18  404  	remove_proc_entry("dev", net->proc_net);
900ff8c6321418 Cong Wang  2013-02-18  405  	goto out;
900ff8c6321418 Cong Wang  2013-02-18  406  }
900ff8c6321418 Cong Wang  2013-02-18  407  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
