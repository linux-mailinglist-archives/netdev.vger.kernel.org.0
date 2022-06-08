Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D33754360F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbiFHPGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242504AbiFHPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:05:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5173826B96B;
        Wed,  8 Jun 2022 07:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654700253; x=1686236253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vabkUfz2r5crtrIrJqk2A20R0OQx7I0ukNGf+NHVR10=;
  b=Uqh6wab9Ud1bgRlPBUeeVRCWsKzFyQoenBrbzHpT/tqGlTxEb50VXH5E
   4ChG/dmZkRrNE/Z2Pv5nhiwPCQswMfoSt8/nPyexC+ciPcUK4JyNhn99+
   VhbRWgStb2moKesatl/QnWX5cGKVL3H8Y7GjIrImldmHHSAw7eJ+8OfhP
   3NiQ4Ft2WqoKfkueCAutmYAAYpaUwJskwcNHa5ckTtGiggt9dl6Ohav94
   ZoEfV04Qqc1+dCp63JwYEg3JaZnHtfccCR1+EUry/aZOL+YFZEjSrvoeh
   UmfMcAXuVcc0z7IO/beu1tef4q6rWoDOs8sfDHQKCtPj5bg6wZNrERWvY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="363250872"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="363250872"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 07:49:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="580090504"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 08 Jun 2022 07:49:35 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nyx03-000EiI-8k;
        Wed, 08 Jun 2022 14:49:35 +0000
Date:   Wed, 8 Jun 2022 22:48:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v2 1/3] bpf: Add bpf_verify_pkcs7_signature() helper
Message-ID: <202206082219.09oAvCwe-lkp@intel.com>
References: <20220608111221.373833-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608111221.373833-2-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on bpf/master]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Add-bpf_verify_pkcs7_signature-helper/20220608-192110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220608/202206082219.09oAvCwe-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/223914a2278b692d4120315d2fc7a29e3b89512a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Add-bpf_verify_pkcs7_signature-helper/20220608-192110
        git checkout 223914a2278b692d4120315d2fc7a29e3b89512a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/bpf_lsm.c: In function '____bpf_verify_pkcs7_signature':
>> kernel/bpf/bpf_lsm.c:146:38: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     146 |                                      (struct key *)keyring,
         |                                      ^


vim +146 kernel/bpf/bpf_lsm.c

   135	
   136	BPF_CALL_5(bpf_verify_pkcs7_signature, u8 *, data, u32, datalen, u8 *, sig,
   137		   u32, siglen, u64, keyring)
   138	{
   139		int ret = -EOPNOTSUPP;
   140	
   141	#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
   142		if (keyring > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
   143			return -EINVAL;
   144	
   145		ret = verify_pkcs7_signature(data, datalen, sig, siglen,
 > 146					     (struct key *)keyring,
   147					     VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
   148					     NULL);
   149	#endif
   150		return ret;
   151	}
   152	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
