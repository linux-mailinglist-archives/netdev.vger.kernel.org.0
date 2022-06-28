Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55C55E9FB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbiF1QgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237400AbiF1Qe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:59 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D658335862
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ge10so26898574ejb.7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EnkldBizAbtcQ/b8PNuwOxdeNT2ej6ej+gjqsPyuyDo=;
        b=gVQ7SGJIOxgI5u4R2NQ9QXRVxbRCBtPjM2sUouafDkoZFdoLiHyKy1ppm66vtDeyE9
         j0sOa94tlh9/HKZ6lDWNZXEmluoxMSYoTW/3HGUiHGiTxRpauDmHvWtEdU3SWsGKCNpy
         e59VXwNcPP6PZGG+pK3e4CCBURU7j6pDXIgyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EnkldBizAbtcQ/b8PNuwOxdeNT2ej6ej+gjqsPyuyDo=;
        b=qE9kfN4PS8TZOtyGxhfyta41kqnS6ROAFlGybdOWob3RuzuSNXuH/Eymt+FmR5ZDE+
         TIANMK/iv8E4Rm8XYqQHRIhhAp7tyIgmkL7iCxRuMiLj/aG2sqhE4k+RaHTHoadfiZ5x
         zY3WcmJn+sw1cQv6bmUmEtytGR25eH0fbmWi4JrxIn/TkMKd6siGWTzIVXM1TMVrOvpS
         240uJ1K89E2ZjCY0kTSAHrBHT/RaIOlTIT9rDugF1gyxuVBQuXeF553qhlf/jfyR3Hw4
         /WVDrvpZbRu8UMyQaOSjA8Y64nkh53l0S1RTsON+Z4avb4yR1DvhdsPR6DWkzdbtGyL9
         6Jyw==
X-Gm-Message-State: AJIora/0xJ+dSqSxPHFgMH0Cc/965TdEvwuqpiRu5xgYnua/lvnC+UOD
        DI+AmfwZQ/t3B1D691PZxyH9QQ==
X-Google-Smtp-Source: AGRyM1tW1JbfWs81rMrmsjJkHJY3Gdi0X1CVdqYT2uA/xYErOUijhCZ3mf/mW3c1ElGzh03RvxKiLQ==
X-Received: by 2002:a17:906:c152:b0:726:35bd:b3bd with SMTP id dp18-20020a170906c15200b0072635bdb3bdmr18725435ejc.201.1656433923423;
        Tue, 28 Jun 2022 09:32:03 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:32:02 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
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
Subject: [PATCH v5 10/12] can: slcan: add ethtool support to reset adapter errors
Date:   Tue, 28 Jun 2022 18:31:34 +0200
Message-Id: <20220628163137.413025-11-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

(no changes since v1)

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
index 249b5ade06fc..c1fd1e934d93 100644
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
@@ -109,6 +113,28 @@ static const u32 slcan_bitrate_const[] = {
 	250000, 500000, 800000, 1000000
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
@@ -510,6 +536,15 @@ static int slc_open(struct net_device *dev)
 			goto cmd_transmit_failed;
 		}
 
+		if (test_bit(CF_ERR_RST, &sl->cmd_flags)) {
+			err = slcan_transmit_cmd(sl, "F\r");
+			if (err) {
+				netdev_err(dev,
+					   "failed to send error command 'F\\r'\n");
+				goto cmd_transmit_failed;
+			}
+		}
+
 		err = slcan_transmit_cmd(sl, "O\r");
 		if (err) {
 			netdev_err(dev, "failed to send open command 'O\\r'\n");
@@ -629,6 +664,7 @@ static struct slcan *slc_alloc(void)
 	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
 	dev->base_addr  = i;
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

