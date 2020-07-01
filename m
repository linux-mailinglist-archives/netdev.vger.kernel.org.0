Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAA21112D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgGAQxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732632AbgGAQxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:53:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA54C08C5C1;
        Wed,  1 Jul 2020 09:53:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so11242897pfu.8;
        Wed, 01 Jul 2020 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgWMYsxifIjCAMg7HZzoEhiN+UCBVyZRovJ/AjnVLVk=;
        b=sWPcsnyCaxu2D8bWEGXiR1Z9baVSYIo4Ox2GbJ83WzrUT/9tZLC5SIotlEJLY0aIXK
         3sLxqcvB2Pe47M6kxwM+q34DMc5DduXblnU6vYxr2lyzZn0NDus1VtnFhFoUppQ3pHbR
         qz/Yp3pl/gGDutJS1JBnaJ4aZUtttt5c2As/cLhbKvMlENFDcqIeZFiMH+moapI3fRyK
         lWcxgKB9HrN9ekI6zW9NMg/ZwSH0urrzUV0tUES+3qcheO4VFnz2con19h3au1fBkwJW
         WGDtgKITpXPpMzWWRzkff5mTQJKT8xuKjzAq1M90i5IrcAlI8ER78zEukN0w0jHIq0fS
         QgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgWMYsxifIjCAMg7HZzoEhiN+UCBVyZRovJ/AjnVLVk=;
        b=ELelb0Ie4G/5tyc4aaY5PNNgHCh5J8W/zGNwkMuzTSFE24U6hwlVD/x/MVneQISsNQ
         QAR3XIks4U0P3x7kKEyGTdRjTcB9g8Q9Fi6K1pRfziMsoLR5cMRm3/DmNRyjuQPKCr5J
         4GVxNrOZ28FFjs9bANtxAyUbC4m5ukfDmbJecq9oDks1xgiJTf1L2ffvtbDzhesdId1d
         eaByzeumVGsdAdU7AFHEho/KmXsHCtLRDMlZqmX6CmXVfSzkEE0mZNTIKU1hDq4yT3pm
         Up3zswIEYRtJwDFUrDAz18XkiLgmJEFcJxwXg8Zicbe5xdQ1g3fwIdNavQYe7wUAhSnK
         I8wg==
X-Gm-Message-State: AOAM532UNeCDzS9Sy6srKyq9v8IfrDB/eLEb02woyT6nS8QBUKQKZMkc
        Ilkm9TwqGWH6IB4ZgDh0XCI=
X-Google-Smtp-Source: ABdhPJwsgL18JV27Sau7nPIz5eYvsV/uzsFPrY3R0zIEHJ414F0YgAo4/JQ6uo5+LnalKaqIpg+4/A==
X-Received: by 2002:a63:fc1f:: with SMTP id j31mr21138230pgi.104.1593622383151;
        Wed, 01 Jul 2020 09:53:03 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:53:02 -0700 (PDT)
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
Subject: [PATCH v2 04/11] ena_netdev: use generic power management
Date:   Wed,  1 Jul 2020 22:20:50 +0530
Message-Id: <20200701165057.667799-5-vaibhavgupta40@gmail.com>
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

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 22 ++++++++------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dda4b8fc9525..91be3ffa1c5c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4420,13 +4420,12 @@ static void ena_shutdown(struct pci_dev *pdev)
 	__ena_shutoff(pdev, true);
 }
 
-#ifdef CONFIG_PM
 /* ena_suspend - PM suspend callback
- * @pdev: PCI device information struct
- * @state:power state
+ * @dev_d: Device information struct
  */
-static int ena_suspend(struct pci_dev *pdev,  pm_message_t state)
+static int __maybe_unused ena_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 
 	u64_stats_update_begin(&adapter->syncp);
@@ -4445,12 +4444,11 @@ static int ena_suspend(struct pci_dev *pdev,  pm_message_t state)
 }
 
 /* ena_resume - PM resume callback
- * @pdev: PCI device information struct
- *
+ * @dev_d: Device information struct
  */
-static int ena_resume(struct pci_dev *pdev)
+static int __maybe_unused ena_resume(struct device *dev_d)
 {
-	struct ena_adapter *adapter = pci_get_drvdata(pdev);
+	struct ena_adapter *adapter = dev_get_drvdata(dev_d);
 	int rc;
 
 	u64_stats_update_begin(&adapter->syncp);
@@ -4462,7 +4460,8 @@ static int ena_resume(struct pci_dev *pdev)
 	rtnl_unlock();
 	return rc;
 }
-#endif
+
+static SIMPLE_DEV_PM_OPS(ena_pm_ops, ena_suspend, ena_resume);
 
 static struct pci_driver ena_pci_driver = {
 	.name		= DRV_MODULE_NAME,
@@ -4470,10 +4469,7 @@ static struct pci_driver ena_pci_driver = {
 	.probe		= ena_probe,
 	.remove		= ena_remove,
 	.shutdown	= ena_shutdown,
-#ifdef CONFIG_PM
-	.suspend    = ena_suspend,
-	.resume     = ena_resume,
-#endif
+	.driver.pm	= &ena_pm_ops,
 	.sriov_configure = pci_sriov_configure_simple,
 };
 
-- 
2.27.0

