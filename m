Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D3657749B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 07:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiGQFWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 01:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQFWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 01:22:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6F415A05
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 22:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658035336; x=1689571336;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XlLwB14E3AJ6q9h6czMTzmE6gMdgcaYNJl30Q+TcGZE=;
  b=UbT7mA/UppbA6nI/7GhKHIvmUIldbsDdePMa3UuoQuJezOA0Y0nq4ftt
   KN7g/vUPWJ985ncSiejEONCd8tGEPnCKOfLRWURYnm9x3dJdwaknmvidL
   d1hCJRjnvirT8K59kUZCce10KsLEJ3rormpZGvEZFT+2Y5t80cbELIf9o
   7ta49e8FUxqvA26IbkaJ1R3+Z1l0PHNW6a/FAmKKIYzJNEkxDBt/MhFNS
   PVeP9t5+BqCUXxr+dpW5W0YkERf4lAdKnPU1u7VSQ+zKB7z9AIpUC12U0
   79mXCWiuP2CXAvmCy6+TVLhvfDmx87W8Vp40Woh57eYqE3Q/m4zIxg6Nm
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="287173664"
X-IronPort-AV: E=Sophos;i="5.92,278,1650956400"; 
   d="scan'208";a="287173664"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 22:22:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,278,1650956400"; 
   d="scan'208";a="596898254"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 16 Jul 2022 22:22:13 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCwjN-0002lG-7Y;
        Sun, 17 Jul 2022 05:22:13 +0000
Date:   Sun, 17 Jul 2022 13:22:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrey Turkin <andrey.turkin@gmail.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Andrey Turkin <andrey.turkin@gmail.com>
Subject: Re: [PATCH] vmxnet3: Implement ethtool's get_channels command
Message-ID: <202207171326.msDvZqQY-lkp@intel.com>
References: <20220717022050.822766-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717022050.822766-1-andrey.turkin@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrey,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 972a278fe60c361eb8f37619f562f092e8786d7c]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrey-Turkin/vmxnet3-Implement-ethtool-s-get_channels-command/20220717-102410
base:   972a278fe60c361eb8f37619f562f092e8786d7c
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220717/202207171326.msDvZqQY-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 45067f8fbf61284839c739807c2da2e2505661eb)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/87d4e00b53b145b85dfcda9645ed4a2467caab7d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andrey-Turkin/vmxnet3-Implement-ethtool-s-get_channels-command/20220717-102410
        git checkout 87d4e00b53b145b85dfcda9645ed4a2467caab7d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/vmxnet3/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/vmxnet3/vmxnet3_ethtool.c:1191:6: warning: no previous prototype for function 'vmxnet3_get_channels' [-Wmissing-prototypes]
   void vmxnet3_get_channels(struct net_device *netdev,
        ^
   drivers/net/vmxnet3/vmxnet3_ethtool.c:1191:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void vmxnet3_get_channels(struct net_device *netdev,
   ^
   static 
   1 warning generated.


vim +/vmxnet3_get_channels +1191 drivers/net/vmxnet3/vmxnet3_ethtool.c

  1190	
> 1191	void vmxnet3_get_channels(struct net_device *netdev,
  1192				  struct ethtool_channels *ec)
  1193	{
  1194		struct vmxnet3_adapter *adapter = netdev_priv(netdev);
  1195	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
