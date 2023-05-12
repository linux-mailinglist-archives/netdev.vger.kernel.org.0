Return-Path: <netdev+bounces-2316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C657F70124D
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 01:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAE691C212DD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807EB2261B;
	Fri, 12 May 2023 23:03:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D322609
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 23:03:07 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920961FC8;
	Fri, 12 May 2023 16:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683932585; x=1715468585;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FomQx5g+caJEuw8Rc81IGxLvjLOMBltYdVeWZa89Wjs=;
  b=hYypEaIX/H/bSTiyzWxeIXoV+bUq+A+6mGnUpAOdp+8PMcL9Q7tSDzcP
   YLHIVtYx2Bm1ji/7U5zMv5DQToPJqJ59PAeLjeWLr/UeNAxHd8njS1aBi
   qLMjiDgr4yRkkoeV9OvAarOAxH1R4b3Prp4Cejk/9kIsH013BJx2kxJui
   Aq6kd94FJ5lxHcICwhf7d2c6KIZRWO22rcG0CTVvUi2PfnLsQasLWi4LQ
   DiJ77qekgQtwA/WmZDYA0H0PNxBq9cvJNgH7km6ilzSeNjWfftHfU5MSW
   KOSe5DqBB3ATtkmRLiQasjDDCJ/CsZnZkiRNK3w+6+iG7xvLGuyKNoUFY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="340227013"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="340227013"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 16:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="650791514"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="650791514"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 12 May 2023 16:02:58 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxbms-0005A8-0W;
	Fri, 12 May 2023 23:02:58 +0000
Date: Sat, 13 May 2023 07:02:34 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v6 07/21] net/tcp: Add tcp_parse_auth_options()
Message-ID: <202305130600.uZymcUzw-lkp@intel.com>
References: <20230512202311.2845526-8-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512202311.2845526-8-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 47a2ee5d4a0bda05decdda7be0a77e792cdb09a3]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230513-042734
base:   47a2ee5d4a0bda05decdda7be0a77e792cdb09a3
patch link:    https://lore.kernel.org/r/20230512202311.2845526-8-dima%40arista.com
patch subject: [PATCH v6 07/21] net/tcp: Add tcp_parse_auth_options()
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230513/202305130600.uZymcUzw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/16d692b101c65ae6a5a60530a3461c512f3bc312
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230513-042734
        git checkout 16d692b101c65ae6a5a60530a3461c512f3bc312
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305130600.uZymcUzw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv4/tcp.c: In function 'tcp_inbound_md5_hash':
>> net/ipv4/tcp.c:4506:24: warning: implicit conversion from 'enum <anonymous>' to 'enum skb_drop_reason' [-Wenum-conversion]
    4506 |                 return true;
         |                        ^~~~


vim +4506 net/ipv4/tcp.c

  4477	
  4478	/* Called with rcu_read_lock() */
  4479	enum skb_drop_reason
  4480	tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
  4481			     const void *saddr, const void *daddr,
  4482			     int family, int dif, int sdif)
  4483	{
  4484		/*
  4485		 * This gets called for each TCP segment that arrives
  4486		 * so we want to be efficient.
  4487		 * We have 3 drop cases:
  4488		 * o No MD5 hash and one expected.
  4489		 * o MD5 hash and we're not expecting one.
  4490		 * o MD5 hash and its wrong.
  4491		 */
  4492		const __u8 *hash_location = NULL;
  4493		struct tcp_md5sig_key *hash_expected;
  4494		const struct tcphdr *th = tcp_hdr(skb);
  4495		const struct tcp_sock *tp = tcp_sk(sk);
  4496		int genhash, l3index;
  4497		u8 newhash[16];
  4498	
  4499		/* sdif set, means packet ingressed via a device
  4500		 * in an L3 domain and dif is set to the l3mdev
  4501		 */
  4502		l3index = sdif ? dif : 0;
  4503	
  4504		hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
  4505		if (tcp_parse_auth_options(th, &hash_location, NULL))
> 4506			return true;
  4507	
  4508		/* We've parsed the options - do we have a hash? */
  4509		if (!hash_expected && !hash_location)
  4510			return SKB_NOT_DROPPED_YET;
  4511	
  4512		if (hash_expected && !hash_location) {
  4513			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
  4514			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
  4515		}
  4516	
  4517		if (!hash_expected && hash_location) {
  4518			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
  4519			return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
  4520		}
  4521	
  4522		/* Check the signature.
  4523		 * To support dual stack listeners, we need to handle
  4524		 * IPv4-mapped case.
  4525		 */
  4526		if (family == AF_INET)
  4527			genhash = tcp_v4_md5_hash_skb(newhash,
  4528						      hash_expected,
  4529						      NULL, skb);
  4530		else
  4531			genhash = tp->af_specific->calc_md5_hash(newhash,
  4532								 hash_expected,
  4533								 NULL, skb);
  4534	
  4535		if (genhash || memcmp(hash_location, newhash, 16) != 0) {
  4536			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
  4537			if (family == AF_INET) {
  4538				net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
  4539						saddr, ntohs(th->source),
  4540						daddr, ntohs(th->dest),
  4541						genhash ? " tcp_v4_calc_md5_hash failed"
  4542						: "", l3index);
  4543			} else {
  4544				net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
  4545						genhash ? "failed" : "mismatch",
  4546						saddr, ntohs(th->source),
  4547						daddr, ntohs(th->dest), l3index);
  4548			}
  4549			return SKB_DROP_REASON_TCP_MD5FAILURE;
  4550		}
  4551		return SKB_NOT_DROPPED_YET;
  4552	}
  4553	EXPORT_SYMBOL(tcp_inbound_md5_hash);
  4554	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

