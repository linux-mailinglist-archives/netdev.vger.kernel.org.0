Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC901C0AF5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD3X0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:26:46 -0400
Received: from mail-eopbgr130109.outbound.protection.outlook.com ([40.107.13.109]:36160
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727864AbgD3X0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:26:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FznUTtXYlChzeSmC576mSd4UqT6Ydw8wHbkmtzMpNZc+KW5x4S7jEHULNptP1W5IysgjhXT3lpbKtavMP8nBQMuYZgJAPM82F1jx5yhMuINojIcfrATjYFIyTOyzjUN+lcnVQEAErSMxanlH0bXSfyZGzEP4bh3+m6iYeBD9SS7xjAYQDEZOtoSM3D77Gm3zwxJBCUjOX/5OjCqghhAIANdpxJlVNNJwR6E6SI/gJIdgxQzkxXK2I8UvAbJH2nz4x/1PUf6NC8CH4PBNpnjhdW1A0y9zLP4x165MuLAiM0oR6y1SedI7i947tIRsZLGMB7lFhlQqvcMGo+oY6CxqHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXvMIAGuHFzyPV82bBJ20inpeefdZ9GZ8aqHrvopgs8=;
 b=hWgqv9KKAz7vRC6Ziwjao/Iks6XVeEyKkIb3AFPyalO2XnPhsE/WSqiz0zzreoArbIMPg3UcTtIWraqHTIqteoTImlEhH9qV4r2WJvemYjRT4cStpEVzfKqVfYGuaeJbzfoAyDEjbdkOdzIwpYXpuNwQ1XMNHdOvzKi9td3qKWovz4H48GgjSWdfjpCFxLBzaIIudw8lVsxNX4auuRWZtRyckJyNMJ+1pX32EPoCKe8nOHarPTlThBPZDbNDrEd2lso/YFOjcaqFX9B4IV8IbVjQCBfI6vOLQgE7FCkUdFp6ML/0q4V8S1g/uKHEaOaDw6HAo3hyuDl9aa1wjSBTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXvMIAGuHFzyPV82bBJ20inpeefdZ9GZ8aqHrvopgs8=;
 b=Po/wB22BBc1IGQ2MWRBSuH0qWGg0R+ovGBP7HnL7DjWdw5mwUv6FYRCMicfg522Cwj4JGkkNKraD3QnVHq82SkqGKDmZzW3VX4TWPSJvYcTuX5qbHoVUUdIfpK6uKW8kwPUyG97FyDuV8XFmoT8bKKVD9U3R2hsry7B1olwmCnI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM (10.175.242.25) by
 DB6P190MB0471.EURP190.PROD.OUTLOOK.COM (10.165.186.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Thu, 30 Apr 2020 23:21:24 +0000
Received: from DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6]) by DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 ([fe80::c59e:e6ed:2bec:94a6%6]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:21:24 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: [RFC next-next v2 4/5] net: marvell: prestera: Add Switchdev driver implementation
Date:   Fri,  1 May 2020 02:20:51 +0300
Message-Id: <20200430232052.9016-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430232052.9016-1-vadym.kochan@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0036.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::49) To DB6P190MB0390.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P192CA0036.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 23:21:23 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42f9561b-5d28-4db2-756b-08d7ed5d3328
X-MS-TrafficTypeDiagnostic: DB6P190MB0471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB04710709B081C65ABCBC0CE195AA0@DB6P190MB0471.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7MchMyhjtx3rxSpsu25WMNUrDuO79WuV2T81rcZRXtntt3DDKUxXpSyQTH/1DUnSblMoYwQqwFLYgctFsb22qOTR0BrJjvnS+j5v9w9KXoAUhB00+uQZZE0gh5ZxPT1MUqBTMcta3DY+wR0rdqiUcBEN9vidHKRCTYGMNADr9lxoxupGjYKTpWXsd6X8Z2ymGs1rfByUJOqyhwi737hJTgwosYc8aeJT0yDTW0PyzwRdl4E/IYUipGWLqudg2yfyZ0JSPr77WuMDApRhio4qrno82tJt7KICn8MThkI4tJV/l2JZ2lhe9v4bguMiKcUOucRiCh8DEH56LsZ7Nhp4UNEX3Gvz9xnp45Ubw+J5z0HFA2MFJNV/DU0BG8xrWeVga6lwdh4BIqK09L/ArjilOH/ipiBEAb/Evoae52dmqDO2TWnhwIM2h9wkR6rrESu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(6512007)(44832011)(54906003)(316002)(6666004)(2906002)(956004)(2616005)(508600001)(4326008)(66476007)(66556008)(66946007)(86362001)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(8676002)(52116002)(1076003)(30864003)(6916009)(5660300002)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: i9v/+/xOMaBZ1SZepT2QwvVHPLtp1IEXvtgNw7rXHf6AkeTpIUQ6m34rbqv9wkCG7DIgpf8OumJy4uoTCFpgjkW/IUYWUBByzZChKusm/c2T/oeQW5ZC1SvhgfaqoMzGzkcFw9+4Em9QFaNpj9MXbYV/J+M4xGYP7xMhyh5DIdQSbqCoMMkXg81fvpU6VCfbLGTw9LS/MaRI8mZCrDg6CzPWcUysuRb/UNo7Tzy1Ff+DCkkr6WInma6hPs1ursOUQb4f7rwJDY/UnvtWzWuxYVXMRqr/zqdL8yBbY0PcDtvCKdzzfxxVUgL1AZnJ9jl5ylTZfPA6jVzZqC+B3ssM8R8BF/HYyHrYrC1un/wiyFR9Joy4KviVrbirlF6F7LGRvhkah+GcAHwbZhtzbV2h7g1GQSZc+ynichMc2HTI5IkxPkVgYCSx/atx5Yoe7s2OyCCWO2v86jMIN6mi3fD7fmObiVmAHFJYk+lB4hbnFlQSx6kBmo8/LEDEq50uhnr6WppSoMqxEslVenoM1d0wVUfxe0tXAtcHkxZa5d1KUzt1RRFMGPv6oRF4I5vsHPa0KzMcob3Fa0F1epMxW0WrsLQ2QsRioLQGN0L+J/bVtFlkoWTNY2GDAQcS3CCxpOXRGKM4FyskPYetaEUJZ/EN/7034JhD/mb/nIxA3JnY4coleRyNPhaUtXDp0hX/sFjK4b9g6Zkf5sw6cbX4yti+1bzejdfluWH84pS/Fheyg+yrBofLI3mXBYnmbP3MPuNwmJAvZ1lY6jOAeKGKfWuWZD5co7sIlJU7QtVUWZZn6Gg=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f9561b-5d28-4db2-756b-08d7ed5d3328
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:21:24.4863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiU70rYMvUFm8d9Rrnd3GhEXuLtZxhdH0RKlflsCT5ptRJlRgRE8HIuqkj4Y1v6Jd5X2UIVCCaqYqVIOKu4iLVMu1ePmfJvmvomKggFUvGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following features are supported:

    - VLAN-aware bridge offloading
    - VLAN-unaware bridge offloading
    - FDB offloading (learning, ageing)
    - Switchport configuration

