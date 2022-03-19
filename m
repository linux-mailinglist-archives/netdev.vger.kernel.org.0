Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0464DE516
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbiCSB5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiCSB5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:57:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1144A2DE7BA;
        Fri, 18 Mar 2022 18:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647654959; x=1679190959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tAh91vnc3rdEkDuaj4h0v1lIN85KM43f8GOfm7AX5qI=;
  b=Oj07FoNn7MC0leaT/w8g9nBra1Vt6fwdIOtjPcRqzPYYufU11jNrCaJG
   pKhuO/IgIL+MGLEviXlQhfBlw3XeXmuF2pW+2LpmdCIYnXc5CahfT3PjN
   daxfQPTNxm+GvCn2XXGLwpLGv18uFe6vH31V+Cc+fk9RxvH+s0nHFg3Kt
   GDK9FZjlZEhme00tZ9eU8STAU47JHfi6gaT2jbxZzgLQ1MGcC+p+PqMfL
   lw3BM1QfB/+SDAAOw+Ie8K3yPlYirFGa9fKN7OUyblFObrhGh4YinDcsv
   EnFpPmHepuCPSK0C2Ta43wu8gCo7JnsaEBTeKSdiXNRpsXyegrxFQ3JGs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237871985"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="237871985"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 18:55:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="542147515"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2022 18:55:56 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nVOJw-000FPR-92; Sat, 19 Mar 2022 01:55:56 +0000
Date:   Sat, 19 Mar 2022 09:55:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH net-next] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <202203190905.sxFKRU10-lkp@intel.com>
References: <20220318204350.1918-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318204350.1918-1-socketcan@hartkopp.net>
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

Hi Oliver,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Oliver-Hartkopp/net-remove-noblock-parameter-from-skb_recv_datagram/20220319-044459
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e89600ebeeb14d18c0b062837a84196f72542830
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220319/202203190905.sxFKRU10-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/31180f21a45948092a6c4be3400fd87517ea4eb4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Oliver-Hartkopp/net-remove-noblock-parameter-from-skb_recv_datagram/20220319-044459
        git checkout 31180f21a45948092a6c4be3400fd87517ea4eb4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from net/mctp/route.c:1405:
   net/mctp/test/route-test.c: In function 'mctp_test_route_input_sk_keys':
>> net/mctp/test/route-test.c:585:47: warning: passing argument 3 of 'skb_recv_datagram' makes pointer from integer without a cast [-Wint-conversion]
     585 |         skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
         |                                               ^
         |                                               |
         |                                               int
   In file included from include/net/net_namespace.h:40,
                    from include/linux/netdevice.h:38,
                    from include/uapi/linux/mctp.h:14,
                    from net/mctp/route.c:15:
   include/linux/skbuff.h:3839:77: note: expected 'int *' but argument is of type 'int'
    3839 | struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
         |                                                                        ~~~~~^~~
   In file included from net/mctp/route.c:1405:
>> net/mctp/test/route-test.c:585:16: error: too many arguments to function 'skb_recv_datagram'
     585 |         skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
         |                ^~~~~~~~~~~~~~~~~
   In file included from include/net/net_namespace.h:40,
                    from include/linux/netdevice.h:38,
                    from include/uapi/linux/mctp.h:14,
                    from net/mctp/route.c:15:
   include/linux/skbuff.h:3839:17: note: declared here
    3839 | struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
         |                 ^~~~~~~~~~~~~~~~~


vim +/skb_recv_datagram +585 net/mctp/test/route-test.c

