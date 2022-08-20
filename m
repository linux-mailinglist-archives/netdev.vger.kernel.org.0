Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8CE59AB60
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 06:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242114AbiHTE2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 00:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHTE2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 00:28:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0375E1DA5C;
        Fri, 19 Aug 2022 21:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660969711; x=1692505711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MfnOB1XGKfPqVQCIzu0mFWkAanwpdmkBPanbEOLwVDU=;
  b=V9dNXiZpekhdDkAN8b166m+jWFyLocce/Vq8FxL5J7RMxBt+XDKQZjWt
   ORPgI3a48LLsLck0OERsb1CvCkv1HwRGxyGREBtF+Dh8KnWJrdETxafdM
   19e0EoM0b9zIN+0l7n4RBtWBDC+mutn7hS3645coH8Vij3YLoaGXApM9E
   u+9agRefGM5Wco8Pfu3M5c1N+wOIXnvLh4CAk2omoO6QZFoia08qtnzh4
   HjVI4pJVF5AsiORKy7jb2jOR3YC0ikmJYd1Bc2MRFmDTqjCa8F3LDL0Wt
   Kl9s5Jl5eslEqupZxdT9LjUzKQRLgRAJhYfQMnLQY1GfH29RksZZuVPKt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="290709954"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="290709954"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 21:28:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="734600816"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2022 21:28:24 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oPG5w-00028t-0J;
        Sat, 20 Aug 2022 04:28:24 +0000
Date:   Sat, 20 Aug 2022 12:28:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     kbuild-all@lists.01.org, Daniel Xu <dxu@dxuuu.xyz>,
        pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        martin.lau@linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <202208201201.h5mCZpcU-lkp@intel.com>
References: <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220820-082411
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: nios2-randconfig-r005-20220820 (https://download.01.org/0day-ci/archive/20220820/202208201201.h5mCZpcU-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/20062077235a94dd0b856204b6dbddefe8342f01
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/bpf-Remove-duplicate-PTR_TO_BTF_ID-RO-check/20220820-082411
        git checkout 20062077235a94dd0b856204b6dbddefe8342f01
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   nios2-linux-ld: net/core/filter.o: in function `tc_cls_act_btf_struct_access':
   filter.c:(.text+0xd54): undefined reference to `nf_conntrack_btf_struct_access'
>> nios2-linux-ld: filter.c:(.text+0xd58): undefined reference to `nf_conntrack_btf_struct_access'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
