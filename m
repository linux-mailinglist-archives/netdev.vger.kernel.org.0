Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953E653B36A
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiFBGRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiFBGRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:17:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A912198;
        Wed,  1 Jun 2022 23:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654150642; x=1685686642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ooI4sWwbnlbAAJn+k1VaNoQTx4NFNgg+b47kaovZw28=;
  b=keXhzColze0ab9W2f9vaZOYgwIqvspKimGRUxSeERQliq5jQ9mKYjG2k
   pUA9hQwDfQo7CeGduRwm0hFrYMk09oDG8Y6c1WvfXXo7GV7W16ivH6ZGU
   hWHbXWjXmNOES/Wm4YCNKRpBwY8Xg9n5l489GkIQojgulYjGpHOtOvGBg
   52CwAEBdt3I5lYe3lAeIhtpV1CNbEQgTN8a7WQk+8JzPO4rL7HCsYEF2j
   6UJu5xubOX0nCNLH+7RHGFAunzx50hzmhH/BYlJYNPmj6uBk5z1FUZ0E1
   h9CLAqrNYFuiAAUM+9SRj6qXJbzECtwIJLBvm2xs7PxGv/PITnHkU2v+0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="257906700"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="257906700"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 23:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="563152976"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2022 23:17:12 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwe8u-0004mv-7k;
        Thu, 02 Jun 2022 06:17:12 +0000
Date:   Thu, 2 Jun 2022 14:16:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
Message-ID: <202206021403.M9hFZdbY-lkp@intel.com>
References: <20220601190218.2494963-4-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-4-sdf@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220602-050600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-a004 (https://download.01.org/0day-ci/archive/20220602/202206021403.M9hFZdbY-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b364c76683f8ef241025a9556300778c07b590c2)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/584b25fdd30894c312d577f4b6b83f93d64e464b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220602-050600
        git checkout 584b25fdd30894c312d577f4b6b83f93d64e464b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/bpf/cgroup.c:257:35: warning: overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
                                   if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
                                       ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/cgroup.c:252:35: warning: overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
                                   if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
                                       ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   2 warnings generated.


vim +257 kernel/bpf/cgroup.c

   226	
   227	/**
   228	 * cgroup_bpf_release() - put references of all bpf programs and
   229	 *                        release all cgroup bpf data
   230	 * @work: work structure embedded into the cgroup to modify
   231	 */
   232	static void cgroup_bpf_release(struct work_struct *work)
   233	{
   234		struct cgroup *p, *cgrp = container_of(work, struct cgroup,
   235						       bpf.release_work);
   236		struct bpf_prog_array *old_array;
   237		struct list_head *storages = &cgrp->bpf.storages;
   238		struct bpf_cgroup_storage *storage, *stmp;
   239	
   240		unsigned int atype;
   241	
   242		mutex_lock(&cgroup_mutex);
   243	
   244		for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
   245			struct hlist_head *progs = &cgrp->bpf.progs[atype];
   246			struct bpf_prog_list *pl;
   247			struct hlist_node *pltmp;
   248	
   249			hlist_for_each_entry_safe(pl, pltmp, progs, node) {
   250				hlist_del(&pl->node);
   251				if (pl->prog) {
   252					if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
   253						bpf_trampoline_unlink_cgroup_shim(pl->prog);
   254					bpf_prog_put(pl->prog);
   255				}
   256				if (pl->link) {
 > 257					if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
   258						bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
   259					bpf_cgroup_link_auto_detach(pl->link);
   260				}
   261				kfree(pl);
   262				static_branch_dec(&cgroup_bpf_enabled_key[atype]);
   263			}
   264			old_array = rcu_dereference_protected(
   265					cgrp->bpf.effective[atype],
   266					lockdep_is_held(&cgroup_mutex));
   267			bpf_prog_array_free(old_array);
   268		}
   269	
   270		list_for_each_entry_safe(storage, stmp, storages, list_cg) {
   271			bpf_cgroup_storage_unlink(storage);
   272			bpf_cgroup_storage_free(storage);
   273		}
   274	
   275		mutex_unlock(&cgroup_mutex);
   276	
   277		for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
   278			cgroup_bpf_put(p);
   279	
   280		percpu_ref_exit(&cgrp->bpf.refcnt);
   281		cgroup_put(cgrp);
   282	}
   283	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
