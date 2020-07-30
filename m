Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0002C232C0C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgG3Goc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3Gob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:44:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA41C061794;
        Wed, 29 Jul 2020 23:44:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x6so801569pgx.12;
        Wed, 29 Jul 2020 23:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/vlI3SS5LvqfdvM+r/BRxyq9xbnF0HtDqy+K6GhzXBQ=;
        b=F7pn/vdUGyHNpJ5LnexqOBDYKQKnF9QfMCXyYdInmVdp/JzJFLcckKFTcjH4VrilYf
         4Hps7LsNc7soNYUtMGpnJvaJ/QDfve7hrlv0drmnkXAd/ZMBjoG2SdkiMkh0bsjtjBWv
         qGPDar5x1XpLn8qm+Oze1B+bLhBwIT2WbBG7Knd7rWSDUnsfPhyDufVLNpnjHK9ttk9v
         vQwqG2gVx0HXMUNe9eJRkWOdr/O5YJOdxThjDrlkRcW4bXx1OSePfnc590ZRMJ9B3N6Y
         9p7K3fLtkAtE0QqHYkDIQRzhXTWgcnUUbW1emabD//5o8sr7RN77juR2DATWiUFNNGAm
         2qKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/vlI3SS5LvqfdvM+r/BRxyq9xbnF0HtDqy+K6GhzXBQ=;
        b=LRvlzulc5v2uwtu1TUyomMp5WQWwu5rVrhdJJudbbtW79bfp6NPch6vT6hJtQpLKGn
         PfyhTw5Ya7pdKxIPSNZATzFvE3fOlWLalANylDpWeCMBQxGCiUW8fKF9QdhXWD6YgaGY
         k39tuTzQmaLwKfBOHZnVltfEjcOy5/XEGnrtYYA2UhcLkWs/Mb/sFGlGXoJp62C+qKob
         UimC4dQYwZy4faBWaAv0ykWZhZI4YM4xxtIcZCzyci9SxAXGgacKwet1OCSIdT75uxaL
         x5R/GNeePB4z0fub5Mah5R73EUJEuA+kZ7mHDJwKYHCFiqwxznLDs19shmJCppLPx6Xn
         qbbw==
X-Gm-Message-State: AOAM532EphmicFRs46H4O9l6Q+BRTd2KeUSPvpZC29BFOvN2NrTo2CGd
        S8uG7jtPdciOOqIHxz521wM=
X-Google-Smtp-Source: ABdhPJz1aeKVWZX4u2w6g489ELA8fTkpKQMu1PBdZ0IduIPpWXPqOwdj8qn5V8VqMIG1A4eaWOEvBw==
X-Received: by 2002:a63:417:: with SMTP id 23mr31435392pge.44.1596091471237;
        Wed, 29 Jul 2020 23:44:31 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id t19sm4456942pgg.19.2020.07.29.23.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:44:30 -0700 (PDT)
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
Date:   Thu, 30 Jul 2020 12:12:29 +0530
Message-Id: <20200730064229.174933-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730064229.174933-1-vaibhavgupta40@gmail.com>
References: <20200730051733.113652-1-vaibhavgupta40@gmail.com>
 <20200730064229.174933-1-vaibhavgupta40@gmail.com>
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

