Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C5B4FAFF3
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiDJUCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbiDJUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:02:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CBC103B
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 13:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649620817; x=1681156817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kaGbRKuD1/R+/pyQ3d78mQFXHgTTDiK1LNHItNyruvk=;
  b=NGcTXwIdT0GWGzTjVxt/fHlwVEsAQ0JNinuwxf9PRtzkbsc3EQqq53ey
   wMnd8gIv1uRDL8n9plaLxqtWswsupdGRt3Iv8H1pA98swWIWwmutYZQeg
   qOLJimr+mUm2DJrdwZf1Zv2vo8jz0kaRopdupVY4da/yO5xBZnk0BfCa9
   vNqT0ntuTGfF9kogU04oXu49GEwSm5L1KGQIhY5rS2E6H3sYdf41a16/o
   hSC02ztG1RxXQTdsqf7Nsnp4/IcTkDeJb8Lw9XZB1N6PHqXvRBSAt1j3b
   VEG09KizXZQVi+UZRuPBoj+OqcYzk+VuKL+TkHpSpL00h/z05DMM4tsdd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="241928095"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="241928095"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 13:00:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="525087863"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 10 Apr 2022 13:00:15 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nddjK-00014Z-TK;
        Sun, 10 Apr 2022 20:00:14 +0000
Date:   Mon, 11 Apr 2022 03:59:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH net-next] net: remove noblock parameter from recvmsg()
 entities
Message-ID: <202204110353.rQbTNo81-lkp@intel.com>
References: <20220410185354.123004-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410185354.123004-1-socketcan@hartkopp.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oliver,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Hartkopp/net-remove-noblock-parameter-from-recvmsg-entities/20220411-025612
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 516a2f1f6f3ce1a87931579cc21de6e7e33440bd
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20220411/202204110353.rQbTNo81-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/471dc1b8019d39c987dbdac34bb57678745739c8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oliver-Hartkopp/net-remove-noblock-parameter-from-recvmsg-entities/20220411-025612
        git checkout 471dc1b8019d39c987dbdac34bb57678745739c8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash net/sunrpc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   net/sunrpc/xprtsock.c: In function 'xs_udp_data_receive':
>> net/sunrpc/xprtsock.c:1340:43: warning: passing argument 3 of 'skb_recv_udp' makes pointer from integer without a cast [-Wint-conversion]
    1340 |                 skb = skb_recv_udp(sk, 0, 1, &err);
         |                                           ^
         |                                           |
         |                                           int
   In file included from net/sunrpc/xprtsock.c:48:
   include/net/udp.h:256:49: note: expected 'int *' but argument is of type 'int'
     256 |                                            int *err)
         |                                            ~~~~~^~~
>> net/sunrpc/xprtsock.c:1340:23: error: too many arguments to function 'skb_recv_udp'
    1340 |                 skb = skb_recv_udp(sk, 0, 1, &err);
         |                       ^~~~~~~~~~~~
   In file included from net/sunrpc/xprtsock.c:48:
   include/net/udp.h:255:31: note: declared here
     255 | static inline struct sk_buff *skb_recv_udp(struct sock *sk, unsigned int flags,
         |                               ^~~~~~~~~~~~
--
   net/sunrpc/svcsock.c: In function 'svc_udp_recvfrom':
>> net/sunrpc/svcsock.c:467:44: warning: passing argument 3 of 'skb_recv_udp' makes pointer from integer without a cast [-Wint-conversion]
     467 |         skb = skb_recv_udp(svsk->sk_sk, 0, 1, &err);
         |                                            ^
         |                                            |
         |                                            int
   In file included from net/sunrpc/svcsock.c:43:
   include/net/udp.h:256:49: note: expected 'int *' but argument is of type 'int'
     256 |                                            int *err)
         |                                            ~~~~~^~~
>> net/sunrpc/svcsock.c:467:15: error: too many arguments to function 'skb_recv_udp'
     467 |         skb = skb_recv_udp(svsk->sk_sk, 0, 1, &err);
         |               ^~~~~~~~~~~~
   In file included from net/sunrpc/svcsock.c:43:
   include/net/udp.h:255:31: note: declared here
     255 | static inline struct sk_buff *skb_recv_udp(struct sock *sk, unsigned int flags,
         |                               ^~~~~~~~~~~~


vim +/skb_recv_udp +1340 net/sunrpc/xprtsock.c

f9b2ee714c5c94 Trond Myklebust 2015-10-06  1328  
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1329  static void xs_udp_data_receive(struct sock_xprt *transport)
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1330  {
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1331  	struct sk_buff *skb;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1332  	struct sock *sk;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1333  	int err;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1334  
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1335  	mutex_lock(&transport->recv_mutex);
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1336  	sk = transport->inet;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1337  	if (sk == NULL)
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1338  		goto out;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1339  	for (;;) {
7c13f97ffde63c Paolo Abeni     2016-11-04 @1340  		skb = skb_recv_udp(sk, 0, 1, &err);
4f546149755b4d Trond Myklebust 2018-09-14  1341  		if (skb == NULL)
4f546149755b4d Trond Myklebust 2018-09-14  1342  			break;
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1343  		xs_udp_data_read_skb(&transport->xprt, sk, skb);
850cbaddb52dfd Paolo Abeni     2016-10-21  1344  		consume_skb(skb);
0af3442af7c4c5 Trond Myklebust 2018-01-14  1345  		cond_resched();
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1346  	}
0ffe86f48026b7 Trond Myklebust 2019-01-30  1347  	xs_poll_check_readable(transport);
a246b0105bbd9a Chuck Lever     2005-08-11  1348  out:
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1349  	mutex_unlock(&transport->recv_mutex);
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1350  }
f9b2ee714c5c94 Trond Myklebust 2015-10-06  1351  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
