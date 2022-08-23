Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4440F59EF9F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiHWXWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiHWXWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:22:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA641786CB;
        Tue, 23 Aug 2022 16:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661296932; x=1692832932;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QVG9DQadsJw7ZXxuHHoW0iJxHyDiYCRdyNJgXc5ts5A=;
  b=FRXzIee22jiuZ7CFDQUH9IUS6kyb+d38ZixIaUL0ZabG/X8EUzjBOwx5
   +qD3SBoceeGWDdX2XAGsMLL04l/+GkbntiIvDtJ/AcR4cQ8brszHI91r/
   6hIRfUXCIVx4qM9HdoVs4pTVlz72wablrARFTDxsoiVfiV0JVxje5vBTI
   dT4jLfqCBjFi7Tf1lZulkMEajSVaKzWxIWWRs0xDSGr3/TZcPmRmW2l6p
   uoA1JbDScJLuulr1ilaWwPOSSKKPAx3grKrYGSOujhTMpbnXzjZ8Zxqnr
   iCYbinleR2pY51WTdZrb/gswyQU7jCPR6McKxlRCQrc+hJObbBpeAX/jk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="274205780"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="274205780"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 16:22:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="677806950"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2022 16:22:10 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQdDl-0000hj-2u;
        Tue, 23 Aug 2022 23:22:09 +0000
Date:   Wed, 24 Aug 2022 07:22:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
Message-ID: <202208240728.59W00MTW-lkp@intel.com>
References: <20220822235649.2218031-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822235649.2218031-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-skb-xdp-dynptrs/20220823-080022
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: arm-buildonly-randconfig-r002-20220823 (https://download.01.org/0day-ci/archive/20220824/202208240728.59W00MTW-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a2c8a74d8f0b7fd0b0008dc9bc5ccf9887317f36
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220823-080022
        git checkout a2c8a74d8f0b7fd0b0008dc9bc5ccf9887317f36
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: kernel/bpf/helpers.o: in function `bpf_dynptr_read':
>> helpers.c:(.text+0xb1c): undefined reference to `__bpf_skb_load_bytes'
   arm-linux-gnueabi-ld: kernel/bpf/helpers.o: in function `bpf_dynptr_write':
>> helpers.c:(.text+0xc30): undefined reference to `__bpf_skb_store_bytes'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
