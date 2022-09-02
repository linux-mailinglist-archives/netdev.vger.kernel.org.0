Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FEF5AAE32
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbiIBMQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiIBMQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:16:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA7EC2F92;
        Fri,  2 Sep 2022 05:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662120999; x=1693656999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CJ7K6MAmvy9eYTd7oP1wszLEZKBCQJ6tFK2SaopjaYI=;
  b=Rzs0+2nyXx00SSq6SgHv/p7hUhLoqv/wHOoFB1v12CAXOL2TO6LBzXX/
   Ky+VtPEcqsqZuXwOaLjckJHMs0HivQkGLU1AV6hgLxb2QJb3hjiA0NnQ7
   iWaHUVeFKeNfO89VU6k2XFQolGMLbbmmbDvy0L6fydGCEBHgIN9di4EwI
   lp/KZBOqHEEkApjzi+TPF9tJPqUrio4tVmEqJG2ij47ai2jH/gcYXM0IQ
   ZVurhisjy74nfCEvQbPWjH/UU5BZQ6rDlIOset0bYF4YjgtvPTjUKTnpX
   ihHcH5Tx5ZGkKXDqDB4xCry0kNsdwF7wlouRrIo/0E3TmXYMbKXFxvPm5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="278983881"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="278983881"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 05:16:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="681270907"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 02 Sep 2022 05:16:34 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oU5b8-000039-0W;
        Fri, 02 Sep 2022 12:16:34 +0000
Date:   Fri, 2 Sep 2022 20:16:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     kbuild-all@lists.01.org, Daniel Xu <dxu@dxuuu.xyz>,
        pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        martin.lau@linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <202209022000.s58TmR9h-lkp@intel.com>
References: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220823-032643
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220902/202209022000.s58TmR9h-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/496ec6d75c8e8758f93c6b987eee83713c911a05
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220823-032643
        git checkout 496ec6d75c8e8758f93c6b987eee83713c911a05
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/core/filter.o: in function `tc_cls_act_btf_struct_access':
>> net/core/filter.c:8644: undefined reference to `nf_conntrack_btf_struct_access'
   ld: net/core/filter.o: in function `xdp_btf_struct_access':
   include/net/net_namespace.h:369: undefined reference to `nf_conntrack_btf_struct_access'
   pahole: .tmp_vmlinux.btf: No such file or directory
   .btf.vmlinux.bin.o: file not recognized: file format not recognized


vim +8644 net/core/filter.c

  8632	
  8633	static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
  8634						const struct btf *btf,
  8635						const struct btf_type *t, int off,
  8636						int size, enum bpf_access_type atype,
  8637						u32 *next_btf_id,
  8638						enum bpf_type_flag *flag)
  8639	{
  8640		if (atype == BPF_READ)
  8641			return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
  8642						 flag);
  8643	
> 8644		return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
  8645						      next_btf_id, flag);
  8646	}
  8647	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
