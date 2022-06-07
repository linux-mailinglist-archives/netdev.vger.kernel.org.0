Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBBA53FA49
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbiFGJtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbiFGJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:48:56 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6975D02A6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:48:33 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso3383374wml.1
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sRVCV675gnSBUjquD4ODK0/V3BjHMt/6L2aovdLYzzw=;
        b=Lk0XjM6q+E1tzEcGDkrVL6x2hoglan7SuEzw9HQPL7Lt082R2AeWgFfPl9bMG2med7
         QX0Z82XrbchUno2FU1kHTdNs9R6Ol+r2OjVL7RhVymZshQ8s3q0TRuTAd6xXC58RTdzQ
         rEf6nwc080bs0VXt8vh2tvDJ/ZdSbCBBRnsto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sRVCV675gnSBUjquD4ODK0/V3BjHMt/6L2aovdLYzzw=;
        b=N8B2i0EBY2W8yWANi0iaCZht6x5xPxnkOhxXGCSe6pj4x1la4z1cj/H3t1TMF1TKjo
         dOILcQthIknJCN6j/YO7ggnLDwpQuD8AikWqzYCHf6VnPSeGcsuIllPyHmbEB0c9tLIr
         fSL7PqffDWMtRU3+aLmD2vMyaDIzmJpDna4rhaglrQSWXlXodE+BFFWDp1we7CZrGKaS
         Xk/JkKs1yMVMegW49rGuaIVonmxVoeXd8s9SLBHe5T5KmahDjjeNQ96Cc1nad0cfCBNd
         M6l+hwlvGEAgRFJnUNbibtDWnjJ+LXxsmWarOX3Xu4Bv2OOA4W5k4/aU2nLUbeV44wTR
         UgOw==
X-Gm-Message-State: AOAM531TQXMKVC1cfZteufK74itCbKykLJbdtMhByLaZRYH9ChLYmwRE
        PVfUjTtgCAoWE6J7BHIemTWswA==
X-Google-Smtp-Source: ABdhPJxSoLPGkXdd3XZe95jFcTaxdc3fJEtk7sLyjK0YsTxMSOCKvVx3USfErQYflpGTcq8ZzYLVMw==
X-Received: by 2002:a05:600c:4f85:b0:398:54fc:ea9b with SMTP id n5-20020a05600c4f8500b0039854fcea9bmr27579229wmq.17.1654595312019;
        Tue, 07 Jun 2022 02:48:32 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b0039748be12dbsm23200547wms.47.2022.06.07.02.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:31 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 11/13] can: slcan: add ethtool support to reset adapter errors
Date:   Tue,  7 Jun 2022 11:47:50 +0200
Message-Id: <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a private flag to the slcan driver to switch the
"err-rst-on-open" setting on and off.

"err-rst-on-open" on  - Reset error states on opening command

"err-rst-on-open" off - Don't reset error states on opening command
                        (default)

The setting can only be changed if the interface is down:

    ip link set dev can0 down
    ethtool --set-priv-flags can0 err-rst-on-open {off|on}
    ip link set dev can0 up

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 drivers/net/can/slcan/Makefile        |  1 +
 drivers/net/can/slcan/slcan-core.c    | 36 +++++++++++++++
 drivers/net/can/slcan/slcan-ethtool.c | 65 +++++++++++++++++++++++++++
 drivers/net/can/slcan/slcan.h         | 18 ++++++++
 4 files changed, 120 insertions(+)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

diff --git a/drivers/net/can/slcan/Makefile b/drivers/net/can/slcan/Makefile
index 2e84f7bf7617..8a88e484ee21 100644
--- a/drivers/net/can/slcan/Makefile
+++ b/drivers/net/can/slcan/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_CAN_SLCAN) += slcan.o
 
 slcan-objs :=
 slcan-objs += slcan-core.o
+slcan-objs += slcan-ethtool.o
diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index d63d270d21da..b813a59534a3 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -57,6 +57,8 @@
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
 
+#include "slcan.h"
+
 MODULE_ALIAS_LDISC(N_SLCAN);
 MODULE_DESCRIPTION("serial line CAN interface");
 MODULE_LICENSE("GPL");
