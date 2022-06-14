Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E56554AA17
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353288AbiFNHKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353130AbiFNHKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:10:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A1D3B565;
        Tue, 14 Jun 2022 00:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655190622; x=1686726622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pk+x9K/iqBA609tuVtX93SlJSnddg8Adp1AklpFnyh8=;
  b=Syn+OtvjmYeJlPGTFJyb644P+TfWt1lYjTG6Wc+sTGBodbhahQDNWx2o
   p2OVN64PEs7Yca7v4SJu2Efag7G+rCdlV7SuSEXNeSP/wKdHnsBwQhtbL
   tCHfMfRdzMvCky+FYy11GIWk9jsLBC++QrQPjbGjFijlz7+a6oZbJhWa5
   C7aVvSG/x84AKZ+kld4h3k7BN9eOrp3MS/DDXK6/WWuXQb7eFc/41d4o7
   DHv+b/MrYKubv0n/LViH2on1NgNs+nWKr+6GOI7kYOU9ZQRHE2Km5PFET
   /wFkcD24yQF8AxYKk0S4ip+EXuHW59fK6aTeq+D7Mue+/3bUkyniRRFZn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258363993"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="258363993"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 00:10:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="582574187"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 00:10:19 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o10gs-000Lbd-Ec;
        Tue, 14 Jun 2022 07:10:18 +0000
Date:   Tue, 14 Jun 2022 15:09:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v1 2/2] seg6: add NEXT-C-SID support for SRv6 End
 behavior
Message-ID: <202206141513.QKv7c89J-lkp@intel.com>
References: <20220611104750.2724-3-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611104750.2724-3-andrea.mayer@uniroma2.it>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrea-Mayer/seg6-add-NEXT-C-SID-support-for-SRv6-End-behavior/20220611-185055
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 27f2533bcc6e909b85d3c1b738fa1f203ed8a835
config: csky-buildonly-randconfig-r006-20220613 (https://download.01.org/0day-ci/archive/20220614/202206141513.QKv7c89J-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5d121eb7b2b3ceb14906485b89e9c90dfa16b3c9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andrea-Mayer/seg6-add-NEXT-C-SID-support-for-SRv6-End-behavior/20220611-185055
        git checkout 5d121eb7b2b3ceb14906485b89e9c90dfa16b3c9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   net/ipv6/seg6_local.c: In function 'seg6_local_init':
>> include/linux/compiler_types.h:352:45: error: call to '__compiletime_assert_593' declared with attribute error: BUILD_BUG_ON failed: seg6_chk_next_csid_cfg(SEG6_LOCAL_LCBLOCK_DLEN, SEG6_LOCAL_LCNODE_FN_DLEN) != 0
     352 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:333:25: note: in definition of macro '__compiletime_assert'
     333 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:352:9: note: in expansion of macro '_compiletime_assert'
     352 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   net/ipv6/seg6_local.c:2278:9: note: in expansion of macro 'BUILD_BUG_ON'
    2278 |         BUILD_BUG_ON(seg6_chk_next_csid_cfg(SEG6_LOCAL_LCBLOCK_DLEN,
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_593 +352 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  338  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  339  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  340  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  341  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  342  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  343   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  344   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  345   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  346   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  347   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  348   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  349   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  350   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  351  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @352  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  353  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
