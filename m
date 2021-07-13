Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E7E3C6C6F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhGMIuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbhGMIuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:50:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F0AC0613EF
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x16so18887871pfa.13
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=duCG4IP24crSQcX/Hc+dmtkejh6EvJA1HRc0A4ISBjM=;
        b=jhEklg55ncTgryEBNVp2R8QmbT0mSSZ9Jbx/vRWE7VCj3bWE2z2dIOjal3v7V87F+w
         KXfQDIBXqy11zkoXvndvUbGlVPDEiXSl+fAQR2u1kh3sE66g/ycHI3ytjUjkQxSBJH/g
         AZxHQhTacxVYFFdIyyjgze0ilCXCS/jDuumV2MlbMyoRI0UfccSBvPIQYWOGLs4/8MSa
         /LKjYT2XeUKg2HCwHW37u9JbUA9UywMRQY5Oh21L5F5yKxW5N31AISgPj+ldmzvcwtCe
         E1Q/Vl13UyWPfsgrfUc5jX89w8ETwn8bjbTAF+M6GLaU7IxUmlm0UT8g4Vzjxqr6Yp/e
         wF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=duCG4IP24crSQcX/Hc+dmtkejh6EvJA1HRc0A4ISBjM=;
        b=B6X8GJhy7XOoaH85FNa6DCrbWetGkwxPalH1Az+AliylvmNYYUWa2181eMg9yQdlqX
         8TBmz2YA4R73Y93OD6zGDHBfxV/to0Nyul9ww/BTErAGCVTpavTjqh6jSpE7bh8vIYE8
         hIOg4bqhTjechDfPKsDjnnI4v3uYdWgJGaxdY7ZGgduSEPromo6TPjb2ZZ0gR7vsTceZ
         4IjfV3zrb1zISKCZ+JvJZJyQgCmfmZE7531vMKBCEndWEkLMQzFrS0s/1bPKmcWNq+7n
         NsswKHep1l0tDgdJlBBbDganXm2h9haCvW7nxjay+f9KCseECpppqNdaiulQTm3dAbZz
         ncPw==
X-Gm-Message-State: AOAM531V/Zt8OcN5KU8z7sJ9+ZmC0DAQ4wcRqEwgmMUTQegXalWcQKdX
        vYasXYYvXPwto6hWM9sY+Brq
X-Google-Smtp-Source: ABdhPJzUKtRs1AySsyiLpLF85eJbibtFpTyQ7lV4V3lGutdi9feZAXM7KOxrD2p11DbuRgxCB1AMmQ==
X-Received: by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id e22-20020a62ee160000b02902feffcf775amr3339041pfi.59.1626166065181;
        Tue, 13 Jul 2021 01:47:45 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id b22sm17658102pfi.181.2021.07.13.01.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:44 -0700 (PDT)
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
Subject: [PATCH v9 06/17] vhost-vdpa: Handle the failure of vdpa_reset()
Date:   Tue, 13 Jul 2021 16:46:45 +0800
Message-Id: <20210713084656.232-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vdpa_reset() may fail now. This adds check to its return
value and fail the vhost_vdpa_open().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62b6d911c57d..8615756306ec 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -116,12 +116,13 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 }
 
-static void vhost_vdpa_reset(struct vhost_vdpa *v)
+static int vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
-	vdpa_reset(vdpa);
 	v->in_batch = 0;
+
+	return vdpa_reset(vdpa);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -871,7 +872,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		return -EBUSY;
 
 	nvqs = v->nvqs;
-	vhost_vdpa_reset(v);
+	r = vhost_vdpa_reset(v);
+	if (r)
+		goto err;
 
 	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
-- 
2.11.0

