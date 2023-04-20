Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B196F6E973C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjDTOev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjDTOes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:34:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA54A3C1D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682001286; x=1713537286;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kSjI3HhxTzDOUolW8Wi2neR0i4fYgQMXc/J7y+Hxqsc=;
  b=W8NUvEgYfFzXRETM8rbCO3xAZttinSd+h6kwfQqTGfUtYFBFggp1ZxaB
   HC1YkDmI1UeNR6A4ZpVnIap+GbEB7MukNLPv7/SSWXUgVpWUHkY6aEItR
   yMz5Oqs834Pc4SWCbH4gqzJX9KtWR2TSWiZH1Pf389jkjEckzK2y/qpFp
   5G6Xsh9UQVWoSV5x1QKmnqdsAgVod3ja6snp3dZXq1pEO5lkwTgQ0uD2y
   /8dxZwSUOjadwKQK83PsCFmn9AHABmG7DRSwoBl8sOdLHPwDYE89+e8Oo
   bAw7hwX+VPHX6qV8qd0JReQODQm/jmXDVRv+znmxcRnUgJreXB0grMMgI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343222900"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343222900"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:34:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="722387981"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="722387981"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2023 07:34:43 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ppVMx-000ft4-0M;
        Thu, 20 Apr 2023 14:34:43 +0000
Date:   Thu, 20 Apr 2023 22:34:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <202304202222.eUq4Xfv8-lkp@intel.com>
References: <20230420082230.2968883-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420082230.2968883-2-liuhangbin@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Hangbin-Liu/bonding-fix-send_peer_notif-overflow/20230420-162411
patch link:    https://lore.kernel.org/r/20230420082230.2968883-2-liuhangbin%40gmail.com
patch subject: [PATCH net 1/4] bonding: fix send_peer_notif overflow
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20230420/202304202222.eUq4Xfv8-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5bf7296696ea0aa3997bf310fae2aa5cf62a3af5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hangbin-Liu/bonding-fix-send_peer_notif-overflow/20230420-162411
        git checkout 5bf7296696ea0aa3997bf310fae2aa5cf62a3af5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=parisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304202222.eUq4Xfv8-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__umoddi3" [drivers/net/bonding/bonding.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
