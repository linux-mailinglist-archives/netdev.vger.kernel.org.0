Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D715E53B0B8
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiFBAJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiFBAJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:09:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F99BF7482;
        Wed,  1 Jun 2022 17:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654128538; x=1685664538;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pOhEllTCFsx3tYsEcACYZ8dSbWca5EgyiyBT1jzYJuc=;
  b=TE3aH480RCT9zwYauh17ddLNKLNV7yTGmw67pma846Qa9K4q+DZ4fCl3
   cEqzoqAy7twiN0VAVokrKw3tMJvwpBPgKl+t61xe090lFn4Mc6odFl9AW
   gZbmeXRQYzG0sKyku8XPdguAFSK+XYVFuraRmnv8in1qqP/rxWPQ+YCZu
   pkypU1gwPDCxTzidPbCpEYwbYr1801j6lTkHYfC8SFpbR435TP7vOS2Mt
   +fyr8e9VzfGZ3d/s66OmbMRwThFrxDEDZSquzcqNrm3ipSLQIwgwlfA+w
   X6Jx9IDv67M7p0FdRYtjkZ5B3f/vmHEB70LIQsineRlM1NtzD2En8xZFR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="255639270"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="255639270"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 17:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="667692493"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jun 2022 17:08:55 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwYOU-0004Ys-V1;
        Thu, 02 Jun 2022 00:08:54 +0000
Date:   Thu, 2 Jun 2022 08:08:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, rostedt@goodmis.org,
        jolsa@kernel.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <202206020707.jsHlBldB-lkp@intel.com>
References: <20220601175749.3071572-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601175749.3071572-6-song@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220602/202206020707.jsHlBldB-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/7edcf1c49617641579f2bc36b86c7d59bea20aef
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
        git checkout 7edcf1c49617641579f2bc36b86c7d59bea20aef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/bpf/trampoline.c:30:66: warning: 'enum ftrace_ops_cmd' declared inside parameter list will not be visible outside of this definition or declaration
      30 | static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
         |                                                                  ^~~~~~~~~~~~~~
   kernel/bpf/trampoline.c: In function 'bpf_trampoline_lookup':
   kernel/bpf/trampoline.c:92:35: error: invalid application of 'sizeof' to incomplete type 'struct ftrace_ops'
      92 |         tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
         |                                   ^~~~~~
   kernel/bpf/trampoline.c:100:17: error: invalid use of undefined type 'struct ftrace_ops'
     100 |         tr->fops->private = tr;
         |                 ^~
   kernel/bpf/trampoline.c:101:17: error: invalid use of undefined type 'struct ftrace_ops'
     101 |         tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
         |                 ^~
   kernel/bpf/trampoline.c: In function 'bpf_trampoline_update':
   kernel/bpf/trampoline.c:397:25: error: invalid use of undefined type 'struct ftrace_ops'
     397 |                 tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
         |                         ^~
   kernel/bpf/trampoline.c:397:36: error: 'FTRACE_OPS_FL_SHARE_IPMODIFY' undeclared (first use in this function)
     397 |                 tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/trampoline.c:397:36: note: each undeclared identifier is reported only once for each function it appears in
   kernel/bpf/trampoline.c:415:25: error: invalid use of undefined type 'struct ftrace_ops'
     415 |                 tr->fops->func = NULL;
         |                         ^~
   kernel/bpf/trampoline.c:416:25: error: invalid use of undefined type 'struct ftrace_ops'
     416 |                 tr->fops->trampoline = 0;
         |                         ^~
   kernel/bpf/trampoline.c: At top level:
   kernel/bpf/trampoline.c:431:67: warning: 'enum ftrace_ops_cmd' declared inside parameter list will not be visible outside of this definition or declaration
     431 | static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
         |                                                                   ^~~~~~~~~~~~~~
   kernel/bpf/trampoline.c:431:82: error: parameter 2 ('cmd') has incomplete type
     431 | static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
         |                                                              ~~~~~~~~~~~~~~~~~~~~^~~
   kernel/bpf/trampoline.c: In function 'bpf_tramp_ftrace_ops_func':
   kernel/bpf/trampoline.c:433:40: error: invalid use of undefined type 'struct ftrace_ops'
     433 |         struct bpf_trampoline *tr = ops->private;
         |                                        ^~
   kernel/bpf/trampoline.c:448:14: error: 'FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY' undeclared (first use in this function)
     448 |         case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY:
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/trampoline.c:452:14: error: 'FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY' undeclared (first use in this function)
     452 |         case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY:
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/trampoline.c:454:25: error: invalid use of undefined type 'struct ftrace_ops'
     454 |                 tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
         |                         ^~
   kernel/bpf/trampoline.c:454:37: error: 'FTRACE_OPS_FL_SHARE_IPMODIFY' undeclared (first use in this function)
     454 |                 tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +30 kernel/bpf/trampoline.c

    29	
  > 30	static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
    31	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
