Return-Path: <netdev+bounces-10956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDA2730C8B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B95631C20E00
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CA238B;
	Thu, 15 Jun 2023 01:24:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E0379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:24:13 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6A212D;
	Wed, 14 Jun 2023 18:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686792252; x=1718328252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ojIx/BgoPnAG/VR6HR7v1/Oou2aRENR+NAqwetBhTFY=;
  b=BnwzD443j9Y3ALBhmtJ8A5k69AcxeL1R9y9d+k1nnv7LKdWqsbyWGoX4
   xAyN2G/rfKtZUQOvzVNfqbvP1phZTmu+9yYruSMSJRDiznwhIYDPDTuL/
   IAZXSGBvonwYVz2FpPlrvEw7ZzlWI2xKNmMasCjhhWhhS27IoJ9SgmiTb
   rnO48pOETzqmrc8QI9Sae9XgzUxOOPJX0LN3cLJzcfzb2R2jJuI/1FHOC
   jylLMA1DgGHBJ1ML3LUxTPydRixD0i5y0itquBaq9OSbclggcdGTeQWrk
   zbRAd6LMY5jLC6Lr70txWLA64j7lAGCIc/mnKGUtp17zgxhDjDAh0fUNW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="445149393"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="445149393"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 18:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="745291067"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="745291067"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 18:24:06 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9biX-0001Fx-18;
	Thu, 15 Jun 2023 01:24:05 +0000
Date: Thu, 15 Jun 2023 09:22:57 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v7 08/22] net/tcp: Add AO sign to RST packets
Message-ID: <202306150911.gIaFpxg9-lkp@intel.com>
References: <20230614230947.3954084-9-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614230947.3954084-9-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on b6dad5178ceaf23f369c3711062ce1f2afc33644]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230615-071334
base:   b6dad5178ceaf23f369c3711062ce1f2afc33644
patch link:    https://lore.kernel.org/r/20230614230947.3954084-9-dima%40arista.com
patch subject: [PATCH v7 08/22] net/tcp: Add AO sign to RST packets
config: i386-randconfig-r021-20230612 (https://download.01.org/0day-ci/archive/20230615/202306150911.gIaFpxg9-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git checkout b6dad5178ceaf23f369c3711062ce1f2afc33644
        b4 shazam https://lore.kernel.org/r/20230614230947.3954084-9-dima@arista.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv6/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306150911.gIaFpxg9-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv6/tcp_ipv6.c: In function 'tcp_v6_send_reset':
>> net/ipv6/tcp_ipv6.c:1136:1: warning: label 'out' defined but not used [-Wunused-label]
    1136 | out:
         | ^~~


vim +/out +1136 net/ipv6/tcp_ipv6.c

2045a93527d963 Dmitry Safonov           2023-06-15  1110  
c24b14c46bb88d Song Liu                 2017-10-23  1111  	if (sk) {
c24b14c46bb88d Song Liu                 2017-10-23  1112  		oif = sk->sk_bound_dev_if;
052e0690f1f62f Eric Dumazet             2019-07-10  1113  		if (sk_fullsock(sk)) {
052e0690f1f62f Eric Dumazet             2019-07-10  1114  			const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
052e0690f1f62f Eric Dumazet             2019-07-10  1115  
c24b14c46bb88d Song Liu                 2017-10-23  1116  			trace_tcp_send_reset(sk, skb);
052e0690f1f62f Eric Dumazet             2019-07-10  1117  			if (np->repflow)
052e0690f1f62f Eric Dumazet             2019-07-10  1118  				label = ip6_flowlabel(ipv6h);
e9a5dceee56cb5 Eric Dumazet             2019-09-24  1119  			priority = sk->sk_priority;
dc6456e938e938 Antoine Tenart           2023-04-27  1120  			txhash = sk->sk_txhash;
052e0690f1f62f Eric Dumazet             2019-07-10  1121  		}
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1122  		if (sk->sk_state == TCP_TIME_WAIT) {
50a8accf10627b Eric Dumazet             2019-06-05  1123  			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1124  			priority = inet_twsk(sk)->tw_priority;
9258b8b1be2e1e Eric Dumazet             2022-09-22  1125  			txhash = inet_twsk(sk)->tw_txhash;
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1126  		}
323a53c41292a0 Eric Dumazet             2019-06-05  1127  	} else {
a346abe051bd2b Eric Dumazet             2019-07-01  1128  		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
323a53c41292a0 Eric Dumazet             2019-06-05  1129  			label = ip6_flowlabel(ipv6h);
c24b14c46bb88d Song Liu                 2017-10-23  1130  	}
c24b14c46bb88d Song Liu                 2017-10-23  1131  
e92dd77e6fe0a3 Wei Wang                 2020-09-08  1132  	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
2045a93527d963 Dmitry Safonov           2023-06-15  1133  			     ipv6_get_dsfield(ipv6h), label, priority, txhash,
2045a93527d963 Dmitry Safonov           2023-06-15  1134  			     ao_key, traffic_key, rcv_next, ao_sne);
658ddaaf6694ad Shawn Lu                 2012-01-31  1135  
3b24d854cb3538 Eric Dumazet             2016-04-01 @1136  out:
658ddaaf6694ad Shawn Lu                 2012-01-31  1137  	rcu_read_unlock();
ecc51b6d5ca04b Arnaldo Carvalho de Melo 2005-12-12  1138  }
^1da177e4c3f41 Linus Torvalds           2005-04-16  1139  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

