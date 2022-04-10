Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DEE4FB0C7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiDJXQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 19:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiDJXQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 19:16:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43DE3A5C8
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 16:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649632481; x=1681168481;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=psxz37D1DPooiSbTmqf6pZhcelOEdA1uQoa8dl19olo=;
  b=AmcCRpIUuHbuDk2cgPy9Huskq6fG1aqZCtG9Y7kGwBWsqQ5wkORzTHom
   A8wXTfHmq17Q1eUfETs1ISAKrcEFJ4XHcH3ddYWVHH+wRo9XcYaADQU2y
   4SyXYIQvZrW9Sm6JQfqbU1SnogBtN27RS8kP20s7M6NDRfp9ZP0/UKlux
   5S9Ku6qn2hW3QuX/aUgyt8irF+CW3Tz7BlH3dBqQrhEm/YEiRFydqY2GD
   kT7xq1vrzeiWWhs142YDmbgud4+oI3HRAiFYyOvjerp5gne4d7bPQDBk9
   ZJ+gQuRuCWt/1nhcWYK8zo45Bg7XAPA3NQx9d7388C71X3Th34WvbiKuE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="324913868"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="324913868"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 16:14:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="659820396"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 10 Apr 2022 16:14:39 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ndglS-0001B1-EJ;
        Sun, 10 Apr 2022 23:14:38 +0000
Date:   Mon, 11 Apr 2022 07:13:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH net-next v2] net: remove noblock parameter from recvmsg()
 entities
Message-ID: <202204110751.725yvW2W-lkp@intel.com>
References: <20220410200635.174327-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410200635.174327-1-socketcan@hartkopp.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Hartkopp/net-remove-noblock-parameter-from-recvmsg-entities/20220411-040924
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 516a2f1f6f3ce1a87931579cc21de6e7e33440bd
config: x86_64-randconfig-a004-20220411 (https://download.01.org/0day-ci/archive/20220411/202204110751.725yvW2W-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 256c6b0ba14e8a7ab6373b61b7193ea8c0a3651c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/8c4751aaa17d68be940bdaf4bb1402d1a34a60e7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oliver-Hartkopp/net-remove-noblock-parameter-from-recvmsg-entities/20220411-040924
        git checkout 8c4751aaa17d68be940bdaf4bb1402d1a34a60e7
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/dccp/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/dccp/ipv4.c:959:14: error: incompatible function pointer types initializing 'int (*)(struct sock *, struct msghdr *, size_t, int, int *)' (aka 'int (*)(struct sock *, struct msghdr *, unsigned long, int, int *)') with an expression of type 'int (struct sock *, struct msghdr *, size_t, int, int, int *)' (aka 'int (struct sock *, struct msghdr *, unsigned long, int, int, int *)') [-Werror,-Wincompatible-function-pointer-types]
           .recvmsg                = dccp_recvmsg,
                                     ^~~~~~~~~~~~
   1 error generated.
--
>> net/dccp/ipv6.c:1044:16: error: incompatible function pointer types initializing 'int (*)(struct sock *, struct msghdr *, size_t, int, int *)' (aka 'int (*)(struct sock *, struct msghdr *, unsigned long, int, int *)') with an expression of type 'int (struct sock *, struct msghdr *, size_t, int, int, int *)' (aka 'int (struct sock *, struct msghdr *, unsigned long, int, int, int *)') [-Werror,-Wincompatible-function-pointer-types]
           .recvmsg           = dccp_recvmsg,
                                ^~~~~~~~~~~~
   1 error generated.


vim +959 net/dccp/ipv4.c

6d6ee43e0b8b8d Arnaldo Carvalho de Melo 2005-12-13  947  
5e0817f84c3328 Adrian Bunk              2006-03-20  948  static struct proto dccp_v4_prot = {
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  949  	.name			= "DCCP",
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  950  	.owner			= THIS_MODULE,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  951  	.close			= dccp_close,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  952  	.connect		= dccp_v4_connect,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  953  	.disconnect		= dccp_disconnect,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  954  	.ioctl			= dccp_ioctl,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  955  	.init			= dccp_v4_init_sock,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  956  	.setsockopt		= dccp_setsockopt,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  957  	.getsockopt		= dccp_getsockopt,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  958  	.sendmsg		= dccp_sendmsg,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09 @959  	.recvmsg		= dccp_recvmsg,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  960  	.backlog_rcv		= dccp_v4_do_rcv,
ab1e0a13d70299 Arnaldo Carvalho de Melo 2008-02-03  961  	.hash			= inet_hash,
ab1e0a13d70299 Arnaldo Carvalho de Melo 2008-02-03  962  	.unhash			= inet_unhash,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  963  	.accept			= inet_csk_accept,
ab1e0a13d70299 Arnaldo Carvalho de Melo 2008-02-03  964  	.get_port		= inet_csk_get_port,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  965  	.shutdown		= dccp_shutdown,
3e0fadc51f2fde Arnaldo Carvalho de Melo 2006-03-20  966  	.destroy		= dccp_destroy_sock,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  967  	.orphan_count		= &dccp_orphan_count,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  968  	.max_header		= MAX_DCCP_HEADER,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  969  	.obj_size		= sizeof(struct dccp_sock),
5f0d5a3ae7cff0 Paul E. McKenney         2017-01-18  970  	.slab_flags		= SLAB_TYPESAFE_BY_RCU,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  971  	.rsk_prot		= &dccp_request_sock_ops,
6d6ee43e0b8b8d Arnaldo Carvalho de Melo 2005-12-13  972  	.twsk_prot		= &dccp_timewait_sock_ops,
39d8cda76cfb11 Pavel Emelyanov          2008-03-22  973  	.h.hashinfo		= &dccp_hashinfo,
7c657876b63cb1 Arnaldo Carvalho de Melo 2005-08-09  974  };
6d6ee43e0b8b8d Arnaldo Carvalho de Melo 2005-12-13  975  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
