Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A318F49FA19
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348759AbiA1MvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:51:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:56684 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348747AbiA1MvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 07:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643374283; x=1674910283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2MSnnwmn8vkD3zNXwCEuoiVTvH47x4daX/oVgUn/RIA=;
  b=Y4wEBw/zhFZBofrymw0XuJNYdYF3WUgYes4YWwt3DEIEwf6RCoOXNXlh
   liohZmdcAgAF+ZunyHhqq7Pxmekioopfg454Ssgh/fqRNHJGkbAZapKeV
   F8FRivdNss4FC0TQgO+gn1D0UsusxHMqV75P1xCeK46ZBV8e67W65CBk0
   blih8NiZJJ625hw+hrgauqyjikS0f8Fq3QTLBH5zNK3qWye8Mu6u6LD4L
   aG3OYMucgN2caM12Ei/Xp5Cd32yfDZYVBhS8XjiVv3sW0CANpVEaGxefs
   KHecm65iQgDsAqF8WWl7L7TFymdhvu28mtN/eEyha4U5ZwXPpk6QiT74N
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="307829398"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="307829398"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 04:51:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="478276861"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 28 Jan 2022 04:51:20 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDQim-000NsP-8Z; Fri, 28 Jan 2022 12:51:20 +0000
Date:   Fri, 28 Jan 2022 20:51:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/802: use struct_size over open coded arithmetic
Message-ID: <202201282010.gkSF8kZF-lkp@intel.com>
References: <20220128080541.1211668-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128080541.1211668-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.17-rc1 next-20220128]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/net-802-use-struct_size-over-open-coded-arithmetic/20220128-160925
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 72d044e4bfa6bd9096536e2e1c62aecfe1a525e4
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220128/202201282010.gkSF8kZF-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/9b64e5078d3d779fc56432d43129479f63996c74
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/net-802-use-struct_size-over-open-coded-arithmetic/20220128-160925
        git checkout 9b64e5078d3d779fc56432d43129479f63996c74
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:30,
                    from arch/x86/include/asm/cacheflush.h:5,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from net/802/mrp.c:12:
   net/802/mrp.c: In function 'mrp_attr_create':
>> include/linux/overflow.h:194:18: error: invalid type argument of '->' (have 'struct mrp_attr')
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                  ^~
   net/802/mrp.c:276:17: note: in expansion of macro 'struct_size'
     276 |  attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
         |                 ^~~~~~~~~~~
   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:21,
                    from net/802/mrp.c:10:
   include/linux/overflow.h:194:49: error: invalid type argument of '->' (have 'struct mrp_attr')
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                 ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:46: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                              ^~~~~~~~~~~
   include/linux/overflow.h:194:30: note: in expansion of macro '__must_be_array'
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                              ^~~~~~~~~~~~~~~
   net/802/mrp.c:276:17: note: in expansion of macro 'struct_size'
     276 |  attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
         |                 ^~~~~~~~~~~
   include/linux/overflow.h:194:49: error: invalid type argument of '->' (have 'struct mrp_attr')
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                                                 ^~
   include/linux/build_bug.h:16:62: note: in definition of macro 'BUILD_BUG_ON_ZERO'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                              ^
   include/linux/compiler.h:258:46: note: in expansion of macro '__same_type'
     258 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                              ^~~~~~~~~~~
   include/linux/overflow.h:194:30: note: in expansion of macro '__must_be_array'
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                              ^~~~~~~~~~~~~~~
   net/802/mrp.c:276:17: note: in expansion of macro 'struct_size'
     276 |  attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
         |                 ^~~~~~~~~~~
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:258:28: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     258 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                            ^~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:30: note: in expansion of macro '__must_be_array'
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                              ^~~~~~~~~~~~~~~
   net/802/mrp.c:276:17: note: in expansion of macro 'struct_size'
     276 |  attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
         |                 ^~~~~~~~~~~
   In file included from include/linux/mm.h:30,
                    from arch/x86/include/asm/cacheflush.h:5,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from net/802/mrp.c:12:
>> include/linux/overflow.h:195:14: error: invalid type argument of unary '*' (have 'struct mrp_attr')
     195 |       sizeof(*(p)))
         |              ^~~~
   net/802/mrp.c:276:17: note: in expansion of macro 'struct_size'
     276 |  attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
         |                 ^~~~~~~~~~~


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
