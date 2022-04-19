Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51BC506196
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbiDSBOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiDSBOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:14:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D22D1F0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 18:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650330731; x=1681866731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ghYPcc7q8pWdi62jov5tFqv5LOSpK6qMNqYrISDtq4g=;
  b=hp9sdyiiSql+oMtuIChaog8gikjbiSX77O5Di/G2zFUzWLQ3Oa9gL366
   NHaq7DudqoP1BKyt6BJugMixP8Vx+Mc6Ijer7gDuwjXWHuUgr+MeFtNRv
   iyQTDlmT3DBEGhYlYnRujO8Ptzf+bsxShJLP3SUvqB2uzQin0nBQfuMWg
   FdwyEQBtSq9WN7A6LuCdzdeX/D+PeYA3M/0AZ1aNceSNiv2ZtgT8aUDI/
   qUhtl8FbDscrWO/FjJZd50t7aVPr6CD+MEbKFZ+WR+S+nSWiSFBVH9ksT
   GV6CGsKzQdTzLcsW2x+QnKtjjBO8deCt6nmAG8n0gsUm4cnaq3Kuu3Rsw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="262506277"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="262506277"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 18:12:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="657444539"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 18 Apr 2022 18:12:09 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ngcPY-00059S-SW;
        Tue, 19 Apr 2022 01:12:08 +0000
Date:   Tue, 19 Apr 2022 09:11:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kevin Hao <haokexin@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: Re: [PATCH] net: stmmac: Use readl_poll_timeout_atomic() in atomic
 state
Message-ID: <202204190929.z3hyoNTU-lkp@intel.com>
References: <20220418090500.3393423-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418090500.3393423-1-haokexin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: arm-defconfig (https://download.01.org/0day-ci/archive/20220419/202204190929.z3hyoNTU-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2a443e2b58e8910075a2d972e0e52b1d070654af
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kevin-Hao/net-stmmac-Use-readl_poll_timeout_atomic-in-atomic-state/20220418-170945
        git checkout 2a443e2b58e8910075a2d972e0e52b1d070654af
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.o: in function `init_systime':
>> stmmac_hwtstamp.c:(.text+0x3cc): undefined reference to `__bad_udelay'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
