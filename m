Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB56512936
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241056AbiD1CDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241039AbiD1CDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:03:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749C95F676;
        Wed, 27 Apr 2022 19:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651111229; x=1682647229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cb4/X1eXZxU6ysYO3MZ6/p8QIYf2WmnoKf8/fH1JDYE=;
  b=K9NeG10FZF4/HH3+Qyz7ISmBylBzHBYmK46dshGDZVR4oPm8s0ip+it/
   tqGC22gfdX/U4oI3gxwc2xd5Gq5pOmhwj7JjLMWhLA/GOn8JT9uwdvFW/
   hiP/3gvgFlq+GTH7S12ja/IK9Nly5Tngm98jWT7e3s5ayIAy16uKGaGKx
   dtMAYN7Fk7hIGK/c6v45Ia7YkCbYpjXIfWG6WLyjrfET+9go0JSewgdPS
   I3bjDY+U5cl7oZdrUjdIFsGuUZvlQmhtRI71vHkDJFg4qBj2DaIQQ0GcK
   7u0LbMUih+s97fwDTrx7tCGYUUfjApU99choXz+ywxdWqc8aB5Y9lyAGS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="291287367"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="291287367"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 19:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="559349499"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2022 19:00:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njtSB-0004xt-N0;
        Thu, 28 Apr 2022 02:00:23 +0000
