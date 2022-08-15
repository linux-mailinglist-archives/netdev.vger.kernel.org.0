Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B12E59344E
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiHOR4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiHOR4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:56:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880592873F;
        Mon, 15 Aug 2022 10:56:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 130so6945759pfy.6;
        Mon, 15 Aug 2022 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc;
        bh=POGhXHHrShO+5snvawREHYn7DdRXAdPEiDut+UfqJD0=;
        b=TasIyn6wnSKhDedqQAakKj2PD4W9/10Vyl37s+zb0UMobZ/wmkdoU/H2JA9u0QpdEu
         p5EfHGDDmZ3qE1p1PkPcbmEiGRchBkEzqBm0Nu2OtkeqwQ3MLkwxwIDStDv0erGGXbJD
         vmhU/WtyrXbx7ABzKZQYk+1LJ0XMYZlNz4qCqfLijE3R+zo7Hvj+jFedrPbZN78UpG+M
         vP2VFOtJec3kqhex9HrGSKCS2VvuCD6red8xEnd7WKH9LvxFMjiyI3CiCuua6bEjAhr0
         tAd+A5aaPFyiDVRa/+Ed7yVKSRI3C8Xo293R8ok5TdjtEHS0c/h9SbaaydzrRbXcV665
         u+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc;
        bh=POGhXHHrShO+5snvawREHYn7DdRXAdPEiDut+UfqJD0=;
        b=1ZjIGA7hkeO0Bb9p61asaiaStYGxdcti3O89diGsKtOkhqR/LngcGdC5rIw79P2pAa
         zXiWmGn5uaZrmpu2fpbS9Qq9M2pVorcQoZ9LMlHAutXCLX5VIGOi2bq4n+VNvLOniLTw
         3IhSXmPoMbnsD7+vL1eVgo/3K4Cqp8miA9X061Vb1bjCKUpfJ3wMRNJ0ehJcKPgLfERS
         7a9DKNzQoIOuBfI8hpUKr42xSM1WhbfOJcJ3L8847ItyaRDxTtVQKZW8n2zqiRDruqiD
         Sp0/uzqvYTx0NgsjAPMZmhuWaqigW3eIKWxwGKO0BDIwepgm9rPDcX5prQla0Tw/JmEO
         PpvQ==
X-Gm-Message-State: ACgBeo0g/hgaEMtKScq73F2O6Hk0u4Vi5SresdZehpvgVcgnDJUf7vZt
        t/jXQzmocpMg9hKzEHNRSJo=
X-Google-Smtp-Source: AA6agR6NQxRn6TVeJpksDrJwM7uImdLR6FRna64P7wOu9G/+nnSGJqrowCmXWEGx6RthjNMSrckjGg==
X-Received: by 2002:a65:6a49:0:b0:429:88a0:4c04 with SMTP id o9-20020a656a49000000b0042988a04c04mr1887703pgu.566.1660586200956;
        Mon, 15 Aug 2022 10:56:40 -0700 (PDT)
Received: from C02G8BMUMD6R.bytedance.net (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm7299935plg.304.2022.08.15.10.56.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2022 10:56:40 -0700 (PDT)
Sender: Bobby Eshleman <bobbyeshleman@gmail.com>
From:   Bobby Eshleman <bobby.eshleman@gmail.com>
X-Google-Original-From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Date:   Mon, 15 Aug 2022 10:56:07 -0700
Message-Id: <3d1f32c4da81f8a0870e126369ba12bc8c4ad048.1660362668.git.bobby.eshleman@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1660362668.git.bobby.eshleman@bytedance.com>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a feature bit for virtio vsock to support datagrams.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c             | 3 ++-
 include/uapi/linux/virtio_vsock.h | 1 +
 net/vmw_vsock/virtio_transport.c  | 8 ++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index b20ddec2664b..a5d1bdb786fe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -32,7 +32,8 @@
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
 };
 
 enum {
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 64738838bee5..857df3a3a70d 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -40,6 +40,7 @@
 
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
 
 struct virtio_vsock_config {
 	__le64 guest_cid;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index c6212eb38d3c..073314312683 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -35,6 +35,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue *vqs[VSOCK_VQ_MAX];
+	bool has_dgram;
 
 	/* Virtqueue processing is deferred to a workqueue */
 	struct work_struct tx_work;
@@ -709,7 +710,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	}
 
 	vsock->vdev = vdev;
-
 	vsock->rx_buf_nr = 0;
 	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
@@ -726,6 +726,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->has_dgram = true;
+
 	vdev->priv = vsock;
 
 	ret = virtio_vsock_vqs_init(vsock);
@@ -820,7 +823,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_VSOCK_F_SEQPACKET
+	VIRTIO_VSOCK_F_SEQPACKET,
+	VIRTIO_VSOCK_F_DGRAM
 };
 
 static struct virtio_driver virtio_vsock_driver = {
-- 
2.35.1

