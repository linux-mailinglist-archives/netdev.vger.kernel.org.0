Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9641B193A14
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCZH7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:59:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36644 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgCZH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:59:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so1843456plo.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RxomeTlZreSiZkANpvkepEqR5xm/1fzp6mqM+OEneCY=;
        b=Ga/u/sGR5yyuyoWpFCcNidp3msOr0xYNQpUBpyIP5d6xEMRsf3LRC7nJSm2Qv3Qwjs
         o1DWprytB4kCro7s29ZDF+BWuRQO/NyH6PVw4zHFU7Sm6/cMQetBA2r0sfrb5wHLG2nV
         qmjmP0ii5M411oAMPp9x9UVj8qv0xcgkJPZgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RxomeTlZreSiZkANpvkepEqR5xm/1fzp6mqM+OEneCY=;
        b=Gg/zTNeBDmlNruzxrM6Nwz2luJEY/f+TtVLQMJfcrR9/vseGrfA6VEnmk6Bi+g/m+j
         pxZLMdJBgYFjP89jGhYjW1QslggP/xJHO4DVai2LTGyBNwVQBMunKWDRU6vXX//+yCAw
         IjAQV1SsuKfbstZ4zuaZibgjQsVmZKQhjC53cwWR1Bx76ewNPEPJxJ8ULfECalcZil8K
         r0Uf/CPgXfnHVCs17e3EKseMXNZDW4XMDCVFACtSZJomkJIwfG4D1lTdl+mZG67HFCET
         nnhHyYc/qxi5jw1KhOh5/UcFY/QrTiR1YFsRLMUD4XvqXIxKVR3MSMqpeYDIgOZ7/e8X
         3GaQ==
X-Gm-Message-State: ANhLgQ3aYZnf0uNorK6HXKLjcSuduWMlnBYKgXK6kJNBVm252ek4xmkR
        ciT0idf9pN60grCGCt2B1Sa4NA==
X-Google-Smtp-Source: ADFU+vsG13qcQw5Qvy86YrL9soselJefcwx8r59FOMkfXhKhuVy612zraOJIGAc6aac/g6yIQiNhYg==
X-Received: by 2002:a17:90a:2dc2:: with SMTP id q2mr1759548pjm.146.1585209586936;
        Thu, 26 Mar 2020 00:59:46 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id 8sm1036476pfv.65.2020.03.26.00.59.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 00:59:46 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/2] Bluetooth: btusb: Indicate Microsoft vendor extension for Intel 9460/9560 and 9160/9260
Date:   Thu, 26 Mar 2020 00:59:37 -0700
Message-Id: <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326075938.65053-1-mcchou@chromium.org>
References: <20200326075938.65053-1-mcchou@chromium.org>
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
about the extension. This was verified with Intel ThunderPeak BT controller
where msft_vnd_ext_opcode is 0xFC1E.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v3:
- Create net/bluetooth/msft.c with struct msft_vnd_ext defined internally
and change the hdev->msft_ext field to void*.
- Define and expose msft_vnd_ext_set_opcode() for btusb use.
- Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev().

 drivers/bluetooth/btusb.c        | 10 ++++++++--
 include/net/bluetooth/hci_core.h |  4 ++++
 net/bluetooth/hci_core.c         | 25 +++++++++++++++++++++++++
 net/bluetooth/msft.c             | 25 +++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 net/bluetooth/msft.c

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3bdec42c9612..f9ce35f1be58 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_CW6622		0x100000
 #define BTUSB_MEDIATEK		0x200000
 #define BTUSB_WIDEBAND_SPEECH	0x400000
+#define BTUSB_MSFT_VND_EXT	0x800000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -335,7 +336,8 @@ static const struct usb_device_id blacklist_table[] = {
 
 	/* Intel Bluetooth devices */
 	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW |
-						     BTUSB_WIDEBAND_SPEECH },
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_MSFT_VND_EXT },
 	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW |
