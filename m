Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC73223A0C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGQLNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgGQLNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 07:13:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97BEC061755;
        Fri, 17 Jul 2020 04:13:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn17so6362101pjb.4;
        Fri, 17 Jul 2020 04:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5ev4kSW5JconVc7T0PCVCRRJqkXlELXzdrdZpOZiik=;
        b=Wk8gyhJq96IdJCvhyLK1uyhGpcJjdrYwD611D52OjTZdPK91knxyCh9dt+FWxcNegd
         /byOQjg0kClwM71dIgvQdj+DxK81Hz02yLWaXA+bAgIR1Aoc9LqD6qOpq16yNZhEJOBx
         cys2gHmNjYb6l1pa/WrcNoBbSvZthEZLYVBvzeBaf+hK+b/nPsNLl/VU6KRR6CQNNOtC
         W5L7426YxQ7MSrxfb8GGlmElvHQk7NanwUh0Kg2o90/yc/5Qe51gbSkNfuy7eNw1Jvao
         Rm2hpZI1OcNKjGPlBwb81QLATPomE26gmoUN7fsM6nSsIFN4C6x0VAdzMw7Pz3h0R9M9
         cHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5ev4kSW5JconVc7T0PCVCRRJqkXlELXzdrdZpOZiik=;
        b=M8Ir80hNq2CEbO+OjJ7l/3249d9AOw6I9bNX/7FYF5moT/TZZuJoCF39mvW/f1bs7A
         CMlsznpZ/x9o90bbIvosCW4CMRa9muOlugdwRoS4Pnq0/ZxNqyJPvUeqvvY0I8ZQdvE8
         F3Evf0D3jGu4TTBJB5HfX7K6rXQ7me46JJJ+e9I7Fe6z7ZsU6E92AvwO8WtqbFmUObIB
         Hr8h78TLjBjkjWpexlikMOz55pLnu0dBQG+J0TxLdokgqFiw+7NA711wDgHe13e9LrW6
         bwT9OTHpY5JXWkhnofKklyvqV01dqm1n1GG8DbcnFhQ7gUj/asWFklxh0dVBAYYy5j5y
         Rzag==
X-Gm-Message-State: AOAM530y0EWL3V2zu5URpVppS+AxbfrD+/COsYIgr24bSmecQY9u2YJY
        BCAWiaMUjwMEfP0kgAEMRHM=
X-Google-Smtp-Source: ABdhPJy98PvG5QSn5Hcy/KgkwC7hJsK9RQcDe4mNCIdLMeWeFqmLzWHlLgUHdHdJ0J+LvyzYC4l3OQ==
X-Received: by 2002:a17:90b:2350:: with SMTP id ms16mr9830611pjb.224.1594984418730;
        Fri, 17 Jul 2020 04:13:38 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id 66sm7920694pfa.92.2020.07.17.04.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 04:13:37 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] ralink/rt2x00: pci: use generic power management
Date:   Fri, 17 Jul 2020 16:39:29 +0530
Message-Id: <20200717110928.454867-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using legacy PM have to manage PCI states and device's PM states
themselves. They also need to take care of configuration registers.

With improved and powerful support of generic PM, PCI Core takes care of
above mentioned, device-independent, jobs.

The callbacks make use of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device() and
pci_set_power_state() to do required operations. In generic mode, they are
no longer needed.

Change function parameter in both .suspend() and .resume() to
"struct device*" type. Use dev_get_drvdata() to get drv data.

The .suspend() callback is invoking rt2x00lib_suspend() which needs to be
modified as generic rt2x00pci_suspend() has no pm_message_t type argument,
passed to it, which is required by it according to its declaration.
Although this variable remained unused in the function body. Hence, remove
it from the function definition & declaration.

rt2x00lib_suspend() is also invoked by rt2x00usb_suspend() and
rt2x00soc_suspend(). Thus, modify the functional call accordingly in their
function body.

Earlier, .suspend() & .resume() were exported and were used by the
following drivers:
    - drivers/net/wireless/ralink/rt2x00/rt2400pci.c
    - drivers/net/wireless/ralink/rt2x00/rt2500pci.c
    - drivers/net/wireless/ralink/rt2x00/rt2800pci.c
    - drivers/net/wireless/ralink/rt2x00/rt61pci.c

