Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10AF4A027E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 22:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349466AbiA1VEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 16:04:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:39330 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344421AbiA1VEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 16:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643403846; x=1674939846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rRQi5U4fNXjd7il7SklJ7fYxH9Jsm7zneoJJFyQiclk=;
  b=E7JtnfaPJN3dIl7ZnWGHHKLGz/ZokWP3w3O9pj5392Es6rMxe2xngtZJ
   YdDleVJW9F5Gqg3HFvq1tSjxsaN01lMlSVuqagns3sdLvP0xch/VuYEtw
   1y4SybVcflw5Woh7k+qyxBNFN4R7FpwHLqKJwl6OovEInUkaS9ircgR9E
   p+oOToc6XsC4AewjnOMkHh3uq8my1yfqBVr7tn87XIc9PjXfEfJHwG2IW
   vF29wJRKu4gUr2o2jCq4c3425M3s6hHRjN7rINjGbkRDeZyVNA2NG6ICw
   XjjBK7mXfuwZyjcsFQdjfu0Z6cvZlTrHR1s4sue5IFYSABUuK2fgqqaTq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10241"; a="246969200"
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="246969200"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 13:04:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="629247635"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 28 Jan 2022 13:04:02 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDYPZ-000OJP-OP; Fri, 28 Jan 2022 21:04:01 +0000
Date:   Sat, 29 Jan 2022 05:03:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, luciano.coelho@intel.com
Cc:     kbuild-all@lists.01.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, trix@redhat.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH] dvm: use struct_size over open coded arithmetic
Message-ID: <202201290256.JxMfdzDu-lkp@intel.com>
References: <20220128080206.1211452-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128080206.1211452-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc1 next-20220128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/dvm-use-struct_size-over-open-coded-arithmetic/20220128-160349
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 23a46422c56144939c091c76cf389aa863ce9c18
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20220129/202201290256.JxMfdzDu-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/6ce283968f032a338616dbe570097f1639a66b75
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/dvm-use-struct_size-over-open-coded-arithmetic/20220128-160349
        git checkout 6ce283968f032a338616dbe570097f1639a66b75
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:30,
                    from arch/arm/include/asm/cacheflush.h:10,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/wireless/intel/iwlwifi/dvm/rx.c:12:
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c: In function 'iwlagn_rx_noa_notification':
>> include/linux/overflow.h:194:32: error: invalid type argument of '->' (have 'struct iwl_wipan_noa_data')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                ^~
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c:918:36: note: in expansion of macro 'struct_size'
     918 |                 new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
         |                                    ^~~~~~~~~~~
   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:21,
                    from include/linux/skbuff.h:13,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/wireless/intel/iwlwifi/dvm/rx.c:12:
   include/linux/overflow.h:194:63: error: invalid type argument of '->' (have 'struct iwl_wipan_noa_data')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                               ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:51: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                                   ^~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c:918:36: note: in expansion of macro 'struct_size'
     918 |                 new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
         |                                    ^~~~~~~~~~~
   include/linux/overflow.h:194:63: error: invalid type argument of '->' (have 'struct iwl_wipan_noa_data')
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                               ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:51: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                                   ^~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c:918:36: note: in expansion of macro 'struct_size'
     918 |                 new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
         |                                    ^~~~~~~~~~~
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:258:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     258 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:44: note: in expansion of macro '__must_be_array'
     194 |                     sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                            ^~~~~~~~~~~~~~~
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c:918:36: note: in expansion of macro 'struct_size'
     918 |                 new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
         |                                    ^~~~~~~~~~~
   In file included from include/linux/mm.h:30,
                    from arch/arm/include/asm/cacheflush.h:10,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/wireless/intel/iwlwifi/dvm/rx.c:12:
>> include/linux/overflow.h:195:28: error: invalid type argument of unary '*' (have 'struct iwl_wipan_noa_data')
     195 |                     sizeof(*(p)))
         |                            ^~~~
   drivers/net/wireless/intel/iwlwifi/dvm/rx.c:918:36: note: in expansion of macro 'struct_size'
     918 |                 new_data = kmalloc(struct_size(*new_data, data, len), GFP_ATOMIC);
         |                                    ^~~~~~~~~~~


vim +194 include/linux/overflow.h

610b15c50e86eb Kees Cook           2018-05-07  180  
610b15c50e86eb Kees Cook           2018-05-07  181  /**
610b15c50e86eb Kees Cook           2018-05-07  182   * struct_size() - Calculate size of structure with trailing array.
610b15c50e86eb Kees Cook           2018-05-07  183   * @p: Pointer to the structure.
610b15c50e86eb Kees Cook           2018-05-07  184   * @member: Name of the array member.
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  185   * @count: Number of elements in the array.
610b15c50e86eb Kees Cook           2018-05-07  186   *
610b15c50e86eb Kees Cook           2018-05-07  187   * Calculates size of memory needed for structure @p followed by an
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  188   * array of @count number of @member elements.
610b15c50e86eb Kees Cook           2018-05-07  189   *
610b15c50e86eb Kees Cook           2018-05-07  190   * Return: number of bytes needed or SIZE_MAX on overflow.
610b15c50e86eb Kees Cook           2018-05-07  191   */
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  192  #define struct_size(p, member, count)					\
b19d57d0f3cc6f Gustavo A. R. Silva 2020-06-08  193  	__ab_c_size(count,						\
610b15c50e86eb Kees Cook           2018-05-07 @194  		    sizeof(*(p)->member) + __must_be_array((p)->member),\
610b15c50e86eb Kees Cook           2018-05-07 @195  		    sizeof(*(p)))
610b15c50e86eb Kees Cook           2018-05-07  196  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
