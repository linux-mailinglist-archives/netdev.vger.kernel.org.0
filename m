Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A404EA30E
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiC1WiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiC1WiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:38:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CD847558;
        Mon, 28 Mar 2022 15:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648506994; x=1680042994;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h6uHH+d5+1Fugxmpop26tUT1sG4ehI8XA3zeXILOQhw=;
  b=QxwlaBcrdOGFe3LFTgEVpVn4CrJKfiM2eeanUPQUfTVOf2ThYiNJNysz
   6Ju41G6KNAuGfjScB+QixK0GNk/RV96B1E52fDfmX75eLGpQViv4MnfBD
   F1RAwc9E29FD7eXAy/6pn+srcf1C1xYaoP3RMy3e4dewqZqOjhrAt6qf4
   CpSTgt5rvnNQLkJ8b6FIMkI0gsfL15qY4v9SYotC8ZyGfUlTUmUh3Vjvu
   RYgOeCjS1bna909HT+SqHhWacNlGMIwMPUqCsAsn7eXLkqImdCYyYW3XA
   K9baQCyK6wRWa9idxh+wwsNMLBT++vNjM2npM5oQWgblxy/d1Fsy9ar17
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="259085132"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="259085132"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 15:36:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="639119399"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Mar 2022 15:36:31 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nYxyR-0002NB-04; Mon, 28 Mar 2022 22:36:31 +0000
Date:   Tue, 29 Mar 2022 06:36:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202203290625.2evhIzSX-lkp@intel.com>
References: <20220328181644.1748789-3-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328181644.1748789-3-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220329-021809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220329/202203290625.2evhIzSX-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cf70645346b1affcc956902a44671c1d0eaa451a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220329-021809
        git checkout cf70645346b1affcc956902a44671c1d0eaa451a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/bpf_lsm.c: In function '__cgroup_bpf_run_lsm_socket':
>> kernel/bpf/bpf_lsm.c:49:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      49 |         sock = (void *)regs[BPF_REG_0];
         |                ^


vim +49 kernel/bpf/bpf_lsm.c

    37	
    38	static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
    39							const struct bpf_insn *insn)
    40	{
    41		const struct bpf_prog *prog;
    42		struct socket *sock;
    43		struct cgroup *cgrp;
    44		struct sock *sk;
    45		int ret = 0;
    46		u64 *regs;
    47	
    48		regs = (u64 *)ctx;
  > 49		sock = (void *)regs[BPF_REG_0];
    50		/*prog = container_of(insn, struct bpf_prog, insnsi);*/
    51		prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
    52	
    53		if (unlikely(!sock))
    54			return 0;
    55	
    56		sk = sock->sk;
    57		if (unlikely(!sk))
    58			return 0;
    59	
    60		cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
    61		if (likely(cgrp))
    62			ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
    63						    ctx, bpf_prog_run, 0);
    64		return ret;
    65	}
    66	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
