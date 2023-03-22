Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DFB6C5AC9
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjCVXph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCVXpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:45:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879152FCE5;
        Wed, 22 Mar 2023 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679528700; x=1711064700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qw02EwvrD9YAPynAX4WZC2T8OQkJ5gsR8oDM2kkWs3E=;
  b=MYIK/t8ObWuxSfFUHUjKED7jRDID4ZAE63yp4SP3/TbB2Pg/kJVvtLte
   bUCXh1qzdolttFFUShQsUMZgAAoiWYCqUu1w240tnUQe9DT0ngZwi8Kdq
   hkkTe6XGYsAdT8rdBehh2INzGNd6KcqS7FJJtD+syG05r/1l0amLlVPsv
   CpWhJyIT4gp0MY4+U5kQwYDMB63pAxWtvi9OrTWTMlf8LzQ31t6dnRw2i
   +O8WhWnsbNOGgCl+YrqWtsaXf+eOhyB86TcrZL98HVZJrbNwvjD9bSSaK
   7empCtf1vhJzEOFlNxA6X41TQ0V8IVpXUIDgGl6yZ0Ey8q41WB4aTC3UJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404247102"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="404247102"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 16:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="712444421"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="712444421"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2023 16:44:06 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pf87c-000Dki-1Z;
        Wed, 22 Mar 2023 23:44:00 +0000
Date:   Thu, 23 Mar 2023 07:43:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 7/8] virtio_net: introduce
 receive_mergeable_xdp()
Message-ID: <202303230720.XUavHilr-lkp@intel.com>
References: <20230322030308.16046-8-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322030308.16046-8-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/virtio_net-mergeable-xdp-put-old-page-immediately/20230322-110445
patch link:    https://lore.kernel.org/r/20230322030308.16046-8-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH net-next 7/8] virtio_net: introduce receive_mergeable_xdp()
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20230323/202303230720.XUavHilr-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c00edb888e239eb9eb468c0e93419f373f5e72a7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/virtio_net-mergeable-xdp-put-old-page-immediately/20230322-110445
        git checkout c00edb888e239eb9eb468c0e93419f373f5e72a7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303230720.XUavHilr-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/virtio_net.c:1399:6: warning: variable 'page' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (unlikely(len > truesize - room)) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1490:11: note: uninitialized use occurs here
           put_page(page);
                    ^~~~
   drivers/net/virtio_net.c:1399:2: note: remove the 'if' if its condition is always false
           if (unlikely(len > truesize - room)) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1392:19: note: initialize the variable 'page' to silence this warning
           struct page *page;
                            ^
                             = NULL
>> drivers/net/virtio_net.c:1399:6: warning: variable 'num_buf' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (unlikely(len > truesize - room)) {
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
   # define unlikely(x)    __builtin_expect(!!(x), 0)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1491:25: note: uninitialized use occurs here
           mergeable_buf_free(rq, num_buf, dev, stats);
                                  ^~~~~~~
   drivers/net/virtio_net.c:1399:2: note: remove the 'if' if its condition is always false
           if (unlikely(len > truesize - room)) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/virtio_net.c:1393:13: note: initialize the variable 'num_buf' to silence this warning
           int num_buf;
                      ^
                       = 0
   2 warnings generated.


vim +1399 drivers/net/virtio_net.c

  1375	
  1376	static struct sk_buff *receive_mergeable(struct net_device *dev,
  1377						 struct virtnet_info *vi,
  1378						 struct receive_queue *rq,
  1379						 void *buf,
  1380						 void *ctx,
  1381						 unsigned int len,
  1382						 unsigned int *xdp_xmit,
  1383						 struct virtnet_rq_stats *stats)
  1384	{
  1385		unsigned int truesize = mergeable_ctx_to_truesize(ctx);
  1386		unsigned int headroom = mergeable_ctx_to_headroom(ctx);
  1387		unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
  1388		unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
  1389		struct virtio_net_hdr_mrg_rxbuf *hdr;
  1390		struct sk_buff *head_skb, *curr_skb;
  1391		struct bpf_prog *xdp_prog;
  1392		struct page *page;
  1393		int num_buf;
  1394		int offset;
  1395	
  1396		head_skb = NULL;
  1397		stats->bytes += len - vi->hdr_len;
  1398	
> 1399		if (unlikely(len > truesize - room)) {
  1400			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
  1401				 dev->name, len, (unsigned long)(truesize - room));
  1402			dev->stats.rx_length_errors++;
  1403			goto err_skb;
  1404		}
  1405	
  1406		if (likely(vi->xdp_enabled)) {
  1407			rcu_read_lock();
  1408			xdp_prog = rcu_dereference(rq->xdp_prog);
  1409			if (xdp_prog) {
  1410				head_skb = receive_mergeable_xdp(dev, vi, rq, xdp_prog,
  1411								 buf, ctx, len, xdp_xmit,
  1412								 stats);
  1413				rcu_read_unlock();
  1414				return head_skb;
  1415			}
  1416			rcu_read_unlock();
  1417		}
  1418	
  1419		hdr = buf;
  1420		num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
  1421		page = virt_to_head_page(buf);
  1422		offset = buf - page_address(page);
  1423	
  1424		head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
  1425		curr_skb = head_skb;
  1426	
  1427		if (unlikely(!curr_skb))
  1428			goto err_skb;
  1429		while (--num_buf) {
  1430			int num_skb_frags;
  1431	
  1432			buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
  1433			if (unlikely(!buf)) {
  1434				pr_debug("%s: rx error: %d buffers out of %d missing\n",
  1435					 dev->name, num_buf,
  1436					 virtio16_to_cpu(vi->vdev,
  1437							 hdr->num_buffers));
  1438				dev->stats.rx_length_errors++;
  1439				goto err_buf;
  1440			}
  1441	
  1442			stats->bytes += len;
  1443			page = virt_to_head_page(buf);
  1444	
  1445			truesize = mergeable_ctx_to_truesize(ctx);
  1446			headroom = mergeable_ctx_to_headroom(ctx);
  1447			tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
  1448			room = SKB_DATA_ALIGN(headroom + tailroom);
  1449			if (unlikely(len > truesize - room)) {
  1450				pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
  1451					 dev->name, len, (unsigned long)(truesize - room));
  1452				dev->stats.rx_length_errors++;
  1453				goto err_skb;
  1454			}
  1455	
  1456			num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
  1457			if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
  1458				struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
  1459	
  1460				if (unlikely(!nskb))
  1461					goto err_skb;
  1462				if (curr_skb == head_skb)
  1463					skb_shinfo(curr_skb)->frag_list = nskb;
  1464				else
  1465					curr_skb->next = nskb;
  1466				curr_skb = nskb;
  1467				head_skb->truesize += nskb->truesize;
  1468				num_skb_frags = 0;
  1469			}
  1470			if (curr_skb != head_skb) {
  1471				head_skb->data_len += len;
  1472				head_skb->len += len;
  1473				head_skb->truesize += truesize;
  1474			}
  1475			offset = buf - page_address(page);
  1476			if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
  1477				put_page(page);
  1478				skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
  1479						     len, truesize);
  1480			} else {
  1481				skb_add_rx_frag(curr_skb, num_skb_frags, page,
  1482						offset, len, truesize);
  1483			}
  1484		}
  1485	
  1486		ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
  1487		return head_skb;
  1488	
  1489	err_skb:
  1490		put_page(page);
  1491		mergeable_buf_free(rq, num_buf, dev, stats);
  1492	
  1493	err_buf:
  1494		stats->drops++;
  1495		dev_kfree_skb(head_skb);
  1496		return NULL;
  1497	}
  1498	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
