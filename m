Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C69B5A8AAB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 03:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiIAB2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 21:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiIAB2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 21:28:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE188153D28;
        Wed, 31 Aug 2022 18:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661995704; x=1693531704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gDVcxENd9Twmx6QUkEgAsM0nHpantnVmDCKZztP04RI=;
  b=jTPUTxFwbH3D2jg40Kzdttv1CWeU0jIp6xWM272OQMwBNBTcnSE9yr8q
   frSj0btDmjf6xq7n5FuvZtNcCzs5Y+v4STsjMlmhPEsN+f97ecm1MzzWe
   6qcYoshj3AmS+VjXkz4AWwIXe2zN+ZrWzJuoDl9Qmk2UGETvwXh7cd4F1
   yWVTQiBtUx8+8jWlFWaQuoujUk1Nd84+x2o8VyKi1026VqO4I6xl2tcJI
   KmojnWZkos11nU586UimzaDH5FtIAgHskbrDd8h7jmoYBN4PRh12iOn1e
   f6tSn7ZIee+8IcH+ulb6JU85T/pwpjOZEJaZCrIpsDl2458EkTjHK4p8k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="278607670"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="278607670"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="642111538"
Received: from lkp-server02.sh.intel.com (HELO 811e2ceaf0e5) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 31 Aug 2022 18:28:20 -0700
Received: from kbuild by 811e2ceaf0e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTZ0G-0000vc-0K;
        Thu, 01 Sep 2022 01:28:20 +0000
Date:   Thu, 1 Sep 2022 09:27:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, memxor@gmail.com, toke@redhat.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: Add skb dynptrs
Message-ID: <202209010933.f4RMjrd9-lkp@intel.com>
References: <20220831183224.3754305-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831183224.3754305-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
config: arc-randconfig-r043-20220831 (https://download.01.org/0day-ci/archive/20220901/202209010933.f4RMjrd9-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/273adaa44c063c460e9a23123957a1864c5cc26c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220901-024122
        git checkout 273adaa44c063c460e9a23123957a1864c5cc26c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from kernel/sysctl.c:35:
>> include/linux/filter.h:1540:5: warning: no previous prototype for '__bpf_skb_load_bytes' [-Wmissing-prototypes]
    1540 | int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
         |     ^~~~~~~~~~~~~~~~~~~~
>> include/linux/filter.h:1545:5: warning: no previous prototype for '__bpf_skb_store_bytes' [-Wmissing-prototypes]
    1545 | int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
         |     ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from kernel/kallsyms.c:25:
>> include/linux/filter.h:1540:5: warning: no previous prototype for '__bpf_skb_load_bytes' [-Wmissing-prototypes]
    1540 | int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
         |     ^~~~~~~~~~~~~~~~~~~~
>> include/linux/filter.h:1545:5: warning: no previous prototype for '__bpf_skb_store_bytes' [-Wmissing-prototypes]
    1545 | int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
         |     ^~~~~~~~~~~~~~~~~~~~~
   kernel/kallsyms.c:570:12: warning: no previous prototype for 'arch_get_kallsym' [-Wmissing-prototypes]
     570 | int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
         |            ^~~~~~~~~~~~~~~~
--
   In file included from kernel/bpf/core.c:21:
>> include/linux/filter.h:1540:5: warning: no previous prototype for '__bpf_skb_load_bytes' [-Wmissing-prototypes]
    1540 | int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
         |     ^~~~~~~~~~~~~~~~~~~~
>> include/linux/filter.h:1545:5: warning: no previous prototype for '__bpf_skb_store_bytes' [-Wmissing-prototypes]
    1545 | int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
         |     ^~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/core.c:1623:12: warning: no previous prototype for 'bpf_probe_read_kernel' [-Wmissing-prototypes]
    1623 | u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
         |            ^~~~~~~~~~~~~~~~~~~~~
--
   In file included from include/linux/bpf_verifier.h:9,
                    from kernel/bpf/btf.c:19:
>> include/linux/filter.h:1540:5: warning: no previous prototype for '__bpf_skb_load_bytes' [-Wmissing-prototypes]
    1540 | int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
         |     ^~~~~~~~~~~~~~~~~~~~
>> include/linux/filter.h:1545:5: warning: no previous prototype for '__bpf_skb_store_bytes' [-Wmissing-prototypes]
    1545 | int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
         |     ^~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/btf.c: In function 'btf_seq_show':
   kernel/bpf/btf.c:6612:29: warning: function 'btf_seq_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    6612 |         seq_vprintf((struct seq_file *)show->target, fmt, args);
         |                             ^~~~~~~~
   kernel/bpf/btf.c: In function 'btf_snprintf_show':
   kernel/bpf/btf.c:6649:9: warning: function 'btf_snprintf_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
    6649 |         len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
         |         ^~~
--
   arc-elf-ld: drivers/target/target_core_hba.o: in function `__bpf_skb_load_bytes':
>> target_core_hba.c:(.text+0x1d8): multiple definition of `__bpf_skb_load_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb44): first defined here
   arc-elf-ld: drivers/target/target_core_hba.o: in function `__bpf_skb_store_bytes':
>> target_core_hba.c:(.text+0x1e0): multiple definition of `__bpf_skb_store_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb4c): first defined here
   arc-elf-ld: drivers/target/target_core_tpg.o: in function `__bpf_skb_load_bytes':
   target_core_tpg.c:(.text+0x664): multiple definition of `__bpf_skb_load_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb44): first defined here
   arc-elf-ld: drivers/target/target_core_tpg.o: in function `__bpf_skb_store_bytes':
   target_core_tpg.c:(.text+0x66c): multiple definition of `__bpf_skb_store_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb4c): first defined here
   arc-elf-ld: drivers/target/target_core_transport.o: in function `__bpf_skb_load_bytes':
   target_core_transport.c:(.text+0x4640): multiple definition of `__bpf_skb_load_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb44): first defined here
   arc-elf-ld: drivers/target/target_core_transport.o: in function `__bpf_skb_store_bytes':
   target_core_transport.c:(.text+0x4648): multiple definition of `__bpf_skb_store_bytes'; drivers/target/target_core_device.o:target_core_device.c:(.text+0xb4c): first defined here

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
