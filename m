Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A9495B97
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379153AbiAUIJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:09:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:6594 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343642AbiAUIJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 03:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642752585; x=1674288585;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OQeW5rUFYNb1LuME3+2ja/Sqh0ku+Ix4Xf4t/BS3sDs=;
  b=evP4d2trlkyu0esCpgFOGnGcwws4MvgEiaQmNL48hWDQ87S3XeE9T9Jf
   5yL0QXrfmjmQlBCF9/5CeG4cm84zyneMXPG6xe+z6O+p0H0jCpS9/4njt
   XatfsTljLirGXPNWnZWD5S3lUI7cxml97M4p2bM0WbHwJSohY+juVJEsH
   rwFIpohBiNobKlGU1808smE0gQjMGf07eQ6xTX+vDWHYg3bQlw2tLLvrR
   KbtjzlrRjEg8p9RW6am0bqrltpDmZLJhCeAqCVePtXWPmeAPtCaSy5SDj
   is9KVdStqZQTcwynGGQKf3KMvsUpw7q3jtSVyCl4HsFJ14+AzT54JTqVi
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="308926049"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="308926049"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 00:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="579529041"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jan 2022 00:09:39 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nAozK-000F5O-6L; Fri, 21 Jan 2022 08:09:38 +0000
Date:   Fri, 21 Jan 2022 16:08:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     ycaibb <ycaibb@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ycaibb@gmail.com
Subject: Re: [PATCH] net: missing lock releases in ipmr_base.c
Message-ID: <202201211524.XaQUNPO4-lkp@intel.com>
References: <20220121032210.5829-1-ycaibb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121032210.5829-1-ycaibb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ycaibb,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.16 next-20220121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/ycaibb/net-missing-lock-releases-in-ipmr_base-c/20220121-112603
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8aaaf2f3af2ae212428f4db1af34214225f5cec3
config: mips-bmips_stb_defconfig (https://download.01.org/0day-ci/archive/20220121/202201211524.XaQUNPO4-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project d4baf3b1322b84816aa623d8e8cb45a49cb68b84)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/0day-ci/linux/commit/33b03feacaf2155323b031274d2d67dab0cf561c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review ycaibb/net-missing-lock-releases-in-ipmr_base-c/20220121-112603
        git checkout 33b03feacaf2155323b031274d2d67dab0cf561c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/ipv4/ipmr_base.c:158:4: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
                           return mfc;
                           ^
   net/ipv4/ipmr_base.c:156:3: note: previous statement is here
                   if (pos-- == 0)
                   ^
   net/ipv4/ipmr_base.c:166:4: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
                           return mfc;
                           ^
   net/ipv4/ipmr_base.c:164:3: note: previous statement is here
                   if (pos-- == 0)
                   ^
   2 warnings generated.


vim +/if +158 net/ipv4/ipmr_base.c

3feda6b46f7347 Yuval Mintz 2018-02-28  146  
c8d61968032654 Yuval Mintz 2018-02-28  147  void *mr_mfc_seq_idx(struct net *net,
c8d61968032654 Yuval Mintz 2018-02-28  148  		     struct mr_mfc_iter *it, loff_t pos)
c8d61968032654 Yuval Mintz 2018-02-28  149  {
c8d61968032654 Yuval Mintz 2018-02-28  150  	struct mr_table *mrt = it->mrt;
c8d61968032654 Yuval Mintz 2018-02-28  151  	struct mr_mfc *mfc;
c8d61968032654 Yuval Mintz 2018-02-28  152  
c8d61968032654 Yuval Mintz 2018-02-28  153  	rcu_read_lock();
c8d61968032654 Yuval Mintz 2018-02-28  154  	it->cache = &mrt->mfc_cache_list;
c8d61968032654 Yuval Mintz 2018-02-28  155  	list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list)
c8d61968032654 Yuval Mintz 2018-02-28  156  		if (pos-- == 0)
33b03feacaf215 Ryan Cai    2022-01-21  157  			rcu_read_unlock();
c8d61968032654 Yuval Mintz 2018-02-28 @158  			return mfc;
c8d61968032654 Yuval Mintz 2018-02-28  159  	rcu_read_unlock();
c8d61968032654 Yuval Mintz 2018-02-28  160  
c8d61968032654 Yuval Mintz 2018-02-28  161  	spin_lock_bh(it->lock);
c8d61968032654 Yuval Mintz 2018-02-28  162  	it->cache = &mrt->mfc_unres_queue;
c8d61968032654 Yuval Mintz 2018-02-28  163  	list_for_each_entry(mfc, it->cache, list)
c8d61968032654 Yuval Mintz 2018-02-28  164  		if (pos-- == 0)
33b03feacaf215 Ryan Cai    2022-01-21  165  			spin_unlock_bh(it->lock);
c8d61968032654 Yuval Mintz 2018-02-28  166  			return mfc;
c8d61968032654 Yuval Mintz 2018-02-28  167  	spin_unlock_bh(it->lock);
c8d61968032654 Yuval Mintz 2018-02-28  168  
c8d61968032654 Yuval Mintz 2018-02-28  169  	it->cache = NULL;
c8d61968032654 Yuval Mintz 2018-02-28  170  	return NULL;
c8d61968032654 Yuval Mintz 2018-02-28  171  }
c8d61968032654 Yuval Mintz 2018-02-28  172  EXPORT_SYMBOL(mr_mfc_seq_idx);
c8d61968032654 Yuval Mintz 2018-02-28  173  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
