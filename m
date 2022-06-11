Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260985472AA
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 09:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiFKHfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 03:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiFKHfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 03:35:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BFDE8B88;
        Sat, 11 Jun 2022 00:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654932914; x=1686468914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O40TrZUlRL9YzE746VelewMzcK6KC/tvdxPq5f4zq6Q=;
  b=IlXY07rQmWWebaBmjfdU4WCf0emKEG92U13+9Tu/dGTM/QXTKz/CAcCI
   cUwbU8DDFnhztoi4uPt+h67RLgtmDbb98iLlmxdpAew6wXdrUYhsE6/Ys
   BFSE7Ph2CaRDdx1xvfn+WsyJOCYpdNFMwkn8NWcxoIFLcPLY31wwK+4s+
   QCd5Uffft9q4aGz269uUY0yvNgGkr6hP5Qd/ybYRMId7D/cEcUTScCENx
   z4C7yqIlaIPfvv3ENa7GeRXjfCvUPxDJDzwbTs+c4FmBZLCogLR8FEYbV
   Pn9vqFkNEboSZaXKmLfJn1XbC1JU26tZewti6RCh4/826aKybCNmFzsQy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275375455"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="275375455"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 00:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="611055537"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 11 Jun 2022 00:35:07 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzveF-000Iht-4o;
        Sat, 11 Jun 2022 07:35:07 +0000
Date:   Sat, 11 Jun 2022 15:34:50 +0800
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
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Message-ID: <202206111529.2okIVRo9-lkp@intel.com>
References: <20220610194435.2268290-5-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-5-yosryahmed@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20220611/202206111529.2okIVRo9-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/619857fd1ec4f351376ffcaaec20acc9aae9486f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 619857fd1ec4f351376ffcaaec20acc9aae9486f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/bpf/cgroup_iter.c:9:
>> kernel/bpf/../cgroup/cgroup-internal.h:78:41: error: field 'iter' has incomplete type
      78 |                 struct css_task_iter    iter;
         |                                         ^~~~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'cgroup_is_dead':
   kernel/bpf/../cgroup/cgroup-internal.h:188:22: error: invalid use of undefined type 'const struct cgroup'
     188 |         return !(cgrp->self.flags & CSS_ONLINE);
         |                      ^~
   kernel/bpf/../cgroup/cgroup-internal.h:188:37: error: 'CSS_ONLINE' undeclared (first use in this function); did you mean 'N_ONLINE'?
     188 |         return !(cgrp->self.flags & CSS_ONLINE);
         |                                     ^~~~~~~~~~
         |                                     N_ONLINE
   kernel/bpf/../cgroup/cgroup-internal.h:188:37: note: each undeclared identifier is reported only once for each function it appears in
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'notify_on_release':
   kernel/bpf/../cgroup/cgroup-internal.h:193:25: error: 'CGRP_NOTIFY_ON_RELEASE' undeclared (first use in this function)
     193 |         return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
         |                         ^~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/../cgroup/cgroup-internal.h:193:54: error: invalid use of undefined type 'const struct cgroup'
     193 |         return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
         |                                                      ^~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'put_css_set':
   kernel/bpf/../cgroup/cgroup-internal.h:207:39: error: invalid use of undefined type 'struct css_set'
     207 |         if (refcount_dec_not_one(&cset->refcount))
         |                                       ^~
   kernel/bpf/../cgroup/cgroup-internal.h: In function 'get_css_set':
   kernel/bpf/../cgroup/cgroup-internal.h:220:27: error: invalid use of undefined type 'struct css_set'
     220 |         refcount_inc(&cset->refcount);
         |                           ^~
   kernel/bpf/../cgroup/cgroup-internal.h: At top level:
   kernel/bpf/../cgroup/cgroup-internal.h:284:22: error: array type has incomplete element type 'struct cftype'
     284 | extern struct cftype cgroup1_base_files[];
         |                      ^~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_start':
