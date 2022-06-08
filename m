Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38C5439D5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbiFHQ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343886AbiFHQyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:54:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FA63CA2C7
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u12so42644352eja.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D347QqdRdrFNo4P9Em/ayvZ1ba87O9qPIqi6sUOPlwQ=;
        b=G6FtfoTZaFiA0jXaBcblD832125eqRUc5l3XTcBdsf085JsJ26DMjuxuWXmW5PwA72
         b35wcybrpyifY/9G8E80xzDz8b58Xz4d7v12Zos/iYvShYsN3Lvkj36l8PJoM0hOfH/Z
         MGSirWJK1sQEe1FBxA2OTLwbm8aLSUDcLDZrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D347QqdRdrFNo4P9Em/ayvZ1ba87O9qPIqi6sUOPlwQ=;
        b=TMkCh/z7Vu1FxDI5/z8JUnZASi03VHEmFpUUow16YL95eIYXp+WMrX6c7KzRWeM5U6
         rqve+O9rH88pvhJHJ/owJ+Xx9iJqd5tdimznTWgr3W1ZrlY2BAuwA+wEiM4hTXafhP7u
         NkAr0uZPSjXUSVkogjXiWNFcss9g5mG4MGpGOJh39pWhH4Ma/BxnKA4+txGqA0urjsR5
         TBua9GF7wOkeUFt2CYdEL6iQ3zrRU2UZnhWhzqjjuOWBpjwM4/+ktoL0hcFKhzSMMRCa
         EaXK++5s81v9l/g8qF9Q/bW7r+M73Mocs67JBKpwXgdOEaaxGA4dMiw5lWQIacoKWZQ1
         qinA==
X-Gm-Message-State: AOAM5320I70AYwBdODzdAkixkNxvyzQ9mMdvLWbYjwevlNC1daAEl9Un
        KIpu8CfXZhX4BmAxZp35e0sR5w==
X-Google-Smtp-Source: ABdhPJw/5gQRquX+8U8LHLxsUqC3Jb6chyypr2FpdQFo+oZulkTugELneeLct3wkrvpM6/Qc7BZOCg==
X-Received: by 2002:a17:907:2cc7:b0:709:f1e1:7b17 with SMTP id hg7-20020a1709072cc700b00709f1e17b17mr31394072ejc.498.1654707099497;
        Wed, 08 Jun 2022 09:51:39 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:39 -0700 (PDT)
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
Subject: [PATCH v2 11/13] can: slcan: add ethtool support to reset adapter errors
Date:   Wed,  8 Jun 2022 18:51:14 +0200
Message-Id: <20220608165116.1575390-12-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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
index 0722e7820564..038ce7c25d42 100644
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
@@ -105,6 +109,28 @@ struct slcan {
 static struct net_device **slcan_devs;
 static DEFINE_SPINLOCK(slcan_lock);
 
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
@@ -475,6 +501,15 @@ static int slc_open(struct net_device *dev)
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
@@ -634,6 +669,7 @@ static struct slcan *slc_alloc(void)
 
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

