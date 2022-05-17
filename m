Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D3B52976E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiEQCjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQCjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:39:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3959445506;
        Mon, 16 May 2022 19:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652755160; x=1684291160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xftwmo8CNrHSR3juUYt1djnxmsGihebc2jvPKN5TNvI=;
  b=VpHtB7hGEPmJ3sFwLaukWDRPOFSbKzNG5+CvMDc7p74qbZZLuTwY9O4m
   kbzaRArcdbzW0MRYSen9jnjp9k1eWoTTmF0gSSjbHp2vFQs1Qf0XNEgWf
   swoHtcu0tUCthFF2+wYFtUMYq2KU9lmQue+xWqwUtSnUz+nRRsMRTjT5D
   Ps/QJn7ixTqULZtRhH3Yw3AQpDx2s5LCReS98hNqg0i76MRoD9Yxe0AhJ
   Xgs7FRdbo9dEXjQ5no1A+gYodbj2AmbJbN+Lhx2CLwRMffMsz2CUP3WJZ
   k1skG+yofBIdVJdKtE/Fc/NMQ15i5Dm0Ei64mxHGDb8FZgQ18rwuFwOMi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="270725220"
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="270725220"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 19:39:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="660394014"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 16 May 2022 19:39:16 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqn7D-0000X3-Lv;
        Tue, 17 May 2022 02:39:15 +0000
Date:   Tue, 17 May 2022 10:39:14 +0800
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
Message-ID: <202205171050.9msZot6F-lkp@intel.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
config: x86_64-randconfig-c002-20220516 (https://download.01.org/0day-ci/archive/20220517/202205171050.9msZot6F-lkp@intel.com/config)
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

>> vmlinux.o: warning: objtool: arch_cpu_idle()+0x0: call to {dynamic}() leaves .noinstr.text section
>> vmlinux.o: warning: objtool: rcu_idle_exit()+0x16: call to trace_hardirqs_off() leaves .noinstr.text section
   vmlinux.o: warning: objtool: enter_from_user_mode()+0x18: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: syscall_enter_from_user_mode()+0x1d: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: syscall_enter_from_user_mode_prepare()+0x18: call to __kcsan_check_access() leaves .noinstr.text section
   vmlinux.o: warning: objtool: irqentry_enter_from_user_mode()+0x18: call to __kcsan_check_access() leaves .noinstr.text section

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
