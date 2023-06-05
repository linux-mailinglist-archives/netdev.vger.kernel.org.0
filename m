Return-Path: <netdev+bounces-7969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE3A72242D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA4B01C20B2A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444AD168C1;
	Mon,  5 Jun 2023 11:07:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C5A154BC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:07:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82398FF
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685963224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kbCiwyqVxBGMkLGPRwYBBYz8NZcSuztWZwPhXZOo2A4=;
	b=GYfZjarLxYnHHDi7KyXv1i1bQanf/G4IzQTQ5Ab1y9Dts6l2Q94QxKc4YFDrV/7Ur+m552
	GmVAQ4vUyBzW1ju3Q193xosCCdf7OeUZiAeVSJWvs7C2n5aAu7yBB+mhKNJ+GUMLfxoCAp
	5u1UXarKLtmt7wTyWpftDR88ZBkrTLI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-485Aq_LqOzqlq1gCYwZiVg-1; Mon, 05 Jun 2023 07:07:03 -0400
X-MC-Unique: 485Aq_LqOzqlq1gCYwZiVg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f739a73ba4so4665875e9.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 04:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685963207; x=1688555207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbCiwyqVxBGMkLGPRwYBBYz8NZcSuztWZwPhXZOo2A4=;
        b=NAVWn2P+FGIzyfJP952La/zLvd3POUBQrRM8YEyKXWozToqNv264yPuMRabtY0Igx/
         57AWQXiAytG/QZi1kf+CP9pKV5TznTomBKDY2ITyU/E5k3dcngceBp+bNFHl7Fmi5w3B
         F2sWmSFvuOo2c/AjWefgVLfGvahtlx8Q5CBNW8YgG3pqgixJFf5i/51VU/ZsKrG1mgJQ
         EQRPJS2OkET+dFGJznVIXrBDtqT7F2SjWPU3++DxU+S1ec8GVviE2XOLHuCPrmvM0tNz
         kViOXOEXCKr3zXiKdJdVGXdhNj2yDg/VPhyNB1Fk0kgaK8pvg1QIwvfdymvvVcA5qDrJ
         hTVQ==
X-Gm-Message-State: AC+VfDxCTYrxecfuw1swSnhad/CHSRrYbk4FG2Zx7rNr39dWzQV6nTzn
	EiEmzu35bl8aaCQ/Fgz6Kj1HYyVNI35kDAmKPAhOssV1pyUlSucUDi51Pd6D5W43PEMMqrgH37F
	NePxBBP7ainw0Dw+S
X-Received: by 2002:a05:600c:2318:b0:3f5:fb97:eafe with SMTP id 24-20020a05600c231800b003f5fb97eafemr6359798wmo.30.1685963207564;
        Mon, 05 Jun 2023 04:06:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ53W9xn9TGBpaX8/z08DhNRppPkhtiy/6dFg/34pYnUjNp28hkX6GPjzKGWmEUJ3a7qTnjMfQ==
X-Received: by 2002:a05:600c:2318:b0:3f5:fb97:eafe with SMTP id 24-20020a05600c231800b003f5fb97eafemr6359787wmo.30.1685963207240;
        Mon, 05 Jun 2023 04:06:47 -0700 (PDT)
Received: from step1.redhat.com ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id s5-20020a5d4245000000b0030903d44dbcsm9407323wrr.33.2023.06.05.04.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 04:06:46 -0700 (PDT)
From: Stefano Garzarella <sgarzare@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Date: Mon,  5 Jun 2023 13:06:44 +0200
Message-Id: <20230605110644.151211-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
don't support packed virtqueue well yet, so let's filter the
VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().

This way, even if the device supports it, we don't risk it being
negotiated, then the VMM is unable to set the vring state properly.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
    better PACKED support" series [1] and backported in stable branches.
    
    We can revert it when we are sure that everything is working with
    packed virtqueues.
    
    Thanks,
    Stefano
    
    [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/

 drivers/vhost/vdpa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 8c1aefc865f0..ac2152135b23 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 
 	features = ops->get_device_features(vdpa);
 
+	/*
+	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
+	 * packed virtqueue well yet, so let's filter the feature for now.
+	 */
+	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
+
 	if (copy_to_user(featurep, &features, sizeof(features)))
 		return -EFAULT;
 

base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.40.1


