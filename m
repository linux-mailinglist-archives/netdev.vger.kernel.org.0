Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA5A52FC32
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244945AbiEULrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiEULro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:47:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE6F5F254;
        Sat, 21 May 2022 04:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653133663; x=1684669663;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5JYbmecEfaojoV0o0RHmSf31Bg5PL/dcrqKwNqVLbR8=;
  b=fogFnyJFdEebJI8H2OgOkFQ0UFIgy9W9qeo3iOSn7/qZMC3EcdI9Qume
   fBjLgY2Y1XR335zRJtHM3Mb/hf1iWAl+TJKU7S5SrtJU2wDuQHVHQ5RDB
   bHxVOxJYqY3pm3w2U4PnKocYRT9ocdHE/ym2PfbSA6LjRmARdGp9G97WJ
   E7zjZvY8mvVRtXunU5xMketKTN5feacevLQGopS3CvrK4sfJWk7SrgNYk
   kqaG3lUuiG/100eEAOoRRsAuhL2POkpHA2WQVqfkbvbvCcNNEa11hHO2E
   G2ka7Hho339v/ORoJVIXnhHrrS+BtbQ+36H+d+ai5bZcSOIxOMuyNj5Py
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272819376"
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="272819376"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 04:47:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="557873765"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 21 May 2022 04:47:38 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsNa5-0006Fa-L8;
        Sat, 21 May 2022 11:47:37 +0000
Date:   Sat, 21 May 2022 19:47:07 +0800
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
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     kbuild-all@lists.01.org, Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Message-ID: <202205211913.wPnVDaPm-lkp@intel.com>
References: <20220520012133.1217211-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-3-yosryahmed@google.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yosry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220520-093041
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220521/202205211913.wPnVDaPm-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/203797424b1159b12702cea9d9a20acc24ea92e0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220520-093041
        git checkout 203797424b1159b12702cea9d9a20acc24ea92e0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/cgroup/rstat.c:155:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     155 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~
   kernel/cgroup/rstat.c:503:10: error: 'const struct btf_kfunc_id_set' has no member named 'sleepable_set'; did you mean 'release_set'?
     503 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |          ^~~~~~~~~~~~~
         |          release_set
>> kernel/cgroup/rstat.c:503:27: warning: excess elements in struct initializer
     503 |         .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
         |                           ^
   kernel/cgroup/rstat.c:503:27: note: (near initialization for 'bpf_rstat_kfunc_set')


vim +503 kernel/cgroup/rstat.c

   499	
   500	static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
   501		.owner		= THIS_MODULE,
   502		.check_set	= &bpf_rstat_check_kfunc_ids,
 > 503		.sleepable_set	= &bpf_rstat_sleepable_kfunc_ids,
   504	};
   505	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
