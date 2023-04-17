Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8107A6E4E0B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDQQLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:11:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E944BC
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681747903; x=1713283903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c477qUAHCeHL3YyqtCIxRQFjPbDhJ2GjH1aURAxuoVQ=;
  b=asKa8UwdpgkofSW3//eY/bJi+/sDGi2dnEDToE6CHHYi4VTSjEKyN4F+
   puwd6txICjfguKBr6avxGal7p2Iqms11kVIBWm7FMuFcujE6uVKvI+T8d
   IVHIjedpAramsiGMd2OHLYR51/6qzDxY7LavbTTOfpl7CN+Qegv3gkxbW
   vWWGacYS07kb+heiXd5insj2F3FC0fT2hB7pv9i9bQRklI4g7CYrAVe+O
   oNIDFsukHPMxrFmkr/+xs38tfe7aD13ebFLqTA2Su7zQoABsQMbGWRKs6
   FKr62aj7u8Uc2ZXZN9fFh6DaLb9FYiRNhcNeKAV1Q+T2k+YkWVhruCvj0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="372809944"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="372809944"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 09:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="690720995"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="690720995"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 17 Apr 2023 09:09:59 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1poRQV-000cZb-0F;
        Mon, 17 Apr 2023 16:09:59 +0000
Date:   Tue, 18 Apr 2023 00:09:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        jiawenwu@trustnetic.com, mengyuanlou <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
Message-ID: <202304172313.16rBAkpz-lkp@intel.com>
References: <20230417105457.82127-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417105457.82127-2-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mengyuan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Mengyuan-Lou/net-wangxun-libwx-add-tx-offload-functions/20230417-194455
patch link:    https://lore.kernel.org/r/20230417105457.82127-2-mengyuanlou%40net-swift.com
patch subject: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload functions
config: riscv-randconfig-r042-20230417 (https://download.01.org/0day-ci/archive/20230417/202304172313.16rBAkpz-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 9638da200e00bd069e6dd63604e14cbafede9324)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/961fa7b9dfbcadb10aa6d908cb80a285473becc0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mengyuan-Lou/net-wangxun-libwx-add-tx-offload-functions/20230417-194455
        git checkout 961fa7b9dfbcadb10aa6d908cb80a285473becc0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/wangxun/libwx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304172313.16rBAkpz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:1172:3: warning: variable 'tunhdr_eiplen_tunlen' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
                   default:
                   ^~~~~~~
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:1189:43: note: uninitialized use occurs here
           wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
                                                    ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:1138:6: warning: variable 'tunhdr_eiplen_tunlen' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (enc) {
               ^~~
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:1189:43: note: uninitialized use occurs here
           wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
                                                    ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:1138:2: note: remove the 'if' if its condition is always true
           if (enc) {
           ^~~~~~~~~
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:1080:33: note: initialize the variable 'tunhdr_eiplen_tunlen' to silence this warning
           u32 l4len, tunhdr_eiplen_tunlen;
                                          ^
                                           = 0
   2 warnings generated.


vim +/tunhdr_eiplen_tunlen +1172 drivers/net/ethernet/wangxun/libwx/wx_lib.c

  1073	
  1074	static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
  1075			  u8 *hdr_len, u8 ptype)
  1076	{
  1077		u32 vlan_macip_lens, type_tucmd, mss_l4len_idx;
  1078		struct net_device *netdev = tx_ring->netdev;
  1079		struct sk_buff *skb = first->skb;
  1080		u32 l4len, tunhdr_eiplen_tunlen;
  1081		bool enc = skb->encapsulation;
  1082		struct ipv6hdr *ipv6h;
  1083		struct tcphdr *tcph;
  1084		struct iphdr *iph;
  1085		u8 tun_prot = 0;
  1086		int err;
  1087	
  1088		if (skb->ip_summed != CHECKSUM_PARTIAL)
  1089			return 0;
  1090	
  1091		if (!skb_is_gso(skb))
  1092			return 0;
  1093	
  1094		err = skb_cow_head(skb, 0);
  1095		if (err < 0)
  1096			return err;
  1097	
  1098		/* indicates the inner headers in the skbuff are valid. */
  1099		iph = enc ? inner_ip_hdr(skb) : ip_hdr(skb);
  1100		if (iph->version == 4) {
  1101			tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
  1102			iph->tot_len = 0;
  1103			iph->check = 0;
  1104			tcph->check = ~csum_tcpudp_magic(iph->saddr,
  1105							 iph->daddr, 0,
  1106							 IPPROTO_TCP, 0);
  1107			first->tx_flags |= WX_TX_FLAGS_TSO |
  1108					   WX_TX_FLAGS_CSUM |
  1109					   WX_TX_FLAGS_IPV4 |
  1110					   WX_TX_FLAGS_CC;
  1111		} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
  1112			ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
  1113			tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
  1114			ipv6h->payload_len = 0;
  1115			tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
  1116						       &ipv6h->daddr, 0,
  1117						       IPPROTO_TCP, 0);
  1118			first->tx_flags |= WX_TX_FLAGS_TSO |
  1119					   WX_TX_FLAGS_CSUM |
  1120					   WX_TX_FLAGS_CC;
  1121		}
  1122	
  1123		/* compute header lengths */
  1124		l4len = enc ? inner_tcp_hdrlen(skb) : tcp_hdrlen(skb);
  1125		*hdr_len = enc ? (skb_inner_transport_header(skb) - skb->data)
  1126			       : skb_transport_offset(skb);
  1127		*hdr_len += l4len;
  1128	
  1129		/* update gso size and bytecount with header size */
  1130		first->gso_segs = skb_shinfo(skb)->gso_segs;
  1131		first->bytecount += (first->gso_segs - 1) * *hdr_len;
  1132	
  1133		/* mss_l4len_id: use 0 as index for TSO */
  1134		mss_l4len_idx = l4len << WX_TXD_L4LEN_SHIFT;
  1135		mss_l4len_idx |= skb_shinfo(skb)->gso_size << WX_TXD_MSS_SHIFT;
  1136	
  1137		/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
> 1138		if (enc) {
  1139			switch (first->protocol) {
  1140			case htons(ETH_P_IP):
  1141				tun_prot = ip_hdr(skb)->protocol;
  1142				first->tx_flags |= WX_TX_FLAGS_OUTER_IPV4;
  1143				break;
  1144			case htons(ETH_P_IPV6):
  1145				tun_prot = ipv6_hdr(skb)->nexthdr;
  1146				break;
  1147			default:
  1148				break;
  1149			}
  1150			switch (tun_prot) {
  1151			case IPPROTO_UDP:
  1152				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_UDP;
  1153				tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
  1154							 WX_TXD_OUTER_IPLEN_SHIFT) |
  1155							(((skb_inner_mac_header(skb) -
  1156							skb_transport_header(skb)) >> 1) <<
  1157							WX_TXD_TUNNEL_LEN_SHIFT);
  1158				break;
  1159			case IPPROTO_GRE:
  1160				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_GRE;
  1161				tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
  1162							 WX_TXD_OUTER_IPLEN_SHIFT) |
  1163							(((skb_inner_mac_header(skb) -
  1164							skb_transport_header(skb)) >> 1) <<
  1165							WX_TXD_TUNNEL_LEN_SHIFT);
  1166				break;
  1167			case IPPROTO_IPIP:
  1168				tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
  1169							(char *)ip_hdr(skb)) >> 2) <<
  1170							WX_TXD_OUTER_IPLEN_SHIFT;
  1171				break;
> 1172			default:
  1173				break;
  1174			}
  1175			vlan_macip_lens = skb_inner_network_header_len(skb) >> 1;
  1176		} else {
  1177			vlan_macip_lens = skb_network_header_len(skb) >> 1;
  1178		}
  1179	
  1180		vlan_macip_lens |= skb_network_offset(skb) << WX_TXD_MACLEN_SHIFT;
  1181		vlan_macip_lens |= first->tx_flags & WX_TX_FLAGS_VLAN_MASK;
  1182	
  1183		type_tucmd = ptype << 24;
  1184		if (skb->vlan_proto == htons(ETH_P_8021AD) &&
  1185		    netdev->features & NETIF_F_HW_VLAN_STAG_TX)
  1186			type_tucmd |= WX_SET_FLAG(first->tx_flags,
  1187						  WX_TX_FLAGS_HW_VLAN,
  1188						  0x1 << WX_TXD_TAG_TPID_SEL_SHIFT);
  1189		wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
  1190			       type_tucmd, mss_l4len_idx);
  1191	
  1192		return 1;
  1193	}
  1194	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
