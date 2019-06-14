Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41A46624
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfFNRtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:49:40 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33192 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfFNRtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:49:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so2249691qkc.0;
        Fri, 14 Jun 2019 10:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LoNSmm24AEOSHRs9C1mSR8MxDcq/15X/cKP+AT4w4Ow=;
        b=OCuTdDxMx8ddKllHLRvOUKRXd9aQMaZhas/sfMTEAxFFBeeO055Wu8pQqdTNboS4eU
         VvY/Q5f02GxBOOlpI4hfaPN0gRWAjnxxXvYxhTRowIuX6Yxbp4WlccxF0tBqG5t8srIj
         IDRVjjopPK6mQSGWZwvXo623xqkla4M2j2SDpACp11Uq+hhRvCKFiiUiHHuswihXa+9x
         Hk+lGkB1DAExwXWkHfZiv2zaGrvdfcpSJ9v9nUDo8Y6KMsvqfhZMWaUKEX/wGEQxbSYC
         qzDpsRTl87QxjZJ46AaXMOko4nZnMx7p9XKRAoKApq1jNbaSqiM+pcU4zYrg71d4syFN
         HHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LoNSmm24AEOSHRs9C1mSR8MxDcq/15X/cKP+AT4w4Ow=;
        b=me/Fj8oiPPDqrD7xGfmCB9VdsPe6dry+GYTF0BCqXhlkuiRfylrHBWRkmtfEE+EYN6
         C4hbca0FUkd4Tyh89t4SmYG4B6ZH/Mu1Qyruyt4hc7VrER1tlCrsomZLuAbbPPSx4gJU
         cDxQj0Z1HVl8jrXgpoC4BfVIZ0IxvaTCgH2EYKnvxHcTdTYxa6IsAHnq21vuZ8iFTB27
         aDHEd17P4Sa2/M4whnpgCFqwDNH5/4pao332tw5GtgAsK1aI5RDXe1RrynHGMI4oz+mb
         /LpPEvgZsNel19dc6ZcNB0j6itAqhzjw4u3l4gb7oBzVuAhi3f9nUrep9L/rkdOR7e/X
         TTZg==
X-Gm-Message-State: APjAAAXny2gkgLZB3IA6wgBgNMVBEeMjB4i0cnB2UvQw5My4a2lLizm6
        RhgNUuB41bXwTNT86ouJTuWXZGwd4lw=
X-Google-Smtp-Source: APXvYqz8m0OYowOfvLvvfjGnCDyS2bctdURQQbg/rQzE/D8YF7xKU0QKQA+TPEyYUkveRobws0YafA==
X-Received: by 2002:a37:b501:: with SMTP id e1mr57475514qkf.271.1560534575381;
        Fri, 14 Jun 2019 10:49:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b5sm1833524qkk.45.2019.06.14.10.49.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 10:49:34 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next v2 4/4] net: dsa: use switchdev handle helpers
Date:   Fri, 14 Jun 2019 13:49:22 -0400
Message-Id: <20190614174922.2590-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614174922.2590-1-vivien.didelot@gmail.com>
References: <20190614174922.2590-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of the dsa_slave_switchdev_port_{attr_set,obj}_event functions
in favor of the switchdev_handle_port_{attr_set,obj_add,obj_del}
helpers which recurse into the lower devices of the target interface.

This has the benefit of being aware of the operations made on the
bridge device itself, where orig_dev is the bridge, and dev is the
slave. This can be used later to configure the hardware switches.

Only VLAN and (port) MDB objects not directly targeting the slave
device are unsupported at the moment, so skip this case in their
respective case statements.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c | 76 +++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 44 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index cb436a05c9a8..99673f6b07f6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -311,7 +311,8 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
-				  struct switchdev_trans *trans)
+				  struct switchdev_trans *trans,
+				  struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
@@ -323,6 +324,8 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		if (obj->orig_dev != dev)
+			return -EOPNOTSUPP;
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
@@ -333,6 +336,8 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 				       trans);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (obj->orig_dev != dev)
+			return -EOPNOTSUPP;
 		err = dsa_port_vlan_add(dp, SWITCHDEV_OBJ_PORT_VLAN(obj),
 					trans);
 		break;
@@ -352,6 +357,8 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		if (obj->orig_dev != dev)
+			return -EOPNOTSUPP;
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
@@ -361,6 +368,8 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (obj->orig_dev != dev)
+			return -EOPNOTSUPP;
 		err = dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	default:
@@ -1479,19 +1488,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int
-dsa_slave_switchdev_port_attr_set_event(struct net_device *netdev,
-		struct switchdev_notifier_port_attr_info *port_attr_info)
-{
-	int err;
-
-	err = dsa_slave_port_attr_set(netdev, port_attr_info->attr,
-				      port_attr_info->trans);
-
-	port_attr_info->handled = true;
-	return notifier_from_errno(err);
-}
-
 struct dsa_switchdev_event_work {
 	struct work_struct work;
 	struct switchdev_notifier_fdb_info fdb_info;
@@ -1566,13 +1562,18 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct dsa_switchdev_event_work *switchdev_work;
+	int err;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     dsa_slave_dev_check,
+						     dsa_slave_port_attr_set);
+		return notifier_from_errno(err);
+	}
 
 	if (!dsa_slave_dev_check(dev))
 		return NOTIFY_DONE;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET)
-		return dsa_slave_switchdev_port_attr_set_event(dev, ptr);
-
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return NOTIFY_BAD;
@@ -1602,41 +1603,28 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	return NOTIFY_BAD;
 }
 
-static int
-dsa_slave_switchdev_port_obj_event(unsigned long event,
-			struct net_device *netdev,
-			struct switchdev_notifier_port_obj_info *port_obj_info)
-{
-	int err = -EOPNOTSUPP;
-
-	switch (event) {
-	case SWITCHDEV_PORT_OBJ_ADD:
-		err = dsa_slave_port_obj_add(netdev, port_obj_info->obj,
-					     port_obj_info->trans);
-		break;
-	case SWITCHDEV_PORT_OBJ_DEL:
-		err = dsa_slave_port_obj_del(netdev, port_obj_info->obj);
-		break;
-	}
-
-	port_obj_info->handled = true;
-	return notifier_from_errno(err);
-}
-
 static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 					      unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
+	int err;
 
 	switch (event) {
-	case SWITCHDEV_PORT_OBJ_ADD: /* fall through */
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    dsa_slave_dev_check,
+						    dsa_slave_port_obj_add);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_OBJ_DEL:
-		return dsa_slave_switchdev_port_obj_event(event, dev, ptr);
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    dsa_slave_dev_check,
+						    dsa_slave_port_obj_del);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_ATTR_SET:
-		return dsa_slave_switchdev_port_attr_set_event(dev, ptr);
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     dsa_slave_dev_check,
+						     dsa_slave_port_attr_set);
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
-- 
2.21.0

