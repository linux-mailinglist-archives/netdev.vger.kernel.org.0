Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4835209B1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiEIX4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiEIX4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:56:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96D84C78B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652140325; x=1683676325;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TQJQFjueDSBasDFSBrI65m8aXGgYtoBOWaUhG6eV7x8=;
  b=GrFkUMEbkwOmyBanhqTpY7AqmIjJGtwfAuKjy+WBGFXI+obFN5aa04Lb
   WYmg2Hl7AHU+vNSVDmmadHnJeJ3OlKP3ZdfOP4uV/Sd/53r/CGcuSUHkX
   RV/OdmtmC65k1uutolT+YhYPl6ieQdUBu9MJ1pkJnasqGBNGcFBa4hiLE
   Rr8/6FikVMkft4UiMDFMscpv3xYHGKpf1DMc3pCVzhVx/DPe83am+zfsI
   UueL2hffzpF7jS1gnYutGKH3+QEXGDHvggBpaTbW128ncsurg/YpW7Zgl
   TFNBmgATA+voCTVhWHy3aZ6ab6sY70Dq6j8qjVt5A5tT743K+YnWiHk+C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332239419"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="332239419"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 16:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="813706946"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 09 May 2022 16:52:02 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noDAY-000H1K-8l;
        Mon, 09 May 2022 23:52:02 +0000
