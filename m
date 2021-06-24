Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A413B2473
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFXBUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 21:20:30 -0400
Received: from mx20.baidu.com ([111.202.115.85]:48686 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229864AbhFXBUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 21:20:30 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id BFC658B1C1A00E2B8333;
        Thu, 24 Jun 2021 09:18:04 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.10; Thu, 24 Jun 2021 09:18:04 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Thu, 24 Jun 2021 09:18:04 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH v2] virtio_net/vringh: add "else { }" according coding style
Date:   Thu, 24 Jun 2021 09:17:57 +0800
Message-ID: <20210624011757.338-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex11.internal.baidu.com (172.31.51.51) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
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

