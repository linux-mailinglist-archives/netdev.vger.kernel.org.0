Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B994EA54E
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiC2Cii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiC2Cib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:38:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F632467DD;
        Mon, 28 Mar 2022 19:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648521409; x=1680057409;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LNHgqLDR8PycGfDeEiYuRN193gJyruOeIO57tRrWPxs=;
  b=QtNizHn0ORe+GwXpIORa1Os+CFrzOaLghkdtU30LxgQ+ss28GI+Sm3hz
   hVEkkyZWNh8BE/b72RuS8fvWh1NBtL2BfMAsykGLz2oWiXCLMxcE0Vwgi
   Xbl+b3hkwJx+UCIRMHZig4FbAFcYUzYXDOdFZ2vcag0B5el/SN9ZsoWV3
   TCTPTB+nYksrI5KfK67elg75DdrzS8jkL2EjhkW0Yn2TbydDuQTmAGCom
   c+1E/rJpZwlpSPmXlNOT17dct0MhSKFJzfQtMYXEQNVXKNuNgX3DUcQq6
   EqCmi/+CoixIxr14WtqiDfg2cNqhwJfu6ll8H2xt1prCWlrjXbmj4aJjA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="239077896"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="239077896"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 19:36:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="518615068"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 28 Mar 2022 19:36:43 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nZ1is-0002Xv-FZ; Tue, 29 Mar 2022 02:36:42 +0000
Date:   Tue, 29 Mar 2022 10:35:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, corbet@lwn.net,
        viro@zeniv.linux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kpsingh@kernel.org, shuah@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        zohar@linux.ibm.com
Cc:     kbuild-all@lists.01.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 14/18] bpf-preload: Switch to new preload registration
 method
Message-ID: <202203291042.8dll5BFm-lkp@intel.com>
References: <20220328175033.2437312-15-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328175033.2437312-15-roberto.sassu@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]
[also build test ERROR on linus/master next-20220328]
[cannot apply to bpf/master v5.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-c001 (https://download.01.org/0day-ci/archive/20220329/202203291042.8dll5BFm-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2e0e81b0296abc384efb2a73520ce03c2a5344ea
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Secure-and-authenticated-preloading-of-eBPF-programs/20220329-015829
        git checkout 2e0e81b0296abc384efb2a73520ce03c2a5344ea
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> kernel/bpf/inode.c:25:37: error: 'CONFIG_BPF_PRELOAD_LIST' undeclared here (not in a function)
      25 | static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~


vim +/CONFIG_BPF_PRELOAD_LIST +25 kernel/bpf/inode.c

    24	
  > 25	static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
    26	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
