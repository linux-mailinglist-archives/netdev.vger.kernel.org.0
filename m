Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9133B1D7C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFWPTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 11:19:47 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:52746 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 11:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=n4uti17wWj1/CT5h9/
        fg8g1tzffNK+G6iQUSow14SlM=; b=ozaQTYll3QvEkGB1pkelq7CvYDa17Zq7rX
        5zVxaVZFGE9iHi/d63WpgUp6qRIpQT7nHIKaoZWHzbkCOMshYQj0jqjc7uq6N5WP
        avkfDK+3iyCsVlXHt3eKD9fUfQG8w1rLEst7HBICnpQAtzsPf+/C9lMZPomYrchK
        fqT8tk5W4=
Received: from 192.168.137.133 (unknown [112.10.75.196])
        by smtp3 (Coremail) with SMTP id DcmowAAnBv9hUNNg9TNFSg--.38421S3;
        Wed, 23 Jun 2021 23:16:52 +0800 (CST)
From:   Xianting Tian <xianting_tian@126.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] virtio_net: Use virtio_find_vqs_ctx() helper
Date:   Wed, 23 Jun 2021 11:16:22 -0400
Message-Id: <1624461382-8302-1-git-send-email-xianting_tian@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DcmowAAnBv9hUNNg9TNFSg--.38421S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr1DWrWxXr17Kw4fJr17trb_yoW3WrXE9F
        yxtF1fJr4Ut3WY93yUuw4rAFy5Ka45WF1kuFyft3yfuryUWFy3XasFqrnrJ3Zruay8AFnx
        JwsrJrW7u3s3ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1773JUUUUU==
X-Originating-IP: [112.10.75.196]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbiogS6pFx5fW+9YwAAsR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_find_vqs_ctx() is defined but never be called currently,
it is the right place to use it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 78a01c7..9061c55 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2830,8 +2830,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 			ctx[rxq2vq(i)] = true;
 	}
 
-	ret = vi->vdev->config->find_vqs(vi->vdev, total_vqs, vqs, callbacks,
-					 names, ctx, NULL);
+	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
+				  names, ctx, NULL);
 	if (ret)
 		goto err_find;
 
-- 
1.8.3.1

