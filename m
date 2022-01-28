Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A228649FEB7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350474AbiA1RNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:13:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:14665 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239932AbiA1RNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 12:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643390033; x=1674926033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DlxeEj08eU3l+CcffcmNLw4TqlFei4v68U+XxbQa+Yo=;
  b=M+p7axsouZH1tg+0P7l5IcP8wIIjHDbUcf2bM6uwZimJEaJcdWbOriXP
   mOxlJ5PI7drFxSac9awhQ2zoYPAQyUcppRPZ1RhjAGB+622A8OcgiKtRR
   5HOjwABqB08s0+uzJjcs1AgvN5FpopXQD0wISNUqeQCSR92Q+3us2+Chv
   9hYRAbxIWB+BcugsdJQTBm+uGcXyXxefMit2jgBCbO2gPkRzcabv15Av9
   /9jOi5T+umITp7aStfiZMxsS+49dMJcysTPuiGYwcs5OUWI6Xe7iyOBmD
   Z8pw2gYY9uRij7OSTrkuMerhftxXoZAiQS1DIKx9S8S9CBMPoXrpUTN0H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="307886910"
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="307886910"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 09:06:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="581909687"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jan 2022 09:06:38 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDUhq-000O74-3o; Fri, 28 Jan 2022 17:06:38 +0000
Date:   Sat, 29 Jan 2022 01:06:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, jiri@resnulli.us
Cc:     kbuild-all@lists.01.org, ivecera@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/switchdev: use struct_size over open coded arithmetic
Message-ID: <202201290005.GR1IxnQb-lkp@intel.com>
References: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
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

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/net-switchdev-use-struct_size-over-open-coded-arithmetic/20220128-155848
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 23a46422c56144939c091c76cf389aa863ce9c18
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220129/202201290005.GR1IxnQb-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/bf0e33a8c3deb700b95173a37dd16754341ba70e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/net-switchdev-use-struct_size-over-open-coded-arithmetic/20220128-155848
        git checkout bf0e33a8c3deb700b95173a37dd16754341ba70e
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:30,
                    from arch/x86/include/asm/cacheflush.h:5,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/net/net_namespace.h:40,
                    from include/linux/netdevice.h:37,
                    from net/switchdev/switchdev.c:13:
   net/switchdev/switchdev.c: In function 'switchdev_deferred_enqueue':
>> include/linux/overflow.h:194:18: error: invalid type argument of '->' (have 'struct switchdev_deferred_item')
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                  ^~
   net/switchdev/switchdev.c:88:19: note: in expansion of macro 'struct_size'
      88 |  dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
         |                   ^~~~~~~~~~~
   In file included from include/linux/container_of.h:5,
                    from include/linux/kernel.h:21,
                    from net/switchdev/switchdev.c:8:
   include/linux/overflow.h:194:49: error: invalid type argument of '->' (have 'struct switchdev_deferred_item')
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
   net/switchdev/switchdev.c:88:19: note: in expansion of macro 'struct_size'
      88 |  dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
         |                   ^~~~~~~~~~~
   include/linux/overflow.h:194:49: error: invalid type argument of '->' (have 'struct switchdev_deferred_item')
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
   net/switchdev/switchdev.c:88:19: note: in expansion of macro 'struct_size'
      88 |  dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
         |                   ^~~~~~~~~~~
   include/linux/build_bug.h:16:51: error: bit-field '<anonymous>' width not an integer constant
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:258:28: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     258 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                            ^~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:30: note: in expansion of macro '__must_be_array'
     194 |       sizeof(*(p)->member) + __must_be_array((p)->member),\
         |                              ^~~~~~~~~~~~~~~
   net/switchdev/switchdev.c:88:19: note: in expansion of macro 'struct_size'
      88 |  dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
         |                   ^~~~~~~~~~~
   In file included from include/linux/mm.h:30,
                    from arch/x86/include/asm/cacheflush.h:5,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/skbuff.h:17,
                    from include/net/net_namespace.h:40,
                    from include/linux/netdevice.h:37,
                    from net/switchdev/switchdev.c:13:
>> include/linux/overflow.h:195:14: error: invalid type argument of unary '*' (have 'struct switchdev_deferred_item')
     195 |       sizeof(*(p)))
         |              ^~~~
   net/switchdev/switchdev.c:88:19: note: in expansion of macro 'struct_size'
      88 |  dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
         |                   ^~~~~~~~~~~


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
