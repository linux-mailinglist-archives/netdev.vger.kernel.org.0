Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4745197BF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345164AbiEDHFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiEDHFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:05:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDAA21260;
        Wed,  4 May 2022 00:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651647722; x=1683183722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7ZCqlQA5sx7gnt6UXenHJLpYVoVKeBIUo5U3B8t8rmE=;
  b=JgsQrAjNoJ2bKHpmeKPP0rymm4WqEYDo24MUUewYIoYW2YCZbO+tbXTg
   W3A8ppj9USsIf09Ak+kXTlJKXTJri9oiCdi/rQvT44YlYz8v394LWa0dN
   Kfn/VssNM90dJL2YaLpgQNwjDYoURjPIp++ntxf/J6NvMN+LJgNsMqMJu
   ajep2Urat2qbuK0ZHEDlqugapvSSsztxSVYApTPV0FGhLCRu26/YL8xM1
   3SlErWBs+K4t6mqQ8bra2384HEma3siIYo2NaHQyD4dm/Umz/52mULEaO
   e2tCUZZw5/9M4opfpxyUgreVIiLXLgP0GQ/aI7N/r6fLRlB6NJb0nUDxn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267279980"
X-IronPort-AV: E=Sophos;i="5.91,197,1647327600"; 
   d="scan'208";a="267279980"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 00:02:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,197,1647327600"; 
   d="scan'208";a="653603446"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 04 May 2022 00:01:55 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nm91G-000B9r-MZ;
        Wed, 04 May 2022 07:01:54 +0000
Date:   Wed, 4 May 2022 15:01:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guowei Du <duguoweisz@gmail.com>, jack@suse.cz
Cc:     kbuild-all@lists.01.org, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org, serge@hallyn.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, selinux@vger.kernel.org, duguoweisz@gmail.com,
        duguowei <duguowei@xiaomi.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
Message-ID: <202205041421.bHwZBEFK-lkp@intel.com>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183750.1977-1-duguoweisz@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guowei,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on pcmoore-selinux/next]
[also build test WARNING on linus/master jmorris-security/next-testing v5.18-rc5]
[cannot apply to jack-fs/fsnotify next-20220503]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Guowei-Du/fsnotify-add-generic-perm-check-for-unlink-rmdir/20220504-024310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git next
config: h8300-randconfig-s032-20220501 (https://download.01.org/0day-ci/archive/20220504/202205041421.bHwZBEFK-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/6f635019bbd2ab22a64e03164c8812a46531966e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guowei-Du/fsnotify-add-generic-perm-check-for-unlink-rmdir/20220504-024310
        git checkout 6f635019bbd2ab22a64e03164c8812a46531966e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=h8300 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   security/security.c:358:25: sparse: sparse: cast removes address space '__rcu' of expression
>> security/security.c:1169:35: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct path *path @@     got struct path const *dir @@
   security/security.c:1169:35: sparse:     expected struct path *path
   security/security.c:1169:35: sparse:     got struct path const *dir
   security/security.c:1180:35: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct path *path @@     got struct path const *dir @@
   security/security.c:1180:35: sparse:     expected struct path *path
   security/security.c:1180:35: sparse:     got struct path const *dir

vim +1169 security/security.c

  1160	
  1161	int security_path_rmdir(const struct path *dir, struct dentry *dentry)
  1162	{
  1163		int ret;
  1164		if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
  1165			return 0;
  1166		ret = call_int_hook(path_rmdir, 0, dir, dentry);
  1167		if (ret)
  1168			return ret;
> 1169		return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
  1170	}
  1171	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
