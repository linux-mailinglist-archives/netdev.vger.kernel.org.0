Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4092850C845
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 10:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiDWImT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 04:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbiDWImO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 04:42:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0B515C29B;
        Sat, 23 Apr 2022 01:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650703158; x=1682239158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i9L7QIiqrDSO2UicXrZ7/EMlVdX5GRYWe4z8LgmUPKc=;
  b=C7ILNI8lWgTQ+3JEJXmWS1e2DIYd8nGmCPnQcRs1Dg07cLYZ1zNNeaf6
   MEPULS41H54kZqc2Aq0XwS2O7rDKPHh/z8YqQ6rkoF+q8Bgceb6YqR3j9
   ALcEwOULPncNzPmoOC8TOr3gksQIMCiJl47zKe3PPJc4JWA7yjS/DIgLP
   CLSkCivXlrJJsnFnkIYOCwI1gcWIHTCi/D6Xh9RLoKaY3ldSRf3C4qFwt
   wSaWl9K/1Fw/kSO5z8Aqk2j1Y/5tB3NKkHfbkdia/VhmQgoMdgjqbe2+6
   vkaXfXXVkGQ47hPJV11x+KfgafnjWo7YkMRh2hga8nxGodAS2Aim//T3U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="265037384"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="265037384"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 01:39:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="556778864"
Received: from lkp-server01.sh.intel.com (HELO dd58949a6e39) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 23 Apr 2022 01:39:11 -0700
Received: from kbuild by dd58949a6e39 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1niBIM-000051-Pz;
        Sat, 23 Apr 2022 08:39:10 +0000
Date:   Sat, 23 Apr 2022 16:38:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH bpf-next v6 3/6] bpf: Allow helpers to accept pointers
 with a fixed size
Message-ID: <202204231646.yQjLArUK-lkp@intel.com>
References: <20220422172422.4037988-4-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422172422.4037988-4-maximmi@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxim-Mikityanskiy/bpf-Use-ipv6_only_sock-in-bpf_tcp_gen_syncookie/20220423-022511
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: arc-randconfig-r036-20220422 (https://download.01.org/0day-ci/archive/20220423/202204231646.yQjLArUK-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e374c2f19a674b586212d155ecb708aaa86dcd2c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Maxim-Mikityanskiy/bpf-Use-ipv6_only_sock-in-bpf_tcp_gen_syncookie/20220423-022511
        git checkout e374c2f19a674b586212d155ecb708aaa86dcd2c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/verifier.c: In function 'check_helper_call':
>> kernel/bpf/verifier.c:5954:49: warning: array subscript 5 is above array bounds of 'const enum bpf_arg_type[5]' [-Warray-bounds]
    5954 |         return arg_type_is_mem_size(fn->arg_type[arg + 1]) || fn->arg_size[arg];
         |                                     ~~~~~~~~~~~~^~~~~~~~~
   In file included from include/linux/bpf-cgroup.h:5,
                    from kernel/bpf/verifier.c:7:
   include/linux/bpf.h:456:35: note: while referencing 'arg_type'
     456 |                 enum bpf_arg_type arg_type[5];
         |                                   ^~~~~~~~
   kernel/bpf/verifier.c:5952:57: warning: array subscript 5 is above array bounds of 'const enum bpf_arg_type[5]' [-Warray-bounds]
    5952 |                 return arg_type_is_mem_size(fn->arg_type[arg + 1]) ==
         |                                             ~~~~~~~~~~~~^~~~~~~~~
   In file included from include/linux/bpf-cgroup.h:5,
                    from kernel/bpf/verifier.c:7:
   include/linux/bpf.h:456:35: note: while referencing 'arg_type'
     456 |                 enum bpf_arg_type arg_type[5];
         |                                   ^~~~~~~~


vim +5954 kernel/bpf/verifier.c

  5948	
  5949	static bool check_args_pair_invalid(const struct bpf_func_proto *fn, int arg)
  5950	{
  5951		if (arg_type_is_mem_ptr(fn->arg_type[arg]))
  5952			return arg_type_is_mem_size(fn->arg_type[arg + 1]) ==
  5953				!!fn->arg_size[arg];
> 5954		return arg_type_is_mem_size(fn->arg_type[arg + 1]) || fn->arg_size[arg];
  5955	}
  5956	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
