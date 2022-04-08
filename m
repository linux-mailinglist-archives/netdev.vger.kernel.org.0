Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351214F8E99
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiDHErb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiDHEr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:47:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7128B12A;
        Thu,  7 Apr 2022 21:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649393124; x=1680929124;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0Um57j16VIm3UAAJbcdUmZW4zy0Fo9kHkNmKemxl03I=;
  b=FwWREW62uFrMFB8Wvq4ACOWBhwK02weTVqFaRsBKIu9Xch3YDLnKdYld
   s2/gALxBNsyGB7Ysb99qzYgwmzw+Nsqi4XPx/KUDttzIiHbX6QfzUddV3
   RTMSymUY9N7BGU2O+y9Ol+T4krx5UaskuhA323KbJRrjUdxdxyJGRFGxO
   MQlA6qJ7kZajUY5YDoJn1GsG7fXwB80bIUXB+ZmfEtAHy3IS5cunYD0Kx
   eicXrDtYFDK0drn5ip9BqlTKU80t+y9kZdef6h2WgvMJ0HDV67520NEW7
   orEIOXsivvqrc/eMX5a5+q+JsB7ctmIGbvS8FZ0sFXOrXK1Wl9cK16pzP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261201295"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="261201295"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 21:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="723248260"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 07 Apr 2022 21:45:20 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncgUp-00062R-Ff;
        Fri, 08 Apr 2022 04:45:19 +0000
Date:   Fri, 8 Apr 2022 12:44:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     kbuild-all@lists.01.org, casey@schaufler-ca.com,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v34 11/29] LSM: Use lsmblob in security_current_getsecid
Message-ID: <202204081233.FUUgdt5c-lkp@intel.com>
References: <20220407212230.12893-12-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407212230.12893-12-casey@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casey,

I love your patch! Perhaps something to improve:

[auto build test WARNING on pcmoore-selinux/next]
[also build test WARNING on linus/master v5.18-rc1 next-20220407]
[cannot apply to pcmoore-audit/next jmorris-security/next-testing]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Casey-Schaufler/integrity-disassociate-ima_filter_rule-from-security_audit_rule/20220408-062243
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git next
config: mips-randconfig-r002-20220408 (https://download.01.org/0day-ci/archive/20220408/202204081233.FUUgdt5c-lkp@intel.com/config)
compiler: mips64el-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0d4df6ae86e123057cb18eeb5ba1b1eff2641fe4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Casey-Schaufler/integrity-disassociate-ima_filter_rule-from-security_audit_rule/20220408-062243
        git checkout 0d4df6ae86e123057cb18eeb5ba1b1eff2641fe4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash security/integrity/ima/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   security/integrity/ima/ima_main.c: In function 'ima_file_check':
>> security/integrity/ima/ima_main.c:521:16: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     521 |         return process_measurement(file, current_cred(), blob.secid[0], NULL, 0,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     522 |                                    mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
         |                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     523 |                                            MAY_APPEND), FILE_CHECK);
         |                                            ~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:517:24: note: defined here 'blob'
     517 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'ima_file_mmap':
   security/integrity/ima/ima_main.c:413:24: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     413 |                 return process_measurement(file, current_cred(), blob.secid[0],
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     414 |                                            NULL, 0, MAY_EXEC, MMAP_CHECK);
         |                                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:408:24: note: defined here 'blob'
     408 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'ima_file_mprotect':
   security/integrity/ima/ima_main.c:453:18: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     453 |         action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
         |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     454 |                                 current_cred(), blob.secid[0], MAY_EXEC,
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     455 |                                 MMAP_CHECK, &pcr, &template, NULL, NULL);
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:441:24: note: defined here 'blob'
     441 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'ima_bprm_check':
   security/integrity/ima/ima_main.c:495:15: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     495 |         ret = process_measurement(bprm->file, current_cred(), blob.secid[0],
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     496 |                                   NULL, 0, MAY_EXEC, BPRM_CHECK);
         |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:491:24: note: defined here 'blob'
     491 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'ima_read_file':
   security/integrity/ima/ima_main.c:739:16: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     739 |         return process_measurement(file, current_cred(), blob.secid[0], NULL,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     740 |                                    0, MAY_READ, func);
         |                                    ~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:717:24: note: defined here 'blob'
     717 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'ima_post_read_file':
   security/integrity/ima/ima_main.c:783:16: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     783 |         return process_measurement(file, current_cred(), blob.secid[0], buf,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     784 |                                    size, MAY_READ, func);
         |                                    ~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:768:24: note: defined here 'blob'
     768 |         struct lsmblob blob;
         |                        ^~~~
   security/integrity/ima/ima_main.c: In function 'process_buffer_measurement':
   security/integrity/ima/ima_main.c:934:26: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
     934 |                 action = ima_get_action(mnt_userns, inode, current_cred(),
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     935 |                                         blob.secid[0], 0, func, &pcr, &template,
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     936 |                                         func_data, NULL);
         |                                         ~~~~~~~~~~~~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_main.c:26:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_main.c:909:24: note: defined here 'blob'
--
   security/integrity/ima/ima_appraise.c: In function 'ima_must_appraise':
>> security/integrity/ima/ima_appraise.c:81:16: warning: array subscript 0 is outside array bounds of 'u32[0]' {aka 'unsigned int[]'} [-Warray-bounds]
      81 |         return ima_match_policy(mnt_userns, inode, current_cred(),
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      82 |                                 blob.secid[0], func, mask,
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
      83 |                                 IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      84 |                                 NULL);
         |                                 ~~~~~
   In file included from include/linux/ima.h:12,
                    from security/integrity/ima/ima_appraise.c:14:
   include/linux/security.h:150:17: note: while referencing 'secid'
     150 |         u32     secid[LSMBLOB_ENTRIES];
         |                 ^~~~~
   security/integrity/ima/ima_appraise.c:74:24: note: defined here 'blob'
      74 |         struct lsmblob blob;
         |                        ^~~~


vim +521 security/integrity/ima/ima_main.c

   504	
   505	/**
   506	 * ima_file_check - based on policy, collect/store measurement.
   507	 * @file: pointer to the file to be measured
   508	 * @mask: contains MAY_READ, MAY_WRITE, MAY_EXEC or MAY_APPEND
   509	 *
   510	 * Measure files based on the ima_must_measure() policy decision.
   511	 *
   512	 * On success return 0.  On integrity appraisal error, assuming the file
   513	 * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
   514	 */
   515	int ima_file_check(struct file *file, int mask)
   516	{
   517		struct lsmblob blob;
   518	
   519		security_current_getsecid_subj(&blob);
   520		/* scaffolding until process_measurement changes */
 > 521		return process_measurement(file, current_cred(), blob.secid[0], NULL, 0,
   522					   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
   523						   MAY_APPEND), FILE_CHECK);
   524	}
   525	EXPORT_SYMBOL_GPL(ima_file_check);
   526	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
