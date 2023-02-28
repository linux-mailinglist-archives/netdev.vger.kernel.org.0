Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764386A543D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjB1IQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjB1IQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:16:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554F2265BD;
        Tue, 28 Feb 2023 00:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677572205; x=1709108205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jvlbirBCen0JoozO0DRtMtM9lsFMy3zjq3zERzZPv4o=;
  b=JkWo2QjrMqaPRM7zvDWAbJDEzF9vieUXT7Kc04wLzHD23KVNxrhZI+P5
   5yb0pGiQ+TRsQArirJVopjuFlYKIVMnDQNWUhLqhaKO/BCJTqUyT2EV1h
   J2JKG/TAhIgGQEWUUo5+wkIYT7X4R+b9p4nKUVXs+I0IjV2RlQBGTvo4y
   qcBHK1U8xuAydotAohFAxpKS22FVBcW6SwJOBTaDPoEFq4sijN1ODD7kh
   Cbql8gEkIHXsGDhXr0zdtT/PaU1/WF2x/p1UZE1DhniBZA2bDVhRfZEHV
   GatHeRjir0gAwHkzT33WRNjKbRuZmg2uiJbqjRa75EXX/xTOCX2sml/mc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="334122092"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="334122092"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 00:16:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="667359132"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="667359132"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 00:16:23 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWv9q-0005Dl-2y;
        Tue, 28 Feb 2023 08:16:22 +0000
Date:   Tue, 28 Feb 2023 16:15:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, dsahern@kernel.org, pabeni@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 5/8] bpf: net: ipv6: Add bpf_ipv6_frag_rcv()
 kfunc
Message-ID: <202302281646.GYE1qnGb-lkp@intel.com>
References: <bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/ip-frags-Return-actual-error-codes-from-ip_check_defrag/20230228-035449
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu%40dxuuu.xyz
patch subject: [PATCH bpf-next v2 5/8] bpf: net: ipv6: Add bpf_ipv6_frag_rcv() kfunc
config: i386-defconfig (https://download.01.org/0day-ci/archive/20230228/202302281646.GYE1qnGb-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/be4610312351d4a658435bd4649a3a830322396d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/ip-frags-Return-actual-error-codes-from-ip_check_defrag/20230228-035449
        git checkout be4610312351d4a658435bd4649a3a830322396d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302281646.GYE1qnGb-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: net/ipv6/af_inet6.o: in function `inet6_init':
>> af_inet6.c:(.init.text+0x22a): undefined reference to `register_ipv6_reassembly_bpf'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
