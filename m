Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2101B5A8B24
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiIAB62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 21:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiIAB60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 21:58:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256F9E924A;
        Wed, 31 Aug 2022 18:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661997506; x=1693533506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+QJK0DcrsKTyJk//SveBQx5j6h4eSCkpl5k0nQvH7do=;
  b=dk+dl+xaFp5I3/LwogJ0PS17aVJZKi/gnDDeYEwAd3KGZChTKNzMbEen
   fHQrZk0vyIMSLykme3qe4mfglX1NHc1DtJjzUkLaTFHSh5w0/ZN+IMOsU
   vXqm0le00ql7GOqbLNvWxPjQirkqBUK1h8lHr/PMokGeQaCTu33oQY8LM
   PUARKzKVtMEdim+twV4+rjL11daDeto4c+lhzi1J2uxYJYC8vmfljVbZc
   OeTuR1WMGpvot4nClj2fUG7ujcgLjZX0hIWQHMEklHWSnccIWb7eF96On
   v/PGMkWX9Eqpaz44Us+KjBT8F6GoC89ZGwa41DnfGyKhlbGso+jrUIPyX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="275341927"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="275341927"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:58:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="563259127"
Received: from lkp-server02.sh.intel.com (HELO 811e2ceaf0e5) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 31 Aug 2022 18:58:22 -0700
Received: from kbuild by 811e2ceaf0e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTZTK-0000yC-0M;
        Thu, 01 Sep 2022 01:58:22 +0000
Date:   Thu, 1 Sep 2022 09:58:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, andrii@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        memxor@gmail.com, toke@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: Add skb dynptrs
Message-ID: <202209010925.Du4GHGW9-lkp@intel.com>
References: <20220831183224.3754305-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831183224.3754305-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-skb-xdp-dynptrs/20220901-024122
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: hexagon-randconfig-r045-20220831 (https://download.01.org/0day-ci/archive/20220901/202209010925.Du4GHGW9-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project c55b41d5199d2394dd6cdb8f52180d8b81d809d4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/273adaa44c063c460e9a23123957a1864c5cc26c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220901-024122
        git checkout 273adaa44c063c460e9a23123957a1864c5cc26c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from kernel/sysctl.c:35:
>> include/linux/filter.h:1540:5: warning: no previous prototype for function '__bpf_skb_load_bytes' [-Wmissing-prototypes]
   int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
       ^
   include/linux/filter.h:1540:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
   ^
   static 
>> include/linux/filter.h:1545:5: warning: no previous prototype for function '__bpf_skb_store_bytes' [-Wmissing-prototypes]
   int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
       ^
   include/linux/filter.h:1545:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
   ^
   static 
   2 warnings generated.
--
   In file included from kernel/kallsyms.c:25:
>> include/linux/filter.h:1540:5: warning: no previous prototype for function '__bpf_skb_load_bytes' [-Wmissing-prototypes]
   int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
       ^
   include/linux/filter.h:1540:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
   ^
   static 
>> include/linux/filter.h:1545:5: warning: no previous prototype for function '__bpf_skb_store_bytes' [-Wmissing-prototypes]
   int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
       ^
   include/linux/filter.h:1545:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
   ^
   static 
   kernel/kallsyms.c:570:12: warning: no previous prototype for function 'arch_get_kallsym' [-Wmissing-prototypes]
   int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
              ^
   kernel/kallsyms.c:570:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
   ^
   static 
   3 warnings generated.
--
>> ld.lld: error: duplicate symbol: __bpf_skb_load_bytes
   >>> defined at filter.h:1542 (include/linux/filter.h:1542)
   >>>            sysctl.o:(__bpf_skb_load_bytes) in archive kernel/built-in.a
   >>> defined at filter.h:1542 (include/linux/filter.h:1542)
   >>>            extable.o:(.text+0x0) in archive kernel/built-in.a
--
>> ld.lld: error: duplicate symbol: __bpf_skb_store_bytes
   >>> defined at filter.h:1548 (include/linux/filter.h:1548)
   >>>            sysctl.o:(__bpf_skb_store_bytes) in archive kernel/built-in.a
   >>> defined at filter.h:1548 (include/linux/filter.h:1548)
   >>>            extable.o:(.text+0x8) in archive kernel/built-in.a
--
>> ld.lld: error: duplicate symbol: __bpf_skb_load_bytes
   >>> defined at filter.h:1542 (include/linux/filter.h:1542)
   >>>            sysctl.o:(__bpf_skb_load_bytes) in archive kernel/built-in.a
   >>> defined at filter.h:1542 (include/linux/filter.h:1542)
   >>>            kallsyms.o:(.text+0x0) in archive kernel/built-in.a
--
>> ld.lld: error: duplicate symbol: __bpf_skb_store_bytes
   >>> defined at filter.h:1548 (include/linux/filter.h:1548)
   >>>            sysctl.o:(__bpf_skb_store_bytes) in archive kernel/built-in.a
   >>> defined at filter.h:1548 (include/linux/filter.h:1548)
   >>>            kallsyms.o:(.text+0x8) in archive kernel/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
