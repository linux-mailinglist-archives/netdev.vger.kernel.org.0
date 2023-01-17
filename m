Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4266E1E6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjAQPRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjAQPRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172B539CE7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673968594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fw/nFMgEKd6/JOs4Bo38UV7NzYCcuP0Qle+XYJWZ2qI=;
        b=MLe9o75n0n57K+UGD/GbIe8pY5n2vEnm3iqOmaao6ObeiscRwqR2eTRYWB0XLHzZr9fjUr
        cHKMCEG6WR0aGw6t78kvcw7eUOYAdy2D7v38Oxk9qEs6gOXvjvpUihjYi1cQrKS/9i4a3R
        vkygKBOXEdpV8LW2CaLJtqsDxPfSMbk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-XilJkniLMZW6SrZ_Dud_eA-1; Tue, 17 Jan 2023 10:16:32 -0500
X-MC-Unique: XilJkniLMZW6SrZ_Dud_eA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6723814968;
        Tue, 17 Jan 2023 15:15:22 +0000 (UTC)
Received: from qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com (qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com [10.19.240.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 317F44078904;
        Tue, 17 Jan 2023 15:15:22 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     peterx@redhat.com, lvivier@redhat.com
Subject: [PATCH 1/2] vhost: Remove the enabled parameter from vhost_init_device_iotlb
Date:   Tue, 17 Jan 2023 10:15:17 -0500
Message-Id: <20230117151518.44725-2-eric.auger@redhat.com>
In-Reply-To: <20230117151518.44725-1-eric.auger@redhat.com>
References: <20230117151518.44725-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'enabled' parameter is not used by the function. Remove it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c   | 2 +-
 drivers/vhost/vhost.c | 2 +-
 drivers/vhost/vhost.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9af19b0cf3b7..135e23254a26 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1642,7 +1642,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 		goto out_unlock;
 
 	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
-		if (vhost_init_device_iotlb(&n->dev, true))
+		if (vhost_init_device_iotlb(&n->dev))
 			goto out_unlock;
 	}
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bfd2f1f..34458e203716 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1729,7 +1729,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 }
 EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
 
-int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
+int vhost_init_device_iotlb(struct vhost_dev *d)
 {
 	struct vhost_iotlb *niotlb, *oiotlb;
 	int i;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..4bfa10e52297 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -221,7 +221,7 @@ ssize_t vhost_chr_read_iter(struct vhost_dev *dev, struct iov_iter *to,
 			    int noblock);
 ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 			     struct iov_iter *from);
-int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
+int vhost_init_device_iotlb(struct vhost_dev *d);
 
 void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
-- 
2.31.1

