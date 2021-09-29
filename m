Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E24741CBEF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbhI2SgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:36:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:42561 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345800AbhI2SgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 14:36:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="288670170"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="gz'50?scan'50,208,50";a="288670170"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 11:34:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="gz'50?scan'50,208,50";a="708471230"
Received: from lkp-server02.sh.intel.com (HELO f7acefbbae94) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 29 Sep 2021 11:34:31 -0700
Received: from kbuild by f7acefbbae94 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mVePW-00036Z-Jt; Wed, 29 Sep 2021 18:34:30 +0000
Date:   Thu, 30 Sep 2021 02:33:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com
Subject: Re: [PATCH bpf-next v3 06/10] xsk: propagate napi_id to XDP socket
 Rx path
Message-ID: <202109300212.l6Ky1gNu-lkp@intel.com>
References: <20201119083024.119566-7-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201119083024.119566-7-bjorn.topel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi "Björn,

I love your patch! Yet something to improve:

[auto build test ERROR on 4e99d115d865d45e17e83478d757b58d8fa66d3c]

url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-preferred-busy-polling/20210929-234934
base:   4e99d115d865d45e17e83478d757b58d8fa66d3c
config: um-kunit_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/f481c00164924dd5d782a92cc67897cc7f804502
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Bj-rn-T-pel/Introduce-preferred-busy-polling/20210929-234934
        git checkout f481c00164924dd5d782a92cc67897cc7f804502
        # save the attached .config to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=um SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   cc1: warning: arch/um/include/uapi: No such file or directory [-Wmissing-include-dirs]
   In file included from fs/select.c:32:
   include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
>> include/net/busy_poll.h:150:36: error: 'const struct sk_buff' has no member named 'napi_id'
     150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
         |                                    ^~


vim +150 include/net/busy_poll.h

   145	
   146	/* variant used for unconnected sockets */
   147	static inline void sk_mark_napi_id_once(struct sock *sk,
   148						const struct sk_buff *skb)
   149	{
 > 150		__sk_mark_napi_id_once_xdp(sk, skb->napi_id);
   151	}
   152	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--Kj7319i9nmIyA2yE
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
HXT8LwqSwgAERwAA

--Kj7319i9nmIyA2yE--
