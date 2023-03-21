Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3938E6C2A73
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 07:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCUGdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 02:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCUGdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 02:33:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49720E3B6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 23:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679380400; x=1710916400;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BUXePkyHTHETXtAuHMxH7I69e4gnxoz4jfjC52U5cF0=;
  b=IiDzEk3n0V79luUoQ5JSYBJdIPjOy0lb9I5q0KCFkRHUq/6ulHx3RI5e
   G1ver8bYu+4OJ/wE7LyCCaA+lB9nXNfvbCifrcZQu6gK6B+aMJ4cvJBT8
   BoJMdClAB41NnP5BIIUUIFMnYOFnhpMM6Ax5YaxzvFfrf6CUOIt93pOaO
   29zxOTtHMg0x7YseC18gh62yPToq9DqsvqR62r3Fzgh5gMzt11Sd807ji
   BFJJK1qXo8av5+aHd6O2AtUPHzZtfZ8i5wk0sNgVxmHhf9OPcHwmcr9TG
   TQK3dBl03OXTvZMNTOwLUdl+TVqEr9Pwap4VcK6OjFU+AmmbeeS43dW4J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401433586"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="401433586"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 23:33:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="713861523"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="713861523"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 Mar 2023 23:33:17 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peVYa-000Bfu-1L;
        Tue, 21 Mar 2023 06:33:16 +0000
Date:   Tue, 21 Mar 2023 14:33:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <202303211426.xE59ciyg-lkp@intel.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
patch link:    https://lore.kernel.org/r/20230321033704.936685-1-eric.dumazet%40gmail.com
patch subject: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
config: i386-randconfig-a004-20230320 (https://download.01.org/0day-ci/archive/20230321/202303211426.xE59ciyg-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d0eaa3eabce1c80d067a739749e4253546417722
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-introduce-a-config-option-to-tweak-MAX_SKB_FRAGS/20230321-113826
        git checkout d0eaa3eabce1c80d067a739749e4253546417722
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/packet/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211426.xE59ciyg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/packet/af_packet.c:2626:11: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
                                  MAX_SKB_FRAGS);
                                  ^~~~~~~~~~~~~
   include/linux/printk.h:498:33: note: expanded from macro 'pr_err'
           printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                  ~~~     ^~~~~~~~~~~
   include/linux/printk.h:455:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:427:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   include/linux/skbuff.h:348:23: note: expanded from macro 'MAX_SKB_FRAGS'
   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                         ^~~~~~~~~~~~~~~~~~~~
   ./include/generated/autoconf.h:2539:30: note: expanded from macro 'CONFIG_MAX_SKB_FRAGS'
   #define CONFIG_MAX_SKB_FRAGS 17
                                ^~
   1 warning generated.


vim +2626 net/packet/af_packet.c

