Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B79C26CD3E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgIPU4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:56:32 -0400
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:19201
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbgIPQwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:52:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCbz24njTGjE+iqNhN9YEGV7SGo2eXDmwN62FCqKAgPPPnck1O5PUHkmwvRzZyBPsLZhAkM4rDnlof920kT66hzDooLEDccdsCEJ1NPvqCXKJgY+phWBkzpK0bx3Ao7+IKtTa1F2nJSpGhkVL5+79RzOY5Qw2+o1OHNwt0pe2TcmnckvHfsn8pVdEIeDcch+Mt0r03xUVqznZ3POQ5UUd0XxJgO8pQMNa3hBs7D5uABdaJlnYHSMWG4Eo/fIrPBq0CAaOSik9m7plYau/WDRamMlLdTBrZHq/9XGJ+IF381MiwekMgq8eGIQKHOf+b6DA4bECVaVWAuOSC/6098gtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDADhwarw+75rxP6ev0cPXEAARy7eHAY0zk4nlgA/BY=;
 b=aKOrON7KKz8IMjHQzcC0clycPMh68pyZRbUtz18ss86KgujA3iUCotYQ7dUHZnQ0eSS0rbu2on1/W2xJt4p5r5BaBZznPXYK2yMnjb5vjR474yR711VI/mcjCKhBtKtIjaxpLeUMi5zp6r7CUZ3GCvM2QJldSSUnqGYbxDeAonCQGxFO2GMaVK3lNqknybDZxZnZqEaQsJZJm8tQYzgCdsm0fis0djKavMHhXPhwDIrOHA468PUyW3KWtdOr0Oget8hFkaaKnyVDfv7hmGbWWU1H8wazurE87guAjuSKR6VIoP35RdnfbOYJWjsvU8rrmKujsqsKM+/H/GjTs12EIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDADhwarw+75rxP6ev0cPXEAARy7eHAY0zk4nlgA/BY=;
 b=gyYUmC/QNUYIF91njKDMVCERhU3A0yRrDDNJWXYl048Q34bL9TDZjons4mhL9/rS5jxvJaIhHCD3Zfo+lFnJTtAEZ5ynAvhJ33kHJFPpeo9i8eZ6QueTSeHoKoabXUscLDd+H2qOYsAZMqn+HPGsGeTM5S+uuKW8gkCUziBiLPw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0332.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.19; Wed, 16 Sep 2020 16:31:38 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 16:31:38 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net-next v9 5/6] net: marvell: prestera: Add Switchdev driver implementation
