Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F34821219C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgGBKzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgGBKzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:55:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D09C08C5C1;
        Thu,  2 Jul 2020 03:55:18 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f2so11169425plr.8;
        Thu, 02 Jul 2020 03:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQztFWTnvvCC65swoXT94iI6JJUvW0UB4XPTfh/WW2w=;
        b=eupQ18VFDu/AqLHsApIR/AXryJVxCGDoso/+wFL3dozCbdBHuCJEYInE+14uYLsLig
         f/DMKq0c1QX1Pzr6k9KmaX1zZAMVjesSnuqY+zfCVNpWxA99wqAxZJpTePzvH5N3wZP5
         HOjERzU7jFG2IHw/02HV8gPRsSeL0whjPdP50bW0RQfhRfjyUI+VadZ6HsOBHk5Ym4ve
         MqtjRvspMPHDnD1MdFTvWaxhvC4p696ZTD5OXCSe+V4lj31O+8NLDyPXxFeLPHXKE4+U
         rFjyoIiTl6yUt0E/O6C8uGYr7bPaL8psQYaZggLIjKdfQdAJqulyzRdxuluLgSj52AxP
         rXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQztFWTnvvCC65swoXT94iI6JJUvW0UB4XPTfh/WW2w=;
        b=JxW0BMfYNSOabiDEmrJN0grr+xe/dymLWuxqB2m9D02zbo+AMh4lySI1AM5CCdMDzY
         oMcKlOmLL3cIijKGoC7y3ul0JpxEkfDPf+uUcU0bUHaYhCSb51uy3zLr/FMLq5m7rcfu
         LROIdp8E+FtJlo7ZlAe8QdssTFveTNGDkPTVLVwoy+d7fKxAjImbuGCcSqTfDuHNkTbK
         jrqL5HAoFrrB73BJlyWodkO2I/g7yFCISTCMj8LHxTVtOW6nyy6+tPT3SmQ10yT+yjh5
         KMWVeWVQSqWSHTHumP7bcopZCovCxTvOnTNpF4VNtWrKUyC1nD6epl9+H3Rk38Qpfjdp
         9FMw==
X-Gm-Message-State: AOAM531EP6uE/eN56qpzmG4PraqPAop4foNeXyFInkyODz4Pv3+QIWTZ
        y19MXsHxDHX5PpKXbBQFwXU=
X-Google-Smtp-Source: ABdhPJzVPBbmkC4b0myZ5JB6fAfqNBf1wDyxDCENndpW13VJ3FygOeJ0bkkLWWk7K+/QskGs8FhshA==
X-Received: by 2002:a17:902:a40c:: with SMTP id p12mr17143434plq.51.1593687317660;
        Thu, 02 Jul 2020 03:55:17 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id z13sm8702393pfq.220.2020.07.02.03.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 03:55:17 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/2] epic100: use generic power management
Date:   Thu,  2 Jul 2020 16:23:50 +0530
Message-Id: <20200702105351.363880-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702105351.363880-1-vaibhavgupta40@gmail.com>
References: <20200702105351.363880-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/smsc/epic100.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 61ddee0c2a2e..d950b312c418 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1512,12 +1512,9 @@ static void epic_remove_one(struct pci_dev *pdev)
 	/* pci_power_off(pdev, -1); */
 }
 
-
-#ifdef CONFIG_PM
-
-static int epic_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused epic_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct epic_private *ep = netdev_priv(dev);
 	void __iomem *ioaddr = ep->ioaddr;
 
@@ -1531,9 +1528,9 @@ static int epic_suspend (struct pci_dev *pdev, pm_message_t state)
 }
 
 
-static int epic_resume (struct pci_dev *pdev)
+static int __maybe_unused epic_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (!netif_running(dev))
 		return 0;
@@ -1542,18 +1539,14 @@ static int epic_resume (struct pci_dev *pdev)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(epic_pm_ops, epic_suspend, epic_resume);
 
 static struct pci_driver epic_driver = {
 	.name		= DRV_NAME,
 	.id_table	= epic_pci_tbl,
 	.probe		= epic_init_one,
 	.remove		= epic_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= epic_suspend,
-	.resume		= epic_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &epic_pm_ops,
 };
 
 
-- 
2.27.0

