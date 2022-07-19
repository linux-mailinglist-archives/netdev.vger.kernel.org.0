Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F406E57A00A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbiGSNtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiGSNtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:49:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264F210ADB0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658235745; x=1689771745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aS+GcxlKC0jA3okV/2u3UIxu+JofoO/qq8pfz+eWpow=;
  b=SvFu0e3zvkc+4x+QDWtbyRgWFByGdOvFONWPbF1QrA3BU3Wp8kGggSN6
   8MhQ0x5H3FhsV7FinBH/scpNeb0Ycbi6L7/wFkUHDBdnvdOVLm7iYb4fX
   5jQBaT0w6NIoPsqRg07JuQjFOl4VGjk7JBY53cmJwPZ9jFLHC2dTFhJ/N
   ystRtXQoguwaRPeadCQYXZi6yvblyYOC208O0eu/cERhTqGQQPXRjz5ir
   SwfDtLcP1IutWSoSHDBo+gaKYzCIBfFKWGcg7J1bDuoiukweiJp4xliE8
   +ZuQRFhBcGEeDLisMztF7T+ridgshHt6VoEvnlGsY2TI6OZJcKEYLXX3U
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="348176216"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="348176216"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 06:02:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="774114823"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2022 06:02:14 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDmrd-0005fb-FX;
        Tue, 19 Jul 2022 13:02:13 +0000
Date:   Tue, 19 Jul 2022 21:01:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/7] tls: rx: do not use the standard strparser
Message-ID: <202207192015.4YzT5lNo-lkp@intel.com>
References: <20220718194811.1728061-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718194811.1728061-8-kuba@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
config: i386-randconfig-a005-20220718 (https://download.01.org/0day-ci/archive/20220719/202207192015.4YzT5lNo-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d74b88c69dc2644bd0dc5d64e2d7413a0d4040e5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2a6e8eea293987aa4507bf82c5952f49752c9be3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/tls-rx-decrypt-from-the-TCP-queue/20220719-035116
        git checkout 2a6e8eea293987aa4507bf82c5952f49752c9be3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux.o(.init.text+0x4791a): Section mismatch in reference from the function tls_register() to the function .exit.text:tls_device_cleanup()
The function __init tls_register() references
a function __exit tls_device_cleanup().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
tls_device_cleanup() so it may be used outside an exit section.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