Currently there are some limitations like:

    - Only 1 VLAN-aware bridge instance supported
    - No STP supported (will be added in next submission)
    - FDB ageing timeout parameter is set globally per device

Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../net/ethernet/marvell/prestera/Makefile    |    2 +-
 .../net/ethernet/marvell/prestera/prestera.c  |  112 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   32 +-
 .../ethernet/marvell/prestera/prestera_hw.c   |  301 ++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |   40 +
 .../marvell/prestera/prestera_switchdev.c     | 1176 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   16 +
 7 files changed, 1668 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index aa99b1348ac4..2b9400b162ce 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_PRESTERA)	+= prestera_sw.o
 prestera_sw-objs	:= prestera.o prestera_hw.o prestera_dsa.o \
-			   prestera_rxtx.o
+			   prestera_rxtx.o prestera_switchdev.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.c b/drivers/net/ethernet/marvell/prestera/prestera.c
index 9689c84840be..eafbbc996e33 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera.c
@@ -13,6 +13,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_switchdev.h"
 
 static char base_mac_addr[ETH_ALEN];
 static char *base_mac;
@@ -309,6 +310,29 @@ static const char prestera_cnt_name[PRESTERA_STATS_CNT][ETH_GSTRING_LEN] = {
 	PRESTERA_STATS_FIELD(good_octets_sent),
 };
 
+int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
+{
+	enum prestera_accept_frm_type frm_type;
+	int err;
+
+	frm_type = PRESTERA_ACCEPT_FRAME_TYPE_TAGGED;
+
+	if (vid) {
+		err = prestera_hw_vlan_port_vid_set(port, vid);
+		if (err)
+			return err;
+
+		frm_type = PRESTERA_ACCEPT_FRAME_TYPE_ALL;
+	}
+
+	err = prestera_hw_port_accept_frm_type(port, frm_type);
+	if (err && frm_type == PRESTERA_ACCEPT_FRAME_TYPE_ALL)
+		prestera_hw_vlan_port_vid_set(port, port->pvid);
+
+	port->pvid = vid;
+	return 0;
+}
+
 struct prestera_port *prestera_port_find_by_hwid(u32 dev_id, u32 hw_id)
 {
 	struct prestera_port *port;
@@ -327,15 +351,14 @@ struct prestera_port *prestera_port_find_by_hwid(u32 dev_id, u32 hw_id)
 	return NULL;
 }
 
