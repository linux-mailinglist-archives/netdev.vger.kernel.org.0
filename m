Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E27495B72
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379230AbiAUH6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:58:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:25458 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379221AbiAUH6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 02:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642751921; x=1674287921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jE99VFNQyNXY2EoQUsne6SaOHvBhTpB5dl4BtBOCEEw=;
  b=jFDroRi4SSRFOp6bl86fahFcYZ7RaZA4kGmm0lV7TxR365RPbmSvp2vg
   YiE5AbHGf9PIGXn2/AxM+18JfG014VBXScYG9HbP8XawQrMpYPAmSE/lZ
   AbQ1kppFXzxuR8Jw6LYTd73/oZuglZnfG1rXbyZA4oHvpRzamoGzbmxOh
   k5IZq3X7JrR0NQ2SLF4Og8lw0ioqmkaooATRyOWDHWDjiqiiApnbbbRMf
   OtQWjW67dKthx7Rh6N7a0d96v1UG9ugQd3ax0K0ofZxt9wzUVyp2Gby+D
   z+BN4Ln+mZNxrwT+7v7xIX7R3dcgSwY7QxsRnKU5LApSWbX17esZCvei6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="331943673"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="331943673"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 23:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="596051366"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jan 2022 23:58:38 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nAoog-000F4j-0e; Fri, 21 Jan 2022 07:58:38 +0000
Date:   Fri, 21 Jan 2022 15:58:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     ycaibb <ycaibb@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ycaibb@gmail.com
Subject: Re: [PATCH] net: missing lock releases in ipmr_base.c
Message-ID: <202201211542.TGuj5kMv-lkp@intel.com>
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
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20220121/202201211542.TGuj5kMv-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/33b03feacaf2155323b031274d2d67dab0cf561c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review ycaibb/net-missing-lock-releases-in-ipmr_base-c/20220121-112603
        git checkout 33b03feacaf2155323b031274d2d67dab0cf561c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv4/ipmr_base.c: In function 'mr_mfc_seq_idx':
>> net/ipv4/ipmr_base.c:156:17: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     156 |                 if (pos-- == 0)
         |                 ^~
   net/ipv4/ipmr_base.c:158:25: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     158 |                         return mfc;
         |                         ^~~~~~
   net/ipv4/ipmr_base.c:164:17: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     164 |                 if (pos-- == 0)
         |                 ^~
   net/ipv4/ipmr_base.c:166:25: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     166 |                         return mfc;
         |                         ^~~~~~


vim +/if +156 net/ipv4/ipmr_base.c

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
c8d61968032654 Yuval Mintz 2018-02-28 @156  		if (pos-- == 0)
33b03feacaf215 Ryan Cai    2022-01-21  157  			rcu_read_unlock();
c8d61968032654 Yuval Mintz 2018-02-28  158  			return mfc;
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
