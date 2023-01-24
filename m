Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E8367911C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjAXGiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjAXGit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:38:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685B4C31;
        Mon, 23 Jan 2023 22:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674542328; x=1706078328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nCllPZY6zrzrfh4fFvccqk4bgDomrRfcoK4PfShWMzQ=;
  b=KwR+bIrJ8od/KfJySIUfd5lRGtkmRTNAajbNqPvP6sZ+BcsEgtBxkeA9
   YjRHpiePxk+J/uFLLqwsAuYhB6RCJNYmEU39t+Z0KQE8LY7BLNfiNiqbC
   Y/ZriBtPEGRrIRGjHC6XRdOJERIRdHvCNTQWME1QT/uVs87MM65Z9QWbU
   9H/kD8tWryevzM17tE28vOzRssZ1Huno3Djx/YHFHF9ktB9JiOFV5qySg
   6pYLCOpCuVj3du0kFN7xXPMBiAmhn7/V4P8tKahxwHOVZn20SOzrceDIw
   cb/sCo37xD91h/AHPogJw/1QRfpgBexZBv/t3MCvHYxgiJ/Wv2hQVFqeB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="388584537"
X-IronPort-AV: E=Sophos;i="5.97,241,1669104000"; 
   d="scan'208";a="388584537"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 22:38:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="639475752"
X-IronPort-AV: E=Sophos;i="5.97,241,1669104000"; 
   d="scan'208";a="639475752"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 23 Jan 2023 22:38:43 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKCx8-0006D6-1U;
        Tue, 24 Jan 2023 06:38:42 +0000
Date:   Tue, 24 Jan 2023 14:38:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <202301241423.sEVD92vC-lkp@intel.com>
References: <20230118122817.42466-4-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118122817.42466-4-francesco@dolcini.it>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on robh/for-next]
[also build test WARNING on bluetooth-next/master bluetooth/master horms-ipvs/master net/master net-next/master linus/master v6.2-rc5 next-20230123]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20230118122817.42466-4-francesco%40dolcini.it
patch subject: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
config: hexagon-randconfig-r021-20230123 (https://download.01.org/0day-ci/archive/20230124/202301241423.sEVD92vC-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2ae116c8ad209e0bf11559519915e511c44c28be
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
        git checkout 2ae116c8ad209e0bf11559519915e511c44c28be
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/bluetooth/ lib/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/bluetooth/hci_mrvl.c:12:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from drivers/bluetooth/hci_mrvl.c:12:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from drivers/bluetooth/hci_mrvl.c:12:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
>> drivers/bluetooth/hci_mrvl.c:450:36: warning: unused variable 'mrvl_proto_8997' [-Wunused-const-variable]
   static const struct hci_uart_proto mrvl_proto_8997 = {
                                      ^
   7 warnings generated.


vim +/mrvl_proto_8997 +450 drivers/bluetooth/hci_mrvl.c

   449	
 > 450	static const struct hci_uart_proto mrvl_proto_8997 = {
   451		.id		= HCI_UART_MRVL,
   452		.name		= "Marvell 8997",
   453		.init_speed	= 115200,
   454		.oper_speed	= 3000000,
   455		.open		= mrvl_open,
   456		.close		= mrvl_close,
   457		.flush		= mrvl_flush,
   458		.set_baudrate   = mrvl_set_baudrate,
   459		.recv		= mrvl_recv,
   460		.enqueue	= mrvl_enqueue,
   461		.dequeue	= mrvl_dequeue,
   462	};
   463	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
