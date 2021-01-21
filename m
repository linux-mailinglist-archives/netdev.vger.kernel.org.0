Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341652FEC41
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbhAUNtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:49:19 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45764 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728739AbhAUNr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:47:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UMRCJb4_1611236830;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UMRCJb4_1611236830)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 21:47:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bpf@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
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
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 2/3] virtio-net: support IFF_TX_SKB_NO_LINEAR
Date:   Thu, 21 Jan 2021 21:47:08 +0800
Message-Id: <b2dd13d32f728407bd4ecc3c7ac9aa615ebc5a16.1611236588.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
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

