Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D524F0B08
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359315AbiDCQCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359307AbiDCQCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 12:02:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A4F3980E;
        Sun,  3 Apr 2022 09:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649001638; x=1680537638;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qvHYdvxr81dj6BSTtdc044toQ4oANBTAS7xvEFGuayI=;
  b=lgX3zuPsEyQ2cveb8kTh0NN+IR9or3qvf8xtw1YERTPWDrY7zaIvVuwp
   wfZxaDWRVY8AhrST2o2Y/RhXm+0Bi2hIIW3S/F1p9ftMSq2tpC2t878hv
   JC9/fXFMba13awo+JwrZ6CR1Hxl9O/1cME+kMoKgM3PLWtOZfYshCRSz5
   MZQ9YfDCg/prYshujp4TjIcSJ6xE9c4yqfBJpVMmxDkWvLILfsAX++P0/
   00OBhz1gZ2V75QuyI7IwPbC2LZyEzlFQmoHvdO2AZ+J6fWkoQP2Fw6cbM
   Uwq0xVx3s8kVFYop/dz+H12RXjpz69rzU3UrTed+ZQaJPZUeDdU9VhlHX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="260381423"
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="260381423"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 09:00:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="607767948"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 03 Apr 2022 09:00:33 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nb2eW-00014e-Ru;
        Sun, 03 Apr 2022 16:00:32 +0000
Date:   Sun, 3 Apr 2022 23:59:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bui Quang Minh <minhquangbui99@gmail.com>, cgroups@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] cgroup: Kill the parent controller when its last child
 is killed
Message-ID: <202204032330.l2wsF3mf-lkp@intel.com>
References: <20220403135717.8294-1-minhquangbui99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403135717.8294-1-minhquangbui99@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bui,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tj-cgroup/for-next]
[also build test ERROR on v5.17 next-20220401]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Bui-Quang-Minh/cgroup-Kill-the-parent-controller-when-its-last-child-is-killed/20220403-215911
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20220403/202204032330.l2wsF3mf-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2bc22feae8a913c7f371bc79ef9967122d8d326c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bui-Quang-Minh/cgroup-Kill-the-parent-controller-when-its-last-child-is-killed/20220403-215911
        git checkout 2bc22feae8a913c7f371bc79ef9967122d8d326c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/cgroup/cgroup.c: In function 'css_release_work_fn':
>> kernel/cgroup/cgroup.c:5169:52: error: 'struct cgroup_bpf' has no member named 'refcnt'
    5169 |                 if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
         |                                                    ^


vim +5169 kernel/cgroup/cgroup.c

  5148	
  5149	static void css_release_work_fn(struct work_struct *work)
  5150	{
  5151		struct cgroup_subsys_state *css =
  5152			container_of(work, struct cgroup_subsys_state, destroy_work);
  5153		struct cgroup_subsys *ss = css->ss;
  5154		struct cgroup *cgrp = css->cgroup;
  5155		struct cgroup *parent = cgroup_parent(cgrp);
  5156	
  5157		mutex_lock(&cgroup_mutex);
  5158	
  5159		css->flags |= CSS_RELEASED;
  5160		list_del_rcu(&css->sibling);
  5161	
  5162		/*
  5163		 * If parent doesn't have any children, start killing it.
  5164		 * And don't kill the default root.
  5165		 */
  5166		if (parent && list_empty(&parent->self.children) &&
  5167		    parent != &cgrp_dfl_root.cgrp &&
  5168		    !percpu_ref_is_dying(&parent->self.refcnt)) {
> 5169			if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
  5170				cgroup_bpf_offline(parent);
  5171			percpu_ref_kill(&parent->self.refcnt);
  5172		}
  5173	
  5174		if (ss) {
  5175			/* css release path */
  5176			if (!list_empty(&css->rstat_css_node)) {
  5177				cgroup_rstat_flush(cgrp);
  5178				list_del_rcu(&css->rstat_css_node);
  5179			}
  5180	
  5181			cgroup_idr_replace(&ss->css_idr, NULL, css->id);
  5182			if (ss->css_released)
  5183				ss->css_released(css);
  5184		} else {
  5185			struct cgroup *tcgrp;
  5186	
  5187			/* cgroup release path */
  5188			TRACE_CGROUP_PATH(release, cgrp);
  5189	
  5190			cgroup_rstat_flush(cgrp);
  5191	
  5192			spin_lock_irq(&css_set_lock);
  5193			for (tcgrp = cgroup_parent(cgrp); tcgrp;
  5194			     tcgrp = cgroup_parent(tcgrp))
  5195				tcgrp->nr_dying_descendants--;
  5196			spin_unlock_irq(&css_set_lock);
  5197	
  5198			/*
  5199			 * There are two control paths which try to determine
  5200			 * cgroup from dentry without going through kernfs -
  5201			 * cgroupstats_build() and css_tryget_online_from_dir().
  5202			 * Those are supported by RCU protecting clearing of
  5203			 * cgrp->kn->priv backpointer.
  5204			 */
  5205			if (cgrp->kn)
  5206				RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv,
  5207						 NULL);
  5208		}
  5209	
  5210		mutex_unlock(&cgroup_mutex);
  5211	
  5212		INIT_RCU_WORK(&css->destroy_rwork, css_free_rwork_fn);
  5213		queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);
  5214	}
  5215	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
