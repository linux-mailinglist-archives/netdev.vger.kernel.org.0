Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92A93D9EB7
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhG2HhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhG2Hgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:36:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34092C0617A1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so5926487plr.11
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=X98+TJ5q20fVVP7OZ9n9veXNRWtBaNyF7u49KUNkAM08u5ecR/X2DKDwo1Z3kXSnog
         AkIvxsuc6X/gsU10vyjL8G4S48EXGasvxyUvBWTz/n2nYXpvsiABp2BBpcAxzMKlc9JC
         tZHpDQJRdciKCGBbNBWxs2uv+1TVCUY4XPFmsIqsbkO+YVLO26aR4jONl8t2P20X7aov
         2MxYGwbbV4OrGtS6am9b0pJn4afscft59CPUq0kj0zGDJRQnHkTNskX287DpmE2RFfUV
         TaJlG/0ITl45C5ABu2t/JY8+gPqs+Fpn2oPnqG672GSOWOJqgTtAC/jfy64aWdz90uPG
         HNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=I46a6cRstwXLpedp79iK8FBzoJ2VpeQGssKZLxQY0dO74x8JuKmUcop9XgHZg9oI7f
         73TPeBMdrGRSGjokQiPtP1xMRpuAA4SqfcinFO3WT11M4KjlNzo6DrSWLlaL4CSAFHyV
         FrqQnrJ+Id+IaCjUe5/+sPQ5Va91gNAy0LH4zu4MZBrb50EOWvxGB4SbUndcHLWzEcEN
         5Li9x/ll0+SJeoDFGePq62QUhajn4XkQ6XD4Y3FN0IgEsWt/UP5N3TkbNanEHg53aKaO
         uYCVnlHb8wbAHqnDdclyYXoLiuKJFPdge6uWkvWOMQjF+fSz4CYoPRCnpnU28HlmPT2b
         09NQ==
X-Gm-Message-State: AOAM531w8GgvNmM3vABUhuwUbzDVz4Agy0eIbLncjr5UX9F52A5zoMgP
        G40WYQnAdW7yyVISbWCniVzo
X-Google-Smtp-Source: ABdhPJwjSVfLNS2GDfIx/eWaUI7/WEDOXCiXXfI318zMm7E6oJfs9FrWN4b/fDb28gHcKZEreTjMkA==
X-Received: by 2002:a17:90a:5101:: with SMTP id t1mr13696042pjh.107.1627544210785;
        Thu, 29 Jul 2021 00:36:50 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id s3sm2487674pfk.61.2021.07.29.00.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:50 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 10/17] virtio: Handle device reset failure in register_virtio_device()
Date:   Thu, 29 Jul 2021 15:34:56 +0800
Message-Id: <20210729073503.187-11-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device reset may fail in virtio-vdpa case now, so add checks to
its return value and fail the register_virtio_device().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a15beb6b593b..8df75425fb43 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
-	dev->config->reset(dev);
+	err = dev->config->reset(dev);
+	if (err)
+		goto err_reset;
 
 	/* Acknowledge that we've seen the device. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
@@ -362,10 +364,13 @@ int register_virtio_device(struct virtio_device *dev)
 	 */
 	err = device_add(&dev->dev);
 	if (err)
-		ida_simple_remove(&virtio_index_ida, dev->index);
-out:
-	if (err)
-		virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+		goto err_add;
+
+	return 0;
+err_add:
+	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+err_reset:
+	ida_simple_remove(&virtio_index_ida, dev->index);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_virtio_device);
-- 
2.11.0

