Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D854749A
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 14:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiFKMpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 08:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiFKMpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 08:45:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B97F434BB;
        Sat, 11 Jun 2022 05:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654951520; x=1686487520;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ldP9g6TIbYFe/+aBJarIY4pGbC4vrVIwVDj0RxIrnC4=;
  b=Sq6BbyDjVrg7Pjt48lkjMV7UxqlUo2spVlBBncVMt0wy2lfUZrm9drVr
   WxCgIqn6EhfJMGmezlK1N8W9wVoZFY7Yiu9zj3R9R4KlIQhEZVnm0XvR2
   uy/6FceasMs2Pitoyo+Krer9bCSBCTSkCfzaUHAyLs7l8vNlC48REQHw+
   lzV8kUYaZVBT1VbUAY4dNKN/YMgywWm/euhcmSjCTV52ra4HgpyqztWxm
   pBtdLrokV8hx12A1unS/tdgyVpMuYp3sfP8uiLMNYhPyY2esXX3i0OPSA
   t4FZISZvTFgmo4+WcYyCjKykEkIEQWnDqblD8dthJpr0dtIc4sMbGvkka
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="277917976"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="277917976"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 05:45:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="909453396"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jun 2022 05:45:14 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o00UL-000Iu3-Rn;
        Sat, 11 Jun 2022 12:45:13 +0000
