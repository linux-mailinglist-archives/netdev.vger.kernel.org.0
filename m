Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75EC6AA77E
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCDCFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCDCFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:05:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9463B60D7D
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677895540; x=1709431540;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tnpt6y7F9bG9yZCGTWrcKkVIoZwOTmZiR2QBkCKqg8M=;
  b=IXVB+7s4u7L3fnmXCzIkRl9bxNRtNVUPoaKnZ9k6PKpzMSOjftmyRM0J
   EknWAH9ffMJRg4FR0jUSaAQAZwRh0ySBjCqMcYSK7B5dv2WL3ggwefkQI
   rIfJlWM7y2x+VqThJrJZ0mcdXigCvAY/3oSSDt3qnBaB40TL2OIefDtSv
   tgG4+NtI0BXW4mvqhwfPeG8iH1peaoEKRnjKj6mJOQdZugAVDcbpR5B+0
   Izx34HeFa1rn7kzsbyO7XfL2mXHIFijn5OXTZ9no9si2RpN62a9qnnL/8
   pqnu8PD05XwKl2N8NQjZjIy1e3xUzI2wuOX2skpyFCrbgZdSMGmUvNNml
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="323510869"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="323510869"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 18:05:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="668855503"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="668855503"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2023 18:05:31 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYHH9-0001nI-0C;
        Sat, 04 Mar 2023 02:05:31 +0000
