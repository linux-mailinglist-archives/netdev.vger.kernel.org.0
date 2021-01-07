Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32FA2EC7B0
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbhAGBZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbhAGBZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:25:54 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CDFC0612F0
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:25:14 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g24so6139848edw.9
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCzyhGgTWWel+e7I1WlhjYvXmgKVK+ZX8TJG9dMRlqs=;
        b=Mblm5laarpgC14v9v4JeaQawUYt8RYtVhHqZwZODtBCTQvpCIHWhf4UPQHj5d7B4sm
         ac4pkyRxtQmLRX7dAMFf8UVimMcSp6kpgGJe1lpzJ6Xc87o4mQtH2/Sx2ieyrNRJOk3v
         6yLaoowsa91d6p2r5wu5HQYZ9J3uuhCQxKZbKrYu2WuXVFQnzDyJLQdvxzeVhA5rzpIu
         +/fZ1ANmbpPP7W1BM1QdFQPa4UfxSc0pv4rdu3cyHmMwQK5jIj4vtvpr9LzBpRuHe3ox
         Sk00TZllArVgnp3eZGdM4gDsfFS+lixMxIHYJd9s+dbzsVMehmkq/98qttYaIg8tNae7
         0J2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCzyhGgTWWel+e7I1WlhjYvXmgKVK+ZX8TJG9dMRlqs=;
        b=RT7J25OELoCZQOLKxJB3P9wsOcR977UOtxBZM+qG9M7EyMrjtjuXHHl37QgkpskE00
         myO6TBmVIJQ9kgKw252eAyC3coZuguOWD+cKO2d8bX1G8p/q3pzaHjr0EGugQCuIZ5jg
         8Q/7UxQqes2Pj1oBIe8twU8wMnV2IycSGjUMrPXeCl+kwgdBwRXy/H8L9+IMPhcLk7f0
         4oMK7YP7nY2elCzgOtgpEbtHscN+RBLnPVMdC+hGQxQQS3Kruopq6Q5p2rirkvudkxaD
         WF1s1yj0dxl8ohq3Y/kf4ILnzNR5sj86g+ljQNZWD0HQeST4VLedGN5UbLsqHcVTtzwg
         qo3A==
X-Gm-Message-State: AOAM5301xWdiiC0eFpHsG5NwlApk5lCPob3HK0FwgwZ6P71lQjzNOsEl
        kZAg0o5biBgatNwOAT46MIY=
X-Google-Smtp-Source: ABdhPJyk3WD8gQYwUAcbu0ZLekfGKrxwfnadaO4kgk+9QYcjwiRP6q4y8U3ucBujsLCt4l5g+DFhaw==
X-Received: by 2002:a05:6402:312b:: with SMTP id dd11mr5925745edb.308.1609982712803;
        Wed, 06 Jan 2021 17:25:12 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm2041858edv.74.2021.01.06.17.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:25:12 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2 net-next 1/4] net: dsa: move the Broadcom tag information in a separate header file
Date:   Thu,  7 Jan 2021 03:24:00 +0200
Message-Id: <20210107012403.1521114-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107012403.1521114-1-olteanv@gmail.com>
References: <20210107012403.1521114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It is a bit strange to see something as specific as Broadcom SYSTEMPORT
bits in the main DSA include file. Move these away into a separate
header, and have the tagger and the SYSTEMPORT driver include them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 MAINTAINERS                                |  1 +
 drivers/net/ethernet/broadcom/bcmsysport.c |  1 +
 include/linux/dsa/brcm.h                   | 16 ++++++++++++++++
 include/net/dsa.h                          |  6 ------
 net/dsa/tag_brcm.c                         |  1 +
 5 files changed, 19 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/dsa/brcm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c1e45c416b1..3854aca806f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3400,6 +3400,7 @@ L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
 F:	Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
 F:	drivers/net/dsa/b53/*
+F:	include/linux/dsa/brcm.h
 F:	include/linux/platform_data/b53.h
 
 BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b1ae9eb8f247..9ef743d6ba67 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
diff --git a/include/linux/dsa/brcm.h b/include/linux/dsa/brcm.h
new file mode 100644
index 000000000000..47545a948784
--- /dev/null
+++ b/include/linux/dsa/brcm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2014 Broadcom Corporation
+ */
+
+/* Included by drivers/net/ethernet/broadcom/bcmsysport.c and
+ * net/dsa/tag_brcm.c
+ */
+#ifndef _NET_DSA_BRCM_H
+#define _NET_DSA_BRCM_H
+
+/* Broadcom tag specific helpers to insert and extract queue/port number */
+#define BRCM_TAG_SET_PORT_QUEUE(p, q)	((p) << 8 | q)
+#define BRCM_TAG_GET_PORT(v)		((v) >> 8)
+#define BRCM_TAG_GET_QUEUE(v)		((v) & 0xff)
+
+#endif
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..af9a4f9ee764 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -873,12 +873,6 @@ static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 }
 #endif
 
-/* Broadcom tag specific helpers to insert and extract queue/port number */
-#define BRCM_TAG_SET_PORT_QUEUE(p, q)	((p) << 8 | q)
-#define BRCM_TAG_GET_PORT(v)		((v) >> 8)
-#define BRCM_TAG_GET_QUEUE(v)		((v) & 0xff)
-
-
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
 int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
 int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e934dace3922..e2577a7dcbca 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2014 Broadcom Corporation
  */
 
+#include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-- 
2.25.1

