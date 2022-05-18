Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CB452AFBE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiERBPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiERBPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:15:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A6D54187;
        Tue, 17 May 2022 18:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652836514; x=1684372514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6tM7gH4JRFS/rWl6JwkUGKCjUG1QwGkrdJ6CLSIx99k=;
  b=BW5DDf8NhRFcwwpKiqW9KZolGfJwVscOubYrTOKqqHebUf91oDAXlarP
   k/aN2ccibWeqLp5xycukAmpICJ/jwTPjFvlpCpn6qwsMniJcRU/JEeKty
   MsmFB9hJw5xYSfbhiW+0ArudxZNQAVqL9+gK9QisOYmoQIvkvM+OVRxmx
   A/9GaW+W9Qasylu3nkPgUK1yH0xijTCFJTfBfP0pSa0pwr71/THrnCWpH
   tGiSONpmu/w8dJeAa0mwkcNADEUfEA/PLN0AJJWMBqKgxHwt/FW4SGuy2
   hyq8XsEHR2i2iykVT8qkfxlqHyz3V2RFT+eHrrvLkE6mUrUF5l2/KqfKq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="258979715"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="258979715"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 18:15:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="597448146"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 17 May 2022 18:15:10 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nr8HN-0001d7-Md;
        Wed, 18 May 2022 01:15:09 +0000
Date:   Wed, 18 May 2022 09:14:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     longli@linuxonhyperv.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <202205180903.446J0L2Y-lkp@intel.com>
References: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc7 next-20220517]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 42226c989789d8da4af1de0c31070c96726d990c
config: x86_64-randconfig-a002-20220516 (https://download.01.org/0day-ci/archive/20220518/202205180903.446J0L2Y-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 853fa8ee225edf2d0de94b0dcbd31bea916e825e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f082dc68ab65c498c978d574e62413d50286b4f9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review longli-linuxonhyperv-com/Introduce-Microsoft-Azure-Network-Adapter-MANA-RDMA-driver/20220517-170632
        git checkout f082dc68ab65c498c978d574e62413d50286b4f9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <built-in>:1:
>> ./usr/include/rdma/mana-abi.h:12:10: fatal error: 'linux/mana/mana.h' file not found
   #include <linux/mana/mana.h>
            ^~~~~~~~~~~~~~~~~~~
   1 error generated.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
