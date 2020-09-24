Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8722C27672B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIXDZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726764AbgIXDZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JjDz5I+JlXV5OkcQPnYHfpYpW55ZyPxuGBbeeuU1mY=;
        b=P1uG7sJPUQqmtwlDrhGBFZdsA+7Eg9TkG0KjjeUuaHP2ZKBZ7l9bsgaAlkToztRmTEV9s4
        vMaK3fh6y6ykIzNVyCjQRcnIxpBMxU6Nj6NC+Wj762Hs7CBJikC1dpZ0RLu2mt0GZ86Xlk
        WbxL0IZ/llCu2R+kDhAuieIYaK1pUlI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-FpMlv3VaPOW1LfK_QsZGoA-1; Wed, 23 Sep 2020 23:25:38 -0400
X-MC-Unique: FpMlv3VaPOW1LfK_QsZGoA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F51781CAFC;
        Thu, 24 Sep 2020 03:25:36 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70FFD3782;
        Thu, 24 Sep 2020 03:25:24 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 20/24] vdpa_sim: advertise VIRTIO_NET_F_MTU
Date:   Thu, 24 Sep 2020 11:21:21 +0800
Message-Id: <20200924032125.18619-21-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index d1764a64578d..4b2d0d3fbc87 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -61,7 +61,8 @@ struct vdpasim_virtqueue {
 
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
-			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
+			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			      (1ULL << VIRTIO_NET_F_MTU);
 
 /* State of each vdpasim device */
 struct vdpasim {
-- 
2.20.1

