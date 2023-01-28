Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8306F67F8BB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjA1Oik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjA1Oij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:38:39 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1C1DBB6;
        Sat, 28 Jan 2023 06:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674916718; x=1706452718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bVB7tnZm5geSNISr1ZhuBzdB5Q5cqRLQJevOq6tw38E=;
  b=QLqTYbYtAqxkvSlHwmLj5snvf3W9Kpi8/fy1ABDvSLWgur/D52JJ/63c
   uwj32HAST/MQadWGcvAPo3ptmIyfvLAeCNXNRlHQyxlBkGY04kkIqXGpF
   oEakIYwYXHwQbpUymqCqITTXUvY1DThyabXElx2gsoACbL4lLiWEN9nsq
   vT161Ekzl57CqQa3FJBCGBMKKudFbNgg7f7AKFPWZIrDuU/9lZN3x/i2i
   FhvCTgfALTG4pMmDFr02/6elPbxp4d5Rnh+eJUW516UFBYlPAhO/72ijU
   B3JQBN7Qrbu6gNt3ac2hth/b/0137wyfffB8TgSncaiT7CUm+PLLJYbXY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="306944579"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="306944579"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 06:38:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="908984117"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="908984117"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jan 2023 06:38:35 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLmLi-0000nd-2T;
        Sat, 28 Jan 2023 14:38:34 +0000
Date:   Sat, 28 Jan 2023 22:38:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v8 bpf-next 4/5] bpf: Add xdp dynptrs
Message-ID: <202301282216.D4fgHBjZ-lkp@intel.com>
References: <20230126233439.3739120-5-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126233439.3739120-5-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/bpf-Allow-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230128-170947
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230126233439.3739120-5-joannelkoong%40gmail.com
patch subject: [PATCH v8 bpf-next 4/5] bpf: Add xdp dynptrs
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230128/202301282216.D4fgHBjZ-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ca213ec890479169ac6661c55e4c3eb95b4d8464
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/bpf-Allow-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230128-170947
        git checkout ca213ec890479169ac6661c55e4c3eb95b4d8464
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/filter.c:1866:5: warning: no previous prototype for 'bpf_dynptr_from_skb' [-Wmissing-prototypes]
    1866 | int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
         |     ^~~~~~~~~~~~~~~~~~~
>> net/core/filter.c:3858:5: warning: no previous prototype for 'bpf_dynptr_from_xdp' [-Wmissing-prototypes]
    3858 | int bpf_dynptr_from_xdp(struct xdp_buff *xdp, u64 flags, struct bpf_dynptr_kern *ptr)
         |     ^~~~~~~~~~~~~~~~~~~


vim +/bpf_dynptr_from_xdp +3858 net/core/filter.c

  3857	
> 3858	int bpf_dynptr_from_xdp(struct xdp_buff *xdp, u64 flags, struct bpf_dynptr_kern *ptr)
  3859	{
  3860		if (flags) {
  3861			bpf_dynptr_set_null(ptr);
  3862			return -EINVAL;
  3863		}
  3864	
  3865		bpf_dynptr_init(ptr, xdp, BPF_DYNPTR_TYPE_XDP, 0, xdp_get_buff_len(xdp));
  3866	
  3867		return 0;
  3868	}
  3869	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
