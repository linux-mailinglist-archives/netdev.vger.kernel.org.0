Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8605E1757D0
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 10:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCBJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 04:59:18 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56099 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBJ7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 04:59:17 -0500
Received: by mail-pj1-f68.google.com with SMTP id a18so4212330pjs.5
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 01:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CpvIzq/GXLZAstxTnpEFuhRMZ+4nIRadjbjhOg0PRiI=;
        b=bYVHKiVuVAxlAn3J2dPclBhtIa6kdRd7PFcBHaHBYBCs3Nf8Kh3k8O9su3PSomRwv2
         MvCpZilvQP4IjK8vb9AH5M+xZqBIKxRBwPAWOwBGfANzWS/TsaKwmcwSM6VOQcQYzgqG
         Bu6OVR7suCUzKHxtteYg7VczxfsWkDlInIGOwnuv34i932kJ5aNn9YH8GXq5Duig3p3p
         6088ii5aR/LZdrVpzF1Zn2iNG3gW1IVKODEKsxfBfvtUUBRJ75PILh+XIiQ2NJW3NsQT
         sraxBPVmSMjAScBhWnSh2DWWR3EkE/G4sNYPn94oBWjnWyRFJJOmAIrcij4jtld4T6kh
         2tWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CpvIzq/GXLZAstxTnpEFuhRMZ+4nIRadjbjhOg0PRiI=;
        b=M/m1k6/DfFNUdAk3o2qhikD6Lx0aFsUCHykQekORk5XnRFQ9Pi+EtHNG7JW2EyMP7B
         YNWvKzqIZTAgKBb88AmOsI8H4nu6dXDXgEtFB77+WJWdXKFNlcAFyH2sout9WeANJ8Pm
         Mg3yUen6wNmhxmcDdiIdS7N1ZPnppczDHDUDTOK3m2tlOK0SdHSo+ZAZZRQYVh9ismpc
         yL5oF31PUuCvZSOCM/VQNR0iihfhkdEYVs0uKzNJmLNWTZ6EoH6PW+hOOQ/qv50M2R8p
         XllmHWPv+L3D8PNlacWwRKydOaaYNTxxcvlwkXFitODx4CYswpftxvZQbWW4Di/pdl0/
         eaeA==
X-Gm-Message-State: APjAAAU3UAtvWPerZM7Rpsbrmd0gKXmt9FCg7ITWiIzTocpZBydUorH5
        hsxNN/1jWqPvaIGDu9+X/DD53M4rLXM=
X-Google-Smtp-Source: APXvYqz6zeSQ8hfjqS/Ir7k8ujr5RAVg08bIRstiwQ5dgX9mM2tilebKVu4OafusMMRw0XR8/pIs7Q==
X-Received: by 2002:a17:902:9a85:: with SMTP id w5mr16986939plp.290.1583143156273;
        Mon, 02 Mar 2020 01:59:16 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z13sm20564307pge.29.2020.03.02.01.59.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Mar 2020 01:59:15 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Prakash Brahmajyosyula <bprakash@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 3/3] net: cavium: Register driver with PCI subsys IDs
Date:   Mon,  2 Mar 2020 15:29:02 +0530
Message-Id: <1583143142-7958-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prakash Brahmajyosyula <bprakash@marvell.com>

Across Cavium's ThunderX and Marvell's OcteonTx2 silicons
the PTP timestamping block's PCI device ID and vendor ID
have remained same but the HW architecture has changed.

Hence added PCI subsystem IDs to the device table to avoid
this driver from being probed on OcteonTx2 silicons.

Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/cavium/common/cavium_ptp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/common/cavium_ptp.c b/drivers/net/ethernet/cavium/common/cavium_ptp.c
index b821c9e..81ff9ac 100644
--- a/drivers/net/ethernet/cavium/common/cavium_ptp.c
+++ b/drivers/net/ethernet/cavium/common/cavium_ptp.c
@@ -13,6 +13,9 @@
 #define DRV_NAME "cavium_ptp"
 
 #define PCI_DEVICE_ID_CAVIUM_PTP	0xA00C
+#define PCI_SUBSYS_DEVID_88XX_PTP	0xA10C
+#define PCI_SUBSYS_DEVID_81XX_PTP	0XA20C
+#define PCI_SUBSYS_DEVID_83XX_PTP	0xA30C
 #define PCI_DEVICE_ID_CAVIUM_RST	0xA00E
 
 #define PCI_PTP_BAR_NO	0
@@ -321,7 +324,12 @@ static void cavium_ptp_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id cavium_ptp_id_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_CAVIUM_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_CAVIUM_PTP,
+			PCI_VENDOR_ID_CAVIUM, PCI_SUBSYS_DEVID_88XX_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_CAVIUM_PTP,
+			PCI_VENDOR_ID_CAVIUM, PCI_SUBSYS_DEVID_81XX_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_CAVIUM_PTP,
+			PCI_VENDOR_ID_CAVIUM, PCI_SUBSYS_DEVID_83XX_PTP) },
 	{ 0, }
 };
 
-- 
2.7.4

