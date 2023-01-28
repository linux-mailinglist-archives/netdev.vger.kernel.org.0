Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7FE67F99F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjA1Qnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjA1Qnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:43:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E98FB477
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674924226; x=1706460226;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TLglT9qgfl51JBF9AscxGjDzxdMZxX/pzsRH9CbaNFo=;
  b=KMGDayqsIzsd9z9xn5uRnjvF5RP65paR72r2mk2oXS6I+wvFrT6BJmGx
   xckdPnA0juKPJ7/cKkcJyCtLQ2Tfd93jy8yoYFp9FY6pGUIQQQZn818Dd
   JgqInOl3auPihomSGLmHp3YWfhGfidqlw13op5nTR24mcGZXVAZPNKVVQ
   THeqAhSQnWOFspUyUkgbiLNEKNy0BKu45rZQj7X3qQPdUmSZu0uhx6h6n
   U8GdA/9Ps0AHUkxdpYzfn1Te3gY6mwT+yXTXnoPBnp2CjxWcLKKtQNFOR
   avr8Rz9GUfum4MzBG/B1hROA0nU3wU+lyD8f1ys0/ktpEDznaWisbXSPs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="327324040"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="327324040"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 08:43:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="909005833"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="909005833"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jan 2023 08:43:43 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLoIp-0000vF-0c;
        Sat, 28 Jan 2023 16:43:43 +0000
Date:   Sun, 29 Jan 2023 00:42:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <202301290020.2pCidjI4-lkp@intel.com>
References: <20230126010206.13483-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
patch link:    https://lore.kernel.org/r/20230126010206.13483-3-vfedorenko%40novek.ru
patch subject: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo use-after-free
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20230129/202301290020.2pCidjI4-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2516a9785583b92ac82262a813203de696096ccd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
        git checkout 2516a9785583b92ac82262a813203de696096ccd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:93:18: warning: unused variable 'skb' [-Wunused-variable]
           struct sk_buff *skb;
                           ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:92:30: warning: unused variable 'hwts' [-Wunused-variable]
           struct skb_shared_hwtstamps hwts = {};
                                       ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:102:2: error: expected identifier or '('
           while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:110:2: error: expected identifier or '('
           if (!skb)
           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:113:2: error: expected identifier or '('
           return true;
           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:114:1: error: extraneous closing brace ('}')
   }
   ^
   2 warnings and 4 errors generated.


vim +/skb +93 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c

58a518948f6015 Aya Levin       2022-07-04   88  
2516a9785583b9 Vadim Fedorenko 2023-01-26   89  static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
83256998eee9fa Vadim Fedorenko 2023-01-26   90  					     u16 skb_id, int budget)
58a518948f6015 Aya Levin       2022-07-04   91  {
58a518948f6015 Aya Levin       2022-07-04  @92  	struct skb_shared_hwtstamps hwts = {};
58a518948f6015 Aya Levin       2022-07-04  @93  	struct sk_buff *skb;
58a518948f6015 Aya Levin       2022-07-04   94  
58a518948f6015 Aya Levin       2022-07-04   95  	ptpsq->cq_stats->resync_event++;
58a518948f6015 Aya Levin       2022-07-04   96  
2516a9785583b9 Vadim Fedorenko 2023-01-26   97  	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
2516a9785583b9 Vadim Fedorenko 2023-01-26   98  		pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");
2516a9785583b9 Vadim Fedorenko 2023-01-26   99  		return false;
2516a9785583b9 Vadim Fedorenko 2023-01-26  100  	}
2516a9785583b9 Vadim Fedorenko 2023-01-26  101  
2516a9785583b9 Vadim Fedorenko 2023-01-26  102  	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
58a518948f6015 Aya Levin       2022-07-04  103  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
58a518948f6015 Aya Levin       2022-07-04  104  		skb_tstamp_tx(skb, &hwts);
58a518948f6015 Aya Levin       2022-07-04  105  		ptpsq->cq_stats->resync_cqe++;
83256998eee9fa Vadim Fedorenko 2023-01-26  106  		napi_consume_skb(skb, budget);
58a518948f6015 Aya Levin       2022-07-04  107  		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
58a518948f6015 Aya Levin       2022-07-04  108  	}
2516a9785583b9 Vadim Fedorenko 2023-01-26  109  
2516a9785583b9 Vadim Fedorenko 2023-01-26  110  	if (!skb)
2516a9785583b9 Vadim Fedorenko 2023-01-26  111  		return false;
2516a9785583b9 Vadim Fedorenko 2023-01-26  112  
2516a9785583b9 Vadim Fedorenko 2023-01-26  113  	return true;
58a518948f6015 Aya Levin       2022-07-04  114  }
58a518948f6015 Aya Levin       2022-07-04  115  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
