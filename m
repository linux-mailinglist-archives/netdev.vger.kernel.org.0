Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08E51A092
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350383AbiEDNXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350241AbiEDNXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:23:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FD41CFCD;
        Wed,  4 May 2022 06:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651670369; x=1683206369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H9BdaDvD0tI00BXc7t73JRza9VVjgjSUb1IhYY15jGU=;
  b=bra9fYXHc7R9xaBslrTNMUOfR+HIxhiZcIM1VKLGM2At1pmci+SpBY9z
   fiDYi5x+aoLPQM23vIsgaHLSd1CqmXEJJUpJLbTgYrZFG2IJx/fZMCoDd
   uEjBP7q4GEQ+zUzfyHTjr3aRcGaUhHy95tfLxH+USb9/PcHrlbswm6MlQ
   wG1SdC/7uGlfv8+1k3yj2444l0qGdvSmEXDe1kFlix9dUra/GrxgFBMle
   q35E4S8B9sqAWS8Raa5s3/FpbVa09vgE7yDnU6qU7/4z3RaKvFpbZBnq+
   Bc5uN0UX2fWQIy8euCC3si5BZUP8mm0Q15Fb99VAqzaoj9jIXKSeKW/Qs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="249744969"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="249744969"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 06:19:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="562717663"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 04 May 2022 06:19:01 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmEuC-000BPt-S7;
        Wed, 04 May 2022 13:19:00 +0000
Date:   Wed, 4 May 2022 21:18:54 +0800
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
Message-ID: <202205042136.nn1xy0Ae-lkp@intel.com>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183750.1977-1-duguoweisz@gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
config: openrisc-buildonly-randconfig-r003-20220501 (https://download.01.org/0day-ci/archive/20220504/202205042136.nn1xy0Ae-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6f635019bbd2ab22a64e03164c8812a46531966e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guowei-Du/fsnotify-add-generic-perm-check-for-unlink-rmdir/20220504-024310
        git checkout 6f635019bbd2ab22a64e03164c8812a46531966e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   security/security.c: In function 'security_path_rmdir':
>> security/security.c:1169:35: warning: passing argument 1 of 'fsnotify_path_perm' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    1169 |         return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
         |                                   ^~~
   In file included from security/security.c:24:
   include/linux/fsnotify.h:83:51: note: expected 'struct path *' but argument is of type 'const struct path *'
      83 | static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
         |                                      ~~~~~~~~~~~~~^~~~
   security/security.c: In function 'security_path_unlink':
   security/security.c:1180:35: warning: passing argument 1 of 'fsnotify_path_perm' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    1180 |         return fsnotify_path_perm(dir, dentry, MAY_UNLINK);
         |                                   ^~~
   In file included from security/security.c:24:
   include/linux/fsnotify.h:83:51: note: expected 'struct path *' but argument is of type 'const struct path *'
      83 | static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
         |                                      ~~~~~~~~~~~~~^~~~


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
