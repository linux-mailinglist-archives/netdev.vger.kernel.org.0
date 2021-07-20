Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC39E3CF524
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhGTGdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 02:33:20 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:51282 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237129AbhGTGdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 02:33:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UgOSYrF_1626765219;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgOSYrF_1626765219)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 15:13:49 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH v2] vsock/virtio: set vsock frontend ready in virtio_vsock_probe()
Date:   Tue, 20 Jul 2021 15:13:37 +0800
Message-Id: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missed virtio_device_ready() to set vsock frontend ready.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 net/vmw_vsock/virtio_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e0c2c992a..dc834b8fd 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
+	virtio_device_ready(vdev);
+
 	return 0;
 
 out:
-- 
2.17.1

