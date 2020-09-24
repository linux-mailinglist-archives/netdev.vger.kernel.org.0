Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF58A2766E6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgIXDWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:22:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726714AbgIXDWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=257+bopw92IH4lZUaMeS+qFgZVg0lxCZVzMn3r9TfiQ=;
        b=gqNhDPH4tIvd4kTMKmXbt1jr4BvXgitYEXddJh4CwJF3va21MPo4uvFAxC+G8v8/fDcIsj
        X9xkO8grgC/Hill+4kt6IHwwnjNv7bghSPqeMvBoArSMd1NGXa+pUDRlM4vNJAvfBumZRd
        /jLKINxXESlUSiQ13S82gbImV0oVUC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-jfZrj1e2NzeZh3mlnXquqg-1; Wed, 23 Sep 2020 23:22:14 -0400
X-MC-Unique: jfZrj1e2NzeZh3mlnXquqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CEBB186DD32;
        Thu, 24 Sep 2020 03:22:12 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A837055768;
        Thu, 24 Sep 2020 03:22:06 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 03/24] vhost: move the backend feature bits to vhost_types.h
Date:   Thu, 24 Sep 2020 11:21:04 +0800
Message-Id: <20200924032125.18619-4-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 75232185324a..c26452782882 100644
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
index 9a269a88a6ff..532571571b4b 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -144,4 +144,9 @@ struct vhost_vdpa_config {
 /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
 #define VHOST_NET_F_VIRTIO_NET_HDR 27
 
+/* Use message type V2 */
+#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
+/* IOTLB can accept batching hints */
+#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+
 #endif
-- 
2.20.1

