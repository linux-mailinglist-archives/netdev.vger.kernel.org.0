Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E43A6C59
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhFNQth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbhFNQtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:49:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8982CC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 09:47:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o3so15259080wri.8
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 09:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GW2XCDtC9nihSyasB1mX5hXTxCPb+lONVNhPqWjf8dg=;
        b=hIlO7esIZhg47ySU+aFUKHdIZxBpnTPIXSi5hD4gL6sdNkqHO9DQjWWvRS+7OU7s3s
         XV8Q9SbbPta1adgATw4AHrIDYvzhNckhekOIbH5wFsvkwiJneBBRciS1CVV+S1pVF5cz
         ZdQMU+T7RV14t4qLj9zKAncoKqk0sITLWQpy/GaKBHUcdT+cDnCH12n2amzIo2qAfReP
         y5gge5Ew080h/hfT0XBqonugl01TeszEBm6VHdRj3NpUBTc15rfOzIvUOtDI/gn+loVh
         DgsBy2pcJD4YTkwVgGxG4woRsDBlQMYe5LXAi2fVaefvHqNF3oTOI/O5YH08dOBUceQI
         UJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GW2XCDtC9nihSyasB1mX5hXTxCPb+lONVNhPqWjf8dg=;
        b=sGst5Zcov+VWCKjuti+EE9QLUw5wYHaLqcqtfEjmH0iuTh1m1zPIqz8y+I2rG2mMZ5
         +PVQ3T20pLC/5k5c9NvPkqy1n8cHU2JKIL2Xx5ArTASvMDOBus4FfmePBTp3WuL6tMap
         1zVn+dRg6seG/S3DvrU4tZITLuV1fB+oiukoTpFsuxmiRMtYM67W7t21ikef5wsKR+IF
         tcBA5IbB66G5UWqcjTfGrtWECRbTNXUqvuSKm4GwwEIvCF1YOZTpUZ3a8TTahs5wfsan
         BCa5P5kLttXilFrRxr/gZIAdgW6B+d/VVAZtyVddeQrOstd6q3ka801IrTA8UNCtBCW9
         DyMg==
X-Gm-Message-State: AOAM533ONzot5vSMxVICFjBC/m4fuhCng7TC884sHb5A4KlJzBXql5aj
        8ar5cPQKxKBmnXq4CqFnP6RtYw==
X-Google-Smtp-Source: ABdhPJzU5hNFZ9j0/GL0NjSqRfVQmxBh0QLEq/YXMKv3wlI4HISbfFFr/t2F81cz89fTU0bHiBR1DA==
X-Received: by 2002:adf:ed03:: with SMTP id a3mr19886827wro.166.1623689219968;
        Mon, 14 Jun 2021 09:46:59 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id d15sm16307580wri.58.2021.06.14.09.46.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jun 2021 09:46:59 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ryazanov.s.a@gmail.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: wwan: Fix WWAN config symbols
Date:   Mon, 14 Jun 2021 18:56:36 +0200
Message-Id: <1623689796-8740-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is not strong reason to have both WWAN and WWAN_CORE symbols,
Let's build the WWAN core framework when WWAN is selected, in the
same way as for other subsystems.

This fixes issue with mhi_net selecting WWAN_CORE without WWAN and
reported by kernel test robot:

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for WWAN_CORE
   Depends on NETDEVICES && WWAN
   Selected by
   - MHI_NET && NETDEVICES && NET_CORE && MHI_BUS

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/Kconfig       |  2 +-
 drivers/net/wwan/Kconfig  | 17 ++++++-----------
 drivers/net/wwan/Makefile |  2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 30d6e2f..6977f82 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -431,7 +431,7 @@ config VSOCKMON
 config MHI_NET
 	tristate "MHI network driver"
 	depends on MHI_BUS
-	select WWAN_CORE
+	select WWAN
 	help
 	  This is the network driver for MHI bus.  It can be used with
 	  QCOM based WWAN modems (like SDX55).  Say Y or M.
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 13613a4..249b3f1 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -3,15 +3,9 @@
 # Wireless WAN device configuration
 #
 
-menuconfig WWAN
-	bool "Wireless WAN"
-	help
-	  This section contains Wireless WAN configuration for WWAN framework
-	  and drivers.
-
-if WWAN
+menu "Wireless WAN"
 
-config WWAN_CORE
+config WWAN
 	tristate "WWAN Driver Core"
 	help
 	  Say Y here if you want to use the WWAN driver core. This driver
@@ -20,9 +14,10 @@ config WWAN_CORE
 	  To compile this driver as a module, choose M here: the module will be
 	  called wwan.
 
+if WWAN
+
 config WWAN_HWSIM
 	tristate "Simulated WWAN device"
-	depends on WWAN_CORE
 	help
 	  This driver is a developer testing tool that can be used to test WWAN
 	  framework.
@@ -32,7 +27,6 @@ config WWAN_HWSIM
 
 config MHI_WWAN_CTRL
 	tristate "MHI WWAN control driver for QCOM-based PCIe modems"
-	select WWAN_CORE
 	depends on MHI_BUS
 	help
 	  MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
@@ -46,7 +40,6 @@ config MHI_WWAN_CTRL
 
 config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
-	select WWAN_CORE
 	depends on INTEL_IOMMU
 	help
 	  This driver enables Intel M.2 WWAN Device communication.
@@ -57,3 +50,5 @@ config IOSM
 	  If unsure, say N.
 
 endif # WWAN
+
+endmenu
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 3e565d3..83dd348 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the Linux WWAN device drivers.
 #
 
-obj-$(CONFIG_WWAN_CORE) += wwan.o
+obj-$(CONFIG_WWAN) += wwan.o
 wwan-objs += wwan_core.o
 
 obj-$(CONFIG_WWAN_HWSIM) += wwan_hwsim.o
-- 
2.7.4

