Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672EF49F9AE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348619AbiA1MlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:41:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:25642 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237505AbiA1MlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 07:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643373683; x=1674909683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ztdVh+NZZ18Z6P1Aq48jKG/tZtlC6UcWlAOA5hHHMBE=;
  b=VNEDUQg+GzWPgkLlXCYQvn76Xc5E8jQ0y9eQ2eRMFHuKFGoDEpdJlBuC
   qeBwG8g+oKLpZ0yxIpNle/9FBwBWlVEeqZqfz8TCTHaVp68P39UmKn9aN
   eY74dNI0YfKXyXq4PptkN4RFbh84Flna7HyangtzDuUWqbYKbz9VkYOIl
   pLDFNoMAC3iKwBZl9+Mb5HWyvFNGy85Na9iBXqVV4nkHYAi/dtNVCc5rl
   cdpXpxcwU3ASPWBxOQCGjvCn8jUVzwVdM1qH33DOWF65IcvqspSC/JadF
   k3Sta5Qdxmgh7b1gDNjoaBwj6K63hT+rfZUpB/DHm6IcCDiJQGheOzhHj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="247060504"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="247060504"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 04:41:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="536118366"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 28 Jan 2022 04:41:20 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nDQZ6-000Nrp-32; Fri, 28 Jan 2022 12:41:20 +0000
Date:   Fri, 28 Jan 2022 20:40:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/802: use struct_size over open coded arithmetic
Message-ID: <202201282017.0TQvVTtf-lkp@intel.com>
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
config: riscv-randconfig-r042-20220124 (https://download.01.org/0day-ci/archive/20220128/202201282017.0TQvVTtf-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 33b45ee44b1f32ffdbc995e6fec806271b4b3ba4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/9b64e5078d3d779fc56432d43129479f63996c74
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/net-802-use-struct_size-over-open-coded-arithmetic/20220128-160925
        git checkout 9b64e5078d3d779fc56432d43129479f63996c74
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/wireless/ath/wcn36xx/ net/802/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/802/garp.c:187:17: error: member reference type 'struct garp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:18: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                               ~~~^
>> net/802/garp.c:187:17: error: indirection requires pointer operand ('unsigned char[]' invalid)
           attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                              ^~~~~~~~~~~~
>> net/802/garp.c:187:17: error: member reference type 'struct garp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:59: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/compiler_types.h:287:63: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                 ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/802/garp.c:187:17: error: member reference type 'struct garp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:65: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
   include/linux/compiler_types.h:287:74: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                            ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/802/garp.c:187:17: error: indirection requires pointer operand ('struct garp_attr' invalid)
           attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:195:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)))
                              ^~~~
   5 errors generated.
--
>> net/802/mrp.c:276:17: error: member reference type 'struct mrp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:18: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                               ~~~^
>> net/802/mrp.c:276:17: error: indirection requires pointer operand ('unsigned char[]' invalid)
           attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                              ^~~~~~~~~~~~
>> net/802/mrp.c:276:17: error: member reference type 'struct mrp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:59: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/compiler_types.h:287:63: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                 ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/802/mrp.c:276:17: error: member reference type 'struct mrp_attr' is not a pointer; did you mean to use '.'?
           attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:194:49: note: expanded from macro 'struct_size'
                       sizeof(*(p)->member) + __must_be_array((p)->member),\
                                              ~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   include/linux/compiler.h:258:65: note: expanded from macro '__must_be_array'
   #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
   include/linux/compiler_types.h:287:74: note: expanded from macro '__same_type'
   #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
                                                                            ^
   include/linux/build_bug.h:16:62: note: expanded from macro 'BUILD_BUG_ON_ZERO'
   #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
                                                                ^
>> net/802/mrp.c:276:17: error: indirection requires pointer operand ('struct mrp_attr' invalid)
           attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:195:14: note: expanded from macro 'struct_size'
                       sizeof(*(p)))
                              ^~~~
   5 errors generated.


vim +187 net/802/garp.c

   166	
   167	static struct garp_attr *garp_attr_create(struct garp_applicant *app,
   168						  const void *data, u8 len, u8 type)
   169	{
   170		struct rb_node *parent = NULL, **p = &app->gid.rb_node;
   171		struct garp_attr *attr;
   172		int d;
   173	
   174		while (*p) {
   175			parent = *p;
   176			attr = rb_entry(parent, struct garp_attr, node);
   177			d = garp_attr_cmp(attr, data, len, type);
   178			if (d > 0)
   179				p = &parent->rb_left;
   180			else if (d < 0)
   181				p = &parent->rb_right;
   182			else {
   183				/* The attribute already exists; re-use it. */
   184				return attr;
   185			}
   186		}
 > 187		attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
   188		if (!attr)
   189			return attr;
   190		attr->state = GARP_APPLICANT_VO;
   191		attr->type  = type;
   192		attr->dlen  = len;
   193		memcpy(attr->data, data, len);
   194	
   195		rb_link_node(&attr->node, parent, p);
   196		rb_insert_color(&attr->node, &app->gid);
   197		return attr;
   198	}
   199	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
