Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6201547258
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 08:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243048AbiFKGYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 02:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiFKGYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 02:24:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20C02314D;
        Fri, 10 Jun 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654928650; x=1686464650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nq1Y7M1o0QIJ3J1LnJ2FgHo85YT5uJzjeELR5R/ykZg=;
  b=dh7Mqce11fUD3PKJEfigVbnDcvLx/mCXDS9GfeHOohCe82VLbrrY4r2e
   z5jvDC7MMbmFjrFPK5nO/sAGbWe9Xkwe6iqqqAHaMuj8JGZCqDKIeWtZS
   t4VbjWX/RROgh1HDZGwWn2fMcopgTPJU0ILGhsF7620oCXdnX4xVV/BML
   LC4PI/kLYOV4QQABIvXuzSNuFK9KYJONHiwKgeNBL3u4WijCZZDCm6xAp
   CxCuzDiCOEeBuyq0nmay5w3aa/ITqVXyw50uCMtMRLG6frpRoQ3zl2XlI
   1TkUQTqdEEub+LqRgLZXWfw8CDaB8HlTxcHBoUPnZwFisMUTsMOGwOly6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278959580"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="278959580"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 23:24:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="650271408"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jun 2022 23:24:04 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzuXU-000Ibx-12;
        Sat, 11 Jun 2022 06:24:04 +0000
Date:   Sat, 11 Jun 2022 14:23:39 +0800
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
Message-ID: <202206111453.xWWh2wMK-lkp@intel.com>
References: <20220610194435.2268290-5-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610194435.2268290-5-yosryahmed@google.com>
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yosry-Ahmed/bpf-rstat-cgroup-hierarchical-stats/20220611-034720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20220611/202206111453.xWWh2wMK-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash kernel/bpf/ kernel/cgroup/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from kernel/bpf/cgroup_iter.c:9:
   kernel/bpf/../cgroup/cgroup-internal.h:78:41: error: field 'iter' has incomplete type
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
   kernel/bpf/cgroup_iter.c:55:24: error: implicit declaration of function 'css_next_descendant_pre' [-Werror=implicit-function-declaration]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/cgroup_iter.c:55:24: warning: returning 'int' from a function with return type 'void *' makes pointer from integer without a cast [-Wint-conversion]
      55 |                 return css_next_descendant_pre(NULL, p->start_css);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup_iter.c:57:24: error: implicit declaration of function 'css_next_descendant_post' [-Werror=implicit-function-declaration]
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
   kernel/bpf/cgroup_iter.c:87:28: error: invalid use of undefined type 'struct cgroup_subsys_state'
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
   kernel/bpf/cgroup_iter.c:137:29: error: invalid use of undefined type 'struct cgroup'
     137 |         p->start_css = &cgrp->self;
         |                             ^~
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_attach_cgroup':
   kernel/bpf/cgroup_iter.c:157:24: error: implicit declaration of function 'cgroup_get_from_fd'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                        ^~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
>> kernel/bpf/cgroup_iter.c:157:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     157 |                 cgrp = cgroup_get_from_fd(fd);
         |                      ^
   kernel/bpf/cgroup_iter.c:159:24: error: implicit declaration of function 'cgroup_get_from_path'; did you mean 'cgroup_get_from_id'? [-Werror=implicit-function-declaration]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                        ^~~~~~~~~~~~~~~~~~~~
         |                        cgroup_get_from_id
   kernel/bpf/cgroup_iter.c:159:22: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     159 |                 cgrp = cgroup_get_from_path("/");
         |                      ^
   kernel/bpf/cgroup_iter.c: In function 'bpf_iter_cgroup_show_fdinfo':
   kernel/bpf/cgroup_iter.c:190:9: error: implicit declaration of function 'cgroup_path_ns'; did you mean 'cgroup_parent'? [-Werror=implicit-function-declaration]
     190 |         cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
         |         ^~~~~~~~~~~~~~
         |         cgroup_parent
   kernel/bpf/cgroup_iter.c: In function 'cgroup_iter_seq_next':
   kernel/bpf/cgroup_iter.c:88:1: error: control reaches end of non-void function [-Werror=return-type]
      88 | }
         | ^
   cc1: some warnings being treated as errors


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
