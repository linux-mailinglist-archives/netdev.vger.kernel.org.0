Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C65476A4
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiFKQy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiFKQy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:54:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAE26BFDB;
        Sat, 11 Jun 2022 09:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654966465; x=1686502465;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mmZTqyEiB+FhFlacMnW+tfkrZq3xPE+aodltan7a1v0=;
  b=SNVvhOQjGC6pNDXSMY8nSPGfqFIkHbAwh65J8D5ZBnXhGJbD90PH40/J
   I2U0GtLj7/i6xPK1MWl4ox30VJ4wo7Z6TkQPkSfgOiLuGlOKNE64ugs/w
   Ta35axF0Y5WPeboHZIB9No2cHMgxhPlR/3hrnyC38ixmq5VmGwM0pF6S3
   lVWPgCcFlHw/avs/mLLMy5hHA5V5tLdvCQtP/8NRxyXBUE6Epc3k3x71/
   ovXLwOLt0nPb/m/sI+amJQSy56NxbmBjJIL7INuxBTXdw4doj5t8RwiiB
   /sywxAO9306Wl2A7ugwqJNhfr/r+tqdAcwMYVEUkdfsaqXnMc1Mhtk8SH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10375"; a="278681593"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="278681593"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 09:54:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="685176956"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jun 2022 09:54:22 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o04NS-000J6f-3o;
        Sat, 11 Jun 2022 16:54:22 +0000
Date:   Sun, 12 Jun 2022 00:53:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v9 04/10] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <202206120010.PClasXCc-lkp@intel.com>
References: <20220610165803.2860154-5-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-5-sdf@google.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220611-010241
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20220612/202206120010.PClasXCc-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ca53950e781503c3d62454a19b4d0395dbd79dd7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220611-010241
        git checkout ca53950e781503c3d62454a19b4d0395dbd79dd7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: bpf_cgroup_atype_get
   >>> referenced by trampoline.c:558 (kernel/bpf/trampoline.c:558)
   >>>               bpf/trampoline.o:(bpf_trampoline_link_cgroup_shim) in archive kernel/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
