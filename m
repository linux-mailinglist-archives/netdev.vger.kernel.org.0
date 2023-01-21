Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556E76769B3
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjAUVq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 16:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjAUVqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 16:46:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47CA2684D;
        Sat, 21 Jan 2023 13:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674337614; x=1705873614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JAKSS4dPSaIj68kmeXyY63au78qva1tFAdBiC+XiVko=;
  b=cSSSlU4+krggal6PJXVHal+hhF4usKEhKga1K1reD3bIfKfQwmeq/tg6
   st5b2uWozQ85YPGWpYyoVGvd2kAplAaVAYCEm728XHZ6eEAt71EL6jYYU
   Yk3qXkZ96+1HMALylaajVbk9UAan07voVGCwUjp428PLQ26EFusETrne2
   kCjl71IHGMwalWxNKYNdKGnAgcYZbtU4RMCSiIgVCBA4jKdwPdHfpD1Qk
   MNl3DXseaUE7LdpLs2gB7bPos6tLsZPTsXR1gxnHVyiHeINyXcA7IV+Rk
   JMFUV0olNX1/9hs0d15tBvoS10Sxj1WhNedk/fF2pSaZT0ZrFHOoVV5aq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="390340341"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="390340341"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 13:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="662918042"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="662918042"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jan 2023 13:46:46 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pJLhG-0004VC-09;
        Sat, 21 Jan 2023 21:46:46 +0000
Date:   Sun, 22 Jan 2023 05:46:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yanchao Yang <yanchao.yang@mediatek.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: Re: [PATCH net-next v2 06/12] net: wwan: tmi: Add AT & MBIM WWAN
 ports
Message-ID: <202301220534.qrMLlR2w-lkp@intel.com>
References: <20230118113859.175836-7-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118113859.175836-7-yanchao.yang@mediatek.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yanchao,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yanchao-Yang/net-wwan-tmi-Add-PCIe-core/20230118-203144
patch link:    https://lore.kernel.org/r/20230118113859.175836-7-yanchao.yang%40mediatek.com
patch subject: [PATCH net-next v2 06/12] net: wwan: tmi: Add AT & MBIM WWAN ports
config: openrisc-randconfig-s052-20230120 (https://download.01.org/0day-ci/archive/20230122/202301220534.qrMLlR2w-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/366056f9aec8d7739b18869078ce15a2a4c9d719
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yanchao-Yang/net-wwan-tmi-Add-PCIe-core/20230118-203144
        git checkout 366056f9aec8d7739b18869078ce15a2a4c9d719
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   or1k-linux-ld: drivers/net/wwan/mediatek/mtk_port_io.o: in function `mtk_port_relayfs_recv':
>> mtk_port_io.c:(.text+0x238): undefined reference to `relay_switch_subbuf'
   mtk_port_io.c:(.text+0x238): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `relay_switch_subbuf'
   or1k-linux-ld: drivers/net/wwan/mediatek/mtk_port_io.o: in function `mtk_port_relayfs_disable':
>> mtk_port_io.c:(.text+0x2c8): undefined reference to `relay_close'
   mtk_port_io.c:(.text+0x2c8): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `relay_close'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
