Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D424DB9C7
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358086AbiCPUwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbiCPUv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:51:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BCC5A5B6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463845; x=1678999845;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dVG9+OWl3+PaAqbEgZhaN0JTSnfFMyBO3Solt6p4Ww0=;
  b=g7dJg5JQ1kCRzpu8pwPA/rJugkEcVbUUXD2b6I8+Ddcmfg4Kif96wywu
   TCRk9wD50s27NyBG8khk5hXiYPBIO0t/nmx48hjDgn2Piy6vGY2Bg2nOR
   5LveeAvyiP/IEVpKwKCicDPiaFY5Ci4YBa8xtuxIiJU4kSiJ1eGuHAYMG
   qiwU6ngys9RVrIW06RqOduyr5EYdaeoda2e9O99oy8DJ/D5Vna5JemQvh
   k5bccvy1SBM6QQgYjwY51g/bguOW3ZQ4LMS+jTHtfchXLDvrVbI44fsPd
   FjjA53pwUwYFf/YfD4yBOaaBylaOxGb1TYFObkB8kl5QtTcd2hChlfdUI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256436100"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="256436100"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="635127816"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2022 13:50:41 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nUabQ-000CuV-JU; Wed, 16 Mar 2022 20:50:40 +0000
Date:   Thu, 17 Mar 2022 04:49:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH v2 net-next 2/5] net: bridge: Implement bridge flood flag
Message-ID: <202203170401.hynO2BwT-lkp@intel.com>
References: <20220316153059.2503153-3-mattias.forsblad+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316153059.2503153-3-mattias.forsblad+netdev@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattias,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Mattias-Forsblad/bridge-dsa-switchdev-mv88e6xxx-Implement-bridge-flood-flags/20220316-233416
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9f01cfbf2922432668c2fd4dfc0413342aaff48b
config: hexagon-randconfig-r045-20220313 (https://download.01.org/0day-ci/archive/20220317/202203170401.hynO2BwT-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a6ec1e3d798f8eab43fb3a91028c6ab04e115fcb)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4c003fec67078a4e8c1c6e36c7b9fc6303a3bb6f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mattias-Forsblad/bridge-dsa-switchdev-mv88e6xxx-Implement-bridge-flood-flags/20220316-233416
        git checkout 4c003fec67078a4e8c1c6e36c7b9fc6303a3bb6f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/bridge/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/bridge/br.c:347:26: warning: unused variable 'bm' [-Wunused-variable]
           struct br_boolopt_multi bm;
                                   ^
>> net/bridge/br.c:361:2: warning: variable 'bropt' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
           default:
           ^~~~~~~
   net/bridge/br.c:365:20: note: uninitialized use occurs here
           br_opt_toggle(br, bropt, on);
                             ^~~~~
   net/bridge/br.c:348:2: note: variable 'bropt' is declared here
           enum net_bridge_opts bropt;
           ^
   2 warnings generated.


vim +/bropt +361 net/bridge/br.c

   338	
   339	int br_flood_toggle(struct net_bridge *br, enum br_boolopt_id opt,
   340			    bool on)
   341	{
   342		struct switchdev_attr attr = {
   343			.orig_dev = br->dev,
   344			.id = SWITCHDEV_ATTR_ID_BRIDGE_FLOOD,
   345			.flags = SWITCHDEV_F_DEFER,
   346		};
   347		struct br_boolopt_multi bm;
   348		enum net_bridge_opts bropt;
   349		int ret;
   350	
   351		switch (opt) {
   352		case BR_BOOLOPT_FLOOD:
   353			bropt = BROPT_FLOOD;
   354			break;
   355		case BR_BOOLOPT_MCAST_FLOOD:
   356			bropt = BROPT_MCAST_FLOOD;
   357			break;
   358		case BR_BOOLOPT_BCAST_FLOOD:
   359			bropt = BROPT_BCAST_FLOOD;
   360			break;
 > 361		default:
   362			WARN_ON(1);
   363			break;
   364		}
   365		br_opt_toggle(br, bropt, on);
   366	
   367		attr.u.brport_flags.mask = BIT(bropt);
   368		attr.u.brport_flags.val = on << bropt;
   369		ret = switchdev_port_attr_set(br->dev, &attr, NULL);
   370	
   371		return ret;
   372	}
   373	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
