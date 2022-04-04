Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CB74F11DB
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350601AbiDDJVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 05:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiDDJVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 05:21:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDB0765C
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 02:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649063954; x=1680599954;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PRmUoYnR9ObRGY4bAzNyOUan5LivX4ITkvO/QgDSiUo=;
  b=H0AVWNdbn3dmcfPAp7gOdxGxdQO3/635iL/ovuzNiCKNNaul19y/qO5Z
   FVq0Ed/YGPCvx2SLZTXg9JIceJx/hakKLlWMTG0M+BBVcobz1wSFXQjcT
   2JHZ5gu+ruYcBlGC3c0uVigNwRYrYD8XzVdTo2rl7GK+z6g7sae+sCCX1
   K2fmcFwzLkcg13IO40VAVLz+BIo3INOWgMCtKvD4Hte98qOJzUXGpgKyN
   candbFhyJ2yMdze6gzpJsIX5R5FqQUheFbDIBeSgqO4lzGUV82bCf3sP/
   1xgfGb+R6lqyqeOVhzBVe4OlFKn7hSRUOkD9Cnc1n70rkb0CsBq0NghzB
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="285421758"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="285421758"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 02:19:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657429136"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 02:19:10 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nbIrd-0001wT-Os;
        Mon, 04 Apr 2022 09:19:09 +0000
Date:   Mon, 4 Apr 2022 17:18:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net: tc: dsa: Add the matchall filter
 with drop action for bridged DSA ports.
Message-ID: <202204041711.z39NxDjM-lkp@intel.com>
References: <20220404063327.1017157-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404063327.1017157-2-mattias.forsblad@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

url:    https://github.com/intel-lab-lkp/linux/commits/Mattias-Forsblad/net-tc-dsa-Implement-offload-of-matchall-for-bridged-DSA-ports/20220404-143446
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 89695196f0ba78a17453f9616355f2ca6b293402
config: arm-randconfig-r021-20220404 (https://download.01.org/0day-ci/archive/20220404/202204041711.z39NxDjM-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c4a1b07d0979e7ff20d7d541af666d822d66b566)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/6781e2f5653edf4eeab1aa2996a250b942f2b19b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-tc-dsa-Implement-offload-of-matchall-for-bridged-DSA-ports/20220404-143446
        git checkout 6781e2f5653edf4eeab1aa2996a250b942f2b19b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/dsa/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/dsa/slave.c:1307:9: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
           return err;
                  ^~~
   net/dsa/slave.c:1289:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   1 warning generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MICREL_PHY
   Depends on NETDEVICES && PHYLIB && PTP_1588_CLOCK_OPTIONAL
   Selected by
   - KS8851_MLL && NETDEVICES && ETHERNET && NET_VENDOR_MICREL && HAS_IOMEM


vim +/err +1307 net/dsa/slave.c

  1278	
  1279	static int
  1280	dsa_slave_add_cls_matchall_drop(struct net_device *dev,
  1281					struct tc_cls_matchall_offload *cls,
  1282					bool ingress)
  1283	{
  1284		struct dsa_port *dp = dsa_slave_to_port(dev);
  1285		struct dsa_slave_priv *p = netdev_priv(dev);
  1286		struct dsa_mall_tc_entry *mall_tc_entry;
  1287		struct dsa_mall_drop_tc_entry *drop;
  1288		struct dsa_switch *ds = dp->ds;
  1289		int err;
  1290	
  1291		if (!ds->ops->bridge_local_rcv)
  1292			return -EOPNOTSUPP;
  1293	
  1294		mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
  1295		if (!mall_tc_entry)
  1296			return -ENOMEM;
  1297	
  1298		mall_tc_entry->cookie = cls->cookie;
  1299		mall_tc_entry->type = DSA_PORT_MALL_DROP;
  1300		drop = &mall_tc_entry->drop;
  1301		drop->enable = true;
  1302		dp->bridge->local_rcv = 0;
  1303		dsa_slave_bridge_foreign_if_check(dp->bridge->dev, drop);
  1304	
  1305		list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
  1306	
> 1307		return err;
  1308	}
  1309	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
