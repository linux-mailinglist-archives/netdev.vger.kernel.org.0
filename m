Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F933E963
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhCQF54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:57:56 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:45070 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhCQF51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:57:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0USDZNaf_1615960639;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USDZNaf_1615960639)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Mar 2021 13:57:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mst@redhat.com
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] virtio_net: replace if (cond) BUG() with BUG_ON()
Date:   Wed, 17 Mar 2021 13:57:15 +0800
Message-Id: <1615960635-29735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/virtio_net.c:1551:2-5: WARNING: Use BUG_ON instead of if
condition followed by BUG.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d..093530b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1545,10 +1545,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	else
 		hdr = skb_vnet_hdr(skb);
 
-	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
-				    virtio_is_little_endian(vi->vdev), false,
-				    0))
-		BUG();
+	BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,  virtio_is_little_endian(vi->vdev),
+				       false, 0));
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
1.8.3.1

