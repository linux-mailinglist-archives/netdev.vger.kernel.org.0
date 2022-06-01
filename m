Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1FD53AF96
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiFAWpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 18:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiFAWpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 18:45:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64554281860;
        Wed,  1 Jun 2022 15:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654123530; x=1685659530;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=smkMhl7SsLCvV8F21B6h6yHB6om4C/Bmm9M+s7xMgFs=;
  b=oC3R54YH7KpP6anGlcRpgoBObGC0UAHryK9cvqHrtBBg1Eq6VPQdWHUQ
   Lo+az2D2znNGVdR54a+yrKQpJ0JjbVNlqqTH8lmfiLEMohAzGOyIzXrIa
   K/27vk8uvFXRLkfqxaTfeVZ3BExw/oE+p2raA1oymfhdtnsFLE4/QHyeI
   cuR7RUn1IuDREX5CXCc6RPra9TA3zT+fS3Y1jOLWyIpiR7Oco8nYP/BOL
   Fk87tLBWnu8GatIjUDLGarL7l/wTLCNB48HRtjqHBNrHF62S7Lad4oKYh
   /ZoczDsQ13x8OFCDCvee5we2LNkzKTy6+pVX5uz3xDDKNi+ONefq1EF+U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="362129073"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="362129073"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 15:45:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="581805052"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2022 15:45:27 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nwX5j-0004UY-14;
        Wed, 01 Jun 2022 22:45:27 +0000
Date:   Thu, 2 Jun 2022 06:44:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        rostedt@goodmis.org, jolsa@kernel.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <202206020622.HnFjEObo-lkp@intel.com>
References: <20220601175749.3071572-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601175749.3071572-6-song@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20220602/202206020622.HnFjEObo-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7edcf1c49617641579f2bc36b86c7d59bea20aef
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220602-020112
        git checkout 7edcf1c49617641579f2bc36b86c7d59bea20aef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/bpf/trampoline.c:30:66: warning: declaration of 'enum ftrace_ops_cmd' will not be visible outside of this function [-Wvisibility]
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
                                                                    ^
   kernel/bpf/trampoline.c:92:21: error: invalid application of 'sizeof' to an incomplete type 'struct ftrace_ops'
           tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
                              ^     ~~~~~~~~~~~~~~~~~~~
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:100:10: error: incomplete definition of type 'struct ftrace_ops'
           tr->fops->private = tr;
           ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:101:10: error: incomplete definition of type 'struct ftrace_ops'
           tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
           ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:397:11: error: incomplete definition of type 'struct ftrace_ops'
                   tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
                   ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:397:22: error: use of undeclared identifier 'FTRACE_OPS_FL_SHARE_IPMODIFY'
                   tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
                                      ^
   kernel/bpf/trampoline.c:415:11: error: incomplete definition of type 'struct ftrace_ops'
                   tr->fops->func = NULL;
                   ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:416:11: error: incomplete definition of type 'struct ftrace_ops'
                   tr->fops->trampoline = 0;
                   ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:431:67: warning: declaration of 'enum ftrace_ops_cmd' will not be visible outside of this function [-Wvisibility]
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
                                                                     ^
   kernel/bpf/trampoline.c:431:12: error: conflicting types for 'bpf_tramp_ftrace_ops_func'
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
              ^
   kernel/bpf/trampoline.c:30:12: note: previous declaration is here
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
              ^
   kernel/bpf/trampoline.c:431:82: error: variable has incomplete type 'enum ftrace_ops_cmd'
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
                                                                                    ^
   kernel/bpf/trampoline.c:431:67: note: forward declaration of 'enum ftrace_ops_cmd'
   static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
                                                                     ^
   kernel/bpf/trampoline.c:433:33: error: incomplete definition of type 'struct ftrace_ops'
           struct bpf_trampoline *tr = ops->private;
                                       ~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:448:7: error: use of undeclared identifier 'FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY'
           case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY:
                ^
   kernel/bpf/trampoline.c:452:7: error: use of undeclared identifier 'FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY'
           case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY:
                ^
   kernel/bpf/trampoline.c:454:11: error: incomplete definition of type 'struct ftrace_ops'
                   tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
                   ~~~~~~~~^
   include/linux/bpf.h:47:8: note: forward declaration of 'struct ftrace_ops'
   struct ftrace_ops;
          ^
   kernel/bpf/trampoline.c:454:23: error: use of undeclared identifier 'FTRACE_OPS_FL_SHARE_IPMODIFY'
                   tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
                                       ^
   2 warnings and 14 errors generated.


vim +30 kernel/bpf/trampoline.c

    29	
  > 30	static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
    31	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