-static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
-						u32 port_id)
+struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 {
 	struct prestera_port *port;
 
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(port, &sw->port_list, list) {
-		if (port->id == port_id) {
+		if (port->id == id) {
 			rcu_read_unlock();
 			return port;
 		}
@@ -1010,6 +1033,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	port = netdev_priv(dev);
 
+	INIT_LIST_HEAD(&port->vlans_list);
+	port->pvid = PRESTERA_DEFAULT_VID;
 	port->dev = dev;
 	port->id = id;
 	port->sw = sw;
@@ -1178,6 +1203,72 @@ static int prestera_event_handlers_register(struct prestera_switch *sw)
 						  NULL);
 }
 
+bool prestera_netdev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &netdev_ops;
+}
+
+static int prestera_lower_dev_walk(struct net_device *dev, void *data)
+{
+	struct prestera_port **pport = data;
+
+	if (prestera_netdev_check(dev)) {
+		*pport = netdev_priv(dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
+{
+	struct prestera_port *port;
+
+	if (prestera_netdev_check(dev))
+		return netdev_priv(dev);
+
+	port = NULL;
+	netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
+
+	return port;
+}
+
+static int prestera_netdev_port_event(struct net_device *dev,
+				      unsigned long event, void *ptr)
+{
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+	case NETDEV_CHANGEUPPER:
+		return prestera_bridge_port_event(dev, event, ptr);
+	}
+
+	return 0;
+}
+
+static int prestera_netdev_event_handler(struct notifier_block *nb,
+					 unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int err = 0;
+
+	if (prestera_netdev_check(dev))
+		err = prestera_netdev_port_event(dev, event, ptr);
+
+	return notifier_from_errno(err);
+}
+
+static int prestera_netdev_event_handler_register(struct prestera_switch *sw)
+{
+	sw->netdev_nb.notifier_call = prestera_netdev_event_handler;
+
+	return register_netdevice_notifier(&sw->netdev_nb);
+}
+
+static void prestera_netdev_event_handler_unregister(struct prestera_switch *sw)
+{
+	unregister_netdevice_notifier(&sw->netdev_nb);
+}
+
 static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
@@ -1196,10 +1287,18 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		return err;
 
-	err = prestera_rxtx_switch_init(sw);
+	err = prestera_netdev_event_handler_register(sw);
 	if (err)
 		return err;
 
+	err = prestera_switchdev_init(sw);
+	if (err)
+		goto err_swdev_register;
+
+	err = prestera_rxtx_switch_init(sw);
+	if (err)
+		goto err_rxtx_register;
+
 	err = prestera_event_handlers_register(sw);
 	if (err)
 		goto err_evt_handlers;
@@ -1212,6 +1311,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 
 err_ports_create:
 err_evt_handlers:
+err_rxtx_register:
+err_swdev_register:
+	prestera_netdev_event_handler_unregister(sw);
+	prestera_switchdev_fini(sw);
 	prestera_rxtx_switch_fini(sw);
 
 	return err;
@@ -1222,6 +1325,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_destroy_ports(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
+	prestera_switchdev_fini(sw);
 }
 
 int prestera_device_register(struct prestera_device *dev)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index b870d440468c..666e98947f64 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -12,6 +12,8 @@
 #include <uapi/linux/if_ether.h>
 #include <linux/workqueue.h>
 
+#define PRESTERA_DEFAULT_VID	1
+
 struct prestera_fw_rev {
 	u16 maj;
 	u16 min;
@@ -48,8 +50,6 @@ struct prestera_port_stats {
 	u64 unicast_frames_sent;
 	u64 sent_multiple;
 	u64 sent_deferred;
-	u64 frames_1024_to_1518_octets;
-	u64 frames_1519_to_max_octets;
 	u64 good_octets_sent;
 };
 
@@ -67,11 +67,13 @@ struct prestera_port {
 	u32 hw_id;
 	u32 dev_id;
 	u16 fp_id;
+	u16 pvid;
 	bool autoneg;
 	u64 adver_link_modes;
 	u8 adver_fec;
 	struct prestera_port_caps caps;
 	struct list_head list;
+	struct list_head vlans_list;
 	struct {
 		struct prestera_port_stats stats;
 		struct delayed_work caching_dw;
@@ -101,6 +103,7 @@ enum prestera_event_type {
 	PRESTERA_EVENT_TYPE_UNSPEC,
 
 	PRESTERA_EVENT_TYPE_PORT,
+	PRESTERA_EVENT_TYPE_FDB,
 	PRESTERA_EVENT_TYPE_RXTX,
 
 	PRESTERA_EVENT_TYPE_MAX,
@@ -123,19 +126,37 @@ struct prestera_port_event {
 	} data;
 };
 
+enum prestera_fdb_event_id {
+	PRESTERA_FDB_EVENT_UNSPEC,
+	PRESTERA_FDB_EVENT_LEARNED,
+	PRESTERA_FDB_EVENT_AGED,
+};
+
+struct prestera_fdb_event {
+	u32 port_id;
+	u32 vid;
+	union {
+		u8 mac[ETH_ALEN];
+	} data;
+};
+
 struct prestera_event {
 	u16 id;
 	union {
 		struct prestera_port_event port_evt;
+		struct prestera_fdb_event fdb_evt;
 	};
 };
 
+struct prestera_switchdev;
 struct prestera_rxtx;
 
 struct prestera_switch {
 	struct prestera_device *dev;
+	struct prestera_switchdev *swdev;
 	struct prestera_rxtx *rxtx;
 	struct list_head event_handlers;
+	struct notifier_block netdev_nb;
 	char base_mac[ETH_ALEN];
 	struct list_head port_list;
 	spinlock_t ports_lock;
@@ -167,6 +188,13 @@ static inline u32 prestera_read(const struct prestera_switch *sw,
 int prestera_device_register(struct prestera_device *dev);
 void prestera_device_unregister(struct prestera_device *dev);
 
+struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 struct prestera_port *prestera_port_find_by_hwid(u32 dev_id, u32 hw_id);
 
+struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
+
+int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
+
+bool prestera_netdev_check(const struct net_device *dev);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 8ceb19e32a76..6b0a62f1972d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -20,6 +20,22 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_PORT_ATTR_GET = 0x101,
 	PRESTERA_CMD_TYPE_PORT_INFO_GET = 0x110,
 
+	PRESTERA_CMD_TYPE_VLAN_CREATE = 0x200,
+	PRESTERA_CMD_TYPE_VLAN_DELETE = 0x201,
+	PRESTERA_CMD_TYPE_VLAN_PORT_SET = 0x202,
+	PRESTERA_CMD_TYPE_VLAN_PVID_SET = 0x203,
+
+	PRESTERA_CMD_TYPE_FDB_ADD = 0x300,
+	PRESTERA_CMD_TYPE_FDB_DELETE = 0x301,
+	PRESTERA_CMD_TYPE_FDB_FLUSH_PORT = 0x310,
+	PRESTERA_CMD_TYPE_FDB_FLUSH_VLAN = 0x311,
+	PRESTERA_CMD_TYPE_FDB_FLUSH_PORT_VLAN = 0x312,
+
+	PRESTERA_CMD_TYPE_BRIDGE_CREATE = 0x400,
+	PRESTERA_CMD_TYPE_BRIDGE_DELETE = 0x401,
+	PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD = 0x402,
+	PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE = 0x403,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
@@ -32,6 +48,9 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_MTU = 3,
 	PRESTERA_CMD_PORT_ATTR_MAC = 4,
 	PRESTERA_CMD_PORT_ATTR_SPEED = 5,
+	PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE = 6,
+	PRESTERA_CMD_PORT_ATTR_LEARNING = 7,
+	PRESTERA_CMD_PORT_ATTR_FLOOD = 8,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
 	PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY = 10,
 	PRESTERA_CMD_PORT_ATTR_REMOTE_FC = 11,
@@ -47,6 +66,7 @@ enum {
 
 enum {
 	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
+	PRESTERA_CMD_SWITCH_ATTR_AGEING = 2,
 };
 
 enum {
@@ -93,8 +113,6 @@ enum {
 	PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT,
 	PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT,
 	PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT,
-	PRESTERA_PORT_PKTS_1024TO1518L_CNT,
-	PRESTERA_PORT_PKTS_1519TOMAXL_CNT,
 	PRESTERA_PORT_GOOD_OCTETS_SENT_CNT,
 
 	PRESTERA_PORT_CNT_MAX,
@@ -133,6 +151,7 @@ struct prestera_msg_common_resp {
 
 union prestera_msg_switch_param {
 	u8 mac[ETH_ALEN];
+	u32 ageing_timeout;
 };
 
 struct prestera_msg_switch_attr_req {
@@ -171,7 +190,10 @@ union prestera_msg_port_param {
 	u8  oper_state;
 	u32 mtu;
 	u8  mac[ETH_ALEN];
+	u8  accept_frm_type;
 	u32 speed;
+	u8 learning;
+	u8 flood;
 	u32 link_mode;
 	u8  type;
 	u8  duplex;
@@ -212,6 +234,38 @@ struct prestera_msg_port_info_resp {
 	u16 fp_id;
 } __packed __aligned(4);
 
+struct prestera_msg_vlan_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 vid;
+	u8  is_member;
+	u8  is_tagged;
+} __packed __aligned(4);
+
+struct prestera_msg_fdb_req {
+	struct prestera_msg_cmd cmd;
+	u8 dest_type;
+	u32 port;
+	u32 dev;
+	u8  mac[ETH_ALEN];
+	u16 vid;
+	u8  dynamic;
+	u32 flush_mode;
+} __packed __aligned(4);
+
+struct prestera_msg_bridge_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 bridge;
+} __packed __aligned(4);
+
+struct prestera_msg_bridge_resp {
+	struct prestera_msg_ret ret;
+	u16 bridge;
+} __packed __aligned(4);
+
 struct prestera_msg_rxtx_req {
 	struct prestera_msg_cmd cmd;
 	u8 use_sdma;
@@ -243,6 +297,18 @@ struct prestera_msg_event_port {
 	union prestera_msg_event_port_param param;
 } __packed __aligned(4);
 
+union prestera_msg_event_fdb_param {
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_event_fdb {
+	struct prestera_msg_event id;
+	u8 dest_type;
+	u32 port_id;
+	u32 vid;
+	union prestera_msg_event_fdb_param param;
+} __packed __aligned(4);
+
 static int __prestera_cmd_ret(struct prestera_switch *sw,
 			      enum prestera_cmd_type_t type,
 			      struct prestera_msg_cmd *cmd, size_t clen,
@@ -308,10 +374,25 @@ static int prestera_fw_parse_port_evt(u8 *msg, struct prestera_event *evt)
 	return 0;
 }
 
+static int prestera_fw_parse_fdb_evt(u8 *msg, struct prestera_event *evt)
+{
+	struct prestera_msg_event_fdb *hw_evt;
+
+	hw_evt = (struct prestera_msg_event_fdb *)msg;
+
+	evt->fdb_evt.port_id = hw_evt->port_id;
+	evt->fdb_evt.vid = hw_evt->vid;
+
+	memcpy(&evt->fdb_evt.data, &hw_evt->param, sizeof(u8) * ETH_ALEN);
+
+	return 0;
+}
+
 static struct prestera_fw_evt_parser {
 	int (*func)(u8 *msg, struct prestera_event *evt);
 } fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
 	[PRESTERA_EVENT_TYPE_PORT] = {.func = prestera_fw_parse_port_evt},
+	[PRESTERA_EVENT_TYPE_FDB] = {.func = prestera_fw_parse_fdb_evt},
 };
 
 static struct prestera_fw_event_handler *
@@ -445,6 +526,17 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 	return 0;
 }
 
+int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing)
+{
+	struct prestera_msg_switch_attr_req req = {
+		.param = {.ageing_timeout = ageing},
+		.attr = PRESTERA_CMD_SWITCH_ATTR_AGEING,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_state_set(const struct prestera_port *port,
 			       bool admin_state)
 {
@@ -485,6 +577,20 @@ int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_accept_frm_type(struct prestera_port *port,
+				     enum prestera_accept_frm_type type)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.accept_frm_type = type}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps)
 {
@@ -830,13 +936,200 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
 	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
 	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
-	st->frames_1024_to_1518_octets = hw[PRESTERA_PORT_PKTS_1024TO1518L_CNT];
-	st->frames_1519_to_max_octets = hw[PRESTERA_PORT_PKTS_1519TOMAXL_CNT];
 	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
 
 	return 0;
 }
 
+int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_LEARNING,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.learning = enable}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_flood_set(struct prestera_port *port, bool flood)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {.flood = flood}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
+{
+	struct prestera_msg_vlan_req req = {
+		.vid = vid,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VLAN_CREATE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_vlan_delete(struct prestera_switch *sw, u16 vid)
+{
+	struct prestera_msg_vlan_req req = {
+		.vid = vid,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VLAN_DELETE,
+			    &req.cmd, sizeof(req));
+}
+int prestera_hw_vlan_port_set(struct prestera_port *port, u16 vid,
+			      bool is_member, bool untagged)
+{
+	struct prestera_msg_vlan_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid,
+		.is_member = is_member,
+		.is_tagged = untagged
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_VLAN_PORT_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_vlan_port_vid_set(struct prestera_port *port, u16 vid)
+{
+	struct prestera_msg_vlan_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_VLAN_PVID_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_fdb_add(struct prestera_port *port, const unsigned char *mac,
+			u16 vid, bool dynamic)
+{
+	struct prestera_msg_fdb_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid,
+		.dynamic = dynamic
+	};
+
+	memcpy(req.mac, mac, sizeof(req.mac));
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_ADD,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
+			u16 vid)
+{
+	struct prestera_msg_fdb_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid
+	};
+
+	memcpy(req.mac, mac, sizeof(req.mac));
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_fdb_flush_port(struct prestera_port *port, u32 mode)
+{
+	struct prestera_msg_fdb_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.flush_mode = mode,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT,
+			    &req.cmd, sizeof(req));
+}
+int prestera_hw_fdb_flush_vlan(struct prestera_switch *sw, u16 vid, u32 mode)
+{
+	struct prestera_msg_fdb_req req = {
+		.vid = vid,
+		.flush_mode = mode,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_VLAN,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
+				    u32 mode)
+{
+	struct prestera_msg_fdb_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid,
+		.flush_mode = mode,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT_VLAN,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_bridge_create(struct prestera_switch *sw, u16 *bridge_id)
+{
+	struct prestera_msg_bridge_resp resp;
+	struct prestera_msg_bridge_req req;
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_BRIDGE_CREATE,
+			       &req.cmd, sizeof(req),
+			       &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*bridge_id = resp.bridge;
+	return err;
+}
+
+int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id)
+{
+	struct prestera_msg_bridge_req req = {
+		.bridge = bridge_id
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_BRIDGE_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id)
+{
+	struct prestera_msg_bridge_req req = {
+		.bridge = bridge_id,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
+{
+	struct prestera_msg_bridge_req req = {
+		.bridge = bridge_id,
+		.port = port->hw_id,
+		.dev = port->dev_id
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index af2141834bbf..c8729451d606 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -9,6 +9,19 @@
 
 #include <linux/types.h>
 
+enum prestera_accept_frm_type {
+	PRESTERA_ACCEPT_FRAME_TYPE_TAGGED,
+	PRESTERA_ACCEPT_FRAME_TYPE_UNTAGGED,
+	PRESTERA_ACCEPT_FRAME_TYPE_ALL
+};
+
+enum prestera_fdb_flush_mode {
+	PRESTERA_FDB_FLUSH_MODE_DYNAMIC = BIT(0),
+	PRESTERA_FDB_FLUSH_MODE_STATIC = BIT(1),
+	PRESTERA_FDB_FLUSH_MODE_ALL = PRESTERA_FDB_FLUSH_MODE_DYNAMIC
+					| PRESTERA_FDB_FLUSH_MODE_STATIC,
+};
+
 enum {
 	PRESTERA_LINK_MODE_10baseT_Half,
 	PRESTERA_LINK_MODE_10baseT_Full,
@@ -82,6 +95,7 @@ struct prestera_rxtx_params;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
+int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing);
 int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac);
 
 /* Port API */
@@ -114,6 +128,32 @@ int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
 			      u8 *admin_mode);
 int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
+int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
+int prestera_hw_port_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_accept_frm_type(struct prestera_port *port,
+				     enum prestera_accept_frm_type type);
+/* Vlan API */
+int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid);
+int prestera_hw_vlan_delete(struct prestera_switch *sw, u16 vid);
+int prestera_hw_vlan_port_set(struct prestera_port *port, u16 vid,
+			      bool is_member, bool untagged);
+int prestera_hw_vlan_port_vid_set(struct prestera_port *port, u16 vid);
+
+/* FDB API */
+int prestera_hw_fdb_add(struct prestera_port *port, const unsigned char *mac,
+			u16 vid, bool dynamic);
+int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
+			u16 vid);
+int prestera_hw_fdb_flush_port(struct prestera_port *port, u32 mode);
+int prestera_hw_fdb_flush_vlan(struct prestera_switch *sw, u16 vid, u32 mode);
+int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
+				    u32 mode);
+
+/* Bridge API */
+int prestera_hw_bridge_create(struct prestera_switch *sw, u16 *bridge_id);
+int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id);
+int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id);
+int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id);
 
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
new file mode 100644
index 000000000000..b8d9c4d772d1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -0,0 +1,1176 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/if_vlan.h>
+#include <linux/if_bridge.h>
+#include <linux/notifier.h>
+#include <net/switchdev.h>
+#include <net/netevent.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+
+#define PRESTERA_DEFAULT_AGEING_TIME_MS 300
+#define PRESTERA_MAX_AGEING_TIME_MS 1000000
+#define PRESTERA_MIN_AGEING_TIME_MS 10
+
+struct prestera_fdb_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	unsigned long event;
+};
+
+struct prestera_switchdev {
+	struct prestera_switch *sw;
+	u32 ageing_time;
+	struct list_head bridge_list;
+	bool bridge_8021q_exists;
+	struct notifier_block swdev_nb_blk;
+	struct notifier_block swdev_nb;
+};
+
+struct prestera_bridge {
+	struct list_head head;
+	struct net_device *dev;
+	struct prestera_switchdev *swdev;
+	struct list_head port_list;
+	bool vlan_enabled;
+	u16 bridge_id;
+};
+
+struct prestera_bridge_port {
+	struct list_head head;
+	struct net_device *dev;
+	struct prestera_bridge *bridge;
+	struct list_head vlan_list;
+	refcount_t ref_count;
+	unsigned long flags;
+};
+
+struct prestera_bridge_vlan {
+	struct list_head br_port_node;
+	struct list_head port_vlan_list;
+	u16 vid;
+};
+
+struct prestera_port_vlan {
+	struct list_head list;
+	struct prestera_port *port;
+	struct prestera_bridge_port *br_port;
+	struct list_head bridge_vlan_node;
+	u16 vid;
+};
+
+static struct workqueue_struct *swdev_wq;
+
+static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
+
+static struct prestera_bridge_vlan *
+prestera_bridge_vlan_create(struct prestera_bridge_port *br_port, u16 vid)
+{
+	struct prestera_bridge_vlan *br_vlan;
+
+	br_vlan = kzalloc(sizeof(*br_vlan), GFP_KERNEL);
+	if (!br_vlan)
+		return NULL;
+
+	INIT_LIST_HEAD(&br_vlan->port_vlan_list);
+	br_vlan->vid = vid;
+	list_add(&br_vlan->br_port_node, &br_port->vlan_list);
+
+	return br_vlan;
+}
+
+static void prestera_bridge_vlan_destroy(struct prestera_bridge_vlan *br_vlan)
+{
+	list_del(&br_vlan->br_port_node);
+	WARN_ON(!list_empty(&br_vlan->port_vlan_list));
+	kfree(br_vlan);
+}
+
+static struct prestera_bridge_vlan *
+prestera_bridge_vlan_by_vid(struct prestera_bridge_port *br_port, u16 vid)
+{
+	struct prestera_bridge_vlan *br_vlan;
+
+	list_for_each_entry(br_vlan, &br_port->vlan_list, br_port_node) {
+		if (br_vlan->vid == vid)
+			return br_vlan;
+	}
+
+	return NULL;
+}
+
+static int prestera_bridge_vlan_port_count(struct prestera_bridge *bridge,
+					   u16 vid)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge_vlan *br_vlan;
+	int count = 0;
+
+	list_for_each_entry(br_port, &bridge->port_list, head) {
+		list_for_each_entry(br_vlan, &br_port->vlan_list, br_port_node) {
+			if (br_vlan->vid == vid) {
+				count += 1;
+				break;
+			}
+		}
+	}
+
+	return count;
+}
+
+static void prestera_bridge_vlan_put(struct prestera_bridge_vlan *br_vlan)
+{
+	if (list_empty(&br_vlan->port_vlan_list))
+		prestera_bridge_vlan_destroy(br_vlan);
+}
+
+static struct prestera_port_vlan *
+prestera_port_vlan_by_vid(struct prestera_port *port, u16 vid)
+{
+	struct prestera_port_vlan *port_vlan;
+
+	list_for_each_entry(port_vlan, &port->vlans_list, list) {
+		if (port_vlan->vid == vid)
+			return port_vlan;
+	}
+
+	return NULL;
+}
+
+static struct prestera_port_vlan *
+prestera_port_vlan_create(struct prestera_port *port, u16 vid, bool untagged)
+{
+	struct prestera_port_vlan *port_vlan;
+	int err;
+
+	port_vlan = prestera_port_vlan_by_vid(port, vid);
+	if (port_vlan)
+		return ERR_PTR(-EEXIST);
+
+	err = prestera_hw_vlan_port_set(port, vid, true, untagged);
+	if (err)
+		return ERR_PTR(err);
+
+	port_vlan = kzalloc(sizeof(*port_vlan), GFP_KERNEL);
+	if (!port_vlan) {
+		err = -ENOMEM;
+		goto err_port_vlan_alloc;
+	}
+
+	port_vlan->port = port;
+	port_vlan->vid = vid;
+
+	list_add(&port_vlan->list, &port->vlans_list);
+
+	return port_vlan;
+
+err_port_vlan_alloc:
+	prestera_hw_vlan_port_set(port, vid, false, false);
+	return ERR_PTR(err);
+}
+
+static void
+prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
+{
+	u32 fdb_flush_mode = PRESTERA_FDB_FLUSH_MODE_DYNAMIC;
+	struct prestera_port *port = port_vlan->port;
+	struct prestera_bridge_vlan *br_vlan;
+	struct prestera_bridge_port *br_port;
+	u16 vid = port_vlan->vid;
+	bool last_port, last_vlan;
+	int port_count;
+
+	br_port = port_vlan->br_port;
+	port_count = prestera_bridge_vlan_port_count(br_port->bridge, vid);
+	br_vlan = prestera_bridge_vlan_by_vid(br_port, vid);
+
+	last_vlan = list_is_singular(&br_port->vlan_list);
+	last_port = port_count == 1;
+
+	if (last_vlan)
+		prestera_hw_fdb_flush_port(port, fdb_flush_mode);
+	else if (last_port)
+		prestera_hw_fdb_flush_vlan(port->sw, vid, fdb_flush_mode);
+	else
+		prestera_hw_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
+
+	list_del(&port_vlan->bridge_vlan_node);
+	prestera_bridge_vlan_put(br_vlan);
+	prestera_bridge_port_put(br_port);
+	port_vlan->br_port = NULL;
+}
+
+void prestera_port_vlan_destroy(struct prestera_port_vlan *port_vlan)
+{
+	struct prestera_port *port = port_vlan->port;
+	u16 vid = port_vlan->vid;
+
+	if (port_vlan->br_port)
+		prestera_port_vlan_bridge_leave(port_vlan);
+
+	list_del(&port_vlan->list);
+	kfree(port_vlan);
+	prestera_hw_vlan_port_set(port, vid, false, false);
+}
+
+static struct prestera_bridge *
+prestera_bridge_create(struct prestera_switchdev *swdev, struct net_device *dev)
+{
+	bool vlan_enabled = br_vlan_enabled(dev);
+	struct prestera_bridge *bridge;
+	u16 bridge_id;
+	int err;
+
+	if (vlan_enabled && swdev->bridge_8021q_exists) {
+		netdev_err(dev, "Only one VLAN-aware bridge is supported\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return ERR_PTR(-ENOMEM);
+
+	if (vlan_enabled) {
+		swdev->bridge_8021q_exists = true;
+	} else {
+		err = prestera_hw_bridge_create(swdev->sw, &bridge_id);
+		if (err) {
+			kfree(bridge);
+			return ERR_PTR(err);
+		}
+
+		bridge->bridge_id = bridge_id;
+	}
+
+	bridge->vlan_enabled = vlan_enabled;
+	bridge->swdev = swdev;
+	bridge->dev = dev;
+
+	INIT_LIST_HEAD(&bridge->port_list);
+
+	list_add(&bridge->head, &swdev->bridge_list);
+
+	return bridge;
+}
+
+static void prestera_bridge_destroy(struct prestera_bridge *bridge)
+{
+	struct prestera_switchdev *swdev = bridge->swdev;
+
+	list_del(&bridge->head);
+
+	if (bridge->vlan_enabled)
+		swdev->bridge_8021q_exists = false;
+	else
+		prestera_hw_bridge_delete(swdev->sw, bridge->bridge_id);
+
+	WARN_ON(!list_empty(&bridge->port_list));
+	kfree(bridge);
+}
+
+static void prestera_bridge_put(struct prestera_bridge *bridge)
+{
+	if (list_empty(&bridge->port_list))
+		prestera_bridge_destroy(bridge);
+}
+
+struct prestera_bridge *prestera_bridge_by_dev(struct prestera_switchdev *swdev,
+					       const struct net_device *dev)
+{
+	struct prestera_bridge *bridge;
+
+	list_for_each_entry(bridge, &swdev->bridge_list, head)
+		if (bridge->dev == dev)
+			return bridge;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+__prestera_bridge_port_by_dev(struct prestera_bridge *bridge,
+			      struct net_device *dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &bridge->port_list, head) {
+		if (br_port->dev == dev)
+			return br_port;
+	}
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_by_dev(struct prestera_switchdev *swdev,
+			    struct net_device *dev)
+{
+	struct net_device *br_dev = netdev_master_upper_dev_get(dev);
+	struct prestera_bridge *bridge;
+
+	if (!br_dev)
+		return NULL;
+
+	bridge = prestera_bridge_by_dev(swdev, br_dev);
+	if (!bridge)
+		return NULL;
+
+	return __prestera_bridge_port_by_dev(bridge, dev);
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_create(struct prestera_bridge *bridge,
+			    struct net_device *dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	br_port = kzalloc(sizeof(*br_port), GFP_KERNEL);
+	if (!br_port)
+		return NULL;
+
+	br_port->flags = BR_LEARNING | BR_FLOOD | BR_LEARNING_SYNC |
+				BR_MCAST_FLOOD;
+	refcount_set(&br_port->ref_count, 1);
+	br_port->bridge = bridge;
+	br_port->dev = dev;
+
+	INIT_LIST_HEAD(&br_port->vlan_list);
+	list_add(&br_port->head, &bridge->port_list);
+
+	return br_port;
+}
+
+static void
+prestera_bridge_port_destroy(struct prestera_bridge_port *br_port)
+{
+	list_del(&br_port->head);
+	WARN_ON(!list_empty(&br_port->vlan_list));
+	kfree(br_port);
+}
+
+static void prestera_bridge_port_get(struct prestera_bridge_port *br_port)
+{
+	refcount_inc(&br_port->ref_count);
+}
+
+static void prestera_bridge_port_put(struct prestera_bridge_port *br_port)
+{
+	struct prestera_bridge *bridge = br_port->bridge;
+
+	if (refcount_dec_and_test(&br_port->ref_count)) {
+		prestera_bridge_port_destroy(br_port);
+		prestera_bridge_put(bridge);
+	}
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_add(struct prestera_bridge *bridge, struct net_device *dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	br_port = __prestera_bridge_port_by_dev(bridge, dev);
+	if (br_port) {
+		prestera_bridge_port_get(br_port);
+		return br_port;
+	}
+
+	br_port = prestera_bridge_port_create(bridge, dev);
+	if (!br_port)
+		return ERR_PTR(-ENOMEM);
+
+	return br_port;
+}
+
+static int
+prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
+{
+	struct prestera_port *port = netdev_priv(br_port->dev);
+	struct prestera_bridge *bridge = br_port->bridge;
+	int err;
+
+	err = prestera_hw_bridge_port_add(port, bridge->bridge_id);
+	if (err)
+		return err;
+
+	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_port_flood_set;
+
+	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_port_learning_set;
+
+	return err;
+
+err_port_learning_set:
+	prestera_hw_port_flood_set(port, false);
+err_port_flood_set:
+	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
+
+	return err;
+}
+
+static int prestera_port_bridge_join(struct prestera_port *port,
+				     struct net_device *upper)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_switchdev *swdev;
+	struct prestera_bridge *bridge;
+	int err;
+
+	swdev = port->sw->swdev;
+
+	bridge = prestera_bridge_by_dev(swdev, upper);
+	if (!bridge) {
+		bridge = prestera_bridge_create(swdev, upper);
+		if (IS_ERR(bridge))
+			return PTR_ERR(bridge);
+	}
+
+	br_port = prestera_bridge_port_add(bridge, port->dev);
+	if (IS_ERR(br_port)) {
+		err = PTR_ERR(br_port);
+		goto err_brport_create;
+	}
+
+	if (bridge->vlan_enabled)
+		return 0;
+
+	err = prestera_bridge_1d_port_join(br_port);
+	if (err)
+		goto err_port_join;
+
+	return 0;
+
+err_port_join:
+	prestera_bridge_port_put(br_port);
+err_brport_create:
+	prestera_bridge_put(bridge);
+	return err;
+}
+
+static void prestera_bridge_1q_port_leave(struct prestera_bridge_port *br_port)
+{
+	struct prestera_port *port = netdev_priv(br_port->dev);
+
+	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
+	prestera_port_pvid_set(port, PRESTERA_DEFAULT_VID);
+}
+
+static void prestera_bridge_1d_port_leave(struct prestera_bridge_port *br_port)
+{
+	struct prestera_port *port = netdev_priv(br_port->dev);
+
+	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
+	prestera_hw_bridge_port_delete(port, br_port->bridge->bridge_id);
+}
+
+static void prestera_port_bridge_leave(struct prestera_port *port,
+				       struct net_device *upper)
+{
+	struct prestera_switchdev *swdev = port->sw->swdev;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *bridge;
+
+	bridge = prestera_bridge_by_dev(swdev, upper);
+	if (!bridge)
+		return;
+
+	br_port = __prestera_bridge_port_by_dev(bridge, port->dev);
+	if (!br_port)
+		return;
+
+	bridge = br_port->bridge;
+
+	if (bridge->vlan_enabled)
+		prestera_bridge_1q_port_leave(br_port);
+	else
+		prestera_bridge_1d_port_leave(br_port);
+
+	prestera_hw_port_learning_set(port, false);
+	prestera_hw_port_flood_set(port, false);
+	prestera_bridge_port_put(br_port);
+}
+
+int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
+			       void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
+	struct prestera_port *port;
+	struct net_device *upper;
+	int err = 0;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+	port = netdev_priv(dev);
+	upper = info->upper_dev;
+
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		if (!netif_is_bridge_master(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+			return -EINVAL;
+		}
+
+		if (!info->linking)
+			break;
+
+		if (netdev_has_any_upper_dev(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
+			return -EINVAL;
+		}
+		break;
+
+	case NETDEV_CHANGEUPPER:
+		if (!netif_is_bridge_master(upper))
+			break;
+
+		if (info->linking)
+			err = prestera_port_bridge_join(port, upper);
+		else
+			prestera_port_bridge_leave(port, upper);
+		break;
+	}
+
+	return err;
+}
+
+static int prestera_port_attr_br_flags_set(struct prestera_port *port,
+					   struct switchdev_trans *trans,
+					   struct net_device *dev,
+					   unsigned long flags)
+{
+	struct prestera_bridge_port *br_port;
+	int err;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
+	if (!br_port)
+		return 0;
+
+	err = prestera_hw_port_flood_set(port, flags & BR_FLOOD);
+	if (err)
+		return err;
+
+	err = prestera_hw_port_learning_set(port, flags & BR_LEARNING);
+	if (err)
+		return err;
+
+	memcpy(&br_port->flags, &flags, sizeof(flags));
+	return 0;
+}
+
+static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
+					    struct switchdev_trans *trans,
+					    unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
+	struct prestera_switch *sw = port->sw;
+	int err;
+
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (ageing_time < PRESTERA_MIN_AGEING_TIME_MS ||
+		    ageing_time > PRESTERA_MAX_AGEING_TIME_MS)
+			return -ERANGE;
+		else
+			return 0;
+	}
+
+	err = prestera_hw_switch_ageing_set(sw, ageing_time);
+	if (!err)
+		sw->swdev->ageing_time = ageing_time;
+
+	return err;
+}
+
+static int prestera_port_attr_br_vlan_set(struct prestera_port *port,
+					  struct switchdev_trans *trans,
+					  struct net_device *dev,
+					  bool vlan_enabled)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge *bridge;
+
+	if (!switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	bridge = prestera_bridge_by_dev(sw->swdev, dev);
+	if (WARN_ON(!bridge))
+		return -EINVAL;
+
+	if (bridge->vlan_enabled == vlan_enabled)
+		return 0;
+
+	netdev_err(bridge->dev, "VLAN filtering can't be changed for existing bridge\n");
+
+	return -EINVAL;
+}
+
+static int prestera_port_obj_attr_set(struct net_device *dev,
+				      const struct switchdev_attr *attr,
+				      struct switchdev_trans *trans)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err = 0;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		err = -EOPNOTSUPP;
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (attr->u.brport_flags &
+		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+			err = -EINVAL;
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		err = prestera_port_attr_br_flags_set(port, trans,
+						      attr->orig_dev,
+						      attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		err = prestera_port_attr_br_ageing_set(port, trans,
+						      attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		err = prestera_port_attr_br_vlan_set(port, trans,
+						     attr->orig_dev,
+						     attr->u.vlan_filtering);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static void
+prestera_fdb_offload_notify(struct prestera_port *port,
+			    struct switchdev_notifier_fdb_info *info)
+{
+	struct switchdev_notifier_fdb_info send_info;
+
+	send_info.addr = info->addr;
+	send_info.vid = info->vid;
+	send_info.offloaded = true;
+
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, port->dev,
+				 &send_info.info, NULL);
+}
+
+static int prestera_port_fdb_set(struct prestera_port *port,
+				 struct switchdev_notifier_fdb_info *fdb_info,
+				 bool adding)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *bridge;
+	int err;
+	u16 vid;
+
+	br_port = prestera_bridge_port_by_dev(sw->swdev, port->dev);
+	if (!br_port)
+		return -EINVAL;
+
+	bridge = br_port->bridge;
+
+	if (bridge->vlan_enabled)
+		vid = fdb_info->vid;
+	else
+		vid = bridge->bridge_id;
+
+	if (adding)
+		err = prestera_hw_fdb_add(port, fdb_info->addr, vid, false);
+	else
+		err = prestera_hw_fdb_del(port, fdb_info->addr, vid);
+
+	return err;
+}
+
+static void prestera_fdb_event_work(struct work_struct *work)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct prestera_fdb_event_work *swdev_work;
+	struct prestera_port *port;
+	struct net_device *dev;
+	int err = 0;
+
+	swdev_work = container_of(work, struct prestera_fdb_event_work, work);
+	dev = swdev_work->dev;
+
+	rtnl_lock();
+
+	port = prestera_port_dev_lower_find(dev);
+	if (!port)
+		goto out;
+
+	switch (swdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fdb_info = &swdev_work->fdb_info;
+		if (!fdb_info->added_by_user)
+			break;
+
+		err = prestera_port_fdb_set(port, fdb_info, true);
+		if (err)
+			break;
+
+		prestera_fdb_offload_notify(port, fdb_info);
+		break;
+
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info = &swdev_work->fdb_info;
+		prestera_port_fdb_set(port, fdb_info, false);
+		break;
+	}
+
+out:
+	rtnl_unlock();
+
+	kfree(swdev_work->fdb_info.addr);
+	kfree(swdev_work);
+	dev_put(dev);
+}
+
+static int prestera_switchdev_event(struct notifier_block *unused,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	struct prestera_fdb_event_work *swdev_work;
+	struct net_device *upper;
+	int err = 0;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     prestera_netdev_check,
+						     prestera_port_obj_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		return NOTIFY_DONE;
+
+	if (!netif_is_bridge_master(upper))
+		return NOTIFY_DONE;
+
+	swdev_work = kzalloc(sizeof(*swdev_work), GFP_ATOMIC);
+	if (!swdev_work)
+		return NOTIFY_BAD;
+
+	swdev_work->event = event;
+	swdev_work->dev = dev;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+
+		INIT_WORK(&swdev_work->work, prestera_fdb_event_work);
+		memcpy(&swdev_work->fdb_info, ptr,
+		       sizeof(swdev_work->fdb_info));
+
+		swdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!swdev_work->fdb_info.addr)
+			goto out;
+
+		ether_addr_copy((u8 *)swdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(dev);
+
+		break;
+
+	default:
+		kfree(swdev_work);
+		return NOTIFY_DONE;
+	}
+
+	queue_work(swdev_wq, &swdev_work->work);
+	return NOTIFY_DONE;
+out:
+	kfree(swdev_work);
+	return NOTIFY_BAD;
+}
+
+static int
+prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
+			       struct prestera_bridge_port *br_port)
+{
+	struct prestera_port *port = port_vlan->port;
+	struct prestera_bridge_vlan *br_vlan;
+	u16 vid = port_vlan->vid;
+	int err;
+
+	if (port_vlan->br_port)
+		return 0;
+
+	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		return err;
+
+	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_port_learning_set;
+
+	br_vlan = prestera_bridge_vlan_by_vid(br_port, vid);
+	if (!br_vlan) {
+		br_vlan = prestera_bridge_vlan_create(br_port, vid);
+		if (!br_vlan) {
+			err = -ENOMEM;
+			goto err_bridge_vlan_get;
+		}
+	}
+
+	list_add(&port_vlan->bridge_vlan_node, &br_vlan->port_vlan_list);
+
+	prestera_bridge_port_get(br_port);
+	port_vlan->br_port = br_port;
+
+	return 0;
+
+err_bridge_vlan_get:
+	prestera_hw_port_learning_set(port, false);
+err_port_learning_set:
+	return err;
+}
+
+static int
+prestera_bridge_port_vlan_add(struct prestera_port *port,
+			      struct prestera_bridge_port *br_port,
+			      u16 vid, bool is_untagged, bool is_pvid,
+			      struct netlink_ext_ack *extack)
+{
+	struct prestera_port_vlan *port_vlan;
+	u16 old_pvid = port->pvid;
+	u16 pvid;
+	int err;
+
+	if (is_pvid)
+		pvid = vid;
+	else
+		pvid = port->pvid == vid ? 0 : port->pvid;
+
+	port_vlan = prestera_port_vlan_by_vid(port, vid);
+	if (port_vlan && port_vlan->br_port != br_port)
+		return -EEXIST;
+
+	if (!port_vlan) {
+		port_vlan = prestera_port_vlan_create(port, vid, is_untagged);
+		if (IS_ERR(port_vlan))
+			return PTR_ERR(port_vlan);
+	} else {
+		err = prestera_hw_vlan_port_set(port, vid, true, is_untagged);
+		if (err)
+			goto err_port_vlan_set;
+	}
+
+	err = prestera_port_pvid_set(port, pvid);
+	if (err)
+		goto err_port_pvid_set;
+
+	err = prestera_port_vlan_bridge_join(port_vlan, br_port);
+	if (err)
+		goto err_port_vlan_bridge_join;
+
+	return 0;
+
+err_port_vlan_bridge_join:
+	prestera_port_pvid_set(port, old_pvid);
+err_port_pvid_set:
+	prestera_hw_vlan_port_set(port, vid, false, false);
+err_port_vlan_set:
+	prestera_port_vlan_destroy(port_vlan);
+
+	return err;
+}
+
+static void
+prestera_bridge_port_vlan_del(struct prestera_port *port,
+			      struct prestera_bridge_port *br_port, u16 vid)
+{
+	u16 pvid = port->pvid == vid ? 0 : port->pvid;
+	struct prestera_port_vlan *port_vlan;
+
+	port_vlan = prestera_port_vlan_by_vid(port, vid);
+	if (WARN_ON(!port_vlan))
+		return;
+
+	prestera_port_vlan_bridge_leave(port_vlan);
+	prestera_port_pvid_set(port, pvid);
+	prestera_port_vlan_destroy(port_vlan);
+}
+
+static int prestera_port_vlans_add(struct prestera_port *port,
+				   const struct switchdev_obj_port_vlan *vlan,
+				   struct switchdev_trans *trans,
+				   struct netlink_ext_ack *extack)
+{
+	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool flag_pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct net_device *dev = vlan->obj.orig_dev;
+	struct prestera_bridge_port *br_port;
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge *bridge;
+	u16 vid;
+
+	if (netif_is_bridge_master(dev))
+		return 0;
+
+	if (switchdev_trans_ph_commit(trans))
+		return 0;
+
+	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
+	if (WARN_ON(!br_port))
+		return -EINVAL;
+
+	bridge = br_port->bridge;
+	if (!bridge->vlan_enabled)
+		return 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		int err;
+
+		err = prestera_bridge_port_vlan_add(port, br_port,
+						    vid, flag_untagged,
+						    flag_pvid, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int prestera_port_obj_add(struct net_device *dev,
+				 const struct switchdev_obj *obj,
+				 struct switchdev_trans *trans,
+				 struct netlink_ext_ack *extack)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	const struct switchdev_obj_port_vlan *vlan;
+	int err = 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		err = prestera_port_vlans_add(port, vlan, trans, extack);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int prestera_port_vlans_del(struct prestera_port *port,
+				   const struct switchdev_obj_port_vlan *vlan)
+{
+	struct net_device *dev = vlan->obj.orig_dev;
+	struct prestera_bridge_port *br_port;
+	struct prestera_switch *sw = port->sw;
+	u16 vid;
+
+	if (netif_is_bridge_master(dev))
+		return -EOPNOTSUPP;
+
+	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
+	if (WARN_ON(!br_port))
+		return -EINVAL;
+
+	if (!br_port->bridge->vlan_enabled)
+		return 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
+		prestera_bridge_port_vlan_del(port, br_port, vid);
+
+	return 0;
+}
+
+static int prestera_port_obj_del(struct net_device *dev,
+				 const struct switchdev_obj *obj)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	int err = 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int prestera_switchdev_blk_event(struct notifier_block *unused,
+					unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err = 0;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    prestera_netdev_check,
+						    prestera_port_obj_add);
+		break;
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    prestera_netdev_check,
+						    prestera_port_obj_del);
+		break;
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     prestera_netdev_check,
+						     prestera_port_obj_attr_set);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static void prestera_fdb_event(struct prestera_switch *sw,
+			       struct prestera_event *evt, void *arg)
+{
+	struct switchdev_notifier_fdb_info info;
+	struct prestera_port *port;
+
+	port = prestera_find_port(sw, evt->fdb_evt.port_id);
+	if (!port)
+		return;
+
+	info.addr = evt->fdb_evt.data.mac;
+	info.vid = evt->fdb_evt.vid;
+	info.offloaded = true;
+
+	rtnl_lock();
+
+	switch (evt->id) {
+	case PRESTERA_FDB_EVENT_LEARNED:
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+					 port->dev, &info.info, NULL);
+		break;
+	case PRESTERA_FDB_EVENT_AGED:
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+					 port->dev, &info.info, NULL);
+		break;
+	}
+
+	rtnl_unlock();
+}
+
+static int prestera_fdb_init(struct prestera_switch *sw)
+{
+	int err;
+
+	err = prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_FDB,
+						 prestera_fdb_event, NULL);
+	if (err)
+		return err;
+
+	err = prestera_hw_switch_ageing_set(sw, PRESTERA_DEFAULT_AGEING_TIME_MS);
+	if (err)
+		goto err_ageing_set;
+
+	return 0;
+
+err_ageing_set:
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_FDB,
+					     prestera_fdb_event);
+	return err;
+}
+
+static void prestera_fdb_fini(struct prestera_switch *sw)
+{
+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_FDB,
+					     prestera_fdb_event);
+}
+
+static int prestera_switchdev_handler_init(struct prestera_switchdev *swdev)
+{
+	int err;
+
+	swdev->swdev_nb.notifier_call = prestera_switchdev_event;
+	err = register_switchdev_notifier(&swdev->swdev_nb);
+	if (err)
+		goto err_register_swdev_notifier;
+
+	swdev->swdev_nb_blk.notifier_call = prestera_switchdev_blk_event;
+	err = register_switchdev_blocking_notifier(&swdev->swdev_nb_blk);
+	if (err)
+		goto err_register_blk_swdev_notifier;
+
+	return 0;
+
+err_register_blk_swdev_notifier:
+	unregister_switchdev_notifier(&swdev->swdev_nb);
+err_register_swdev_notifier:
+	destroy_workqueue(swdev_wq);
+	return err;
+}
+
+static void prestera_switchdev_handler_fini(struct prestera_switchdev *swdev)
+{
+	unregister_switchdev_blocking_notifier(&swdev->swdev_nb_blk);
+	unregister_switchdev_notifier(&swdev->swdev_nb);
+}
+
+int prestera_switchdev_init(struct prestera_switch *sw)
+{
+	struct prestera_switchdev *swdev;
+	int err;
+
+	swdev = kzalloc(sizeof(*swdev), GFP_KERNEL);
+	if (!swdev)
+		return -ENOMEM;
+
+	sw->swdev = swdev;
+	swdev->sw = sw;
+
+	INIT_LIST_HEAD(&swdev->bridge_list);
+
+	swdev_wq = alloc_ordered_workqueue("%s_ordered", 0, "prestera_br");
+	if (!swdev_wq) {
+		err = -ENOMEM;
+		goto err_alloc_wq;
+	}
+
+	err = prestera_switchdev_handler_init(swdev);
+	if (err)
+		goto err_swdev_init;
+
+	err = prestera_fdb_init(sw);
+	if (err)
+		goto err_fdb_init;
+
+	return 0;
+
+err_fdb_init:
+err_swdev_init:
+err_alloc_wq:
+	kfree(swdev);
+
+	return err;
+}
+
+void prestera_switchdev_fini(struct prestera_switch *sw)
+{
+	struct prestera_switchdev *swdev = sw->swdev;
+
+	prestera_fdb_fini(sw);
+	prestera_switchdev_handler_fini(swdev);
+	destroy_workqueue(swdev_wq);
+	kfree(swdev);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
new file mode 100644
index 000000000000..7b7aa2c12d9f
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
+
+#ifndef _PRESTERA_SWITCHDEV_H_
+#define _PRESTERA_SWITCHDEV_H_
+
+int prestera_switchdev_init(struct prestera_switch *sw);
+void prestera_switchdev_fini(struct prestera_switch *sw);
+
+int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
+			       void *ptr);
+
+#endif /* _PRESTERA_SWITCHDEV_H_ */
-- 
2.17.1

