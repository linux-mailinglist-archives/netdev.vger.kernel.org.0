Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7C685EC6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBAFNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjBAFNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:13:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CADC166DE;
        Tue, 31 Jan 2023 21:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675228390; x=1706764390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xWwCKHYt2J5l61HD0a3yuo0QATfIPEAmjkskt55PBV4=;
  b=WEChysdYokcDsfjWxWWKQ0f8uxMc8dCV/D6q74ylTNrFTav33VawQBdI
   i6aolfaNJPrPIqaQZkRLpps1f1F/Puc/u/3Hucf7xOc+eKKPdX5A8blCL
   Pm5gyGaLUtIJKN1SnzsTYJ50KWQ8v3A8Hlb8363Z6gZ86JK3zZEVfGU3i
   OaY1lfakaH4JpS52QYBuWhRJefwcIKY0APexGripgNurJPRnQlrLJpWGf
   xp0VDgweCxI1YewGVHGaF/aLeHwel2Q8AzCJxgFok5EzCBWFqswP9rvKr
   TM7QY/NJ35WaLS24zIvRPFmVaNrFxAbpRhCggHdH436FypvXouJ8tCF9y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="311670868"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="311670868"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 21:13:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="695212481"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="695212481"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2023 21:13:05 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pN5Qe-000566-2a;
        Wed, 01 Feb 2023 05:13:04 +0000
Date:   Wed, 1 Feb 2023 13:12:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Heng Qi <hengqi@linux.alibaba.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: Re: [PATCH net-next] virtio-net: fix possible unsigned integer
 overflow
Message-ID: <202302011339.GBk75YVm-lkp@intel.com>
References: <20230131024630-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131024630-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Michael-S-Tsirkin/Re-PATCH-net-next-virtio-net-fix-possible-unsigned-integer-overflow/20230131-155257
patch link:    https://lore.kernel.org/r/20230131024630-mutt-send-email-mst%40kernel.org
patch subject: Re: [PATCH net-next] virtio-net: fix possible unsigned integer overflow
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230201/202302011339.GBk75YVm-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/077b51b239749c6168bbda5ebe0bb3362d33e2bc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Michael-S-Tsirkin/Re-PATCH-net-next-virtio-net-fix-possible-unsigned-integer-overflow/20230131-155257
        git checkout 077b51b239749c6168bbda5ebe0bb3362d33e2bc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/virtio_net.c: In function 'receive_mergeable':
>> drivers/net/virtio_net.c:1179:50: error: passing argument 8 of 'virtnet_build_xdp_buff_mrg' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1179 |                                                  &num_buf, &xdp_frags_truesz, stats);
         |                                                  ^~~~~~~~
         |                                                  |
         |                                                  int *
   drivers/net/virtio_net.c:999:44: note: expected 'u16 *' {aka 'short unsigned int *'} but argument is of type 'int *'
     999 |                                       u16 *num_buf,
         |                                       ~~~~~^~~~~~~
   cc1: some warnings being treated as errors


vim +/virtnet_build_xdp_buff_mrg +1179 drivers/net/virtio_net.c

