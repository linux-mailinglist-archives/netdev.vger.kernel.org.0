Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21247FC81
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhL0MJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:09:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:49927 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhL0MJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 07:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640606962; x=1672142962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=okfjJNDIMcbw0e+Sab5DYvFf+BRXsTdpjDfl4ffFb88=;
  b=iBfRgetn1s+9poM90p8bIZ5Yf/VZk1J4Iq1KQBFfJIloCBC+R9NMFJPO
   0NtSpR8HxGeY8j5PjPyomHrfwcbL40x0DRZ2j2inRJOcES4v8ffQbjYry
   5dJUY1qP1W1fXP2qlaMBBAWts3XcDxnBtAMY87Lfqpyp215D0lVK0zE7d
   FlLSJeZxThFVEBlPVhG7yeJhG6cijFwEyyZA5uF4QqYoEyNqmfCLjm4/V
   1uDQ0qGhP/ljQxDaKRfouwwjjOfhx37vcIIVmJ9ckNfGLtggfEdOI0Iqd
   laU8Ip/L2ho23+1ELwNmRXTfPji5m1gv3xdo+LA2qH51S6yo89jXmLP8g
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221869146"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="221869146"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 04:09:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="758403941"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 27 Dec 2021 04:09:19 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n1ooY-0006Fl-Lb; Mon, 27 Dec 2021 12:09:18 +0000
Date:   Mon, 27 Dec 2021 20:08:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Qiang Wang <wangqiang.wq.frank@bytedance.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] libbpf: Support repeated legacy kprobes on same
 function
Message-ID: <202112272030.W0PW9fN7-lkp@intel.com>
References: <20211225083242.38498-2-wangqiang.wq.frank@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211225083242.38498-2-wangqiang.wq.frank@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qiang,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]
[also build test ERROR on bpf/master horms-ipvs/master linus/master v5.16-rc7 next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Qiang-Wang/libbpf-Use-probe_name-for-legacy-kprobe/20211225-163349
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-c001-20211227 (https://download.01.org/0day-ci/archive/20211227/202112272030.W0PW9fN7-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 511726c64d3b6cca66f7c54d457d586aa3129f67)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4a70a6c46086b85c64cae0b5c67980bd7f73cfeb
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Qiang-Wang/libbpf-Use-probe_name-for-legacy-kprobe/20211225-163349
        git checkout 4a70a6c46086b85c64cae0b5c67980bd7f73cfeb
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> libbpf.c:9896:4: error: expected ')'
                    __sync_fetch_and_add(&index, 1));
                    ^
   libbpf.c:9895:10: note: to match this '('
           snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(), kfunc_name, offset
                   ^
   1 error generated.
   make[6]: *** [tools/build/Makefile.build:97: kernel/bpf/preload/libbpf/staticobjs/libbpf.o] Error 1
   make[6]: Target '__build' not remade because of errors.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
