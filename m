Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD516505EC6
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 21:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbiDRT5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 15:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347805AbiDRT5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 15:57:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A34DF12
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 12:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650311701; x=1681847701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h6Wq2KUNZXLjKWIzIbgs5E6BmURH6qZiyFlSB+GJJJI=;
  b=FspHZ1QpHD3ylCesddHei/TG/ZMQQZjXPes54qYfzkXoeMmj1zQ1fEOH
   XDICqar4mFINqypS7ONo2C9S5KsaKbFWY2Cvl5upmXrKtWmRCZd2E5qlQ
   NIjR0AfXfB07Muhkfrau26r62xRVYwnNoUZ3YOybJs1Lys31JjeC7A2gj
   Fg3kkffIfOqkrBmlEkmmjcViR4+JfaI2Fa9xbPCxW/XsbHtUXxYU9Sc0q
   C+JUmY0cSbw/vhwb2Qrv+5h66vpuTxRoVqbq8pFrnj42/vHpd5W4noKrl
   DBGfYoh62kxoLsexPSXpJuNMWzP0AiXjIyea56AD5POtXD5kRojDwMnx4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="288691933"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="288691933"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 12:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="561448219"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 18 Apr 2022 12:54:52 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ngXSV-0004vF-Rw;
        Mon, 18 Apr 2022 19:54:51 +0000
Date:   Tue, 19 Apr 2022 03:54:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kevin Hao <haokexin@gmail.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: Re: [PATCH] net: stmmac: Use readl_poll_timeout_atomic() in atomic
 state
Message-ID: <202204190334.b0rutoIE-lkp@intel.com>
References: <20220418090500.3393423-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418090500.3393423-1-haokexin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kevin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v5.18-rc3 next-20220414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Kevin-Hao/net-stmmac-Use-readl_poll_timeout_atomic-in-atomic-state/20220418-170945
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 49aefd131739df552f83c566d0665744c30b1d70
config: arm-spear13xx_defconfig (https://download.01.org/0day-ci/archive/20220419/202204190334.b0rutoIE-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 429cbac0390654f90bba18a41799464adf31a5ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/2a443e2b58e8910075a2d972e0e52b1d070654af
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kevin-Hao/net-stmmac-Use-readl_poll_timeout_atomic-in-atomic-state/20220418-170945
        git checkout 2a443e2b58e8910075a2d972e0e52b1d070654af
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __bad_udelay
   >>> referenced by stmmac_hwtstamp.c
   >>>               net/ethernet/stmicro/stmmac/stmmac_hwtstamp.o:(init_systime) in archive drivers/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
