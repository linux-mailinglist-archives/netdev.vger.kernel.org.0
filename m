Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C88C69E5D0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbjBURVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjBURVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:21:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4164298DE;
        Tue, 21 Feb 2023 09:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677000093; x=1708536093;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cTKYMdw4X1Kqcxxevc6EKHs2f4mp07bWEgQQBjJ26Kg=;
  b=iazZvWz2xbCJWPX+4LPstsgJbmCX0naIHRScew5wjqFdMGCdsa9/z1ZF
   Fhc21MkkAUX/YruQzr3ZI4zib2UfvsaSsTj2D8wNnyg2v9NUJcNfYFV3h
   G6bnJz+im8BX4SbSLms2DjrFFojQfoAZ7J7ix3+PaAj0ftuPHemu1hFeR
   D7nAQ2FWoLM0HSsRvjuY2Zb33wPsQD3f3BYnhQQmzLx61338CMcQDOY43
   ANOQSZCxI8y5brhwcSMQLaWAThcOf6tkPohtGQSKfb5W+XzqJo/yUmdB+
   2FqNewGE2U5EM5LB0Zh+CyjELzpS9vMCwRIpfseE30Ok5D5qSoJFW49mj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="313067651"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="313067651"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 09:21:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="740475638"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="740475638"
Received: from lkp-server01.sh.intel.com (HELO eac18b5d7d93) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 21 Feb 2023 09:21:30 -0800
Received: from kbuild by eac18b5d7d93 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUWKX-00004X-29;
        Tue, 21 Feb 2023 17:21:29 +0000
Date:   Wed, 22 Feb 2023 01:20:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hangyu Hua <hbh25y@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ian.mcdonald@jandi.co.nz
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: Re: [PATCH] net: dccp: delete redundant ackvec record in
 dccp_insert_options()
Message-ID: <202302220153.QeW2n6o4-lkp@intel.com>
References: <20230221092206.39741-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221092206.39741-1-hbh25y@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangyu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v6.2 next-20230221]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hangyu-Hua/net-dccp-delete-redundant-ackvec-record-in-dccp_insert_options/20230221-172448
patch link:    https://lore.kernel.org/r/20230221092206.39741-1-hbh25y%40gmail.com
patch subject: [PATCH] net: dccp: delete redundant ackvec record in dccp_insert_options()
config: s390-randconfig-r011-20230220 (https://download.01.org/0day-ci/archive/20230222/202302220153.QeW2n6o4-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db89896bbbd2251fff457699635acbbedeead27f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/ea44b55ba82bbe3f35b51212bf839f507a30b70b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hangyu-Hua/net-dccp-delete-redundant-ackvec-record-in-dccp_insert_options/20230221-172448
        git checkout ea44b55ba82bbe3f35b51212bf839f507a30b70b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash net/dccp/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302220153.QeW2n6o4-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/dccp/options.c:10:
   In file included from include/linux/dccp.h:13:
   In file included from include/net/inet_connection_sock.h:21:
   In file included from include/net/inet_sock.h:19:
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
   In file included from net/dccp/options.c:10:
   In file included from include/linux/dccp.h:13:
   In file included from include/net/inet_connection_sock.h:21:
   In file included from include/net/inet_sock.h:19:
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
   In file included from net/dccp/options.c:10:
   In file included from include/linux/dccp.h:13:
   In file included from include/net/inet_connection_sock.h:21:
   In file included from include/net/inet_sock.h:19:
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
>> net/dccp/options.c:594:8: error: call to undeclared function 'dccp_ackvec_lookup'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
                 ^
>> net/dccp/options.c:594:6: error: incompatible integer to pointer conversion assigning to 'struct dccp_ackvec_record *' from 'int' [-Wint-conversion]
           avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/dccp/options.c:596:18: error: use of undeclared identifier 'dccp_ackvec_record_slab'; did you mean 'dccp_ackvec_clear_state'?
           kmem_cache_free(dccp_ackvec_record_slab, avr);
                           ^~~~~~~~~~~~~~~~~~~~~~~
                           dccp_ackvec_clear_state
   net/dccp/ackvec.h:110:6: note: 'dccp_ackvec_clear_state' declared here
   void dccp_ackvec_clear_state(struct dccp_ackvec *av, const u64 ackno);
        ^
   12 warnings and 3 errors generated.


vim +/dccp_ackvec_lookup +594 net/dccp/options.c

   548	
   549	int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
   550	{
   551		struct dccp_sock *dp = dccp_sk(sk);
   552		struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
   553		struct dccp_ackvec_record *avr;
   554	
   555		DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
   556	
   557		if (dp->dccps_send_ndp_count && dccp_insert_option_ndp(sk, skb))
   558			return -1;
   559	
   560		if (DCCP_SKB_CB(skb)->dccpd_type != DCCP_PKT_DATA) {
   561	
   562			/* Feature Negotiation */
   563			if (dccp_feat_insert_opts(dp, NULL, skb))
   564				return -1;
   565	
   566			if (DCCP_SKB_CB(skb)->dccpd_type == DCCP_PKT_REQUEST) {
   567				/*
   568				 * Obtain RTT sample from Request/Response exchange.
   569				 * This is currently used for TFRC initialisation.
   570				 */
   571				if (dccp_insert_option_timestamp(skb))
   572					return -1;
   573	
   574			} else if (dccp_ackvec_pending(sk) &&
   575				   dccp_insert_option_ackvec(sk, skb)) {
   576					return -1;
   577			}
   578		}
   579	
   580		if (dp->dccps_hc_rx_insert_options) {
   581			if (ccid_hc_rx_insert_options(dp->dccps_hc_rx_ccid, sk, skb))
   582				goto delete_ackvec;
   583			dp->dccps_hc_rx_insert_options = 0;
   584		}
   585	
   586		if (dp->dccps_timestamp_echo != 0 &&
   587		    dccp_insert_option_timestamp_echo(dp, NULL, skb))
   588			goto delete_ackvec;
   589	
   590		dccp_insert_option_padding(skb);
   591		return 0;
   592	
   593	delete_ackvec:
 > 594		avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
   595		list_del(&avr->avr_node);
 > 596		kmem_cache_free(dccp_ackvec_record_slab, avr);
   597		return -1;
   598	}
   599	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
