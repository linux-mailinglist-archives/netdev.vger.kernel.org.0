Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3157B189
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiGTHRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiGTHRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:17:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54C642AF8;
        Wed, 20 Jul 2022 00:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658301437; x=1689837437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1nodBnQLzYMmQ5JiDReJknJ4ovopOxI3fMdDU4D3o+A=;
  b=jQmV/tZ/gIGi4OUh/80xIpjgpvYh4HQXV7I0yINR5kHfUeez/YVpfvEJ
   iqkvrJSQNE8OSBX4swUjcLz8T75pCS+BWOTiqJMTB38+VBnttEGGN+hbE
   2mFDHTQSb0IlpF7uFT1sk/2MVWHMLqga8m3QoPoGXsqsYkSp3OnGtjzLy
   mJ5vXmCfpdC6EVtmFmiLEw83SliHa6nbm2qYChrk3Yp9Vb8nHX8hco9Gr
   N98X4FcedBsDjUiCjH4868Djr5w4UCUGGfi0enwr/ogJt/ganvWlyhty7
   8oze9U/iYzJ6fXN9M03uzL17gD96cUBPYHrg/Prk4hC3ERyZ1Zfodm6/l
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348395224"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="348395224"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 00:17:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="665753842"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2022 00:17:15 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oE3xK-0000Aj-9t;
        Wed, 20 Jul 2022 07:17:14 +0000
Date:   Wed, 20 Jul 2022 15:16:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xu Jia <xujia39@huawei.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, xujia39@huawei.com
Subject: Re: [PATCH bpf-next] bpf: fix bpf compile error caused by
 CONFIG_CGROUP_BPF
Message-ID: <202207201518.zmoBBoB6-lkp@intel.com>
References: <1658221305-35718-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658221305-35718-1-git-send-email-xujia39@huawei.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xu-Jia/bpf-fix-bpf-compile-error-caused-by-CONFIG_CGROUP_BPF/20220719-165058
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-a005-20220718 (https://download.01.org/0day-ci/archive/20220720/202207201518.zmoBBoB6-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project dd5635541cd7bbd62cd59b6694dfb759b6e9a0d8)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cfd7055cd0be7cfd0de5c24a84c29afe0611cb6c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xu-Jia/bpf-fix-bpf-compile-error-caused-by-CONFIG_CGROUP_BPF/20220719-165058
        git checkout cfd7055cd0be7cfd0de5c24a84c29afe0611cb6c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/ufs/core/ kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/bpf/trampoline.c:526:34: warning: unused variable 'bpf_shim_tramp_link_lops' [-Wunused-const-variable]
   static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
                                    ^
   1 warning generated.


vim +/bpf_shim_tramp_link_lops +526 kernel/bpf/trampoline.c

69fd337a975c7e Stanislav Fomichev 2022-06-28  525  
69fd337a975c7e Stanislav Fomichev 2022-06-28 @526  static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
69fd337a975c7e Stanislav Fomichev 2022-06-28  527  	.release = bpf_shim_tramp_link_release,
69fd337a975c7e Stanislav Fomichev 2022-06-28  528  	.dealloc = bpf_shim_tramp_link_dealloc,
69fd337a975c7e Stanislav Fomichev 2022-06-28  529  };
69fd337a975c7e Stanislav Fomichev 2022-06-28  530  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
