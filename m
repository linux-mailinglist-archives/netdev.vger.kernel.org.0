Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FEB23ADEB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgHCUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgHCUED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:04:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61ACC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:04:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so20698059pgq.1
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6219eW0CRVUqlw/+reyzl7L8d8bWSx4EXYUvMNU5nBY=;
        b=tM/fuRuW/udxU6ZYnUqC8Jd4ff8GVmzr+1YW/IUIDcIrePPwAUZH98A+jiMHlIt60T
         xH9kIBxQEyd6JBoAAa6gepUSc6gYRIlcBt5C0xbxkpr2EVhqC+m4oWN4xVUutd8J3d5i
         XEeyIQTpihM5VKGPkNxaApgUmJOg6P8YGYaixOfDROf2zUJ4meZ7FveEQcBrcoJhGJW4
         /sIdvIWlSibS7yM6oEc7SsrqeEHEwh+zmzT8XaCykxSyBaMAJcohDioLd9a/F/FcJdgu
         OvY4nsku6m3cq1WlNvOR5LyOfNmkdkL19IMliclaqWYEdJVfYMDhjIehnLYCRiheADmc
         U2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6219eW0CRVUqlw/+reyzl7L8d8bWSx4EXYUvMNU5nBY=;
        b=e1k/h9sXUn4g15fahHFxho0oQFtkwInW0KtqiLAOYgg2yH80QYreR0EffuREn4cB0n
         Xx+sa1IeRuE9aagZgZsfFSJ6nHSdAffDANs9NcNsfTVRse8lEcN1rHYdZW/HF7OrQy+o
         khAXOSL9zAypFGz5718Lx6JmnzrwSrDLhWbwH0dFbiflknskOpJI2OeHTVXkAsgg9pFy
         gB4yYudncj8EDRckgg8odORCtrJFWCH2PuRpYwfXk/blZXR0VJE4laP4bPLH2BvHXE90
         XJCDyv5n6nw7AxDmAk2DPOBFgKjRR7URXdzgi4zX3BWAsvIFMpTF2KhPRh3XI+NQwKcY
         xyWQ==
X-Gm-Message-State: AOAM532ERv+wPX4y6FZ74tg44z6NUSKI5MtY5e/lolAFhj4RJMstg48u
        4xwn4BUC2SybhAqMqzJVVLKbaHpg
X-Google-Smtp-Source: ABdhPJzZwzIHHr+KJ66KNMIb9+Z2pAlAdqBJoLkIfcE2RSV7vsYBmYKxRNoL4zqnECYxwpINA74CRQ==
X-Received: by 2002:a63:5049:: with SMTP id q9mr119664pgl.219.1596485042359;
        Mon, 03 Aug 2020 13:04:02 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:04:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] net: dsa: loop: Move data structures to header
Date:   Mon,  3 Aug 2020 13:03:52 -0700
Message-Id: <20200803200354.45062-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding support for a mockup data path, move the
driver data structures to include/linux/dsa/loop.h such that we can
share them between net/dsa/ and drivers/net/dsa/ later on.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 32 +-----------------------------
 include/linux/dsa/loop.h   | 40 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/dsa/loop.h

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 6e97b44c6f3f..ed0b580c9944 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -14,28 +14,11 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/if_bridge.h>
+#include <linux/dsa/loop.h>
 #include <net/dsa.h>
 
 #include "dsa_loop.h"
 
-struct dsa_loop_vlan {
-	u16 members;
-	u16 untagged;
-};
-
-struct dsa_loop_mib_entry {
-	char name[ETH_GSTRING_LEN];
-	unsigned long val;
-};
-
-enum dsa_loop_mib_counters {
-	DSA_LOOP_PHY_READ_OK,
-	DSA_LOOP_PHY_READ_ERR,
-	DSA_LOOP_PHY_WRITE_OK,
-	DSA_LOOP_PHY_WRITE_ERR,
-	__DSA_LOOP_CNT_MAX,
-};
-
 static struct dsa_loop_mib_entry dsa_loop_mibs[] = {
 	[DSA_LOOP_PHY_READ_OK]	= { "phy_read_ok", },
 	[DSA_LOOP_PHY_READ_ERR]	= { "phy_read_err", },
@@ -43,19 +26,6 @@ static struct dsa_loop_mib_entry dsa_loop_mibs[] = {
 	[DSA_LOOP_PHY_WRITE_ERR] = { "phy_write_err", },
 };
 
-struct dsa_loop_port {
-	struct dsa_loop_mib_entry mib[__DSA_LOOP_CNT_MAX];
-	u16 pvid;
-};
-
-struct dsa_loop_priv {
-	struct mii_bus	*bus;
-	unsigned int	port_base;
-	struct dsa_loop_vlan vlans[VLAN_N_VID];
-	struct net_device *netdev;
-	struct dsa_loop_port ports[DSA_MAX_PORTS];
-};
-
 static struct phy_device *phydevs[PHY_MAX_ADDR];
 
 static enum dsa_tag_protocol dsa_loop_get_protocol(struct dsa_switch *ds,
diff --git a/include/linux/dsa/loop.h b/include/linux/dsa/loop.h
new file mode 100644
index 000000000000..bb39401a8056
--- /dev/null
+++ b/include/linux/dsa/loop.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef DSA_LOOP_H
+#define DSA_LOOP_H
+
+#include <linux/types.h>
+#include <linux/ethtool.h>
+#include <net/dsa.h>
+
+struct dsa_loop_vlan {
+	u16 members;
+	u16 untagged;
+};
+
+struct dsa_loop_mib_entry {
+	char name[ETH_GSTRING_LEN];
+	unsigned long val;
+};
+
+enum dsa_loop_mib_counters {
+	DSA_LOOP_PHY_READ_OK,
+	DSA_LOOP_PHY_READ_ERR,
+	DSA_LOOP_PHY_WRITE_OK,
+	DSA_LOOP_PHY_WRITE_ERR,
+	__DSA_LOOP_CNT_MAX,
+};
+
+struct dsa_loop_port {
+	struct dsa_loop_mib_entry mib[__DSA_LOOP_CNT_MAX];
+	u16 pvid;
+};
+
+struct dsa_loop_priv {
+	struct mii_bus	*bus;
+	unsigned int	port_base;
+	struct dsa_loop_vlan vlans[VLAN_N_VID];
+	struct net_device *netdev;
+	struct dsa_loop_port ports[DSA_MAX_PORTS];
+};
+
+#endif /* DSA_LOOP_H */
-- 
2.25.1