ef75cb51f13941 Heng Qi                2023-01-14  1075  
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1076  static struct sk_buff *receive_mergeable(struct net_device *dev,
fdd819b21576c3 Michael S. Tsirkin     2014-10-07  1077  					 struct virtnet_info *vi,
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1078  					 struct receive_queue *rq,
680557cf79f826 Michael S. Tsirkin     2017-03-06  1079  					 void *buf,
680557cf79f826 Michael S. Tsirkin     2017-03-06  1080  					 void *ctx,
186b3c998c50fc Jason Wang             2017-09-19  1081  					 unsigned int len,
7d9d60fd4ab696 Toshiaki Makita        2018-07-23  1082  					 unsigned int *xdp_xmit,
d46eeeaf99bcfa Jason Wang             2018-07-31  1083  					 struct virtnet_rq_stats *stats)
9ab86bbcf8be75 Shirley Ma             2010-01-29  1084  {
012873d057a449 Michael S. Tsirkin     2014-10-24  1085  	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
077b51b239749c Michael S. Tsirkin     2023-01-31  1086  	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1087  	struct page *page = virt_to_head_page(buf);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1088  	int offset = buf - page_address(page);
f600b690501550 John Fastabend         2016-12-15  1089  	struct sk_buff *head_skb, *curr_skb;
f600b690501550 John Fastabend         2016-12-15  1090  	struct bpf_prog *xdp_prog;
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1091  	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
4941d472bf95b4 Jason Wang             2017-07-19  1092  	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
ef75cb51f13941 Heng Qi                2023-01-14  1093  	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
ef75cb51f13941 Heng Qi                2023-01-14  1094  	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
22174f79a44baf Heng Qi                2023-01-14  1095  	unsigned int frame_sz, xdp_room;
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1096  	int err;
f600b690501550 John Fastabend         2016-12-15  1097  
56434a01b12e99 John Fastabend         2016-12-15  1098  	head_skb = NULL;
d46eeeaf99bcfa Jason Wang             2018-07-31  1099  	stats->bytes += len - vi->hdr_len;
56434a01b12e99 John Fastabend         2016-12-15  1100  
ef75cb51f13941 Heng Qi                2023-01-14  1101  	if (unlikely(len > truesize - room)) {
ad993a95c50841 Xie Yongji             2021-05-31  1102  		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
ef75cb51f13941 Heng Qi                2023-01-14  1103  			 dev->name, len, (unsigned long)(truesize - room));
ad993a95c50841 Xie Yongji             2021-05-31  1104  		dev->stats.rx_length_errors++;
ad993a95c50841 Xie Yongji             2021-05-31  1105  		goto err_skb;
ad993a95c50841 Xie Yongji             2021-05-31  1106  	}
6213f07cb542c9 Li RongQing            2021-10-09  1107  
6213f07cb542c9 Li RongQing            2021-10-09  1108  	if (likely(!vi->xdp_enabled)) {
6213f07cb542c9 Li RongQing            2021-10-09  1109  		xdp_prog = NULL;
6213f07cb542c9 Li RongQing            2021-10-09  1110  		goto skip_xdp;
6213f07cb542c9 Li RongQing            2021-10-09  1111  	}
6213f07cb542c9 Li RongQing            2021-10-09  1112  
f600b690501550 John Fastabend         2016-12-15  1113  	rcu_read_lock();
f600b690501550 John Fastabend         2016-12-15  1114  	xdp_prog = rcu_dereference(rq->xdp_prog);
f600b690501550 John Fastabend         2016-12-15  1115  	if (xdp_prog) {
22174f79a44baf Heng Qi                2023-01-14  1116  		unsigned int xdp_frags_truesz = 0;
22174f79a44baf Heng Qi                2023-01-14  1117  		struct skb_shared_info *shinfo;
44fa2dbd475996 Jesper Dangaard Brouer 2018-04-17  1118  		struct xdp_frame *xdpf;
72979a6c35907b John Fastabend         2016-12-15  1119  		struct page *xdp_page;
0354e4d19cd5de John Fastabend         2017-02-02  1120  		struct xdp_buff xdp;
0354e4d19cd5de John Fastabend         2017-02-02  1121  		void *data;
f600b690501550 John Fastabend         2016-12-15  1122  		u32 act;
22174f79a44baf Heng Qi                2023-01-14  1123  		int i;
f600b690501550 John Fastabend         2016-12-15  1124  
3d62b2a0db505b Jason Wang             2018-05-22  1125  		/* Transient failure which in theory could occur if
3d62b2a0db505b Jason Wang             2018-05-22  1126  		 * in-flight packets from before XDP was enabled reach
3d62b2a0db505b Jason Wang             2018-05-22  1127  		 * the receive path after XDP is loaded.
3d62b2a0db505b Jason Wang             2018-05-22  1128  		 */
3d62b2a0db505b Jason Wang             2018-05-22  1129  		if (unlikely(hdr->hdr.gso_type))
3d62b2a0db505b Jason Wang             2018-05-22  1130  			goto err_xdp;
3d62b2a0db505b Jason Wang             2018-05-22  1131  
ef75cb51f13941 Heng Qi                2023-01-14  1132  		/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
ef75cb51f13941 Heng Qi                2023-01-14  1133  		 * with headroom may add hole in truesize, which
ef75cb51f13941 Heng Qi                2023-01-14  1134  		 * make their length exceed PAGE_SIZE. So we disabled the
ef75cb51f13941 Heng Qi                2023-01-14  1135  		 * hole mechanism for xdp. See add_recvbuf_mergeable().
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1136  		 */
ef75cb51f13941 Heng Qi                2023-01-14  1137  		frame_sz = truesize;
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1138  
22174f79a44baf Heng Qi                2023-01-14  1139  		/* This happens when headroom is not enough because
22174f79a44baf Heng Qi                2023-01-14  1140  		 * of the buffer was prefilled before XDP is set.
22174f79a44baf Heng Qi                2023-01-14  1141  		 * This should only happen for the first several packets.
22174f79a44baf Heng Qi                2023-01-14  1142  		 * In fact, vq reset can be used here to help us clean up
22174f79a44baf Heng Qi                2023-01-14  1143  		 * the prefilled buffers, but many existing devices do not
22174f79a44baf Heng Qi                2023-01-14  1144  		 * support it, and we don't want to bother users who are
22174f79a44baf Heng Qi                2023-01-14  1145  		 * using xdp normally.
3cc81a9aac4382 Jason Wang             2018-03-02  1146  		 */
22174f79a44baf Heng Qi                2023-01-14  1147  		if (!xdp_prog->aux->xdp_has_frags &&
22174f79a44baf Heng Qi                2023-01-14  1148  		    (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
72979a6c35907b John Fastabend         2016-12-15  1149  			/* linearize data for XDP */
56a86f84b8332a Jason Wang             2016-12-23  1150  			xdp_page = xdp_linearize_page(rq, &num_buf,
4941d472bf95b4 Jason Wang             2017-07-19  1151  						      page, offset,
4941d472bf95b4 Jason Wang             2017-07-19  1152  						      VIRTIO_XDP_HEADROOM,
4941d472bf95b4 Jason Wang             2017-07-19  1153  						      &len);
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1154  			frame_sz = PAGE_SIZE;
9ce6146ec7b507 Jesper Dangaard Brouer 2020-05-14  1155  
72979a6c35907b John Fastabend         2016-12-15  1156  			if (!xdp_page)
f600b690501550 John Fastabend         2016-12-15  1157  				goto err_xdp;
2de2f7f40ef923 John Fastabend         2017-02-02  1158  			offset = VIRTIO_XDP_HEADROOM;
22174f79a44baf Heng Qi                2023-01-14  1159  		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
22174f79a44baf Heng Qi                2023-01-14  1160  			xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
22174f79a44baf Heng Qi                2023-01-14  1161  						  sizeof(struct skb_shared_info));
22174f79a44baf Heng Qi                2023-01-14  1162  			if (len + xdp_room > PAGE_SIZE)
22174f79a44baf Heng Qi                2023-01-14  1163  				goto err_xdp;
22174f79a44baf Heng Qi                2023-01-14  1164  
22174f79a44baf Heng Qi                2023-01-14  1165  			xdp_page = alloc_page(GFP_ATOMIC);
22174f79a44baf Heng Qi                2023-01-14  1166  			if (!xdp_page)
22174f79a44baf Heng Qi                2023-01-14  1167  				goto err_xdp;
22174f79a44baf Heng Qi                2023-01-14  1168  
22174f79a44baf Heng Qi                2023-01-14  1169  			memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
22174f79a44baf Heng Qi                2023-01-14  1170  			       page_address(page) + offset, len);
22174f79a44baf Heng Qi                2023-01-14  1171  			frame_sz = PAGE_SIZE;
22174f79a44baf Heng Qi                2023-01-14  1172  			offset = VIRTIO_XDP_HEADROOM;
72979a6c35907b John Fastabend         2016-12-15  1173  		} else {
72979a6c35907b John Fastabend         2016-12-15  1174  			xdp_page = page;
f600b690501550 John Fastabend         2016-12-15  1175  		}
f600b690501550 John Fastabend         2016-12-15  1176  
0354e4d19cd5de John Fastabend         2017-02-02  1177  		data = page_address(xdp_page) + offset;
22174f79a44baf Heng Qi                2023-01-14  1178  		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
22174f79a44baf Heng Qi                2023-01-14 @1179  						 &num_buf, &xdp_frags_truesz, stats);
22174f79a44baf Heng Qi                2023-01-14  1180  		if (unlikely(err))
22174f79a44baf Heng Qi                2023-01-14  1181  			goto err_xdp_frags;
754b8a21a96d5f Jesper Dangaard Brouer 2018-01-03  1182  
0354e4d19cd5de John Fastabend         2017-02-02  1183  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
d46eeeaf99bcfa Jason Wang             2018-07-31  1184  		stats->xdp_packets++;
0354e4d19cd5de John Fastabend         2017-02-02  1185  
56434a01b12e99 John Fastabend         2016-12-15  1186  		switch (act) {
56434a01b12e99 John Fastabend         2016-12-15  1187  		case XDP_PASS:
fab89bafa95b6f Heng Qi                2023-01-14  1188  			if (unlikely(xdp_page != page))
1830f8935f3b17 Jason Wang             2016-12-23  1189  				put_page(page);
fab89bafa95b6f Heng Qi                2023-01-14  1190  			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
fab89bafa95b6f Heng Qi                2023-01-14  1191  			rcu_read_unlock();
1830f8935f3b17 Jason Wang             2016-12-23  1192  			return head_skb;
56434a01b12e99 John Fastabend         2016-12-15  1193  		case XDP_TX:
d46eeeaf99bcfa Jason Wang             2018-07-31  1194  			stats->xdp_tx++;
1b698fa5d8ef95 Lorenzo Bianconi       2020-05-28  1195  			xdpf = xdp_convert_buff_to_frame(&xdp);
7a542bee27c6a5 Xuan Zhuo              2022-08-04  1196  			if (unlikely(!xdpf)) {
fab89bafa95b6f Heng Qi                2023-01-14  1197  				netdev_dbg(dev, "convert buff to frame failed for xdp\n");
fab89bafa95b6f Heng Qi                2023-01-14  1198  				goto err_xdp_frags;
7a542bee27c6a5 Xuan Zhuo              2022-08-04  1199  			}
ca9e83b4a55bfa Jason Wang             2018-07-31  1200  			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
fdc13979f91e66 Lorenzo Bianconi       2021-03-08  1201  			if (unlikely(!err)) {
fdc13979f91e66 Lorenzo Bianconi       2021-03-08  1202  				xdp_return_frame_rx_napi(xdpf);
fdc13979f91e66 Lorenzo Bianconi       2021-03-08  1203  			} else if (unlikely(err < 0)) {
0354e4d19cd5de John Fastabend         2017-02-02  1204  				trace_xdp_exception(vi->dev, xdp_prog, act);
fab89bafa95b6f Heng Qi                2023-01-14  1205  				goto err_xdp_frags;
11b7d897ccc1fb Jesper Dangaard Brouer 2018-02-20  1206  			}
2471c75efed325 Jesper Dangaard Brouer 2018-06-26  1207  			*xdp_xmit |= VIRTIO_XDP_TX;
72979a6c35907b John Fastabend         2016-12-15  1208  			if (unlikely(xdp_page != page))
5d458a13dd59d0 Jason Wang             2018-05-22  1209  				put_page(page);
56434a01b12e99 John Fastabend         2016-12-15  1210  			rcu_read_unlock();
56434a01b12e99 John Fastabend         2016-12-15  1211  			goto xdp_xmit;
3cc81a9aac4382 Jason Wang             2018-03-02  1212  		case XDP_REDIRECT:
d46eeeaf99bcfa Jason Wang             2018-07-31  1213  			stats->xdp_redirects++;
3cc81a9aac4382 Jason Wang             2018-03-02  1214  			err = xdp_do_redirect(dev, &xdp, xdp_prog);
fab89bafa95b6f Heng Qi                2023-01-14  1215  			if (err)
fab89bafa95b6f Heng Qi                2023-01-14  1216  				goto err_xdp_frags;
2471c75efed325 Jesper Dangaard Brouer 2018-06-26  1217  			*xdp_xmit |= VIRTIO_XDP_REDIR;
3cc81a9aac4382 Jason Wang             2018-03-02  1218  			if (unlikely(xdp_page != page))
6890418bbb780f Jason Wang             2018-05-22  1219  				put_page(page);
3cc81a9aac4382 Jason Wang             2018-03-02  1220  			rcu_read_unlock();
3cc81a9aac4382 Jason Wang             2018-03-02  1221  			goto xdp_xmit;
56434a01b12e99 John Fastabend         2016-12-15  1222  		default:
c8064e5b4adac5 Paolo Abeni            2021-11-30  1223  			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
df561f6688fef7 Gustavo A. R. Silva    2020-08-23  1224  			fallthrough;
0354e4d19cd5de John Fastabend         2017-02-02  1225  		case XDP_ABORTED:
0354e4d19cd5de John Fastabend         2017-02-02  1226  			trace_xdp_exception(vi->dev, xdp_prog, act);
df561f6688fef7 Gustavo A. R. Silva    2020-08-23  1227  			fallthrough;
0354e4d19cd5de John Fastabend         2017-02-02  1228  		case XDP_DROP:
fab89bafa95b6f Heng Qi                2023-01-14  1229  			goto err_xdp_frags;
f600b690501550 John Fastabend         2016-12-15  1230  		}
22174f79a44baf Heng Qi                2023-01-14  1231  err_xdp_frags:
22174f79a44baf Heng Qi                2023-01-14  1232  		if (unlikely(xdp_page != page))
22174f79a44baf Heng Qi                2023-01-14  1233  			__free_pages(xdp_page, 0);
22174f79a44baf Heng Qi                2023-01-14  1234  
22174f79a44baf Heng Qi                2023-01-14  1235  		if (xdp_buff_has_frags(&xdp)) {
22174f79a44baf Heng Qi                2023-01-14  1236  			shinfo = xdp_get_shared_info_from_buff(&xdp);
22174f79a44baf Heng Qi                2023-01-14  1237  			for (i = 0; i < shinfo->nr_frags; i++) {
22174f79a44baf Heng Qi                2023-01-14  1238  				xdp_page = skb_frag_page(&shinfo->frags[i]);
22174f79a44baf Heng Qi                2023-01-14  1239  				put_page(xdp_page);
22174f79a44baf Heng Qi                2023-01-14  1240  			}
22174f79a44baf Heng Qi                2023-01-14  1241  		}
22174f79a44baf Heng Qi                2023-01-14  1242  
22174f79a44baf Heng Qi                2023-01-14  1243  		goto err_xdp;
56434a01b12e99 John Fastabend         2016-12-15  1244  	}
f600b690501550 John Fastabend         2016-12-15  1245  	rcu_read_unlock();
ab7db91705e95e Michael Dalton         2014-01-16  1246  
6213f07cb542c9 Li RongQing            2021-10-09  1247  skip_xdp:
18117a842ab029 Heng Qi                2023-01-14  1248  	head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
f600b690501550 John Fastabend         2016-12-15  1249  	curr_skb = head_skb;
3f2c31d90327f2 Mark McLoughlin        2008-11-16  1250  
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1251  	if (unlikely(!curr_skb))
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1252  		goto err_skb;
9ab86bbcf8be75 Shirley Ma             2010-01-29  1253  	while (--num_buf) {
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1254  		int num_skb_frags;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1255  
680557cf79f826 Michael S. Tsirkin     2017-03-06  1256  		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
03e9f8a05bce73 Yunjian Wang           2017-12-04  1257  		if (unlikely(!buf)) {
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1258  			pr_debug("%s: rx error: %d buffers out of %d missing\n",
fdd819b21576c3 Michael S. Tsirkin     2014-10-07  1259  				 dev->name, num_buf,
012873d057a449 Michael S. Tsirkin     2014-10-24  1260  				 virtio16_to_cpu(vi->vdev,
012873d057a449 Michael S. Tsirkin     2014-10-24  1261  						 hdr->num_buffers));
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1262  			dev->stats.rx_length_errors++;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1263  			goto err_buf;
3f2c31d90327f2 Mark McLoughlin        2008-11-16  1264  		}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1265  
d46eeeaf99bcfa Jason Wang             2018-07-31  1266  		stats->bytes += len;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1267  		page = virt_to_head_page(buf);
28b39bc7c57e79 Jason Wang             2017-07-19  1268  
28b39bc7c57e79 Jason Wang             2017-07-19  1269  		truesize = mergeable_ctx_to_truesize(ctx);
ef75cb51f13941 Heng Qi                2023-01-14  1270  		headroom = mergeable_ctx_to_headroom(ctx);
ef75cb51f13941 Heng Qi                2023-01-14  1271  		tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
ef75cb51f13941 Heng Qi                2023-01-14  1272  		room = SKB_DATA_ALIGN(headroom + tailroom);
ef75cb51f13941 Heng Qi                2023-01-14  1273  		if (unlikely(len > truesize - room)) {
56da5fd04e3d51 Dan Carpenter          2017-04-06  1274  			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
ef75cb51f13941 Heng Qi                2023-01-14  1275  				 dev->name, len, (unsigned long)(truesize - room));
680557cf79f826 Michael S. Tsirkin     2017-03-06  1276  			dev->stats.rx_length_errors++;
680557cf79f826 Michael S. Tsirkin     2017-03-06  1277  			goto err_skb;
680557cf79f826 Michael S. Tsirkin     2017-03-06  1278  		}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1279  
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1280  		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
2613af0ed18a11 Michael Dalton         2013-10-28  1281  		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
2613af0ed18a11 Michael Dalton         2013-10-28  1282  			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1283  
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1284  			if (unlikely(!nskb))
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1285  				goto err_skb;
2613af0ed18a11 Michael Dalton         2013-10-28  1286  			if (curr_skb == head_skb)
2613af0ed18a11 Michael Dalton         2013-10-28  1287  				skb_shinfo(curr_skb)->frag_list = nskb;
2613af0ed18a11 Michael Dalton         2013-10-28  1288  			else
2613af0ed18a11 Michael Dalton         2013-10-28  1289  				curr_skb->next = nskb;
2613af0ed18a11 Michael Dalton         2013-10-28  1290  			curr_skb = nskb;
2613af0ed18a11 Michael Dalton         2013-10-28  1291  			head_skb->truesize += nskb->truesize;
2613af0ed18a11 Michael Dalton         2013-10-28  1292  			num_skb_frags = 0;
2613af0ed18a11 Michael Dalton         2013-10-28  1293  		}
2613af0ed18a11 Michael Dalton         2013-10-28  1294  		if (curr_skb != head_skb) {
2613af0ed18a11 Michael Dalton         2013-10-28  1295  			head_skb->data_len += len;
2613af0ed18a11 Michael Dalton         2013-10-28  1296  			head_skb->len += len;
fb51879dbceab9 Michael Dalton         2014-01-16  1297  			head_skb->truesize += truesize;
2613af0ed18a11 Michael Dalton         2013-10-28  1298  		}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1299  		offset = buf - page_address(page);
ba275241030cfe Jason Wang             2013-11-01  1300  		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
ba275241030cfe Jason Wang             2013-11-01  1301  			put_page(page);
ba275241030cfe Jason Wang             2013-11-01  1302  			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
fb51879dbceab9 Michael Dalton         2014-01-16  1303  					     len, truesize);
ba275241030cfe Jason Wang             2013-11-01  1304  		} else {
2613af0ed18a11 Michael Dalton         2013-10-28  1305  			skb_add_rx_frag(curr_skb, num_skb_frags, page,
fb51879dbceab9 Michael Dalton         2014-01-16  1306  					offset, len, truesize);
ba275241030cfe Jason Wang             2013-11-01  1307  		}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1308  	}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1309  
5377d75823ff90 Johannes Berg          2015-08-19  1310  	ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1311  	return head_skb;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1312  
f600b690501550 John Fastabend         2016-12-15  1313  err_xdp:
f600b690501550 John Fastabend         2016-12-15  1314  	rcu_read_unlock();
d46eeeaf99bcfa Jason Wang             2018-07-31  1315  	stats->xdp_drops++;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1316  err_skb:
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1317  	put_page(page);
850e088d5bbb33 Jason Wang             2018-05-22  1318  	while (num_buf-- > 1) {
680557cf79f826 Michael S. Tsirkin     2017-03-06  1319  		buf = virtqueue_get_buf(rq->vq, &len);
680557cf79f826 Michael S. Tsirkin     2017-03-06  1320  		if (unlikely(!buf)) {
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1321  			pr_debug("%s: rx error: %d buffers missing\n",
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1322  				 dev->name, num_buf);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1323  			dev->stats.rx_length_errors++;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1324  			break;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1325  		}
d46eeeaf99bcfa Jason Wang             2018-07-31  1326  		stats->bytes += len;
680557cf79f826 Michael S. Tsirkin     2017-03-06  1327  		page = virt_to_head_page(buf);
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1328  		put_page(page);
9ab86bbcf8be75 Shirley Ma             2010-01-29  1329  	}
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1330  err_buf:
d46eeeaf99bcfa Jason Wang             2018-07-31  1331  	stats->drops++;
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1332  	dev_kfree_skb(head_skb);
56434a01b12e99 John Fastabend         2016-12-15  1333  xdp_xmit:
8fc3b9e9a22977 Michael S. Tsirkin     2013-11-28  1334  	return NULL;
3f2c31d90327f2 Mark McLoughlin        2008-11-16  1335  }
23cde76d801246 Mark McLoughlin        2008-06-08  1336  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
