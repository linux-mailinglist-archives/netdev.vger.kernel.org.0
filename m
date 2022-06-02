Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE41653B1A2
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiFBBbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiFBBbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:31:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93FE131F00;
        Wed,  1 Jun 2022 18:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654133496; x=1685669496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EICTw4lRgz1GEwBE23gGkyRblMBsQMnEDRc0oqq4R58=;
  b=oIfVNUz+mlSurw/cgDrF0zzFCzBrNmgL83MCxU/0BlXaO7diLorH/yM9
   jBBjP7272xbd6pwve/A+d3UkwQn4Tkt0IF8CmVI5NIuQAwHZNFiCGIHyr
   Hb3qgg2rZS1IQcfWcazlAVJ7CugvqJ4A2Gav7JfBMtTcLFr/hbuvXrvDt
   lAd9jNuaOrxw/BMijhhlWwtBPP1qu0m1JdL4Zo33K3v4DVQRKMKZqyXP/
   UKO8GVJ2PB5mGutstOcKTezJWCNsndusdX8IZaxt+pPxOHEzSFilCwtMY
   IPMYaaF5H1Fvyt/TEZLb6h5e+ga6hX8X7flY5zhUuKkowzyKswlzreQ3p
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="257853196"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="257853196"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 18:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="577237992"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2022 18:31:32 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwZgR-0004cS-TC;
        Thu, 02 Jun 2022 01:31:31 +0000
Date:   Thu, 2 Jun 2022 09:30:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, rostedt@goodmis.org,
        jolsa@kernel.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <202206020957.KETjl2xP-lkp@intel.com>
References: <20220601175749.3071572-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601175749.3071572-6-song@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a006 (https://download.01.org/0day-ci/archive/20220602/202206020957.KETjl2xP-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/7edcf1c49617641579f2bc36b86c7d59bea20aef
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
        git checkout 7edcf1c49617641579f2bc36b86c7d59bea20aef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/bpf/trampoline.c: In function 'bpf_trampoline_lookup':
>> kernel/bpf/trampoline.c:101:17: error: 'struct ftrace_ops' has no member named 'ops_func'
     101 |         tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
         |                 ^~
   kernel/bpf/trampoline.c: In function 'bpf_trampoline_update':
>> kernel/bpf/trampoline.c:416:25: error: 'struct ftrace_ops' has no member named 'trampoline'
     416 |                 tr->fops->trampoline = 0;
         |                         ^~


vim +101 kernel/bpf/trampoline.c

    74	
    75	static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
    76	{
    77		struct bpf_trampoline *tr;
    78		struct hlist_head *head;
    79		int i;
    80	
    81		mutex_lock(&trampoline_mutex);
    82		head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
    83		hlist_for_each_entry(tr, head, hlist) {
    84			if (tr->key == key) {
    85				refcount_inc(&tr->refcnt);
    86				goto out;
    87			}
    88		}
    89		tr = kzalloc(sizeof(*tr), GFP_KERNEL);
    90		if (!tr)
    91			goto out;
    92		tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
    93		if (!tr->fops) {
    94			kfree(tr);
    95			tr = NULL;
    96			goto out;
    97		}
    98	
    99		tr->key = key;
   100		tr->fops->private = tr;
 > 101		tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
   102		INIT_HLIST_NODE(&tr->hlist);
   103		hlist_add_head(&tr->hlist, head);
   104		refcount_set(&tr->refcnt, 1);
   105		mutex_init(&tr->mutex);
   106		for (i = 0; i < BPF_TRAMP_MAX; i++)
   107			INIT_HLIST_HEAD(&tr->progs_hlist[i]);
   108	out:
   109		mutex_unlock(&trampoline_mutex);
   110		return tr;
   111	}
   112	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
