Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F177B4BE8D5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356744AbiBULtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:49:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiBULtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:49:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 398AC1EEE6
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 03:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645444161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=12CjzIfm9u48VcTin9bYn/mbYSt9Byr6lQhm+jL2Tdg=;
        b=ghOanVcIIx1ygXHpL+lBeLbLRsEqPrrhybxOerlaygsFE7K7D64LfQTQYsj6ZImacVYL48
        CByO/0JDZjxim7GudoDBmOu1Ue3adE97t5jCFzOTdwLaUUL6Yyefdf6H5QgFi4/HxsfKJR
        i4r/wwgdIOMT3i7bJVwYzNTWUHspEfc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-A5RI6GxVOHWo2wx1F3TCeg-1; Mon, 21 Feb 2022 06:49:20 -0500
X-MC-Unique: A5RI6GxVOHWo2wx1F3TCeg-1
Received: by mail-wm1-f71.google.com with SMTP id h82-20020a1c2155000000b003552c13626cso7931190wmh.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 03:49:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=12CjzIfm9u48VcTin9bYn/mbYSt9Byr6lQhm+jL2Tdg=;
        b=dLDnSbCRAS3iChUb/1FvgtM+TeJJsW1HkR+IiOZkivRo27eL5+qtX/eSHgoUglLq4k
         WukSbgAVqkfiQxAn5u9pHK1m1cqfXBukUu4ECfk60SYiWrMsFUgnA7L3lDsQ9GlLRWhW
         SZLmJ921pwAbMxpa+5LHwecNuaTT+lAulEUylf+TqWOj+WLXn0ps48Yev/ZmrWcFI1Ta
         dFOpTTroEICS0isHoLMdMQDOQLp7Ej9mGCaMWDOyj38Snxuq1OGYj4Vq9b8MaV8XrgUJ
         U9CLKoRQDAx2jIyu9hWJwxWQM6yKw6rFUJhWOAAD3YnSWEMNN76epbLNbcrbS9bXFoSv
         pwww==
X-Gm-Message-State: AOAM532AGfup9Klr1Xd9FchCsHQ8Swd1cIHO98W7E7gYN+ynjCVEfuJc
        m8hoCi6irElgeZ5HolnGmrpaitvA0nuChbrjMfyWTnGC7IiVWHZvlAdaIfsmzJ7noRl6SRysiIW
        9AIdTMGvD2N8t5IwP
X-Received: by 2002:a7b:c844:0:b0:37b:b986:7726 with SMTP id c4-20020a7bc844000000b0037bb9867726mr17401383wml.160.1645444158956;
        Mon, 21 Feb 2022 03:49:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz80NBK4xySdNK92dBVDo686zdoILiLjZ8DrwJxbn6DUuDBzdF93Cfrshx7zCott46Y92HTgQ==
X-Received: by 2002:a7b:c844:0:b0:37b:b986:7726 with SMTP id c4-20020a7bc844000000b0037bb9867726mr17401363wml.160.1645444158689;
        Mon, 21 Feb 2022 03:49:18 -0800 (PST)
Received: from step1.redhat.com (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id o6-20020a05600c338600b0037c322d1425sm7141176wmp.8.2022.02.21.03.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:49:17 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Asias He <asias@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop() while releasing
Date:   Mon, 21 Feb 2022 12:49:16 +0100
Message-Id: <20220221114916.107045-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
ownership. It expects current->mm to be valid.

vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
the user has not done close(), so when we are in do_exit(). In this
case current->mm is invalid and we're releasing the device, so we
should clean it anyway.

Let's check the owner only when vhost_vsock_stop() is called
by an ioctl.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d6ca1c7ad513..f00d2dfd72b7 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 	return ret;
 }
 
-static int vhost_vsock_stop(struct vhost_vsock *vsock)
+static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
 {
 	size_t i;
 	int ret;
 
 	mutex_lock(&vsock->dev.mutex);
 
-	ret = vhost_dev_check_owner(&vsock->dev);
-	if (ret)
-		goto err;
+	if (check_owner) {
+		ret = vhost_dev_check_owner(&vsock->dev);
+		if (ret)
+			goto err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		struct vhost_virtqueue *vq = &vsock->vqs[i];
@@ -753,7 +755,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	 * inefficient.  Room for improvement here. */
 	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
 
-	vhost_vsock_stop(vsock);
+	vhost_vsock_stop(vsock, false);
 	vhost_vsock_flush(vsock);
 	vhost_dev_stop(&vsock->dev);
 
@@ -868,7 +870,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 		if (start)
 			return vhost_vsock_start(vsock);
 		else
-			return vhost_vsock_stop(vsock);
+			return vhost_vsock_stop(vsock, true);
 	case VHOST_GET_FEATURES:
 		features = VHOST_VSOCK_FEATURES;
 		if (copy_to_user(argp, &features, sizeof(features)))
-- 
2.35.1

