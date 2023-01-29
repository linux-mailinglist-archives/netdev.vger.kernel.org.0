Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD5268000B
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 16:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjA2PpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjA2PpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 10:45:21 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA28F30D7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 07:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675007118; x=1706543118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p2RdTQucMPsqY9ei0+xyGrvmPIuH/RoSUq8cglhTrrE=;
  b=bjVNkXANydtMw52r3XCNAS/76BdzDcEtFXIfsYIpJdifIFaEP7Hk6pkC
   5hGaAptQk3tka0Yd12JJlhWvzRw8Wix4fpFYF9Th4Tj+9B0UL2vHRy5EQ
   qgsAPVmqCxqfMbEZFYo/u/RgDxYAhyBnf2E7St63XwfvN9DsXN0nvAfvu
   oj7ba/6SJz/D3HItBKQY1ZlasrFUjthDwhhNjogedMuEkVo8WZWkRqXF4
   LDoQQ1H1FFhgqowfZDncIoUFdsyD/OMut3X3m1CF5Owk1a83vz9AyJ/6R
   LKpeoOC0FqaTuesuV46Qv4EGeIvJQo78o4sdlNv5R4wRNl3VYCbeeDDZh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="413625478"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="413625478"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 07:45:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="694295964"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="694295964"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2023 07:45:13 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pM9rk-0002u2-1k;
        Sun, 29 Jan 2023 15:45:12 +0000
Date:   Sun, 29 Jan 2023 23:44:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1] netlink: provide an ability to set default
 extack message
Message-ID: <202301292309.r5KzfyUp-lkp@intel.com>
References: <d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Leon-Romanovsky/netlink-provide-an-ability-to-set-default-extack-message/20230129-203242
patch link:    https://lore.kernel.org/r/d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon%40kernel.org
patch subject: [PATCH net-next v1] netlink: provide an ability to set default extack message
config: s390-randconfig-r021-20230129 (https://download.01.org/0day-ci/archive/20230129/202301292309.r5KzfyUp-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/f0b11fb09eb6708058858b0cf95d1fec34eba956
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Leon-Romanovsky/netlink-provide-an-ability-to-set-default-extack-message/20230129-203242
        git checkout f0b11fb09eb6708058858b0cf95d1fec34eba956
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash net/bridge/ net/dsa/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/bridge/br_switchdev.c:4:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/bridge/br_switchdev.c:4:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/bridge/br_switchdev.c:4:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> net/bridge/br_switchdev.c:107:3: error: called object type 'char[9]' is not a function or function pointer
                   NL_SET_ERR_MSG_WEAK_MOD(extack,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   net/bridge/br_switchdev.c:117:3: error: called object type 'char[9]' is not a function or function pointer
                   NL_SET_ERR_MSG_WEAK_MOD(extack,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   12 warnings and 2 errors generated.
--
   In file included from net/dsa/master.c:9:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/dsa/master.c:9:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/dsa/master.c:9:
   In file included from include/linux/ethtool.h:18:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> net/dsa/master.c:467:3: error: called object type 'char[11]' is not a function or function pointer
                   NL_SET_ERR_MSG_WEAK_MOD(extack, "CPU port failed to join LAG");
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   12 warnings and 1 error generated.
--
   In file included from net/dsa/slave.c:8:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/dsa/slave.c:8:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/dsa/slave.c:8:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:28:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> net/dsa/slave.c:2695:5: error: called object type 'char[11]' is not a function or function pointer
                                   NL_SET_ERR_MSG_WEAK_MOD(extack, "Offloading not supported");
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/netlink.h:140:32: note: expanded from macro 'NL_SET_ERR_MSG_WEAK_MOD'
                   NL_SET_ERR_MSG_MOD((extack), (msg));    \
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/netlink.h:128:47: note: expanded from macro 'NL_SET_ERR_MSG_MOD'
           NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   include/linux/netlink.h:99:30: note: expanded from macro 'NL_SET_ERR_MSG'
           static const char __msg[] = msg;                \
                                       ^~~
   12 warnings and 1 error generated.


vim +107 net/bridge/br_switchdev.c

    72	
    73	/* Flags that can be offloaded to hardware */
    74	#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB | \
    75					  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
    76					  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
    77	
    78	int br_switchdev_set_port_flag(struct net_bridge_port *p,
    79				       unsigned long flags,
    80				       unsigned long mask,
    81				       struct netlink_ext_ack *extack)
    82	{
    83		struct switchdev_attr attr = {
    84			.orig_dev = p->dev,
    85		};
    86		struct switchdev_notifier_port_attr_info info = {
    87			.attr = &attr,
    88		};
    89		int err;
    90	
    91		mask &= BR_PORT_FLAGS_HW_OFFLOAD;
    92		if (!mask)
    93			return 0;
    94	
    95		attr.id = SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS;
    96		attr.u.brport_flags.val = flags;
    97		attr.u.brport_flags.mask = mask;
    98	
    99		/* We run from atomic context here */
   100		err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
   101					       &info.info, extack);
   102		err = notifier_to_errno(err);
   103		if (err == -EOPNOTSUPP)
   104			return 0;
   105	
   106		if (err) {
 > 107			NL_SET_ERR_MSG_WEAK_MOD(extack,
   108						"bridge flag offload is not supported");
   109			return -EOPNOTSUPP;
   110		}
   111	
   112		attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
   113		attr.flags = SWITCHDEV_F_DEFER;
   114	
   115		err = switchdev_port_attr_set(p->dev, &attr, extack);
   116		if (err) {
   117			NL_SET_ERR_MSG_WEAK_MOD(extack,
   118						"error setting offload flag on port");
   119			return err;
   120		}
   121	
   122		return 0;
   123	}
   124	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
