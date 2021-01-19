Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A412FB04E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbhASFXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388977AbhASFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:06:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D19C061786
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l23so11371576pjg.1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rk3Zr0O5adDtcKDEPjgvkHO0z8gks3DD0R510gfQviI=;
        b=znqS6hnVz6dahC+EHSdB87OaGtNUKXPEDPbv9BRfgHji1a4LjR1Je/PDQuHlonctZF
         BP3HHtdI7HAmXp2j9UIXS71yX5sjsnmx3oWoNSBurhnSzFh3+uNgFfSimf5NJppJkcBE
         lffuKp+ndrCAqjbI1YojLoCRIRhYAi2iNTIoZhhAWPGuJHRAd4u4+V3Z4hADLjaCZAUp
         KBNTvPpMIAhbPnbyCy1TUIwX9PhLzsLsbSG8I7cDhr7s+6FB3q+5AAr26cU+sPyWpScL
         Ks+Cl6Ua+C+cHunJTJzSGIJRu0qpdaRLAnOFPWvP0p1uIY81jddpKM3iBbLcHN5FMt/T
         1XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rk3Zr0O5adDtcKDEPjgvkHO0z8gks3DD0R510gfQviI=;
        b=JPiu6Vi9n+6H7v4e4iHzmhs7UHM3AwIolNYIko2wGvBAbHl2R7cWE+KdJQ0mQ+sCtc
         b/pb/YvWczjjcMNe5Kdh4nsf3QC0Ve4Itxv6MF21IOEYX/VvM0Lzi8gSNyVsoOifax/R
         ZVthj4CZWcpyK2X4Ab4imRcEg4f7P6e7On/nb2N0uUkf7N/hMeIu8a00hzxfkPt9Y6LX
         RWkIvR0P6jSkBXF8rqZcnapITSO9EfMvXe/y7zd8nqettVLmUDganeN2nJN0qIIdkuKj
         fi5+Q2ZTUJ8FarwYJDMkf6LExSvL+Y0JDAVwvinf7AQ5sbR0H/ujgjKiYM6fTTEa7wc5
         TROA==
X-Gm-Message-State: AOAM530t3moyLGU/r6m9FyQMOv5swa5buOxbYd+LrcewsC2JIODArDxn
        z62Zc/QR9PHS4fUAGcrPS/E1
X-Google-Smtp-Source: ABdhPJwaZBIZPAe2wVJ2M5FYpu2+mBkdly7m6W4Agcx3j+WJGeyF0X6mqSRoroO3c0uR8pMGJhBAcw==
X-Received: by 2002:a17:902:e885:b029:de:abac:f9c4 with SMTP id w5-20020a170902e885b02900deabacf9c4mr2753168plg.30.1611032685396;
        Mon, 18 Jan 2021 21:04:45 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id d2sm1089669pjd.29.2021.01.18.21.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:44 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 03/11] vdpa: Remove the restriction that only supports virtio-net devices
Date:   Tue, 19 Jan 2021 12:59:12 +0800
Message-Id: <20210119045920.447-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With VDUSE, we should be able to support all kinds of virtio devices.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 29ed4173f04e..448be7875b6d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -22,6 +22,7 @@
 #include <linux/nospec.h>
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
+#include <linux/virtio_blk.h>
 
 #include "vhost.h"
 
@@ -185,26 +186,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	return 0;
 }
 
-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
-				      struct vhost_vdpa_config *c)
-{
-	long size = 0;
-
-	switch (v->virtio_id) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	}
-
-	if (c->len == 0)
-		return -EINVAL;
-
-	if (c->len > size - c->off)
-		return -E2BIG;
-
-	return 0;
-}
-
 static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
@@ -215,7 +196,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
@@ -243,7 +224,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
@@ -1025,10 +1006,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
-	/* Currently, we only accept the network devices. */
-	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
-		return -ENOTSUPP;
-
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
-- 
2.11.0

