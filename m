Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7A546F31
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350853AbiFJVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244326AbiFJVXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 17:23:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518C6517EF;
        Fri, 10 Jun 2022 14:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654896179; x=1686432179;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Fnfy4WtP9NWPenQZd12tioUwaC4f7ruohnjtYS/f3Q=;
  b=gMNVufcWr0NsKdGfIlVHsJGQWHmNQ55lPzmgwiZ1xgH+y26zNBhsDMPk
   r/ZfbdGDU8u4PtmshPjqt0JLXyuInqJJi7Wv1wa2MQQruYQLJhEdE23TD
   wOeU602XWeyx8vEVgOZ0z5QuFdxBXJDIAzLJcwWXkUt7gOBC2QpaKjcbF
   e1nmWW37vHY7qgTha398jLJC5wFVILvDh1WIcTx5IW/kEoimaVZkDMhqL
   9tf6VsP5mxRDrgiOZwfWmSV6cqEo956+eIiV9XpJ/dZAwekk69gIu/j2W
   8FoQyRpQug4v9xlVcSXZjrk4vnlufw3g6LhKAboIjoh3A7rMXDVC6olZa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="260868821"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="260868821"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 14:22:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="760671333"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 10 Jun 2022 14:22:53 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzm5k-000II1-E0;
        Fri, 10 Jun 2022 21:22:52 +0000
Date:   Sat, 11 Jun 2022 05:22:41 +0800
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
Message-ID: <202206110544.D5cTU0WQ-lkp@intel.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-7-yosryahmed@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
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
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220611/202206110544.D5cTU0WQ-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/83f297e2b47dc41b511f071b9eadf38339387b41
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 83f297e2b47dc41b511f071b9eadf38339387b41
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/cgroup/rstat.c:161:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     161 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~
>> kernel/cgroup/rstat.c:509:10: error: 'const struct btf_kfunc_id_set' has no member named 'sleepable_set'; did you mean 'release_set'?
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |          ^~~~~~~~~~~~~
         |          release_set
   kernel/cgroup/rstat.c:509:27: warning: excess elements in struct initializer
     509 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |                           ^
   kernel/cgroup/rstat.c:509:27: note: (near initialization for 'bpf_rstat_kfunc_set')


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
