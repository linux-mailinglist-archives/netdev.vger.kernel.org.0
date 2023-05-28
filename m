Return-Path: <netdev+bounces-5970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759D3713B75
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 20:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D577D280E56
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9255694;
	Sun, 28 May 2023 18:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41C05692
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:06:21 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A8A3;
	Sun, 28 May 2023 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685297179; x=1716833179;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n1G3073duu9zebJvOfP4bDW93rS2yyqVqrYzBTqEQVI=;
  b=c8o37eg7aQNu+Uhv5Hx20n7/+23YNNaP3nbde+cTV+Bg165GWJeV2/AJ
   YKIsZvy5wCu8aEAeSszvoQYM9cYA+xbgYkNKXU4Nb4JHYw8ylwZV9Mz6N
   pKBKIVykgX1UAAmJmg+ps11vTl8DXeZaabf9JDN0a4ea6ubfSjCMT6obx
   FxBY7GdBsIFcJ7ukrAjgxnKrw5r3/UWZbhWCeY9+dlYGNZnJy4g5Pwg8r
   i+0G6gB1U+en+WMCKkOb7OTQvTkeRcIXrYjU/npyV4jFIXRWqGj/ISd0d
   N4m9ZWcq6wfhJ1HHzh4mbpThazUyoaV8m7VtdN6Odp8kqc18eqrdWmAqE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="420302749"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="420302749"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 11:06:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="738897686"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="738897686"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2023 11:06:13 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q3KmS-000KhW-1C;
	Sun, 28 May 2023 18:06:12 +0000
Date: Mon, 29 May 2023 02:05:23 +0800
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>, dsahern@kernel.org,
	willemdebruijn.kernel@gmail.com,
	Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, leit@fb.com, axboe@kernel.dk,
	asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <202305290107.hs8sbfYc-lkp@intel.com>
References: <20230525125503.400797-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525125503.400797-1-leitao@debian.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Breno,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Breno-Leitao/net-ioctl-Use-kernel-memory-on-protocol-ioctl-callbacks/20230525-205741
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230525125503.400797-1-leitao%40debian.org
patch subject: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol ioctl callbacks
config: i386-randconfig-i061-20230525 (https://download.01.org/0day-ci/archive/20230529/202305290107.hs8sbfYc-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/dbeb44f8503d11da0219fc6ef8a56c28cfde1511
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Breno-Leitao/net-ioctl-Use-kernel-memory-on-protocol-ioctl-callbacks/20230525-205741
        git checkout dbeb44f8503d11da0219fc6ef8a56c28cfde1511
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/phonet/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305290107.hs8sbfYc-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/phonet/af_phonet.c:43:5: error: redefinition of 'phonet_sk_ioctl'
   int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
       ^
   include/net/phonet/phonet.h:125:19: note: previous definition is here
   static inline int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
                     ^
   1 error generated.


vim +/phonet_sk_ioctl +43 net/phonet/af_phonet.c

    42	
  > 43	int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
    44	{
    45		int karg;
    46	
    47		switch (cmd) {
    48		case SIOCPNADDRESOURCE:
    49		case SIOCPNDELRESOURCE:
    50			if (get_user(karg, (int __user *)arg))
    51				return -EFAULT;
    52	
    53			return sk->sk_prot->ioctl(sk, cmd, &karg);
    54		}
    55		/* A positive return value means that the ioctl was not processed */
    56		return 1;
    57	}
    58	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

