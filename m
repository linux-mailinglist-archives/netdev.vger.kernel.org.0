Return-Path: <netdev+bounces-11215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F4210731F84
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA37281408
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0992E0EF;
	Thu, 15 Jun 2023 17:54:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E26B2E0D8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:54:20 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF0D13E;
	Thu, 15 Jun 2023 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686851657; x=1718387657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M5HG/Z8xM0hGFLzU9ZTCMfj2JYrEGxYFNH365bchPSE=;
  b=fTwBKV/IePAWixMn9qiq9WTG/JMNurZD2M/yIXBn6CRtV+eznYiv9H/V
   t4g516226AwF/4MuwtORt2S/9WZ38YH1HII+tB8s+T7fI7AGPuGjTKJwO
   VKYxKwdFEEDzqjSlvvbH0ExVNLjB5p7a+00Ulc02Z2Tgbp5oLnzaAQwX8
   opzwnI6qglMqCyT9eYFlirLVNOi1mUnRd8biONl/4hmR0QZHARaq2SA7i
   aFuz/Femio1wGJEnhKsKXw/ruU5jNv6sp2UmRHlMT3FLZqZ9cWSaOgsjw
   +GBYcpPqzxcTRTp6WezM+F/S254qrnuqFXbrlFndB11HSFk+tHTKkEADs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424923062"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="424923062"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:54:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="886788157"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="886788157"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 15 Jun 2023 10:53:43 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9rAE-0000F0-1G;
	Thu, 15 Jun 2023 17:53:42 +0000
Date: Fri, 16 Jun 2023 01:52:51 +0800
From: kernel test robot <lkp@intel.com>
To: carlos.fernandez@technica-engineering.de, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] net: macsec SCI assignment for ES = 0
Message-ID: <202306160102.4iSEfuNY-lkp@intel.com>
References: <20230615111315.6072-1-carlos.fernandez@technica-engineering.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615111315.6072-1-carlos.fernandez@technica-engineering.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]
[also build test WARNING on net/main linus/master horms-ipvs/master v6.4-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/carlos-fernandez-technica-engineering-de/net-macsec-SCI-assignment-for-ES-0/20230615-192230
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230615111315.6072-1-carlos.fernandez%40technica-engineering.de
patch subject: [PATCH] net: macsec SCI assignment for ES = 0
config: s390-randconfig-r026-20230615 (https://download.01.org/0day-ci/archive/20230616/202306160102.4iSEfuNY-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch net-next main
        git checkout net-next/main
        b4 shazam https://lore.kernel.org/r/20230615111315.6072-1-carlos.fernandez@technica-engineering.de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306160102.4iSEfuNY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/net/macsec.c:9:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
         |                                                           ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
     102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
         |                                                      ^
   In file included from drivers/net/macsec.c:9:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
         |                                                           ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
     115 | #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
         |                                                      ^
   In file included from drivers/net/macsec.c:9:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     692 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     700 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     708 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     717 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     726 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     735 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> drivers/net/macsec.c:270:3: warning: variable 'sci' is used uninitialized whenever 'for' loop exits because its condition is false [-Wsometimes-uninitialized]
     270 |                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_entry_rcu'
     392 |                 &pos->member != (head);                                 \
         |                 ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/macsec.c:285:9: note: uninitialized use occurs here
     285 |         return sci;
         |                ^~~
   drivers/net/macsec.c:270:3: note: remove the condition if it is always true
     270 |                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
         |                 ^
   include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_entry_rcu'
     392 |                 &pos->member != (head);                                 \
         |                 ^
   drivers/net/macsec.c:263:11: note: initialize the variable 'sci' to silence this warning
     263 |         sci_t sci;
         |                  ^
         |                   = 0
   13 warnings generated.


vim +270 drivers/net/macsec.c

   258	
   259	static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
   260			struct macsec_rxh_data *rxd)
   261	{
   262		struct macsec_dev *macsec_device;
   263		sci_t sci;
   264		/* SC = 1*/
   265		if (sci_present)
   266			memcpy(&sci, hdr->secure_channel_id,
   267					sizeof(hdr->secure_channel_id));
   268		/* SC = 0; ES = 0*/
   269		else if (0 == (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) {
 > 270			list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
   271				struct macsec_rx_sc *rx_sc;
   272				struct macsec_secy *secy = &macsec_device->secy;
   273	
   274				for_each_rxsc(secy, rx_sc) {
   275					rx_sc = rx_sc ? macsec_rxsc_get(rx_sc) : NULL;
   276					if (rx_sc && rx_sc->active) {
   277						sci = rx_sc->sci;
   278						return sci;
   279					}
   280				}
   281			}
   282		} else {
   283			sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
   284		}
   285		return sci;
   286	}
   287	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

