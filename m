Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01646BACB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfGQKyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfGQKy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:54:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1A253066752;
        Wed, 17 Jul 2019 10:54:29 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1D821001DE3;
        Wed, 17 Jul 2019 10:54:18 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 15/15] vhost: enable packed virtqueues
Date:   Wed, 17 Jul 2019 06:52:55 -0400
Message-Id: <20190717105255.63488-16-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 17 Jul 2019 10:54:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables packed virtqueue support for vhost.

Testpmd (virtio-user) + vhost_net shows about 2.6% improvemetn on TX
PPS:

Before: 5.75Mpps
After : 5.90Mpps

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bb3f8bb763b9..5483eea84a5c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -326,7 +326,8 @@ enum {
 			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
 			 (1ULL << VHOST_F_LOG_ALL) |
 			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
-			 (1ULL << VIRTIO_F_VERSION_1)
+			 (1ULL << VIRTIO_F_VERSION_1) |
+			 (1ULL << VIRTIO_F_RING_PACKED)
 };
 
 static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
-- 
2.18.1

