Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747DD6E2DF9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjDOAoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDOAoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:44:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F47A5242
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 17:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681519444; x=1713055444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a1YTaGvNfV6OIZ4Py7zcMRzRR16ghrp/iTk/SPFNtEI=;
  b=N3MtGGiPJSVx38IoBY8amv2X6qIAJ4PbTV7ypwaN0J+8ewo+JVN4RTcS
   dFBFZjnVV0NkmAjo/4mtKBwjp1UWgvLZJgBfhKc5yewMGVPPCBXKEWa3X
   VnKJ+GRaeuNiS3Vc88BHtsp9z3bsI0IFsGr5qSThxd1ygECnwNu+cAlVW
   b+3ddyR/ynFt/KZ3ot2bncYTM/qubwlxMsT4xuSCtIcb4B9SO92RP8BaT
   1Ie/jYBK09Y1a5gH/e7v6bc0hsympT4buBmdAwdPuXNyOIA7yOpErYuGq
   3voEYSTyVVeigckTAd7zjBRbX/utkRRo+BbOIQUBMfOrKntH9LeQ3BLIq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="347328853"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="347328853"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 17:44:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="864381611"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="864381611"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 14 Apr 2023 17:44:00 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnU1H-000aBB-2Q;
        Sat, 15 Apr 2023 00:43:59 +0000
Date:   Sat, 15 Apr 2023 08:43:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        fw@strlen.de
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Message-ID: <202304150840.hkUoyFNG-lkp@intel.com>
References: <20230414160105.172125-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-6-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-skbuff-hide-wifi_acked-when-CONFIG_WIRELESS-not-set/20230415-000750
patch link:    https://lore.kernel.org/r/20230414160105.172125-6-kuba%40kernel.org
patch subject: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
config: i386-randconfig-a005-20230410 (https://download.01.org/0day-ci/archive/20230415/202304150840.hkUoyFNG-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e2a92e33e41fe773b7c4a32a75db87340855387a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/net-skbuff-hide-wifi_acked-when-CONFIG_WIRELESS-not-set/20230415-000750
        git checkout e2a92e33e41fe773b7c4a32a75db87340855387a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304150840.hkUoyFNG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_tables_core.c:64:30: error: no member named 'nf_trace' in 'struct sk_buff'
                   info->nf_trace = pkt->skb->nf_trace;
                                    ~~~~~~~~  ^
   net/netfilter/nf_tables_core.c:75:31: error: no member named 'nf_trace' in 'struct sk_buff'
                           info->nf_trace = pkt->skb->nf_trace;
                                            ~~~~~~~~  ^
   net/netfilter/nf_tables_core.c:132:37: error: no member named 'nf_trace' in 'struct sk_buff'
                           info->nf_trace = info->pkt->skb->nf_trace;
                                            ~~~~~~~~~~~~~~  ^
   3 errors generated.
--
>> net/netfilter/nf_tables_trace.c:284:29: error: no member named 'nf_trace' in 'struct sk_buff'
           info->nf_trace = pkt->skb->nf_trace;
                            ~~~~~~~~  ^
   1 error generated.
--
>> net/netfilter/nft_meta.c:446:8: error: no member named 'nf_trace' in 'struct sk_buff'
                   skb->nf_trace = !!value8;
                   ~~~  ^
   1 error generated.


vim +64 net/netfilter/nf_tables_core.c

01ef16c2dd2e9a Patrick McHardy   2015-03-03  56  
399a14ec7993d6 Florian Westphal  2022-08-04  57  static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
399a14ec7993d6 Florian Westphal  2022-08-04  58  				    struct nft_traceinfo *info,
01ef16c2dd2e9a Patrick McHardy   2015-03-03  59  				    const struct nft_chain *chain,
2c865a8a28a10e Pablo Neira Ayuso 2022-01-09  60  				    const struct nft_rule_dp *rule,
33d5a7b14bfd02 Florian Westphal  2015-11-28  61  				    enum nft_trace_types type)
01ef16c2dd2e9a Patrick McHardy   2015-03-03  62  {
e639f7ab079b52 Florian Westphal  2015-11-28  63  	if (static_branch_unlikely(&nft_trace_enabled)) {
e34b9ed96ce3b0 Florian Westphal  2022-06-22 @64  		info->nf_trace = pkt->skb->nf_trace;
33d5a7b14bfd02 Florian Westphal  2015-11-28  65  		info->rule = rule;
e65eebec9c67df Florian Westphal  2018-05-11  66  		__nft_trace_packet(info, chain, type);
33d5a7b14bfd02 Florian Westphal  2015-11-28  67  	}
01ef16c2dd2e9a Patrick McHardy   2015-03-03  68  }
01ef16c2dd2e9a Patrick McHardy   2015-03-03  69  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
