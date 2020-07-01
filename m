Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0E821112B
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbgGAQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732632AbgGAQwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:52:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C364DC08C5DB;
        Wed,  1 Jul 2020 09:52:54 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so9034235pgf.0;
        Wed, 01 Jul 2020 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QuyL93xGAaaNSghhFPwjm3/FQ7kS7DpgB2p+k7g93Fg=;
        b=U+q/ChJ32SvosX5d+vZSvkbJyN6RbExhvMW0WqpXuca3Dk8sqCyku+OZTzx+xDBP0l
         MxXRpkUNg9iKpt6NFlNI2vq8gipOICMkOFe6Yw5PcOvlg7FoPkg0I1OgB8lp1Gdi9KxB
         PbALlHFmRw4q4H9IVleJSSwR7AfVgNlCw794ru1r7JGI8A9pErfQQmxeOfoBlEsSnL8I
         jxrjHieyS39m7ISSuSPfy2WKmSvEeGeueEn8LpjKCpavxy+7XWtFI007+Ht7Ei/Im6+d
         Q2rxrMZIV3N1AhcGBKL1b50zSglv0D16XzpDLA4H5g8HMWe+gdZdfC0BGuX23i3A0jNz
         JO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QuyL93xGAaaNSghhFPwjm3/FQ7kS7DpgB2p+k7g93Fg=;
        b=GQmxVi+jUEGDBNylVTogz2vIx6GB0nG2gHPvjVfy5tE1zV6N3Lh1cgR6yxxkLM53uS
         TzZKRUK0dzVl80ygK+fwA8boxfebsN7zTWSL7mMdP6CFecbJQYEjmDRAWQKkHDQ2+5fz
         v67gLWVQhZ3LsFLPCmu0pt3VtKjc4Y2OWxczSWAAM6br6rfuiJ6GsYa+yVoscSj8GsxZ
         pQrOpVv5piazt7FQgb7Wfz5OVInpAMiTTZ6YcotyZtv5jVtq4r6Yl5CLiBjFU7JbY2DA
         Cn9Rc1oDycP95s2txptGaUUG7+7ha+2wACjUf2o3ofqZwqKDJr+RSdMcRuMzplysSTVX
         jvSw==
X-Gm-Message-State: AOAM530lvElm2EGbR2YibOOV/N/N+aHscvxBc+UyG1cv6KQMWNGNT/GB
        vOmrWvLpkIMUJmDB8sjL3bM=
X-Google-Smtp-Source: ABdhPJwZl9Z3ZTfI1i0GTTtXri0t+gvmcmZPYD+1kOUbDpxoXB0QVkNrlSNKTaOLgB2m/e6Agc+E7Q==
X-Received: by 2002:a63:495c:: with SMTP id y28mr21000872pgk.30.1593622372580;
        Wed, 01 Jul 2020 09:52:52 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:52:52 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 03/11] starfire: use generic power management
Date:   Wed,  1 Jul 2020 22:20:49 +0530
Message-Id: <20200701165057.667799-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
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

Thus, there is no need to call the PCI helper functions like
pci_save/restore_sate() and pci_set_power_state().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/adaptec/starfire.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index a64191fc2af9..ba0055bb1614 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1984,28 +1984,21 @@ static int netdev_close(struct net_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int starfire_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused starfire_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		netdev_close(dev);
 	}
 
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev,state));
-
 	return 0;
 }
 
-static int starfire_resume(struct pci_dev *pdev)
+static int __maybe_unused starfire_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev)) {
 		netdev_open(dev);
@@ -2014,8 +2007,6 @@ static int starfire_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
-
 
 static void starfire_remove_one(struct pci_dev *pdev)
 {
@@ -2040,15 +2031,13 @@ static void starfire_remove_one(struct pci_dev *pdev)
 	free_netdev(dev);			/* Will also free np!! */
 }
 
+static SIMPLE_DEV_PM_OPS(starfire_pm_ops, starfire_suspend, starfire_resume);
 
 static struct pci_driver starfire_driver = {
 	.name		= DRV_NAME,
 	.probe		= starfire_init_one,
 	.remove		= starfire_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= starfire_suspend,
-	.resume		= starfire_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &starfire_pm_ops,
 	.id_table	= starfire_pci_tbl,
 };
 
-- 
2.27.0

