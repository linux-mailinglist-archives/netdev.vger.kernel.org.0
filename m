Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BA2E0C2B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgLVOzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbgLVOy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:54:59 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F81C061248
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id f14so1413977pju.4
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1UEYpy3brrmzHosf+pyp3Ev0oeyxtX5ZA7++RYwLUxk=;
        b=D5NeZ7x9TOi/yUZw3xp7qu2qq+Or3ua5HWy/Z2uXVr2+WLGsDsh+jFVr5aEbl1dZCj
         tuYXSzsZq/GiRRQXfDknHdcUw68CnGM8uHTIqoNEW+OGfxgwGXEnZNpm105gCBux5zRx
         w9AxEgACFlYii/vvDdeOHd8SF5hk2u3S/ZrBbA6iOpde7F+D4gHCXABILdLTVDmHYmXH
         eiXGHwdW7kw1p1RhSb+OMR7S7i+8gsIECeHaPY5OTK2fOiyJjsJGr9EdVK0pebF0B9j/
         /q4OpWuQ7NadXBGpduGfOi97CcT/OFNaBDw+7P6COSPwyTfTwvS7LwAQnFd72B/SpWVa
         SLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1UEYpy3brrmzHosf+pyp3Ev0oeyxtX5ZA7++RYwLUxk=;
        b=q7flcVysehtTi0yrmS5frhyDhwuwhRpnJuzOjJrSOyLxVkyl58bT5tvsr8SSMNIJcy
         P+tyaasOUMrhh4k7EHg5DpEdY+GtDUpMABHwkv+vY35vcFVO3Yk37VDITMph2Io3Rh3w
         XOQBR+oO/lRgrKSeJPhWnjFsBjpuqatTY7AOHouTkB+67NpnToiOXpDE2yMbi4WeM7Zp
         RKYplT4qF7kK30WetDEeICS8KoIk4sPUV+f0qJdc62ylBG+5bB06eLnxH/DBYgg2nFS1
         CqvalIdumurPk2q8tUCPDN0h+AfI0HqXFJcPzwvOujnrhriafejbbqj1fKrSFRzt/YDb
         tFfg==
X-Gm-Message-State: AOAM532kVd2ezvM+Cn3SkO3+Ba94cuUZRJqZoNYblU9enrpjGhI/EwqZ
        EjKhjyYX+GsgXhjvFaMa0hRk
X-Google-Smtp-Source: ABdhPJxiPxmyWa+UkgpZQDc/STtBaxADXfOe8GSVoIfBib0q5ZxwEZlDMoSp+1DTeBAkTEjqkhUD2A==
X-Received: by 2002:a17:902:6103:b029:da:c46c:b3d6 with SMTP id t3-20020a1709026103b02900dac46cb3d6mr21153959plj.46.1608648867654;
        Tue, 22 Dec 2020 06:54:27 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id k125sm17686436pga.57.2020.12.22.06.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:54:27 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 12/13] vduse: Add memory shrinker to reclaim bounce pages
Date:   Tue, 22 Dec 2020 22:52:20 +0800
Message-Id: <20201222145221.711-13-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a shrinker to reclaim several pages used by bounce buffer
in order to avoid memory pressures.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index c29b24a7e7e9..1bc2e627c476 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1142,6 +1142,43 @@ static long vduse_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
+static unsigned long vduse_shrink_scan(struct shrinker *shrinker,
+					struct shrink_control *sc)
+{
+	unsigned long freed = 0;
+	struct vduse_dev *dev;
+
+	if (!mutex_trylock(&vduse_lock))
+		return SHRINK_STOP;
+
+	list_for_each_entry(dev, &vduse_devs, list) {
+		if (!dev->domain)
+			continue;
+
+		freed = vduse_domain_reclaim(dev->domain);
+		if (!freed)
+			continue;
+
+		list_move_tail(&dev->list, &vduse_devs);
+		break;
+	}
+	mutex_unlock(&vduse_lock);
+
+	return freed ? freed : SHRINK_STOP;
+}
+
+static unsigned long vduse_shrink_count(struct shrinker *shrink,
+					struct shrink_control *sc)
+{
+	return percpu_counter_read_positive(&vduse_total_bounce_pages);
+}
+
+static struct shrinker vduse_bounce_pages_shrinker = {
+	.count_objects = vduse_shrink_count,
+	.scan_objects = vduse_shrink_scan,
+	.seeks = DEFAULT_SEEKS,
+};
+
 static const struct file_operations vduse_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= vduse_ioctl,
@@ -1292,12 +1329,24 @@ static int vduse_init(void)
 	if (ret)
 		goto err_irqfd;
 
+	ret = vduse_domain_init();
+	if (ret)
+		goto err_domain;
+
+	ret = register_shrinker(&vduse_bounce_pages_shrinker);
+	if (ret)
+		goto err_shrinker;
+
 	ret = vduse_parentdev_init();
 	if (ret)
 		goto err_parentdev;
 
 	return 0;
 err_parentdev:
+	unregister_shrinker(&vduse_bounce_pages_shrinker);
+err_shrinker:
+	vduse_domain_exit();
+err_domain:
 	vduse_virqfd_exit();
 err_irqfd:
 	destroy_workqueue(vduse_vdpa_wq);
@@ -1309,8 +1358,10 @@ module_init(vduse_init);
 
 static void vduse_exit(void)
 {
+	unregister_shrinker(&vduse_bounce_pages_shrinker);
 	misc_deregister(&vduse_misc);
 	destroy_workqueue(vduse_vdpa_wq);
+	vduse_domain_exit();
 	vduse_virqfd_exit();
 	vduse_parentdev_exit();
 }
-- 
2.11.0

