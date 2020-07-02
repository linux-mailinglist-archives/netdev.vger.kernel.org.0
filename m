Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC4211C0D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGBGiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBGiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 02:38:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA4C08C5C1;
        Wed,  1 Jul 2020 23:38:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f3so12992591pgr.2;
        Wed, 01 Jul 2020 23:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5VyTVc6pqjY8BZMU1suOu8lMlrhY2GnLm40n7rAuB0=;
        b=IbUIvX2xeRCHyYUd7UzydP1SUOQdtpQ7YUw75qwVAA8SyoSslClfhEt55hbZnMKoEP
         Patmec2jNBnqKkg9HhJT9jLoX7ObSDNUUaSr4LubH6ZsR45rRT8HSb3zdrPJmtQjU0xc
         IvK0CI5FJW/PGhwYNXpXSVeYMbsYYxi+4TCE3HCTm/CDO5+bqPdjCNlnoKWpwZgdpD5Y
         EHDKsMRmZOnvJnz3wVnOrXoqqh7JhvN4CERKcSWhum35mlk3YJ5VUef1tz5m2DV8Bv5F
         IeepaKgM2ia/9Nh0nERKfwX8miVIJN5KB1MoQrvQ7bfHJqU1ymP1EjU99zOER4+DiTN4
         Dhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5VyTVc6pqjY8BZMU1suOu8lMlrhY2GnLm40n7rAuB0=;
        b=GUYfMfn53mbHdJ2BVL7ml+smdxWJqKsBwPyPIm5fa6SR25bsxFU1SQjbR1Wn4AvsHK
         X6EtiuhVDa82kicKQXlHnUDssfr7k9s+JKH5ROW3d0u0UH/OSJyFvjPzLZUWoVX657VN
         MGgEJz/VcgK1CjuBku+pHB7CoAG+pjiJAUbFXUXRrXGgulL5Bo0QA5m72dK+owkPjPz0
         Jy9qp7vwLCC4vcDVYAx6wzXvcQ/czYV32oeNuw1KgkV2Q27+qG+FW0V6tFLLwgeSLmKI
         oq6xM6V/4uP03q5YFCwb+d3JhLL+4arr9XCkA1bQU40i2xu0uHddtjrXahteuoELch7m
         zF9w==
X-Gm-Message-State: AOAM533SCfLz1r8vFaj2AbuEyp/4iX1fzOJnkjfKyPIB3iHKnuAL0h1D
        tvk+h1h+bv0IM/utuHK8qxk=
X-Google-Smtp-Source: ABdhPJwx5JOu/vxym75bmMwsktikujKgXS2aJ7oyts4Vwr63mim+pdRxfm7TTLCStHcWjP0zIbOhlA==
X-Received: by 2002:a62:f206:: with SMTP id m6mr14228672pfh.260.1593671893294;
        Wed, 01 Jul 2020 23:38:13 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id l12sm7523549pff.212.2020.07.01.23.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:38:12 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/2] netxen_nic: use generic power management
Date:   Thu,  2 Jul 2020 12:06:31 +0530
Message-Id: <20200702063632.289959-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
References: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states. And they use PCI
helper functions to do it.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

In this driver:
netxen_nic_resume() calls netxen_nic_attach_func() which then invokes PCI
helper functions like pci_enable_device(), pci_set_power_state() and
pci_restore_state(). Other function:
 - netxen_io_slot_reset()
also calls netxen_nic_attach_func().

Also, netxen_io_slot_reset() returns specific value based on the return value
of netxen_nic_attach_func() as whole. Thus, cannot simply move some piece of
code from netxen_nic_attach_func() to it.

Hence, define a new function netxen_nic_attach_late_func() to do the tasks
which has to be done after PCI helper functions have done their job.

Now, netxen_nic_attach_func() invokes netxen_nic_attach_late_func(), thus
netxen_io_slot_reset() behaves normally.
And, netxen_nic_resume() calls netxen_nic_attach_late_func() to avoid PCI
helper functions calls.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 59 +++++++++----------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 8067ea04d455..f21847739ef1 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1695,19 +1695,13 @@ static void netxen_nic_detach_func(struct netxen_adapter *adapter)
 	clear_bit(__NX_RESETTING, &adapter->state);
 }
 
-static int netxen_nic_attach_func(struct pci_dev *pdev)
+static int netxen_nic_attach_late_func(struct pci_dev *pdev)
 {
 	struct netxen_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	int err;
 
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-
-	pci_set_power_state(pdev, PCI_D0);
 	pci_set_master(pdev);
-	pci_restore_state(pdev);
 
 	adapter->ahw.crb_win = -1;
 	adapter->ahw.ocm_win = -1;
@@ -1741,6 +1735,20 @@ static int netxen_nic_attach_func(struct pci_dev *pdev)
 	return err;
 }
 
+static int netxen_nic_attach_func(struct pci_dev *pdev)
+{
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	return netxen_nic_attach_late_func(pdev);
+}
+
 static pci_ers_result_t netxen_io_error_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
@@ -1785,36 +1793,24 @@ static void netxen_nic_shutdown(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#ifdef CONFIG_PM
-static int
-netxen_nic_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+netxen_nic_suspend(struct device *dev_d)
 {
-	struct netxen_adapter *adapter = pci_get_drvdata(pdev);
-	int retval;
+	struct netxen_adapter *adapter = dev_get_drvdata(dev_d);
 
 	netxen_nic_detach_func(adapter);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	if (netxen_nic_wol_supported(adapter)) {
-		pci_enable_wake(pdev, PCI_D3cold, 1);
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-	}
-
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (netxen_nic_wol_supported(adapter))
+		device_wakeup_enable(dev_d);
 
 	return 0;
 }
 
-static int
-netxen_nic_resume(struct pci_dev *pdev)
+static int __maybe_unused
+netxen_nic_resume(struct device *dev_d)
 {
-	return netxen_nic_attach_func(pdev);
+	return netxen_nic_attach_late_func(to_pci_dev(dev_d));
 }
-#endif
 
 static int netxen_nic_open(struct net_device *netdev)
 {
@@ -3448,15 +3444,16 @@ static const struct pci_error_handlers netxen_err_handler = {
 	.slot_reset = netxen_io_slot_reset,
 };
 
+static SIMPLE_DEV_PM_OPS(netxen_nic_pm_ops,
+			 netxen_nic_suspend,
+			 netxen_nic_resume);
+
 static struct pci_driver netxen_driver = {
 	.name = netxen_nic_driver_name,
 	.id_table = netxen_pci_tbl,
 	.probe = netxen_nic_probe,
 	.remove = netxen_nic_remove,
-#ifdef CONFIG_PM
-	.suspend = netxen_nic_suspend,
-	.resume = netxen_nic_resume,
-#endif
+	.driver.pm = &netxen_nic_pm_ops,
 	.shutdown = netxen_nic_shutdown,
 	.err_handler = &netxen_err_handler
 };
-- 
2.27.0

