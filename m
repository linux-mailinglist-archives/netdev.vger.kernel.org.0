Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5E3D0F27
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhGUMTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhGUMT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 08:19:29 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58F9C061574;
        Wed, 21 Jul 2021 06:00:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f190so1269309wmf.4;
        Wed, 21 Jul 2021 06:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dSqJAOlSxZ15myCAkE3t0lhY1ZlRYiFCDX+JzW8ZRDA=;
        b=nOgNsDCL6wc9pRUlqpN6unXU3aVQqr4x+E2FR4N+q0wSAh2lq2sak70YQr2Tx1sXUH
         GRriCKrwBNWtCJ5D0jAv8iPNIvFEHjyhsP/i8HetZcOeMXfsFc2SbgsQW2R6dZPDFZvP
         dJhMSOZZhKXELovAa2EX0a1g5fQrQuDa12cq9FZ2EjD5MgsegYyzon/Gi/CBTU5vy+BX
         dhHQxtJ30KXQZ/1m+Wyp9c8Pgau9lDXjW8swo06UT4+UkS5NPjkIz6PJacf/4FgcwZla
         GNYX5fKbAP5+hPanppHD861o8aw2nTmIORMPg6GkbUKkJ/qWjARZimEKXWjR8Qvk12kI
         pZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSqJAOlSxZ15myCAkE3t0lhY1ZlRYiFCDX+JzW8ZRDA=;
        b=S3kD3G5i9aA+yT0oTwWTRXKyk1ur58pmg5GFrxCvY/trNv8PWJJQz0Zj6CPDlAAZfS
         RI2Yc5QcwteWzbPeOdD3R9x1KSI1dWRgryYLxbJ0K1udrIILcxRiRjARa/l1FKF5r/wh
         JSvDbI7psO9+5/CNrZGTEj/LHewpBfJxQUsht+YPwskiZDCLWx5vzmwXJn0oW3TPKQ8D
         oIOLCNh7e/KtYPm0FpRkqWheaN0DBuX3QdYymCoR1WcLjW1WTsaQjNIr2mJrhVzeN192
         c5q6wdQKr3QvUw/DjuGBvoEpQdafliEdrw0Tbj+C1n6SMJK0fs4H0JdP5PkEIR4HvWVF
         uUyA==
X-Gm-Message-State: AOAM533xIbqO8AxoTz2wRhEu93g8AdKr8AmKtyjNy23+aXG/pjkmpA1C
        RD36hTM0zxaUcFCqgXeg1lI=
X-Google-Smtp-Source: ABdhPJw6hmIKcrQMErznhiO56awpaW3krRisk7cmmq32dFNmzMH/whGmd1xzOqpWmSsdzfRO/Bj3LA==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr37483562wmj.87.1626872403325;
        Wed, 21 Jul 2021 06:00:03 -0700 (PDT)
Received: from Buzz.nordsys.de ([2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5])
        by smtp.gmail.com with ESMTPSA id q7sm22483733wmq.33.2021.07.21.06.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 06:00:02 -0700 (PDT)
From:   Andre Naujoks <nautsch2@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andre Naujoks <nautsch2@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
Date:   Wed, 21 Jul 2021 14:59:25 +0200
Message-Id: <20210721125926.593283-1-nautsch2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721124048.590426-1-nautsch2@gmail.com>
References: <20210721124048.590426-1-nautsch2@gmail.com>
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

Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
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

