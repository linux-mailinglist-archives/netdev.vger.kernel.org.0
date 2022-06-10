Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C9C546EB8
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350267AbiFJUxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245369AbiFJUxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:53:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF1F248;
        Fri, 10 Jun 2022 13:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654894381; x=1686430381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IloPOG6rb4/h3WwQsyZ0qK0FPygA1mR4l8uI6GNZRZY=;
  b=P51CVVWh57qs6sBC+S2TyW3xqiK1o4y3zHDqtdbVktb8+si0OR1jpud8
   3yo7z5LG7EB3WVBuT7KBNfTxlo9ulrzSaN9IXelOeYGmv8wxqvTA/W0hw
   09+a/1vWHS5FxKXjUM3Q94Ea11VcZnNd1zOz9zEsFBM1trLi+WEAQw9FA
   QfW58oy1dQMp8pXrzpFpJ3cDEENxwggLYidndfwcsR2FOCPGUr0Ir5eP6
   ytUKBDyFDOXZk0DYU5m5zfWiJ2tUNd4q2v8En+B65mkb9ibaXPSaFwWzg
   +xvGafOzeqMS9UPtT8/7TtUnHJ0T9mGB73ybA/06R/ZVjhLX6cnlxEJ9x
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278545377"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="278545377"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 13:52:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="586384948"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jun 2022 13:52:52 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzlch-000IGv-Pd;
        Fri, 10 Jun 2022 20:52:51 +0000
Date:   Sat, 11 Jun 2022 04:52:06 +0800
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
Cc:     kbuild-all@lists.01.org, Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Message-ID: <202206110457.uD5lLvbh-lkp@intel.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-7-yosryahmed@google.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yosry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220611/202206110457.uD5lLvbh-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/83f297e2b47dc41b511f071b9eadf38339387b41
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 83f297e2b47dc41b511f071b9eadf38339387b41
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/cgroup/rstat.c:161:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     161 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~
   kernel/cgroup/rstat.c:509:10: error: 'const struct btf_kfunc_id_set' has no member named 'sleepable_set'; did you mean 'release_set'?
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |          ^~~~~~~~~~~~~
         |          release_set
>> kernel/cgroup/rstat.c:509:27: warning: excess elements in struct initializer
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |                           ^
   kernel/cgroup/rstat.c:509:27: note: (near initialization for 'bpf_rstat_kfunc_set')


vim +/bpf_rstat_flush +161 kernel/cgroup/rstat.c

   148	
   149	/*
   150	 * A hook for bpf stat collectors to attach to and flush their stats.
   151	 * Together with providing bpf kfuncs for cgroup_rstat_updated() and
   152	 * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
   153	 * collect cgroup stats can integrate with rstat for efficient flushing.
   154	 *
   155	 * A static noinline declaration here could cause the compiler to optimize away
   156	 * the function. A global noinline declaration will keep the definition, but may
   157	 * optimize away the callsite. Therefore, __weak is needed to ensure that the
   158	 * call is still emitted, by telling the compiler that we don't know what the
   159	 * function might eventually be.
   160	 */
 > 161	__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
   162					     struct cgroup *parent, int cpu)
   163	{
   164	}
   165	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
