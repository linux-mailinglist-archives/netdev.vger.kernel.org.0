Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B8C59184A
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 04:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiHMCJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 22:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMCJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 22:09:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B99F220D6;
        Fri, 12 Aug 2022 19:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660356548; x=1691892548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K1sPmUlSGlZdpd8fyqcmHRHve+qzuq97ORygXjVcVjk=;
  b=EsEGK7ox/yG3habdL+miQBI+Tjr9PtXZnxyPmIq2aZPXc5JOA0buQueI
   vMZAHRiBoBZ9gQjFjkn+X9IRlghbJLKlZVsMz4av082P/E4AfhE8VSLuI
   /VVlqwE5f6STUmWhiAHG7MA0DZeqdd8jpV5Aj3nSW3o9SSW4R2y2Thbrg
   b0zQ9Kfbw65aG9v21FrTDPmx5NMdEYh6FM4IFI+Rd1vU4AfZndULuN4NO
   gZU0GFhIUHXiQ70ntgmtXQQOqe7W7V20A7cdkHjBjsPZ5CoPUkKbX5uyL
   2jhpamzAkH7K6YRnZchnKZwTLmbPIM0bQMebGkFLtzsAhckSgeAgybGxS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="271492189"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="271492189"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 19:09:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="609430908"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 12 Aug 2022 19:09:04 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMgaF-0001Cw-2D;
        Sat, 13 Aug 2022 02:09:03 +0000
Date:   Sat, 13 Aug 2022 10:09:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ojeda@kernel.org,
        ndesaulniers@google.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: skb: prevent the split of
 kfree_skb_reason() by gcc
Message-ID: <202208131003.M7FBGBna-lkp@intel.com>
References: <20220812025015.316609-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812025015.316609-1-imagedong@tencent.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/net-skb-prevent-the-split-of-kfree_skb_reason-by-gcc/20220812-105214
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7ebfc85e2cd7b08f518b526173e9a33b56b3913b
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220813/202208131003.M7FBGBna-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ec98116fd4b985103e65c71d47f9390fee025cb9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/net-skb-prevent-the-split-of-kfree_skb_reason-by-gcc/20220812-105214
        git checkout ec98116fd4b985103e65c71d47f9390fee025cb9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/skbuff.c:780:6: warning: unknown attribute '__optimize__' ignored [-Wunknown-attributes]
   void __nofnsplit
        ^~~~~~~~~~~
   include/linux/compiler_attributes.h:273:56: note: expanded from macro '__nofnsplit'
   #define __nofnsplit                     __attribute__((__optimize__("O1")))
                                                          ^~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +/__optimize__ +780 net/core/skbuff.c

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
