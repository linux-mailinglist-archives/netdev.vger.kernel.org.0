Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262F22DBB76
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLPGuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:50:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgLPGuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LgtoOZuqafOK0nq8AHmeG/YV/K0PmtXlvUknLye9+3I=;
        b=CJ+7nKbg516RTvN3+3/3wy5XL3kZn6Aa7Bvr4P4Xyz2zh5pekIHln4NPwNCQ1igt7dVZFw
        NxdPplxwPk2RS/KvHrmcVKe3lsXcoNijAoiybmzaIFIqW/32Ge83FxzFlDJ8S4Pi4cX75F
        QWdmA8ELTS67hJFGStspxEY3/flZKrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-9E4wkYGZMxiWY1xhbYWvrg-1; Wed, 16 Dec 2020 01:48:36 -0500
X-MC-Unique: 9E4wkYGZMxiWY1xhbYWvrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 370BE1005513;
        Wed, 16 Dec 2020 06:48:35 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A77110013C1;
        Wed, 16 Dec 2020 06:48:30 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 01/21] vhost: move the backend feature bits to vhost_types.h
Date:   Wed, 16 Dec 2020 14:47:58 +0800
Message-Id: <20201216064818.48239-2-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should store feature bits in vhost_types.h as what has been done
for e.g VHOST_F_LOG_ALL.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/uapi/linux/vhost.h       | 5 -----
 include/uapi/linux/vhost_types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..59c6c0fbaba1 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -89,11 +89,6 @@
 
 /* Set or get vhost backend capability */
 
-/* Use message type V2 */
-#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
-/* IOTLB can accept batching hints */
-#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
-
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..76ee7016c501 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -153,4 +153,9 @@ struct vhost_vdpa_iova_range {
 /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
 #define VHOST_NET_F_VIRTIO_NET_HDR 27
 
+/* Use message type V2 */
+#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
+/* IOTLB can accept batching hints */
+#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+
 #endif
-- 
2.25.1

