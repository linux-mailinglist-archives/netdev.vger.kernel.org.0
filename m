Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB045585BED
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiG3T62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 15:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiG3T61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 15:58:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9C6140FE;
        Sat, 30 Jul 2022 12:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659211106; x=1690747106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HObJrlZGJ6u9EOYWVaX5OuT5VSYtbWLsWazETsXPcrU=;
  b=e9Wsm7AocLyFnA2K8nBRDNarmFwjcN8Pn4l5R8LP81Ety7yBwsY2ns+U
   50Ud9vc6TNNeyI+g24flttu2V6VVtlOtjUlbTWsa1nH0OMu4f9a5WTmYw
   omvnMcLKvtWm2ZEBgi09vqgOSc9vQRuvbKnDLpM9oMra7nyAW2SreGCUV
   T/69lQkOWIcvbhP43UZrBzIJPVgU4Aq3FKJUvX97BMJeXa9k1pIJBz2Yg
   e9JgGrjQv5dCxB6sLi3ENpI1dcH6Lse5LX9wJU+U2msMCKH3MQVYwmlEL
   tEGaA0hGgkMmcLHbiig3yaKtIuzdL7EQqTf7X1+9UziBanJ+MeQN0lRXB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="352947743"
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="352947743"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 12:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="601617623"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2022 12:58:23 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHsbO-000DCt-1k;
        Sat, 30 Jul 2022 19:58:22 +0000
Date:   Sun, 31 Jul 2022 03:58:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>, aroulin@nvidia.com
Cc:     kbuild-all@lists.01.org, sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: 8021q: fix bridge binding behavior for
 vlan interfaces
Message-ID: <202207310332.cSMhECu3-lkp@intel.com>
References: <2b09fbacde7e8818f4ada4829818fdf015e36b58.1659195179.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b09fbacde7e8818f4ada4829818fdf015e36b58.1659195179.git.sevinj.aghayeva@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sevinj,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220731-000455
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 63757225a93353bc2ce4499af5501eabdbbf23f9
config: openrisc-randconfig-r031-20220729 (https://download.01.org/0day-ci/archive/20220731/202207310332.cSMhECu3-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/993166d2a01876dc92807f74b3d72f63d25c8227
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220731-000455
        git checkout 993166d2a01876dc92807f74b3d72f63d25c8227
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   `.exit.text' referenced in section `.data' of sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o
   or1k-linux-ld: net/8021q/vlan_dev.o: in function `vlan_dev_change_flags':
>> net/8021q/vlan_dev.c:249: undefined reference to `br_vlan_upper_change'
   net/8021q/vlan_dev.c:249:(.text+0x1d88): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `br_vlan_upper_change'
>> or1k-linux-ld: net/8021q/vlan_dev.c:251: undefined reference to `br_vlan_upper_change'
   net/8021q/vlan_dev.c:251:(.text+0x1dc4): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `br_vlan_upper_change'


vim +249 net/8021q/vlan_dev.c

   211	
   212	/* Flags are defined in the vlan_flags enum in
   213	 * include/uapi/linux/if_vlan.h file.
   214	 */
   215	int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
   216	{
   217		struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
   218		u32 old_flags = vlan->flags;
   219		struct net_device *br_dev;
   220	
   221		if (mask & ~(VLAN_FLAG_REORDER_HDR | VLAN_FLAG_GVRP |
   222			     VLAN_FLAG_LOOSE_BINDING | VLAN_FLAG_MVRP |
   223			     VLAN_FLAG_BRIDGE_BINDING))
   224			return -EINVAL;
   225	
   226		vlan->flags = (old_flags & ~mask) | (flags & mask);
   227	
   228		if (!netif_running(dev))
   229			return 0;
   230	
   231		if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
   232			if (vlan->flags & VLAN_FLAG_GVRP)
   233				vlan_gvrp_request_join(dev);
   234			else
   235				vlan_gvrp_request_leave(dev);
   236		}
   237	
   238		if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
   239			if (vlan->flags & VLAN_FLAG_MVRP)
   240				vlan_mvrp_request_join(dev);
   241			else
   242				vlan_mvrp_request_leave(dev);
   243		}
   244	
   245		if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
   246		    netif_is_bridge_port(dev)) {
   247			br_dev = vlan->real_dev;
   248			if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 > 249				br_vlan_upper_change(br_dev, dev, true);
   250			else
 > 251				br_vlan_upper_change(br_dev, dev, false);
   252		}
   253	
   254		return 0;
   255	}
   256	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
