Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4E48092F
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhL1MsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:48:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:5558 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhL1MsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 07:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640695685; x=1672231685;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ar/RH9/tqbsukSabdLt+5vT2Am7QCZlrjurfbcYvawk=;
  b=ZqyorWbQ48eh618GaMvH7LiCYQWSJSt52lMAiYGUOzxExH2ScP29Qy8f
   MgO2izGm3FkgUKAsSYZdPzSzMPDX6jrtcflGn2V84PaeFXEv3kMva4qOt
   xTnThkgYa/TJHvJHixERVbM0zTEgFpiw+WcWHoK5s6Ek3hE/6LU0e1Dxm
   oDR2dDBrVr3H2hYn5zJH0vTTzJ+RGuflpp5/7UQiiaCvukUS6/o0nI3Bi
   DpG2PDI6q/Jex73bvt5zF/1L8O9QlYj3ZeG1dktOAKRwfBxg+PtuQ4Gdk
   JvSCVGTXlgkBXbij1y2RXWDB0WVAP2McXXG3rc2g9EnsS/Fe+u6fuzDct
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="241574490"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="241574490"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 04:48:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="470019284"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 28 Dec 2021 04:48:02 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n2BtZ-0007Yy-R5; Tue, 28 Dec 2021 12:48:01 +0000
Date:   Tue, 28 Dec 2021 20:47:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Mosberger-Tang <davidm@egauge.net>,
        Ajay Singh <ajay.kathat@microchip.com>
Cc:     kbuild-all@lists.01.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
Subject: Re: [PATCH v2 32/50] wilc1000: introduce vmm_table_entry() helper
 function
Message-ID: <202112282030.iPTnhHRr-lkp@intel.com>
References: <20211223011358.4031459-33-davidm@egauge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223011358.4031459-33-davidm@egauge.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvalo-wireless-drivers-next/master]
[also build test WARNING on kvalo-wireless-drivers/master v5.16-rc7 next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Mosberger-Tang/wilc1000-rework-tx-path-to-use-sk_buffs-throughout/20211223-091915
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: sparc-randconfig-s031-20211228 (https://download.01.org/0day-ci/archive/20211228/202112282030.iPTnhHRr-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/9339519807fd005c22f3299f859edc615e540d3f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Mosberger-Tang/wilc1000-rework-tx-path-to-use-sk_buffs-throughout/20211223-091915
        git checkout 9339519807fd005c22f3299f859edc615e540d3f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/wireless/microchip/wilc1000/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned int @@     got restricted __le32 [usertype] @@
   drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse:     expected unsigned int
   drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse:     got restricted __le32 [usertype]

vim +640 drivers/net/wireless/microchip/wilc1000/wlan.c

   631	
   632	static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
   633	{
   634		struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
   635		u32 entry;
   636	
   637		entry = vmm_sz / 4;
   638		if (tx_cb->type == WILC_CFG_PKT)
   639			entry |= WILC_VMM_CFG_PKT;
 > 640		return cpu_to_le32(entry);
   641	}
   642	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
