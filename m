Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBCB5363B6
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352913AbiE0OEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 10:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiE0OEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 10:04:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFFC275FE;
        Fri, 27 May 2022 07:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653660245; x=1685196245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PqdxjODClt15VT2awJtvXXZ53wPVcAebxtqdPJLcC5M=;
  b=CsK3FrhoN62zDVh5KFm8mwRLncMrsUZrj+42WfCkkM2ynSQ9nfA3FFPE
   V0/v85vdR5YC42+wsYw3uQr45+8rMWgBR/07BKo/QPHQ5PNAYhogRQtaw
   vkAPIOtPaZE8vWH40Q9FVxGcDysihxcGmAs5onn0cPV7sz/Eg8LYevGD5
   ddjFJou+FWJ47W1wyzC2cfflKig/iBdbvlExcIKzk9PpIbbkOHQa/Mxvi
   6LsH+QW0D7x5ATAjNLKg+CmWBnVsa+wckWguTnA1NEthg9HQ0mLyltTtK
   pJoR1xumfAXXQoKL23LrvkvGIOJ9PQYMiyoLRngpD7l7G4Mv2IQ73R1/m
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254980770"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="254980770"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 07:04:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="603902168"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2022 07:03:59 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuaZK-0004pq-DI;
        Fri, 27 May 2022 14:03:58 +0000
Date:   Fri, 27 May 2022 22:03:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        nhorman@tuxdriver.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
Message-ID: <202205272154.7zdeh6A3-lkp@intel.com>
References: <20220527071522.116422-3-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527071522.116422-3-imagedong@tencent.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220527-152050
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: x86_64-randconfig-a013 (https://download.01.org/0day-ci/archive/20220527/202205272154.7zdeh6A3-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0a1ac892edba0134b4891c9e61e06d462f8262a9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review menglong8-dong-gmail-com/reorganize-the-code-of-the-enum-skb_drop_reason/20220527-152050
        git checkout 0a1ac892edba0134b4891c9e61e06d462f8262a9
        # save the config file
        make W=1 ARCH=x86_64 

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/core/skbuff.c:85:
   ./net/core/dropreason_str.h:1:1: error: stray '\' in program
       1 | \n#define __DEFINE_SKB_DROP_REASON(FN) \
         | ^
   ./net/core/dropreason_str.h:1:3: error: stray '#' in program
       1 | \n#define __DEFINE_SKB_DROP_REASON(FN) \
         |   ^
>> ./net/core/dropreason_str.h:1:2: error: unknown type name 'n'
       1 | \n#define __DEFINE_SKB_DROP_REASON(FN) \
         |  ^
>> ./net/core/dropreason_str.h:1:11: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__DEFINE_SKB_DROP_REASON'
       1 | \n#define __DEFINE_SKB_DROP_REASON(FN) \
         |           ^~~~~~~~~~~~~~~~~~~~~~~~
>> net/core/skbuff.c:101:9: error: implicit declaration of function '__DEFINE_SKB_DROP_REASON' [-Werror=implicit-function-declaration]
     101 |         __DEFINE_SKB_DROP_REASON(FN)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
>> net/core/skbuff.c:101:34: error: 'FN' undeclared here (not in a function)
     101 |         __DEFINE_SKB_DROP_REASON(FN)
         |                                  ^~
   cc1: some warnings being treated as errors

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
