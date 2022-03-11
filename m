Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB664D66C5
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350529AbiCKQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350593AbiCKQsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:48:51 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD2FC3319;
        Fri, 11 Mar 2022 08:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647017265; x=1678553265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MBmm6hfe6ofPaZWinscXCme4Dj8Bg6tgZ9OwG6ZINs0=;
  b=bvoWKXDdDnGs6pY6an6y/K3xtgfiMusG3T0/G7cgWHm2YyCoX0eregRL
   tPyMA0jdxFd+KEp+0O5daZHZlpAbz08sj84/+TrwR7MUnNXbHEXJrO6L3
   4TF6ylGVaFvdDBlmR61QIGeQelJmRTSd6/NSXBiB4ESYkElvM+AdQKwO4
   cK93qt75urbbc9Yqr7ooMwervioP+lVwPSqUpGa1KDaz/aKyIEk9Wkgb0
   nlyMpr2SYTW0Q2ROPDGKKMZCA2uQwfu5FL33tmO8LoWw3r8JV/68R4Wa+
   7/dk2aYA4lSNrPg6uu0lE0Y0a3Elfbt1KL5R0wH/p5P4Hcgls8goFE8MK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="236209714"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="236209714"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 08:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="597164038"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 11 Mar 2022 08:47:36 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSiQR-0006ll-LC; Fri, 11 Mar 2022 16:47:35 +0000
Date:   Sat, 12 Mar 2022 00:47:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: Re: [PATCH 3/3] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
Message-ID: <202203120015.kkExdFHA-lkp@intel.com>
References: <20220311024958.7458-4-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311024958.7458-4-sunshouxin@chinatelecom.cn>
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

Hi Sun,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 2a9eef868a997ec575c2e6ae885e91313f635d59]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
base:   2a9eef868a997ec575c2e6ae885e91313f635d59
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220312/202203120015.kkExdFHA-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 276ca87382b8f16a65bddac700202924228982f6)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/dde3df4ab3030a55968f48dc96ff2014d8f18410
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
        git checkout dde3df4ab3030a55968f48dc96ff2014d8f18410
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/bonding/bond_alb.c:986:6: warning: no previous prototype for function 'rlb6_update_client' [-Wmissing-prototypes]
   void rlb6_update_client(struct rlb_client_info *client_info)
        ^
   drivers/net/bonding/bond_alb.c:986:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void rlb6_update_client(struct rlb_client_info *client_info)
   ^
   static 
   1 warning generated.


vim +/rlb6_update_client +986 drivers/net/bonding/bond_alb.c

   984	
   985	/*********************** ipv6 rlb specific functions ***************************/
 > 986	void rlb6_update_client(struct rlb_client_info *client_info)
   987	{
   988		int i;
   989	
   990		if (!client_info->slave || !is_valid_ether_addr(client_info->mac_dst))
   991			return;
   992	
   993		for (i = 0; i < RLB_ARP_BURST_SIZE; i++) {
   994			ndisc_bond_send_na(client_info->slave->dev,
   995					   &client_info->ip6_dst,
   996					   &client_info->ip6_src,
   997					   false, false, true, true,
   998					   client_info->vlan_id,
   999					   client_info->mac_dst,
  1000					   client_info->slave->dev->dev_addr);
  1001		}
  1002	}
  1003	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
