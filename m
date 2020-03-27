Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DCA195B24
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgC0Qdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:33:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53813 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbgC0Qdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:33:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id b12so12066728wmj.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 09:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=r0tlhX3TANvDbVtQSR4GyapuAe3Bh5PdWjICIuTlxJk=;
        b=J04EPhYFaxCIv6G1osHyEK9EgI8fionzYxxWl1Cv90MWGWG8A23ObcyMLAhTXafBAa
         xhS9DTyqWQCC29kcwJI4vJL/HwM8P9tUhRFd4jDXM3lH5bsl1Pq3BL3BhLwT+FgcVt1l
         9KSIRgjVU8yRsNMiELLZWS9BFD0rMDLrInGyMjT27pQ7seQUe35yyPMi2eQ1VRNg5X8n
         5y7ucyr1j3MwaTwfd8ljGbLJJcipQE9b5JtxEoMpXardFCt7POAVUr9TD1oMYL7Jjhkp
         gYt//mYfTCU4y2M3pKPqjkeSeTo8JrjOhbjEVyD4dqjV+opaI7xC8GmDINVu2pvi5m3g
         /f+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=r0tlhX3TANvDbVtQSR4GyapuAe3Bh5PdWjICIuTlxJk=;
        b=hPSvCxjszh90B45/LGdRfLPnPFkSQ5OtbF6FSttzitND2gacaebfK2+wgYLYF6Zyo+
         btykoEwW9aqM3yHzXKfnbJ1Ue1CgBp/uELrolbxdo8ZWJdTClalrtwmRNc0yGkX5Ujve
         yMUT99MhG+6UlD+Il1Z7Z0aG8l0Xg4yZ62Kdj10DoGgrsqIoPfeDcthp6hOhGOahctvi
         mF2T3DjEnZiwCdfEodAxKJ0Sdo4Qwqf5I++bOWQNXeFnLpmVfBLW8GTsguhyBG3J9Izt
         q5oUlirzbhLck1rKvq381syxaQxF6V0nuWVP3OvA8zwc62WSGg5AEdEbq2p7FogwQzWd
         RtGg==
X-Gm-Message-State: ANhLgQ33S766pnJzxIiRJ+lVDiIf04tgNEYpShmmCMOtQnrgnf4JuyCJ
        p3QpCTKdr5idsWb70uT6KE9Oad0u
X-Google-Smtp-Source: ADFU+vuzpxQlJkkhcDd0jXms3xTcZZP+eWObCzhdm0XNw9uxpE3bsuWjxW6v1qO24RBbe5f4g09Vcg==
X-Received: by 2002:a1c:7e43:: with SMTP id z64mr5930101wmc.45.1585326819978;
        Fri, 27 Mar 2020 09:33:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:9d76:401f:98cb:c084? (p200300EA8F2960009D76401F98CBC084.dip0.t-ipconnect.de. [2003:ea:8f29:6000:9d76:401f:98cb:c084])
        by smtp.googlemail.com with ESMTPSA id j11sm8903408wrt.14.2020.03.27.09.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 09:33:39 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     Chih-Wei Huang <cwhuang@android-x86.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix PHY driver check on platforms w/o module
 softdeps
Message-ID: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
Date:   Fri, 27 Mar 2020 17:33:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Android/x86 the module loading infrastructure can't deal with
softdeps. Therefore the check for presence of the Realtek PHY driver
module fails. mdiobus_register() will try to load the PHY driver
module, therefore move the check to after this call and explicitly
check that a dedicated PHY driver is bound to the PHY device.

Fixes: f32593773549 ("r8169: check that Realtek PHY driver module is loaded")
Reported-by: Chih-Wei Huang <cwhuang@android-x86.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Please apply fix back to 5.4 only. On 4.19 it would break processing.
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a9bdafd15..791d99b9e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5285,6 +5285,13 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	if (!tp->phydev) {
 		mdiobus_unregister(new_bus);
 		return -ENODEV;
+	} else if (!tp->phydev->drv) {
+		/* Most chip versions fail with the genphy driver.
+		 * Therefore ensure that the dedicated PHY driver is loaded.
+		 */
+		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		mdiobus_unregister(new_bus);
+		return -EUNATCH;
 	}
 
 	/* PHY will be woken up in rtl_open() */
@@ -5446,15 +5453,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chipset, region;
 	int jumbo_max, rc;
 
-	/* Some tools for creating an initramfs don't consider softdeps, then
-	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
-	 * PHY driver is used that doesn't work with most chip versions.
-	 */
-	if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		return -ENOENT;
-	}
-
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
 	if (!dev)
 		return -ENOMEM;
-- 
2.26.0

