Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921F272D7A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGXL12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:27:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46247 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfGXL11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:27:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so2046102pgk.13;
        Wed, 24 Jul 2019 04:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4DxcTaeexPnaVFulxgnZmsQIq5RlnqnEKxY7Kh+oe0=;
        b=qwp0r4F7dH0xpc0WddOmAfplVDQ5zK5P8BbLITgy9s9y2FpC3kCMw26YiSktTcRBxy
         hExWUt3KxE8WdBpaW+5Ur8bI0HOwoIeonJZURRk/LmkbCEzPfDB0G0T9pUFlak2tAyEG
         jLMfExcEcekrvrTdLe2Yi1CLtET55E3yRp3bxPiMgsNcE57yHzOFs2qLmWOxREL4SWN9
         PiroeMRXnhNjFHOMhM8RzqwQSpLABK8nlAoVedkUal/+KP8j9o+uaIyPzEBz7kj3ItId
         SCELkl8uGEi2hEISgQY4J7Qm2wLQcSRgKSnzP4YOdZc9rhbv9TSzhqAc/HK+qD1PX3+2
         tgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4DxcTaeexPnaVFulxgnZmsQIq5RlnqnEKxY7Kh+oe0=;
        b=Xho/bkursl96M6VB1bHdUqk4oyx6mzGdVQjuh/gmAAGw8ErG5D/2szQwkt/OyWnP7n
         +RC+O2sY6dF8lCyJQb4W905JD6T9tXx6U/ycBTwkGiDE3bW7hX+I/oZkwH1UAqekSmUr
         PWTKrSjFuO1cIh7hbMXgGDmiWghkBepIigEwmTQAjtnSwP6yFgdrwkhKJSClYmStIm+K
         Aj1skb7A/QSc6tQuh1rJVOoOXhBQKQjvpAf0jOxD26hNnheClrLGkyP6nOtVBTUzM2NP
         p55wTIztcy4zFGUAvlzvIRWqBXrDYT5tHHi4l8UZAyHuabopgEvNfGcX6C0jI5GWm0Gj
         IlNA==
X-Gm-Message-State: APjAAAXn0bMuWJ1TXv0wrqth0+6azLwZQfM19lwCO4q8+PBPH3UPE/60
        J86genya+hHdDYOfEswe/uMvhs2cuBE=
X-Google-Smtp-Source: APXvYqycfVcHScdr7+gEN4ivvTtR92ARiffYrtKhWntNt1vy16afr/6LUDhxMyD86Rp7SPmxuO0qxw==
X-Received: by 2002:a17:90a:4f0e:: with SMTP id p14mr84329540pjh.40.1563967647157;
        Wed, 24 Jul 2019 04:27:27 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id f20sm50411675pgg.56.2019.07.24.04.27.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:26 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Maya Erez <merez@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wil6210@qti.qualcomm.com,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 05/10] ath: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:27:20 +0800
Message-Id: <20190724112720.13349-1-hslester96@gmail.com>
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
 drivers/net/wireless/ath/ath5k/pci.c        | 3 +--
 drivers/net/wireless/ath/ath9k/pci.c        | 5 ++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 6 ++----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index c6156cc38940..e1378e203611 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -301,8 +301,7 @@ ath5k_pci_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int ath5k_pci_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
 	struct ath5k_hw *ah = hw->priv;
 
 	ath5k_led_off(ah);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 92b2dd396436..f3461b193c7a 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -1021,13 +1021,12 @@ static void ath_pci_remove(struct pci_dev *pdev)
 
 static int ath_pci_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = dev_get_drvdata(device);
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	if (test_bit(ATH_OP_WOW_ENABLED, &common->op_flags)) {
-		dev_info(&pdev->dev, "WOW is enabled, bypassing PCI suspend\n");
+		dev_info(device, "WOW is enabled, bypassing PCI suspend\n");
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 9f5a914abc18..1b0625987d76 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -631,8 +631,7 @@ static int __maybe_unused wil6210_pm_resume(struct device *dev)
 
 static int __maybe_unused wil6210_pm_runtime_idle(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct wil6210_priv *wil = dev_get_drvdata(dev);
 
 	wil_dbg_pm(wil, "Runtime idle\n");
 
@@ -646,8 +645,7 @@ static int __maybe_unused wil6210_pm_runtime_resume(struct device *dev)
 
 static int __maybe_unused wil6210_pm_runtime_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct wil6210_priv *wil = dev_get_drvdata(dev);
 
 	if (test_bit(wil_status_suspended, wil->status)) {
 		wil_dbg_pm(wil, "trying to suspend while suspended\n");
-- 
2.20.1

