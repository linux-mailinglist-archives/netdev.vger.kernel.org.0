Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC36526AC98
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgIOSwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgIORXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:23:40 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A24C0611BE;
        Tue, 15 Sep 2020 10:11:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so4123736wrp.8;
        Tue, 15 Sep 2020 10:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wSjHquXGGSBRC1E8BzsuQPA5XSPZNn6B9qBviuWtzU8=;
        b=dc7+0GoEGYY/tzYR9c8tmPWtUTnOI7+/PDYINWv5clIJ8xeznxRVTT/mRrYcmYNXaq
         zkBgxmoEKVb977Ybh0jBVM3vw89HByHP4jvRMH8kqvccGWa8F9O3kbpShKrmC54RLYqe
         /7ROJX+54c8vhDujXNxwjyPHjhNVTr4vfKOqkN/tWtlywaErfnB28XvNMmeoKCgrmzQ2
         Bg/vW83uOeYMkuia6ZZPjLQ45nQhZSgB/JgjkrqI+lePBiryIRxa3wcd0O4DCKl6uXYy
         ci306/S1J2zPJ6OCM6jeD5hqRyNVBbVRIOjHHn0YGpEceyeARk/oMpadJAiydo6yKLxF
         nM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wSjHquXGGSBRC1E8BzsuQPA5XSPZNn6B9qBviuWtzU8=;
        b=N//buv3S5xrcR0pGgitWc9Jf1uQYYjKbasFM7ORRZVgl3VmFdQSqD7wB9FUq+DkGBK
         9+67Syjmwlt6PsgdraGWJlHnZaatp8wJhzovpBUse0SlhpW0Fpcefdc5oeyZQTRcC72t
         PVqjAvBKWexXoMnbK8rGB9F/y7EWpW6iYLgJTVK7r+V5uktf8Buk8ajd8hARAucze1E8
         7Wzm/axaczk5RGoT5G18p9kcqukaW0t001HEQgKPeRXW8EvuxJDpgVx3pglsc9r0LEwv
         hf2lwEzG7r6jdvBmtNiw8vZX4wD6w9PqyTkz7GW1keOptCLBVNi2RtqNZ6JI6/ju4jxU
         ixxQ==
X-Gm-Message-State: AOAM533feB2nGepnMNC83uRUO1skCqowRkL1rNM/JsaF5hzTr5h19dqu
        NudIRkH66HfSoR7cM1mGBx3SYcocCp+Y+Q==
X-Google-Smtp-Source: ABdhPJx/KjL9B2S2zYL5Yr8Sfkw0m5yRqeXuyY/k7LYjaUj4mOXgctYfAnXvE0NbD7YLfHY7FKn38A==
X-Received: by 2002:adf:f24f:: with SMTP id b15mr24145845wrp.301.1600189861432;
        Tue, 15 Sep 2020 10:11:01 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:11:00 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 13/14] habanalabs/gaudi: support DCB protocol
Date:   Tue, 15 Sep 2020 20:10:21 +0300
Message-Id: <20200915171022.10561-14-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add DCB support to configure the NIC's Priority Flow Control (PFC).
The added support is minimal because a full support is not
currently required.

A summary of the supported callbacks:

- ieee_getpfc: get the current PFC configuration. PFC is enabled by
               default.
- ieee_setpfc: set PFC configuration. Only 0 or all 4 priorities can be
               enabled, no subset is allowed.
- getdcbx: get DCBX capability.
- setdcbx: set DCBX capability. Only host LLDP agent and IEEE protocol
           flavors are supported.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/gaudi/Makefile        |   2 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     |   3 +
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   | 108 ++++++++++++++++++
 3 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c

diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index df674c5973e0..0345c91c40f8 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -3,4 +3,4 @@ HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
 HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o \
-	gaudi/gaudi_nic_ethtool.o
+	gaudi/gaudi_nic_ethtool.o gaudi/gaudi_nic_dcbnl.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index c97e5f0e1c53..83d369ffbd89 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -2779,6 +2779,9 @@ static int port_register(struct hl_device *hdev, int port)
 
 	ndev->netdev_ops = &gaudi_nic_netdev_ops;
 	ndev->ethtool_ops = &gaudi_nic_ethtool_ops;
