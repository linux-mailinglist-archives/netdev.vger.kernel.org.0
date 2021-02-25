Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0563254B0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBYRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:42:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45801 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhBYRlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:41:55 -0500
Received: from 1-171-225-221.dynamic-ip.hinet.net ([1.171.225.221] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1lFKdQ-0007iq-Oa; Thu, 25 Feb 2021 17:41:09 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     bhelgaas@google.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown quirk
Date:   Fri, 26 Feb 2021 01:40:40 +0800
Message-Id: <20210225174041.405739-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210225174041.405739-1-kai.heng.feng@canonical.com>
References: <20210225174041.405739-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we have a generic D3 shutdown quirk, so convert the original
approach to a PCI quirk.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 2 --
 drivers/pci/quirks.c                     | 6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 786a48649946..cddc9b09bb1f 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1709,8 +1709,6 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 
 	if (chip->ops->shutdown)
 		chip->ops->shutdown(rtwdev);
-
-	pci_set_power_state(pdev, PCI_D3hot);
 }
 EXPORT_SYMBOL(rtw_pci_shutdown);
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0a848ef0b7db..dfb8746e3b72 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5627,3 +5627,9 @@ static void pci_fixup_shutdown_d3(struct pci_dev *pdev)
 		pci_set_power_state(pdev, PCI_D3cold);
 }
 DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_AMD, 0x1639, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xd723, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xc821, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xb822, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xb822, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xc822, pci_fixup_shutdown_d3);
+DECLARE_PCI_FIXUP_SHUTDOWN(PCI_VENDOR_ID_REALTEK, 0xc82f, pci_fixup_shutdown_d3);
-- 
2.30.0

