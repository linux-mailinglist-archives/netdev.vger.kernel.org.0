Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3474D6A0E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiCKW6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiCKW6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:58:43 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5372EE066;
        Fri, 11 Mar 2022 14:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647038914; x=1678574914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VM6tsSriXECwu9X21fmUx10GUaaqq0EPCItaeLE8jCI=;
  b=FHBzr8X0RGDGKqT5lv33VQ5VBkeROxBVVdkwIzI41i2c/7OpVjonNulg
   iJoEYWXEr84ljHSfxcHbpUyeG47HEBS66bCfFIP277ymeTWmFBKTAAB1f
   NdiSswIlsGVmZi+Rtgqr2/RpKM5vMEN3gArQHg8IUDCJvDgbcGMd2iTh8
   ACYPmjpgcQtlPFZTFxIz/pRVVz9yrJNJfSqv9bc3TSR4Wj/erUfBmm/cG
   MxvjsvyY0jdeSbezrG3eGcodMujfwOJ6af614MNBYww1BUFf5tIhh+WbK
   eGzMjxMT+YyqXNgWHLhHfXg42LQDctW+V2GrkNpi1cUygBwt6Ye8YV+8/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="316381056"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="316381056"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:41:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="712980514"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2022 13:41:12 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSn0Z-00078m-OR; Fri, 11 Mar 2022 21:41:11 +0000
Date:   Sat, 12 Mar 2022 05:40:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, edumazet@google.com,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 bpf-next] bpf: select proper size for bpf_prog_pack
Message-ID: <202203120545.dI2S3hTQ-lkp@intel.com>
References: <20220309183523.3308210-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309183523.3308210-1-song@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Song-Liu/bpf-select-proper-size-for-bpf_prog_pack/20220310-023737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: arm-randconfig-c002-20220311 (https://download.01.org/0day-ci/archive/20220312/202203120545.dI2S3hTQ-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4d06f388e14c69d938cbc1e4081029c14d8bc654
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Song-Liu/bpf-select-proper-size-for-bpf_prog_pack/20220310-023737
        git checkout 4d06f388e14c69d938cbc1e4081029c14d8bc654
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/bpf/core.c: In function 'select_bpf_prog_pack_size':
>> kernel/bpf/core.c:846:16: error: 'PMD_SIZE' undeclared (first use in this function); did you mean 'P4D_SIZE'?
     846 |         size = PMD_SIZE * num_online_nodes();
         |                ^~~~~~~~
         |                P4D_SIZE
   kernel/bpf/core.c:846:16: note: each undeclared identifier is reported only once for each function it appears in


vim +846 kernel/bpf/core.c

   840	
   841	static size_t select_bpf_prog_pack_size(void)
   842	{
   843		size_t size;
   844		void *ptr;
   845	
 > 846		size = PMD_SIZE * num_online_nodes();
   847		ptr = module_alloc(size);
   848	
   849		/* Test whether we can get huge pages. If not just use PAGE_SIZE
   850		 * packs.
   851		 */
   852		if (!ptr || !is_vm_area_hugepages(ptr))
   853			size = PAGE_SIZE;
   854	
   855		vfree(ptr);
   856		return size;
   857	}
   858	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
