Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C3D72D71
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfGXL1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:27:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35297 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGXL1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:27:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so20825180pfn.2;
        Wed, 24 Jul 2019 04:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I0XF4VBylKiJuexlFja0wIfDveJDuyPSmCn2G0l0UQ8=;
        b=BSxtz4EJ8vFAkfMa+fA7Oga6gTEZT5YCdJB0bEgM14wHU0fBh9IThdiYij5zMDM++T
         3SOJrBt/G2gNs9QZMp7v1CWllJuuLr0NgDe6jIZIBi0Fih96WupS0d1MLiWjYmNwPxOz
         3I2yBScUq9PeI7N5CLPeVd23agFcIl0qF0NTnPZyoSb2+8sBUtfqy77wEfLF1KV2DjJa
         XR/qWgFDAW6mRfIzK5mMWJuaQM08w9DTWxpU2df1zJ4EE5GUmEPOa2LmGPqB8bn5NB+r
         H3mBB1PtLO3ohV4j5s1j3KCdpfVbFv3LHvyfZcuCeQlLLFiSksn7OySBGDaMklTU3rIU
         OJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I0XF4VBylKiJuexlFja0wIfDveJDuyPSmCn2G0l0UQ8=;
        b=VcQkrnQnUHtI99LHDnmHoJFKl1URfl6ywfnXTFFO+ofB+4baUz1OnAEPyzIWtIXAUh
         m3fXLSvd4PhnW3HbaAru8ipgzUlIYdC5FgFnbL8EVy6bvNslTa/TYx+OBdGRjiYVe+0S
         jNREYuKXafjm9o58xo5FfNoNpuspczPubq9AHOOJH2WlRpeV7wxAEPHv14bv6BYt0e0l
         lEiEBTxFCE7T8M8bo2DuuweADOj1D71C/RCN0/stEjGkGCJVEnfUncNuMjFJmX/SYRYn
         7jSoGuZYhoqaUxo7ri59B7MvNRYpZ0wc8Z9cOdE7ZK8QTx6z0n4hjnyIGUt24d0qxkFw
         c5MA==
X-Gm-Message-State: APjAAAXom/hQkXTkx0qyXQECBZTDrMCnbaaTjAqaXDNR8a32LHSR3EkM
        KSQJuulgr9shPCPHKfOJcMf4BICiw68=
X-Google-Smtp-Source: APXvYqwARX7E+99nfnXJK0Hji9I8FHhbcYJAC1X15/eXPqkO3RP5rl0BOxIFmzpJPj9bM3TA9c20rw==
X-Received: by 2002:a62:e801:: with SMTP id c1mr10923813pfi.41.1563967624201;
        Wed, 24 Jul 2019 04:27:04 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id i124sm85043051pfe.61.2019.07.24.04.27.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:03 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 03/10] sfc: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:26:58 +0800
Message-Id: <20190724112658.13241-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c |  4 ++--
 drivers/net/ethernet/sfc/efx.c  | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 16d6952c312a..0ec13f520e90 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -508,7 +508,7 @@ static ssize_t efx_ef10_show_link_control_flag(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n",
 		       ((efx->mcdi->fn_flags) &
@@ -520,7 +520,7 @@ static ssize_t efx_ef10_show_primary_flag(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n",
 		       ((efx->mcdi->fn_flags) &
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index ab58b837df47..2fef7402233e 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2517,7 +2517,7 @@ static struct notifier_block efx_netdev_notifier = {
 static ssize_t
 show_phy_type(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", efx->phy_type);
 }
 static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
@@ -2526,7 +2526,7 @@ static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
 static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
@@ -2534,7 +2534,7 @@ static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
 static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
 	bool enable = count > 0 && *buf != '0';
 
@@ -3654,7 +3654,7 @@ static int efx_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
 
 static int efx_pm_freeze(struct device *dev)
 {
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 
 	rtnl_lock();
 
@@ -3675,7 +3675,7 @@ static int efx_pm_freeze(struct device *dev)
 static int efx_pm_thaw(struct device *dev)
 {
 	int rc;
-	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct efx_nic *efx = dev_get_drvdata(dev);
 
 	rtnl_lock();
 
-- 
2.20.1

