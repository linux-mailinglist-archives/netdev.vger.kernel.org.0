Return-Path: <netdev+bounces-10462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E72B72E9CA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A61C1C20889
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E8137B8E;
	Tue, 13 Jun 2023 17:29:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D33924F;
	Tue, 13 Jun 2023 17:29:40 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF021BDC;
	Tue, 13 Jun 2023 10:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686677353; x=1718213353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vHANWv3zEJsC1831jhZqokLdunyn+W4Oc+D4AmUHZ6s=;
  b=bxLHf/u0SAsdtJqJcPXgt77nmKo4XUUzh+FbR7OBlUvUNuhYGBR0A5lV
   wDDgrneP8cyQtLr5o9owJ56z5AeZNUQ9flamykmp4W23v/zLtdnnNWli6
   EPXIg0sUqSJyzxqwcauvZUWVOwdkOQ8lX4g4GE88SX/Xx2hJz80J8HHRd
   LXZ/q6GUPvV68ehiMf+9NgRjIuuGU2XWaYXhVNZ5ys3YDWqL4InUxphNS
   uyvUPpYw2cE94nIdoMpD2jopsFJkbIcSBPKt5ucxcTdqR0EiHURxhZggB
   GGrUY0nym49TlEbFyQMp3bxE4b+xTij5XWd26M/YEeFeA9QTXPypY4eey
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="386805856"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="386805856"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="958472728"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="958472728"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2023 10:27:11 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q97nT-0001bM-2n;
	Tue, 13 Jun 2023 17:27:11 +0000
Date: Wed, 14 Jun 2023 01:26:12 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenz Bauer <lmb@isovalent.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Hemanth Malla <hemanthmalla@gmail.com>,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Lorenz Bauer <lmb@isovalent.com>
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup
 functions
Message-ID: <202306140138.DnwjedJ1-lkp@intel.com>
References: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Lorenz,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 25085b4e9251c77758964a8e8651338972353642]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenz-Bauer/net-export-inet_lookup_reuseport-and-inet6_lookup_reuseport/20230613-181619
base:   25085b4e9251c77758964a8e8651338972353642
patch link:    https://lore.kernel.org/r/20230613-so-reuseport-v2-3-b7c69a342613%40isovalent.com
patch subject: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup functions
config: i386-defconfig (https://download.01.org/0day-ci/archive/20230614/202306140138.DnwjedJ1-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git checkout 25085b4e9251c77758964a8e8651338972353642
        b4 shazam https://lore.kernel.org/r/20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv4/ net/ipv6/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140138.DnwjedJ1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ipv4/udp.c:409:5: warning: no previous prototype for 'udp_ehashfn' [-Wmissing-prototypes]
     409 | u32 udp_ehashfn(const struct net *net, const __be32 laddr, const __u16 lport,
         |     ^~~~~~~~~~~
--
>> net/ipv6/udp.c:74:5: warning: no previous prototype for 'udp6_ehashfn' [-Wmissing-prototypes]
      74 | u32 udp6_ehashfn(const struct net *net,
         |     ^~~~~~~~~~~~


vim +/udp_ehashfn +409 net/ipv4/udp.c

   407	
   408	INDIRECT_CALLABLE_SCOPE
 > 409	u32 udp_ehashfn(const struct net *net, const __be32 laddr, const __u16 lport,
   410			const __be32 faddr, const __be16 fport)
   411	{
   412		static u32 udp_ehash_secret __read_mostly;
   413	
   414		net_get_random_once(&udp_ehash_secret, sizeof(udp_ehash_secret));
   415	
   416		return __inet_ehashfn(laddr, lport, faddr, fport,
   417				      udp_ehash_secret + net_hash_mix(net));
   418	}
   419	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