Date:   Sat, 4 Mar 2023 10:04:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: Re: [PATCH v1] netdevice: use ifmap isteand of plain fields
Message-ID: <202303040937.SrzjrYMQ-lkp@intel.com>
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v6.2 next-20230303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
patch link:    https://lore.kernel.org/r/20230303150818.132386-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v1] netdevice: use ifmap isteand of plain fields
config: hexagon-randconfig-r001-20230303 (https://download.01.org/0day-ci/archive/20230304/202303040937.SrzjrYMQ-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-isteand-of-plain-fields/20230303-231003
        git checkout 4efa870f9b2112fdebe7d1fffe30f5626b8d5229
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/hamradio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303040937.SrzjrYMQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/hamradio/baycom_ser_hdx.c:53:
   In file included from include/linux/interrupt.h:11:
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
   In file included from drivers/net/hamradio/baycom_ser_hdx.c:53:
   In file included from include/linux/interrupt.h:11:
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
   In file included from drivers/net/hamradio/baycom_ser_hdx.c:53:
   In file included from include/linux/interrupt.h:11:
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
>> drivers/net/hamradio/baycom_ser_hdx.c:158:22: error: no member named 'base_addr' in 'struct net_device'
           outb(0x81, LCR(dev->base_addr));        /* DLAB = 1 */
                          ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:83:22: note: expanded from macro 'LCR'
   #define LCR(iobase) (iobase+3)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:159:25: error: no member named 'base_addr' in 'struct net_device'
           outb(divisor, DLL(dev->base_addr));
                             ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:88:22: note: expanded from macro 'DLL'
   #define DLL(iobase) (iobase+0)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:160:19: error: no member named 'base_addr' in 'struct net_device'
           outb(0, DLM(dev->base_addr));
                       ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:89:22: note: expanded from macro 'DLM'
   #define DLM(iobase) (iobase+1)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:161:22: error: no member named 'base_addr' in 'struct net_device'
           outb(0x01, LCR(dev->base_addr));        /* word length = 6 */
                          ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:83:22: note: expanded from macro 'LCR'
   #define LCR(iobase) (iobase+3)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:167:22: error: no member named 'base_addr' in 'struct net_device'
           outb(0x00, THR(dev->base_addr));
                          ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:79:22: note: expanded from macro 'THR'
   #define THR(iobase) (iobase+0)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:193:51: error: no member named 'base_addr' in 'struct net_device'
           outb(0x0e | (!!bc->modem.ser12.tx_bit), MCR(dev->base_addr));
                                                       ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:84:22: note: expanded from macro 'MCR'
   #define MCR(iobase) (iobase+4)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:209:23: error: no member named 'base_addr' in 'struct net_device'
           cur_s = inb(MSR(dev->base_addr)) & 0x10;        /* the CTS line */
                           ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:86:22: note: expanded from macro 'MSR'
   #define MSR(iobase) (iobase+6)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:339:22: error: no member named 'base_addr' in 'struct net_device'
           outb(0x0d, MCR(dev->base_addr));                /* transmitter off */
                          ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:84:22: note: expanded from macro 'MCR'
   #define MCR(iobase) (iobase+4)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:346:46: error: no member named 'base_addr' in 'struct net_device'
                           hdlcdrv_setdcd(&bc->hdrv, !((inb(MSR(dev->base_addr)) ^ bc->opt_dcd) & 0x80));
                                                                ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:86:22: note: expanded from macro 'MSR'
   #define MSR(iobase) (iobase+6)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:371:26: error: no member named 'base_addr' in 'struct net_device'
           if ((iir = inb(IIR(dev->base_addr))) & 1)
                              ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:81:22: note: expanded from macro 'IIR'
   #define IIR(iobase) (iobase+2)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:377:17: error: no member named 'base_addr' in 'struct net_device'
                           inb(LSR(dev->base_addr));
                                   ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:85:22: note: expanded from macro 'LSR'
   #define LSR(iobase) (iobase+5)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:381:17: error: no member named 'base_addr' in 'struct net_device'
                           inb(RBR(dev->base_addr));
                                   ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:78:22: note: expanded from macro 'RBR'
   #define RBR(iobase) (iobase+0)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:394:24: error: no member named 'base_addr' in 'struct net_device'
                           outb(0x00, THR(dev->base_addr));
                                          ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:79:22: note: expanded from macro 'THR'
   #define THR(iobase) (iobase+0)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:398:17: error: no member named 'base_addr' in 'struct net_device'
                           inb(MSR(dev->base_addr));
                                   ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:86:22: note: expanded from macro 'MSR'
   #define MSR(iobase) (iobase+6)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:401:22: error: no member named 'base_addr' in 'struct net_device'
                   iir = inb(IIR(dev->base_addr));
                                 ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:81:22: note: expanded from macro 'IIR'
   #define IIR(iobase) (iobase+2)
                        ^~~~~~
   drivers/net/hamradio/baycom_ser_hdx.c:463:12: error: no member named 'base_addr' in 'struct net_device'
           if (!dev->base_addr || dev->base_addr > 0x1000-SER12_EXTENT ||
                ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:463:30: error: no member named 'base_addr' in 'struct net_device'
           if (!dev->base_addr || dev->base_addr > 0x1000-SER12_EXTENT ||
                                  ~~~  ^
   drivers/net/hamradio/baycom_ser_hdx.c:466:27: error: no member named 'base_addr' in 'struct net_device'
           if (!request_region(dev->base_addr, SER12_EXTENT, "baycom_ser12"))
                               ~~~  ^
   include/linux/ioport.h:268:75: note: expanded from macro 'request_region'
   #define request_region(start,n,name)            __request_region(&ioport_resource, (start), (n), (name), 0)
--
   In file included from drivers/net/hamradio/hdlcdrv.c:43:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
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
   In file included from drivers/net/hamradio/hdlcdrv.c:43:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
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
   In file included from drivers/net/hamradio/hdlcdrv.c:43:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
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
>> drivers/net/hamradio/hdlcdrv.c:528:28: error: no member named 'base_addr' in 'struct net_device'
                   bi.data.mp.iobase = dev->base_addr;
                                       ~~~  ^
   drivers/net/hamradio/hdlcdrv.c:540:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = bi.data.mp.iobase;
                   ~~~  ^
   drivers/net/hamradio/hdlcdrv.c:706:7: error: no member named 'base_addr' in 'struct net_device'
           dev->base_addr = baseaddr;
           ~~~  ^
   6 warnings and 3 errors generated.


vim +158 drivers/net/hamradio/baycom_ser_hdx.c

^1da177e4c3f41 Linus Torvalds 2005-04-16  149  
^1da177e4c3f41 Linus Torvalds 2005-04-16  150  /* --------------------------------------------------------------------- */
^1da177e4c3f41 Linus Torvalds 2005-04-16  151  /*
^1da177e4c3f41 Linus Torvalds 2005-04-16  152   * ===================== SER12 specific routines =========================
^1da177e4c3f41 Linus Torvalds 2005-04-16  153   */
^1da177e4c3f41 Linus Torvalds 2005-04-16  154  
^1da177e4c3f41 Linus Torvalds 2005-04-16  155  static inline void ser12_set_divisor(struct net_device *dev,
^1da177e4c3f41 Linus Torvalds 2005-04-16  156  				     unsigned char divisor)
^1da177e4c3f41 Linus Torvalds 2005-04-16  157  {
^1da177e4c3f41 Linus Torvalds 2005-04-16 @158  	outb(0x81, LCR(dev->base_addr));	/* DLAB = 1 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  159  	outb(divisor, DLL(dev->base_addr));
^1da177e4c3f41 Linus Torvalds 2005-04-16  160  	outb(0, DLM(dev->base_addr));
^1da177e4c3f41 Linus Torvalds 2005-04-16  161  	outb(0x01, LCR(dev->base_addr));	/* word length = 6 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  162  	/*
^1da177e4c3f41 Linus Torvalds 2005-04-16  163  	 * make sure the next interrupt is generated;
^1da177e4c3f41 Linus Torvalds 2005-04-16  164  	 * 0 must be used to power the modem; the modem draws its
^1da177e4c3f41 Linus Torvalds 2005-04-16  165  	 * power from the TxD line
^1da177e4c3f41 Linus Torvalds 2005-04-16  166  	 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  167  	outb(0x00, THR(dev->base_addr));
^1da177e4c3f41 Linus Torvalds 2005-04-16  168  	/*
^1da177e4c3f41 Linus Torvalds 2005-04-16  169  	 * it is important not to set the divider while transmitting;
^1da177e4c3f41 Linus Torvalds 2005-04-16  170  	 * this reportedly makes some UARTs generating interrupts
^1da177e4c3f41 Linus Torvalds 2005-04-16  171  	 * in the hundredthousands per second region
^1da177e4c3f41 Linus Torvalds 2005-04-16  172  	 * Reported by: Ignacio.Arenaza@studi.epfl.ch (Ignacio Arenaza Nuno)
^1da177e4c3f41 Linus Torvalds 2005-04-16  173  	 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  174  }
^1da177e4c3f41 Linus Torvalds 2005-04-16  175  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
