Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A328121544E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgGFI7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGFI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:59:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FAAC061794;
        Mon,  6 Jul 2020 01:59:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k5so7157265pjg.3;
        Mon, 06 Jul 2020 01:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=It/KCincJ1QGaOO3UJT7U/GTe3VbLriw3afVTbDT6II=;
        b=CB8z185MxQ6CkLhK0kdmZB3E7Cyhh8QOuACpiO1OpxmyJ0wkeqL67RoQwYbGemDlMu
         M7AIRJ+gb5Q05PLdon3i/wfbgW2rRuHO+OTu5WGmPKh0qyC5tb0SpOtTMBdb7RLyaqWx
         zCKTelnHV5b00qyds1fhiBpcuohnKWgNqNUSOgUL8aeYQXaPLgv/gOzJHA9dtdbrSxhu
         W4iUUhWvbDvgt3dMRE923QYawVRiUzd4O7dBYyX/RF59TisTSLpxmVgdQ/SLMZOFF9JQ
         GEcs+yYDc/W555OuwkWYm+zyiZL1al7hgUk3L8g+heBOJO4AGY2palhari4fyx/7qf3d
         fqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=It/KCincJ1QGaOO3UJT7U/GTe3VbLriw3afVTbDT6II=;
        b=m3fGbJh3UypJga1BcauBuRNDbdoi6ErVA/h3JmW9TdnMilQKv9zBcmUdEH7c0P3Z+D
         o5bBF9j/u0WZLEDnzXb7L/lv6CvnI8YHsSMizwu3Sg2SYbIzsBt8B/1c7RPB0WAW4p8g
         8G6W+gYNFb00hNrQNvjEynQTAzCs8pVA0NnFJTl0zQtDmCwUQFxL1O/5fsAQB4SlmvfB
         qIG4uCp+DGvr5GFAcxfIatLuUH988nWPG4Flp+dLCucmPqhqh0ew4HNyPozDzdNkNdj7
         Gl8eltYJvK4p4Eq/H5+eB/dnVf+F1vLCnbfylxpRwIZ5MSdUCnPLOGuUJMKcRgGUjaao
         M3GQ==
X-Gm-Message-State: AOAM530gq50x0CTs6ZBS0DCZzGjieW2nlatZStZkGlBbUbVyxpWESIca
        1+DOFLuMqWCxiE0u7X7zJVM=
X-Google-Smtp-Source: ABdhPJzdwMBcEoHGFBN8BFYtVx9Mvr6X3ml8KNAOxTdBCKB+cQEsfLXBpCgjAIzQ1rj34+kighSeTA==
X-Received: by 2002:a17:90a:cc03:: with SMTP id b3mr46644646pju.80.1594025977830;
        Mon, 06 Jul 2020 01:59:37 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id a19sm10068149pfn.136.2020.07.06.01.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 01:59:37 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 3/3] sun/cassini: use generic power management
Date:   Mon,  6 Jul 2020 14:27:46 +0530
Message-Id: <20200706085746.221992-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
References: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/sun/cassini.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index debd3c3fa6fb..5b11124450d6 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5172,10 +5172,9 @@ static void cas_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#ifdef CONFIG_PM
-static int cas_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused cas_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct cas *cp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -5204,9 +5203,9 @@ static int cas_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int cas_resume(struct pci_dev *pdev)
+static int cas_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct cas *cp = netdev_priv(dev);
 
 	netdev_info(dev, "resuming\n");
@@ -5227,17 +5226,15 @@ static int cas_resume(struct pci_dev *pdev)
 	mutex_unlock(&cp->pm_mutex);
 	return 0;
 }
-#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(cas_pm_ops, cas_suspend, cas_resume);
 
 static struct pci_driver cas_driver = {
 	.name		= DRV_MODULE_NAME,
 	.id_table	= cas_pci_tbl,
 	.probe		= cas_init_one,
 	.remove		= cas_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= cas_suspend,
-	.resume		= cas_resume
-#endif
+	.driver.pm	= &cas_pm_ops,
 };
 
 static int __init cas_init(void)
-- 
2.27.0