Now, we only need to bind "struct dev_pm_ops" variable to
"struct pci_driver". Thus, make the callbacks static. Declare an
"extern const struct dev_pm_ops" variable and bind PM callbacks to it. Now,
export the variable instead and use it in respective drivers.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/wireless/ralink/rt2x00/rt2400pci.c    |  3 +-
 .../net/wireless/ralink/rt2x00/rt2500pci.c    |  3 +-
 .../net/wireless/ralink/rt2x00/rt2800pci.c    |  3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  5 ++-
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  4 +--
 .../net/wireless/ralink/rt2x00/rt2x00pci.c    | 31 +++++--------------
 .../net/wireless/ralink/rt2x00/rt2x00pci.h    |  9 ++----
 .../net/wireless/ralink/rt2x00/rt2x00soc.c    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  |  3 +-
 10 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 4d44509e2ce3..c1ac933349d1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1834,8 +1834,7 @@ static struct pci_driver rt2400pci_driver = {
 	.id_table	= rt2400pci_device_table,
 	.probe		= rt2400pci_probe,
 	.remove		= rt2x00pci_remove,
-	.suspend	= rt2x00pci_suspend,
-	.resume		= rt2x00pci_resume,
+	.driver.pm	= &rt2x00pci_pm_ops,
 };
 
 module_pci_driver(rt2400pci_driver);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 4620990a94cf..0859adebd860 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -2132,8 +2132,7 @@ static struct pci_driver rt2500pci_driver = {
 	.id_table	= rt2500pci_device_table,
 	.probe		= rt2500pci_probe,
 	.remove		= rt2x00pci_remove,
-	.suspend	= rt2x00pci_suspend,
-	.resume		= rt2x00pci_resume,
+	.driver.pm	= &rt2x00pci_pm_ops,
 };
 
 module_pci_driver(rt2500pci_driver);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 3868c07672bd..9a33baaa6184 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -455,8 +455,7 @@ static struct pci_driver rt2800pci_driver = {
 	.id_table	= rt2800pci_device_table,
 	.probe		= rt2800pci_probe,
 	.remove		= rt2x00pci_remove,
-	.suspend	= rt2x00pci_suspend,
-	.resume		= rt2x00pci_resume,
+	.driver.pm	= &rt2x00pci_pm_ops,
 };
 
 module_pci_driver(rt2800pci_driver);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index ea8a34ecae14..ecc60d8cbb01 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1487,9 +1487,8 @@ bool rt2x00mac_tx_frames_pending(struct ieee80211_hw *hw);
  */
 int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev);
-#ifdef CONFIG_PM
-int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state);
+
+int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev);
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev);
-#endif /* CONFIG_PM */
 
 #endif /* RT2X00_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 7f9e43a4f805..8c6d3099b19d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1556,8 +1556,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 /*
  * Device state handlers
  */
-#ifdef CONFIG_PM
-int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
+int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev)
 {
 	rt2x00_dbg(rt2x00dev, "Going to sleep\n");
 
@@ -1614,7 +1613,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
-#endif /* CONFIG_PM */
 
 /*
  * rt2x00lib module information.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
index 7f9baa94c7c8..cabeef0dde45 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
@@ -169,39 +169,24 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_remove);
 
-#ifdef CONFIG_PM
-int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int __maybe_unused rt2x00pci_suspend(struct device *dev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int retval;
-
-	retval = rt2x00lib_suspend(rt2x00dev, state);
-	if (retval)
-		return retval;
 
-	pci_save_state(pci_dev);
-	pci_disable_device(pci_dev);
-	return pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
+	return rt2x00lib_suspend(rt2x00dev);
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_suspend);
 
-int rt2x00pci_resume(struct pci_dev *pci_dev)
+static int __maybe_unused rt2x00pci_resume(struct device *dev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	if (pci_set_power_state(pci_dev, PCI_D0) ||
-	    pci_enable_device(pci_dev)) {
-		rt2x00_err(rt2x00dev, "Failed to resume device\n");
-		return -EIO;
-	}
-
-	pci_restore_state(pci_dev);
 	return rt2x00lib_resume(rt2x00dev);
 }
-EXPORT_SYMBOL_GPL(rt2x00pci_resume);
-#endif /* CONFIG_PM */
+
+SIMPLE_DEV_PM_OPS(rt2x00pci_pm_ops, rt2x00pci_suspend, rt2x00pci_resume);
+EXPORT_SYMBOL_GPL(rt2x00pci_pm_ops);
 
 /*
  * rt2x00pci module information.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
index fd955ccaa1e6..27f7b2bd26ea 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
@@ -21,12 +21,7 @@
  */
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops);
 void rt2x00pci_remove(struct pci_dev *pci_dev);
-#ifdef CONFIG_PM
-int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state);
-int rt2x00pci_resume(struct pci_dev *pci_dev);
-#else
-#define rt2x00pci_suspend	NULL
-#define rt2x00pci_resume	NULL
-#endif /* CONFIG_PM */
+
+extern const struct dev_pm_ops rt2x00pci_pm_ops;
 
 #endif /* RT2X00PCI_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
index 596b8a432946..eface610178d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
@@ -130,7 +130,7 @@ int rt2x00soc_suspend(struct platform_device *pdev, pm_message_t state)
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	return rt2x00lib_suspend(rt2x00dev, state);
+	return rt2x00lib_suspend(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00soc_suspend);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 92e9e023c349..e4473a551241 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -886,7 +886,7 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	return rt2x00lib_suspend(rt2x00dev, state);
+	return rt2x00lib_suspend(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_suspend);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d83288bef2fc..eefce76fc99b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -3009,8 +3009,7 @@ static struct pci_driver rt61pci_driver = {
 	.id_table	= rt61pci_device_table,
 	.probe		= rt61pci_probe,
 	.remove		= rt2x00pci_remove,
-	.suspend	= rt2x00pci_suspend,
-	.resume		= rt2x00pci_resume,
+	.driver.pm	= &rt2x00pci_pm_ops,
 };
 
 module_pci_driver(rt61pci_driver);
-- 
2.27.0

