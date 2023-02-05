Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17C368B213
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 23:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBEWEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 17:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBEWEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 17:04:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8841199E8;
        Sun,  5 Feb 2023 14:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675634682; x=1707170682;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xaVHZI6dtIw3nflt7wyiHWuKYGBbFllA+XtM5p/ijmY=;
  b=eSs1ODL4dr9AR1EFxp+tTMi/x9kDtLXLCCQrrIml3IwTHUNZQc675nf8
   yC2UOgYorBHE2K9ZEB1BUFsxHCHWzwp+8rZOTtWLJ7KKaaZe44ajxpoa4
   knuB/9N4h8m7gwtak9dI+1MX+VJ+DWUG0ICFfKk6vqCodYdd5hGBGgx0N
   TPxNokWV8709ABSWTmGQCUdxttzbUcW9HS0gQwnHLLK2dX6X46SDIruna
   H+tzjoYzpL2UgD00X9P11C02VOURlJ5RBiS5Skm5QO4dk0hV8W/XN06Yz
   8RqyP4dnTokkKtD/0DLy9BcXgrNZkdx6rQiaevo3KW4w1lAnLsxLey73M
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="326783294"
X-IronPort-AV: E=Sophos;i="5.97,275,1669104000"; 
   d="scan'208";a="326783294"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 14:04:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="659669395"
X-IronPort-AV: E=Sophos;i="5.97,275,1669104000"; 
   d="scan'208";a="659669395"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 05 Feb 2023 14:04:36 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOn7j-0002FE-2U;
        Sun, 05 Feb 2023 22:04:35 +0000
