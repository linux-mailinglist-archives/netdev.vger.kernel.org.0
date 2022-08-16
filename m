Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3805954A3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiHPILK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiHPIKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ECFB67155
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660628202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=T7r0ntMozADw9boET5C48DFEG1iBLiCe/T+QBh56Jq2O3Hj09wfSrnpFT2JrrDalqerNXj
        8q9emd/jSFa+lhxIzUK/VPipxm/iSshob/n3BUelF6lugpZj/9/JIkg5m/kLHiqshvmCoK
        nFid0EW77GqAvPIG/7Mw6emTaXP+/2E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-250-B052lTNZMLy91hWismUhFw-1; Tue, 16 Aug 2022 01:36:38 -0400
X-MC-Unique: B052lTNZMLy91hWismUhFw-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfa151000000b00224f8e2a2edso1139964wrr.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=zGVEh9l2QuhRogt/N27CAwnMhR3ltOXBYFwNISCKZGPzYTrmqssFFMhUUR/556PCYr
         mQGItCfKFW31/Akr3oy6ZWUL5yFHnSQhWHTExuqKwjHk+CS81A1a7GKTN+k5iOwGP4o3
         mX7rgW/2SNr9XccRZi2UsdUBGCo+ssdXIo9NeOVI+3lIIsL5zbV69QRxWZa+iHL6oucK
         tG+H18EDbBv5hUa5Q45+3Ybnp5JbP6MiJVzDKT/Knq6xrs9nuxWTxW4+AA7DUU5osyjx
         A45h102D1KlR+lQhTFKjMrsY00q2wRsCYCtctz+MaUYkklgubELGVmse/U6YRHqWg1Fs
         /P2w==
X-Gm-Message-State: ACgBeo046+C/VYmb/NyBVbWJQVLUxLfgEeaJKKSBWpHKu7PcHMyH/O4m
        iynr9P4SxtfFsQSt9/I8VdQW6D09ko7DUjbS79M3sauJwlSHIArCW1lo8JLsX7zG+fmc65jzGEa
        UXdHtBkcm+Egp7OXc
X-Received: by 2002:a5d:6312:0:b0:220:6820:57d7 with SMTP id i18-20020a5d6312000000b00220682057d7mr10333256wru.8.1660628195656;
        Mon, 15 Aug 2022 22:36:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5lfJNXkB52mr103dHeF1YNUqGQn4R8ZmPcZt7Bv3gQF4wEpKRHrZVkPc9XrO/DSv/ceTxJOA==
X-Received: by 2002:a5d:6312:0:b0:220:6820:57d7 with SMTP id i18-20020a5d6312000000b00220682057d7mr10333235wru.8.1660628195428;
        Mon, 15 Aug 2022 22:36:35 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id ba11-20020a0560001c0b00b002235eb9d200sm9225278wrb.10.2022.08.15.22.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 22:36:34 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:36:32 -0400
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
Subject: [PATCH v4 3/6] virtio-mmio: Revert "virtio_mmio: support the arg
 sizes of find_vqs()"
Message-ID: <20220816053602.173815-4-mst@redhat.com>
References: <20220816053602.173815-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053602.173815-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

