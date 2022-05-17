Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91BC529DCF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244719AbiEQJTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244485AbiEQJTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:19:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022112A714;
        Tue, 17 May 2022 02:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652779160; x=1684315160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=grGQ9QQpYMfdTvHJAab0dxyFSKeeJ8ndipTrOFgXDeQ=;
  b=h867A+GufgBdkh2Dau+6XLqJEsWf7iXM9EhwEI2G2foOmgvlb1AfpRzq
   gGeRiS7fA+m4k2eqfuOH007iTLnZTT+uIAIZbnBOB/pPc40HhwoZRGi/b
   6N1vVgUTHbbYpmzuOHbtU+gUagAzAmLpoyZ29xZ8bXEimFiDzJIjhr2z6
   0hh8Dt2gjObr4IHyrOQzWBMPY3q8NUd1oDiYGL+3vsNsc8fUxI1ViFCiU
   fLplN1+3yDlUb59EJ8daI21esXjYTQN1K4NHPoqcL5RKDQa96rB+I53h7
   rf6D2N5N2CdLuNCkoER4pwcoLMLn4HlvX6whkxXqxn6y1l7ZwYGysh9nv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="270814915"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="270814915"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 02:19:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="555694551"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2022 02:19:15 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqtMJ-0000nV-73;
        Tue, 17 May 2022 09:19:15 +0000
Date:   Tue, 17 May 2022 17:19:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Message-ID: <202205171711.hqxFhp5l-lkp@intel.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiri-Olsa/cpuidle-rcu-Making-arch_cpu_idle-and-rcu_idle_exit-noinstr/20220516-043752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a014-20220516 (https://download.01.org/0day-ci/archive/20220517/202205171711.hqxFhp5l-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0b6fee32d730f621f2bfc4d8d9f0729814398415
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiri-Olsa/cpuidle-rcu-Making-arch_cpu_idle-and-rcu_idle_exit-noinstr/20220516-043752
        git checkout 0b6fee32d730f621f2bfc4d8d9f0729814398415
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   vmlinux.o: warning: objtool: vmx_l1d_flush()+0x13: call to static_key_count() leaves .noinstr.text section
   vmlinux.o: warning: objtool: vmx_vcpu_enter_exit()+0x29: call to static_key_count() leaves .noinstr.text section
   vmlinux.o: warning: objtool: vmx_update_host_rsp()+0x3e: call to static_key_count() leaves .noinstr.text section
   vmlinux.o: warning: objtool: arch_cpu_idle()+0xb: call to {dynamic}() leaves .noinstr.text section
>> vmlinux.o: warning: objtool: rcu_idle_exit()+0x25: call to trace_hardirqs_on() leaves .noinstr.text section
   vmlinux.o: warning: objtool: enter_from_user_mode()+0x1c: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: syscall_enter_from_user_mode()+0x21: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: syscall_enter_from_user_mode_prepare()+0x1c: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: exit_to_user_mode()+0x1b: call to static_key_count() leaves .noinstr.text section
   vmlinux.o: warning: objtool: syscall_exit_to_user_mode()+0x36: call to static_key_count() leaves .noinstr.text section
   vmlinux.o: warning: objtool: irqentry_enter_from_user_mode()+0x1c: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: irqentry_exit_to_user_mode()+0x22: call to static_key_count() leaves .noinstr.text section

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
