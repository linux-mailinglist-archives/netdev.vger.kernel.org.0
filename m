Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A592558FBA1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbiHKLxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiHKLw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:52:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCF66CD3F;
        Thu, 11 Aug 2022 04:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660218775; x=1691754775;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Us48dgt1h8gZcQLMuTHC3rp79tb70SotwtEKrHWZwv8=;
  b=SIXJ/zjM8qgI/3GHzK8hSGyh3rbfShFLchqdyv+VkXYvzsJUZOaw2z4X
   JHxa49AteZmxe9KzReRTjEI+d7NGzDeaO4RjkpAc6fQT7+ZFdPQNL+dn6
   kXqwPHqYZZJDPsB0uXNNemCsAwz4TlGeAuoAZkaU+2HfQ3OAAhh6//yYl
   aw778kaC3eVuSj0clM1ljNDxReLdcHLuv0CxnQlYM9xMfkLeXJ7aEY6bC
   ljz8fGCjAZAkiuB3XBWpRvEDbJFwLSBOfU/UiLq2DDkg3uaLUDF5uVveB
   ydin2X88TB6CNV8YKaBaQDqzsN46MFtZW4LOwRSl5qJMDXh2/HpZ+d/b4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="271102260"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="271102260"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 04:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="673668048"
Received: from lkp-server02.sh.intel.com (HELO cfab306db114) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 04:52:48 -0700
Received: from kbuild by cfab306db114 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oM6k3-0000A5-2V;
        Thu, 11 Aug 2022 11:52:47 +0000
Date:   Thu, 11 Aug 2022 19:51:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 01/10] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
Message-ID: <202208111933.9PvuHltH-lkp@intel.com>
References: <075ff0be35660efac638448cdae7f7e7e04199d4.1660152975.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <075ff0be35660efac638448cdae7f7e7e04199d4.1660152975.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-optimize-the-parallelism-of-SMC-R-connections/20220811-014942
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: x86_64-randconfig-s021 (https://download.01.org/0day-ci/archive/20220811/202208111933.9PvuHltH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/2c1c2e644fb8dbce9b8a004e604792340cbfccb8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review D-Wythe/net-smc-optimize-the-parallelism-of-SMC-R-connections/20220811-014942
        git checkout 2c1c2e644fb8dbce9b8a004e604792340cbfccb8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> net/smc/smc_core.c:49:24: sparse: sparse: symbol 'smc_lgr_manager' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
