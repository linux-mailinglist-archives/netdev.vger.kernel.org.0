Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033C8302EAD
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbhAYWJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733145AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620FDC061786
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:33 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d22so17427402edy.1
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LnAfhs0pCnZlnrIHuWTEBYlC8Wv/rXHwldl6wPaIqx8=;
        b=ZU/pXtm1ssf9cs/pi4bt/qUkLujdXwwb7EEShwVq0nvok4yZ/i8U7eIuZOceKSiiit
         mKCtP2BE/GlJMaBJe8CM+E6x1vXg6kLPsvHg1yQgHrZPsgZXTKPgxD6nsPd9m3OhvZyV
         o6408wt94aXnSYEo3r0JkTAhHMCW7GnJPVRJxed9VISHfJzwCHe7iuAVCbVbIZFnAjPu
         hAzyeOfQ2aCSxaZ0p2ALSeAjspGLtjnbVS07B63vtRpE/STOYOEuOUS0lT6TNLkL6WNN
         sShpSDsd9qzW0lRuFMb223UoDQn93zmD4TJysYcHkZHkjzFNRw5+GsOFbXrG8xXQBdEk
         PIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LnAfhs0pCnZlnrIHuWTEBYlC8Wv/rXHwldl6wPaIqx8=;
        b=qVBlAGv8xQlcF3vRORcmL2LwhzE3DOoZNmCfckdKcgS4Oc1aFEbZj70DKP6PkNRPgU
         /Gs6xZffE8geWPpHTrxzSYBzWpqc9aG0sjQ0v8Bxgz815OHoHin5ExOcztGp6oYpl/G1
         HyHwyW19l40rM6EdTjel5mG9yNJIMo4AURiKU5w/uaQbc75KRGkmKeNj+4kQ6eHo5Xz6
         klXF9EdkLjKmTlrLk6rANCzs4vwHIbpZRYNV4eRgbOnQo68FTXjaBDYNyMtBIilwHvk0
         /vteQak9QHFOgl7QdGaAEkH2jMlYdrkBurhHCz6d7BhQSxpcEgHiGaDiGzaSQrgOcFDX
         FnGA==
X-Gm-Message-State: AOAM531pedsi9iMxOm+pfCvTUxJ+purBFBEQhfSwaOOj5rulMWAzMqy1
        z2548mBm6RS1pRGh4y4j7Ag=
X-Google-Smtp-Source: ABdhPJz6uQARPu5qYAFUujHmMLQc4xLelfl3jUv99fFqQ6UFF8h99ys6IWFqOdx060qPtYoqS4Ws1A==
X-Received: by 2002:aa7:dd49:: with SMTP id o9mr2207242edw.14.1611612272123;
        Mon, 25 Jan 2021 14:04:32 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 06/11] net: dsa: document the existing switch tree notifiers and add a new one
Date:   Tue, 26 Jan 2021 00:03:28 +0200
Message-Id: <20210125220333.1004365-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The existence of dsa_broadcast has generated some confusion in the past:
https://www.mail-archive.com/netdev@vger.kernel.org/msg365042.html

So let's document the existing dsa_port_notify and dsa_broadcast
functions and explain when each of them should be used.

Also, in fact, the in-between function has always been there but was
lacking a name, and is the main reason for this patch: dsa_tree_notify.
Refactor dsa_broadcast to use it.

This patch also moves dsa_broadcast (a top-level function) to dsa2.c,
where it really belonged in the first place, but had no companion so it
stood with dsa_port_notify.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
Patch is new.

 net/dsa/dsa2.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 36 +++++++++++++-----------------------
 3 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cc13549120e5..2953d0c1c7bc 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,49 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+/**
+ * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
+ * @dst: collection of struct dsa_switch devices to notify.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Given a struct dsa_switch_tree, this can be used to run a function once for
+ * each member DSA switch. The other alternative of traversing the tree is only
+ * through its ports list, which does not uniquely list the switches.
+ */
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
+{
+	struct raw_notifier_head *nh = &dst->nh;
+	int err;
+
+	err = raw_notifier_call_chain(nh, e, v);
+
+	return notifier_to_errno(err);
+}
+
+/**
+ * dsa_broadcast - Notify all DSA trees in the system.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Can be used to notify the switching fabric of events such as cross-chip
+ * bridging between disjoint trees (such as islands of tagger-compatible
+ * switches bridged by an incompatible middle switch).
+ */
+int dsa_broadcast(unsigned long e, void *v)
+{
+	struct dsa_switch_tree *dst;
+	int err = 0;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		err = dsa_tree_notify(dst, e, v);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2ce46bb87703..3cc1e6d76e3a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -283,6 +283,8 @@ void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 /* dsa2.c */
 void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
+int dsa_broadcast(unsigned long e, void *v);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f5b0f72ee7cd..a8886cf40160 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,31 +13,21 @@
 
 #include "dsa_priv.h"
 
-static int dsa_broadcast(unsigned long e, void *v)
-{
-	struct dsa_switch_tree *dst;
-	int err = 0;
-
-	list_for_each_entry(dst, &dsa_tree_list, list) {
-		struct raw_notifier_head *nh = &dst->nh;
-
-		err = raw_notifier_call_chain(nh, e, v);
-		err = notifier_to_errno(err);
-		if (err)
-			break;
-	}
-
-	return err;
-}
-
+/**
+ * dsa_port_notify - Notify the switching fabric of changes to a port
+ * @dp: port on which change occurred
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Notify all switches in the DSA tree that this port's switch belongs to,
+ * including this switch itself, of an event. Allows the other switches to
+ * reconfigure themselves for cross-chip operations. Can also be used to
+ * reconfigure ports without net_devices (CPU ports, DSA links) whenever
+ * a user port's state changes.
+ */
 static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 {
-	struct raw_notifier_head *nh = &dp->ds->dst->nh;
-	int err;
-
-	err = raw_notifier_call_chain(nh, e, v);
-
-	return notifier_to_errno(err);
+	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
 int dsa_port_set_state(struct dsa_port *dp, u8 state)
-- 
2.25.1