Date:   Wed, 16 Sep 2020 19:31:01 +0300
Message-Id: <20200916163102.3408-6-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916163102.3408-1-vadym.kochan@plvision.eu>
References: <20200916163102.3408-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0070.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::47) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR0202CA0070.eurprd02.prod.outlook.com (2603:10a6:20b:3a::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 16:31:36 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8079fec-4ca4-48a3-fb48-08d85a5dfc26
X-MS-TrafficTypeDiagnostic: HE1P190MB0332:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03323D7E7BF75970A173151895210@HE1P190MB0332.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYGZJozLmJO+ZeRdaeJLpSTqXRKW32Oy3HHTd4KS/9p6127/b/UMYQ+QZdcNK8ZjAM65J0GJNKUHuge5po8hBQljv5yHxtNNoIz7qZWcvaTzt60Q7uHM18Qkm55q/Xr2nYaSP1TaRv6U4VO1IGmWewoemWxOARW9B7dpcAW8JCnebOGidYlERrGf2CjlZxVo1Chqpc+RyO/hBZe0gEqGwkEo23Nt091JdrUPOCMmw39tJSHVE+Jd7WcZcLPETve7oVYQ6Mb2ULHZrZlnjSHG3AiiOJojtlEK2M7aSmf0HaxhUo8aqvDZd91A9zWIE3bw8wO5dLEt+STX86gtrQ959LPGflYEyo39nYj9nc45c9pC/0JqXGzPOac665dUEFQvpARkz8yojiqCc/gUJ3jlvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(110136005)(478600001)(66556008)(66946007)(8936002)(4326008)(66476007)(30864003)(8676002)(6666004)(6486002)(1076003)(86362001)(5660300002)(6512007)(36756003)(44832011)(83380400001)(2906002)(54906003)(6506007)(316002)(52116002)(26005)(107886003)(16526019)(186003)(2616005)(956004)(333604002)(921003)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HRe8fgukPdcKi47c69GTaQELfXXKH5yx7X2CLCI45AO4HILGGVoqXBfYsqQXZKqlBoIkJc5j3xR+vu9CH2iNLoYceayOouyYz3fCqCy1lUgsaAjXEU6jQe+5inQpcwvX1N2bn4GhnFzTnHZ4s/mAOFsZvthdtXMUgHdXN3A4C1YP+yYKKNYeRkJf6yjeqcBGLgEPgbe/QpulZuYNTXot0TK3iIvwq37O/F/U8Q8yuMneLVtYA5XCFdpIlP+SktcReZ1XVqIdZG2SfhheWJDEoLgrsDvp+jKqgQMyOSG+X+zompvwJ1LCYHEHCwKz3Kt0rr0OKZME+x7YVEIKxEQCj1JgVYB/Qb9SGBM/6gowsc/BEvVMRdb4hjKgf1GI/ZRJZmARaon7KL8bLOAPe8DXHzASBXlkc6vXjtf6gfHdJsbT6mXUViG12v3mVEZ3v0JrTLOOm2dJfYxphsE14nEttviZGkgJvS8S3hAPkePBHleXkUs6XyH9jjMTBHMzj69JF1bLHE1hwwCWDLcDTHcT4xiloDnIIhUtWh8UPfC2QELgz2JDdzfglI2bssYBp92utxoIzJKraPCPr87LfNAiYeSor17H/HCp8KKJ+RPabJlY7AZIZlcJEBqTdvVGsEM1ZmsGJwKkkdeWB76Xg3SSwQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b8079fec-4ca4-48a3-fb48-08d85a5dfc26
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:31:38.4345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dkf6r8/QgYbUdrQSDSH53K1GZUehlt5p94zwE+yIGDb1/QxEBXZfa2pbxEi+qhOnePAjlxNcal42P/L9Q5kWfYKKnPNT/1cek730tMDUaH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0332
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
    - FDB ageing timeout parameter is set globally per device

Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
PATCH v8:
    1) Add missing comma for last enum member.

    2) Add _ms suffix for ageing variable and struct member.

    3) Add comma for last member in initialized struct in prestera_hw.c

    4) Use ether_addr_copy() instead of memcpy() for mac FDB copying in prestera_hw.c

    5) Sorted includes.

    6) Fix ageing macro to be in ms instead of seconds.

    7) Do not intialize 'err' where it is not needed.

    8) Drop swdev->ageing_time member which is not used.

    9) Simplify prestera_port_attr_br_ageing_set() by simply
       return prestera_hw_switch_ageing_set(sw, ageing_time_ms), and remove err handling.

    10) Put license in one line.

PATCH v7:
    1) Add missing destroy_workqueue(swdev_wq) in prestera_switchdev.c:prestera_switchdev_init()
       on error path handling.

PATCH v5:
    0) Add Co-developed tag.

    1) Remove "," from terminated enum entry.

    2) Replace 'u8 *' -> 'void *' in prestera_fw_parse_fdb_evt(...)

    3) Use ether_addr_copy() in prestera_fw_parse_fdb_evt(...)

PATCH v4:
    1) Check for the prestera dev interface in switchdev event handler
       to ignore unsupported topology.

 .../net/ethernet/marvell/prestera/Makefile    |    3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   31 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  329 +++++
 .../ethernet/marvell/prestera/prestera_hw.h   |   48 +
 .../ethernet/marvell/prestera/prestera_main.c |  110 +-
 .../marvell/prestera/prestera_switchdev.c     | 1277 +++++++++++++++++
 .../marvell/prestera/prestera_switchdev.h     |   13 +
 7 files changed, 1807 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 7684e7047562..93129e32ebc5 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
-			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o
+			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
+			   prestera_switchdev.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 69628632e2bd..55aa4bf8a27c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -12,6 +12,8 @@
 
 #define PRESTERA_DRV_NAME	"prestera"
 
