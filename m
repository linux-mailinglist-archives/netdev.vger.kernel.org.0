Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180BE57504F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiGNOGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiGNOGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:06:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872672648
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657807591; x=1689343591;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vYuxqx+TZP+6i2p1+NDjEr+/9wlVQCuAMsrd9ayHd3o=;
  b=h43P2XMEwD72gPC8+8WEb1JK/+fheNrZ+eaonekhbTPjP/OY6vwcRbIA
   kwd9YB10EfT9NsDW0upYV+I8gteVaJwScV67smaJ69wLGp+KlTTdJ2D/H
   YbfHUAjYNOf6K+wfWugiFGtdh1QNPPtB3pHyEHUZYRjoNb4jcQ/BsKeu+
   WRFKcWRYV68584ke4m464Qc2HvKrjyJB9qTB7bguU25N2Iq/QyjrX8nxz
   BblI2fJubAJ/i4/eCNuSPdAt871rTP1WKz/N5wBfH6WWzcadqenWDcc+t
   UcI5yypr6smaxockD5JY3kCTaruE1FHVU9y8VRTtLjvUqubif+T0QPqbn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="285542075"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="285542075"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 07:06:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="738284178"
Received: from lkp-server01.sh.intel.com (HELO fd2c14d642b4) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2022 07:06:20 -0700
Received: from kbuild by fd2c14d642b4 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oBzTw-0000j1-9z;
        Thu, 14 Jul 2022 14:06:20 +0000
Date:   Thu, 14 Jul 2022 22:05:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, edumazet@google.com, kafai@fb.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: Add a bhash2 table hashed by port +
 address
Message-ID: <202207142124.OHu1H8Us-lkp@intel.com>
References: <20220712235310.1935121-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712235310.1935121-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220713-075808
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5022e221c98a609e0e5b0a73852c7e3d32f1c545
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220714/202207142124.OHu1H8Us-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2e20fc25bca52fbc786bbae312df56514c10798d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220713-075808
        git checkout 2e20fc25bca52fbc786bbae312df56514c10798d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv4/inet_hashtables.c: In function 'inet_bhash2_update_saddr':
>> net/ipv4/inet_hashtables.c:853:38: warning: variable 'head' set but not used [-Wunused-but-set-variable]
     853 |         struct inet_bind_hashbucket *head, *head2;
         |                                      ^~~~


vim +/head +853 net/ipv4/inet_hashtables.c

   849	
   850	int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
   851	{
   852		struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
 > 853		struct inet_bind_hashbucket *head, *head2;
   854		struct inet_bind2_bucket *tb2, *new_tb2;
   855		int l3mdev = inet_sk_bound_l3mdev(sk);
   856		int port = inet_sk(sk)->inet_num;
   857		struct net *net = sock_net(sk);
   858	
   859		/* Allocate a bind2 bucket ahead of time to avoid permanently putting
   860		 * the bhash2 table in an inconsistent state if a new tb2 bucket
   861		 * allocation fails.
   862		 */
   863		new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
   864		if (!new_tb2)
   865			return -ENOMEM;
   866	
   867		head = &hinfo->bhash[inet_bhashfn(net, port,
   868						  hinfo->bhash_size)];
   869		head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
   870	
   871		spin_lock_bh(&prev_saddr->lock);
   872		__sk_del_bind2_node(sk);
   873		inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
   874					  inet_csk(sk)->icsk_bind2_hash);
   875		spin_unlock_bh(&prev_saddr->lock);
   876	
   877		spin_lock_bh(&head2->lock);
   878		tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
   879		if (!tb2) {
   880			tb2 = new_tb2;
   881			inet_bind2_bucket_init(tb2, net, head2, port, l3mdev, sk);
   882		}
   883		sk_add_bind2_node(sk, &tb2->owners);
   884		inet_csk(sk)->icsk_bind2_hash = tb2;
   885		spin_unlock_bh(&head2->lock);
   886	
   887		if (tb2 != new_tb2)
   888			kmem_cache_free(hinfo->bind2_bucket_cachep, new_tb2);
   889	
   890		return 0;
   891	}
   892	EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
   893	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
