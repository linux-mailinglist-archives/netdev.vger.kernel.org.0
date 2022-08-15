Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A0594E6F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiHPCDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiHPCCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36764220BA9
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=EIO8t93P3kfXNAsBT/04iFY8+UDi+h+6Ja1sB+Codqfa5HvX60m5BJW3l34R0YGtIlKVfo
        44LMM2lM2id6AiARmVEC3OasTe27qqsrgbCNthiCQDJRhv6zJbP+ktaWxKBaQkphe6vzex
        OsckFOLEsycEeA64aaZafE+LqOVi64w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-7R2ywlGVOu6b-l6fe0WGbw-1; Mon, 15 Aug 2022 17:53:48 -0400
X-MC-Unique: 7R2ywlGVOu6b-l6fe0WGbw-1
Received: by mail-wm1-f70.google.com with SMTP id b16-20020a05600c4e1000b003a5a47762c3so4046551wmq.9
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=TXO8L8CdCjus/SrmhEUacd3jbFNYmTD6P8cBPhVCES0wl53ebopowsZcHiNHLdUmts
         pQv9eVgTDnR/jonngC609YamM/tWF9A4rYMCV8YWapkvVVrfRhThkHe2FNxEo2uK6J9s
         sMgz1P2SIibT3JjpzIljyRbj/C+qJyAELdyHVZkF1+JQKLlz77zxgcS3fIC5CAlmr4Yu
         JXD+j2YFPxqSxsT2wIKGq5zuE7TJC68EC6PTyH50KOFnmFdPghGyrRX7whAp5/0h+ObL
         rbbHXTNowQNUDsEAO7E2LCnYk9yeXhGS8vYwcjkxXZyk4V3Y2HscaDsH8yOTCbZ83hYP
         UpBA==
X-Gm-Message-State: ACgBeo1AbY/0QsYh799fJ6QQK3V9iOSzAnlaVdN2vXk20g0LJwGW3WKh
        lpLMSa+fXZxXXMWaoEDG69jpPYb3Qe3mODljpe4TI5U3hj17f0FaCQhPaFzJfjO1ay22Kei3rai
        G+evZzub24W91Deiq
X-Received: by 2002:a05:600c:ad4:b0:3a5:50b2:f991 with SMTP id c20-20020a05600c0ad400b003a550b2f991mr16731035wmr.146.1660600426184;
        Mon, 15 Aug 2022 14:53:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7WhVEK8u+bWBQ+vsIP1p2ogF6bjbQsW8dmESOECqvboXglS7PHGAZ3CszZnuGHypllX9oYGw==
X-Received: by 2002:a05:600c:ad4:b0:3a5:50b2:f991 with SMTP id c20-20020a05600c0ad400b003a550b2f991mr16731025wmr.146.1660600425942;
        Mon, 15 Aug 2022 14:53:45 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id n32-20020a05600c502000b003a2d47d3051sm13154371wmr.41.2022.08.15.14.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:53:45 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:53:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 3/5] virtio-mmio: Revert "virtio_mmio: support the arg
 sizes of find_vqs()"
Message-ID: <20220815215251.154451-6-mst@redhat.com>
References: <20220815215251.154451-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215251.154451-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fbed86abba6e0472d98079790e58060e4332608a.
The API is now unused, let's not carry dead code around.

Fixes: fbed86abba6e ("virtio_mmio: support the arg sizes of find_vqs()")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index c492a57531c6..dfcecfd7aba1 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -360,7 +360,7 @@ static void vm_synchronize_cbs(struct virtio_device *vdev)
 
 static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int index,
 				  void (*callback)(struct virtqueue *vq),
-				  const char *name, u32 size, bool ctx)
+				  const char *name, bool ctx)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	struct virtio_mmio_vq_info *info;
@@ -395,11 +395,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		goto error_new_virtqueue;
 	}
 
-	if (!size || size > num)
-		size = num;
-
 	/* Create the vring */
-	vq = vring_create_virtqueue(index, size, VIRTIO_MMIO_VRING_ALIGN, vdev,
+	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
 				 true, true, ctx, vm_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
@@ -503,7 +500,6 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		}
 
 		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     sizes ? sizes[i] : 0,
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			vm_del_vqs(vdev);
-- 
MST

