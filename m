Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1536A740E
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 20:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjCATJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 14:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCATJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 14:09:18 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FCC30FF;
        Wed,  1 Mar 2023 11:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677697757; x=1709233757;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bJzj9S3Ol5uf9Y3a+Q3tlxd3ZEIxI0dIWJCTPDgaX3w=;
  b=Y/heiCKV65lDNVIkVhaa8II1pI2RTg4y04E2Xf7h0YlvuRuLnIImINII
   MdJ+1Bq0sh3JVK5WL8JohUQkU/QDyXC9WVOJ4mi+7NfxAoMlazguU/Vq6
   msbC1CHVZPuc6sETipvPtf+hEkhZuuEZt6l0jdhOsHzIk4L7iLvNr3qOC
   hO9pTCrEj4Ln7+fVqSykEBZRt3oIr7Da312V0UPwBDJPcMCpAeLPUs5aX
   jDtyRdAbd2088mhQ1YgF27IDy0xQRs5DNjrQr68uwI/HlV0aTEZ40KsMD
   AuMN1JUuzN4aO4KzCY4BKgTXKlEMvk1ez7HZLGWwiK1C+MrhHPJ9Ay/Oi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="318298923"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="318298923"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 11:08:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920353573"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="920353573"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 11:08:31 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXRoU-0006M3-2q;
        Wed, 01 Mar 2023 19:08:30 +0000
Date:   Thu, 2 Mar 2023 03:08:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     oe-kbuild-all@lists.linux.dev,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Message-ID: <202303020331.PSFMFbXw-lkp@intel.com>
References: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Lobakin/xdp-recycle-Page-Pool-backed-skbs-built-from-XDP-frames/20230302-000635
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230301160315.1022488-2-aleksander.lobakin%40intel.com
patch subject: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built from XDP frames
config: i386-randconfig-a001 (https://download.01.org/0day-ci/archive/20230302/202303020331.PSFMFbXw-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a5ca5578e9bd35220be091fd02df96d492120ee3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-Lobakin/xdp-recycle-Page-Pool-backed-skbs-built-from-XDP-frames/20230302-000635
        git checkout a5ca5578e9bd35220be091fd02df96d492120ee3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303020331.PSFMFbXw-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/core/xdp.c: In function '__xdp_build_skb_from_frame':
>> net/core/xdp.c:662:17: error: implicit declaration of function 'skb_mark_for_recycle' [-Werror=implicit-function-declaration]
     662 |                 skb_mark_for_recycle(skb);
         |                 ^~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/skb_mark_for_recycle +662 net/core/xdp.c

   614	
   615	struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
   616						   struct sk_buff *skb,
   617						   struct net_device *dev)
   618	{
   619		struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
   620		unsigned int headroom, frame_size;
   621		void *hard_start;
   622		u8 nr_frags;
   623	
   624		/* xdp frags frame */
   625		if (unlikely(xdp_frame_has_frags(xdpf)))
   626			nr_frags = sinfo->nr_frags;
   627	
   628		/* Part of headroom was reserved to xdpf */
   629		headroom = sizeof(*xdpf) + xdpf->headroom;
   630	
   631		/* Memory size backing xdp_frame data already have reserved
   632		 * room for build_skb to place skb_shared_info in tailroom.
   633		 */
   634		frame_size = xdpf->frame_sz;
   635	
   636		hard_start = xdpf->data - headroom;
   637		skb = build_skb_around(skb, hard_start, frame_size);
   638		if (unlikely(!skb))
   639			return NULL;
   640	
   641		skb_reserve(skb, headroom);
   642		__skb_put(skb, xdpf->len);
   643		if (xdpf->metasize)
   644			skb_metadata_set(skb, xdpf->metasize);
   645	
   646		if (unlikely(xdp_frame_has_frags(xdpf)))
   647			xdp_update_skb_shared_info(skb, nr_frags,
   648						   sinfo->xdp_frags_size,
   649						   nr_frags * xdpf->frame_sz,
   650						   xdp_frame_is_frag_pfmemalloc(xdpf));
   651	
   652		/* Essential SKB info: protocol and skb->dev */
   653		skb->protocol = eth_type_trans(skb, dev);
   654	
   655		/* Optional SKB info, currently missing:
   656		 * - HW checksum info		(skb->ip_summed)
   657		 * - HW RX hash			(skb_set_hash)
   658		 * - RX ring dev queue index	(skb_record_rx_queue)
   659		 */
   660	
   661		if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
 > 662			skb_mark_for_recycle(skb);
   663	
   664		/* Allow SKB to reuse area used by xdp_frame */
   665		xdp_scrub_frame(xdpf);
   666	
   667		return skb;
   668	}
   669	EXPORT_SYMBOL_GPL(__xdp_build_skb_from_frame);
   670	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
