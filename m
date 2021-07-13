Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606F63C6C72
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhGMIum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbhGMIui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:50:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D178C0613EE
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p9so11712591pjl.3
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EjR09xl/s+Zlx+uuKDPZmG38VH07hTVA8QsJdDWGoMM=;
        b=0VNyBgTY7yxOchYvhwFlmk9k2udQOWCUUMpM8nhTR7Bk4VZtxT4ZI8f98TzkKevJk5
         dYLlzzFa5wsVMHn13aVEoDurgoQ/B97Q+JhhlkS6OR7p2ukAzqbqaIA6heoBr2mvaW2u
         LWKNdvE1D06+3O4nambhTYRGp9OSBjhVsvc+sS1fRJwI0tKIi1LcEHcgiIroKNvO+Tk9
         Y9lhU4YFRflDnAO1ytSChBfqW/0Xf2PueeNxk3B7oGv7K2ZJPXdQOsXRxJSUBz/FAPuC
         yq81H3J4EOgBB4At7Bf6X83H6Bjq4AOEWbBPDSkXpZtUwXWHYKXE5SKnGfz6IjR2oj55
         XrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EjR09xl/s+Zlx+uuKDPZmG38VH07hTVA8QsJdDWGoMM=;
        b=emmCio/EAEBs3SE1D2z/lXJsSfdUcNiQiTxhyCDhPHCF4w/JhNwNGDXLZojOcNfsuv
         3gEejXrRAd6AwYoqKj49usdsnLto+csYtbsyj4nkrXspiDWcbk4BJKp8I1S1poPqdlCp
         SuNzBua82mpMjeFE3X/YfUxDZjRHkvEReQl4Rmiyjm1qEqdijrplRzUk/XExq3RNvMQU
         O9stZaQ86YicwRg5cwCkNT24AUyjtT/jK7eXOgYSSnKs3tMuh6sfkIKBP5wy3LmetR+f
         a0LEyRnkLW5TTKXutHU4F2a72CSChVDkvNi7MPUQIZtvN8wAT7FUhQPDFFk2ZPtJtSkG
         8Ccw==
X-Gm-Message-State: AOAM530PcUSTH4ZdyAMwNd+ExaHSAk8AO3OFIIHXvmgBlOflkeYdk54A
        cCBzxQWXJwAsNtx+NbX0gwYp
X-Google-Smtp-Source: ABdhPJw5LSlu0ju1WyptJVUqPCDp3E+vXWICCBRXlUH6oKTubBRS+RfF2LpFzJEBJMPewe5KBLVzVw==
X-Received: by 2002:a17:902:7610:b029:12b:f9f:727 with SMTP id k16-20020a1709027610b029012b0f9f0727mr2734371pll.65.1626166068835;
        Tue, 13 Jul 2021 01:47:48 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id i12sm9336715pjj.9.2021.07.13.01.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:48 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 07/17] virtio: Don't set FAILED status bit on device index allocation failure
Date:   Tue, 13 Jul 2021 16:46:46 +0800
Message-Id: <20210713084656.232-8-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to set FAILED status bit on device index allocation
failure since the device initialization hasn't been started yet.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..a15beb6b593b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device *dev)
 	/* Assign a unique device index and hence name. */
 	err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out;
+		return err;
 
 	dev->index = err;
 	dev_set_name(&dev->dev, "virtio%u", dev->index);
-- 
2.11.0