+#define PRESTERA_DEFAULT_VID    1
+
 struct prestera_fw_rev {
 	u16 maj;
 	u16 min;
@@ -66,11 +68,13 @@ struct prestera_port {
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
@@ -100,6 +104,7 @@ enum prestera_event_type {
 	PRESTERA_EVENT_TYPE_UNSPEC,
 
 	PRESTERA_EVENT_TYPE_PORT,
+	PRESTERA_EVENT_TYPE_FDB,
 	PRESTERA_EVENT_TYPE_RXTX,
 
 	PRESTERA_EVENT_TYPE_MAX
@@ -122,19 +127,37 @@ struct prestera_port_event {
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
 	rwlock_t port_list_lock;
@@ -172,4 +195,12 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
 			      u64 adver_link_modes, u8 adver_fec);
 
+struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
+
+struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
+
+int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
+
+bool prestera_netdev_check(const struct net_device *dev);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index e501f8c7dc50..0424718d5998 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -20,9 +20,27 @@ enum prestera_cmd_type_t {
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
 
+	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
+
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
 	PRESTERA_CMD_TYPE_MAX
 };
@@ -32,6 +50,9 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_MTU = 3,
 	PRESTERA_CMD_PORT_ATTR_MAC = 4,
 	PRESTERA_CMD_PORT_ATTR_SPEED = 5,
+	PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE = 6,
+	PRESTERA_CMD_PORT_ATTR_LEARNING = 7,
+	PRESTERA_CMD_PORT_ATTR_FLOOD = 8,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
 	PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY = 10,
 	PRESTERA_CMD_PORT_ATTR_REMOTE_FC = 11,
@@ -47,6 +68,7 @@ enum {
 
 enum {
 	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
+	PRESTERA_CMD_SWITCH_ATTR_AGEING = 2,
 };
 
 enum {
@@ -132,6 +154,7 @@ struct prestera_msg_common_resp {
 
 union prestera_msg_switch_param {
 	u8 mac[ETH_ALEN];
+	u32 ageing_timeout_ms;
 };
 
 struct prestera_msg_switch_attr_req {
@@ -170,7 +193,10 @@ union prestera_msg_port_param {
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
@@ -211,6 +237,46 @@ struct prestera_msg_port_info_resp {
 	u16 fp_id;
 };
 
+struct prestera_msg_vlan_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 vid;
+	u8  is_member;
+	u8  is_tagged;
+};
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
+};
+
+struct prestera_msg_bridge_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 bridge;
+};
+
+struct prestera_msg_bridge_resp {
+	struct prestera_msg_ret ret;
+	u16 bridge;
+};
+
+struct prestera_msg_stp_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 vid;
+	u8  state;
+};
+
 struct prestera_msg_rxtx_req {
 	struct prestera_msg_cmd cmd;
 	u8 use_sdma;
@@ -242,6 +308,18 @@ struct prestera_msg_event_port {
 	union prestera_msg_event_port_param param;
 };
 
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
+};
+
 static int __prestera_cmd_ret(struct prestera_switch *sw,
 			      enum prestera_cmd_type_t type,
 			      struct prestera_msg_cmd *cmd, size_t clen,
@@ -304,10 +382,23 @@ static int prestera_fw_parse_port_evt(void *msg, struct prestera_event *evt)
 	return 0;
 }
 
+static int prestera_fw_parse_fdb_evt(void *msg, struct prestera_event *evt)
+{
+	struct prestera_msg_event_fdb *hw_evt = msg;
+
+	evt->fdb_evt.port_id = hw_evt->port_id;
+	evt->fdb_evt.vid = hw_evt->vid;
+
+	ether_addr_copy(evt->fdb_evt.data.mac, hw_evt->param.mac);
+
+	return 0;
+}
+
 static struct prestera_fw_evt_parser {
 	int (*func)(void *msg, struct prestera_event *evt);
 } fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
 	[PRESTERA_EVENT_TYPE_PORT] = { .func = prestera_fw_parse_port_evt },
+	[PRESTERA_EVENT_TYPE_FDB] = { .func = prestera_fw_parse_fdb_evt },
 };
 
 static struct prestera_fw_event_handler *
@@ -449,6 +540,19 @@ void prestera_hw_switch_fini(struct prestera_switch *sw)
 	WARN_ON(!list_empty(&sw->event_handlers));
 }
 
+int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing_ms)
+{
+	struct prestera_msg_switch_attr_req req = {
+		.attr = PRESTERA_CMD_SWITCH_ATTR_AGEING,
+		.param = {
+			.ageing_timeout_ms = ageing_ms,
+		},
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_state_set(const struct prestera_port *port,
 			       bool admin_state)
 {
@@ -494,6 +598,22 @@ int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_accept_frm_type(struct prestera_port *port,
+				     enum prestera_accept_frm_type type)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.accept_frm_type = type,
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps)
 {
@@ -853,6 +973,215 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 	return 0;
 }
 
+int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_LEARNING,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.learning = enable,
+		}
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
+		.param = {
+			.flood = flood,
+		}
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
+
+int prestera_hw_vlan_port_set(struct prestera_port *port, u16 vid,
+			      bool is_member, bool untagged)
+{
+	struct prestera_msg_vlan_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid,
+		.is_member = is_member,
+		.is_tagged = !untagged,
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
+		.vid = vid,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_VLAN_PVID_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_vlan_port_stp_set(struct prestera_port *port, u16 vid, u8 state)
+{
+	struct prestera_msg_stp_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.vid = vid,
+		.state = state,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_STP_PORT_SET,
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
+		.dynamic = dynamic,
+	};
+
+	ether_addr_copy(req.mac, mac);
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
+		.vid = vid,
+	};
+
+	ether_addr_copy(req.mac, mac);
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
+
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
+
+	return 0;
+}
+
+int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id)
+{
+	struct prestera_msg_bridge_req req = {
+		.bridge = bridge_id,
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
+		.dev = port->dev_id,
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
+		.dev = port->dev_id,
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
index 203c0daa4af1..b2b5ac95b4e3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -6,6 +6,19 @@
 
 #include <linux/types.h>
 
+enum prestera_accept_frm_type {
+	PRESTERA_ACCEPT_FRAME_TYPE_TAGGED,
+	PRESTERA_ACCEPT_FRAME_TYPE_UNTAGGED,
+	PRESTERA_ACCEPT_FRAME_TYPE_ALL,
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
@@ -69,6 +82,13 @@ enum {
 	PRESTERA_PORT_DUPLEX_FULL,
 };
 
+enum {
+	PRESTERA_STP_DISABLED,
+	PRESTERA_STP_BLOCK_LISTEN,
+	PRESTERA_STP_LEARN,
+	PRESTERA_STP_FORWARD,
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
@@ -84,6 +104,7 @@ struct prestera_rxtx_params;
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
 void prestera_hw_switch_fini(struct prestera_switch *sw);
+int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing_ms);
 int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac);
 
 /* Port API */
@@ -116,6 +137,33 @@ int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
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
+int prestera_hw_vlan_port_stp_set(struct prestera_port *port, u16 vid, u8 state);
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
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index bb51ee5646cd..9bd57b89d1d0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera_rxtx.h"
 #include "prestera_devlink.h"
 #include "prestera_ethtool.h"
+#include "prestera_switchdev.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
 
@@ -23,6 +24,29 @@
 
 static struct workqueue_struct *prestera_wq;
 
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
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id)
 {
@@ -38,8 +62,7 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 	return port;
 }
 
-static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
-						u32 id)
+struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 {
 	struct prestera_port *port = NULL;
 
@@ -261,6 +284,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	port = netdev_priv(dev);
 
+	INIT_LIST_HEAD(&port->vlans_list);
+	port->pvid = PRESTERA_DEFAULT_VID;
 	port->dev = dev;
 	port->id = id;
 	port->sw = sw;
@@ -452,6 +477,71 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
 
+bool prestera_netdev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &prestera_netdev_ops;
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
+	struct prestera_port *port = NULL;
+
+	if (prestera_netdev_check(dev))
+		return netdev_priv(dev);
+
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
+	default:
+		return 0;
+	}
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
@@ -469,10 +559,18 @@ static int prestera_switch_init(struct prestera_switch *sw)
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
 		goto err_handlers_register;