@@ -98,6 +100,8 @@ struct slcan {
 #define SLF_INUSE		0		/* Channel in use            */
 #define SLF_ERROR		1               /* Parity, etc. error        */
 #define SLF_XCMD		2               /* Command transmission      */
+	unsigned long           cmd_flags;      /* Command flags             */
+#define CF_ERR_RST		0               /* Reset errors on open      */
 	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
 						/* transmission              */
 };
@@ -117,6 +121,28 @@ static const struct can_bittiming_const slcan_bittiming_const = {
 	.brp_inc = 1,
 };
 
+bool slcan_err_rst_on_open(struct net_device *ndev)
+{
+	struct slcan *sl = netdev_priv(ndev);
+
+	return !!test_bit(CF_ERR_RST, &sl->cmd_flags);
+}
+
+int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
+{
+	struct slcan *sl = netdev_priv(ndev);
+
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	if (on)
+		set_bit(CF_ERR_RST, &sl->cmd_flags);
+	else
+		clear_bit(CF_ERR_RST, &sl->cmd_flags);
+
+	return 0;
+}
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -483,6 +509,15 @@ static int slc_open(struct net_device *dev)
 	if (sl->can.bittiming.bitrate == 0) {
 		sl->can.bittiming.bitrate = -1UL;
 	} else {
+		if (test_bit(CF_ERR_RST, &sl->cmd_flags)) {
+			err = slcan_transmit_cmd(sl, "F\r");
+			if (err) {
+				netdev_err(sl->dev,
+					   "failed to send error command 'F\\r'\n");
+				return err;
+			}
+		}
+
 		err = slcan_transmit_cmd(sl, "O\r");
 		if (err) {
 			netdev_err(dev, "failed to send open command 'O\\r'\n");
@@ -645,6 +680,7 @@ static struct slcan *slc_alloc(void)
 
 	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
+	slcan_set_ethtool_ops(dev);
 	sl = netdev_priv(dev);
 
 	/* Initialize channel control data */
diff --git a/drivers/net/can/slcan/slcan-ethtool.c b/drivers/net/can/slcan/slcan-ethtool.c
new file mode 100644
index 000000000000..bf0afdc4e49d
--- /dev/null
+++ b/drivers/net/can/slcan/slcan-ethtool.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ *
+ */
+
+#include <linux/can/dev.h>
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+
+#include "slcan.h"
+
+static const char slcan_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN BIT(0)
+	"err-rst-on-open",
+};
+
+static void slcan_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	switch (stringset) {
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, slcan_priv_flags_strings,
+		       sizeof(slcan_priv_flags_strings));
+	}
+}
+
+static u32 slcan_get_priv_flags(struct net_device *ndev)
+{
+	u32 flags = 0;
+
+	if (slcan_err_rst_on_open(ndev))
+		flags |= SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN;
+
+	return flags;
+}
+
+static int slcan_set_priv_flags(struct net_device *ndev, u32 flags)
+{
+	bool err_rst_op_open = !!(flags & SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN);
+
+	return slcan_enable_err_rst_on_open(ndev, err_rst_op_open);
+}
+
+static int slcan_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_PRIV_FLAGS:
+		return ARRAY_SIZE(slcan_priv_flags_strings);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct ethtool_ops slcan_ethtool_ops = {
+	.get_strings = slcan_get_strings,
+	.get_priv_flags = slcan_get_priv_flags,
+	.set_priv_flags = slcan_set_priv_flags,
+	.get_sset_count = slcan_get_sset_count,
+};
+
+void slcan_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &slcan_ethtool_ops;
+}
diff --git a/drivers/net/can/slcan/slcan.h b/drivers/net/can/slcan/slcan.h
new file mode 100644
index 000000000000..d463c8d99e22
--- /dev/null
+++ b/drivers/net/can/slcan/slcan.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * slcan.h - serial line CAN interface driver
+ *
+ * Copyright (C) Laurence Culhane <loz@holmes.demon.co.uk>
+ * Copyright (C) Fred N. van Kempen <waltje@uwalt.nl.mugnet.org>
+ * Copyright (C) Oliver Hartkopp <socketcan@hartkopp.net>
+ * Copyright (C) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ *
+ */
+
+#ifndef _SLCAN_H
+#define _SLCAN_H
+
+bool slcan_err_rst_on_open(struct net_device *ndev);
+int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on);
+void slcan_set_ethtool_ops(struct net_device *ndev);
+
+#endif /* _SLCAN_H */
-- 
2.32.0

