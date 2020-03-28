Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAA6196448
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgC1Hqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:46:47 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44710 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgC1Hqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 03:46:47 -0400
Received: by mail-pf1-f182.google.com with SMTP id b72so5715857pfb.11
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 00:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=udOjHUuVrYhmjpcD3RfPEn/4AJ+kCTCeCAwVdy3cmzE=;
        b=XOTwvg1q2GtN1U/qnPXTCULtOxjsFTkJ+RaYVY3ArtrTo0vWDo+m6lxr2PDmhtJrvI
         n3C+CEOWHRgiHJd6wuP+jDzZvXbSaKaJ9K2cP0nL+3YoMA6kSema8qVVccM3LxGjshvv
         AHTkZZE1Y0+ZtVGSTV+KZRDRY6+n1u3t19Vro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=udOjHUuVrYhmjpcD3RfPEn/4AJ+kCTCeCAwVdy3cmzE=;
        b=rGq5jSgVq52etNhfzETB8EV3zYlkf+/JG/p9NrtMYHNyf4mzpIS1QzPNMcl6hQoEv6
         7xdjqMUTnMnP+aUchXS8orAyu83slwrIIWHYGCkpJN1h+awQ+7qzvwP1T7IjW7o3OQYJ
         Hjm/bh1PMbu14maHPO/4umtrUHuCz3kdwW9kYsea6/+Y0iR6EGHne1SEtBWp/k2p9BpT
         SDfP5Q7aJx7VAi7A1yJr1Irybz6l/qcjRaeMRHgzqGvupT7IPkSxIWVaRZxguo3ypknO
         /fLfrIW+FQVGrqmQkm3tx9NJ8GjwY4wR5kvWzKqG+VEXUfV02CEXaSd4hDGNitgE1T3X
         IFjA==
X-Gm-Message-State: ANhLgQ0kHCDDgsVIuxQZPUYndEb5IayJ5uiHXNZFbTA0o4y1pVps/LYr
        Rfk05++SAJVUStmzxMXRKvshog==
X-Google-Smtp-Source: ADFU+vuoI5eRA0P1Ibj5ZQlZ2Y3DOnCQSgwffpi2rnk6IQnv72+L+YPHyaCxgF6ovW4HFfYzAeF+RQ==
X-Received: by 2002:a63:d709:: with SMTP id d9mr3168715pgg.82.1585381604560;
        Sat, 28 Mar 2020 00:46:44 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id r59sm5273063pjb.45.2020.03.28.00.46.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 00:46:43 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 1/2] Bluetooth: btusb: Indicate Microsoft vendor extension for Intel 9460/9560 and 9160/9260
Date:   Sat, 28 Mar 2020 00:46:31 -0700
Message-Id: <20200328004507.v4.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200328074632.21907-1-mcchou@chromium.org>
References: <20200328074632.21907-1-mcchou@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a bit mask of driver_info for Microsoft vendor extension and
indicates the support for Intel 9460/9560 and 9160/9260. See
https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
microsoft-defined-bluetooth-hci-commands-and-events for more information
about the extension. This also add a kernel config, BT_MSFTEXT, and a
source file to facilitate Microsoft vendor extension functions.
This was verified with Intel ThunderPeak BT controller
where msft_vnd_ext_opcode is 0xFC1E.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v4:
- Introduce CONFIG_BT_MSFTEXT as a starting point of providing a
framework to use Microsoft extension
- Create include/net/bluetooth/msft.h and net/bluetooth/msft.c to
facilitate functions of Microsoft extension.

Changes in v3:
- Create net/bluetooth/msft.c with struct msft_vnd_ext defined internally
and change the hdev->msft_ext field to void*.
- Define and expose msft_vnd_ext_set_opcode() for btusb use.
- Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev().

Changes in v2:
- Define struct msft_vnd_ext and add a field of this type to struct
hci_dev to facilitate the support of Microsoft vendor extension.

 drivers/bluetooth/btusb.c        | 11 +++++++++--
 include/net/bluetooth/hci_core.h |  4 ++++
 net/bluetooth/Kconfig            |  9 ++++++++-
 net/bluetooth/Makefile           |  1 +
 net/bluetooth/msft.c             | 16 ++++++++++++++++
 net/bluetooth/msft.h             | 19 +++++++++++++++++++
 6 files changed, 57 insertions(+), 3 deletions(-)
 create mode 100644 net/bluetooth/msft.c
 create mode 100644 net/bluetooth/msft.h

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3bdec42c9612..0fe47708d3c8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -21,6 +21,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
+#include "../../net/bluetooth/msft.h"
 #include "btintel.h"
 #include "btbcm.h"
 #include "btrtl.h"
