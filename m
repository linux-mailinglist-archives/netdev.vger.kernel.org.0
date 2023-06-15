Return-Path: <netdev+bounces-10957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2EC730C8C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBCF21C20DFF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B95390;
	Thu, 15 Jun 2023 01:24:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22238F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:24:23 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7EA212D;
	Wed, 14 Jun 2023 18:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686792262; x=1718328262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TKMlT1y1/y5VedBm18Sg1VLQSNu3WZkBrgxFikyleQQ=;
  b=EY3nXxpuelSPTOtvtf/zcrZ91/GsN8NM5U8jsFJGv5h1gII2hw7jwlmu
   s/xTjlqYlv4pH8XKQT/3IpDzOtHYuS8QXjxBGk4NPVcB7HrduUK2N7dVS
   KUy6YcgsaX9nglqzxy3k75ZhpYFVhrG/tILQN4ZjCvaoA/6LOzkt54DWz
   ew3ulEzoQvoYJkKqyhaHbi4uZNETm4Xqd23kG8dgBkfUY3KLtJ912cHmL
   Mvc7TiQgOLIf5AKSXDjMgkPbD6cYVCbEcWyX+FI5e7WsoJ3gTn13IVYHz
   cLFlayXr3frLHAQDj/o26SgVyKsJkitYz4TZ/ilnlQvgTSE3BWlEG0bu0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="422385826"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="422385826"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 18:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="742052049"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="742052049"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 18:24:06 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9biX-0001G1-1L;
	Thu, 15 Jun 2023 01:24:05 +0000
Date: Thu, 15 Jun 2023 09:23:12 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>
Subject: Re: [PATCH v7 08/22] net/tcp: Add AO sign to RST packets
Message-ID: <202306150955.0sJRXmfG-lkp@intel.com>
References: <20230614230947.3954084-9-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614230947.3954084-9-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Dmitry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on b6dad5178ceaf23f369c3711062ce1f2afc33644]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Prepare-tcp_md5sig_pool-for-TCP-AO/20230615-071334
base:   b6dad5178ceaf23f369c3711062ce1f2afc33644
patch link:    https://lore.kernel.org/r/20230614230947.3954084-9-dima%40arista.com
patch subject: [PATCH v7 08/22] net/tcp: Add AO sign to RST packets
config: hexagon-randconfig-r025-20230612 (https://download.01.org/0day-ci/archive/20230615/202306150955.0sJRXmfG-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout b6dad5178ceaf23f369c3711062ce1f2afc33644
        b4 shazam https://lore.kernel.org/r/20230614230947.3954084-9-dima@arista.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv6/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306150955.0sJRXmfG-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/ipv6/tcp_ipv6.c:32:
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
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from net/ipv6/tcp_ipv6.c:32:
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
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from net/ipv6/tcp_ipv6.c:32:
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
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
>> net/ipv6/tcp_ipv6.c:1136:1: warning: unused label 'out' [-Wunused-label]
    1136 | out:
         | ^~~~
    1137 |         rcu_read_unlock();
   7 warnings generated.


vim +/out +1136 net/ipv6/tcp_ipv6.c

2045a93527d963 Dmitry Safonov           2023-06-15  1110  
c24b14c46bb88d Song Liu                 2017-10-23  1111  	if (sk) {
c24b14c46bb88d Song Liu                 2017-10-23  1112  		oif = sk->sk_bound_dev_if;
052e0690f1f62f Eric Dumazet             2019-07-10  1113  		if (sk_fullsock(sk)) {
052e0690f1f62f Eric Dumazet             2019-07-10  1114  			const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
052e0690f1f62f Eric Dumazet             2019-07-10  1115  
c24b14c46bb88d Song Liu                 2017-10-23  1116  			trace_tcp_send_reset(sk, skb);
052e0690f1f62f Eric Dumazet             2019-07-10  1117  			if (np->repflow)
052e0690f1f62f Eric Dumazet             2019-07-10  1118  				label = ip6_flowlabel(ipv6h);
e9a5dceee56cb5 Eric Dumazet             2019-09-24  1119  			priority = sk->sk_priority;
dc6456e938e938 Antoine Tenart           2023-04-27  1120  			txhash = sk->sk_txhash;
052e0690f1f62f Eric Dumazet             2019-07-10  1121  		}
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1122  		if (sk->sk_state == TCP_TIME_WAIT) {
50a8accf10627b Eric Dumazet             2019-06-05  1123  			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1124  			priority = inet_twsk(sk)->tw_priority;
9258b8b1be2e1e Eric Dumazet             2022-09-22  1125  			txhash = inet_twsk(sk)->tw_txhash;
f6c0f5d209fa80 Eric Dumazet             2019-09-24  1126  		}
323a53c41292a0 Eric Dumazet             2019-06-05  1127  	} else {
a346abe051bd2b Eric Dumazet             2019-07-01  1128  		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
323a53c41292a0 Eric Dumazet             2019-06-05  1129  			label = ip6_flowlabel(ipv6h);
c24b14c46bb88d Song Liu                 2017-10-23  1130  	}
c24b14c46bb88d Song Liu                 2017-10-23  1131  
e92dd77e6fe0a3 Wei Wang                 2020-09-08  1132  	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
2045a93527d963 Dmitry Safonov           2023-06-15  1133  			     ipv6_get_dsfield(ipv6h), label, priority, txhash,
2045a93527d963 Dmitry Safonov           2023-06-15  1134  			     ao_key, traffic_key, rcv_next, ao_sne);
658ddaaf6694ad Shawn Lu                 2012-01-31  1135  
3b24d854cb3538 Eric Dumazet             2016-04-01 @1136  out:
658ddaaf6694ad Shawn Lu                 2012-01-31  1137  	rcu_read_unlock();
ecc51b6d5ca04b Arnaldo Carvalho de Melo 2005-12-12  1138  }
^1da177e4c3f41 Linus Torvalds           2005-04-16  1139  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