16cc1400456a4d Willem de Bruijn      2016-02-03  2565  
69e3c75f4d541a Johann Baudy          2009-05-18  2566  static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
8d39b4a6b83c14 Willem de Bruijn      2016-02-03  2567  		void *frame, struct net_device *dev, void *data, int tp_len,
c14ac9451c3483 Soheil Hassas Yeganeh 2016-04-02  2568  		__be16 proto, unsigned char *addr, int hlen, int copylen,
c14ac9451c3483 Soheil Hassas Yeganeh 2016-04-02  2569  		const struct sockcm_cookie *sockc)
69e3c75f4d541a Johann Baudy          2009-05-18  2570  {
184f489e9b8c40 Daniel Borkmann       2013-04-16  2571  	union tpacket_uhdr ph;
8d39b4a6b83c14 Willem de Bruijn      2016-02-03  2572  	int to_write, offset, len, nr_frags, len_max;
69e3c75f4d541a Johann Baudy          2009-05-18  2573  	struct socket *sock = po->sk.sk_socket;
69e3c75f4d541a Johann Baudy          2009-05-18  2574  	struct page *page;
69e3c75f4d541a Johann Baudy          2009-05-18  2575  	int err;
69e3c75f4d541a Johann Baudy          2009-05-18  2576  
69e3c75f4d541a Johann Baudy          2009-05-18  2577  	ph.raw = frame;
69e3c75f4d541a Johann Baudy          2009-05-18  2578  
69e3c75f4d541a Johann Baudy          2009-05-18  2579  	skb->protocol = proto;
69e3c75f4d541a Johann Baudy          2009-05-18  2580  	skb->dev = dev;
69e3c75f4d541a Johann Baudy          2009-05-18  2581  	skb->priority = po->sk.sk_priority;
2d37a186cedc51 Eric Dumazet          2009-10-01  2582  	skb->mark = po->sk.sk_mark;
3d0ba8c03ca9c4 Richard Cochran       2018-07-03  2583  	skb->tstamp = sockc->transmit_time;
8f932f762e7928 Willem de Bruijn      2018-12-17  2584  	skb_setup_tx_timestamp(skb, sockc->tsflags);
5cd8d46ea1562b Willem de Bruijn      2018-11-20  2585  	skb_zcopy_set_nouarg(skb, ph.raw);
69e3c75f4d541a Johann Baudy          2009-05-18  2586  
ae641949df01b8 Herbert Xu            2011-11-18  2587  	skb_reserve(skb, hlen);
69e3c75f4d541a Johann Baudy          2009-05-18  2588  	skb_reset_network_header(skb);
c1aad275b0293d Jason Wang            2013-03-25  2589  
69e3c75f4d541a Johann Baudy          2009-05-18  2590  	to_write = tp_len;
69e3c75f4d541a Johann Baudy          2009-05-18  2591  
69e3c75f4d541a Johann Baudy          2009-05-18  2592  	if (sock->type == SOCK_DGRAM) {
69e3c75f4d541a Johann Baudy          2009-05-18  2593  		err = dev_hard_header(skb, dev, ntohs(proto), addr,
69e3c75f4d541a Johann Baudy          2009-05-18  2594  				NULL, tp_len);
69e3c75f4d541a Johann Baudy          2009-05-18  2595  		if (unlikely(err < 0))
69e3c75f4d541a Johann Baudy          2009-05-18  2596  			return -EINVAL;
1d036d25e5609b Willem de Bruijn      2016-02-03  2597  	} else if (copylen) {
9ed988cd591500 Willem de Bruijn      2016-03-09  2598  		int hdrlen = min_t(int, copylen, tp_len);
9ed988cd591500 Willem de Bruijn      2016-03-09  2599  
69e3c75f4d541a Johann Baudy          2009-05-18  2600  		skb_push(skb, dev->hard_header_len);
1d036d25e5609b Willem de Bruijn      2016-02-03  2601  		skb_put(skb, copylen - dev->hard_header_len);
9ed988cd591500 Willem de Bruijn      2016-03-09  2602  		err = skb_store_bits(skb, 0, data, hdrlen);
69e3c75f4d541a Johann Baudy          2009-05-18  2603  		if (unlikely(err))
69e3c75f4d541a Johann Baudy          2009-05-18  2604  			return err;
9ed988cd591500 Willem de Bruijn      2016-03-09  2605  		if (!dev_validate_header(dev, skb->data, hdrlen))
9ed988cd591500 Willem de Bruijn      2016-03-09  2606  			return -EINVAL;
69e3c75f4d541a Johann Baudy          2009-05-18  2607  
9ed988cd591500 Willem de Bruijn      2016-03-09  2608  		data += hdrlen;
9ed988cd591500 Willem de Bruijn      2016-03-09  2609  		to_write -= hdrlen;
69e3c75f4d541a Johann Baudy          2009-05-18  2610  	}
69e3c75f4d541a Johann Baudy          2009-05-18  2611  
69e3c75f4d541a Johann Baudy          2009-05-18  2612  	offset = offset_in_page(data);
69e3c75f4d541a Johann Baudy          2009-05-18  2613  	len_max = PAGE_SIZE - offset;
69e3c75f4d541a Johann Baudy          2009-05-18  2614  	len = ((to_write > len_max) ? len_max : to_write);
69e3c75f4d541a Johann Baudy          2009-05-18  2615  
69e3c75f4d541a Johann Baudy          2009-05-18  2616  	skb->data_len = to_write;
69e3c75f4d541a Johann Baudy          2009-05-18  2617  	skb->len += to_write;
69e3c75f4d541a Johann Baudy          2009-05-18  2618  	skb->truesize += to_write;
14afee4b6092fd Reshetova, Elena      2017-06-30  2619  	refcount_add(to_write, &po->sk.sk_wmem_alloc);
69e3c75f4d541a Johann Baudy          2009-05-18  2620  
69e3c75f4d541a Johann Baudy          2009-05-18  2621  	while (likely(to_write)) {
69e3c75f4d541a Johann Baudy          2009-05-18  2622  		nr_frags = skb_shinfo(skb)->nr_frags;
69e3c75f4d541a Johann Baudy          2009-05-18  2623  
69e3c75f4d541a Johann Baudy          2009-05-18  2624  		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
40d4e3dfc2f56a Eric Dumazet          2009-07-21  2625  			pr_err("Packet exceed the number of skb frags(%lu)\n",
69e3c75f4d541a Johann Baudy          2009-05-18 @2626  			       MAX_SKB_FRAGS);
69e3c75f4d541a Johann Baudy          2009-05-18  2627  			return -EFAULT;
69e3c75f4d541a Johann Baudy          2009-05-18  2628  		}
69e3c75f4d541a Johann Baudy          2009-05-18  2629  
0af55bb58f8fa7 Changli Gao           2010-12-01  2630  		page = pgv_to_page(data);
0af55bb58f8fa7 Changli Gao           2010-12-01  2631  		data += len;
69e3c75f4d541a Johann Baudy          2009-05-18  2632  		flush_dcache_page(page);
69e3c75f4d541a Johann Baudy          2009-05-18  2633  		get_page(page);
0af55bb58f8fa7 Changli Gao           2010-12-01  2634  		skb_fill_page_desc(skb, nr_frags, page, offset, len);
69e3c75f4d541a Johann Baudy          2009-05-18  2635  		to_write -= len;
69e3c75f4d541a Johann Baudy          2009-05-18  2636  		offset = 0;
69e3c75f4d541a Johann Baudy          2009-05-18  2637  		len_max = PAGE_SIZE;
69e3c75f4d541a Johann Baudy          2009-05-18  2638  		len = ((to_write > len_max) ? len_max : to_write);
69e3c75f4d541a Johann Baudy          2009-05-18  2639  	}
69e3c75f4d541a Johann Baudy          2009-05-18  2640  
75c65772c3d184 Maxim Mikityanskiy    2019-02-21  2641  	packet_parse_headers(skb, sock);
efdfa2f7848f64 Daniel Borkmann       2015-11-11  2642  
69e3c75f4d541a Johann Baudy          2009-05-18  2643  	return tp_len;
69e3c75f4d541a Johann Baudy          2009-05-18  2644  }
69e3c75f4d541a Johann Baudy          2009-05-18  2645  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
