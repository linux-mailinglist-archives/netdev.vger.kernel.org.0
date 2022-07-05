Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473FD5661E8
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 05:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiGEDiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 23:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiGEDiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 23:38:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D01C11A34
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 20:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656992330; x=1688528330;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GFLON9pERjyeGGpq5kP/SZAZHkKuoQ4hXmKkrZoWXNk=;
  b=RYkb2v3fSCXLHVNIb317mA+AAw4NL7XcyTviXQo1JMIJ7DmiKMDT1iZF
   PeNVd16HH0LXNOVCI+6GyjhcZss5sSwQWl7sgDBN2vBz51zUwchMcnBKF
   kYm6+LFsE4wYeIDxF1N81LgFrgU5ibwvkk5trOhHUad+TB1BSGCiwCwgv
   BPdFnUKaZl9Au/wgBVlD2/+wniiK6CdDGP13d85cg/GVP08rkTGWx4OQc
   5yqw2oswPigGihDduXbxhQTdUjAUjOWSlKFwoiCmGs6BfrdBEdRD7f70T
   DStCXcZ5TfSf9JLf+xBr9COARLeFbb2EJD0Rou8Buhh9MfeJyItFykZeF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="283971867"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="283971867"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 20:38:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="567433944"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2022 20:38:48 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8ZOh-000Ii6-Va;
        Tue, 05 Jul 2022 03:38:47 +0000
Date:   Tue, 5 Jul 2022 11:38:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>
Subject: Re: [PATCH net-next v2] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <202207051158.Vo7Qj6VM-lkp@intel.com>
References: <20220704095845.365359-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704095845.365359-1-equinox@diac24.net>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Lamparter/net-ip6mr-add-RTM_GETROUTE-netlink-op/20220704-180235
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d0bf1fe6454e976e39bc1524b9159fa2c0fcf321
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220705/202207051158.Vo7Qj6VM-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/ab5f843c60bd5c7ef119d8be390e67f9c43d8d3b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Lamparter/net-ip6mr-add-RTM_GETROUTE-netlink-op/20220704-180235
        git checkout ab5f843c60bd5c7ef119d8be390e67f9c43d8d3b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/ipv6/ip6mr.c:2515:25: sparse: sparse: symbol 'rtm_ipv6_mr_policy' was not declared. Should it be static?
   net/ipv6/ip6mr.c:407:13: sparse: sparse: context imbalance in 'ip6mr_vif_seq_start' - different lock contexts for basic block
   net/ipv6/ip6mr.c: note: in included file (through include/linux/rculist.h, include/linux/pid.h, include/linux/sched.h, ...):
   include/linux/rcupdate.h:726:9: sparse: sparse: context imbalance in 'ip6_mr_forward' - unexpected unlock
   net/ipv6/ip6mr.c: note: in included file (through include/linux/mroute6.h):
   include/linux/mroute_base.h:432:31: sparse: sparse: context imbalance in 'mr_mfc_seq_stop' - unexpected unlock

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
