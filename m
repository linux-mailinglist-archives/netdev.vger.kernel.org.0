Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4709651936F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343514AbiEDBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbiEDBZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:25:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD034616F;
        Tue,  3 May 2022 18:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651627235; x=1683163235;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i4MxkxPDNSGtzMvlquogsvEU8lFtzY2vpeFrQnL7YOU=;
  b=XM9QFrmZspa71IODuBGPKLe8jAEGqod/CRPLKATvxIqfNM+Bbf0wLYgA
   ltahLkLodmGS9fp/hikMdbAbFCN6Yw9CSudtzs3AuJlv4MKmKI0SIId09
   HtxaDbomHcPs6LxteZOHJWszPxnVblmw2kNH0JsBD5KWLVXXMM0bNXCto
   P6M/FpvrbrQlZeLCVOSioDm+jgOZnNndFWIfFjcP0qw77GLINjYInvKF8
   EtznMu+aFlJxDvwV9bl9PYdFBsAYIQ9yt8vSPXVOQRewIu3EMJULW++cD
   h66q6IIEYDgqVeSKP2Sp0GhWz6qnp8Di1MdnRi1K/Nmi3PdTcb+6iUGPh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="354072558"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="354072558"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 18:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="516817108"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 03 May 2022 18:19:33 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nm3fw-000Avv-BI;
        Wed, 04 May 2022 01:19:32 +0000
Date:   Wed, 4 May 2022 09:19:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guowei Du <duguoweisz@gmail.com>, jack@suse.cz
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, amir73il@gmail.com,
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
Message-ID: <202205040959.SAV6vlzH-lkp@intel.com>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183750.1977-1-duguoweisz@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guowei,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on pcmoore-selinux/next]
[also build test ERROR on linus/master v5.18-rc5]
[cannot apply to jack-fs/fsnotify next-20220503]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Guowei-Du/fsnotify-add-generic-perm-check-for-unlink-rmdir/20220504-024310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git next
config: hexagon-randconfig-r041-20220501 (https://download.01.org/0day-ci/archive/20220504/202205040959.SAV6vlzH-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 363b3a645a1e30011cc8da624f13dac5fd915628)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6f635019bbd2ab22a64e03164c8812a46531966e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guowei-Du/fsnotify-add-generic-perm-check-for-unlink-rmdir/20220504-024310
        git checkout 6f635019bbd2ab22a64e03164c8812a46531966e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> security/security.c:1169:28: error: passing 'const struct path *' to parameter of type 'struct path *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
           return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
                                     ^~~
   include/linux/fsnotify.h:83:51: note: passing argument to parameter 'path' here
   static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
                                                     ^
   security/security.c:1180:28: error: passing 'const struct path *' to parameter of type 'struct path *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
           return fsnotify_path_perm(dir, dentry, MAY_UNLINK);
                                     ^~~
   include/linux/fsnotify.h:83:51: note: passing argument to parameter 'path' here
   static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
                                                     ^
   2 errors generated.


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
