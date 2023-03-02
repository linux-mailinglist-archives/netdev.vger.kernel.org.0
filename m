Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC06A812A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCBLfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCBLf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9446E22033
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYIRvQhreJmamPTgF10vjkMAMOhZQaOaX6sUzVAfpfw=;
        b=hQManXAScAKWA8mgFefT9Uv+XU0ZH8HiL2J6k7qE72pVd/cT+KFy5MDd3ttUqAL4aNRLM9
        OHLmtGUnwE8v1YrbAdkK4dILv8AvlxcTjr2i2Lqlgkl4+G0zR09KWgDTWH2OTyBoI+fcuL
        u+KYgUX7mWzqoyosTbdovsMBY49gLdQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-568-k24ugQEEMjC5nn3EclJWTQ-1; Thu, 02 Mar 2023 06:34:35 -0500
X-MC-Unique: k24ugQEEMjC5nn3EclJWTQ-1
Received: by mail-qt1-f198.google.com with SMTP id t22-20020ac86a16000000b003bd1c0f74cfso8283683qtr.20
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYIRvQhreJmamPTgF10vjkMAMOhZQaOaX6sUzVAfpfw=;
        b=Aav/XkqbpcZHIbFfCkP3rmGNn0jblm471x2xWAwsbQDgR46i//moWyIyWO3k0ho41f
         SC56IpNx4uKGASmPJe6gFxf4KPuxhVEDqKv0O+UQrME6F1/8AKXgXcRV516DO/tKi/qN
         /U881+oMKgKXYhw7XLw51C2mkuSLx7vYHR0ciEMS22fCH3Xz+ZksFmHwk1Rhju2Kejll
         wpIUtwD6RxFgP8YGSbMyj7heUliWKglkOC68xsinaPIhd9aVp1xkpOv4tS8KLQr14WSX
         TtB0ZPWRHC+NPueYpS3Y/VuSU6dqeRvGH68LniD6JbRU22sKAVUyTuIsRVIDS0CCPm+Z
         MDKQ==
X-Gm-Message-State: AO0yUKXNMJmhn/l5Zy68ZD2THDwVaaXpUrhnO8DMn29e947D2chRMfGt
        0RRB81RWXeQW2h21dckXo4Om8rUnUlJ0QNBPCU65OPr8PUdA3kS/pRpvZJW8Q2cd0sUntN9Dvyt
        V19u0FTo1zpsvWbFe
X-Received: by 2002:a05:622a:186:b0:3bf:d4c3:365d with SMTP id s6-20020a05622a018600b003bfd4c3365dmr17450755qtw.14.1677756875320;
        Thu, 02 Mar 2023 03:34:35 -0800 (PST)
X-Google-Smtp-Source: AK7set+DEB84vy51k02CcK+JjytuJL+amad7fRxImnJYIv4nCRuUv0xkGiPSLgQZT6Jrlf+7iGe6iA==
X-Received: by 2002:a05:622a:186:b0:3bf:d4c3:365d with SMTP id s6-20020a05622a018600b003bfd4c3365dmr17450741qtw.14.1677756875094;
        Thu, 02 Mar 2023 03:34:35 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o12-20020ac8698c000000b003ba19e53e43sm10084156qtq.25.2023.03.02.03.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:34 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Date:   Thu,  2 Mar 2023 12:34:15 +0100
Message-Id: <20230302113421.174582-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user call VHOST_SET_OWNER ioctl and the vDPA device
has `use_va` set to true, let's call the bind_mm callback.
In this way we can bind the device to the user address space
and directly use the user VA.

The unbind_mm callback is called during the release after
stopping the device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - call the new unbind_mm callback during the release [Jason]
    - avoid to call bind_mm callback after the reset, since the device
      is not detaching it now during the reset

 drivers/vhost/vdpa.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index dc12dbd5b43b..1ab89fccd825 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
 	return vdpa_reset(vdpa);
 }
 
+static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->bind_mm)
+		return 0;
+
+	return ops->bind_mm(vdpa, v->vdev.mm);
+}
+
+static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->unbind_mm)
+		return;
+
+	ops->unbind_mm(vdpa);
+}
+
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -711,6 +733,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
+		if (!r && cmd == VHOST_SET_OWNER) {
+			r = vhost_vdpa_bind_mm(v);
+			if (r) {
+				vhost_dev_reset_owner(&v->vdev, NULL);
+				break;
+			}
+		}
 		if (r == -ENOIOCTLCMD)
 			r = vhost_vdpa_vring_ioctl(v, cmd, argp);
 		break;
@@ -1285,6 +1314,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_unbind_mm(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
-- 
2.39.2

