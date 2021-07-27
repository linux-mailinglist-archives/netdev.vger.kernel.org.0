Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF33D7C19
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhG0R0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:26:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:58815 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0R0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 13:26:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10058"; a="199715962"
X-IronPort-AV: E=Sophos;i="5.84,274,1620716400"; 
   d="gz'50?scan'50,208,50";a="199715962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 10:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,274,1620716400"; 
   d="gz'50?scan'50,208,50";a="505980149"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jul 2021 10:25:53 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1m8Qq0-00075G-U3; Tue, 27 Jul 2021 17:25:52 +0000
Date:   Wed, 28 Jul 2021 01:25:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>
Cc:     clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: xfrm: fix shift-out-of-bounce
Message-ID: <202107280113.ykJy6Oc4-lkp@intel.com>
References: <20210727174318.53806d27@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20210727174318.53806d27@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pavel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on ipsec-next/master]
[also build test ERROR on next-20210726]
[cannot apply to ipsec/master net-next/master net/master sparc-next/master v5.14-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Pavel-Skripkin/net-xfrm-fix-shift-out-of-bounce/20210727-224549
base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
config: s390-randconfig-r034-20210727 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project c658b472f3e61e1818e1909bf02f3d65470018a5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/0d1cb044926e3d81c86b5add2eeaf38c7aec7f90
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pavel-Skripkin/net-xfrm-fix-shift-out-of-bounce/20210727-224549
        git checkout 0d1cb044926e3d81c86b5add2eeaf38c7aec7f90
        # save the attached .config to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross O=build_dir ARCH=s390 SHELL=/bin/bash net/xfrm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from net/xfrm/xfrm_user.c:22:
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
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from net/xfrm/xfrm_user.c:22:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from net/xfrm/xfrm_user.c:22:
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
>> net/xfrm/xfrm_user.c:1975:54: error: expected ';' after expression
           dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK
                                                               ^
                                                               ;
   12 warnings and 1 error generated.


vim +1975 net/xfrm/xfrm_user.c

  1963	
  1964	static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
  1965				    struct nlattr **attrs)
  1966	{
  1967		struct net *net = sock_net(skb->sk);
  1968		struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
  1969		u8 dirmask;
  1970		u8 old_default = net->xfrm.policy_default;
  1971	
  1972		if (up->dirmask >= sizeof(up->action) * 8)
  1973			return -EINVAL;
  1974	
> 1975		dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK
  1976	
  1977		net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
  1978					    | (up->action << up->dirmask);
  1979	
  1980		rt_genid_bump_all(net);
  1981	
  1982		return 0;
  1983	}
  1984	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--BXVAT5kNtrzKuDFl
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--BXVAT5kNtrzKuDFl--
