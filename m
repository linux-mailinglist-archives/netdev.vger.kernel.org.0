Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7794E228332
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgGUPIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgGUPIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 11:08:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C28C061794;
        Tue, 21 Jul 2020 08:08:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 8so1144639pjj.1;
        Tue, 21 Jul 2020 08:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxArNrsDxK0jgBrFXe5Xugx6neCsoFxEQFgdlLGJALY=;
        b=cvKDwOQ5Q1EfaXBnNKGYSan/gUvJ2Wpuz0IEZBdbEzg7l/oeqXx2Aw2AR/oHEtXxxQ
         JTqdz8qQl1jw0bOSHve9RQyayuss5fTkI4N7E520IR0YTgY8iQN9dt724jK/FNEqAsWb
         uLL1AbWOs7IRs7gxr3gXxH1nGDlJvl7hOdEH64PuXiEq+Qzzpi7awMJWt4SHrBdaUgI/
         wsBWSW2qCPjzH1FbatYCcH/wvFDCXRa+H84MRkGHs8mQuQwe0/X2CTqgFvOMAqaoFzli
         +xeC+8KU1Hh1AAFUeR9Sa2BDb5NUSgKi4GZQcZoHSeWvc3BH75IeRN1Riasw9SH5O+uV
         IGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxArNrsDxK0jgBrFXe5Xugx6neCsoFxEQFgdlLGJALY=;
        b=bhNEO+q+Ndr3BDbf9hOgRsTy1UrLBwaiLk0GngjeG2qnWXBzVaKMV4ik3tWpKmKD9x
         SWqZkuTj+7XdmliO7L7HTwGtFKYIxaTDLSR45NfK4druUCTgAiWDe0kFe+kdvk6QqDtJ
         etgZQxNT/p1cJuNE947mq6n6OuN61LcjIBfm/MsiqMEiLm9kWx+fcO0GN7RRUJZ/5QRP
         3brHZyFQAhkN0+3T6E9mhBIhvn1hmXrz6gwKOaabVPdrl187V0hGH/HqCvRTl9rxMf0x
         qN4TjIvAADtQjK1cQTcOKs+ZJc6+hW2YCxlxRWywEy3V+J+FyH8jj0p3M0WBJeTSGJho
         dfQg==
X-Gm-Message-State: AOAM532SmG1bWwnl9OAc1kHCfgkLPzwFR2ozXgF6DOsNrBxvZgt88TAQ
        g/hAHQfqX6YAm93XZ5ppWCc=
X-Google-Smtp-Source: ABdhPJxx6sheP773N2Alf7m5fZ1kBw3d8TYsmk6FDAhB5okg1aq0WfjsN1Rzp3JE1fPsUGQT+7tCaQ==
X-Received: by 2002:a17:90a:6983:: with SMTP id s3mr5240415pjj.55.1595344117406;
        Tue, 21 Jul 2020 08:08:37 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id j3sm20122735pfe.102.2020.07.21.08.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 08:08:36 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] hostap: use generic power management
Date:   Tue, 21 Jul 2020 20:35:48 +0530
Message-Id: <20200721150547.371763-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
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
helper functions and device power state control functions as through
the generic framework, PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/wireless/intersil/hostap/hostap_hw.c  |  6 ++--
 .../net/wireless/intersil/hostap/hostap_pci.c | 34 ++++++-------------
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 2ab34cf74ecc..b6c497ce12e1 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -3366,8 +3366,8 @@ static void prism2_free_local_data(struct net_device *dev)
 }
 
 
-#if (defined(PRISM2_PCI) && defined(CONFIG_PM)) || defined(PRISM2_PCCARD)
-static void prism2_suspend(struct net_device *dev)
+#if defined(PRISM2_PCI) || defined(PRISM2_PCCARD)
+static void __maybe_unused prism2_suspend(struct net_device *dev)
 {
 	struct hostap_interface *iface;
 	struct local_info *local;
@@ -3385,7 +3385,7 @@ static void prism2_suspend(struct net_device *dev)
 	/* Disable hardware and firmware */
 	prism2_hw_shutdown(dev, 0);
 }
-#endif /* (PRISM2_PCI && CONFIG_PM) || PRISM2_PCCARD */
+#endif /* PRISM2_PCI || PRISM2_PCCARD */
 
 
 /* These might at some point be compiled separately and used as separate
diff --git a/drivers/net/wireless/intersil/hostap/hostap_pci.c b/drivers/net/wireless/intersil/hostap/hostap_pci.c
index 0c2aa880e32a..101887e6bd0f 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_pci.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_pci.c
@@ -403,36 +403,23 @@ static void prism2_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-
-#ifdef CONFIG_PM
-static int prism2_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused prism2_pci_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev)) {
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
 	}
 	prism2_suspend(dev);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
-static int prism2_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused prism2_pci_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	int err;
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       dev->name);
-		return err;
-	}
-	pci_restore_state(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
+
 	prism2_hw_config(dev, 0);
 	if (netif_running(dev)) {
 		netif_device_attach(dev);
@@ -441,20 +428,19 @@ static int prism2_pci_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
-
 
 MODULE_DEVICE_TABLE(pci, prism2_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(prism2_pci_pm_ops,
+			 prism2_pci_suspend,
+			 prism2_pci_resume);
+
 static struct pci_driver prism2_pci_driver = {
 	.name		= "hostap_pci",
 	.id_table	= prism2_pci_id_table,
 	.probe		= prism2_pci_probe,
 	.remove		= prism2_pci_remove,
-#ifdef CONFIG_PM
-	.suspend	= prism2_pci_suspend,
-	.resume		= prism2_pci_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &prism2_pci_pm_ops,
 };
 
 module_pci_driver(prism2_pci_driver);
-- 
2.27.0

