Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF3A52FBFD
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiEULcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355539AbiEULcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:32:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B696817D39F;
        Sat, 21 May 2022 04:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653132423; x=1684668423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eSHQOnH8evDQZV/d9u1PVNuHXTx6c6o4uF+RXXCZ7Ic=;
  b=RRSQvvkV8q7Mw2nUXU9SO9Bs90FN/ioEP9ca8JO4m2x0V1aNddElnm6L
   Q/qHEaxN7i8S4GlVY9GyC10BPRZArbmbFEjkXy1Uezyx0wWPdFmj3JxGT
   w4N9r1GUxMgi2kI32ObNRR5j6nOp+4Ty5+d5ccZ7fMoHG2qzX4cj8JMQE
   7eAX35EBArbC5+oiCAp1GLYXZVGL4fhogoxlGAH/sibCRGC+YfALq1DuX
   vWjYXH5twcW2pJ3bACQV3SAtAHZjqC2Ar9ar2vjZP4PaaqNVhAE1h5dkc
   C+r4OoY6PX4bjpnj1dWkfGheQqWyQL3nyX4BbxqIglnoIFyQxMOEcfIzw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="260428045"
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="260428045"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 04:26:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="599742031"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2022 04:26:42 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsNFk-0006Eh-MW;
        Sat, 21 May 2022 11:26:36 +0000
Date:   Sat, 21 May 2022 19:26:22 +0800
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
Subject: Re: [PATCH bpf-next v1 1/5] cgroup: bpf: add a hook for bpf progs to
 attach to rstat flushing
Message-ID: <202205211930.7xTXJTBH-lkp@intel.com>
References: <20220520012133.1217211-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-2-yosryahmed@google.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
config: parisc-randconfig-r026-20220519 (https://download.01.org/0day-ci/archive/20220521/202205211930.7xTXJTBH-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/23c4c48fb35b084dc1173c7b9d23d4e6e1a084a3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220520-093041
        git checkout 23c4c48fb35b084dc1173c7b9d23d4e6e1a084a3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/cgroup/rstat.c:145:22: warning: no previous prototype for 'bpf_rstat_flush' [-Wmissing-prototypes]
     145 | __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
         |                      ^~~~~~~~~~~~~~~


vim +/bpf_rstat_flush +145 kernel/cgroup/rstat.c

   143	
   144	/* A hook for bpf stat collectors to attach to and flush their stats */
 > 145	__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
   146					     struct cgroup *parent, int cpu)
   147	{
   148	}
   149	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
