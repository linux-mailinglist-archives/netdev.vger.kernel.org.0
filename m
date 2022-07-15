Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7055F5768F4
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiGOVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiGOVfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:35:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C06158841;
        Fri, 15 Jul 2022 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657920949; x=1689456949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vFAX1UVh0i4rvEsH7mYrdzd8F6INE5/AtplT3ycQd/M=;
  b=LSH6UYujYW71I7Lrvh46GbvmFMapnuXFqQUuzIzlxQy3FxvJTtEIdvVf
   TCL5ZnoMTMQLXJ7N2Kw6hTiZTNbI6yHdWwOCg7jvVFoSS7jOnvKN6Op58
   m/LoITxgLbe1d7RfBCK55HCw3DofHTs5HYeGdAWtEIUf+tXf+O/Tvgnx+
   nbutFP5nWAdCTNcXBKDfuCANIVhtaD/TlLEaJ6XsN28hfNTKMuHqNzNqh
   8ktQbH5h3sWAh7xz8PBlRrDBn6F0fdi7YgIBLCRoVRAjGaIrxNL15qKh1
   c7fsi4mpFxEoStF+sT/uTbqmXXzOdcf9p1Mkb0E+r2FPnG4n47CzmNZdP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="286640942"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="286640942"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:35:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="571689965"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 15 Jul 2022 14:35:46 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCSyP-0000mO-Bd;
        Fri, 15 Jul 2022 21:35:45 +0000
Date:   Sat, 16 Jul 2022 05:35:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mathias Lark <mathiaslark@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH net-next] improve handling of ICMP_EXT_ECHO icmp type
Message-ID: <202207160519.M8OOdyfX-lkp@intel.com>
References: <20220714151358.GA16615@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714151358.GA16615@debian>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathias,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mathias-Lark/improve-handling-of-ICMP_EXT_ECHO-icmp-type/20220714-231818
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b126047f43f11f61f1dd64802979765d71795dae
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20220716/202207160519.M8OOdyfX-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e61b9c556267086ef9b743a0b57df302eef831b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d238a024060b9cf5095b5027301f5921c9140c4e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mathias-Lark/improve-handling-of-ICMP_EXT_ECHO-icmp-type/20220714-231818
        git checkout d238a024060b9cf5095b5027301f5921c9140c4e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <built-in>:1:
>> ./usr/include/linux/icmp.h:163:19: error: unknown type name 'bool'
   static __inline__ bool icmp_is_valid_type(__u8 type)
                     ^
   1 error generated.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
