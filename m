Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EC1620D70
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiKHKfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiKHKfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:35:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCEB209AA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jnEQ/6uclYdSedN00zhcPF82VnGpN8n10b9g5MbTnn0=;
        b=CVy8Xvpd6yVBllRxXHMwaZkOzymHzFbHcH6mapNZQS5O62Ey4U0Mmo5Rj1gOsyGgXjB9k9
        cJNZl9WvQ2J8mp4tIEltPFPdga97qUKKxexRZPX9jlga75qDq7Zc+OCH1Yf6cRP3noy/fp
        GE6AF5u3m5RVsVfWbIwkz2wanUZR94s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-Q7EIQ-daNp6JkW5iZt__bw-1; Tue, 08 Nov 2022 05:34:43 -0500
X-MC-Unique: Q7EIQ-daNp6JkW5iZt__bw-1
Received: by mail-wm1-f69.google.com with SMTP id bg21-20020a05600c3c9500b003c2acbff422so619460wmb.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnEQ/6uclYdSedN00zhcPF82VnGpN8n10b9g5MbTnn0=;
        b=WY4J2Mj35odypk6FPblXTK6BcG6ggWcsqJpVS+1Xn5mJrB9Kpv6y7iqgGsqjCqkQfV
         4p2IhLwE50fGJdOrV0PgKdFq0ui0CshMLu1xz4EJh2pEhUNx7a/fggA8UUo311DTP5ih
         tXNyTxDn3akc4LG3ttgL6+HgYjvRERAhMMYRFjtuuuvfSXItdaASo4nKH4Aqo13EV0nV
         cAn0f9P5vS0ZHTPMFilokaGkhQvy872ae2v3EV0z+1TW+7d8uB+E0O3p4ye/F6Kn9Qfz
         mEqL39asLd5sFeSUTRGupMres8tXYOFGA1HzDw+7dzdbSY+tXTwkNqZ48FvQS64yEBct
         ETrQ==
X-Gm-Message-State: ACrzQf0C3Q7pX2zEyLi4a3C2Oryq9lqvoyNZUBLvnKAXazzth4ta5DaA
        OieKR+p8Sb1cTp32SSWOb5u8l4yJlVlbBBGQGmijUTeUcSKXYVIXBUGVLrNrb2Ie138NLawMjuE
        Ogo0JEvedXTME3dew
X-Received: by 2002:adf:f303:0:b0:236:d1c0:79dc with SMTP id i3-20020adff303000000b00236d1c079dcmr29615251wro.695.1667903682488;
        Tue, 08 Nov 2022 02:34:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM60F4oRwRyS4YKIr5SpakIIdGyqUKYKutX+9xZI1DBbeFzrSYNiUGX7Pq6GFACc6ESaUV3XiQ==
X-Received: by 2002:adf:f303:0:b0:236:d1c0:79dc with SMTP id i3-20020adff303000000b00236d1c079dcmr29615240wro.695.1667903682285;
        Tue, 08 Nov 2022 02:34:42 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm9632802wrq.88.2022.11.08.02.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:34:41 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 2/2] vhost: fix range used in translate_desc()
Date:   Tue,  8 Nov 2022 11:34:37 +0100
Message-Id: <20221108103437.105327-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108103437.105327-1-sgarzare@redhat.com>
References: <20221108103437.105327-1-sgarzare@redhat.com>
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

vhost_iotlb_itree_first() requires `start` and `last` parameters
to search for a mapping that overlaps the range.

In translate_desc() we cyclically call vhost_iotlb_itree_first(),
incrementing `addr` by the amount already translated, so rightly
we move the `start` parameter passed to vhost_iotlb_itree_first(),
but we should hold the `last` parameter constant.

Let's fix it by saving the `last` parameter value before incrementing
`addr` in the loop.

Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

I'm not sure about the fixes tag. On the one I used this patch should
apply cleanly, but looking at the latest stable (4.9), maybe we should
use

Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")

Suggestions?
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..3c2359570df9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2053,7 +2053,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
 	struct iovec *_iov;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
 
 	while ((u64)len > s) {
@@ -2063,7 +2063,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
+		map = vhost_iotlb_itree_first(umem, addr, last);
 		if (map == NULL || map->start > addr) {
 			if (umem != dev->iotlb) {
 				ret = -EFAULT;
-- 
2.38.1