Date:   Sat, 11 Jun 2022 20:44:57 +0800
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
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Message-ID: <202206112009.sycCJKhv-lkp@intel.com>
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-randconfig-r035-20220611 (https://download.01.org/0day-ci/archive/20220611/202206112009.sycCJKhv-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/619857fd1ec4f351376ffcaaec20acc9aae9486f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
        git checkout 619857fd1ec4f351376ffcaaec20acc9aae9486f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash kernel/bpf/ kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:78:24: error: field has incomplete type 'struct css_task_iter'
                   struct css_task_iter    iter;
                                           ^
   kernel/bpf/../cgroup/cgroup-internal.h:78:10: note: forward declaration of 'struct css_task_iter'
                   struct css_task_iter    iter;
                          ^
   kernel/bpf/../cgroup/cgroup-internal.h:188:15: error: incomplete definition of type 'struct cgroup'
           return !(cgrp->self.flags & CSS_ONLINE);
                    ~~~~^
   include/linux/sched/task.h:35:9: note: forward declaration of 'struct cgroup'
           struct cgroup *cgrp;
                  ^
   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:188:30: error: use of undeclared identifier 'CSS_ONLINE'; did you mean 'N_ONLINE'?
           return !(cgrp->self.flags & CSS_ONLINE);
                                       ^~~~~~~~~~
                                       N_ONLINE
   include/linux/nodemask.h:392:2: note: 'N_ONLINE' declared here
           N_ONLINE,               /* The node is online */
           ^
   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:193:47: error: incomplete definition of type 'struct cgroup'
           return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
                                                    ~~~~^
   include/linux/sched/task.h:35:9: note: forward declaration of 'struct cgroup'
           struct cgroup *cgrp;
                  ^
   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:193:18: error: use of undeclared identifier 'CGRP_NOTIFY_ON_RELEASE'
           return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
                           ^
   kernel/bpf/../cgroup/cgroup-internal.h:207:32: error: incomplete definition of type 'struct css_set'
           if (refcount_dec_not_one(&cset->refcount))
                                     ~~~~^
   include/linux/sched/task.h:16:8: note: forward declaration of 'struct css_set'
   struct css_set;
          ^
   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:220:20: error: incomplete definition of type 'struct css_set'
           refcount_inc(&cset->refcount);
                         ~~~~^
   include/linux/sched/task.h:16:8: note: forward declaration of 'struct css_set'
   struct css_set;
          ^
   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:284:40: error: array has incomplete element type 'struct cftype'
   extern struct cftype cgroup1_base_files[];
                                          ^
   kernel/bpf/../cgroup/cgroup-internal.h:284:15: note: forward declaration of 'struct cftype'
   extern struct cftype cgroup1_base_files[];
                 ^
   kernel/bpf/cgroup_iter.c:55:10: error: call to undeclared function 'css_next_descendant_pre'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return css_next_descendant_pre(NULL, p->start_css);
                          ^
>> kernel/bpf/cgroup_iter.c:55:10: warning: incompatible integer to pointer conversion returning 'int' from a function with result type 'void *' [-Wint-conversion]
                   return css_next_descendant_pre(NULL, p->start_css);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:57:10: error: call to undeclared function 'css_next_descendant_post'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return css_next_descendant_post(NULL, p->start_css);
                          ^
   kernel/bpf/cgroup_iter.c:57:10: warning: incompatible integer to pointer conversion returning 'int' from a function with result type 'void *' [-Wint-conversion]
                   return css_next_descendant_post(NULL, p->start_css);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:83:10: error: call to undeclared function 'css_next_descendant_pre'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return css_next_descendant_pre(curr, p->start_css);
                          ^
   kernel/bpf/cgroup_iter.c:83:10: warning: incompatible integer to pointer conversion returning 'int' from a function with result type 'void *' [-Wint-conversion]
                   return css_next_descendant_pre(curr, p->start_css);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:85:10: error: call to undeclared function 'css_next_descendant_post'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return css_next_descendant_post(curr, p->start_css);
                          ^
   kernel/bpf/cgroup_iter.c:85:10: warning: incompatible integer to pointer conversion returning 'int' from a function with result type 'void *' [-Wint-conversion]
                   return css_next_descendant_post(curr, p->start_css);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:87:14: error: incomplete definition of type 'struct cgroup_subsys_state'
                   return curr->parent;
                          ~~~~^
   include/linux/kthread.h:218:8: note: forward declaration of 'struct cgroup_subsys_state'
   struct cgroup_subsys_state;
          ^
   kernel/bpf/cgroup_iter.c:100:31: error: incomplete definition of type 'struct cgroup_subsys_state'
           if (css && cgroup_is_dead(css->cgroup))
                                     ~~~^
   include/linux/kthread.h:218:8: note: forward declaration of 'struct cgroup_subsys_state'
   struct cgroup_subsys_state;
          ^
   kernel/bpf/cgroup_iter.c:104:24: error: incomplete definition of type 'struct cgroup_subsys_state'
           ctx.cgroup = css ? css->cgroup : NULL;
                              ~~~^
   include/linux/kthread.h:218:8: note: forward declaration of 'struct cgroup_subsys_state'
   struct cgroup_subsys_state;
          ^
   kernel/bpf/cgroup_iter.c:137:22: error: incomplete definition of type 'struct cgroup'
           p->start_css = &cgrp->self;
                           ~~~~^
   include/linux/sched/task.h:35:9: note: forward declaration of 'struct cgroup'
           struct cgroup *cgrp;
                  ^
   kernel/bpf/cgroup_iter.c:157:10: error: call to undeclared function 'cgroup_get_from_fd'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   cgrp = cgroup_get_from_fd(fd);
                          ^
   kernel/bpf/cgroup_iter.c:157:10: note: did you mean 'cgroup_get_from_id'?
   include/linux/cgroup.h:756:30: note: 'cgroup_get_from_id' declared here
   static inline struct cgroup *cgroup_get_from_id(u64 id)
                                ^
>> kernel/bpf/cgroup_iter.c:157:8: warning: incompatible integer to pointer conversion assigning to 'struct cgroup *' from 'int' [-Wint-conversion]
                   cgrp = cgroup_get_from_fd(fd);
                        ^ ~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:159:10: error: call to undeclared function 'cgroup_get_from_path'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   cgrp = cgroup_get_from_path("/");
                          ^
   kernel/bpf/cgroup_iter.c:159:8: warning: incompatible integer to pointer conversion assigning to 'struct cgroup *' from 'int' [-Wint-conversion]
                   cgrp = cgroup_get_from_path("/");
                        ^ ~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:190:2: error: call to undeclared function 'cgroup_path_ns'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
           ^
   kernel/bpf/cgroup_iter.c:190:2: note: did you mean 'cgroup_parent'?
   include/linux/cgroup.h:732:30: note: 'cgroup_parent' declared here
   static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
                                ^
   6 warnings and 19 errors generated.


vim +55 kernel/bpf/cgroup_iter.c

    41	
    42	static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
    43	{
    44		struct cgroup_iter_priv *p = seq->private;
    45	
    46		mutex_lock(&cgroup_mutex);
    47	
    48		/* support only one session */
    49		if (*pos > 0)
    50			return NULL;
    51	
    52		++*pos;
    53		p->terminate = false;
    54		if (p->order == BPF_ITER_CGROUP_PRE)
  > 55			return css_next_descendant_pre(NULL, p->start_css);
    56		else if (p->order == BPF_ITER_CGROUP_POST)
    57			return css_next_descendant_post(NULL, p->start_css);
    58		else /* BPF_ITER_CGROUP_PARENT_UP */
    59			return p->start_css;
    60	}
    61	
    62	static int __cgroup_iter_seq_show(struct seq_file *seq,
    63					  struct cgroup_subsys_state *css, int in_stop);
    64	
    65	static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
    66	{
    67		/* pass NULL to the prog for post-processing */
    68		if (!v)
    69			__cgroup_iter_seq_show(seq, NULL, true);
    70		mutex_unlock(&cgroup_mutex);
    71	}
    72	
    73	static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
    74	{
    75		struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
    76		struct cgroup_iter_priv *p = seq->private;
    77	
    78		++*pos;
    79		if (p->terminate)
    80			return NULL;
    81	
    82		if (p->order == BPF_ITER_CGROUP_PRE)
    83			return css_next_descendant_pre(curr, p->start_css);
    84		else if (p->order == BPF_ITER_CGROUP_POST)
    85			return css_next_descendant_post(curr, p->start_css);
    86		else
    87			return curr->parent;
    88	}
    89	
    90	static int __cgroup_iter_seq_show(struct seq_file *seq,
    91					  struct cgroup_subsys_state *css, int in_stop)
    92	{
    93		struct cgroup_iter_priv *p = seq->private;
    94		struct bpf_iter__cgroup ctx;
    95		struct bpf_iter_meta meta;
    96		struct bpf_prog *prog;
    97		int ret = 0;
    98	
    99		/* cgroup is dead, skip this element */
   100		if (css && cgroup_is_dead(css->cgroup))
   101			return 0;
   102	
   103		ctx.meta = &meta;
   104		ctx.cgroup = css ? css->cgroup : NULL;
   105		meta.seq = seq;
   106		prog = bpf_iter_get_info(&meta, in_stop);
   107		if (prog)
   108			ret = bpf_iter_run_prog(prog, &ctx);
   109	
   110		/* if prog returns > 0, terminate after this element. */
   111		if (ret != 0)
   112			p->terminate = true;
   113	
   114		return 0;
   115	}
   116	
   117	static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
   118	{
   119		return __cgroup_iter_seq_show(seq, (struct cgroup_subsys_state *)v,
   120					      false);
   121	}
   122	
   123	static const struct seq_operations cgroup_iter_seq_ops = {
   124		.start  = cgroup_iter_seq_start,
   125		.next   = cgroup_iter_seq_next,
   126		.stop   = cgroup_iter_seq_stop,
   127		.show   = cgroup_iter_seq_show,
   128	};
   129	
   130	BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
   131	
   132	static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
   133	{
   134		struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
   135		struct cgroup *cgrp = aux->cgroup.start;
   136	
   137		p->start_css = &cgrp->self;
   138		p->terminate = false;
   139		p->order = aux->cgroup.order;
   140		return 0;
   141	}
   142	
   143	static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
   144		.seq_ops                = &cgroup_iter_seq_ops,
   145		.init_seq_private       = cgroup_iter_seq_init,
   146		.seq_priv_size          = sizeof(struct cgroup_iter_priv),
   147	};
   148	
   149	static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
   150					  union bpf_iter_link_info *linfo,
   151					  struct bpf_iter_aux_info *aux)
   152	{
   153		int fd = linfo->cgroup.cgroup_fd;
   154		struct cgroup *cgrp;
   155	
   156		if (fd)
 > 157			cgrp = cgroup_get_from_fd(fd);
   158		else /* walk the entire hierarchy by default. */
   159			cgrp = cgroup_get_from_path("/");
   160	
   161		if (IS_ERR(cgrp))
   162			return PTR_ERR(cgrp);
   163	
   164		aux->cgroup.start = cgrp;
   165		aux->cgroup.order = linfo->cgroup.traversal_order;
   166		return 0;
   167	}
   168	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