Date:   Mon, 6 Feb 2023 06:04:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 10/33] xsk: support virtio DMA map
Message-ID: <202302060542.IxBGSiKh-lkp@intel.com>
References: <20230202110058.130695-11-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-11-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on mst-vhost/linux-next linus/master v6.2-rc6 next-20230203]
[cannot apply to net/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/virtio_ring-virtqueue_add-support-premapped/20230202-190707
patch link:    https://lore.kernel.org/r/20230202110058.130695-11-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH 10/33] xsk: support virtio DMA map
config: i386-debian-10.3-kvm (https://download.01.org/0day-ci/archive/20230206/202302060542.IxBGSiKh-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/370aefebcea755f7c4c14e16f8dcb5540769fd26
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/virtio_ring-virtqueue_add-support-premapped/20230202-190707
        git checkout 370aefebcea755f7c4c14e16f8dcb5540769fd26
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/xdp/xsk_buff_pool.o: in function `xp_alloc':
>> net/xdp/xsk_buff_pool.c:575: undefined reference to `is_virtio_device'
>> ld: net/xdp/xsk_buff_pool.c:576: undefined reference to `virtio_dma_sync_signle_range_for_device'
   ld: net/xdp/xsk_buff_pool.o: in function `__xp_dma_unmap':
   net/xdp/xsk_buff_pool.c:338: undefined reference to `is_virtio_device'
>> ld: net/xdp/xsk_buff_pool.c:339: undefined reference to `virtio_dma_unmap'
   ld: net/xdp/xsk_buff_pool.o: in function `xp_dma_map':
   net/xdp/xsk_buff_pool.c:443: undefined reference to `is_virtio_device'
   ld: net/xdp/xsk_buff_pool.c:443: undefined reference to `virtio_dma_sync_signle_range_for_device'
>> ld: net/xdp/xsk_buff_pool.c:443: undefined reference to `virtio_dma_sync_signle_range_for_cpu'
>> ld: net/xdp/xsk_buff_pool.c:458: undefined reference to `virtio_dma_map_page'
>> ld: net/xdp/xsk_buff_pool.c:461: undefined reference to `virtio_dma_mapping_error'
>> ld: net/xdp/xsk_buff_pool.c:464: undefined reference to `virtio_dma_need_sync'
>> ld: net/xdp/xsk_buff_pool.c:457: undefined reference to `is_virtio_device'


vim +575 net/xdp/xsk_buff_pool.c

   424	
   425	int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
   426		       unsigned long attrs, struct page **pages, u32 nr_pages)
   427	{
   428		struct xsk_dma_map *dma_map;
   429		dma_addr_t dma;
   430		int err;
   431		u32 i;
   432	
   433		dma_map = xp_find_dma_map(pool);
   434		if (dma_map) {
   435			err = xp_init_dma_info(pool, dma_map);
   436			if (err)
   437				return err;
   438	
   439			refcount_inc(&dma_map->users);
   440			return 0;
   441		}
   442	
 > 443		if (is_virtio_device(dev)) {
   444			pool->dma_sync_for_cpu = virtio_dma_sync_signle_range_for_cpu;
   445			pool->dma_sync_for_device = virtio_dma_sync_signle_range_for_device;
   446	
   447		} else {
   448			pool->dma_sync_for_cpu = dma_sync_for_cpu;
   449			pool->dma_sync_for_device = dma_sync_for_device;
   450		}
   451	
   452		dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
   453		if (!dma_map)
   454			return -ENOMEM;
   455	
   456		for (i = 0; i < dma_map->dma_pages_cnt; i++) {
 > 457			if (is_virtio_device(dev)) {
 > 458				dma = virtio_dma_map_page(dev, pages[i], 0, PAGE_SIZE,
   459							  DMA_BIDIRECTIONAL);
   460	
 > 461				if (virtio_dma_mapping_error(dev, dma))
   462					goto err;
   463	
 > 464				if (virtio_dma_need_sync(dev, dma))
   465					dma_map->dma_need_sync = true;
   466	
   467			} else {
   468				dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
   469							 DMA_BIDIRECTIONAL, attrs);
   470	
   471				if (dma_mapping_error(dev, dma))
   472					goto err;
   473	
   474				if (dma_need_sync(dev, dma))
   475					dma_map->dma_need_sync = true;
   476			}
   477			dma_map->dma_pages[i] = dma;
   478		}
   479	
   480		if (pool->unaligned)
   481			xp_check_dma_contiguity(dma_map);
   482	
   483		err = xp_init_dma_info(pool, dma_map);
   484		if (err) {
   485			__xp_dma_unmap(dma_map, attrs);
   486			return err;
   487		}
   488	
   489		return 0;
   490	err:
   491		__xp_dma_unmap(dma_map, attrs);
   492		return -ENOMEM;
   493	}
   494	EXPORT_SYMBOL(xp_dma_map);
   495	
   496	static bool xp_addr_crosses_non_contig_pg(struct xsk_buff_pool *pool,
   497						  u64 addr)
   498	{
   499		return xp_desc_crosses_non_contig_pg(pool, addr, pool->chunk_size);
   500	}
   501	
   502	static bool xp_check_unaligned(struct xsk_buff_pool *pool, u64 *addr)
   503	{
   504		*addr = xp_unaligned_extract_addr(*addr);
   505		if (*addr >= pool->addrs_cnt ||
   506		    *addr + pool->chunk_size > pool->addrs_cnt ||
   507		    xp_addr_crosses_non_contig_pg(pool, *addr))
   508			return false;
   509		return true;
   510	}
   511	
   512	static bool xp_check_aligned(struct xsk_buff_pool *pool, u64 *addr)
   513	{
   514		*addr = xp_aligned_extract_addr(pool, *addr);
   515		return *addr < pool->addrs_cnt;
   516	}
   517	
   518	static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
   519	{
   520		struct xdp_buff_xsk *xskb;
   521		u64 addr;
   522		bool ok;
   523	
   524		if (pool->free_heads_cnt == 0)
   525			return NULL;
   526	
   527		for (;;) {
   528			if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
   529				pool->fq->queue_empty_descs++;
   530				return NULL;
   531			}
   532	
   533			ok = pool->unaligned ? xp_check_unaligned(pool, &addr) :
   534			     xp_check_aligned(pool, &addr);
   535			if (!ok) {
   536				pool->fq->invalid_descs++;
   537				xskq_cons_release(pool->fq);
   538				continue;
   539			}
   540			break;
   541		}
   542	
   543		if (pool->unaligned) {
   544			xskb = pool->free_heads[--pool->free_heads_cnt];
   545			xp_init_xskb_addr(xskb, pool, addr);
   546			if (pool->dma_pages_cnt)
   547				xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
   548		} else {
   549			xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
   550		}
   551	
   552		xskq_cons_release(pool->fq);
   553		return xskb;
   554	}
   555	
   556	struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
   557	{
   558		struct xdp_buff_xsk *xskb;
   559	
   560		if (!pool->free_list_cnt) {
   561			xskb = __xp_alloc(pool);
   562			if (!xskb)
   563				return NULL;
   564		} else {
   565			pool->free_list_cnt--;
   566			xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk,
   567						free_list_node);
   568			list_del_init(&xskb->free_list_node);
   569		}
   570	
   571		xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
   572		xskb->xdp.data_meta = xskb->xdp.data;
   573	
   574		if (pool->dma_need_sync) {
 > 575			if (is_virtio_device(pool->dev))
 > 576				virtio_dma_sync_signle_range_for_device(pool->dev, xskb->dma, 0,
   577									pool->frame_len,
   578									DMA_BIDIRECTIONAL);
   579			else
   580				dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
   581								 pool->frame_len,
   582								 DMA_BIDIRECTIONAL);
   583		}
   584		return &xskb->xdp;
   585	}
   586	EXPORT_SYMBOL(xp_alloc);
   587	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
