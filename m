Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E016877B6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBBImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBBImT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:42:19 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4797D994
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:42:18 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o36so788585wms.1
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 00:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJ2h1ZaU/GcFk31wHwXi/YmcM59nhFndu/IEhvHklgU=;
        b=JagVYhvz8pDF2iKIQuwL52O/DMXrNq67WmS2Ysg5mBspm6Zf8s2/AQKlykE1CtDrve
         F0RYnEng7c0b4oazJF+xUwLeqwvyj2lYJYi+Y534DnWMgwgxSqbBOueBiCVkM/X5CPjt
         hnxIvTMYbUoZgPpki9SXVTpE8hvicKxkrZ964jCqnG0GflrwMvYQXDjVqrc5xgCiRDVb
         QadV0/HE8flOC0K3cBAFbpYqqux4xuzJiH9wttkEHnFRnS8Evz+DsdHUhy76G6c/kcUc
         NXxs3L4XwebUUg47uv3kfnC5ECntYGcG4t1oKc2Re7DIadqy63CoJL7jJqKouexsrAdz
         2lRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJ2h1ZaU/GcFk31wHwXi/YmcM59nhFndu/IEhvHklgU=;
        b=mFCw+96s8oLu7uIpM06VvxLIFrGNi4E5/kJhzDZB4LvP3dNomIyySJWb4zbmj6kzEn
         g2zxxPwFBPfRy9PMGSiQuWnUFKb9m6n620PzYzimHLvEMUzBZAZSSmUVEfRk6qxArNHH
         OYF0POCFaTP0m+P8Q5AePxxwOY+BDfdVPxiXSwItwC1WaiTDnzNB5N9ERwhnKAmLcSi3
         IFjHekCyahIGvo2qpxAo4j9OQatSeo0c2f60iwbDPIjg67ZGPKHEfXxwffwPvZ9doQcx
         F35y0e2/XtlbroagW7hPlvNPTJsNPEE3hmzHi0QVgl4YokYVeFns6sO24AC30i/xRfSm
         KfzQ==
X-Gm-Message-State: AO0yUKVYEzYO86qy46G/+nGc7GXg9UdNt1pSjAYIrWrmkjkAyenu9k89
        fH7jXCx+QCrB6cO/yzzTG6nVmw==
X-Google-Smtp-Source: AK7set/dZBeBiTxve1zjMeO7wkX4uitN6ccr1VJ/0ayaitBMBYYqDoBhGZzUzubT3kffRhTh0I1vbA==
X-Received: by 2002:a05:600c:3b9d:b0:3d2:3be4:2d9a with SMTP id n29-20020a05600c3b9d00b003d23be42d9amr5141708wms.20.1675327336811;
        Thu, 02 Feb 2023 00:42:16 -0800 (PST)
Received: from alvaro-dell.. (bzq-84-110-153-254.static-ip.bezeqint.net. [84.110.153.254])
        by smtp.gmail.com with ESMTPSA id i13-20020a1c540d000000b003db03725e86sm4170906wmb.8.2023.02.02.00.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:42:15 -0800 (PST)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: [PATCH v2] vhost-vdpa: print warning when vhost_vdpa_alloc_domain fails
Date:   Thu,  2 Feb 2023 10:42:12 +0200
Message-Id: <20230202084212.1328530-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a print explaining why vhost_vdpa_alloc_domain failed if the device
is not IOMMU cache coherent capable.

Without this print, we have no hint why the operation failed.

For example:

$ virsh start <domain>
	error: Failed to start domain <domain>
	error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
	       Unknown error 524

Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

---
v2:
	- replace dev_err with dev_warn_once.

 drivers/vhost/vdpa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 23db92388393..135f8aa70fb2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	if (!bus)
 		return -EFAULT;
 
-	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
+	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
+		dev_warn_once(&v->dev,
+			      "Failed to allocate domain, device is not IOMMU cache coherent capable\n");
 		return -ENOTSUPP;
+	}
 
 	v->domain = iommu_domain_alloc(bus);
 	if (!v->domain)
-- 
2.34.1

