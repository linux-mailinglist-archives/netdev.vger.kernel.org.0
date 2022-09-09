Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B115B39C8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiIINqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiIINqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:46:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95594131BEF
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 06:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662731185; x=1694267185;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bOumJnRPkN+EhKWt0SJyT8pLZSEuGQcN/nu/jsJGYrY=;
  b=muMsQtMpmstSC16iJ8v5c84Eq4byfg9ZfnfukuboulPTPtyvZ6jvWDOM
   gp9+WKC9HMGQ7G5usWNcWk3EIAP7l5cuKRJigMCSt3TnDWXYeyMklEv9M
   F/wbOqMGcKctwypKAaT52BnBMOc3Y0fxajguqB0jnmyOcJdRKHFhmpE5R
   +WCtPxZHkaBmS+xVjMypVh+YAhxlGLpMQLtqpATzHkGk/jkFeI7hzaMTk
   0vyMq+IKy2NMwjBS+N4dkzh+fJNDphezKzw3OjAD+maWefqxzE6jizw2i
   eAjg28heeDQULll/b/qwWQ42A1GdRjT6O3JfrrmxUDj9kGht1esIGe+wT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="323684081"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="323684081"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="592611147"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 09 Sep 2022 06:44:26 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWeIz-0001F3-19;
        Fri, 09 Sep 2022 13:44:25 +0000
Date:   Fri, 9 Sep 2022 21:43:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next v8 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <202209092151.xu08eXWH-lkp@intel.com>
References: <20220909085138.3539952-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909085138.3539952-5-mattias.forsblad@gmail.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Mattias-Forsblad/net-dsa-qca8k-mv88e6xxx-rmon-Add-RMU-support/20220909-165609
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 34df6a8a50aa72c4ac4fd65033a2798fc321adf8
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220909/202209092151.xu08eXWH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/5a8005d484d3a5d466c656f11cba47e951f7d264
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mattias-Forsblad/net-dsa-qca8k-mv88e6xxx-rmon-Add-RMU-support/20220909-165609
        git checkout 5a8005d484d3a5d466c656f11cba47e951f7d264
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/dsa/mv88e6xxx/chip.c:45:
>> drivers/net/dsa/mv88e6xxx/rmu.h:20:17: warning: 'rmu_dest_addr' defined but not used [-Wunused-const-variable=]
      20 | static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
         |                 ^~~~~~~~~~~~~


vim +/rmu_dest_addr +20 drivers/net/dsa/mv88e6xxx/rmu.h

    19	
  > 20	static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
    21	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
