Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEA8598D6F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345891AbiHRUIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345529AbiHRUIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:08:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134D13AE59;
        Thu, 18 Aug 2022 13:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660853006; x=1692389006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hK4joLjW67roEfSg9L3o4RSW3LVg032fexmMiJB4qHE=;
  b=GkDAWOARvETiowcvSZ4tteFXcJrlxFrfCe5AHfrbu16u9Wj7WV70WEcQ
   gLSanioLOadt4kCSOC7NVO8RbgzaH1sTlxCtU3ZWYbnEjV5naMPe6UQeB
   UJrTaZYuLGUGOy4c4pK0KrWQUSNXRT9AA8n8Hh3Fv7ajHVuFXNrFik7+E
   KKpbtj7eD1QIiXUXcM8bDQ3o+bNXO4DjPxb3wKz/W/+jlcu3R9h5INmob
   AS6rtmtsMpaq0lBAGqlN0eOdPG11JV8GsmuuEpVitS314RaKQ+niuPkGP
   qDaEB1GDUWDeafAt46lfPqXdZ5Hu0v/pvJdyB37nvehljvKIiwmG6KSjY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="293648497"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="293648497"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 13:02:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="734179034"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 18 Aug 2022 13:02:07 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOliR-0000WH-01;
        Thu, 18 Aug 2022 20:02:07 +0000
Date:   Fri, 19 Aug 2022 04:01:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Message-ID: <202208190318.HygywK17-lkp@intel.com>
References: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/Support-direct-writes-to-nf_conn-mark/20220816-060429
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: arm-versatile_defconfig (https://download.01.org/0day-ci/archive/20220819/202208190318.HygywK17-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/c7b21d163eb9c61514dd86baf4281deb4d4387bb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/Support-direct-writes-to-nf_conn-mark/20220816-060429
        git checkout c7b21d163eb9c61514dd86baf4281deb4d4387bb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/core/filter.c:8723:10: error: call to undeclared function 'btf_struct_access'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
                          ^
   net/core/filter.c:8797:10: error: call to undeclared function 'btf_struct_access'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
                          ^
   2 errors generated.


vim +/btf_struct_access +8723 net/core/filter.c

  8714	
  8715	static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
  8716						const struct btf *btf,
  8717						const struct btf_type *t, int off,
  8718						int size, enum bpf_access_type atype,
  8719						u32 *next_btf_id,
  8720						enum bpf_type_flag *flag)
  8721	{
  8722		if (atype == BPF_READ)
> 8723			return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
  8724						 flag);
  8725	
  8726		return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
  8727						      next_btf_id, flag);
  8728	}
  8729	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
