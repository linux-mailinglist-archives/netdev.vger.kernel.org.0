Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01A154A24D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 00:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiFMWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 18:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbiFMWzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 18:55:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00783138D
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 15:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655160911; x=1686696911;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nLVpemy9gxF1/zu+6uvWOe4ukzkTPIflDzRj+y3KhVk=;
  b=iPTjYYidJBCpcd6OGnJSlEGIxJbz64Uuawlpci+0rGuWsNVz73t6lUmx
   FWePyV4d7eFdmlTrImZ5JR1ZWZ4jxiFDinGbbbvxm2ru9Nw/E544cI0+n
   Kc67emsBLWUtiDTjJb9Hl0B04ER3xvxTsDh2zw6GTrj2S9/1t0u1sbmK4
   NSVa0qo/bmUrGBGbgftmNNS0Z+pGyFBM4nl1oiUEkMHE7w82YqGiCuZ0K
   hiCKvmqmeaObmI9d3iJKQ49X6TJ+Y6HxRSCPYcAPuh35KyPU4zots2pXm
   NaKaWLpfdMcp6ns5vQV5efKM+rOAUU3as2aee6Xpl6otALJG/qsijgpRw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="277210904"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="277210904"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 15:55:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="830046207"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2022 15:55:04 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o0sxb-000LER-EW;
        Mon, 13 Jun 2022 22:55:03 +0000
Date:   Tue, 14 Jun 2022 06:54:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andy Chiu <andy.chiu@sifive.com>, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        Andy Chiu <andy.chiu@sifive.com>, Max Hsu <max.hsu@sifive.com>
Subject: Re: [PATCH net-next 2/2] net: axienet: Use iowrite64 to write all
 64b descriptor pointers
Message-ID: <202206140650.4x173WyJ-lkp@intel.com>
References: <20220613034202.3777248-3-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613034202.3777248-3-andy.chiu@sifive.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/net-axienet-fix-DMA-Tx-error/20220613-114738
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 27f2533bcc6e909b85d3c1b738fa1f203ed8a835
config: x86_64-randconfig-r002-20220613 (https://download.01.org/0day-ci/archive/20220614/202206140650.4x173WyJ-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d378268ead93c85803c270277f0243737b536ae7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6c45bbcce325f6c9c907ed0a11ddc13d8026bbcf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andy-Chiu/net-axienet-fix-DMA-Tx-error/20220613-114738
        git checkout 6c45bbcce325f6c9c907ed0a11ddc13d8026bbcf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: iowrite64
   >>> referenced by amd_bus.c
   >>>               vmlinux.o:(axienet_dma_out_addr)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