Date:   Tue, 10 May 2022 07:51:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
Message-ID: <202205100711.gqvHz9Km-lkp@intel.com>
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509190851.1107955-4-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
config: x86_64-randconfig-m001-20220509 (https://download.01.org/0day-ci/archive/20220510/202205100711.gqvHz9Km-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/d316b61f313a417d7dfa97fa006320288f3af150
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
        git checkout d316b61f313a417d7dfa97fa006320288f3af150
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/can/ctucanfd/ drivers/net/can/spi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   In file included from include/linux/can/dev.h:18,
                    from drivers/net/can/ctucanfd/ctucanfd.h:24,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:35:
   include/linux/can/bittiming.h: In function 'can_calc_bittiming':
   include/linux/can/bittiming.h:127:20: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     127 |         netdev_err(dev, "bit-timing calculation not available\n");
         |                    ^~~
         |                    |
         |                    const struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'const struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   In file included from drivers/net/can/ctucanfd/ctucanfd.h:24,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:35:
   include/linux/can/dev.h: In function 'can_set_static_ctrlmode':
   include/linux/can/dev.h:141:29: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     141 |                 netdev_warn(dev,
         |                             ^~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_reset':
>> drivers/net/can/ctucanfd/ctucanfd_base.c:190:37: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     190 |                         netdev_warn(ndev, "device did not leave reset\n");
         |                                     ^~~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_set_btr':
>> drivers/net/can/ctucanfd/ctucanfd_base.c:214:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     214 |                 netdev_err(ndev, "BUG! Cannot set bittiming - CAN is enabled\n");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_set_secondary_sample_point':
   drivers/net/can/ctucanfd/ctucanfd_base.c:298:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     298 |                 netdev_err(ndev, "BUG! Cannot set SSP - CAN is enabled\n");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:308:37: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     308 |                         netdev_warn(ndev, "SSP offset saturated to 127\n");
         |                                     ^~~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_do_set_mode':
   drivers/net/can/ctucanfd/ctucanfd_base.c:455:36: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     455 |                         netdev_err(ndev, "ctucan_chip_start failed!\n");
         |                                    ^~~~
         |                                    |
         |                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_start_xmit':
   drivers/net/can/ctucanfd/ctucanfd_base.c:608:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     608 |                 netdev_err(ndev, "BUG!, no TXB free when queue awake!\n");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:617:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     617 |                 netdev_err(ndev, "BUG! TXNF set but cannot insert frame into TXTB! HW Bug?");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_err_interrupt':
>> drivers/net/can/ctucanfd/ctucanfd_base.c:817:29: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     817 |                 netdev_info(ndev, "%s: ISR = 0x%08x, rxerr %d, txerr %d, error type %lu, pos %lu, ALC id_field %lu, bit %lu\n",
         |                             ^~~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:832:29: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     832 |                 netdev_info(ndev, "state changes from %s to %s\n",
         |                             ^~~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:837:37: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     837 |                         netdev_warn(ndev,
         |                                     ^~~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:876:37: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     876 |                         netdev_warn(ndev, "unhandled error state (%d:%s)!\n",
         |                                     ^~~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:885:37: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     885 |                         netdev_info(ndev, "arbitration lost\n");
         |                                     ^~~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:895:29: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     895 |                 netdev_info(ndev, "bus error\n");
         |                             ^~~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_rx_poll':
   drivers/net/can/ctucanfd/ctucanfd_base.c:944:29: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     944 |                 netdev_info(ndev, "rx_poll: rx fifo overflow\n");
         |                             ^~~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_tx_interrupt':
   drivers/net/can/ctucanfd/ctucanfd_base.c:1033:45: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1033 |                                 netdev_warn(ndev, "TXB in Error state\n");
         |                                             ^~~~
         |                                             |
         |                                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1042:45: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1042 |                                 netdev_warn(ndev, "TXB in Aborted state\n");
         |                                             ^~~~
         |                                             |
         |                                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1051:52: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1051 |                                         netdev_err(ndev,
         |                                                    ^~~~
         |                                                    |
         |                                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
--
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1161:36: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1161 |                         netdev_err(ndev, "txb[%d] txb status=0x%08x\n", i, status);
         |                                    ^~~~
         |                                    |
         |                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_open':
   drivers/net/can/ctucanfd/ctucanfd_base.c:1209:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1209 |                 netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1222:29: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1222 |                 netdev_warn(ndev, "open_candev failed!\n");
         |                             ^~~~
         |                             |
         |                             struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1228:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1228 |                 netdev_err(ndev, "irq allocation for CAN failed\n");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1234:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1234 |                 netdev_err(ndev, "ctucan_chip_start failed!\n");
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1238:21: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1238 |         netdev_info(ndev, "ctu_can_fd device registered\n");
         |                     ^~~~
         |                     |
         |                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_get_berr_counter':
   drivers/net/can/ctucanfd/ctucanfd_base.c:1293:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1293 |                 netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
         |                            ^~~~
         |                            |
         |                            const struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'const struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c: In function 'ctucan_probe_common':
   drivers/net/can/ctucanfd/ctucanfd_base.c:1406:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1406 |                 netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
         |                            ^~~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/can/ctucanfd/ctucanfd_base.c:1417:36: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1417 |                         netdev_err(ndev, "CTU_CAN_FD signature not found\n");
         |                                    ^~~~
         |                                    |
         |                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/can/ctucanfd/ctucanfd_base.c:28:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
>> drivers/net/can/ctucanfd/ctucanfd_base.c:1441:20: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1441 |         netdev_dbg(ndev, "mem_base=0x%p irq=%d clock=%d, no. of txt buffers:%d\n",
         |                    ^~~~
         |                    |
         |                    struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors
..


vim +/netdev_warn +190 drivers/net/can/ctucanfd/ctucanfd_base.c

2dcb8e8782d8e4 Martin Jerabek 2022-03-22  168  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  169  /**
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  170   * ctucan_reset() - Issues software reset request to CTU CAN FD
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  171   * @ndev:	Pointer to net_device structure
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  172   *
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  173   * Return: 0 for success, -%ETIMEDOUT if CAN controller does not leave reset
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  174   */
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  175  static int ctucan_reset(struct net_device *ndev)
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  176  {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  177  	struct ctucan_priv *priv = netdev_priv(ndev);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  178  	int i = 100;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  179  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  180  	ctucan_write32(priv, CTUCANFD_MODE, REG_MODE_RST);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  181  	clear_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  182  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  183  	do {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  184  		u16 device_id = FIELD_GET(REG_DEVICE_ID_DEVICE_ID,
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  185  					  ctucan_read32(priv, CTUCANFD_DEVICE_ID));
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  186  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  187  		if (device_id == 0xCAFD)
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  188  			return 0;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  189  		if (!i--) {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22 @190  			netdev_warn(ndev, "device did not leave reset\n");
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  191  			return -ETIMEDOUT;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  192  		}
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  193  		usleep_range(100, 200);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  194  	} while (1);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  195  }
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  196  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  197  /**
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  198   * ctucan_set_btr() - Sets CAN bus bit timing in CTU CAN FD
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  199   * @ndev:	Pointer to net_device structure
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  200   * @bt:		Pointer to Bit timing structure
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  201   * @nominal:	True - Nominal bit timing, False - Data bit timing
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  202   *
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  203   * Return: 0 - OK, -%EPERM if controller is enabled
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  204   */
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  205  static int ctucan_set_btr(struct net_device *ndev, struct can_bittiming *bt, bool nominal)
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  206  {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  207  	struct ctucan_priv *priv = netdev_priv(ndev);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  208  	int max_ph1_len = 31;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  209  	u32 btr = 0;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  210  	u32 prop_seg = bt->prop_seg;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  211  	u32 phase_seg1 = bt->phase_seg1;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  212  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  213  	if (CTU_CAN_FD_ENABLED(priv)) {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22 @214  		netdev_err(ndev, "BUG! Cannot set bittiming - CAN is enabled\n");
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  215  		return -EPERM;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  216  	}
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  217  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  218  	if (nominal)
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  219  		max_ph1_len = 63;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  220  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  221  	/* The timing calculation functions have only constraints on tseg1, which is prop_seg +
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  222  	 * phase1_seg combined. tseg1 is then split in half and stored into prog_seg and phase_seg1.
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  223  	 * In CTU CAN FD, PROP is 6/7 bits wide but PH1 only 6/5, so we must re-distribute the
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  224  	 * values here.
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  225  	 */
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  226  	if (phase_seg1 > max_ph1_len) {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  227  		prop_seg += phase_seg1 - max_ph1_len;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  228  		phase_seg1 = max_ph1_len;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  229  		bt->prop_seg = prop_seg;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  230  		bt->phase_seg1 = phase_seg1;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  231  	}
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  232  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  233  	if (nominal) {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  234  		btr = FIELD_PREP(REG_BTR_PROP, prop_seg);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  235  		btr |= FIELD_PREP(REG_BTR_PH1, phase_seg1);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  236  		btr |= FIELD_PREP(REG_BTR_PH2, bt->phase_seg2);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  237  		btr |= FIELD_PREP(REG_BTR_BRP, bt->brp);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  238  		btr |= FIELD_PREP(REG_BTR_SJW, bt->sjw);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  239  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  240  		ctucan_write32(priv, CTUCANFD_BTR, btr);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  241  	} else {
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  242  		btr = FIELD_PREP(REG_BTR_FD_PROP_FD, prop_seg);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  243  		btr |= FIELD_PREP(REG_BTR_FD_PH1_FD, phase_seg1);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  244  		btr |= FIELD_PREP(REG_BTR_FD_PH2_FD, bt->phase_seg2);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  245  		btr |= FIELD_PREP(REG_BTR_FD_BRP_FD, bt->brp);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  246  		btr |= FIELD_PREP(REG_BTR_FD_SJW_FD, bt->sjw);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  247  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  248  		ctucan_write32(priv, CTUCANFD_BTR_FD, btr);
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  249  	}
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  250  
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  251  	return 0;
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  252  }
2dcb8e8782d8e4 Martin Jerabek 2022-03-22  253  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
