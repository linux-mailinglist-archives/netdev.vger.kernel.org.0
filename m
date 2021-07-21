Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7ECE3D0EF0
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhGUMBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhGUMBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 08:01:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE95C061574;
        Wed, 21 Jul 2021 05:42:07 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l6so1271808wmq.0;
        Wed, 21 Jul 2021 05:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zpSU1Ov841qsvPoGnhSNRnkLtBuvpxGfmjQdkDkDWo=;
        b=df3hPmm9PmOVkTBbNuqGhWvyR4OmjkOeKdhNDBKhRq8F5vzHxD4i2TBagnOtuYSlmn
         wBdo/ibD9/1c6OcdRVDEcdjWNX3y7nnp41LklKbgdT/mz2Iv2SSLfRgI2lOflRKD7ZqO
         Fdx5CibUmgP0TIKKSJ8BiJGE6iu7MKTkmUuA1Cc8NH3tEjio8k3ZzPCTSLYf5QoGeLOZ
         jxVFb5wPSBW8ka7QpKbN7ivI14ZO1m/81JA/3Ahb/WQYVEF7OAGXbW2SSA23snKhpgQF
         wmSLeY8DpKchoPJxn9WVsfq0gL7lmV8NUATaaIA6ZIJhPXI9zA7XROYHRf1lVEZ9RG6F
         UYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zpSU1Ov841qsvPoGnhSNRnkLtBuvpxGfmjQdkDkDWo=;
        b=gdaNLHAiHJ9usHaqtFyv704VHnNstk/qIc3zS+HhgqevACOUyqEM7Bu8QgDfjaPCbC
         VBahgIhsB4SeKOCUpl9r8AbBpfqoEis2bFqL7bUbXREJ5ATRz15+NrMrJXlaWjBIYgcI
         GkaeVUsiEAVqqKbbUGiAE+cXVD8/JVBQEq2Bfl+xWQkmgEWSTw8DHgy5jmPGW0tw+9jF
         rE0TXYxmbeRlpOyqBjJ/meShwGd+zWGEIclpcRLehIav+X18aShaybqQ/tIYUTWKXuwX
         vTFYJKIV0hvt1AIbtj3zeueFNrt+NAVyif/4sE5XUDME1CbIqz8Krqm02lB06ZHGkfq/
         wBmw==
X-Gm-Message-State: AOAM530ehRFISVXlisZ4tHv1olTJHsLpADy99vEGdtGfW1//lgFHtkrv
        wyh+2nVs7SDV7ho5ZziJhig=
X-Google-Smtp-Source: ABdhPJxx3HQLRz/wWiWInAaQmqxYQMLmTIXULJdPDTBnbKM5ZL70D9tC+HAHPy2Q7hOl1WQM6KH0xQ==
X-Received: by 2002:a05:600c:4f4d:: with SMTP id m13mr3983852wmq.31.1626871326316;
        Wed, 21 Jul 2021 05:42:06 -0700 (PDT)
Received: from Buzz.nordsys.de ([2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5])
        by smtp.gmail.com with ESMTPSA id w15sm1540668wmi.3.2021.07.21.05.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 05:42:05 -0700 (PDT)
From:   Andre Naujoks <nautsch2@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Andre Naujoks <nautsch2@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Expose Peak USB device id in sysfs via phys_port_name.
Date:   Wed, 21 Jul 2021 14:40:47 +0200
Message-Id: <20210721124048.590426-1-nautsch2@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Peak USB CAN adapters can be assigned a device id via the Peak
provided tools (pcan-settings). This id can currently not be set by the
upstream kernel drivers, but some devices expose this id already.

The id can be used for consistent naming of CAN interfaces regardless of
order of attachment or recognition on the system. The classical CAN Peak
USB adapters expose this id via bcdDevice (combined with another value)
on USB-level in the sysfs tree and this value is then available in
ID_REVISION from udev. This is not a feasible approach, when a single
USB device offers more than one CAN-interface, like e.g. the PCAN-USB
Pro FD devices.

This patch exposes those ids via the, up to now unused, netdevice sysfs
attribute phys_port_name as a simple decimal ASCII representation of the
id. phys_port_id was not used, since the default print functions from
net/core/net-sysfs.c output a hex-encoded binary value, which is
overkill for a one-byte device id, like this one.
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index e8f43ed90b72..f6cbb01a58cc 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -408,6 +408,21 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int peak_usb_ndo_get_phys_port_name(struct net_device *netdev,
+					   char *name, size_t len)
+{
+	const struct peak_usb_device *dev = netdev_priv(netdev);
+	int err;
+
+	err = snprintf(name, len, "%u", dev->device_number);
+
+	if (err >= len || err <= 0) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * start the CAN interface.
  * Rx and Tx urbs are allocated here. Rx urbs are submitted here.
@@ -769,6 +784,7 @@ static const struct net_device_ops peak_usb_netdev_ops = {
 	.ndo_stop = peak_usb_ndo_stop,
 	.ndo_start_xmit = peak_usb_ndo_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
+	.ndo_get_phys_port_name = peak_usb_ndo_get_phys_port_name,
 };
 
 /*
-- 
2.32.0

