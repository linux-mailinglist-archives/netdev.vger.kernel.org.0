Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9144D8A1B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiCNQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbiCNQqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:46:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171335250;
        Mon, 14 Mar 2022 09:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647276299; x=1678812299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xMR2siyabd4TCf1hepbxmt8sSzOlcSZlRl6asTaBpWM=;
  b=bTNb7SmhrtxJmYbhuzeRnLOTBLCaHfrR23+7xrvLPCrnF997ec3YdxzT
   Ag6YNBpHKHYBC5N5gVCKA1M9R0uGWzQejUrwHV5JxkE4d+ldCUj9VuEWh
   2vt1j9Z1le5NQ5CP9u++kIdYyFjfUdhEYT0KEZS49zzwPvX6l5+6LlBh7
   NNY16oVEVWySO28vZwyWi/2s589jGBpmRpMqx1Nyca8HjDBw4+1C68Y3U
   CaVVORy4sEywWc1dengzCMLIK+7bsck6HnAo6e2umGN2rJzpg3gL8O/8J
   2rViBd6xaKUbvIHC91Nr31mWEatfLSOuTciNatrh3KMvqjaBFded1Sehe
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="236686685"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236686685"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 09:44:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="612955175"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2022 09:44:01 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTnnd-000A1r-66; Mon, 14 Mar 2022 16:44:01 +0000
Date:   Tue, 15 Mar 2022 00:43:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 01/14] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <202203150034.m0Fvevlq-lkp@intel.com>
References: <20220314095231.3486931-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-2-tobias@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tobias-Waldekranz/net-bridge-Multiple-Spanning-Trees/20220314-175717
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git de29aff976d3216e7f3ab41fcd7af46fa8f7eab7
config: hexagon-randconfig-r041-20220314 (https://download.01.org/0day-ci/archive/20220315/202203150034.m0Fvevlq-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3e4950d7fa78ac83f33bbf1658e2f49a73719236)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/702c502efb27c12860bc55fc8d9b1bfd99466623
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tobias-Waldekranz/net-bridge-Multiple-Spanning-Trees/20220314-175717
        git checkout 702c502efb27c12860bc55fc8d9b1bfd99466623
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/bridge/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/bridge/br.c:269:9: error: implicit declaration of function 'br_mst_set_enabled' [-Werror,-Wimplicit-function-declaration]
                   err = br_mst_set_enabled(br, on, extack);
                         ^
   net/bridge/br.c:269:9: note: did you mean 'br_stp_set_enabled'?
   net/bridge/br_private.h:1828:5: note: 'br_stp_set_enabled' declared here
   int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
       ^
   1 error generated.


vim +/br_mst_set_enabled +269 net/bridge/br.c

   245	
   246	/* br_boolopt_toggle - change user-controlled boolean option
   247	 *
   248	 * @br: bridge device
   249	 * @opt: id of the option to change
   250	 * @on: new option value
   251	 * @extack: extack for error messages
   252	 *
   253	 * Changes the value of the respective boolean option to @on taking care of
   254	 * any internal option value mapping and configuration.
   255	 */
   256	int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
   257			      struct netlink_ext_ack *extack)
   258	{
   259		int err = 0;
   260	
   261		switch (opt) {
   262		case BR_BOOLOPT_NO_LL_LEARN:
   263			br_opt_toggle(br, BROPT_NO_LL_LEARN, on);
   264			break;
   265		case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
   266			err = br_multicast_toggle_vlan_snooping(br, on, extack);
   267			break;
   268		case BR_BOOLOPT_MST_ENABLE:
 > 269			err = br_mst_set_enabled(br, on, extack);
   270			break;
   271		default:
   272			/* shouldn't be called with unsupported options */
   273			WARN_ON(1);
   274			break;
   275		}
   276	
   277		return err;
   278	}
   279	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
