Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7211749E6B5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbiA0PxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:53:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:17045 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbiA0PxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298785; x=1674834785;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JKTRESHUFHpq6uGWo92fYQDo2Mb2Rgr7dqFyjOwkEO4=;
  b=bxj2QTR2sOjtdvnpSC8xryUi6gRR7LOic4QU9bxLcg8OGzYbydlhRD3W
   43FiwzE6jEqhTrt903jD4Mkj590+ZdkMs9a1S37hctW0LBVDNrsOE2EYX
   7o9enxTDUj9r5NVh+ZX84DC/xvkLAeIB+H6Mcr/5aB/JY/XARnUFAiQ2h
   AQjTCkW4/G6oaWS6VvktdlxGUVZ3zTWannk88kqphMBovbSw5cGqcpDaJ
   kGxoPHIZpp0rlNJwF0fvEEJlqwKtw4ZrmthsbJA5O3V/UsouzWiK6CXAA
   oOtJ/9wd57aCZ2eZpmP2WID69IvMmfB656CrCEqczTm3RgK69O4WnXBGB
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246669262"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246669262"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:53:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="618373997"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jan 2022 07:53:01 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nD753-000Mk6-97; Thu, 27 Jan 2022 15:53:01 +0000
Date:   Thu, 27 Jan 2022 23:52:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/3] net/smc: Limits backlog connections
Message-ID: <202201272349.KA4IX9hr-lkp@intel.com>
References: <9b52fc3f11a2ae6f23224a178fd4cff9f9dd4eaa.1643284658.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b52fc3f11a2ae6f23224a178fd4cff9f9dd4eaa.1643284658.git.alibuda@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/D-Wythe/Optimizing-performance-in-short-lived/20220127-200912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git fbb8295248e1d6f576d444309fcf79356008eac1
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220127/202201272349.KA4IX9hr-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/718aff24f3fcc73ecb7bff17fcbe029b799c6624
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review D-Wythe/Optimizing-performance-in-short-lived/20220127-200912
        git checkout 718aff24f3fcc73ecb7bff17fcbe029b799c6624
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/smc/af_smc.c: In function 'smc_listen':
>> net/smc/af_smc.c:2202:25: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2202 |         smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
         |                         ^


vim +/const +2202 net/smc/af_smc.c

  2166	
  2167	static int smc_listen(struct socket *sock, int backlog)
  2168	{
  2169		struct sock *sk = sock->sk;
  2170		struct smc_sock *smc;
  2171		int rc;
  2172	
  2173		smc = smc_sk(sk);
  2174		lock_sock(sk);
  2175	
  2176		rc = -EINVAL;
  2177		if ((sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) ||
  2178		    smc->connect_nonblock)
  2179			goto out;
  2180	
  2181		rc = 0;
  2182		if (sk->sk_state == SMC_LISTEN) {
  2183			sk->sk_max_ack_backlog = backlog;
  2184			goto out;
  2185		}
  2186		/* some socket options are handled in core, so we could not apply
  2187		 * them to the clc socket -- copy smc socket options to clc socket
  2188		 */
  2189		smc_copy_sock_settings_to_clc(smc);
  2190		if (!smc->use_fallback)
  2191			tcp_sk(smc->clcsock->sk)->syn_smc = 1;
  2192	
  2193		/* save original sk_data_ready function and establish
  2194		 * smc-specific sk_data_ready function
  2195		 */
  2196		smc->clcsk_data_ready = smc->clcsock->sk->sk_data_ready;
  2197		smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
  2198		smc->clcsock->sk->sk_user_data =
  2199			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
  2200	
  2201		/* save origin ops */
> 2202		smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
  2203	
  2204		smc->af_ops = *smc->ori_af_ops;
  2205		smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
  2206	
  2207		inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
  2208	
  2209		rc = kernel_listen(smc->clcsock, backlog);
  2210		if (rc) {
  2211			smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
  2212			goto out;
  2213		}
  2214		sk->sk_max_ack_backlog = backlog;
  2215		sk->sk_ack_backlog = 0;
  2216		sk->sk_state = SMC_LISTEN;
  2217	
  2218	out:
  2219		release_sock(sk);
  2220		return rc;
  2221	}
  2222	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
