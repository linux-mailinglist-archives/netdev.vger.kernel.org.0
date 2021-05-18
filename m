Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D6387578
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348007AbhERJsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:48:17 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:41761 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241211AbhERJsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:48:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UZIo.Ua_1621331216;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UZIo.Ua_1621331216)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 18 May 2021 17:46:57 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] virtio_net: Remove BUG() to aviod machine dead
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
Date:   Tue, 18 May 2021 17:46:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When met error, we output a print to avoid a BUG().

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
  drivers/net/virtio_net.c | 5 ++---
  1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c921ebf3ae82..a66174d13e81 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1647,9 +1647,8 @@ static int xmit_skb(struct send_queue *sq, struct 
sk_buff *skb)
  		hdr = skb_vnet_hdr(skb);

  	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
-				    virtio_is_little_endian(vi->vdev), false,
-				    0))
-		BUG();
+				virtio_is_little_endian(vi->vdev), false, 0))
+		return -EPROTO;

  	if (vi->mergeable_rx_bufs)
  		hdr->num_buffers = 0;
-- 
2.17.1