+#ifdef CONFIG_DCB
+	ndev->dcbnl_ops = &gaudi_nic_dcbnl_ops;
+#endif
 	ndev->watchdog_timeo = NIC_TX_TIMEOUT;
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = NIC_MAX_MTU;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c b/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
new file mode 100644
index 000000000000..87394f50400a
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+
+#define PFC_PRIO_NUM		4
+#define PFC_PRIO_MASK_ALL	GENMASK(PFC_PRIO_NUM - 1, 0)
+#define PFC_PRIO_MASK_NONE	0
+#define PFC_STAT_TX_OFFSET	17
+#define PFC_STAT_RX_OFFSET	27
+
+#ifdef CONFIG_DCB
+static int gaudi_nic_dcbnl_ieee_getpfc(struct net_device *netdev,
+					struct ieee_pfc *pfc)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int rc = 0, i, tx_idx, rx_idx;
+	u32 port = gaudi_nic->port;
+
+	if (disabled_or_in_reset(gaudi_nic)) {
+		dev_info_ratelimited(hdev->dev,
+				"port %d is in reset, can't get PFC", port);
+		return -EBUSY;
+	}
+
+	pfc->pfc_en = gaudi_nic->pfc_enable ? PFC_PRIO_MASK_ALL :
+							PFC_PRIO_MASK_NONE;
+	pfc->pfc_cap = PFC_PRIO_NUM;
+
+	for (i = 0 ; i < PFC_PRIO_NUM ; i++) {
+		tx_idx = PFC_STAT_TX_OFFSET + i;
+		rx_idx = PFC_STAT_RX_OFFSET + i;
+
+		pfc->requests[i] = gaudi_nic_read_mac_stat_counter(hdev, port,
+								tx_idx, false);
+		pfc->indications[i] = gaudi_nic_read_mac_stat_counter(hdev,
+							port, rx_idx, true);
+	}
+
+	return rc;
+}
+
+static int gaudi_nic_dcbnl_ieee_setpfc(struct net_device *netdev,
+					struct ieee_pfc *pfc)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	u8 curr_pfc_en;
+
+	if (pfc->pfc_en & ~PFC_PRIO_MASK_ALL) {
+		dev_info_ratelimited(hdev->dev,
+					"PFC supports %d priorities only, port %d\n",
+					PFC_PRIO_NUM, port);
+		return -EINVAL;
+	}
+
+	if ((pfc->pfc_en != PFC_PRIO_MASK_NONE) &&
+			(pfc->pfc_en != PFC_PRIO_MASK_ALL)) {
+		dev_info_ratelimited(hdev->dev,
+					"PFC should be enabled/disabled on all priorities, port %d\n",
+					port);
+		return -EINVAL;
+	}
+
+	if (disabled_or_in_reset(gaudi_nic)) {
+		dev_info_ratelimited(hdev->dev,
+				"port %d is in reset, can't set PFC", port);
+		return -EBUSY;
+	}
+
+	curr_pfc_en = gaudi_nic->pfc_enable ? PFC_PRIO_MASK_ALL :
+							PFC_PRIO_MASK_NONE;
+
+	if (pfc->pfc_en == curr_pfc_en)
+		return 0;
+
+	gaudi_nic->pfc_enable = !gaudi_nic->pfc_enable;
+
+	gaudi_nic_set_pfc(gaudi_nic);
+
+	return 0;
+}
+
+static u8 gaudi_nic_dcbnl_getdcbx(struct net_device *netdev)
+{
+	return DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
+}
+
+static u8 gaudi_nic_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
+{
+	return !(mode == (DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE));
+}
+
+const struct dcbnl_rtnl_ops gaudi_nic_dcbnl_ops = {
+	.ieee_getpfc	= gaudi_nic_dcbnl_ieee_getpfc,
+	.ieee_setpfc	= gaudi_nic_dcbnl_ieee_setpfc,
+	.getdcbx	= gaudi_nic_dcbnl_getdcbx,
+	.setdcbx	= gaudi_nic_dcbnl_setdcbx
+};
+#endif
-- 
2.17.1

