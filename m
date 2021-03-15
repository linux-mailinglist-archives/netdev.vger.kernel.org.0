Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55733AB15
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhCOFiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhCOFiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 01:38:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43DAC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so13729705pjc.2
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EwpfT4N+OvVlLx64Zz6EFx++RG+spKqj79bcGdpdHNo=;
        b=IaLsea4Qapq24mtt06XRRqn77JxIdZFz5G+/ZPPDmRS64B/Xy2AGEz0qobHDLz8xfe
         BZpZgwCy9nFn0d7KEzmZiXvBz/AWcBhxpdmIhkFmbGutN+kecLaoxO5nFt3I8XseBpCj
         pQ/LgiaiYqJW1I2Ns1VkhijJsPlhNyHmTcRdXmUGkXadCRRZ9dKakoc9y+5ZxWXGYBX4
         wej/YpyCk2M+mM3i3PQSGf/8lEZR9jTFoZ5imCYsnksDgmtrnGI5c+6jSXvhlXrNLgKD
         wnibXBEXgWgS+dLgtJxMgVqWxNCVm4Mn52K7q+51Sw2Thj7ZrqO+/lVg6e/ExQezhZiP
         cnCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwpfT4N+OvVlLx64Zz6EFx++RG+spKqj79bcGdpdHNo=;
        b=E/XgqnpYsYu8GNpFXKRD4o+6BTS+l+bGzbMz0mjGVRJGfPPNtSX1YLN+KLKQ7JGGVU
         NgB4tuveSHapA/K4Y14a8DGtw9MZrVNVgBumpF2sO7VJDB3VKC7S86b246sG1G8jAFCK
         +P/lKie2aDeoPAgG08eAY8ZLFY5PXrD7KH7laz0Xc/jT0x0lbSiDgL3CmDUuYvJMRBwz
         ZMfdlTJvDeQUfdbmtSASDGPdtx5dmBQJ46rtKeltLQHj6B3LINC6/+5nKNR02dSzEzHO
         xkmk0oTxHrgZxF/i4wla7h7PFCr24vxxzK7i+o/sgLhsy1xx7/bayD2PYsmLrSyN32MF
         +oPg==
X-Gm-Message-State: AOAM5328W8l8bZHimm8lKLjQ+w7y9kFCcyKND1ddunMJwfGx2/mJ/bjw
        GApCXXZxHPx0o3H4fYjpCxv8
X-Google-Smtp-Source: ABdhPJyrl/g0uemO0TIBbEB3y4rgqF1KLHEIEOQZKdoqnVu3n9aZkgI7tttjndhnEN+STq1za8FvEA==
X-Received: by 2002:a17:90a:d903:: with SMTP id c3mr10967111pjv.27.1615786681561;
        Sun, 14 Mar 2021 22:38:01 -0700 (PDT)
Received: from localhost ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id f11sm5475738pga.34.2021.03.14.22.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 22:38:01 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 03/11] vhost-vdpa: protect concurrent access to vhost device iotlb
Date:   Mon, 15 Mar 2021 13:37:13 +0800
Message-Id: <20210315053721.189-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315053721.189-1-xieyongji@bytedance.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use vhost_dev->mutex to protect vhost device iotlb from
concurrent access.

Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index cb14c66eb2ec..3f7175c2ac24 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -719,9 +719,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
+	mutex_lock(&dev->mutex);
+
 	r = vhost_dev_check_owner(dev);
 	if (r)
-		return r;
+		goto unlock;
 
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
@@ -742,6 +744,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		r = -EINVAL;
 		break;
 	}
+unlock:
+	mutex_unlock(&dev->mutex);
 
 	return r;
 }
-- 
2.11.0

