Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0FC4CA608
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbiCBNbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242248AbiCBNbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:31:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6C8C5580
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 05:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646227867; x=1677763867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nGH92jnM8+o5caWHklIQVtAB9Fou1SJYOAX+1WLyS0Y=;
  b=SK3R4NypDXgu4ho86r6S/TMwr5/cYtSktOtqOaM7p2mKEo+50BcUoDO3
   xM4pVQJ4ryCSkqD5LZ7wq+cIX8ab3oUezylPZShKYcLIPS9Nn7FlRWd+p
   ZT9osms675rstfztgtLaU1d4AdeKfV5TP9pEOfD6AVB47RCXvoQmjP/4l
   ZBr5g1qNP3+wyY7EYOEshtxv+yuAogqVkx5xI812vjU7IRdmSZWDKqMf+
   qUOornj+Mo2qOdRF2YJ6U1GocQTqBBzEXYQmbHvYzfXhL4bqXfMZVohZz
   V7RC7ErvN4wKXTrSOsMJ8S7d5kSvgbZ0r3q8jkbNAOjt+QzemvqLvuQiz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="234015060"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="234015060"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 05:31:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="551250772"
Received: from lkp-server02.sh.intel.com (HELO e9605edfa585) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 02 Mar 2022 05:31:03 -0800
Received: from kbuild by e9605edfa585 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nPP4I-0001RV-FU; Wed, 02 Mar 2022 13:31:02 +0000
Date:   Wed, 2 Mar 2022 21:30:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH 3/3] mv88e6xxx: Offload the local_receive flag
Message-ID: <202203022121.C5ab64dX-lkp@intel.com>
References: <20220301123104.226731-4-mattias.forsblad+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301123104.226731-4-mattias.forsblad+netdev@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattias,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Mattias-Forsblad/bridge-dsa-switchdev-mv88e6xxx-Implement-local_receive-bridge-flag/20220301-203159
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1e385c08249e4822e0f425efde1896d3933d1471
config: parisc-randconfig-r012-20220302 (https://download.01.org/0day-ci/archive/20220302/202203022121.C5ab64dX-lkp@intel.com/config)
compiler: hppa64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/fcf70df585fafd4afbec12c1597bfc62c3245c32
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mattias-Forsblad/bridge-dsa-switchdev-mv88e6xxx-Implement-local_receive-bridge-flag/20220301-203159
        git checkout fcf70df585fafd4afbec12c1597bfc62c3245c32
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=parisc64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   hppa64-linux-ld: drivers/net/dsa/mv88e6xxx/chip.o: in function `.LC292':
>> (.data.rel.ro+0x7c8): undefined reference to `br_local_receive_enabled'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
