Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181F92FF00C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbhAUQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731668AbhAUQD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:03:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB2DC061793
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:34 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s11so3108413edd.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=olgdY/kPME61Fm5gMVZs1DS3ZVErNWGlsrUdaJfjXUA=;
        b=o2LbBfYhpnRhs04QRnd056fdBWnjumeI/2wm/9DmYrHdMxJpAg1ngxhvVOq2t50JkT
         N71I9yndXg0erEM/H86mfifR3lnrI05J18G8151MYbe0GkbI8C9ewEMPXtkIxQkm+zLX
         wDEDbuGl5gPzy27bz7xFoX+Ity3HHcGD5POvPFxt3ncVF9KGpTyKVKjfw7OLA+7pEj5N
         6XN/+720wIgJRZ9wMXOTf9VtCpKnC2KXVp6lbgu8tca6/XATxmL3gvapVoVHsGpWYrPZ
         VUCHaVku8KwEV76v0ZFAPEHaLnRhNqjCs2KxMr3VUJ4cWz226Pm1Cjlr4K/oxWSYzEwL
         Plkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=olgdY/kPME61Fm5gMVZs1DS3ZVErNWGlsrUdaJfjXUA=;
        b=RqNAWtf0OGlM9zpUOh7AgFCa0Ny4gxObMYq4E29v4g7Zn9jguqToz7yaIxrxNVO+O+
         CfNP3CayAtsCfI9MISWAFppywZj60DVcI3D5swrT0V5Xy+rjx49JaO0hOvzKCTX1OSHr
         z0camCcYKn/zUPUZrrMpEcV6q5L8W0ul8Ss88LZRW9+quZpZKFwXtFhKtGl9KbPAtVva
         qHUnpKWbVLUXIjQGlLpgx83pMPFXfvOcBSV+wWRX1UA3bnHRMlZwZkkdDjla4n/F8vyZ
         LZAzdkdSTIALASy/MNebt/7MvWPAJBhaqLkaj6Y2/87jH1cZ4pUPWJ2h+/2vwIeJiZEN
         j6fQ==
X-Gm-Message-State: AOAM532IsssZ55abk//ieYBPK3lbAc3j+od1eRbOKITHbsKQGk6dppzg
        qPkf/4h2/H/hVxsSIKW1kzM=
X-Google-Smtp-Source: ABdhPJyuTLznutLNUoSSRy+PlIhx+5LlyQCV++w3x2bGIO0iVcl4fzBhvNWg6depQr23COaUfPB7Xw==
X-Received: by 2002:a50:d552:: with SMTP id f18mr11671434edj.168.1611244952852;
        Thu, 21 Jan 2021 08:02:32 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 06/10] net: dsa: document the existing switch tree notifiers and add a new one
Date:   Thu, 21 Jan 2021 18:01:27 +0200
Message-Id: <20210121160131.2364236-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121160131.2364236-1-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
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

