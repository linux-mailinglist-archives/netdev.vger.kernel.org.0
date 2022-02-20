Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA74BD187
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 21:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244950AbiBTUlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 15:41:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244868AbiBTUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 15:41:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3DF4504D;
        Sun, 20 Feb 2022 12:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645389654; x=1676925654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s0jR3gPRePi1saHMkP1Sa718UVGScDkx6b1DLwyOMlo=;
  b=bTXVls4J39vlsKJv2ytQcKh682Izhu1JUoaq93Rsko+gZajLsvhdLSor
   u7/H6dPZi4+MElE0M7uHEqK7vdihs8lcBPefFii39RvyKsefS64TVB9i1
   ksdVQD9SHsA8vrst4jvuYoBu37MWmORXdykDTxC8mnTiXmfPms7iY9joZ
   EXvWTKYj6tfKWOhFOGA7iFjOlbqpiR1aMlZY+c8+mP9s08L7JUS3gB6pS
   MqEdogTzHJYbzdqpPwSUPvcHbY/tSJkNPVZgbtdVHIC5RmjItGyKXvlf+
   jxXSNb3EG3nNvXX9ApmRWaRPR/Vhbj3X83R59KXPLnpmUQ7w2hAbD2Bf0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251347924"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251347924"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 12:40:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683014185"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 12:40:51 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLt0k-0000jT-DX; Sun, 20 Feb 2022 20:40:50 +0000
Date:   Mon, 21 Feb 2022 04:40:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 05/15] bpf: Allow storing
 PTR_TO_PERCPU_BTF_ID in map
Message-ID: <202202210444.8UyLf80r-lkp@intel.com>
References: <20220220134813.3411982-6-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-6-memxor@gmail.com>
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

Hi Kumar,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20220217]
[cannot apply to bpf-next/master bpf/master linus/master v5.17-rc4 v5.17-rc3 v5.17-rc2 v5.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
base:    3c30cf91b5ecc7272b3d2942ae0505dd8320b81c
config: openrisc-randconfig-s032-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210444.8UyLf80r-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/255d8431d2cae10fb3ac6abd44b1bf73f15dd060
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
        git checkout 255d8431d2cae10fb3ac6abd44b1bf73f15dd060
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> kernel/bpf/verifier.c:1568:39: sparse: sparse: mixing different enum types:
>> kernel/bpf/verifier.c:1568:39: sparse:    unsigned int enum bpf_reg_type
>> kernel/bpf/verifier.c:1568:39: sparse:    unsigned int enum bpf_type_flag
   kernel/bpf/verifier.c:13916:38: sparse: sparse: subtraction of functions? Share your drugs
   kernel/bpf/verifier.c: note: in included file (through include/linux/bpf.h, include/linux/bpf-cgroup.h):
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:63:40: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar

vim +1568 kernel/bpf/verifier.c

  1555	
  1556	static void mark_btf_ld_reg(struct bpf_verifier_env *env,
  1557				    struct bpf_reg_state *regs, u32 regno,
  1558				    enum bpf_reg_type reg_type,
  1559				    struct btf *btf, u32 btf_id,
  1560				    enum bpf_type_flag flag)
  1561	{
  1562		if (reg_type == SCALAR_VALUE ||
  1563		    WARN_ON_ONCE(reg_type != PTR_TO_BTF_ID && reg_type != PTR_TO_PERCPU_BTF_ID)) {
  1564			mark_reg_unknown(env, regs, regno);
  1565			return;
  1566		}
  1567		mark_reg_known_zero(env, regs, regno);
> 1568		regs[regno].type = reg_type | flag;
  1569		regs[regno].btf = btf;
  1570		regs[regno].btf_id = btf_id;
  1571	}
  1572	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
