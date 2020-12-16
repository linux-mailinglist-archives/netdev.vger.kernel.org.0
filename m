Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDC32DBBAF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgLPGwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgLPGwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmKuoq/eJL60Avkq6jWrOvKKIpC9RekVhPJ5QHqfZ8M=;
        b=bHWrh8AHh0x9Q78rMSh20bybxxfPOPYhybVHUaD9qwfGjg8M0i5EMLrr1n9wMjuGQ4iQmu
        8uz6wp2ZDrzlbo44vfDzf18cgI4/yO5EJvNwXnlWDm0RzcucvTVzEuD+Q8tLHD0Yc/ibtV
        y7J4eHKhSIUZSgyM9xZZrMaC+izFQUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-VtY8BNa_O7-XL_z_w8lpCA-1; Wed, 16 Dec 2020 01:50:40 -0500
X-MC-Unique: VtY8BNa_O7-XL_z_w8lpCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADE57801AC0;
        Wed, 16 Dec 2020 06:50:38 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 946BD10023B2;
        Wed, 16 Dec 2020 06:50:34 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 18/21] vdpa_sim: advertise VIRTIO_NET_F_MTU
Date:   Wed, 16 Dec 2020 14:48:15 +0800
Message-Id: <20201216064818.48239-19-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've already reported maximum mtu via config space, so let's
advertise the feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index fe4888dfb70f..8d051cf25f0a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -66,7 +66,8 @@ struct vdpasim_virtqueue {
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
 			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			      (1ULL << VIRTIO_NET_F_MAC);
+			      (1ULL << VIRTIO_NET_F_MAC) |
+			      (1ULL << VIRTIO_NET_F_MTU);
 
 /* State of each vdpasim device */
 struct vdpasim {
-- 
2.25.1

