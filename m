Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167520CC29
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgF2Ddu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgF2Ddt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:33:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2554C03E979;
        Sun, 28 Jun 2020 20:33:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u8so7154237pje.4;
        Sun, 28 Jun 2020 20:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pdRoNIQxLUhqhAFVYUae+IUaVMSVu90O9pRkmyfRUE=;
        b=MqUbKDPjHH58VRvfEM2e92nSMSPFLGr5x6g3CwqokrXG1vPxG9oLly8UdNxcmNw5Ec
         0LktYxO4eNegwhMlYslnFZMwLRCJaS3SN7SGl4pwL+NC+SYYlVp+exdAVheZUiurtO2c
         a3GdngVZa4nXZF4aun5KUhUB7W+E7Wmc1pnmVr26bP6QHfSna1+t6jMRabhKvcktIWCn
         ZNgN5keoSqkesztuPVcDuEmpKhq4GXOU1eaWgyVZWBZTeqkke+2anAqt4L88bMknM935
         Chmlc1Trfqqobs2DS2LW0z70HB0/Afsvww1SRIMAQzYqm3xRthsU6QMuAwcRqcjRrkq6
         MP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pdRoNIQxLUhqhAFVYUae+IUaVMSVu90O9pRkmyfRUE=;
        b=GWn7WAj9DprlxNZGoN2+5hHgTU5dZLzyZpfJ8oc9RZQTFT6wbKlhmXreVf038zujGW
         7VG1aA2Sy38BxfS7Z/DAVvGAvJw1Q3nyWcGfWLWkqp1TFWr1QbpUBWyjpm4Q8dxucsnl
         U7+3R2bp+snlBmICoaPn3m4bhDVlB3DXLG1fE2sByKQmF+GfjaSYrTBqeVTzznk+R0cm
         f1cgN44zUL2/xIlLTXjVOQTpF/+uR/q1iv9TTfgBtwMKSZz0Pbjx+9OIRRNq80aPycK4
         l5VltEmNYVeoBzztV5wUiXQ/Tr0mwLnQL5IRCLhwDuF4AiniUpFo+FtBenkfzRyJrm1v
         3GcA==
X-Gm-Message-State: AOAM532viWyP0RR75tunTzS35Ha/vxXg2+dRHTU2RPDcwaHMPyUXfKFN
        AfhoxOzjBCz9C3H/BnFbe5A=
X-Google-Smtp-Source: ABdhPJxW85j1R52gBwd6LuoKKZoh8q7FkbIGlammyJyNseWZVtXqEJ6qUePxGnkFeWcr1P3HrEa/zA==
X-Received: by 2002:a17:90a:89:: with SMTP id a9mr14232333pja.27.1593401629174;
        Sun, 28 Jun 2020 20:33:49 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id e191sm10679196pfh.42.2020.06.28.20.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 20:33:48 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/2] ipw2100: use generic power management
Date:   Mon, 29 Jun 2020 09:02:25 +0530
Message-Id: <20200629033226.160936-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629033226.160936-1-vaibhavgupta40@gmail.com>
References: <20200629033226.160936-1-vaibhavgupta40@gmail.com>
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

The driver was invoking PCI helper functions like pci_save/restore_state(),
pci_enable/disable_device() and pci_set_power_state(), which is not
recommended.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 624fe721e2b5..57ce55728808 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6397,10 +6397,9 @@ static void ipw2100_pci_remove_one(struct pci_dev *pci_dev)
 	IPW_DEBUG_INFO("exit\n");
 }
 
-#ifdef CONFIG_PM
-static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int __maybe_unused ipw2100_suspend(struct device *dev_d)
 {
-	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
+	struct ipw2100_priv *priv = dev_get_drvdata(dev_d);
 	struct net_device *dev = priv->net_dev;
 
 	IPW_DEBUG_INFO("%s: Going into suspend...\n", dev->name);
@@ -6414,10 +6413,6 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/* Remove the PRESENT state of the device */
 	netif_device_detach(dev);
 
-	pci_save_state(pci_dev);
-	pci_disable_device(pci_dev);
-	pci_set_power_state(pci_dev, PCI_D3hot);
-
 	priv->suspend_at = ktime_get_boottime_seconds();
 
 	mutex_unlock(&priv->action_mutex);
@@ -6425,11 +6420,11 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	return 0;
 }
 
-static int ipw2100_resume(struct pci_dev *pci_dev)
+static int __maybe_unused ipw2100_resume(struct device *dev_d)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev_d);
 	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
 	struct net_device *dev = priv->net_dev;
-	int err;
 	u32 val;
 
 	if (IPW2100_PM_DISABLED)
@@ -6439,16 +6434,6 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 
 	IPW_DEBUG_INFO("%s: Coming out of suspend...\n", dev->name);
 
-	pci_set_power_state(pci_dev, PCI_D0);
-	err = pci_enable_device(pci_dev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       dev->name);
-		mutex_unlock(&priv->action_mutex);
-		return err;
-	}
-	pci_restore_state(pci_dev);
-
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
@@ -6473,7 +6458,6 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 
 	return 0;
 }
-#endif
 
 static void ipw2100_shutdown(struct pci_dev *pci_dev)
 {
@@ -6539,15 +6523,14 @@ static const struct pci_device_id ipw2100_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ipw2100_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(ipw2100_pm_ops, ipw2100_suspend, ipw2100_resume);
+
 static struct pci_driver ipw2100_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = ipw2100_pci_id_table,
 	.probe = ipw2100_pci_init_one,
 	.remove = ipw2100_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend = ipw2100_suspend,
-	.resume = ipw2100_resume,
-#endif
+	.driver.pm = &ipw2100_pm_ops,
 	.shutdown = ipw2100_shutdown,
 };
 
-- 
2.27.0

