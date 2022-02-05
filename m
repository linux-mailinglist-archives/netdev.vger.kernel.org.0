Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4E4AA8AC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 13:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379855AbiBEMRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 07:17:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:1313 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243979AbiBEMRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 07:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644063452; x=1675599452;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dA7aLRkk8F+iqwY27GaGa0TrFVEJcF8V/aqgM1P7jJ0=;
  b=mTHOkqj87gNJKmU419+XzvNArZrSYv6tzKKeA0B+S5s44blkFtl3Lc4W
   /jMEKRbi3tKSk0mqF/Od+pztwwdAL2cHo2UOb7sPgF0OD/j7KzRwhwp7Y
   J6IP33HqTiKYd06How7WePtAqiHyKOP9w5scKD2GrnVJyUiDLHEuhH5up
   f36oLFNLgGfagyUKyoWy1Fws9sx962Bzjduc+4gf/oE62rCYe2dulb8wQ
   aLxeJ1qyCs6M6iyvobxrPfnWvGMtd7QLQeliiHwB2EQBtdaLoHGx8RR8o
   qRdTNCm6I2+i+V3u3ULO5bQEkWKXd2OJJ4vfQVefvD3+2PqQPY3ChQCPy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="248722190"
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="248722190"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2022 04:17:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="535775763"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 05 Feb 2022 04:17:30 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nGK0P-000Z0x-MK; Sat, 05 Feb 2022 12:17:29 +0000
Date:   Sat, 5 Feb 2022 20:16:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH net-next v3 1/3] net/smc: Make smc_tcp_listen_work()
 independent
Message-ID: <202202052019.I6XO0mge-lkp@intel.com>
References: <1d7365b47719546fe1f145affb01398d8287b381.1644041638.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7365b47719546fe1f145affb01398d8287b381.1644041638.git.alibuda@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/D-Wythe/Optimizing-performance-in-short-lived-scenarios/20220205-143638
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c78b8b20e34920231eda02fb40c7aca7d88be837
config: x86_64-randconfig-s021 (https://download.01.org/0day-ci/archive/20220205/202202052019.I6XO0mge-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/c750e361a42f2d32b4e041edfd0b51d9020a936c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review D-Wythe/Optimizing-performance-in-short-lived-scenarios/20220205-143638
        git checkout c750e361a42f2d32b4e041edfd0b51d9020a936c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/smc/af_smc.c:62:25: sparse: sparse: symbol 'smc_tcp_ls_wq' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
