Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280FB586067
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 20:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbiGaSq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 14:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGaSq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 14:46:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CB3DF6A
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659293216; x=1690829216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P7ggAeiAb9y5sYAV6qTrQf0HnKwfuziEcvjDdFbNBEo=;
  b=ABjTAMbSHQ7LawcNzI7Vubhkns2co379b9QTEv5uAWDl4g6IWvxtkF/X
   bx1X2BqXgF2Q5d7nYlJeUy01Ncq3HzQaS+eaNVq5+pEWWm+KObZruoxvg
   OSiwNr8zCdqmPlrMlObhxGZbwuOtqci2/KVoTaS9P0H3X+sOjEtv3A+38
   6EVPEbYlWzhUP5bU/B1StfUCHKwc/an85IQQuvFt7jWQFsmPLZudNPruK
   TZwN9AFS2Yv68ViGqzhvjLE56EYE10NcxdUaLXxhjgAObKGOHM7VtZTLX
   TyGVcx3VmsDv6S6K2luPNjHetHgoIRKpK4AoGPxIkwEm0oqHSjU26M32G
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10425"; a="353023237"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="353023237"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2022 11:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="552289350"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 31 Jul 2022 11:46:54 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIDxl-000EOh-1c;
        Sun, 31 Jul 2022 18:46:53 +0000
Date:   Mon, 1 Aug 2022 02:46:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, pabeni@redhat.com, edumazet@google.com,
        kuba@kernel.org, kafai@fb.com, davem@davemloft.net,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] net: Add a bhash2 table hashed by port +
 address
Message-ID: <202208010253.SjaFtOB8-lkp@intel.com>
References: <20220722195406.1304948-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722195406.1304948-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220723-035903
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 949d6b405e6160ae44baea39192d67b39cb7eeac
config: sh-randconfig-m041-20220722 (https://download.01.org/0day-ci/archive/20220801/202208010253.SjaFtOB8-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

smatch warnings:
include/net/inet_hashtables.h:265 inet_bhashfn_portaddr() warn: inconsistent indenting

vim +265 include/net/inet_hashtables.h

   253	
   254	static inline struct inet_bind_hashbucket *
   255	inet_bhashfn_portaddr(const struct inet_hashinfo *hinfo, const struct sock *sk,
   256			      const struct net *net, unsigned short port)
   257	{
   258		u32 hash;
   259	
   260	#if IS_ENABLED(CONFIG_IPV6)
   261		if (sk->sk_family == AF_INET6)
   262			hash = ipv6_portaddr_hash(net, &sk->sk_v6_rcv_saddr, port);
   263		else
   264	#endif
 > 265			hash = ipv4_portaddr_hash(net, sk->sk_rcv_saddr, port);
   266		return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
   267	}
   268	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
