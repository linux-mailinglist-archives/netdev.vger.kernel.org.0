Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F041D4A7EE7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiBCFXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:23:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:45205 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbiBCFXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 00:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643865831; x=1675401831;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fG0m/RXUF4OlUWOTpCXAv3rLGBTu2HjEplkreSuJKL4=;
  b=AbYeaSjGoLDU+OayYV9TaaoVo/lkKf3B46d8F7h+pg6WRmct8uFToTvg
   nxNKCFIC8Vk3QB5x1izn+mKRQPBlgpSzs2W112cO+LsEnAasxhJpga8QU
   5AYPk2TIesPuWrvEKqIZdUojQHq9wCtZBOOTsQZerprb2TlQ7tOKEXNzt
   9+1Ucz1yL3hufCy6Xp3C9qIfK3IP9pfjFhq2r9Or1HKnSZn2dGNvdNMQ1
   FB7aEXlYQ5hYdSpGZIu94YARyGn1VFTVlBdYz9JaSXAxa5D4fygb1rPpr
   aqYHS2wRjdoW3CLAQ1xoHu7OX9Gq+0LZ52KVoWHCFEBnXXVZT/y+uqWM8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="272568022"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="272568022"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 21:23:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="480373471"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2022 21:23:48 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFUax-000Ve9-Ll; Thu, 03 Feb 2022 05:23:47 +0000
Date:   Thu, 3 Feb 2022 13:23:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Message-ID: <202202031315.B425Ipe8-lkp@intel.com>
References: <20220203015140.3022854-10-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203015140.3022854-10-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52dae93f3bad842c6d585700460a0dea4d70e096
config: hexagon-randconfig-r045-20220130 (https://download.01.org/0day-ci/archive/20220203/202202031315.B425Ipe8-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a73e4ce6a59b01f0e37037761c1e6889d539d233)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
        git checkout 64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/bpf/btf.c:22:
>> include/linux/skmsg.h:41:1: error: static_assert failed due to requirement '32 >= (45UL + 1)' "BITS_PER_LONG >= NR_MSG_FRAG_IDS"
   static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: expanded from macro 'static_assert'
   #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:41: note: expanded from macro '__static_assert'
   #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                           ^              ~~~~
   1 error generated.


vim +41 include/linux/skmsg.h

604326b41a6fb9 Daniel Borkmann 2018-10-13  25  
604326b41a6fb9 Daniel Borkmann 2018-10-13  26  struct sk_msg_sg {
604326b41a6fb9 Daniel Borkmann 2018-10-13  27  	u32				start;
604326b41a6fb9 Daniel Borkmann 2018-10-13  28  	u32				curr;
604326b41a6fb9 Daniel Borkmann 2018-10-13  29  	u32				end;
604326b41a6fb9 Daniel Borkmann 2018-10-13  30  	u32				size;
604326b41a6fb9 Daniel Borkmann 2018-10-13  31  	u32				copybreak;
163ab96b52ae2b Jakub Kicinski  2019-10-06  32  	unsigned long			copy;
031097d9e079e4 Jakub Kicinski  2019-11-27  33  	/* The extra two elements:
031097d9e079e4 Jakub Kicinski  2019-11-27  34  	 * 1) used for chaining the front and sections when the list becomes
031097d9e079e4 Jakub Kicinski  2019-11-27  35  	 *    partitioned (e.g. end < start). The crypto APIs require the
031097d9e079e4 Jakub Kicinski  2019-11-27  36  	 *    chaining;
031097d9e079e4 Jakub Kicinski  2019-11-27  37  	 * 2) to chain tailer SG entries after the message.
d3b18ad31f93d0 John Fastabend  2018-10-13  38  	 */
031097d9e079e4 Jakub Kicinski  2019-11-27  39  	struct scatterlist		data[MAX_MSG_FRAGS + 2];
604326b41a6fb9 Daniel Borkmann 2018-10-13  40  };
031097d9e079e4 Jakub Kicinski  2019-11-27 @41  static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
604326b41a6fb9 Daniel Borkmann 2018-10-13  42  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
