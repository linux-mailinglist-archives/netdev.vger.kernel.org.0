Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706FF4A36A5
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 15:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354983AbiA3O2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 09:28:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:62415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354988AbiA3O2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 09:28:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643552922; x=1675088922;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6AVMOcn04ZCi+J9KyCs5yeXM0u+KFFkUfqbBYPDoTOU=;
  b=OB11U+8K5UR7HfHP7HGveEqEOFVYiEw+sNJ8Ic11v+blunem9K5G2qGJ
   oEFrt7Ris11fq9ld5g7lBz2OeVcNcDsYSwx/jYJJ0te+IL7I3IVaPQ637
   zeFSnKEcJYhmeBzVNjZ7pmZoHIQc8uZxY5wakvywHZ8gudk+/14C+eOma
   z8G+f5S8Ne5UidMWn/qqdKmERbVd9nTtvHLQuNUpHsOZpwYaEWcYrkvwp
   zBe/EutiEIY3JrnJjjoDr8sagF2s53ocCIDjF4IzMcgxMAl4OYdaDWxdz
   fzWLOAsWRoRN3oBJXVQZJoapmZIEOUR/PWar/GjhEBm3jyGL5Qron+I7n
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10242"; a="247570399"
X-IronPort-AV: E=Sophos;i="5.88,328,1635231600"; 
   d="scan'208";a="247570399"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 06:28:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,328,1635231600"; 
   d="scan'208";a="564686697"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2022 06:28:38 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nEBC2-000QbE-9L; Sun, 30 Jan 2022 14:28:38 +0000
Date:   Sun, 30 Jan 2022 22:27:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH net-next 1/1] net/sched: Enable tc skb ext allocation on
 chain miss only when needed
Message-ID: <202201302207.vQWCwrx8-lkp@intel.com>
References: <20220130123141.10119-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220130123141.10119-1-paulb@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Paul-Blakey/net-sched-Enable-tc-skb-ext-allocation-on-chain-miss-only-when-needed/20220130-203224
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git ff58831fa02deb42fd731f830d8d9ec545573c7c
config: csky-randconfig-r026-20220130 (https://download.01.org/0day-ci/archive/20220130/202201302207.vQWCwrx8-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/0bc6313c4ce18444ed88c99b19d0cb1682772988
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Paul-Blakey/net-sched-Enable-tc-skb-ext-allocation-on-chain-miss-only-when-needed/20220130-203224
        git checkout 0bc6313c4ce18444ed88c99b19d0cb1682772988
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=csky SHELL=/bin/bash net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/sched/cls_api.c:55:6: error: redefinition of 'tc_skb_ext_tc_ovs_enable'
      55 | void tc_skb_ext_tc_ovs_enable(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/sched/cls_api.c:29:
   include/net/pkt_cls.h:1037:20: note: previous definition of 'tc_skb_ext_tc_ovs_enable' with type 'void(void)'
    1037 | static inline void tc_skb_ext_tc_ovs_enable(void) { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
>> net/sched/cls_api.c:61:6: error: redefinition of 'tc_skb_ext_tc_ovs_disable'
      61 | void tc_skb_ext_tc_ovs_disable(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/sched/cls_api.c:29:
   include/net/pkt_cls.h:1038:20: note: previous definition of 'tc_skb_ext_tc_ovs_disable' with type 'void(void)'
    1038 | static inline void tc_skb_ext_tc_ovs_disable(void) { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/tc_skb_ext_tc_ovs_enable +55 net/sched/cls_api.c

    54	
  > 55	void tc_skb_ext_tc_ovs_enable(void)
    56	{
    57		static_branch_inc(&tc_skb_ext_tc_ovs);
    58	}
    59	EXPORT_SYMBOL(tc_skb_ext_tc_ovs_enable);
    60	
  > 61	void tc_skb_ext_tc_ovs_disable(void)
    62	{
    63		static_branch_dec(&tc_skb_ext_tc_ovs);
    64	}
    65	EXPORT_SYMBOL(tc_skb_ext_tc_ovs_disable);
    66	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