c5755214623dd7 Jeremy Kerr 2022-02-09  534  
c5755214623dd7 Jeremy Kerr 2022-02-09  535  /* test packet rx in the presence of various key configurations */
c5755214623dd7 Jeremy Kerr 2022-02-09  536  static void mctp_test_route_input_sk_keys(struct kunit *test)
c5755214623dd7 Jeremy Kerr 2022-02-09  537  {
c5755214623dd7 Jeremy Kerr 2022-02-09  538  	const struct mctp_route_input_sk_keys_test *params;
c5755214623dd7 Jeremy Kerr 2022-02-09  539  	struct mctp_test_route *rt;
c5755214623dd7 Jeremy Kerr 2022-02-09  540  	struct sk_buff *skb, *skb2;
c5755214623dd7 Jeremy Kerr 2022-02-09  541  	struct mctp_test_dev *dev;
c5755214623dd7 Jeremy Kerr 2022-02-09  542  	struct mctp_sk_key *key;
c5755214623dd7 Jeremy Kerr 2022-02-09  543  	struct netns_mctp *mns;
c5755214623dd7 Jeremy Kerr 2022-02-09  544  	struct mctp_sock *msk;
c5755214623dd7 Jeremy Kerr 2022-02-09  545  	struct socket *sock;
c5755214623dd7 Jeremy Kerr 2022-02-09  546  	unsigned long flags;
c5755214623dd7 Jeremy Kerr 2022-02-09  547  	int rc;
c5755214623dd7 Jeremy Kerr 2022-02-09  548  	u8 c;
c5755214623dd7 Jeremy Kerr 2022-02-09  549  
c5755214623dd7 Jeremy Kerr 2022-02-09  550  	params = test->param_value;
c5755214623dd7 Jeremy Kerr 2022-02-09  551  
c5755214623dd7 Jeremy Kerr 2022-02-09  552  	dev = mctp_test_create_dev();
c5755214623dd7 Jeremy Kerr 2022-02-09  553  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
c5755214623dd7 Jeremy Kerr 2022-02-09  554  
c5755214623dd7 Jeremy Kerr 2022-02-09  555  	rt = mctp_test_create_route(&init_net, dev->mdev, 8, 68);
c5755214623dd7 Jeremy Kerr 2022-02-09  556  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, rt);
c5755214623dd7 Jeremy Kerr 2022-02-09  557  
c5755214623dd7 Jeremy Kerr 2022-02-09  558  	rc = sock_create_kern(&init_net, AF_MCTP, SOCK_DGRAM, 0, &sock);
c5755214623dd7 Jeremy Kerr 2022-02-09  559  	KUNIT_ASSERT_EQ(test, rc, 0);
c5755214623dd7 Jeremy Kerr 2022-02-09  560  
c5755214623dd7 Jeremy Kerr 2022-02-09  561  	msk = container_of(sock->sk, struct mctp_sock, sk);
c5755214623dd7 Jeremy Kerr 2022-02-09  562  	mns = &sock_net(sock->sk)->mctp;
c5755214623dd7 Jeremy Kerr 2022-02-09  563  
c5755214623dd7 Jeremy Kerr 2022-02-09  564  	/* set the incoming tag according to test params */
c5755214623dd7 Jeremy Kerr 2022-02-09  565  	key = mctp_key_alloc(msk, params->key_local_addr, params->key_peer_addr,
c5755214623dd7 Jeremy Kerr 2022-02-09  566  			     params->key_tag, GFP_KERNEL);
c5755214623dd7 Jeremy Kerr 2022-02-09  567  
c5755214623dd7 Jeremy Kerr 2022-02-09  568  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, key);
c5755214623dd7 Jeremy Kerr 2022-02-09  569  
c5755214623dd7 Jeremy Kerr 2022-02-09  570  	spin_lock_irqsave(&mns->keys_lock, flags);
c5755214623dd7 Jeremy Kerr 2022-02-09  571  	mctp_reserve_tag(&init_net, key, msk);
c5755214623dd7 Jeremy Kerr 2022-02-09  572  	spin_unlock_irqrestore(&mns->keys_lock, flags);
c5755214623dd7 Jeremy Kerr 2022-02-09  573  
c5755214623dd7 Jeremy Kerr 2022-02-09  574  	/* create packet and route */
c5755214623dd7 Jeremy Kerr 2022-02-09  575  	c = 0;
c5755214623dd7 Jeremy Kerr 2022-02-09  576  	skb = mctp_test_create_skb_data(&params->hdr, &c);
c5755214623dd7 Jeremy Kerr 2022-02-09  577  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
c5755214623dd7 Jeremy Kerr 2022-02-09  578  
c5755214623dd7 Jeremy Kerr 2022-02-09  579  	skb->dev = dev->ndev;
c5755214623dd7 Jeremy Kerr 2022-02-09  580  	__mctp_cb(skb);
c5755214623dd7 Jeremy Kerr 2022-02-09  581  
c5755214623dd7 Jeremy Kerr 2022-02-09  582  	rc = mctp_route_input(&rt->rt, skb);
c5755214623dd7 Jeremy Kerr 2022-02-09  583  
c5755214623dd7 Jeremy Kerr 2022-02-09  584  	/* (potentially) receive message */
c5755214623dd7 Jeremy Kerr 2022-02-09 @585  	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
c5755214623dd7 Jeremy Kerr 2022-02-09  586  
c5755214623dd7 Jeremy Kerr 2022-02-09  587  	if (params->deliver)
c5755214623dd7 Jeremy Kerr 2022-02-09  588  		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
c5755214623dd7 Jeremy Kerr 2022-02-09  589  	else
c5755214623dd7 Jeremy Kerr 2022-02-09  590  		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
c5755214623dd7 Jeremy Kerr 2022-02-09  591  
c5755214623dd7 Jeremy Kerr 2022-02-09  592  	if (skb2)
c5755214623dd7 Jeremy Kerr 2022-02-09  593  		skb_free_datagram(sock->sk, skb2);
c5755214623dd7 Jeremy Kerr 2022-02-09  594  
c5755214623dd7 Jeremy Kerr 2022-02-09  595  	mctp_key_unref(key);
c5755214623dd7 Jeremy Kerr 2022-02-09  596  	__mctp_route_test_fini(test, dev, rt, sock);
c5755214623dd7 Jeremy Kerr 2022-02-09  597  }
c5755214623dd7 Jeremy Kerr 2022-02-09  598  

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
