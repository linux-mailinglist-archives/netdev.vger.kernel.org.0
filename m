Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C844559F0B7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiHXBPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiHXBPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:15:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E2B2656D;
        Tue, 23 Aug 2022 18:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661303715; x=1692839715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wbm8kTL0vAajZvsHr4nMotWUJXJ4M9eVkVYzLbKNoJk=;
  b=QstFbizZ+RWVo5RFOsmh2CHabD75GzKl2EyCIGYfC+7Ja0FoTNTKWOFK
   TezambmfuY/ZDcxd2i0JUOpLhSZlqKM434pF5aihI2qIEWBqEZG7IVgb/
   bD6QwSiVsG3WU2QTJM9Q2BMiHTga2p9KP+fLH2zijar8j7spQF4yv0pBx
   WFdA7d7qpk/Vy77BstkLrzzRhhMdV3WP/JO2fXVKYJHIjpqCNmkl3nnv1
   xnRvNFzFbkO/iLtXk3/j8jgStxwOKzUbx+GomEGD2m5UNyi1gteccZfbk
   UdkFRJXqwTbYDrh8oEQtVvTHfOg96ZH2HPfMjFT5Zg24L+LckCwmXHAPW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="357810314"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="357810314"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 18:15:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="698878968"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Aug 2022 18:15:13 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQezA-0000nE-1i;
        Wed, 24 Aug 2022 01:15:12 +0000
Date:   Wed, 24 Aug 2022 09:15:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
Message-ID: <202208240923.X2tgBh6Y-lkp@intel.com>
References: <20220822235649.2218031-3-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822235649.2218031-3-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
config: microblaze-buildonly-randconfig-r003-20220823 (https://download.01.org/0day-ci/archive/20220824/202208240923.X2tgBh6Y-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6d832ed17cea3ede1cd48f885a73144d9c4d800a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220823-080022
        git checkout 6d832ed17cea3ede1cd48f885a73144d9c4d800a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   microblaze-linux-ld: kernel/bpf/helpers.o: in function `____bpf_dynptr_read':
   kernel/bpf/helpers.c:1543: undefined reference to `__bpf_skb_load_bytes'
>> microblaze-linux-ld: kernel/bpf/helpers.c:1545: undefined reference to `__bpf_xdp_load_bytes'
   microblaze-linux-ld: kernel/bpf/helpers.o: in function `____bpf_dynptr_write':
   kernel/bpf/helpers.c:1586: undefined reference to `__bpf_skb_store_bytes'
>> microblaze-linux-ld: kernel/bpf/helpers.c:1591: undefined reference to `__bpf_xdp_store_bytes'
   microblaze-linux-ld: kernel/bpf/helpers.o: in function `____bpf_dynptr_data':
   kernel/bpf/helpers.c:1653: undefined reference to `bpf_xdp_pointer'
   pahole: .tmp_vmlinux.btf: Invalid argument
   .btf.vmlinux.bin.o: file not recognized: file format not recognized

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
