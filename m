Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702745790F7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 04:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiGSClK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 22:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiGSClD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 22:41:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FE33122B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658198460; x=1689734460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SIaxaEU3at+JT4W+mXAeOrHexIvSF97bvBGT0TTAJxM=;
  b=hf3ED6/vJRon0UCGeS/Af7eiANBUes+P9cXN+2OvCDa9xHIgNBuBprul
   hxqGZM+5qJCeKOVbigepZQ3dEcbPvGx4K4/GAfqXW1J3GLWStkQFPYyC5
   R4Dx/rMQO/dQQODGo26fHMyfy5MuWxafm584yjO8E8eWH0rdDd974xO9m
   XrP0V58nUNe2LGkPuX7gX4Hu87PcBC6NQcGogzb6QmP5EFNsfjBG0aEx6
   2KCHXS16GtKkfRtpe044fYOUZ5C103oOerqmcTMX5+upffdEmY8KlrajQ
   ldvUhRNT9wx2sZsykyIE+G1WnS4VxjZM9LBcE+JX3lkd/kssZ3NJxnroC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="269393300"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="269393300"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 19:41:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="686951375"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2022 19:40:56 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDdAN-0005By-LM;
        Tue, 19 Jul 2022 02:40:55 +0000
Date:   Tue, 19 Jul 2022 10:40:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, borisp@nvidia.com,
        john.fastabend@gmail.com, maximmi@nvidia.com, tariqt@nvidia.com,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/7] tls: rx: do not use the standard strparser
Message-ID: <202207191049.lGxYs81r-lkp@intel.com>
References: <20220718194811.1728061-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718194811.1728061-8-kuba@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/tls-rx-decrypt-from-the-TCP-queue/20220719-035116
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6e693a104207fbf5a22795c987e8964c0a1ffe2d
config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/20220719/202207191049.lGxYs81r-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2a6e8eea293987aa4507bf82c5952f49752c9be3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/tls-rx-decrypt-from-the-TCP-queue/20220719-035116
        git checkout 2a6e8eea293987aa4507bf82c5952f49752c9be3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: net/tls/tls.o(.init.text+0x65): Section mismatch in reference from the function init_module() to the function .exit.text:tls_device_cleanup()
The function __init init_module() references
a function __exit tls_device_cleanup().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
tls_device_cleanup() so it may be used outside an exit section.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
