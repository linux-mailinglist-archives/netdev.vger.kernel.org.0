Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC459E92F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbiHWRQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344106AbiHWRPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:15:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E75145BBC;
        Tue, 23 Aug 2022 06:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661262598; x=1692798598;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7URe0xxC6qIsgHX2iNkaSTs6I2GXYi/eCN2P9MNn59g=;
  b=WXj3n/J46Pbux/1Zyu41y+jG5NrJnU3Aovzu9CgAHzSx1goXwSm6BuPg
   oafg1w4UCP3hiTQ0CbeEJSv5+NZSNZdgNyQ87zAgtklNPO3u//TA+2XNY
   IPlnxCjPX2iZ/Cr1PDUMUt4rzAH816XyGNiVvvNFtHeICALMvyOjuSRlS
   3Hk4m7/AIImhYJbBLz92Ug9PqnQQocI3Zjx+SK6r+3DNtmKPdVATrHBNA
   2LUu87IXU0LKoVX4TIcI6SpL8+4mv2TFRf9rvqvcylq+1ArUUfYvznE/6
   O6rL1A3TUGGTvoP6iIJtQ6Qven59474nnEbacE9DuvZE1FT4Sbyjk8FqG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="292435544"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="292435544"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 06:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="560172799"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 23 Aug 2022 06:49:53 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQUHw-0000HX-2u;
        Tue, 23 Aug 2022 13:49:52 +0000
Date:   Tue, 23 Aug 2022 21:49:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     kbuild-all@lists.01.org, Daniel Xu <dxu@dxuuu.xyz>,
        pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        martin.lau@linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <202208232110.vsR1bsL0-lkp@intel.com>
References: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220823-032643
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220823/202208232110.vsR1bsL0-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/496ec6d75c8e8758f93c6b987eee83713c911a05
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220823-032643
        git checkout 496ec6d75c8e8758f93c6b987eee83713c911a05
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/core/filter.o: in function `tc_cls_act_btf_struct_access':
   net/core/filter.c:8644: undefined reference to `nf_conntrack_btf_struct_access'
   ld: net/core/filter.o: in function `xdp_btf_struct_access':
>> include/net/net_namespace.h:369: undefined reference to `nf_conntrack_btf_struct_access'
   pahole: .tmp_vmlinux.btf: Invalid argument
   .btf.vmlinux.bin.o: file not recognized: file format not recognized


vim +369 include/net/net_namespace.h

8f424b5f32d78b Eric Dumazet      2008-11-12  365  
0c5c9fb5510633 Eric W. Biederman 2015-03-11  366  static inline struct net *read_pnet(const possible_net_t *pnet)
8f424b5f32d78b Eric Dumazet      2008-11-12  367  {
0c5c9fb5510633 Eric W. Biederman 2015-03-11  368  #ifdef CONFIG_NET_NS
0c5c9fb5510633 Eric W. Biederman 2015-03-11 @369  	return pnet->net;
8f424b5f32d78b Eric Dumazet      2008-11-12  370  #else
0c5c9fb5510633 Eric W. Biederman 2015-03-11  371  	return &init_net;
8f424b5f32d78b Eric Dumazet      2008-11-12  372  #endif
0c5c9fb5510633 Eric W. Biederman 2015-03-11  373  }
5d1e4468a7705d Denis V. Lunev    2008-04-16  374  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
