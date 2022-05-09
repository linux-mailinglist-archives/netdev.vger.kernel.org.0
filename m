Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C888520866
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiEIXgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiEIXf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:35:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E120CA70
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652139123; x=1683675123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AbSkMJhVBi75MwZZeKR4TvLfgc1klxv+VamqFHa1KVw=;
  b=bxGlfO7xBNjJtorhwXm/h/rQwTdkdzwciFGoAEWxX1+MZwQ4ll3WHyz6
   5tGE5GVyulYmnlh3jNYIB2CNfdLPIt674ERaw8f2vF1am3gWf9jS0MnNv
   k2mqmpat9rfizxKPpPx71oXhPK9WQrNbqsYdGIykQNLmRCmg42mD3OwMT
   0UEsVUa1RP3/zvag6S+Josz7tMD9osdKaZuq9JcG5NrxSTm5feT81HUhs
   /xJVXZ1mXx+YLy4YdDWht6jlFxBNqQO0mkOn8U2/cKx7HR0zIII34kpa2
   kNc+oDoJLtJOWqHeMVWika42YCU1fEvhGVg/d4nnTapk9Avq41p1N7YUs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269333884"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="269333884"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 16:32:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="657360647"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2022 16:32:01 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noCrA-000H0C-RB;
        Mon, 09 May 2022 23:32:00 +0000
Date:   Tue, 10 May 2022 07:31:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
Message-ID: <202205100711.cCKt89Rb-lkp@intel.com>
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509190851.1107955-4-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220510/202205100711.cCKt89Rb-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/d316b61f313a417d7dfa97fa006320288f3af150
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
        git checkout d316b61f313a417d7dfa97fa006320288f3af150
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/skbuff.h:45,
                    from drivers/net/tun.c:44:
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
   In file included from include/linux/skbuff.h:45,
                    from drivers/net/tun.c:44:
   drivers/net/tun.c: In function 'tun_flow_create':
>> drivers/net/tun.c:380:47: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     380 |                 netif_info(tun, tx_queued, tun->dev,
         |                                            ~~~^~~~~
         |                                               |
         |                                               struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:380:17: note: in expansion of macro 'netif_info'
     380 |                 netif_info(tun, tx_queued, tun->dev,
         |                 ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c: In function 'tun_flow_delete':
   drivers/net/tun.c:396:39: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     396 |         netif_info(tun, tx_queued, tun->dev, "delete flow: hash %u index %u\n",
         |                                    ~~~^~~~~
         |                                       |
         |                                       struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:396:9: note: in expansion of macro 'netif_info'
     396 |         netif_info(tun, tx_queued, tun->dev, "delete flow: hash %u index %u\n",
         |         ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c: In function 'tun_net_xmit':
   drivers/net/tun.c:1078:39: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1078 |         netif_info(tun, tx_queued, tun->dev, "%s %d\n", __func__, skb->len);
         |                                    ~~~^~~~~
         |                                       |
         |                                       struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:1078:9: note: in expansion of macro 'netif_info'
    1078 |         netif_info(tun, tx_queued, tun->dev, "%s %d\n", __func__, skb->len);
         |         ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c: In function '__tun_chr_ioctl':
   drivers/net/tun.c:3095:33: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3095 |         netif_info(tun, drv, tun->dev, "tun_chr_ioctl cmd %u\n", cmd);
         |                              ~~~^~~~~
         |                                 |
         |                                 struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:3095:9: note: in expansion of macro 'netif_info'
    3095 |         netif_info(tun, drv, tun->dev, "tun_chr_ioctl cmd %u\n", cmd);
         |         ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c:3116:41: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3116 |                 netif_info(tun, drv, tun->dev, "ignored: set checksum %s\n",
         |                                      ~~~^~~~~
         |                                         |
         |                                         struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:3116:17: note: in expansion of macro 'netif_info'
    3116 |                 netif_info(tun, drv, tun->dev, "ignored: set checksum %s\n",
         |                 ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c:3135:41: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3135 |                 netif_info(tun, drv, tun->dev, "persist %s\n",
         |                                      ~~~^~~~~
         |                                         |
         |                                         struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:3135:17: note: in expansion of macro 'netif_info'
    3135 |                 netif_info(tun, drv, tun->dev, "persist %s\n",
         |                 ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/tun.c:3148:41: error: passing argument 1 of 'netdev_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3148 |                 netif_info(tun, drv, tun->dev, "owner set to %u\n",
         |                                      ~~~^~~~~
         |                                         |
         |                                         struct net_device *
   include/net/net_debug.h:101:32: note: in definition of macro 'netif_level'
     101 |                 netdev_##level(dev, fmt, ##args);               \
         |                                ^~~
   drivers/net/tun.c:3148:17: note: in expansion of macro 'netif_info'
    3148 |                 netif_info(tun, drv, tun->dev, "owner set to %u\n",
         |                 ^~~~~~~~~~
   include/net/net_debug.h:21:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~


vim +/netdev_info +380 drivers/net/tun.c

96442e42429e5f Jason Wang     2012-10-31  372  
96442e42429e5f Jason Wang     2012-10-31  373  static struct tun_flow_entry *tun_flow_create(struct tun_struct *tun,
96442e42429e5f Jason Wang     2012-10-31  374  					      struct hlist_head *head,
96442e42429e5f Jason Wang     2012-10-31  375  					      u32 rxhash, u16 queue_index)
96442e42429e5f Jason Wang     2012-10-31  376  {
9fdc6bef5f1e8b Eric Dumazet   2012-12-21  377  	struct tun_flow_entry *e = kmalloc(sizeof(*e), GFP_ATOMIC);
9fdc6bef5f1e8b Eric Dumazet   2012-12-21  378  
96442e42429e5f Jason Wang     2012-10-31  379  	if (e) {
3424170f37e78c Michal Kubecek 2020-03-04 @380  		netif_info(tun, tx_queued, tun->dev,
3424170f37e78c Michal Kubecek 2020-03-04  381  			   "create flow: hash %u index %u\n",
96442e42429e5f Jason Wang     2012-10-31  382  			   rxhash, queue_index);
96442e42429e5f Jason Wang     2012-10-31  383  		e->updated = jiffies;
96442e42429e5f Jason Wang     2012-10-31  384  		e->rxhash = rxhash;
9bc8893937c836 Tom Herbert    2013-12-22  385  		e->rps_rxhash = 0;
96442e42429e5f Jason Wang     2012-10-31  386  		e->queue_index = queue_index;
96442e42429e5f Jason Wang     2012-10-31  387  		e->tun = tun;
96442e42429e5f Jason Wang     2012-10-31  388  		hlist_add_head_rcu(&e->hash_link, head);
b8732fb7f8920e Jason Wang     2013-01-23  389  		++tun->flow_count;
96442e42429e5f Jason Wang     2012-10-31  390  	}
96442e42429e5f Jason Wang     2012-10-31  391  	return e;
96442e42429e5f Jason Wang     2012-10-31  392  }
96442e42429e5f Jason Wang     2012-10-31  393  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
