Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100D052E4DB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbiETGNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbiETGNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:13:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D714C75F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653027201; x=1684563201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LIUNboT17lR5CW5ZnVnjFPjF/nqQXlv0eH78sLfL0aQ=;
  b=fhxmdxxHMTxN2QCHCvuys5oKcITVhvJ146xlC0CFy83u4IA/Kz72GuLq
   JoKWkfZ7Be2wHx05B/Zd3tXdGh1nkftGCFqo/GeZfGNA7uAT2TUWMoszp
   g1i/1kWcnXFkPdMa9iRI6IjSoWErWutm9UMqyBoaY+CDXeoO5jYqqcgiW
   Pw6AtYFA8wHmey15GQFHnaBTY8XG6AfaNlUxcJqjsPvbfj/bhdvcXBnUW
   tQw3i8ZoT4hD6ZWI8GyCmkv6GyFVSoOIWluByQAJCdX3DS9aZLKBrr+9f
   QLCuJuZajXxcdDC3QVPa7HGaHBTPzn8Rgb7kujuQt3gQ/xeBnb6pNobap
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272476016"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272476016"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 23:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="662109027"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 19 May 2022 23:13:17 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrvsy-0004Lr-TJ;
        Fri, 20 May 2022 06:13:16 +0000
Date:   Fri, 20 May 2022 14:11:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vladimir.oltean@nxp.com, po.liu@nxp.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 10/11] igc: Check incompatible configs for
 Frame Preemption
Message-ID: <202205201422.84XYwlpY-lkp@intel.com>
References: <20220520011538.1098888-11-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520011538.1098888-11-vinicius.gomes@intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vinicius-Costa-Gomes/ethtool-Add-support-for-frame-preemption/20220520-092800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git df98714e432abf5cbdac3e4c1a13f94c65ddb8d3
config: s390-buildonly-randconfig-r002-20220519 (https://download.01.org/0day-ci/archive/20220520/202205201422.84XYwlpY-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project e00cbbec06c08dc616a0d52a20f678b8fbd4e304)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/a42e940bc53c40ee4e33a1bbf022a663bb28a9c7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vinicius-Costa-Gomes/ethtool-Add-support-for-frame-preemption/20220520-092800
        git checkout a42e940bc53c40ee4e33a1bbf022a663bb28a9c7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/ethernet/intel/igc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/ethernet/intel/igc/igc_main.c:6:
   In file included from include/linux/if_vlan.h:10:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/net/ethernet/intel/igc/igc_main.c:6:
   In file included from include/linux/if_vlan.h:10:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/net/ethernet/intel/igc/igc_main.c:6:
   In file included from include/linux/if_vlan.h:10:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:40:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/net/ethernet/intel/igc/igc_main.c:5919:6: warning: variable 'ring' is uninitialized when used here [-Wuninitialized]
           if (ring->preemptible) {
               ^~~~
   drivers/net/ethernet/intel/igc/igc_main.c:5914:23: note: initialize the variable 'ring' to silence this warning
           struct igc_ring *ring;
                                ^
                                 = NULL
   13 warnings generated.


vim +/ring +5919 drivers/net/ethernet/intel/igc/igc_main.c

  5910	
  5911	static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
  5912					      bool enable)
  5913	{
  5914		struct igc_ring *ring;
  5915	
  5916		if (queue < 0 || queue >= adapter->num_tx_queues)
  5917			return -EINVAL;
  5918	
> 5919		if (ring->preemptible) {
  5920			netdev_err(adapter->netdev, "Cannot enable LaunchTime on a preemptible queue\n");
  5921			return -EINVAL;
  5922		}
  5923	
  5924		ring = adapter->tx_ring[queue];
  5925		ring->launchtime_enable = enable;
  5926	
  5927		return 0;
  5928	}
  5929	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
