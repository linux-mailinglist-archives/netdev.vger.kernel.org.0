Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FD3192183
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 08:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCYHDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 03:03:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43443 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgCYHDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 03:03:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id u12so698971pgb.10
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=baRu5nsVbDxJSO3oJpwwpT6CsHgG9dJlSyie1x1BQxg=;
        b=X+6oGftgVS9JAs653mjzV4NYBb/WT5sFCMBMu0y+14I2F3DgVsomaBXkL1FET6FMCa
         7JmnihsNxZAXKzxrm5PfIWHMXpOrnX2wLLwX5VQnpXH6RKp2TigiY47CsUXAVZ+QdRMf
         3fos8ickYKt4OUGwh/oGGHrWFI+kpSn64Kfmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=baRu5nsVbDxJSO3oJpwwpT6CsHgG9dJlSyie1x1BQxg=;
        b=cp2j7cYphTy7DbpLTd/7r69A9m1C/0QQBDFF0Ijwja9Ax5TXzQbFsRSCQCynyh2c/K
         KWGinvHzlm6OWAj10OLyukPzPrngdN5XPB+sV+QAMuesROVzu3wBDs6yYx3q8vLXZpZC
         tUToXL80McXsjAd9f7T6b6MViDYFV1ZnUNopNhWPcb9IMcd21tyzSUfUcJODYHbK2z8p
         WoC7ry2qODTEwYTcrLv1bk8nwqMXLKx6pnlGAWgDIggdMLOUR9Hjpa8h2uExk61fcn5c
         xh30KMJtteNdctJzAMCwipywVQiF9tipQdiUaLM7y2jD3j2lPTZ+QL9Vg1f7rujBaW/K
         stKw==
X-Gm-Message-State: ANhLgQ2nZa/tmbJqYTMVtrlw6BGrIOtrGNM8NjTsWoSWVRBdyy8MKLKZ
        yYpXZoISu1ZT97G4V01hTQvUjA==
X-Google-Smtp-Source: ADFU+vuNT9INJ2iEvMa3zIO7zdhHTcpkfnNUr9luK/PfllzQPPC6EssZTNehgCDtbkATdvNjqh7yBQ==
X-Received: by 2002:a63:a54:: with SMTP id z20mr1774834pgk.372.1585119822183;
        Wed, 25 Mar 2020 00:03:42 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id i34sm566240pgm.83.2020.03.25.00.03.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 00:03:41 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] Bluetooth: btusb: Indicate Microsoft vendor extension for Intel 9460/9560 and 9160/9260
Date:   Wed, 25 Mar 2020 00:03:35 -0700
Message-Id: <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200325070336.1097-1-mcchou@chromium.org>
References: <20200325070336.1097-1-mcchou@chromium.org>
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

Changes in v2:
- Define struct msft_vnd_ext and add a field of this type to struct
hci_dev to facilitate the support of Microsoft vendor extension.

 drivers/bluetooth/btusb.c        | 14 ++++++++++++--
 include/net/bluetooth/hci_core.h |  6 ++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3bdec42c9612..4c49f394f174 100644
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
@@ -3734,6 +3737,8 @@ static int btusb_probe(struct usb_interface *intf,
 	hdev->send   = btusb_send_frame;
 	hdev->notify = btusb_notify;
 
+	hdev->msft_ext.opcode = HCI_OP_NOP;
+
 #ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
@@ -3800,6 +3805,11 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
+
+		if (id->driver_info & BTUSB_MSFT_VND_EXT &&
+			(id->idProduct == 0x0025 || id->idProduct == 0x0aaa)) {
+			hdev->msft_ext.opcode = 0xFC1E;
+		}
 	}
 
 	if (id->driver_info & BTUSB_MARVELL)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d4e28773d378..0ec3d9b41d81 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -244,6 +244,10 @@ struct amp_assoc {
 
 #define HCI_MAX_PAGES	3
 
+struct msft_vnd_ext {
+	__u16	opcode;
+};
+
 struct hci_dev {
 	struct list_head list;
 	struct mutex	lock;
@@ -343,6 +347,8 @@ struct hci_dev {
 
 	struct amp_assoc	loc_assoc;
 
+	struct msft_vnd_ext	msft_ext;
+
 	__u8		flow_ctl_mode;
 
 	unsigned int	auto_accept_delay;
-- 
2.24.1

