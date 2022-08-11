Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D862D590662
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiHKS2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 14:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiHKS2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 14:28:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194829D113;
        Thu, 11 Aug 2022 11:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660242485; x=1691778485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3fA3slRt3QaRDvpFlIyp4A4gcmLnDPb+Je+ZzpvKXpM=;
  b=AiYJRGmJxliTWik/t0iDo8AgLzfjlp9Vb6IYmzdvClcX9uSprIKQEhk7
   Tz0v6t3AplfNmk97nXqInffVkh18UGnK0oonTuCTQxjEgTtIblGEnhahd
   bEcwPV+1FF6Lk9qMPX7JLM9V/DjCBCqjb4tJO3sQ1T4g4OvpLpd0WcvYI
   Tklc1LHyfw0Am/2DOXelDilxR7i0ZVRHPFqB9+HlyZtWqsRHmnyY3LdaF
   aTcCkykR1biQdmdOfgV/N2Inn21CMSC/PlsxrJof76k7/xpXuOtDZekQz
   1QR17hPchtlauKxrxbostb9tItP5u8HUavN9fAKzpab/lnlAPX5WafGrU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292691186"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="292691186"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 11:28:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="673799075"
Received: from lkp-server02.sh.intel.com (HELO cfab306db114) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 11:28:01 -0700
Received: from kbuild by cfab306db114 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMCuW-0000VP-13;
        Thu, 11 Aug 2022 18:28:00 +0000
Date:   Fri, 12 Aug 2022 02:27:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ojeda@kernel.org,
        ndesaulniers@google.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: skb: prevent the split of
 kfree_skb_reason() by gcc
Message-ID: <202208120238.cz3RvV74-lkp@intel.com>
References: <20220811120708.34912-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811120708.34912-1-imagedong@tencent.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/net-skb-prevent-the-split-of-kfree_skb_reason-by-gcc/20220811-200919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: riscv-randconfig-r042-20220811 (https://download.01.org/0day-ci/archive/20220812/202208120238.cz3RvV74-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/8e014b654d9e51abed132155237d855b25da06a0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-skb-prevent-the-split-of-kfree_skb_reason-by-gcc/20220811-200919
        git checkout 8e014b654d9e51abed132155237d855b25da06a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/skbuff.c:780:6: warning: unknown attribute 'optimize' ignored [-Wunknown-attributes]
   void __nofnsplit
        ^~~~~~~~~~~
   include/linux/compiler_attributes.h:374:56: note: expanded from macro '__nofnsplit'
   #define __nofnsplit                     __attribute__((optimize("O1")))
                                                          ^~~~~~~~~~~~~~
   1 warning generated.


vim +/optimize +780 net/core/skbuff.c

   770	
   771	/**
   772	 *	kfree_skb_reason - free an sk_buff with special reason
   773	 *	@skb: buffer to free
   774	 *	@reason: reason why this skb is dropped
   775	 *
   776	 *	Drop a reference to the buffer and free it if the usage count has
   777	 *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
   778	 *	tracepoint.
   779	 */
 > 780	void __nofnsplit
   781	kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
   782	{
   783		if (!skb_unref(skb))
   784			return;
   785	
   786		DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
   787	
   788		trace_kfree_skb(skb, __builtin_return_address(0), reason);
   789		__kfree_skb(skb);
   790	}
   791	EXPORT_SYMBOL(kfree_skb_reason);
   792	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
