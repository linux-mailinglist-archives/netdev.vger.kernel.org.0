Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F167845F61E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbhKZVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:01:33 -0500
Received: from mga18.intel.com ([134.134.136.126]:35263 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233512AbhKZU7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 15:59:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="222587285"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="222587285"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 12:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="539369728"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 26 Nov 2021 12:56:16 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqiGV-0008aY-M1; Fri, 26 Nov 2021 20:56:15 +0000
Date:   Sat, 27 Nov 2021 04:55:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
Message-ID: <202111270414.XuXZgoE5-lkp@intel.com>
References: <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Paolo-Abeni/bpf-do-not-WARN-in-bpf_warn_invalid_xdp_action/20211126-192252
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 35bf8c86eeb8ae609f61c43aeab3b530fedcf1b4
config: riscv-randconfig-r036-20211126 (https://download.01.org/0day-ci/archive/20211127/202111270414.XuXZgoE5-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 5162b558d8c0b542e752b037e72a69d5fd51eb1e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/afb829c16c3bd86f86b24c880601cea9e21c5d3e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Paolo-Abeni/bpf-do-not-WARN-in-bpf_warn_invalid_xdp_action/20211126-192252
        git checkout afb829c16c3bd86f86b24c880601cea9e21c5d3e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/filter.c:8190:50: warning: address of array 'dev->name' will always evaluate to 'true' [-Wpointer-bool-conversion]
                        act, prog->aux->name, prog->aux->id, dev->name ? dev->name : "");
                                                             ~~~~~^~~~ ~
   include/linux/printk.h:608:42: note: expanded from macro 'pr_warn_once'
           printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
                                                   ^~~~~~~~~~~
   include/linux/printk.h:589:30: note: expanded from macro 'printk_once'
           DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
                                       ^~~~~~~~~~~
   include/linux/once_lite.h:11:32: note: expanded from macro 'DO_ONCE_LITE'
           DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
                                         ^~~~~~~~~~~
   include/linux/once_lite.h:19:9: note: expanded from macro 'DO_ONCE_LITE_IF'
                           func(__VA_ARGS__);                              \
                                ^~~~~~~~~~~
   include/linux/printk.h:450:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:422:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   1 warning generated.


vim +8190 net/core/filter.c

  8183	
  8184	void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
  8185	{
  8186		const u32 act_max = XDP_REDIRECT;
  8187	
  8188		pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
  8189			     act > act_max ? "Illegal" : "Driver unsupported",
> 8190			     act, prog->aux->name, prog->aux->id, dev->name ? dev->name : "");
  8191	}
  8192	EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
  8193	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
