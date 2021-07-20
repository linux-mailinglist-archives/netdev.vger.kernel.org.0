Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655393CF2D1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbhGTDBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 23:01:00 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48229 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346553AbhGTDAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 23:00:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UgNm9wq_1626752441;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgNm9wq_1626752441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 11:40:52 +0800
From:   Xianting Tian <tianxianting.txt@linux.alibaba.com>
To:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@linux.alibaba.com>
Subject: [PATCH] vsock/virtio: set vsock frontend ready in virtio_vsock_probe()
Date:   Tue, 20 Jul 2021 11:40:39 +0800
Message-Id: <20210720034039.1351-1-tianxianting.txt@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missed virtio_device_ready() to set vsock frontend ready.

Signed-off-by: Xianting Tian <tianxianting.txt@linux.alibaba.com>
---
 net/vmw_vsock/virtio_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e0c2c992a..eb4c607c4 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -637,6 +637,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vdev->priv = vsock;
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
+	virtio_device_ready(vdev);
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 
 	return 0;
-- 
2.17.1

