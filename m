Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E494BD2EC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 01:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbiBUAk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 19:40:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiBUAk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 19:40:26 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C77E49693;
        Sun, 20 Feb 2022 16:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645404004; x=1676940004;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jcB/VV1tgM+f7nB7Rbpqdo/SKvwweZ8K+gpxHXDQvwI=;
  b=IatFIT7VRy6ZjbyM0wwPgZTxJV0yHkKhgBVMDGQiHOUsGKcITO/+7YkF
   cuso/uH5D4masf7ou+gUjcyFUNZ7agpfdutQmyCdtXX40+SukV4NAvsWV
   ivlXqyNWlAjQYVmD7dSM/AaraRqtYpMng8UyXyXplDKK5ZRMT8KhEdHTF
   U7atM2IU9lopYA8U+gaIMPKDqrPSWPKgYcm1gFgxr4xY+wQig4GSnDht+
   zf3+FTzMBg9A6Us7sHXKkOdX6zJJHfFKLngiaSNE/6cDihUWrYkmXEen2
   awaEZYyygSwbwrPKmzXYQNxR0XBgYDnZrVAsX/nwZ54Tnqef7bUqYq1Gc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="232034672"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="232034672"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 16:40:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="572932144"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 Feb 2022 16:40:00 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLwkB-00015U-Vh; Mon, 21 Feb 2022 00:39:59 +0000
Date:   Mon, 21 Feb 2022 08:39:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 10/15] bpf: Wire up freeing of referenced
 PTR_TO_BTF_ID in map
Message-ID: <202202210811.0jZyZUP1-lkp@intel.com>
References: <20220220134813.3411982-11-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-11-memxor@gmail.com>
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

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20220217]
[cannot apply to bpf-next/master bpf/master linus/master v5.17-rc4 v5.17-rc3 v5.17-rc2 v5.17-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
base:    3c30cf91b5ecc7272b3d2942ae0505dd8320b81c
config: microblaze-randconfig-r022-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210811.0jZyZUP1-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/09a47522ec608218eb6aabd5011316d78ad245e0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
        git checkout 09a47522ec608218eb6aabd5011316d78ad245e0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   microblaze-linux-ld: kernel/bpf/syscall.o: in function `bpf_map_free_ptr_to_btf_id':
>> (.text+0x555c): undefined reference to `__generic_xchg_called_with_bad_pointer'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