@@ -58,6 +59,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_CW6622		0x100000
 #define BTUSB_MEDIATEK		0x200000
 #define BTUSB_WIDEBAND_SPEECH	0x400000
+#define BTUSB_MSFT_VND_EXT	0x800000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -335,7 +337,8 @@ static const struct usb_device_id blacklist_table[] = {
 
 	/* Intel Bluetooth devices */
 	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW |
-						     BTUSB_WIDEBAND_SPEECH },
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_MSFT_VND_EXT },
 	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW |
@@ -348,7 +351,8 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW |
-						     BTUSB_WIDEBAND_SPEECH },
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_MSFT_VND_EXT },
 
 	/* Other Intel Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
@@ -3800,6 +3804,9 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
+
+		if (id->driver_info & BTUSB_MSFT_VND_EXT)
+			msft_set_opcode(hdev, 0xFC1E);
 	}
 
 	if (id->driver_info & BTUSB_MARVELL)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d4e28773d378..239cae2d9998 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -484,6 +484,10 @@ struct hci_dev {
 	struct led_trigger	*power_led;
 #endif
 
+#if IS_ENABLED(CONFIG_BT_MSFTEXT)
+	__u16			msft_opcode;
+#endif
+
 	int (*open)(struct hci_dev *hdev);
 	int (*close)(struct hci_dev *hdev);
 	int (*flush)(struct hci_dev *hdev);
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 165148c7c4ce..5929ccb02b39 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -30,7 +30,7 @@ menuconfig BT
 		L2CAP (Logical Link Control and Adaptation Protocol)
 		SMP (Security Manager Protocol) on LE (Low Energy) links
 	     HCI Device drivers (Interface to the hardware)
-	     RFCOMM Module (RFCOMM Protocol)  
+	     RFCOMM Module (RFCOMM Protocol)
 	     BNEP Module (Bluetooth Network Encapsulation Protocol)
 	     CMTP Module (CAPI Message Transport Protocol)
 	     HIDP Module (Human Interface Device Protocol)
@@ -93,6 +93,13 @@ config BT_LEDS
 	  This option selects a few LED triggers for different
 	  Bluetooth events.
 
+config BT_MSFTEXT
+	bool "Enable Microsoft extensions"
+	depends on BT
+	help
+	  This options enables support for the Microsoft defined HCI
+	  vendor extensions.
+
 config BT_SELFTEST
 	bool "Bluetooth self testing support"
 	depends on BT && DEBUG_KERNEL
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index fda41c0b4781..41dd541a44a5 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -19,5 +19,6 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 bluetooth-$(CONFIG_BT_BREDR) += sco.o
 bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
 bluetooth-$(CONFIG_BT_LEDS) += leds.o
+bluetooth-$(CONFIG_BT_MSFTEXT) += msft.o
 bluetooth-$(CONFIG_BT_DEBUGFS) += hci_debugfs.o
 bluetooth-$(CONFIG_BT_SELFTEST) += selftest.o
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
new file mode 100644
index 000000000000..7609932c48ca
--- /dev/null
+++ b/net/bluetooth/msft.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (C) 2020 Google Corporation */
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include "msft.h"
+
+void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
+{
+	hdev->msft_opcode = opcode;
+
+	bt_dev_info(hdev, "Enabling MSFT extensions with opcode 0x%2.2x",
+		    hdev->msft_opcode);
+}
+EXPORT_SYMBOL(msft_set_opcode);
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
new file mode 100644
index 000000000000..7218ea759dde
--- /dev/null
+++ b/net/bluetooth/msft.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (C) 2020 Google Corporation */
+
+#ifndef __MSFT_H
+#define __MSFT_H
+
+#include <net/bluetooth/hci_core.h>
+
+#if IS_ENABLED(CONFIG_BT_MSFTEXT)
+
+void msft_set_opcode(struct hci_dev *hdev, __u16 opcode);
+
+#else
+
+static inline void msft_set_opcode(struct hci_dev *hdev, __u16 opcode) {}
+
+#endif
+
+#endif /* __MSFT_H*/
-- 
2.24.1

