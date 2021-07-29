Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7E3D9EB0
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhG2HhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhG2Hgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:36:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CB5C061757
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l19so9141630pjz.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=79+lwfgqPqTMCDJYOtelsxZhwWsCxwv7dGGvPGe+0Sw=;
        b=pht7EHvBPEmalFMQJxnA5uITGsCuOlxP9Y280Ur4c4Xr3lJdEeqiDYxP7TC7vQPgGd
         I/ZPYxIAF7wX+D7ibW2+QAbkf4ckwDUGvyyRhT83wHCsspVChvqBgO1K/tQZaoBTt9Yp
         Lir6sHtO0AUKIhh8vlXiMiD+sbirh9E/DVJcXMoijXcC4aQJapQYNS+qNggApM9o0DIi
         ZzEoPv6irKFSlf6epkzfwm9d0JWIMWZMQhLEIbRJUy/HXVHCsfR9gQAfB/8EirRwTMsF
         uRKiOnqoMqV2cLI/WjkPsIhOBs4mwx41zQl+qu/lOvaz0BIStwAPZwrefnhImIRH+0MY
         YaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79+lwfgqPqTMCDJYOtelsxZhwWsCxwv7dGGvPGe+0Sw=;
        b=s5FFBKiyagTUoRxRRRONGHOEYlA8l/Mc6gKboZBl64qR1q9ctyYBO4wUI9FCaQJHqe
         IQ+NHxdTlEG2GIzi3NkcLWEE+LBhViUzJ4D4gI5ItJKjP4JOcfsCJOvgwKiUljzTHOeu
         naLJqLbNieH3ZJ/QTmZgk0oOg0ZyKIk1sDnIpzmN0yJSIjP+2ALuSTG47MeUdDprA4n0
         V8FxQ9aOQHrgb4i0Fl41e/msPpP0nj2htccyH5uqGXOryjCf8eE0s/gTlHIIG5UVVwN9
         EeLLeEyohdj2UhuoVT+MlYmY6c3zFi+BwO8aoR0xEPRqXVd7W+hrJCyIqxp7nA8h/RmK
         HZXg==
X-Gm-Message-State: AOAM530CiXD5OMkkRh1KZUKlAIOpEGcfBHV0bne2mVTem7WRe0cqkmO6
        BRBePMWDz0gSff+st2YV6Tbz
X-Google-Smtp-Source: ABdhPJwd6fqL59b6zB2Y1X6Xa6fhnvr9Evz97aQU4N4q/6V8MSENkC+yj5nWiVm8Rzev8LmszMzr1w==
X-Received: by 2002:a05:6a00:2:b029:32e:3ef0:770a with SMTP id h2-20020a056a000002b029032e3ef0770amr3859510pfk.8.1627544204478;
        Thu, 29 Jul 2021 00:36:44 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id ge21sm2237949pjb.55.2021.07.29.00.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:43 -0700 (PDT)
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
Subject: [PATCH v10 09/17] virtio-vdpa: Handle the failure of vdpa_reset()
Date:   Thu, 29 Jul 2021 15:34:55 +0800
Message-Id: <20210729073503.187-10-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vpda_reset() may fail now. This adds check to its return
value and fail the virtio_vdpa_reset().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio_vdpa.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 3e666f70e829..ebbd8471bbee 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -101,9 +101,7 @@ static int virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	vdpa_reset(vdpa);
-
-	return 0;
+	return vdpa_reset(vdpa);
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
-- 
2.11.0

