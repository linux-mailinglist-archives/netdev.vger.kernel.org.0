Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815672FCC19
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbhATHvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:51:48 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45826 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbhATHuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:50:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UMJCsM0_1611128950;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UMJCsM0_1611128950)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 15:49:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/3] virtio-net: support IFF_TX_SKB_NO_LINEAR
Date:   Wed, 20 Jan 2021 15:49:10 +0800
Message-Id: <d54438cec1fc86a1cb0166098493b1aa6a15885a.1611128806.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20210119142726.4970-1-alobakin@pm.me>
References: <20210119142726.4970-1-alobakin@pm.me>
In-Reply-To: <cover.1611128806.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611128806.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtio net supports the case where the skb linear space is empty, so add
priv_flags.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e637..f2ff6c3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2972,7 +2972,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		return -ENOMEM;
 
 	/* Set up network device as normal. */
-	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
+			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
-- 
1.8.3.1

