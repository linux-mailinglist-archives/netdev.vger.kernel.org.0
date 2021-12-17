Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C34795A9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 21:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhLQUnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 15:43:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:8647 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240874AbhLQUng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 15:43:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639773816; x=1671309816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y+i0HTizlNj49ZQwWWqNGobWioGmYAuUJdgme703Mz4=;
  b=hrZdI6UtogkzV2vErI/6vuMRMOQnPvWc07vJVBeboj3Nzg9x+xfqYufC
   7Yv9E6pa1aOSKLZ755JoMhWHHtsa6MZL6p+2CohTB4q4vJGldg3HJvIl0
   AmsxGVY04pzp1hPSkKkcBYjoAksnTkcMtOJOIa9M2ZPHiWhCcYh2fyR5g
   1zoWSBMA3D3ohoJhhdCDb8u5nKBrdFC55HZLtiZN5jUNCkV+KH9yvFtkK
   Rq8NnwP+34gfixpO1+VHyhYgmSlVVzvp6obMrOBPFBfnh7FJUwJWS4UHp
   JJ7Ees0JtJjWkOVnXVZA8Z/qlpRy5j4uEciBfqsNdUocqbTxVYbzELNqo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="220511585"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="220511585"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 12:43:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="662948348"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 17 Dec 2021 12:43:33 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1myK4j-0005Br-9L; Fri, 17 Dec 2021 20:43:33 +0000
Date:   Sat, 18 Dec 2021 04:43:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH nf-next,v2 5/5] netfilter: nf_tables: make counter
 support built-in
Message-ID: <202112180458.kdTRRudP-lkp@intel.com>
References: <20211217113837.1253-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217113837.1253-5-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf/master]
[also build test WARNING on nf-next/master horms-ipvs/master v5.16-rc5 next-20211217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-remove-rcu-read-size-lock/20211217-194033
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
config: x86_64-randconfig-a001-20211217 (https://download.01.org/0day-ci/archive/20211218/202112180458.kdTRRudP-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 9043c3d65b11b442226015acfbf8167684586cfa)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/390ad4295aa6445c311abd677b653a510f621131
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/netfilter-nf_tables-remove-rcu-read-size-lock/20211217-194033
        git checkout 390ad4295aa6445c311abd677b653a510f621131
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/netfilter/nft_counter.c:195:6: warning: no previous prototype for function 'nft_counter_eval' [-Wmissing-prototypes]
   void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
        ^
   net/netfilter/nft_counter.c:195:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
   ^
   static 
>> net/netfilter/nft_counter.c:277:6: warning: no previous prototype for function 'nft_counter_init_seqcount' [-Wmissing-prototypes]
   void nft_counter_init_seqcount(void)
        ^
   net/netfilter/nft_counter.c:277:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void nft_counter_init_seqcount(void)
   ^
   static 
   2 warnings generated.


vim +/nft_counter_eval +195 net/netfilter/nft_counter.c

   194	
 > 195	void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
   196			      const struct nft_pktinfo *pkt)
   197	{
   198		struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
   199	
   200		nft_counter_do_eval(priv, regs, pkt);
   201	}
   202	
   203	static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
   204	{
   205		struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
   206	
   207		return nft_counter_do_dump(skb, priv, false);
   208	}
   209	
   210	static int nft_counter_init(const struct nft_ctx *ctx,
   211				    const struct nft_expr *expr,
   212				    const struct nlattr * const tb[])
   213	{
   214		struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
   215	
   216		return nft_counter_do_init(tb, priv);
   217	}
   218	
   219	static void nft_counter_destroy(const struct nft_ctx *ctx,
   220					const struct nft_expr *expr)
   221	{
   222		struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
   223	
   224		nft_counter_do_destroy(priv);
   225	}
   226	
   227	static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
   228	{
   229		struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
   230		struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
   231		struct nft_counter __percpu *cpu_stats;
   232		struct nft_counter *this_cpu;
   233		struct nft_counter total;
   234	
   235		nft_counter_fetch(priv, &total);
   236	
   237		cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
   238		if (cpu_stats == NULL)
   239			return -ENOMEM;
   240	
   241		preempt_disable();
   242		this_cpu = this_cpu_ptr(cpu_stats);
   243		this_cpu->packets = total.packets;
   244		this_cpu->bytes = total.bytes;
   245		preempt_enable();
   246	
   247		priv_clone->counter = cpu_stats;
   248		return 0;
   249	}
   250	
   251	static int nft_counter_offload(struct nft_offload_ctx *ctx,
   252				       struct nft_flow_rule *flow,
   253				       const struct nft_expr *expr)
   254	{
   255		/* No specific offload action is needed, but report success. */
   256		return 0;
   257	}
   258	
   259	static void nft_counter_offload_stats(struct nft_expr *expr,
   260					      const struct flow_stats *stats)
   261	{
   262		struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
   263		struct nft_counter *this_cpu;
   264		seqcount_t *myseq;
   265	
   266		preempt_disable();
   267		this_cpu = this_cpu_ptr(priv->counter);
   268		myseq = this_cpu_ptr(&nft_counter_seq);
   269	
   270		write_seqcount_begin(myseq);
   271		this_cpu->packets += stats->pkts;
   272		this_cpu->bytes += stats->bytes;
   273		write_seqcount_end(myseq);
   274		preempt_enable();
   275	}
   276	
 > 277	void nft_counter_init_seqcount(void)
   278	{
   279		int cpu;
   280	
   281		for_each_possible_cpu(cpu)
   282			seqcount_init(per_cpu_ptr(&nft_counter_seq, cpu));
   283	}
   284	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
