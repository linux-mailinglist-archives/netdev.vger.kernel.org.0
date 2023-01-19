Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85568673DF4
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjASPvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjASPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:51:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B6A829AC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674143463; x=1705679463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aOUZMiKF3NX0nh5cZ7E09kHUs0CRUzV9PhmnGZt+OnA=;
  b=CHzB7GSHM0hQ1J75T3YBCJT43sm3dKiftWmGzc+/HnCw/yGe5WItPXKA
   YOBCEkZgz3F2J8esZ99lATXCnUQcVJs3nvPjHXIcqnmvzO45ZZbl9pnHB
   ZoDpHfsffprb1Qy6jOhJ9XeG/yYny00lmDZjgjDCsKC9bvrw653K/0ubM
   H84S/TZsnAHDHa/ilHLQX72qeGipKAtkcsgdE6cpBAoZ1+w1Y489upmAQ
   kKqnAcopTIiNMG1xQq4QHjCj3delR2dbjR6OmY7M7CCdynZZYOyYJBlji
   vrJ5YWzH52XtJAUwFqJ+GoDOMKPsYVsQrQCYphKXLrjEmy93RXAcKT9+Z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="326601212"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="326601212"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:51:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692463392"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="692463392"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 07:50:58 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIXBp-0001ag-0c;
        Thu, 19 Jan 2023 15:50:57 +0000
Date:   Thu, 19 Jan 2023 23:50:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v3 1/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <202301192343.MPDnhYo1-lkp@intel.com>
References: <20230119082357.21744-2-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119082357.21744-2-paulb@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Blakey/net-sched-cls_api-Support-hardware-miss-to-tc-action/20230119-162743
patch link:    https://lore.kernel.org/r/20230119082357.21744-2-paulb%40nvidia.com
patch subject: [PATCH net-next v3 1/6] net/sched: cls_api: Support hardware miss to tc action
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230119/202301192343.MPDnhYo1-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5c85cf394445e1140823351fdfdbf3e541b9abb9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paul-Blakey/net-sched-cls_api-Support-hardware-miss-to-tc-action/20230119-162743
        git checkout 5c85cf394445e1140823351fdfdbf3e541b9abb9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/sched/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/sched/cls_api.c:3224:6: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
           if (err)
               ^~~
   net/sched/cls_api.c:3200:9: note: initialize the variable 'err' to silence this warning
           int err;
                  ^
                   = 0
   1 warning generated.


vim +/err +3224 net/sched/cls_api.c

  3214	
  3215		exts->action = action;
  3216		exts->police = police;
  3217	
  3218		if (!use_action_miss)
  3219			return 0;
  3220	
  3221	#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
  3222		err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
  3223	#endif
> 3224		if (err)
  3225			goto err_miss_alloc;
  3226	
  3227		return 0;
  3228	
  3229	err_miss_alloc:
  3230		tcf_exts_destroy(exts);
  3231		return err;
  3232	}
  3233	EXPORT_SYMBOL(tcf_exts_init_ex);
  3234	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
