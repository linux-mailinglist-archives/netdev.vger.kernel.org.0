Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7376856A8B0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiGGQy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiGGQy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:54:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC69F237E4
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657212896; x=1688748896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eeKgrN0DCk7VxRX4Ogn9M9tx2czAQgPhJqE+xKc3iAw=;
  b=GCpojGbD7evF3jrIusuegYQSVw3+wWYToxsoR1HYjHIe6NQ/dNqCoqAK
   EOT3ZJSe/N1mkn3NeDiSYtznOBpsIyF6Se2Jov4LN7u/dyQPUqMwjWTp/
   7NnWkncK5RoColk2eFIuKstRJTpHGsq6Vk4HAPEE3KN9UxaW+ORNHW+Al
   I2wh1+aYxfvSDkNgbA7Y6PSuK0ODUosztT4vYW7DDL/H7Y2aq7jtlw6GN
   +7nLJ4VU97U9PYOcUsuu96EBhjtectdHCcrG810yADe/wEdzVWKy6MzOP
   tcNuMSYftfPxL0AJOjjYmZ7AS8huYmIn1YgdqZ6tqtsC8m4WzKPRFH7+j
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="282825764"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="282825764"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 09:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="661456171"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jul 2022 09:54:53 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9UmB-000MEi-Tb;
        Thu, 07 Jul 2022 16:54:51 +0000
Date:   Fri, 8 Jul 2022 00:54:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, borisp@nvidia.com,
        john.fastabend@gmail.com, maximmi@nvidia.com, tariqt@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/6] tls: create an internal header
Message-ID: <202207080041.YiP2JbIW-lkp@intel.com>
References: <20220707013510.1372695-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707013510.1372695-6-kuba@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/tls-pad-strparser-internal-header-decrypt_ctx-etc/20220707-120420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git cd355d0bc60df51266d228c0f69570cdcfa1e6ba
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220708/202207080041.YiP2JbIW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/4088937ef16f0f7a85bc39bb89ab75b33d5e8774
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/tls-pad-strparser-internal-header-decrypt_ctx-etc/20220707-120420
        git checkout 4088937ef16f0f7a85bc39bb89ab75b33d5e8774
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function 'fun_tls_tx':
>> drivers/net/ethernet/fungible/funeth/funeth_tx.c:99:25: error: implicit declaration of function 'tls_offload_tx_resync_request'; did you mean 'tls_offload_rx_resync_request'? [-Werror=implicit-function-declaration]
      99 |                         tls_offload_tx_resync_request(skb->sk, seq,
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                         tls_offload_rx_resync_request
   cc1: some warnings being treated as errors
--
   drivers/net/ethernet/netronome/nfp/nfp_net_common.c: In function 'nfp_net_tls_tx':
>> drivers/net/ethernet/netronome/nfp/nfp_net_common.c:636:25: error: implicit declaration of function 'tls_offload_tx_resync_request'; did you mean 'tls_offload_rx_resync_request'? [-Werror=implicit-function-declaration]
     636 |                         tls_offload_tx_resync_request(nskb->sk, seq,
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                         tls_offload_rx_resync_request
   cc1: some warnings being treated as errors


vim +99 drivers/net/ethernet/fungible/funeth/funeth_tx.c

db37bc177dae89c Dimitris Michailidis 2022-02-24   78  
db37bc177dae89c Dimitris Michailidis 2022-02-24   79  static struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
db37bc177dae89c Dimitris Michailidis 2022-02-24   80  				  unsigned int *tls_len)
db37bc177dae89c Dimitris Michailidis 2022-02-24   81  {
b23f9239195a1af Dimitris Michailidis 2022-03-08   82  #if IS_ENABLED(CONFIG_TLS_DEVICE)
db37bc177dae89c Dimitris Michailidis 2022-02-24   83  	const struct fun_ktls_tx_ctx *tls_ctx;
db37bc177dae89c Dimitris Michailidis 2022-02-24   84  	u32 datalen, seq;
db37bc177dae89c Dimitris Michailidis 2022-02-24   85  
504148fedb85429 Eric Dumazet         2022-06-30   86  	datalen = skb->len - skb_tcp_all_headers(skb);
db37bc177dae89c Dimitris Michailidis 2022-02-24   87  	if (!datalen)
db37bc177dae89c Dimitris Michailidis 2022-02-24   88  		return skb;
db37bc177dae89c Dimitris Michailidis 2022-02-24   89  
db37bc177dae89c Dimitris Michailidis 2022-02-24   90  	if (likely(!tls_offload_tx_resync_pending(skb->sk))) {
db37bc177dae89c Dimitris Michailidis 2022-02-24   91  		seq = ntohl(tcp_hdr(skb)->seq);
db37bc177dae89c Dimitris Michailidis 2022-02-24   92  		tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
db37bc177dae89c Dimitris Michailidis 2022-02-24   93  
db37bc177dae89c Dimitris Michailidis 2022-02-24   94  		if (likely(tls_ctx->next_seq == seq)) {
db37bc177dae89c Dimitris Michailidis 2022-02-24   95  			*tls_len = datalen;
db37bc177dae89c Dimitris Michailidis 2022-02-24   96  			return skb;
db37bc177dae89c Dimitris Michailidis 2022-02-24   97  		}
db37bc177dae89c Dimitris Michailidis 2022-02-24   98  		if (seq - tls_ctx->next_seq < U32_MAX / 4) {
db37bc177dae89c Dimitris Michailidis 2022-02-24  @99  			tls_offload_tx_resync_request(skb->sk, seq,
db37bc177dae89c Dimitris Michailidis 2022-02-24  100  						      tls_ctx->next_seq);
db37bc177dae89c Dimitris Michailidis 2022-02-24  101  		}
db37bc177dae89c Dimitris Michailidis 2022-02-24  102  	}
db37bc177dae89c Dimitris Michailidis 2022-02-24  103  
db37bc177dae89c Dimitris Michailidis 2022-02-24  104  	FUN_QSTAT_INC(q, tx_tls_fallback);
db37bc177dae89c Dimitris Michailidis 2022-02-24  105  	skb = tls_encrypt_skb(skb);
db37bc177dae89c Dimitris Michailidis 2022-02-24  106  	if (!skb)
db37bc177dae89c Dimitris Michailidis 2022-02-24  107  		FUN_QSTAT_INC(q, tx_tls_drops);
db37bc177dae89c Dimitris Michailidis 2022-02-24  108  
db37bc177dae89c Dimitris Michailidis 2022-02-24  109  	return skb;
b23f9239195a1af Dimitris Michailidis 2022-03-08  110  #else
b23f9239195a1af Dimitris Michailidis 2022-03-08  111  	return NULL;
db37bc177dae89c Dimitris Michailidis 2022-02-24  112  #endif
b23f9239195a1af Dimitris Michailidis 2022-03-08  113  }
db37bc177dae89c Dimitris Michailidis 2022-02-24  114  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
