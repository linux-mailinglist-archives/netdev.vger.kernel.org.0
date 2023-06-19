Return-Path: <netdev+bounces-11971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A187358AA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 617031C20B06
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C9511196;
	Mon, 19 Jun 2023 13:33:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BC10799;
	Mon, 19 Jun 2023 13:33:36 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F556E59;
	Mon, 19 Jun 2023 06:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687181614; x=1718717614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xqr/3S2/EUn4m71NKoQyh8sBO7P+dlIVRJAQ29FZbC0=;
  b=CHMk6AhnIWk+Im9wJP6uxwPvsnS397PoajdUdOZD+uPXHZQSm3PSEm6N
   UUV4EM/5w8PBaOmDV3W97kKshcwAqMTgXsbeFGlqM7sGzTXdwXiWSkDuj
   7fXlhQ3e7MFC1QHH85P7olXR+v+mFWwyjDfN1/iVmT0EbNR5S7K94ffaj
   424DwUUqm8RneKoceHc/XVWpUMzbhPmy/Rq0Hj283PAd5GIHp5szHDWbI
   aRsiF5gT6+cjd7rvwhcdPaejps6j8VhR2Tsy5DRYUOxJePmW+Tnwal2Od
   c+tX9gA5DqvsK1Lwf0/QQAbt1RAsYJ+Cb/0LL4zxMlRjt892J3k9rrB3e
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="446005346"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="446005346"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 06:33:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="1043902171"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="1043902171"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2023 06:33:30 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qBF0b-0004jw-1i;
	Mon, 19 Jun 2023 13:33:29 +0000
Date: Mon, 19 Jun 2023 21:32:46 +0800
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
Subject: Re: [PATCH net-next 2/4] virtio-net: reprobe csum related fields for
 skb passed by XDP
Message-ID: <202306192151.YMz3NiKw-lkp@intel.com>
References: <20230619105738.117733-3-hengqi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619105738.117733-3-hengqi@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Heng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Heng-Qi/virtio-net-a-helper-for-probing-the-pseudo-header-checksum/20230619-190212
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230619105738.117733-3-hengqi%40linux.alibaba.com
patch subject: [PATCH net-next 2/4] virtio-net: reprobe csum related fields for skb passed by XDP
config: x86_64-randconfig-r014-20230619 (https://download.01.org/0day-ci/archive/20230619/202306192151.YMz3NiKw-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230619/202306192151.YMz3NiKw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306192151.YMz3NiKw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/virtio_net.c:1648:17: error: call to undeclared function 'csum_ipv6_magic'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                           uh->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
                                        ^
   drivers/net/virtio_net.c:1648:17: note: did you mean 'csum_tcpudp_magic'?
   include/asm-generic/checksum.h:52:1: note: 'csum_tcpudp_magic' declared here
   csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len,
   ^
   drivers/net/virtio_net.c:1657:17: error: call to undeclared function 'csum_ipv6_magic'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                           th->check = ~csum_ipv6_magic((const struct in6_addr *)&ip6h->saddr,
                                        ^
>> drivers/net/virtio_net.c:1695:19: warning: use of logical '&&' with constant operand [-Wconstant-logical-operand]
           } else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
                            ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1695:19: note: use '&' for a bitwise operation
           } else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
                            ^~
                            &
   drivers/net/virtio_net.c:1695:19: note: remove constant to silence this warning
           } else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
                           ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 2 errors generated.


vim +1695 drivers/net/virtio_net.c

  1667	
  1668	static int virtnet_set_csum_after_xdp(struct virtnet_info *vi,
  1669					      struct sk_buff *skb,
  1670					      __u8 flags)
  1671	{
  1672		int err;
  1673	
  1674		/* When XDP program is loaded, for example, the vm-vm scenario
  1675		 * on the same host, packets marked as VIRTIO_NET_HDR_F_NEEDS_CSUM
  1676		 * will travel. Although these packets are safe from the point of
  1677		 * view of the vm, to avoid modification by XDP and successful
  1678		 * forwarding in the upper layer, we re-probe the necessary checksum
  1679		 * related information: skb->csum_{start, offset}, pseudo-header csum.
  1680		 *
  1681		 * This benefits us:
  1682		 * 1. XDP can be loaded when there's _F_GUEST_CSUM.
  1683		 * 2. The device verifies the checksum of packets , especially
  1684		 *    benefiting for large packets.
  1685		 * 3. In the same-host vm-vm scenario, packets marked as
  1686		 *    VIRTIO_NET_HDR_F_NEEDS_CSUM are no longer dropped after being
  1687		 *    processed by XDP.
  1688		 */
  1689		if (flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
  1690			err = virtnet_flow_dissect_udp_tcp(vi, skb);
  1691			if (err < 0)
  1692				return -EINVAL;
  1693	
  1694			skb->ip_summed = CHECKSUM_PARTIAL;
> 1695		} else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
  1696			/* We want to benefit from this: XDP guarantees that packets marked
  1697			 * as VIRTIO_NET_HDR_F_DATA_VALID still have correct csum after they
  1698			 * are processed.
  1699			 */
  1700			skb->ip_summed = CHECKSUM_UNNECESSARY;
  1701		}
  1702	
  1703		return 0;
  1704	}
  1705	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

