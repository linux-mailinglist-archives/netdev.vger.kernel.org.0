Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737555473AF
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiFKKW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiFKKWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:22:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB72238;
        Sat, 11 Jun 2022 03:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654942938; x=1686478938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1FQ1UCouIaP6LU42YfbC0jlHmjtqheR5eWTCBmjbZqw=;
  b=DusHGC6yGO1qUhnUDxIESPDV7Rs+T9kxhkeZU33xLyFvzpVju+Bpk3Av
   p1J5Uvk5f97utBFrIc9q96olOCpPAFafvaAcui7LYsZOwEFGsAEnzgmkN
   dwwBaAqFIJCAab9d6n+8pVv64O3vyei6/vGMzom84sbdaQ4sgMZ6YjWMd
   MXNKlGPtEuZffrdF51z9LH7gfwRRdGRJqDHE34bf/1Kfs5Jxq98uPfVtx
   Vuat/1SycgRaVPKkrApxqewZYD82BgwhXOhxIdQBbJ9G5Vw0Wvhp+vLRW
   k8FxQALoKH7ThJsIDWa3Me/yeBsMzLPqdSdGNyMrOzAyLwzKODU5w6jTj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339599367"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="339599367"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 03:22:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="556760939"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2022 03:22:10 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzyFu-000InX-4C;
        Sat, 11 Jun 2022 10:22:10 +0000
Date:   Sat, 11 Jun 2022 18:22:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Michal Hocko <mhocko@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Message-ID: <202206111842.O3viR9gq-lkp@intel.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-7-yosryahmed@google.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yosry,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: hexagon-randconfig-r012-20220611 (https://download.01.org/0day-ci/archive/20220611/202206111842.O3viR9gq-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/83f297e2b47dc41b511f071b9eadf38339387b41
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 83f297e2b47dc41b511f071b9eadf38339387b41
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> kernel/cgroup/rstat.c:161:22: warning: no previous prototype for function 'bpf_rstat_flush' [-Wmissing-prototypes]
   __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
                        ^
   kernel/cgroup/rstat.c:161:17: note: declare 'static' if the function is not intended to be used outside of this translation unit
   __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
                   ^
                   static 
>> kernel/cgroup/rstat.c:509:3: error: field designator 'sleepable_set' does not refer to any field in type 'const struct btf_kfunc_id_set'
           .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
            ^
   1 warning and 1 error generated.


vim +509 kernel/cgroup/rstat.c

   505	
   506	static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
   507		.owner		= THIS_MODULE,
   508		.check_set	= &bpf_rstat_check_kfunc_ids,
 > 509		.sleepable_set	= &bpf_rstat_sleepable_kfunc_ids,
   510	};
   511	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