@@ -348,7 +350,8 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW |
-						     BTUSB_WIDEBAND_SPEECH },
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_MSFT_VND_EXT },
 
 	/* Other Intel Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
@@ -3800,6 +3803,9 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
+
+		if (id->driver_info & BTUSB_MSFT_VND_EXT)
+			msft_vnd_ext_set_opcode(hdev, 0xFC1E);
 	}
 
 	if (id->driver_info & BTUSB_MARVELL)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d4e28773d378..7dc5a1d00a87 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -414,6 +414,8 @@ struct hci_dev {
 	void			*smp_data;
 	void			*smp_bredr_data;
 
+	void			*msft_ext;
+
 	struct discovery_state	discovery;
 
 	int			discovery_old_state;
@@ -1658,6 +1660,8 @@ void hci_le_start_enc(struct hci_conn *conn, __le16 ediv, __le64 rand,
 void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			       u8 *bdaddr_type);
 
+void msft_vnd_ext_set_opcode(struct hci_dev *hdev, u16 opcode);
+
 #define SCO_AIRMODE_MASK       0x0003
 #define SCO_AIRMODE_CVSD       0x0000
 #define SCO_AIRMODE_TRANSP     0x0003
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..286294540bed 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -44,6 +44,7 @@
 #include "hci_debugfs.h"
 #include "smp.h"
 #include "leds.h"
+#include "msft.c"
 
 static void hci_rx_work(struct work_struct *work);
 static void hci_cmd_work(struct work_struct *work);
@@ -3269,6 +3270,19 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	}
 }
 
+/* This function sets the opcode of Microsoft vendor extension */
+void msft_vnd_ext_set_opcode(struct hci_dev *hdev, u16 opcode)
+{
+	struct msft_vnd_ext *msft_ext;
+
+	if (!hdev || !hdev->msft_ext)
+		return;
+
+	msft_ext = (struct msft_vnd_ext *)hdev->msft_ext;
+	msft_ext->opcode = opcode;
+}
+EXPORT_SYMBOL(msft_vnd_ext_set_opcode);
+
 static int hci_suspend_wait_event(struct hci_dev *hdev)
 {
 #define WAKE_COND                                                              \
@@ -3360,6 +3374,7 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 struct hci_dev *hci_alloc_dev(void)
 {
 	struct hci_dev *hdev;
+	struct msft_vnd_ext *msft_ext;
 
 	hdev = kzalloc(sizeof(*hdev), GFP_KERNEL);
 	if (!hdev)
@@ -3408,6 +3423,14 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->auth_payload_timeout = DEFAULT_AUTH_PAYLOAD_TIMEOUT;
 	hdev->min_enc_key_size = HCI_MIN_ENC_KEY_SIZE;
 
+	msft_ext = kzalloc(sizeof(*msft_ext), GFP_KERNEL);
+	if (!msft_ext) {
+		kfree(hdev);
+		return NULL;
+	}
+	msft_ext->opcode = HCI_OP_NOP;
+	hdev->msft_ext = (void*)msft_ext;
+
 	mutex_init(&hdev->lock);
 	mutex_init(&hdev->req_lock);
 
@@ -3459,6 +3482,8 @@ EXPORT_SYMBOL(hci_alloc_dev);
 /* Free HCI device */
 void hci_free_dev(struct hci_dev *hdev)
 {
+	kfree(hdev->msft_ext);
+
 	/* will free via device release */
 	put_device(&hdev->dev);
 }
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
new file mode 100644
index 000000000000..c7ede27095be
--- /dev/null
+++ b/net/bluetooth/msft.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+// BlueZ - Bluetooth protocol stack for Linux
+// Copyright (C) 2020 Google Corporation
+//
+// This program is free software; you can redistribute it and/or modify
+// it under the terms of the GNU General Public License version 2 as
+// published by the Free Software Foundation;
+//
+// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
+// IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
+// CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
+// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+//
+// ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
+// COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
+// SOFTWARE IS DISCLAIMED.
+
+struct msft_vnd_ext {
+	__u16	opcode;
+};
-- 
2.24.1

