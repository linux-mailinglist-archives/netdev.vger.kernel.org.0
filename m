Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F406D232C28
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgG3Gzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgG3Gzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:55:41 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB24C061794;
        Wed, 29 Jul 2020 23:55:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j20so14481869pfe.5;
        Wed, 29 Jul 2020 23:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/vlI3SS5LvqfdvM+r/BRxyq9xbnF0HtDqy+K6GhzXBQ=;
        b=IeyTY+OHDs3axg/+m/60sKy64hsxJz6vIgqYhE6Iz6K12qqw/hsugFDau/PBn8WFV3
         JGQGAcFjBIEXxo0/VcnzQEFRhlWgm9IdPUdmzmwhFizSkecC2hZluT61Uqq6D005neYu
         +Lhsq4df0bJBHJSrWY0DUvFJa7psUHeAnTY+8W1mCXMlqiPyzTni1n3uwciUA6J9VmUS
         S6najC8IxhfEx6WzNXnrq4qzFli00UiTBX7CLifCNEf4+81x0tGGDSjxYSye1htoFIDX
         Hq+hUVgBt0ep49YZHEJlW53pldG9t8pu9wz/EmvEiroJ5SyApHesf2QEC2dFLP1sty74
         iqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/vlI3SS5LvqfdvM+r/BRxyq9xbnF0HtDqy+K6GhzXBQ=;
        b=rAhM24QbbOAmHWN4AcYRBJJCqXjRnbWdW80lPsOiW2/BxyoRPQ0IVRqR2FrNie5/FU
         eOd/fxMMXGSp0yJx9ZK1iZeoWsW1HyV0Krpt4j/xsD4ZMhe4vOBTnGuuAV0kMddZTwCd
         DAaioMx+KljeD8+Qo3QMrb+tx3Vubf9XPxKl/QdDNOpBg9bdB/m1nJ3qRIy2ltU7/fB+
         iMVauL1bgu9tgpIYaof8iRx3YtDfQ2Y0UV5nqoSx+3pyw0lgVb/QhpyhRkon+7pGyFf5
         jtzpQWxxhCf/L2OUYmeh3/a67X+5Q6930nSHiFBf2CihJ38q409VDkj72W4JLGlXawNt
         NI9Q==
X-Gm-Message-State: AOAM530nBJSW1xHhbRM4yrxo4rfiKGLYhEDSmNF6qUZh6Ww0ekpaGiFb
        XDlrX5UMs4ltjNCB7u+Tu/A=
X-Google-Smtp-Source: ABdhPJwYGhi+sY/oimQBy5vqYoOm292XvKwZ6vkA9xlHyQ2ck1XAnfc6tDfqNmjF+sYua3WD3W05Cg==
X-Received: by 2002:a63:f04d:: with SMTP id s13mr27043273pgj.100.1596092141275;
        Wed, 29 Jul 2020 23:55:41 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id v2sm4232299pje.19.2020.07.29.23.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:55:40 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniele Venzano <venza@brownhat.org>,
        Samuel Chessman <chessman@tux.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1 3/3] tlan: use generic power management
Date:   Thu, 30 Jul 2020 12:23:36 +0530
Message-Id: <20200730065336.198315-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730065336.198315-1-vaibhavgupta40@gmail.com>
References: <20200730065336.198315-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using legacy power management .suspen()/.resume() callbacks
have to manage PCI states and device's PM states themselves. They also
need to take care of standard configuration registers.

Switch to generic power management framework using a single
"struct dev_pm_ops" variable to take the unnecessary load from the driver.
This also avoids the need for the driver to directly call most of the PCI
helper functions and device power state control functions, as through
the generic framework PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/ti/tlan.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 857709828058..c799945a39ef 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -345,33 +345,21 @@ static void tlan_stop(struct net_device *dev)
 	}
 }
 
-#ifdef CONFIG_PM
-
-static int tlan_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused tlan_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev))
 		tlan_stop(dev);
 
 	netif_device_detach(dev);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_wake_from_d3(pdev, false);
-	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
-static int tlan_resume(struct pci_dev *pdev)
+static int __maybe_unused tlan_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	int rc = pci_enable_device(pdev);
-
-	if (rc)
-		return rc;
-	pci_restore_state(pdev);
-	pci_enable_wake(pdev, PCI_D0, 0);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	netif_device_attach(dev);
 
 	if (netif_running(dev))
@@ -380,21 +368,14 @@ static int tlan_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#else /* CONFIG_PM */
-
-#define tlan_suspend   NULL
-#define tlan_resume    NULL
-
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(tlan_pm_ops, tlan_suspend, tlan_resume);
 
 static struct pci_driver tlan_driver = {
 	.name		= "tlan",
 	.id_table	= tlan_pci_tbl,
 	.probe		= tlan_init_one,
 	.remove		= tlan_remove_one,
-	.suspend	= tlan_suspend,
-	.resume		= tlan_resume,
+	.driver.pm	= &tlan_pm_ops,
 };
 
 static int __init tlan_probe(void)
-- 
2.27.0

