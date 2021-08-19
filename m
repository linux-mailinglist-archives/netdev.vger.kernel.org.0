Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747203F1554
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhHSImF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 04:42:05 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43799 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237341AbhHSIl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 04:41:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uk.dNXL_1629362480;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0Uk.dNXL_1629362480)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Aug 2021 16:41:21 +0800
Date:   Thu, 19 Aug 2021 16:41:20 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     kernel test robot <lkp@intel.com>, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Wensong Zhang <wensong@linux-vs.org>
Cc:     kbuild-all@lists.01.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, yunhong-cgl jiang <xintian1976@gmail.com>
Subject: Re: [PATCH net-next v2] net: ipvs: add sysctl_run_estimation to
 support disable estimation
Message-ID: <20210819084120.GB5594@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20210819045137.35447-1-dust.li@linux.alibaba.com>
 <202108191644.QJhpxuWp-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202108191644.QJhpxuWp-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 04:23:32PM +0800, kernel test robot wrote:
>Hi Dust,
>
>Thank you for the patch! Yet something to improve:
>
>[auto build test ERROR on net-next/master]

Sorry, my fault !

The sysctl_run_estimation() was put in the wrong place when
CONFIG_SYSCTL not defined.

I will send a v3.

>
>url:    https://github.com/0day-ci/linux/commits/Dust-Li/net-ipvs-add-sysctl_run_estimation-to-support-disable-estimation/20210819-125335
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 19b8ece42c56aaa122f7e91eb391bb3dd7e193cd
>config: ia64-randconfig-r024-20210818 (attached as .config)
>compiler: ia64-linux-gcc (GCC) 11.2.0
>reproduce (this is a W=1 build):
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # https://github.com/0day-ci/linux/commit/8f0f8c6b2f04fe397ca8df17353590cdd2f5a414
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review Dust-Li/net-ipvs-add-sysctl_run_estimation-to-support-disable-estimation/20210819-125335
>        git checkout 8f0f8c6b2f04fe397ca8df17353590cdd2f5a414
>        # save the attached .config to linux build tree
>        mkdir build_dir
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash net/netfilter/ipvs/
>
>If you fix the issue, kindly add following tag as appropriate
>Reported-by: kernel test robot <lkp@intel.com>
>
>All errors (new ones prefixed by >>):
>
>   In file included from arch/ia64/include/asm/pgtable.h:153,
>                    from include/linux/pgtable.h:6,
>                    from arch/ia64/include/asm/uaccess.h:40,
>                    from include/linux/uaccess.h:11,
>                    from include/net/checksum.h:21,
>                    from include/net/ip_vs.h:23,
>                    from net/netfilter/ipvs/ip_vs_lc.c:18:
>   arch/ia64/include/asm/mmu_context.h: In function 'reload_context':
>   arch/ia64/include/asm/mmu_context.h:127:48: warning: variable 'old_rr4' set but not used [-Wunused-but-set-variable]
>     127 |         unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
>         |                                                ^~~~~~~
>   In file included from net/netfilter/ipvs/ip_vs_lc.c:18:
>   include/net/ip_vs.h: At top level:
>>> include/net/ip_vs.h:1660:19: error: redefinition of 'sysctl_run_estimation'
>    1660 | static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
>   include/net/ip_vs.h:1075:19: note: previous definition of 'sysctl_run_estimation' with type 'int(struct netns_ipvs *)'
>    1075 | static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
>--
>   In file included from arch/ia64/include/asm/pgtable.h:153,
>                    from include/linux/pgtable.h:6,
>                    from include/linux/mm.h:33,
>                    from include/linux/bvec.h:14,
>                    from include/linux/skbuff.h:17,
>                    from include/linux/ip.h:16,
>                    from net/netfilter/ipvs/ip_vs_core.c:27:
>   arch/ia64/include/asm/mmu_context.h: In function 'reload_context':
>   arch/ia64/include/asm/mmu_context.h:127:48: warning: variable 'old_rr4' set but not used [-Wunused-but-set-variable]
>     127 |         unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
>         |                                                ^~~~~~~
>   In file included from net/netfilter/ipvs/ip_vs_core.c:52:
>   include/net/ip_vs.h: At top level:
>>> include/net/ip_vs.h:1660:19: error: redefinition of 'sysctl_run_estimation'
>    1660 | static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
>   include/net/ip_vs.h:1075:19: note: previous definition of 'sysctl_run_estimation' with type 'int(struct netns_ipvs *)'
>    1075 | static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
>   net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_in_icmp':
>   net/netfilter/ipvs/ip_vs_core.c:1643:15: warning: variable 'outer_proto' set but not used [-Wunused-but-set-variable]
>    1643 |         char *outer_proto = "IPIP";
>         |               ^~~~~~~~~~~
>
>
>vim +/sysctl_run_estimation +1660 include/net/ip_vs.h
>
>  1659	
>> 1660	static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>  1661	{
>  1662		return 1;
>  1663	}
>  1664	
>
>---
>0-DAY CI Kernel Test Service, Intel Corporation
>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


