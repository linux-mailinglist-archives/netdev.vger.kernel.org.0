Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033BB6C2B22
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCUHOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCUHO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:14:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1E3303CD
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679382861; x=1710918861;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xLu0p9zfNRrUVbAcjNoGs6X4bpyytq2hcfMnYuJyjw4=;
  b=nn+AGsAjh9/UwLRzGs13pjXST/otZu6HYFL8IaV9PEO80+jXRoJD9Req
   qM1hXyxWvWGH4GaAebiGUFfQBWSzs+VZ4MKlfhSbu+l6gavlJxwebslLZ
   i5/IaMh9rX/P1jeD11D/X7Tz7pE5pZo0F98825kT+0Ztd8/iihogVTfm2
   AHtFr9V4X7JkiSv1b2DrlkvNTHfStRqtvTOH6V+iQ5ZlKNndadJRz/J0H
   th1Q0Ec7wfIpiXFMrvgtucsra+QC5ASnOLvIt6nMbzWTJFQ7HPkJTDZ6L
   q4rRhp6mNobF4zF3wFIy7jUICOYQOcCk6S20WSJJk3ihhS60Y32cUa5Ev
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="318518707"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="318518707"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="791957018"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="791957018"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2023 00:14:18 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peWCH-000Bi8-2I;
        Tue, 21 Mar 2023 07:14:17 +0000
Date:   Tue, 21 Mar 2023 15:14:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303211503.hDK3soqh-lkp@intel.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
patch link:    https://lore.kernel.org/r/20230321033704.936685-1-eric.dumazet%40gmail.com
patch subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: loongarch-randconfig-r014-20230319 (https://download.01.org/0day-ci/archive/20230321/202303211503.hDK3soqh-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d0eaa3eabce1c80d067a739749e4253546417722
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
        git checkout d0eaa3eabce1c80d067a739749e4253546417722
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash net/packet/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211503.hDK3soqh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/loongarch/include/asm/bug.h:59,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/loongarch/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:56,
                    from include/linux/ipc.h:5,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/compat.h:14,
                    from include/linux/ethtool.h:17,
                    from net/packet/af_packet.c:51:
   net/packet/af_packet.c: In function 'tpacket_fill_skb':
>> include/linux/kern_levels.h:5:25: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   net/packet/af_packet.c:2625:25: note: in expansion of macro 'pr_err'
    2625 |                         pr_err("Packet exceed the number of skb frags(%lu)\n",
         |                         ^~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
