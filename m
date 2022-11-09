Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09962286E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiKIK0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiKIK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:26:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC0217AAD
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667989515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XonZz/B2W6BqtiPIn1XQ7dqlSI0WP9PGZyzmQRe2lsc=;
        b=Zm66+uF3sVBCczxY4QxIbu3wMYa/qP6OSuU8ZFH1AP6Sme9s+jaSiD39xcrO+9WL9OUvQv
        v8Jn2hIMwxR336G358pkdYyN8yL/7YfJ5a0wZSliEdHUYkAKhZeuHG40C69es8/KywTNO3
        Xdkz0fFz26filpd0q8dEbaNnwFwVxK8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-5rt0f4DTPAa7jfZgsgXhfg-1; Wed, 09 Nov 2022 05:25:13 -0500
X-MC-Unique: 5rt0f4DTPAa7jfZgsgXhfg-1
Received: by mail-qt1-f198.google.com with SMTP id fb5-20020a05622a480500b003a525d52abcso12225661qtb.10
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 02:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XonZz/B2W6BqtiPIn1XQ7dqlSI0WP9PGZyzmQRe2lsc=;
        b=fucxipuNnaZt47DnlKc95FSaGRkKAHd1zbUJAzhyWzAxXcNP7kXJ0MOh4eBkWEprFE
         L3A+OvBzBVOiZv1o4VDz+9avcMgeT6mjZyWd+haZ2vcV7DwEyC797RNacxHHOb/V4Bbx
         /rES14g8WUB3Eo6DdU8tcEe3uK7AZy+QzKJoflC1YwPeKLVJ6fxq1uNmuzkk217t+m43
         ySBcxcqSzXTHvs6+c18bWhl7SaPcg5rgmX4isNrKeqL46gVEPFvax0sTSQEJnwyjdCRb
         QNLopvTV6DH36Ytf6h0u9H9JeTcgKSLFEhzaeDKTsNW6bF49E4o0IuxQcH78ltPlAmfI
         c+QA==
X-Gm-Message-State: ACrzQf3MpuQbaQcSpvWhYVDAWDN7hlA/yApN0K0BrSgJ3kGD5bkZd0q/
        yHfwkDUEinK45wWcBn9JZjAtT+5rwMijmWwZJVGrxE/O7ImeO1RxEFra9SdUne6sfqhSOPsIUGp
        LBeHz1eCxFqk2oJB6
X-Received: by 2002:a37:8943:0:b0:6fa:a454:c8d2 with SMTP id l64-20020a378943000000b006faa454c8d2mr16840217qkd.534.1667989513373;
        Wed, 09 Nov 2022 02:25:13 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7bgS44r6yW8TpTmUka6iM1lFnyLysINGmhFPYaKUR8f+8FNUgnbq7sR8Utx2EfXdQOWtRelQ==
X-Received: by 2002:a37:8943:0:b0:6fa:a454:c8d2 with SMTP id l64-20020a378943000000b006faa454c8d2mr16840207qkd.534.1667989513122;
        Wed, 09 Nov 2022 02:25:13 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bj10-20020a05620a190a00b006fa313bf185sm10827522qkb.8.2022.11.09.02.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:25:12 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 2/2] vhost: fix range used in translate_desc()
Date:   Wed,  9 Nov 2022 11:25:03 +0100
Message-Id: <20221109102503.18816-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109102503.18816-1-sgarzare@redhat.com>
References: <20221109102503.18816-1-sgarzare@redhat.com>
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

Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- Replaced Fixes tag with the right one [Jason]
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

