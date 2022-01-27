Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6EA49EECF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbiA0XYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:24:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:21970 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234804AbiA0XYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 18:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643325873; x=1674861873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R4aUtkmA+9GfZrFOvme9j8OBwfAKZDoxsNcZRrM1jHM=;
  b=fK+1LJ36HqqNWufqcQTTiHmuV5k5EHFeaZuBNSZW9oJh11oJc6hpgOJt
   8+YvVz+Xk1RDzPqqsXy6N8PYO8wbLViTd4jJmqAkfjHzNzPFjhHaHCCBj
   YVwYKQowh51FwofEjB0bw1UfOHXlKOEYCtjYOANK0GYxVvso4/xCL7EUE
   yfRTjERJ6MZN+d8IxlIv9MEIk/nMSaVYAMDbCSX32UKFiGvyNkcqHrjkg
   +ViFeOxL+X4bxfVIz7r3Okx6hOnZqZHRix7qwSC9i4lDJNp4gOJ+wzCoW
   iUvH+9FDQv9wM/9yJOcr2846yYIMTWtt5DtnNo8c+Ao1iYZyfP8NyG8+o
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="227664893"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="227664893"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:24:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="618516978"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jan 2022 15:24:31 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDE7y-000N9o-Ga; Thu, 27 Jan 2022 23:24:30 +0000
Date:   Fri, 28 Jan 2022 07:23:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/3] net/smc: Limits backlog connections
Message-ID: <202201280741.2EsIf9Jy-lkp@intel.com>
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
config: x86_64-randconfig-s022-20220124 (https://download.01.org/0day-ci/archive/20220128/202201280741.2EsIf9Jy-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/718aff24f3fcc73ecb7bff17fcbe029b799c6624
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review D-Wythe/Optimizing-performance-in-short-lived/20220127-200912
        git checkout 718aff24f3fcc73ecb7bff17fcbe029b799c6624
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/smc/af_smc.c:2202:25: sparse: sparse: incorrect type in assignment (different modifiers) @@     expected struct inet_connection_sock_af_ops *ori_af_ops @@     got struct inet_connection_sock_af_ops const *icsk_af_ops @@
   net/smc/af_smc.c:2202:25: sparse:     expected struct inet_connection_sock_af_ops *ori_af_ops
   net/smc/af_smc.c:2202:25: sparse:     got struct inet_connection_sock_af_ops const *icsk_af_ops

vim +2202 net/smc/af_smc.c

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
