Return-Path: <netdev+bounces-10835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AED46730764
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBF7281516
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950557476;
	Wed, 14 Jun 2023 18:38:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C202EC16
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:38:31 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E1A1BF7;
	Wed, 14 Jun 2023 11:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686767909; x=1718303909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3sI4YDTtaY0g0URvNJ8Dd8m8uuHedTrH+fP517EWAwI=;
  b=K3cmfml30d0HytjqHGMDGR0bwY7rvhMLpYU1LiW+r8XXRdtjudCtCbYL
   1KO7k+r/ApXqWf63E8l2UhD7dz55+awYtLqHF7ZTbSgLlYlBtWlXnciRj
   NRc7bBE+6kqDoKdYeUt1rzJm1UxIB/rQzTM4qweKWCsVYsW2JdvBz+zZA
   DT9XCLY2vnbIRUgvBSR/cxf/hYKe79ZtZQs1H4grcdOYKnMM+a3VCh3VT
   1hond2Byo1gQvmd9/frfzqiWMA25ygtoBRAeqSRFSnyp8xYNQ5rQkPe5L
   JsRPHWK/nuj+jNAKtlirhRiom8jPDSxd9yok38kHcbCGqGiD1RNT4+oAW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="356195122"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="356195122"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 11:38:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="745184234"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="745184234"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 11:38:24 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9VNv-0000xK-1R;
	Wed, 14 Jun 2023 18:38:23 +0000
Date: Thu, 15 Jun 2023 02:38:07 +0800
From: kernel test robot <lkp@intel.com>
To: Jisheng Zhang <jszhang@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/3] net: stmmac: use pcpu statistics where necessary
Message-ID: <202306150255.k4BaJTXY-lkp@intel.com>
References: <20230614161847.4071-4-jszhang@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614161847.4071-4-jszhang@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jisheng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on sunxi/sunxi/for-next]
[also build test WARNING on linus/master v6.4-rc6]
[cannot apply to next-20230614]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jisheng-Zhang/net-stmmac-don-t-clear-network-statistics-in-ndo_open/20230615-003137
base:   https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git sunxi/for-next
patch link:    https://lore.kernel.org/r/20230614161847.4071-4-jszhang%40kernel.org
patch subject: [PATCH 3/3] net: stmmac: use pcpu statistics where necessary
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230615/202306150255.k4BaJTXY-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add sunxi https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git
        git fetch sunxi sunxi/for-next
        git checkout sunxi/sunxi/for-next
        b4 shazam https://lore.kernel.org/r/20230614161847.4071-4-jszhang@kernel.org
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306150255.k4BaJTXY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c: In function 'stmmac_get_per_qstats':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:564:26: warning: 'start' is used uninitialized [-Wuninitialized]
     564 |                 } while (u64_stats_fetch_retry(&stats->syncp, start));
         |                          ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:551:22: note: 'start' was declared here
     551 |         unsigned int start;
         |                      ^~~~~


vim +/start +564 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c

   546	
   547	static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
   548	{
   549		u32 tx_cnt = priv->plat->tx_queues_to_use;
   550		u32 rx_cnt = priv->plat->rx_queues_to_use;
   551		unsigned int start;
   552		int q, stat, cpu;
   553		char *p;
   554		u64 *pos;
   555	
   556		pos = data;
   557		for_each_possible_cpu(cpu) {
   558			struct stmmac_pcpu_stats *stats, snapshot;
   559	
   560			data = pos;
   561			stats = per_cpu_ptr(priv->xstats.pstats, cpu);
   562			do {
   563				snapshot = *stats;
 > 564			} while (u64_stats_fetch_retry(&stats->syncp, start));
   565	
   566			for (q = 0; q < tx_cnt; q++) {
   567				p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
   568							    txq_stats[q].tx_pkt_n);
   569				for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
   570					*data++ = (*(u64 *)p);
   571					p += sizeof(u64);
   572				}
   573			}
   574			for (q = 0; q < rx_cnt; q++) {
   575				p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
   576							    rxq_stats[q].rx_pkt_n);
   577				for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
   578					*data++ = (*(u64 *)p);
   579					p += sizeof(u64);
   580				}
   581			}
   582		}
   583	}
   584	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

