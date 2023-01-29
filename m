Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9183368000C
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 16:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbjA2PpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 10:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjA2PpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 10:45:22 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72FF30D7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 07:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675007121; x=1706543121;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E6KDQ+M8+EAM5y8GRJ0L1criDCqr36mpkQ5ScFVsktc=;
  b=VFVfKWtC5BnHTaAJuaO9fUxh97/VdwhOqEhNjcH2K92DLvIUekb+b3eY
   18ObeE1lue9tV7B8H2iT3J3N+muQrYLCVlz97c9IrvZfUGgA37EqNRBsM
   VcskYPgqlrHeJwrOH3OkpnUAdLP1BVXwPdxnxB6HtAEONabWMYSq6W+qc
   qjMaQ4JJG+nUkuj3WoibEZ2y78C/CX3+F5L7NUG8V5APsqLeqHzKerJnZ
   3OTtVnjvp0TuowOEb2cYPYn6NKTa+S44bJC2HRLNS9Ouqp2taMdwjQwm6
   3LT5tdC5ip89Fa+hS7T+/AYWlllNG/vLV87Ay5kkXn8k9ltq5LiK+mljF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="413625488"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="413625488"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 07:45:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="694295965"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="694295965"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2023 07:45:13 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pM9rk-0002u4-1r;
        Sun, 29 Jan 2023 15:45:12 +0000
Date:   Sun, 29 Jan 2023 23:44:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1] netlink: provide an ability to set default
 extack message
Message-ID: <202301292320.pYrX8egS-lkp@intel.com>
References: <d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Leon-Romanovsky/netlink-provide-an-ability-to-set-default-extack-message/20230129-203242
patch link:    https://lore.kernel.org/r/d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon%40kernel.org
patch subject: [PATCH net-next v1] netlink: provide an ability to set default extack message
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230129/202301292320.pYrX8egS-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f0b11fb09eb6708058858b0cf95d1fec34eba956
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Leon-Romanovsky/netlink-provide-an-ability-to-set-default-extack-message/20230129-203242
        git checkout f0b11fb09eb6708058858b0cf95d1fec34eba956
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/bridge/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/bridge/br_switchdev.c:107:3: error: called object type 'char[9]' is not a function or function pointer
                   NL_SET_ERR_MSG_WEAK_MOD(extack,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   net/bridge/br_switchdev.c:117:3: error: called object type 'char[9]' is not a function or function pointer
                   NL_SET_ERR_MSG_WEAK_MOD(extack,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   2 errors generated.


vim +107 net/bridge/br_switchdev.c

    72	
    73	/* Flags that can be offloaded to hardware */
    74	#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB | \
    75					  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
    76					  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
    77	
    78	int br_switchdev_set_port_flag(struct net_bridge_port *p,
    79				       unsigned long flags,
    80				       unsigned long mask,
    81				       struct netlink_ext_ack *extack)
    82	{
    83		struct switchdev_attr attr = {
    84			.orig_dev = p->dev,
    85		};
    86		struct switchdev_notifier_port_attr_info info = {
    87			.attr = &attr,
    88		};
    89		int err;
    90	
    91		mask &= BR_PORT_FLAGS_HW_OFFLOAD;
    92		if (!mask)
    93			return 0;
    94	
    95		attr.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS;
    96		attr.u.brport_flags.val = flags;
    97		attr.u.brport_flags.mask = mask;
    98	
    99		/* We run from atomic context here */
   100		err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
   101					       &info.info, extack);
   102		err = notifier_to_errno(err);
   103		if (err == -EOPNOTSUPP)
   104			return 0;
   105	
   106		if (err) {
 > 107			NL_SET_ERR_MSG_WEAK_MOD(extack,
   108						"bridge flag offload is not supported");
   109			return -EOPNOTSUPP;
   110		}
   111	
   112		attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
   113		attr.flags = SWITCHDEV_F_DEFER;
   114	
   115		err = switchdev_port_attr_set(p->dev, &attr, extack);
   116		if (err) {
   117			NL_SET_ERR_MSG_WEAK_MOD(extack,
   118						"error setting offload flag on port");
   119			return err;
   120		}
   121	
   122		return 0;
   123	}
   124	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
