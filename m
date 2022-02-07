Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDC4ACBCF
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 23:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbiBGWFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 17:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbiBGWFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 17:05:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAE6C0401C9;
        Mon,  7 Feb 2022 14:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644271498; x=1675807498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vgdqpg9gutTd0WnwyDDJKP2Z5/j1e3fIAXT24D+glyQ=;
  b=XFnCJJ/leuuENdn8AikHjXodeUm4D/Rp/N6ph/aR6nEQRu8zjkzXQwnK
   jU77nZu2KVRM2JQ4/oI/cBhkCMOgu1And+rnOIGygaN8BJ1k/WATj5E5T
   ZOYchgtVy4fdzs9YREbUOOaePGramlRV+NzizFsEWo8aJYu5NdEyHJ1v1
   pcxqgUnotQp1qGH7GNthmnUP1IUbh9fnTuNzmeY/RUQoxlR1QKKucX4Pn
   9+eE9DMnPLsb8Zi1O1I8VhRPO12+NqNemQFSM4j45EZ8YhvZaGo520jKw
   6HB7zfwxs+BUnuw9Vhvg6c6xw25PlEi+LNho1kUeQmBg+OX7CP1fewu2L
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="229466298"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="229466298"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 14:04:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="484582375"
Received: from lkp-server01.sh.intel.com (HELO 9dd77a123018) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 07 Feb 2022 14:04:56 -0800
Received: from kbuild by 9dd77a123018 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nHC7z-00011a-Ir; Mon, 07 Feb 2022 22:04:55 +0000
Date:   Tue, 8 Feb 2022 06:04:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 1/2] bpf: Make remote_port field in struct
 bpf_sk_lookup 16-bit wide
Message-ID: <202202080631.n8UjqRXy-lkp@intel.com>
References: <20220207131459.504292-2-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207131459.504292-2-jakub@cloudflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Jakub-Sitnicki/Split-bpf_sk_lookup-remote_port-field/20220207-215137
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: sparc-randconfig-s031-20220207 (https://download.01.org/0day-ci/archive/20220208/202202080631.n8UjqRXy-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/b859a90e4c32a55e71d2731dd8dae96d7ad1defe
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jakub-Sitnicki/Split-bpf_sk_lookup-remote_port-field/20220207-215137
        git checkout b859a90e4c32a55e71d2731dd8dae96d7ad1defe
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash net/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/bpf/test_run.c:1149:55: sparse: sparse: restricted __be16 degrades to integer

vim +1149 net/bpf/test_run.c

7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1111  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1112  int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kattr,
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1113  				union bpf_attr __user *uattr)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1114  {
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1115  	struct bpf_test_timer t = { NO_PREEMPT };
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1116  	struct bpf_prog_array *progs = NULL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1117  	struct bpf_sk_lookup_kern ctx = {};
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1118  	u32 repeat = kattr->test.repeat;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1119  	struct bpf_sk_lookup *user_ctx;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1120  	u32 retval, duration;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1121  	int ret = -EINVAL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1122  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1123  	if (prog->type != BPF_PROG_TYPE_SK_LOOKUP)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1124  		return -EINVAL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1125  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1126  	if (kattr->test.flags || kattr->test.cpu)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1127  		return -EINVAL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1128  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1129  	if (kattr->test.data_in || kattr->test.data_size_in || kattr->test.data_out ||
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1130  	    kattr->test.data_size_out)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1131  		return -EINVAL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1132  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1133  	if (!repeat)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1134  		repeat = 1;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1135  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1136  	user_ctx = bpf_ctx_init(kattr, sizeof(*user_ctx));
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1137  	if (IS_ERR(user_ctx))
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1138  		return PTR_ERR(user_ctx);
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1139  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1140  	if (!user_ctx)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1141  		return -EINVAL;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1142  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1143  	if (user_ctx->sk)
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1144  		goto out;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1145  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1146  	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1147  		goto out;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1148  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03 @1149  	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1150  		ret = -ERANGE;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1151  		goto out;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1152  	}
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1153  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1154  	ctx.family = (u16)user_ctx->family;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1155  	ctx.protocol = (u16)user_ctx->protocol;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1156  	ctx.dport = (u16)user_ctx->local_port;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1157  	ctx.sport = (__force __be16)user_ctx->remote_port;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1158  
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1159  	switch (ctx.family) {
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1160  	case AF_INET:
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1161  		ctx.v4.daddr = (__force __be32)user_ctx->local_ip4;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1162  		ctx.v4.saddr = (__force __be32)user_ctx->remote_ip4;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1163  		break;
7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1164  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