Date:   Thu, 28 Apr 2022 09:59:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Message-ID: <202204280348.UBtfnU6Q-lkp@intel.com>
References: <20220427065233.2075-2-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427065233.2075-2-w@1wt.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 71cffebf6358a7f5031f5b208bbdc1cb4db6e539
config: i386-randconfig-a011-20220425 (https://download.01.org/0day-ci/archive/20220428/202204280348.UBtfnU6Q-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/01b26e522b598adf346b809075880feab3dcdc08
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
        git checkout 01b26e522b598adf346b809075880feab3dcdc08
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/ipv4/inet_hashtables.o: in function `__inet_hash_connect':
>> net/ipv4/inet_hashtables.c:780: undefined reference to `__umoddi3'


vim +780 net/ipv4/inet_hashtables.c

190cc82489f46f Eric Dumazet             2021-02-09  735  
5ee31fc1ecdcbc Pavel Emelyanov          2008-01-31  736  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
01b26e522b598a Willy Tarreau            2022-04-27  737  		struct sock *sk, u64 port_offset,
5ee31fc1ecdcbc Pavel Emelyanov          2008-01-31  738  		int (*check_established)(struct inet_timewait_death_row *,
b4d6444ea3b50b Eric Dumazet             2015-03-18  739  			struct sock *, __u16, struct inet_timewait_sock **))
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  740  {
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  741  	struct inet_hashinfo *hinfo = death_row->hashinfo;
1580ab63fc9a03 Eric Dumazet             2016-02-11  742  	struct inet_timewait_sock *tw = NULL;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  743  	struct inet_bind_hashbucket *head;
1580ab63fc9a03 Eric Dumazet             2016-02-11  744  	int port = inet_sk(sk)->inet_num;
3b1e0a655f8eba YOSHIFUJI Hideaki        2008-03-26  745  	struct net *net = sock_net(sk);
1580ab63fc9a03 Eric Dumazet             2016-02-11  746  	struct inet_bind_bucket *tb;
1580ab63fc9a03 Eric Dumazet             2016-02-11  747  	u32 remaining, offset;
1580ab63fc9a03 Eric Dumazet             2016-02-11  748  	int ret, i, low, high;
3c82a21f4320c8 Robert Shearman          2018-11-07  749  	int l3mdev;
190cc82489f46f Eric Dumazet             2021-02-09  750  	u32 index;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  751  
1580ab63fc9a03 Eric Dumazet             2016-02-11  752  	if (port) {
1580ab63fc9a03 Eric Dumazet             2016-02-11  753  		head = &hinfo->bhash[inet_bhashfn(net, port,
1580ab63fc9a03 Eric Dumazet             2016-02-11  754  						  hinfo->bhash_size)];
1580ab63fc9a03 Eric Dumazet             2016-02-11  755  		tb = inet_csk(sk)->icsk_bind_hash;
1580ab63fc9a03 Eric Dumazet             2016-02-11  756  		spin_lock_bh(&head->lock);
1580ab63fc9a03 Eric Dumazet             2016-02-11  757  		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
01770a16616573 Ricardo Dias             2020-11-20  758  			inet_ehash_nolisten(sk, NULL, NULL);
1580ab63fc9a03 Eric Dumazet             2016-02-11  759  			spin_unlock_bh(&head->lock);
1580ab63fc9a03 Eric Dumazet             2016-02-11  760  			return 0;
1580ab63fc9a03 Eric Dumazet             2016-02-11  761  		}
1580ab63fc9a03 Eric Dumazet             2016-02-11  762  		spin_unlock(&head->lock);
1580ab63fc9a03 Eric Dumazet             2016-02-11  763  		/* No definite answer... Walk to established hash table */
1580ab63fc9a03 Eric Dumazet             2016-02-11  764  		ret = check_established(death_row, sk, port, NULL);
1580ab63fc9a03 Eric Dumazet             2016-02-11  765  		local_bh_enable();
1580ab63fc9a03 Eric Dumazet             2016-02-11  766  		return ret;
1580ab63fc9a03 Eric Dumazet             2016-02-11  767  	}
227b60f5102cda Stephen Hemminger        2007-10-10  768  
3c82a21f4320c8 Robert Shearman          2018-11-07  769  	l3mdev = inet_sk_bound_l3mdev(sk);
3c82a21f4320c8 Robert Shearman          2018-11-07  770  
1580ab63fc9a03 Eric Dumazet             2016-02-11  771  	inet_get_local_port_range(net, &low, &high);
1580ab63fc9a03 Eric Dumazet             2016-02-11  772  	high++; /* [32768, 60999] -> [32768, 61000[ */
1580ab63fc9a03 Eric Dumazet             2016-02-11  773  	remaining = high - low;
1580ab63fc9a03 Eric Dumazet             2016-02-11  774  	if (likely(remaining > 1))
1580ab63fc9a03 Eric Dumazet             2016-02-11  775  		remaining &= ~1U;
1580ab63fc9a03 Eric Dumazet             2016-02-11  776  
190cc82489f46f Eric Dumazet             2021-02-09  777  	net_get_random_once(table_perturb, sizeof(table_perturb));
190cc82489f46f Eric Dumazet             2021-02-09  778  	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
190cc82489f46f Eric Dumazet             2021-02-09  779  
190cc82489f46f Eric Dumazet             2021-02-09 @780  	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
1580ab63fc9a03 Eric Dumazet             2016-02-11  781  	/* In first pass we try ports of @low parity.
1580ab63fc9a03 Eric Dumazet             2016-02-11  782  	 * inet_csk_get_port() does the opposite choice.
07f4c90062f8fc Eric Dumazet             2015-05-24  783  	 */
1580ab63fc9a03 Eric Dumazet             2016-02-11  784  	offset &= ~1U;
1580ab63fc9a03 Eric Dumazet             2016-02-11  785  other_parity_scan:
1580ab63fc9a03 Eric Dumazet             2016-02-11  786  	port = low + offset;
1580ab63fc9a03 Eric Dumazet             2016-02-11  787  	for (i = 0; i < remaining; i += 2, port += 2) {
1580ab63fc9a03 Eric Dumazet             2016-02-11  788  		if (unlikely(port >= high))
1580ab63fc9a03 Eric Dumazet             2016-02-11  789  			port -= remaining;
122ff243f5f104 WANG Cong                2014-05-12  790  		if (inet_is_local_reserved_port(net, port))
e3826f1e946e7d Amerigo Wang             2010-05-05  791  			continue;
7f635ab71eef8d Pavel Emelyanov          2008-06-16  792  		head = &hinfo->bhash[inet_bhashfn(net, port,
7f635ab71eef8d Pavel Emelyanov          2008-06-16  793  						  hinfo->bhash_size)];
1580ab63fc9a03 Eric Dumazet             2016-02-11  794  		spin_lock_bh(&head->lock);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  795  
1580ab63fc9a03 Eric Dumazet             2016-02-11  796  		/* Does not bother with rcv_saddr checks, because
1580ab63fc9a03 Eric Dumazet             2016-02-11  797  		 * the established check is already unique enough.
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  798  		 */
b67bfe0d42cac5 Sasha Levin              2013-02-27  799  		inet_bind_bucket_for_each(tb, &head->chain) {
3c82a21f4320c8 Robert Shearman          2018-11-07  800  			if (net_eq(ib_net(tb), net) && tb->l3mdev == l3mdev &&
3c82a21f4320c8 Robert Shearman          2018-11-07  801  			    tb->port == port) {
da5e36308d9f71 Tom Herbert              2013-01-22  802  				if (tb->fastreuse >= 0 ||
da5e36308d9f71 Tom Herbert              2013-01-22  803  				    tb->fastreuseport >= 0)
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  804  					goto next_port;
a9d8f9110d7e95 Evgeniy Polyakov         2009-01-19  805  				WARN_ON(hlist_empty(&tb->owners));
5ee31fc1ecdcbc Pavel Emelyanov          2008-01-31  806  				if (!check_established(death_row, sk,
5ee31fc1ecdcbc Pavel Emelyanov          2008-01-31  807  						       port, &tw))
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  808  					goto ok;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  809  				goto next_port;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  810  			}
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  811  		}
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  812  
941b1d22cc035a Pavel Emelyanov          2008-01-31  813  		tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep,
3c82a21f4320c8 Robert Shearman          2018-11-07  814  					     net, head, port, l3mdev);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  815  		if (!tb) {
1580ab63fc9a03 Eric Dumazet             2016-02-11  816  			spin_unlock_bh(&head->lock);
1580ab63fc9a03 Eric Dumazet             2016-02-11  817  			return -ENOMEM;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  818  		}
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  819  		tb->fastreuse = -1;
da5e36308d9f71 Tom Herbert              2013-01-22  820  		tb->fastreuseport = -1;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  821  		goto ok;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  822  next_port:
1580ab63fc9a03 Eric Dumazet             2016-02-11  823  		spin_unlock_bh(&head->lock);
1580ab63fc9a03 Eric Dumazet             2016-02-11  824  		cond_resched();
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  825  	}
1580ab63fc9a03 Eric Dumazet             2016-02-11  826  
1580ab63fc9a03 Eric Dumazet             2016-02-11  827  	offset++;
1580ab63fc9a03 Eric Dumazet             2016-02-11  828  	if ((offset & 1) && remaining > 1)
1580ab63fc9a03 Eric Dumazet             2016-02-11  829  		goto other_parity_scan;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  830  
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  831  	return -EADDRNOTAVAIL;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  832  
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  833  ok:
c579bd1b4021c4 Eric Dumazet             2021-02-09  834  	/* If our first attempt found a candidate, skip next candidate
c579bd1b4021c4 Eric Dumazet             2021-02-09  835  	 * in 1/16 of cases to add some noise.
c579bd1b4021c4 Eric Dumazet             2021-02-09  836  	 */
c579bd1b4021c4 Eric Dumazet             2021-02-09  837  	if (!i && !(prandom_u32() % 16))
c579bd1b4021c4 Eric Dumazet             2021-02-09  838  		i = 2;
190cc82489f46f Eric Dumazet             2021-02-09  839  	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  840  
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  841  	/* Head lock still held and bh's disabled */
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  842  	inet_bind_hash(sk, tb, port);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  843  	if (sk_unhashed(sk)) {
c720c7e8383aff Eric Dumazet             2009-10-15  844  		inet_sk(sk)->inet_sport = htons(port);
01770a16616573 Ricardo Dias             2020-11-20  845  		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  846  	}
3cdaedae635b17 Eric Dumazet             2009-12-04  847  	if (tw)
fc01538f9fb755 Eric Dumazet             2015-07-08  848  		inet_twsk_bind_unhash(tw, hinfo);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  849  	spin_unlock(&head->lock);
dbe7faa4045ea8 Eric Dumazet             2015-07-08  850  	if (tw)
dbe7faa4045ea8 Eric Dumazet             2015-07-08  851  		inet_twsk_deschedule_put(tw);
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  852  	local_bh_enable();
1580ab63fc9a03 Eric Dumazet             2016-02-11  853  	return 0;
a7f5e7f164788a Arnaldo Carvalho de Melo 2005-12-13  854  }
5ee31fc1ecdcbc Pavel Emelyanov          2008-01-31  855  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