>> kernel/bpf/cgroup_iter.c:55:24: error: implicit declaration of function 'css_next_descendant_pre' [-Werror=implicit-function-declaration]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:55:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:57:24: error: implicit declaration of function 'css_next_descendant_post' [-Werror=implicit-function-declaration]
      57 |                 return css_next_descendant_post(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:57:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      57 |                 return css_next_descendant_post(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_next':
   kernel/bpf/cgroup_iter.c:83:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      83 |                 return css_next_descendant_pre(curr, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:85:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      85 |                 return css_next_descendant_post(curr, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:87:28: error: invalid use of undefined type 'struct cgroup_subsys_state'
      87 |                 return curr->parent;
         |                            ^~
   kernel/bpf/cgroup_iter.c: In function '__cgroup_iter_seq_show':
   kernel/bpf/cgroup_iter.c:100:38: error: invalid use of undefined type 'struct cgroup_subsys_state'
     100 |         if (css && cgroup_is_dead(css->cgroup))
         |                                      ^~
   kernel/bpf/cgroup_iter.c:104:31: error: invalid use of undefined type 'struct cgroup_subsys_state'
     104 |         ctx.cgroup = css ? css->cgroup : NULL;
         |                               ^~
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_init':
>> kernel/bpf/cgroup_iter.c:137:29: error: invalid use of undefined type 'struct cgroup'
     137 |         p->start_css = &cgrp->self;
         |                             ^~
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_attach_cgroup':
>> kernel/bpf/cgroup_iter.c:157:24: error: implicit declaration of function 'cgroup_get_from_fd'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                        ^~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
   kernel/bpf/cgroup_iter.c:157:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                      ^
>> kernel/bpf/cgroup_iter.c:159:24: error: implicit declaration of function 'cgroup_get_from_path'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                        ^~~~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
   kernel/bpf/cgroup_iter.c:159:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                      ^
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_cgroup_show_fdinfo':
>> kernel/bpf/cgroup_iter.c:190:9: error: implicit declaration of function 'cgroup_path_ns'; did you mean 'cgroup_parent'? [-Werror=implicit-function-declaration]
     190 |         cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
         |         ^~~~~~~~~~~~~~
         |         cgroup_parent
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_next':
   kernel/bpf/cgroup_iter.c:88:1: error: control reaches end of non-void function [-Werror=return-type]
      88 | }
         | ^
   cc1: some warnings being treated as errors


vim +/iter +78 kernel/bpf/../cgroup/cgroup-internal.h

0d2b5955b36250 Tejun Heo 2022-01-06  68  
0d2b5955b36250 Tejun Heo 2022-01-06  69  struct cgroup_file_ctx {
e57457641613fe Tejun Heo 2022-01-06  70  	struct cgroup_namespace	*ns;
e57457641613fe Tejun Heo 2022-01-06  71  
0d2b5955b36250 Tejun Heo 2022-01-06  72  	struct {
0d2b5955b36250 Tejun Heo 2022-01-06  73  		void			*trigger;
0d2b5955b36250 Tejun Heo 2022-01-06  74  	} psi;
0d2b5955b36250 Tejun Heo 2022-01-06  75  
0d2b5955b36250 Tejun Heo 2022-01-06  76  	struct {
0d2b5955b36250 Tejun Heo 2022-01-06  77  		bool			started;
0d2b5955b36250 Tejun Heo 2022-01-06 @78  		struct css_task_iter	iter;
0d2b5955b36250 Tejun Heo 2022-01-06  79  	} procs;
0d2b5955b36250 Tejun Heo 2022-01-06  80  
0d2b5955b36250 Tejun Heo 2022-01-06  81  	struct {
0d2b5955b36250 Tejun Heo 2022-01-06  82  		struct cgroup_pidlist	*pidlist;
0d2b5955b36250 Tejun Heo 2022-01-06  83  	} procs1;
0d2b5955b36250 Tejun Heo 2022-01-06  84  };
0d2b5955b36250 Tejun Heo 2022-01-06  85  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
