Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9053B14AB
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhFWHfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:35:20 -0400
Received: from mx21.baidu.com ([220.181.3.85]:56666 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229864AbhFWHfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 03:35:19 -0400
Received: from BJHW-Mail-Ex09.internal.baidu.com (unknown [10.127.64.32])
        by Forcepoint Email with ESMTPS id 27950A13896BCEE60EDB;
        Wed, 23 Jun 2021 15:32:52 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Wed, 23 Jun 2021 15:32:52 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Wed, 23 Jun 2021 15:32:51 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] add "else {...}" according coding style
Date:   Wed, 23 Jun 2021 15:32:43 +0800
Message-ID: <20210623073243.876-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex16.internal.baidu.com (172.31.51.56) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex09_2021-06-23 15:32:52:172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

coding-style.rst shows that:
        if (condition) {
                do_this();
                do_that();
        } else {
                otherwise();
        }

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/virtio_net.c | 3 ++-
 drivers/vhost/vringh.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21ff7b9e49c2..7cd062cb468e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -314,8 +314,9 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
                rq->pages = (struct page *)p->private;
                /* clear private here, it is used to chain pages */
                p->private = 0;
-       } else
+       } else {
                p = alloc_page(gfp_mask);
+       }
        return p;
 }

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4af8fa259d65..79542cad1072 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -454,8 +454,9 @@ static inline int __vringh_complete(struct vringh *vrh,
                if (!err)
                        err = putused(vrh, &used_ring->ring[0], used + part,
                                      num_used - part);
-       } else
+       } else {
                err = putused(vrh, &used_ring->ring[off], used, num_used);
+       }

        if (err) {
                vringh_bad("Failed to write %u used entries %u at %p",
--
2.17.1

