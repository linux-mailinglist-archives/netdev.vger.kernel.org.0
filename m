Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238E54F8DFF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiDHDqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiDHDqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:46:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B4AC92E;
        Thu,  7 Apr 2022 20:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649389461; x=1680925461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IM4iBK3U8QJywOCMgFROUzizS6PUIpTFKrPyenWYVU4=;
  b=ZCT1fU56zzoMZ/WgIkmgZ2KVEw/4dCbnC0zw6Lw53/Psr3k8rMJdin3G
   FnbglK9YcxzAWb7Y7BaACy+c/StkMTZxCrDX3fhdcE5M+75RbieNcZXCI
   sEKQxnOsBcYUmO8A1nmHtiVTz51CBH7uyts3yYwBpMdO8Y+4kEiKKGXjd
   Uj1Lp7wYJAZFhI6lh7tExMuUMbkctAvxpVXafHROxXTpTL7z63QzmNtBi
   AK5LJbtACkFx+pSOAMEHaNiUPpaXcwe4IB/C3OyylbbRIouLP5YCM1niy
   vtGJm05B/mfYCVZJonDR0hcbNV/U72+IvEjmMw61+mIbRBm2eXsh/NrIb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="260335403"
X-IronPort-AV: E=Sophos;i="5.90,243,1643702400"; 
   d="scan'208";a="260335403"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 20:44:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,243,1643702400"; 
   d="scan'208";a="851925493"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 07 Apr 2022 20:44:17 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncfXl-00060p-6Z;
        Fri, 08 Apr 2022 03:44:17 +0000
Date:   Fri, 8 Apr 2022 11:43:33 +0800
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
Message-ID: <202204081146.DPLvGqQ7-lkp@intel.com>
References: <20220407212230.12893-12-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407212230.12893-12-casey@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
config: arm-randconfig-c002-20220408 (https://download.01.org/0day-ci/archive/20220408/202204081146.DPLvGqQ7-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0d4df6ae86e123057cb18eeb5ba1b1eff2641fe4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Casey-Schaufler/integrity-disassociate-ima_filter_rule-from-security_audit_rule/20220408-062243
        git checkout 0d4df6ae86e123057cb18eeb5ba1b1eff2641fe4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash security/integrity/ima/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

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


vim +81 security/integrity/ima/ima_appraise.c

    65	
    66	/*
    67	 * ima_must_appraise - set appraise flag
    68	 *
    69	 * Return 1 to appraise or hash
    70	 */
    71	int ima_must_appraise(struct user_namespace *mnt_userns, struct inode *inode,
    72			      int mask, enum ima_hooks func)
    73	{
    74		struct lsmblob blob;
    75	
    76		if (!ima_appraise)
    77			return 0;
    78	
    79		security_current_getsecid_subj(&blob);
    80		/* scaffolding the .secid[0] */
  > 81		return ima_match_policy(mnt_userns, inode, current_cred(),
    82					blob.secid[0], func, mask,
    83					IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
    84					NULL);
    85	}
    86	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
