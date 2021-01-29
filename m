Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD83082D4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhA2BDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhA2BB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:56 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9772CC061788
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:38 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id kg20so10586565ejc.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TM/Dzwf7ZBadPWfrvY/jc7R4USKd+K7Pa5jN+eIJ5k8=;
        b=Mpd4sMC1+MZGfBEkdcwW2y9AS5f8E6o5Ci8hlP7cg68HO1VrBK1AYRmuERJmfgihZ5
         C0Tg/ptAkFtY+E2DgVZNoR8CWgdNJ5tMcutUvoT2ozcF2i1/rKAGbsXzA0MQb3ID2dLc
         ohzgLm3y0sfpf/I07LZqYM6MppeTusPdjpjwoEGvEfZ6B+4O79PoHi3XRBBggCWwBaoF
         VPZctbkv0AxivQ0232nbZVeeR6QgYF5WSfeZB0ZykDslAs5CmSAzm9DlKTpM59ieeiOb
         FGl7BrgR2wK0zTSrZbTz0P4YP7B6uJG3z0GpoZtOx+NvtDWyWX2TMWaIrEXIfZ2uZE17
         z2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TM/Dzwf7ZBadPWfrvY/jc7R4USKd+K7Pa5jN+eIJ5k8=;
        b=mj+8HnWa/UqcZ09S5MNF/hHP8ih4ruFmwaHO1ub72HN3wJAA1klqiMFoLeRW04bMFZ
         lsIr/FPtaGMZQ/4Q8MqcLyCYKnbx7rOkU1ivKhoa668mQJhRMVu7LS965Kc759n44XG0
         LoMgcRkYT9lwT3/ofQ3d6RnZtG4BUgSTNEGc4NChM4B0Hi/x00cw6zzY38XFsQuda2Lc
         /+DmeQZ9kYoGN/zvpdBgV9HjMAJTrpBkSdL9OzHkwcWEUm0o03aMYgWDc39f5W3xE0JE
         5xQx/cHfVuzVFrkpmjI2+mSo9reP43k8gWXWzSODOnblCdH0RwtQCBWJ13N2/max7xsU
         zqBw==
X-Gm-Message-State: AOAM531JyiGe/dIEgnVxTDIfCD3UcVlUQZzBmMlrUXdtGARBqIyo9p6P
        oZgLdmUXi83HyMup1ax5Fgo=
X-Google-Smtp-Source: ABdhPJyVYMT68AuVeXWZNzZcNU5M2akxDSV8Qy3MVcyleDKk/YoUmVzVF0PbCjKoZt2fShzzaJFaFQ==
X-Received: by 2002:a17:906:2747:: with SMTP id a7mr2251598ejd.250.1611882037307;
        Thu, 28 Jan 2021 17:00:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:36 -0800 (PST)
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
Subject: [PATCH v8 net-next 06/11] net: dsa: document the existing switch tree notifiers and add a new one
Date:   Fri, 29 Jan 2021 03:00:04 +0200
Message-Id: <20210129010009.3959398-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
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
Changes in v8:
None.

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

