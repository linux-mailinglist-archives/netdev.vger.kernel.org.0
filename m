Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002926E2F4E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 08:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDOGpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 02:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDOGp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 02:45:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E91140EC
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 23:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681541128; x=1713077128;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dVz2LcEnC83haxJgz3b1oE8t/W6Groio6OPd6t5ktUM=;
  b=bWlAGaCmIJPAEQeEllluMnwcRatifxmCSnl1STDBQceTye8SfP7ycu74
   uKZXU3XkGDZDfYIAXQO0QQ0JWWD0oATui8Fi7Lpw54I3nAUuOdSvuPKJy
   MWwIL6ONMie/rIqlDE+9hO5aiu/gFQ2/WKZnbpIxBq1qAeCtC6e9dgG0N
   37NumNJfQRfRvcCL0Gmj1xAAcJCTa9WqppAXYZ2G+9FAul+LryEqmK+e0
   StoRueOooj08FJv/hRW3RlW3/MHrUcSMwDN5EeHkslmoV32uGSdcCJzaA
   l+DI0JEBahMM/vlxYITgzUpCpdaNOfbqMnESwovgsgc1CqLrbRNv2Ihal
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="324246976"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="324246976"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 23:45:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="690079271"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="690079271"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2023 23:45:23 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnZev-000acE-2J;
        Sat, 15 Apr 2023 06:45:17 +0000
Date:   Sat, 15 Apr 2023 14:45:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com, Pedro Tammela <pctammela@mojatatu.com>,
        Palash Oswal <oswalpalash@gmail.com>
Subject: Re: [PATCH net-next] net/sched: clear actions pointer in miss cookie
 init fail
Message-ID: <202304151408.D1kAjGwb-lkp@intel.com>
References: <20230414214317.227128-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414214317.227128-1-pctammela@mojatatu.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pedro,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Pedro-Tammela/net-sched-clear-actions-pointer-in-miss-cookie-init-fail/20230415-054434
patch link:    https://lore.kernel.org/r/20230414214317.227128-1-pctammela%40mojatatu.com
patch subject: [PATCH net-next] net/sched: clear actions pointer in miss cookie init fail
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20230415/202304151408.D1kAjGwb-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0a51c6cee30eab6b3023dbcd65899511f14cd8e8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Pedro-Tammela/net-sched-clear-actions-pointer-in-miss-cookie-init-fail/20230415-054434
        git checkout 0a51c6cee30eab6b3023dbcd65899511f14cd8e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/sched/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304151408.D1kAjGwb-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/sched/cls_api.c: In function 'tcf_exts_init_ex':
>> net/sched/cls_api.c:3238:15: error: 'struct tcf_exts' has no member named 'actions'; did you mean 'action'?
    3238 |         exts->actions = NULL;
         |               ^~~~~~~
         |               action


vim +3238 net/sched/cls_api.c

  3223	
  3224		exts->action = action;
  3225		exts->police = police;
  3226	
  3227		if (!use_action_miss)
  3228			return 0;
  3229	
  3230		err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
  3231		if (err)
  3232			goto err_miss_alloc;
  3233	
  3234		return 0;
  3235	
  3236	err_miss_alloc:
  3237		tcf_exts_destroy(exts);
> 3238		exts->actions = NULL;
  3239		return err;
  3240	}
  3241	EXPORT_SYMBOL(tcf_exts_init_ex);
  3242	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