@@ -493,6 +591,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
+err_rxtx_register:
+	prestera_switchdev_fini(sw);
+err_swdev_register:
+	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
 
 	return err;
@@ -504,6 +606,8 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
+	prestera_switchdev_fini(sw);
+	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
new file mode 100644
index 000000000000..7d83e1f91ef1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -0,0 +1,1277 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <net/netevent.h>
+#include <net/switchdev.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_switchdev.h"
+
+#define PRESTERA_VID_ALL (0xffff)
+
+#define PRESTERA_DEFAULT_AGEING_TIME_MS 300000
+#define PRESTERA_MAX_AGEING_TIME_MS 1000000000
+#define PRESTERA_MIN_AGEING_TIME_MS 32000
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
+	u8 stp_state;
+};
+
+struct prestera_bridge_vlan {
+	struct list_head head;
+	struct list_head port_vlan_list;
+	u16 vid;
+};
+
+struct prestera_port_vlan {
+	struct list_head br_vlan_head;
+	struct list_head port_head;
+	struct prestera_port *port;
+	struct prestera_bridge_port *br_port;
+	u16 vid;
+};
+
+static struct workqueue_struct *swdev_wq;
+
+static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
+
+static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
+				     u8 state);
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
+	list_add(&br_vlan->head, &br_port->vlan_list);
+
+	return br_vlan;
+}
+
+static void prestera_bridge_vlan_destroy(struct prestera_bridge_vlan *br_vlan)
+{
+	list_del(&br_vlan->head);
+	WARN_ON(!list_empty(&br_vlan->port_vlan_list));
+	kfree(br_vlan);
+}
+
+static struct prestera_bridge_vlan *
+prestera_bridge_vlan_by_vid(struct prestera_bridge_port *br_port, u16 vid)
+{
+	struct prestera_bridge_vlan *br_vlan;
+
+	list_for_each_entry(br_vlan, &br_port->vlan_list, head) {
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
+		list_for_each_entry(br_vlan, &br_port->vlan_list, head) {
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
+	list_for_each_entry(port_vlan, &port->vlans_list, port_head) {
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
+	list_add(&port_vlan->port_head, &port->vlans_list);
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
+	bool last_port, last_vlan;
+	u16 vid = port_vlan->vid;
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
+	list_del(&port_vlan->br_vlan_head);
+	prestera_bridge_vlan_put(br_vlan);
+	prestera_bridge_port_put(br_port);
+	port_vlan->br_port = NULL;
+}
+
+static void prestera_port_vlan_destroy(struct prestera_port_vlan *port_vlan)
+{
+	struct prestera_port *port = port_vlan->port;
+	u16 vid = port_vlan->vid;
+
+	if (port_vlan->br_port)
+		prestera_port_vlan_bridge_leave(port_vlan);
+
+	prestera_hw_vlan_port_set(port, vid, false, false);
+	list_del(&port_vlan->port_head);
+	kfree(port_vlan);
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
+static
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
+	br_port->stp_state = BR_STATE_DISABLED;
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
+	return 0;
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
+	struct prestera_switchdev *swdev = port->sw->swdev;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *bridge;
+	int err;
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
+static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
+				     u8 state)
+{
+	u8 hw_state = state;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		hw_state = PRESTERA_STP_DISABLED;
+		break;
+
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		hw_state = PRESTERA_STP_BLOCK_LISTEN;
+		break;
+
+	case BR_STATE_LEARNING:
+		hw_state = PRESTERA_STP_LEARN;
+		break;
+
+	case BR_STATE_FORWARDING:
+		hw_state = PRESTERA_STP_FORWARD;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return prestera_hw_vlan_port_stp_set(port, vid, hw_state);
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
+	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
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
+	int err;
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
+		if (info->linking) {
+			err = prestera_port_bridge_join(port, upper);
+			if (err)
+				return err;
+		} else {
+			prestera_port_bridge_leave(port, upper);
+		}
+		break;
+	}
+
+	return 0;
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
+
+	return 0;
+}
+
+static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
+					    struct switchdev_trans *trans,
+					    unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time_ms = jiffies_to_msecs(ageing_jiffies);
+	struct prestera_switch *sw = port->sw;
+
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (ageing_time_ms < PRESTERA_MIN_AGEING_TIME_MS ||
+		    ageing_time_ms > PRESTERA_MAX_AGEING_TIME_MS)
+			return -ERANGE;
+		else
+			return 0;
+	}
+
+	return prestera_hw_switch_ageing_set(sw, ageing_time_ms);
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
+static int prestera_port_bridge_vlan_stp_set(struct prestera_port *port,
+					     struct prestera_bridge_vlan *br_vlan,
+					     u8 state)
+{
+	struct prestera_port_vlan *port_vlan;
+
+	list_for_each_entry(port_vlan, &br_vlan->port_vlan_list, br_vlan_head) {
+		if (port_vlan->port != port)
+			continue;
+
+		return prestera_port_vid_stp_set(port, br_vlan->vid, state);
+	}
+
+	return 0;
+}
+
+static int presterar_port_attr_stp_state_set(struct prestera_port *port,
+					     struct switchdev_trans *trans,
+					     struct net_device *dev,
+					     u8 state)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge_vlan *br_vlan;
+	int err;
+	u16 vid;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
+	if (!br_port)
+		return 0;
+
+	if (!br_port->bridge->vlan_enabled) {
+		vid = br_port->bridge->bridge_id;
+		err = prestera_port_vid_stp_set(port, vid, state);
+		if (err)
+			goto err_port_stp_set;
+	} else {
+		list_for_each_entry(br_vlan, &br_port->vlan_list, head) {
+			err = prestera_port_bridge_vlan_stp_set(port, br_vlan,
+								state);
+			if (err)
+				goto err_port_vlan_stp_set;
+		}
+	}
+
+	br_port->stp_state = state;
+
+	return 0;
+
+err_port_vlan_stp_set:
+	list_for_each_entry_continue_reverse(br_vlan, &br_port->vlan_list, head)
+		prestera_port_bridge_vlan_stp_set(port, br_vlan, br_port->stp_state);
+	return err;
+
+err_port_stp_set:
+	prestera_port_vid_stp_set(port, vid, br_port->stp_state);
+
+	return err;
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
+		err = presterar_port_attr_stp_state_set(port, trans,
+							attr->orig_dev,
+							attr->u.stp_state);
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
+						       attr->u.ageing_time);
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
+	int err;
+
+	swdev_work = container_of(work, struct prestera_fdb_event_work, work);
+	dev = swdev_work->dev;
+
+	rtnl_lock();
+
+	port = prestera_port_dev_lower_find(dev);
+	if (!port)
+		goto out_unlock;
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
+out_unlock:
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
+	int err;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     prestera_netdev_check,
+						     prestera_port_obj_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	if (!prestera_netdev_check(dev))
+		return NOTIFY_DONE;
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
+			goto out_bad;
+
+		ether_addr_copy((u8 *)swdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(dev);
+		break;
+
+	default:
+		kfree(swdev_work);
+		return NOTIFY_DONE;
+	}
+
+	queue_work(swdev_wq, &swdev_work->work);
+	return NOTIFY_DONE;
+
+out_bad:
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
+	err = prestera_port_vid_stp_set(port, vid, br_port->stp_state);
+	if (err)
+		goto err_port_vid_stp_set;
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
+	list_add(&port_vlan->br_vlan_head, &br_vlan->port_vlan_list);
+
+	prestera_bridge_port_get(br_port);
+	port_vlan->br_port = br_port;
+
+	return 0;
+
+err_bridge_vlan_get:
+	prestera_port_vid_stp_set(port, vid, BR_STATE_FORWARDING);
+err_port_vid_stp_set:
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
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		return prestera_port_vlans_add(port, vlan, trans, extack);
+	default:
+		return -EOPNOTSUPP;
+	}
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
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int prestera_switchdev_blk_event(struct notifier_block *unused,
+					unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
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
+	destroy_workqueue(swdev_wq);
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
index 000000000000..606e21d2355b
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
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

