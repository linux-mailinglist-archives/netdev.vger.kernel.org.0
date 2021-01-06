Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADC2EBBEA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAFJxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbhAFJxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:53:02 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A7C06135B;
        Wed,  6 Jan 2021 01:52:13 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id q22so4300311eja.2;
        Wed, 06 Jan 2021 01:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lC1LFiqDpicLin+YkECJxc7NkcTGlHpSR10OKpi+kks=;
        b=MMn0MBO1IZucAJil43VtDtQ9f/QhqzBoa/oWw9wIy2YCE59+Sjl2dDA9MMf0xia1H2
         eUh4zmvJqx2rP/Qv/ouqkMTvJXy8Yr+MrrOG+MndqjCTDdELMMS4PPSliKugftc7ZroU
         iFr1cfBkJDRuQQtas2XnCz52k8RQhJV6QO2Q1SNEM8mSSiyQmhIbnHINPhMfRAC2Qbnk
         HtqEpxtKGKfq1hO87BLdqKn2jXFW5EHdcccTUAyKT/FGDGl36rMc6m/ebNqE4sO+qR+Y
         hCOnFo6hSoNE9R3e9cKnBXuKq6YCAqkCnDaIFtwWEF8hxlet1OBxoCNs6zYtLu85UhRH
         U9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lC1LFiqDpicLin+YkECJxc7NkcTGlHpSR10OKpi+kks=;
        b=SJZaJMQm6g94d/agSyZn+htjdqRgpAF3dd/ExyMFpWpPD/IzqzipKfiW3F2ZX7TBkl
         xYfVdZx9suRoG2OupvLtPnbdQ3hB1LxIGIadNYTepYSc9bdyVH7CYLT5zIeDDL5Vc2vy
         ENkEFWgeARZjQHc3sYePMEx1XRuVJK3MKzYChXoCEe6Cll2n3/r+6zOfnR8/FRxM1cKb
         oLAkrc5bMEZBWufFG/ICL+wSJsoRV2kAlrWya17rZxkozMqfd6adJ45TwCCwJHJ0er+B
         cvOI1Z2/TlfR2X4yUwQ6tbqlXpiBYqaqGQDLPChw9A7ScQPeyHSKiSlYqSpPIYOX+tvs
         fnAw==
X-Gm-Message-State: AOAM530w4i9lbAD16/zS8pGqMGys/mR2KBB3wMWRYslTU5dX+QyNn6IX
        hSjK8XcJBWyccaP+EzWRYnM=
X-Google-Smtp-Source: ABdhPJwT0MuQxw54+W0T9eTfecMbPn2xm8U8M6W+sooSKxUngin825dSUjpqb2DvXgnlx63HNc3sGQ==
X-Received: by 2002:a17:906:578e:: with SMTP id k14mr2360423ejq.90.1609926732066;
        Wed, 06 Jan 2021 01:52:12 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 4/7] net: dsa: move switchdev event implementation under the same switch/case statement
Date:   Wed,  6 Jan 2021 11:51:33 +0200
Message-Id: <20210106095136.224739-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
References: <20210106095136.224739-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
events even for interfaces where dsa_slave_dev_check returns false, so
we need that check inside the switch-case statement for SWITCHDEV_FDB_*.

This movement also avoids a useless allocation / free of switchdev_work
on the untreated "default event" case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/dsa/slave.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5e4fb44c2820..42ec18a4c7ba 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2119,31 +2119,29 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct dsa_port *dp;
 	int err;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET) {
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
-	}
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!dsa_slave_dev_check(dev))
+			return NOTIFY_DONE;
 
-	dp = dsa_slave_to_port(dev);
+		dp = dsa_slave_to_port(dev);
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return NOTIFY_BAD;
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
 
-	INIT_WORK(&switchdev_work->work,
-		  dsa_slave_switchdev_event_work);
-	switchdev_work->ds = dp->ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
+		INIT_WORK(&switchdev_work->work,
+			  dsa_slave_switchdev_event_work);
+		switchdev_work->ds = dp->ds;
+		switchdev_work->port = dp->index;
+		switchdev_work->event = event;
 
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = ptr;
 
 		if (!fdb_info->added_by_user) {
@@ -2156,13 +2154,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->vid = fdb_info->vid;
 
 		dev_hold(dev);
+		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 
-	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
 }
 
-- 
2.25.1

