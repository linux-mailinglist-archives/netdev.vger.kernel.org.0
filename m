Return-Path: <netdev+bounces-11955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D51C7356E9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E5671C20ACF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7FA1376;
	Mon, 19 Jun 2023 12:31:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775E811182;
	Mon, 19 Jun 2023 12:31:34 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC29DC6;
	Mon, 19 Jun 2023 05:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687177892; x=1718713892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S5Tbof1M3nkG5q1M0ChkWrKFAeuGsOQlkoha0trItmY=;
  b=jxqXEJDf1fRsnWanX/3QN+e2fj4g9oaJn4wxfv6mcGn/fp11jDiRm4Yw
   4KqcbdI8oExWRUelbFVzFlytSmCuULlNGpC16FSBdzI9JpPGU38fIJRgo
   VSm/cWhkt6CwjHgYXYLtXk2IaHWkQWssKNbTCVkB9kD/RISM6aMwkW85r
   g7BlAt22T09sUMM0Su9DW1gXIXIj8MXfeftla/iNPXzGjA2yD3c67sPkC
   px/YyqH+X+jaTb75r2i7rQPfNxBloow9mFMM1K8C75Muvmv6xrqYVfgBM
   /Ws7YbKOcl3h8RoQHV0un05bRteS4h450I6fIoJ/buweMnWFPe6TOG4OW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="359622552"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="359622552"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 05:31:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="1043889029"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="1043889029"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2023 05:31:29 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qBE2a-0004hw-19;
	Mon, 19 Jun 2023 12:31:28 +0000
Date: Mon, 19 Jun 2023 20:30:45 +0800
From: kernel test robot <lkp@intel.com>
To: Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 1/4] virtio-net: a helper for probing the
 pseudo-header checksum
Message-ID: <202306192049.8y7DR5F1-lkp@intel.com>
References: <20230619105738.117733-2-hengqi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619105738.117733-2-hengqi@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Heng,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Heng-Qi/virtio-net-a-helper-for-probing-the-pseudo-header-checksum/20230619-190212
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230619105738.117733-2-hengqi%40linux.alibaba.com
patch subject: [PATCH net-next 1/4] virtio-net: a helper for probing the pseudo-header checksum
config: x86_64-randconfig-r014-20230619 (https://download.01.org/0day-ci/archive/20230619/202306192049.8y7DR5F1-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230619/202306192049.8y7DR5F1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306192049.8y7DR5F1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/virtio_net.c:1648:17: error: call to undeclared function 'csum_ipv6_magic'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                           uh->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
                                        ^
   drivers/net/virtio_net.c:1648:17: note: did you mean 'csum_tcpudp_magic'?
   include/asm-generic/checksum.h:52:1: note: 'csum_tcpudp_magic' declared here
   csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len,
   ^
   drivers/net/virtio_net.c:1657:17: error: call to undeclared function 'csum_ipv6_magic'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                           th->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
                                        ^
   2 errors generated.


vim +/csum_ipv6_magic +1648 drivers/net/virtio_net.c

  1572	
  1573	static int virtnet_flow_dissect_udp_tcp(struct virtnet_info *vi, struct sk_buff *skb)
  1574	{
  1575		struct net_device *dev = vi->dev;
  1576		struct flow_keys_basic keys;
  1577		struct udphdr *uh;
  1578		struct tcphdr *th;
  1579		int len, offset;
  1580	
  1581		/* The flow dissector needs this information. */
  1582		skb->dev = dev;
  1583		skb_reset_mac_header(skb);
  1584		skb->protocol = dev_parse_header_protocol(skb);
  1585		/* virtio-net does not need to resolve VLAN. */
  1586		skb_set_network_header(skb, ETH_HLEN);
  1587		if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
  1588						      NULL, 0, 0, 0, 0))
  1589			return -EINVAL;
  1590	
  1591		/* 1. Pseudo-header checksum calculation requires:
  1592		 *    (1) saddr/daddr (2) IP_PROTO (3) length of transport payload
  1593		 * 2. We don't parse SCTP because virtio-net currently doesn't
  1594		 *    support CRC offloading for SCTP.
  1595		 */
  1596		if (keys.basic.n_proto == htons(ETH_P_IP)) {
  1597			struct iphdr *iph;
  1598	
  1599			/* Flow dissector has verified that there is an IP header. */
  1600			iph = ip_hdr(skb);
  1601			if (iph->version != 4 || !pskb_may_pull(skb, iph->ihl * 4))
  1602				return -EINVAL;
  1603	
  1604			skb->transport_header = skb->mac_header + keys.control.thoff;
  1605			offset = skb_transport_offset(skb);
  1606			len = skb->len - offset;
  1607			if (keys.basic.ip_proto == IPPROTO_UDP) {
  1608				if (!pskb_may_pull(skb, offset + sizeof(struct udphdr)))
  1609					return -EINVAL;
  1610	
  1611				uh = udp_hdr(skb);
  1612				skb->csum_offset = offsetof(struct udphdr, check);
  1613				/* Although uh->len is already the 3rd parameter for the calculation
  1614				 * of the pseudo-header checksum, we have already calculated the
  1615				 * length of the transport layer, so use 'len' here directly.
  1616				 */
  1617				uh->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, len,
  1618						IPPROTO_UDP, 0);
  1619			} else if (keys.basic.ip_proto == IPPROTO_TCP) {
  1620				if (!pskb_may_pull(skb, offset + sizeof(struct tcphdr)))
  1621					return -EINVAL;
  1622	
  1623				th = tcp_hdr(skb);
  1624				skb->csum_offset = offsetof(struct tcphdr, check);
  1625				th->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, len,
  1626						IPPROTO_TCP, 0);
  1627			} /* virtio-net doesn't support checksums for SCTP hw offloading.*/
  1628		} else if (keys.basic.n_proto == htons(ETH_P_IPV6)) {
  1629			struct ipv6hdr *ip6h;
  1630	
  1631			ip6h = ipv6_hdr(skb);
  1632			if (ip6h->version != 6)
  1633				return -EINVAL;
  1634	
  1635			/* We have skipped the possible extension headers for IPv6.
  1636			 * If there is a Routing Header, the tx's check value is calculated by
  1637			 * final_dst, and that value is the rx's daddr.
  1638			 */
  1639			skb->transport_header = skb->mac_header + keys.control.thoff;
  1640			offset = skb_transport_offset(skb);
  1641			len = skb->len - offset;
  1642			if (keys.basic.ip_proto == IPPROTO_UDP) {
  1643				if (!pskb_may_pull(skb, offset + sizeof(struct udphdr)))
  1644					return -EINVAL;
  1645	
  1646				uh = udp_hdr(skb);
  1647				skb->csum_offset = offsetof(struct udphdr, check);
> 1648				uh->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
  1649						(const struct in6_addr *)&ip6h->daddr,
  1650						len, IPPROTO_UDP, 0);
  1651			} else if (keys.basic.ip_proto == IPPROTO_TCP) {
  1652				if (!pskb_may_pull(skb, offset + sizeof(struct tcphdr)))
  1653					return -EINVAL;
  1654	
  1655				th = tcp_hdr(skb);
  1656				skb->csum_offset = offsetof(struct tcphdr, check);
  1657				th->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
  1658						(const struct in6_addr *)&ip6h->daddr,
  1659						len, IPPROTO_TCP, 0);
  1660			}
  1661		}
  1662	
  1663		skb->csum_start = skb->transport_header;
  1664	
  1665		return 0;
  1666	}
  1667	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

