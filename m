Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632B64FAFF4
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243866AbiDJUCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243873AbiDJUCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:02:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFAE10D9
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 13:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649620818; x=1681156818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VpGONjLoQy05ffmek7ePIocZDsZjZ5PIUBI0Db3WwRg=;
  b=CZMkgBLj87e24kWh6o8o3W9g6GtOpbkhq8RMmVWad2o4prSVpR7q3vWB
   pve7SJ8RMj2shwtzncGi4spUnZX4XUVrl9Rlr3pi8R6Gr2wABVCOAXqA+
   CBaVMZULLki5nNdSX2eECAaliNeXDzLKkHCPHwkSuIsHtboDOOZFJfW1b
   NXUBiFTn9042JPllyMLzsLR6QsYVijt/nSUfrt5J7v4+UebleiW+NtXJ2
   OKEtFpBuMswtv2xVL/7PaQAHkPqJEkfNGUFJfC5yesT8ZaH+g8qE2CmhH
   eZgXQ0BwPBZ9uvCWzKRIZpR2XzREZIashPoXp04Bi83EmhbS2lp4zVWWf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="322436953"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="322436953"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 13:00:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="622588966"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 10 Apr 2022 13:00:15 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nddjK-00014b-Tj;
        Sun, 10 Apr 2022 20:00:14 +0000
Date:   Mon, 11 Apr 2022 03:59:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH net-next] net: remove noblock parameter from recvmsg()
 entities
Message-ID: <202204110353.gjbLL7o1-lkp@intel.com>
References: <20220410185354.123004-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410185354.123004-1-socketcan@hartkopp.net>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Hartkopp/net-remove-noblock-parameter-from-recvmsg-entities/20220411-025612
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 516a2f1f6f3ce1a87931579cc21de6e7e33440bd
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220411/202204110353.gjbLL7o1-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/chelsio/inline_crypto/chtls/ net/dccp/ net/sctp/ net/tls/ net/xfrm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c: In function 'chtls_recvmsg':
>> drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c:1753:65: warning: passing argument 5 of 'tcp_prot.recvmsg' makes pointer from integer without a cast [-Wint-conversion]
    1753 |                 return tcp_prot.recvmsg(sk, msg, len, nonblock, flags,
         |                                                                 ^~~~~
         |                                                                 |
         |                                                                 int
   drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c:1753:65: note: expected 'int *' but argument is of type 'int'
   drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c:1753:24: error: too many arguments to function 'tcp_prot.recvmsg'
    1753 |                 return tcp_prot.recvmsg(sk, msg, len, nonblock, flags,
         |                        ^~~~~~~~


vim +1753 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c

b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1738  
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1739  int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1740  		  int nonblock, int flags, int *addr_len)
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1741  {
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1742  	struct tcp_sock *tp = tcp_sk(sk);
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1743  	struct chtls_sock *csk;
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1744  	unsigned long avail;    /* amount of available data in current skb */
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1745  	int buffers_freed;
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1746  	int copied = 0;
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1747  	long timeo;
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1748  	int target;             /* Read at least this many bytes */
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1749  
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1750  	buffers_freed = 0;
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1751  
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31  1752  	if (unlikely(flags & MSG_OOB))
b647993fca1460 drivers/crypto/chelsio/chtls/chtls_io.c Atul Gupta 2018-03-31 @1753  		return tcp_prot.recvmsg(sk, msg, len, nonblock, flags,

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
