Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21CA3A2FA1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhFJPqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:46:05 -0400
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:46158
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231743AbhFJPp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 11:45:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9OE5hBwAii+SNg8zUNLE9MFf0uMuc3Rz45oTw3YzZ+mKugxpK0Ne2NdeE21chEtSOqf1HVVxOl6lkRY9KZRVh1e+THdfPf1zrlM2pNjfiFhZ1uERU5ZZYTcQtfhOoFM/qjABV02IV7j60fFIz5GqFnbwMe/o1g02a+gpzREHAYQmd1XDxvFcuhy96XLLT2nlS/d4GFkEZAWQL3Nk9Xuxq/wdt/8gz9nYfzvm27KAd2rx4BAcYfUzHa+69oJeMpxtIkbIQ6nNfo198F10MwNS2OCA24pFFQnCHjGgx4HY+rVNp99KrdfZk0w2yZq0QT9C5FehiytiuK4AJdQtzrwWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voJDKOSoSYQEeZlh07zYolDikJLAoZbY19pU5zv+36k=;
 b=ofqr/vDAmji8ZGM9mjKg7UR4ecNvGn6mS0lTKYrGBXlPN5HIux1WPYbzZqyblobGNnsq0bq2fcTWF7JAh8rfCg3lSvxQKs+KujR0Jf/QZvOSsiRsxEaxCIstXV21lJDVxnKDhPzOGZgneG7xftsZIgUhR/vS5XQu91Plz+8XvXIb82YgFiclhd0x02UYXaH1MEyt7n0ahJ49Jhsku5R5Idflc9Rus9IrVrCQfwop9PWjeifCa1PrZHoSY+iDk4OG2UZSRXXKhnObQ/ODFYU5mASvb06FNykxOBInHKeYDqKTZ6QU2PUh/9CKA+mLwRZgIl4CTEdaOyLme82BrreQHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voJDKOSoSYQEeZlh07zYolDikJLAoZbY19pU5zv+36k=;
 b=x+gck0MjxZPZUObmyQFZHK+EzkMK3pZjc47fGCpkdBj1VQhYK4xEacu/BUx3EuW/J0TecdaSeFj9Tv2Rj5myT7Z7sYYOJdlV09c2jZn0wjt1cBAW+u4V+qkuSbOM8hMtb7JF1qyjtNyt+uwcea2p1V70xpUZFGZtbGBvabUXgKA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Thu, 10 Jun 2021 15:43:51 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 15:43:51 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH v2 3/3] net: marvell: prestera: add LAG support
Date:   Thu, 10 Jun 2021 18:43:11 +0300
Message-Id: <20210610154311.23818-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210610154311.23818-1-vadym.kochan@plvision.eu>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM3PR07CA0082.eurprd07.prod.outlook.com (2603:10a6:207:6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 15:43:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf0ca1c3-7a25-4f4d-296a-08d92c268b7b
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB026831CA3744A06DB1EEAF5895359@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VA2RcqpCZk2avtnBsxrdqp/e1vf9PI0WH6zMsNhZE2/rpy0v+2pThQgZtw0SzJvGP1iC9UW9zM5yNb0htJfvYP4Pvxqydf8tAZ0dpC0fJsGO5yjaYbT/aJkh8fnxBRljSUjRgRn5z0I1MEXvFaylC3VBN07a2P6qKRU9CiuwwcrezCZyhUC0y2QMqQvX7bk1O1fAs/cbOMUiSx8hIIognA96GkVTrbKouAhtxdRGXe8rlYtw0hUcXEzLDSaF6WPalklPfFyVIiD5oyiYCiPTllCsXomA11VjFpE3DwL2EMTz2PrdXRAJPF1qc90NLCFuezQgfB98j7z2DI1bx2vcMsbsHlqjQ7yRU7lCqQL6aL7AVuAXj14QT4tOWGIKKiLG2r5U5V52U+yhUpfXCQydXimlTWisATLQu2HKq4tlG9xQNhI/Hf9QdjcBGeVbAb/6cggQRvUJ71CMeyHz8PXDUtXdrjhJUv88WuxjAFuTOuKUIcJ/M7Rw6oxqnpaPv1dx8HRBpAsrzXKcBMmYF1N39fhj2bCdfsEBhg/BpYIk+/AlasMiaSywAhI2BtanMcFio1T89ubXwG3e8D1jnCS4fdpnIVj4TrgCDf0XDNmWZvDv9TuoCfhkL3RgXVm6D0yb6nOcDzWdyrUtkeAfSLqPoNPm04N9eHquZSFZTkUbSNPbcDn/Nple3rfm3cJRb3/Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(376002)(39830400003)(346002)(136003)(366004)(66476007)(66556008)(8936002)(66946007)(8676002)(6486002)(6512007)(478600001)(2906002)(83380400001)(1076003)(6666004)(186003)(30864003)(956004)(5660300002)(2616005)(6506007)(38350700002)(38100700002)(52116002)(36756003)(44832011)(110136005)(316002)(26005)(16526019)(54906003)(86362001)(4326008)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sNPjzKfktkPTn0ir0uI3x2p3DUWcaYQkz77+Gbm6Nlu8+5ByblsqkswvI2xV?=
 =?us-ascii?Q?woxtFJHixaERyL51/YXPoR8pR64GQh2H3vR9fQHSA4WLsHrs6qUN6HgIAPC6?=
 =?us-ascii?Q?avUSoaZsIxQMmP1jHKod96lzzoo8xFub3GIiv2CP0zomSr121G6nMkTAK1LD?=
 =?us-ascii?Q?nQKzD5sg6ACClhMO1EJuBeJLJoQTOa+x0WALw+l1gnVMmkD8qhCkQsnONuXA?=
 =?us-ascii?Q?7qgdNhfu/OCzzP0xfPbmxsb3vV8oH4dD24wrFux4IWl/xrgaZuLJ+PxYOO5L?=
 =?us-ascii?Q?ZifUerUEZlB7bJZjCtks2b56REnPd7x2j2+0VEeamwvlmAeXPjF4qTTMRMIp?=
 =?us-ascii?Q?m30DLAM/3e3Y2h+Ma/j5rFW19Q82Q9elGUXumAquHxY+7g0HaQ8Kc/mO+FWt?=
 =?us-ascii?Q?kvWbDbwBVg4Zq1GLsosrPfVsD6yZIsCGYAnUGXOSFPqYo1VDEuvH8PooInNO?=
 =?us-ascii?Q?u0+8/dj66FnFWSukt96U6dJcp5bxuHAVEvfn4afLgMe4/tRh6fPBiS59Ti0r?=
 =?us-ascii?Q?1vdh93w1tqGHKhb0EuPR2+HcmrsbyOBDNJLCFIcSyMhebdY7NrNJQGeUok8U?=
 =?us-ascii?Q?BPbAy0qHPkHrE6rIf+u8CLkXohn7bufc4avJegt/ffHHf9lCTxwufasfOswu?=
 =?us-ascii?Q?TljxXTfXoChc0y0d298n4D4HTB4jwldc62Iizbrns5bfKozLA0tR+HwKEoB3?=
 =?us-ascii?Q?+uP6z4d0rFIxJy2VhTURInkrzR5sL6w+O5cZdMDPz7UjguxAAuvqNGkJRlHX?=
 =?us-ascii?Q?+/MdwVwNZ1RzK+qrgcCKULCwM+cwiClIeViKpBX4TkjMGyoI2BlK0umZSBwz?=
 =?us-ascii?Q?M+ZT6z4Z2teXc4kxgO8unPjKxjfT6VZnT/CnkbNU4kIE7Ok0Ml3X4NHtDawT?=
 =?us-ascii?Q?lqdcdoN4evu1jYLE/JgHP+HRsF9c3W4jvje1dcPIyqMMQzkUxcE5NmBSYquh?=
 =?us-ascii?Q?0p2k27gxD74LRwvnkD7wjhQBsUkVH5wgof8LvknB81rGacCqeFFGVTWkT/M9?=
 =?us-ascii?Q?TBtStwJTxAGz6wynrlVBMr3vVwT02ZciHCl/ghjj0wHvFLyBotncITxr2TKe?=
 =?us-ascii?Q?PigIS9rMyylrqHFROQXCufUOruisJna7cjuZ8iFe6PsxORozh4Rx6AOO3IYz?=
 =?us-ascii?Q?8uO3xGgBCbHTi1C91wTWQdg63E2TgagLsYHlPUcRv9L0vLLlgRO+YNmN3mH2?=
 =?us-ascii?Q?WPlFsB1wII0Q6M7unxGyeiHvqgsOovVu4A0mfXzx7sDEx+MzEp7vl7Lvau98?=
 =?us-ascii?Q?dU1ica1xMcMqeSZsoOAegpo2FQM3OuBKCPeJEtjdwWHpKLV/89OEdkZ2qFwB?=
 =?us-ascii?Q?Ow3mdluu8lesOO5N2DW4+ynk?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0ca1c3-7a25-4f4d-296a-08d92c268b7b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 15:43:51.2748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5dZPjW3w2q12E8Mxl33Nrfy8ej1qbpjiZgaByoj4R1QN9Sqz7JbHI2Nc02Zqupm9BUJL38C1d/fd6D6o2dD7agx5NMZJU8yJ9wShUfD7ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

The following features are supported:

    - LAG basic operations
        - create/delete LAG
        - add/remove a member to LAG
        - enable/disable member in LAG
    - LAG Bridge support
    - LAG VLAN support
    - LAG FDB support

Limitations:

    - Only HASH lag tx type is supported
    - The Hash parameters are not configurable. They are applied
      during the LAG creation stage.
    - Enslaving a port to the LAG device that already has an
      upper device is not supported.

Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Co-developed-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
v2:
    1) Initialize 'lag' with NULL in prestera_lag_create()             [suggested by Vladimir Oltean]

    2) Use -ENOSPC in prestera_lag_port_add() if max lag               [suggested by Vladimir Oltean]
       numbers was reached.

    3) Check on info->link_up in prestera_netdev_port_lower_event()    [suggested by Vladimir Oltean]

    4) Return -EOPNOTSUPP in prestera_netdev_port_event() in case      [suggested by Vladimir Oltean]
       LAG hashing mode is not supported.

    5) Do not pass "lower" netdev to bridge join/leave functions.      [suggested by Vladimir Oltean]
       It is not need as offloading settings applied on particular
       physical port. It requires to do extra upper dev lookup
       in case port is in the LAG which is in the bridge on vlans add/del.

 .../net/ethernet/marvell/prestera/prestera.h  |  30 ++-
 .../ethernet/marvell/prestera/prestera_hw.c   | 180 +++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  14 ++
 .../ethernet/marvell/prestera/prestera_main.c | 235 +++++++++++++++++-
 .../marvell/prestera/prestera_switchdev.c     | 103 ++++++--
 5 files changed, 531 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 55aa4bf8a27c..ad0f33a7e517 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -60,10 +60,19 @@ struct prestera_port_caps {
 	u8 transceiver;
 };
 
+struct prestera_lag {
+	struct net_device *dev;
+	struct list_head members;
+	u16 member_count;
+	u16 lag_id;
+};
+
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
 	struct devlink_port dl_port;
+	struct list_head lag_member;
+	struct prestera_lag *lag;
 	u32 id;
 	u32 hw_id;
 	u32 dev_id;
@@ -127,6 +136,12 @@ struct prestera_port_event {
 	} data;
 };
 
+enum prestera_fdb_entry_type {
+	PRESTERA_FDB_ENTRY_TYPE_REG_PORT,
+	PRESTERA_FDB_ENTRY_TYPE_LAG,
+	PRESTERA_FDB_ENTRY_TYPE_MAX
+};
+
 enum prestera_fdb_event_id {
 	PRESTERA_FDB_EVENT_UNSPEC,
 	PRESTERA_FDB_EVENT_LEARNED,
@@ -134,7 +149,11 @@ enum prestera_fdb_event_id {
 };
 
 struct prestera_fdb_event {
-	u32 port_id;
+	enum prestera_fdb_entry_type type;
+	union {
+		u32 port_id;
+		u16 lag_id;
+	} dest;
 	u32 vid;
 	union {
 		u8 mac[ETH_ALEN];
@@ -165,6 +184,9 @@ struct prestera_switch {
 	u32 mtu_min;
 	u32 mtu_max;
 	u8 id;
+	struct prestera_lag *lags;
+	u8 lag_member_max;
+	u8 lag_max;
 };
 
 struct prestera_rxtx_params {
@@ -203,4 +225,10 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
 
+bool prestera_port_is_lag_member(const struct prestera_port *port);
+
+struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
+
+u16 prestera_port_lag_id(const struct prestera_port *port);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 96ce73b50fec..886ce251330e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -40,6 +40,11 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
+	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE = 0x901,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_ENABLE = 0x902,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_DISABLE = 0x903,
+
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
@@ -133,6 +138,12 @@ enum {
 	PRESTERA_FC_SYMM_ASYMM,
 };
 
+enum {
+	PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT = 0,
+	PRESTERA_HW_FDB_ENTRY_TYPE_LAG = 1,
+	PRESTERA_HW_FDB_ENTRY_TYPE_MAX = 2,
+};
+
 struct prestera_fw_event_handler {
 	struct list_head list;
 	struct rcu_head rcu;
@@ -174,6 +185,8 @@ struct prestera_msg_switch_init_resp {
 	u32 port_count;
 	u32 mtu_max;
 	u8  switch_id;
+	u8  lag_max;
+	u8  lag_member_max;
 };
 
 struct prestera_msg_port_autoneg_param {
@@ -261,8 +274,13 @@ struct prestera_msg_vlan_req {
 struct prestera_msg_fdb_req {
 	struct prestera_msg_cmd cmd;
 	u8 dest_type;
-	u32 port;
-	u32 dev;
+	union {
+		struct {
+			u32 port;
+			u32 dev;
+		};
+		u16 lag_id;
+	} dest;
 	u8  mac[ETH_ALEN];
 	u16 vid;
 	u8  dynamic;
@@ -305,6 +323,13 @@ struct prestera_msg_rxtx_port_req {
 	u32 dev;
 };
 
+struct prestera_msg_lag_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u16 lag_id;
+};
+
 struct prestera_msg_event {
 	u16 type;
 	u16 id;
@@ -327,7 +352,10 @@ union prestera_msg_event_fdb_param {
 struct prestera_msg_event_fdb {
 	struct prestera_msg_event id;
 	u8 dest_type;
-	u32 port_id;
+	union {
+		u32 port_id;
+		u16 lag_id;
+	} dest;
 	u32 vid;
 	union prestera_msg_event_fdb_param param;
 };
@@ -398,7 +426,19 @@ static int prestera_fw_parse_fdb_evt(void *msg, struct prestera_event *evt)
 {
 	struct prestera_msg_event_fdb *hw_evt = msg;
 
-	evt->fdb_evt.port_id = hw_evt->port_id;
+	switch (hw_evt->dest_type) {
+	case PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT:
+		evt->fdb_evt.type = PRESTERA_FDB_ENTRY_TYPE_REG_PORT;
+		evt->fdb_evt.dest.port_id = hw_evt->dest.port_id;
+		break;
+	case PRESTERA_HW_FDB_ENTRY_TYPE_LAG:
+		evt->fdb_evt.type = PRESTERA_FDB_ENTRY_TYPE_LAG;
+		evt->fdb_evt.dest.lag_id = hw_evt->dest.lag_id;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	evt->fdb_evt.vid = hw_evt->vid;
 
 	ether_addr_copy(evt->fdb_evt.data.mac, hw_evt->param.mac);
@@ -543,6 +583,8 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 	sw->mtu_min = PRESTERA_MIN_MTU;
 	sw->mtu_max = resp.mtu_max;
 	sw->id = resp.switch_id;
+	sw->lag_member_max = resp.lag_member_max;
+	sw->lag_max = resp.lag_max;
 
 	return 0;
 }
@@ -1150,8 +1192,10 @@ int prestera_hw_fdb_add(struct prestera_port *port, const unsigned char *mac,
 			u16 vid, bool dynamic)
 {
 	struct prestera_msg_fdb_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.dest = {
+			.dev = port->dev_id,
+			.port = port->hw_id,
+		},
 		.vid = vid,
 		.dynamic = dynamic,
 	};
@@ -1166,8 +1210,10 @@ int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
 			u16 vid)
 {
 	struct prestera_msg_fdb_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.dest = {
+			.dev = port->dev_id,
+			.port = port->hw_id,
+		},
 		.vid = vid,
 	};
 
@@ -1177,11 +1223,48 @@ int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_lag_fdb_add(struct prestera_switch *sw, u16 lag_id,
+			    const unsigned char *mac, u16 vid, bool dynamic)
+{
+	struct prestera_msg_fdb_req req = {
+		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
+		.dest = {
+			.lag_id = lag_id,
+		},
+		.vid = vid,
+		.dynamic = dynamic,
+	};
+
+	ether_addr_copy(req.mac, mac);
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_ADD,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_lag_fdb_del(struct prestera_switch *sw, u16 lag_id,
+			    const unsigned char *mac, u16 vid)
+{
+	struct prestera_msg_fdb_req req = {
+		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
+		.dest = {
+			.lag_id = lag_id,
+		},
+		.vid = vid,
+	};
+
+	ether_addr_copy(req.mac, mac);
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_fdb_flush_port(struct prestera_port *port, u32 mode)
 {
 	struct prestera_msg_fdb_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.dest = {
+			.dev = port->dev_id,
+			.port = port->hw_id,
+		},
 		.flush_mode = mode,
 	};
 
@@ -1204,8 +1287,10 @@ int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
 				    u32 mode)
 {
 	struct prestera_msg_fdb_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.dest = {
+			.dev = port->dev_id,
+			.port = port->hw_id,
+		},
 		.vid = vid,
 		.flush_mode = mode,
 	};
@@ -1214,6 +1299,37 @@ int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_fdb_flush_lag(struct prestera_switch *sw, u16 lag_id,
+			      u32 mode)
+{
+	struct prestera_msg_fdb_req req = {
+		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
+		.dest = {
+			.lag_id = lag_id,
+		},
+		.flush_mode = mode,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_fdb_flush_lag_vlan(struct prestera_switch *sw,
+				   u16 lag_id, u16 vid, u32 mode)
+{
+	struct prestera_msg_fdb_req req = {
+		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
+		.dest = {
+			.lag_id = lag_id,
+		},
+		.vid = vid,
+		.flush_mode = mode,
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT_VLAN,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_bridge_create(struct prestera_switch *sw, u16 *bridge_id)
 {
 	struct prestera_msg_bridge_resp resp;
@@ -1295,6 +1411,46 @@ int prestera_hw_rxtx_port_init(struct prestera_port *port)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id)
+{
+	struct prestera_msg_lag_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.lag_id = lag_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_LAG_MEMBER_ADD,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_lag_member_del(struct prestera_port *port, u16 lag_id)
+{
+	struct prestera_msg_lag_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.lag_id = lag_id,
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_lag_member_enable(struct prestera_port *port, u16 lag_id,
+				  bool enable)
+{
+	struct prestera_msg_lag_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.lag_id = lag_id,
+	};
+	u32 cmd;
+
+	cmd = enable ? PRESTERA_CMD_TYPE_LAG_MEMBER_ENABLE :
+			PRESTERA_CMD_TYPE_LAG_MEMBER_DISABLE;
+
+	return prestera_cmd(port->sw, cmd, &req.cmd, sizeof(req));
+}
+
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
 				       prestera_event_cb_t fn,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index e8dd0e2b81d2..846bdc04e278 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -180,4 +180,18 @@ int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params);
 int prestera_hw_rxtx_port_init(struct prestera_port *port);
 
+/* LAG API */
+int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id);
+int prestera_hw_lag_member_del(struct prestera_port *port, u16 lag_id);
+int prestera_hw_lag_member_enable(struct prestera_port *port, u16 lag_id,
+				  bool enable);
+int prestera_hw_lag_fdb_add(struct prestera_switch *sw, u16 lag_id,
+			    const unsigned char *mac, u16 vid, bool dynamic);
+int prestera_hw_lag_fdb_del(struct prestera_switch *sw, u16 lag_id,
+			    const unsigned char *mac, u16 vid);
+int prestera_hw_fdb_flush_lag(struct prestera_switch *sw, u16 lag_id,
+			      u32 mode);
+int prestera_hw_fdb_flush_lag_vlan(struct prestera_switch *sw,
+				   u16 lag_id, u16 vid, u32 mode);
+
 #endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index bee477f44e06..d825fbdfa86f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -8,6 +8,7 @@
 #include <linux/netdev_features.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
+#include <linux/if_vlan.h>
 
 #include "prestera.h"
 #include "prestera_hw.h"
@@ -281,6 +282,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	INIT_LIST_HEAD(&port->vlans_list);
 	port->pvid = PRESTERA_DEFAULT_VID;
+	port->lag = NULL;
 	port->dev = dev;
 	port->id = id;
 	port->sw = sw;
@@ -472,6 +474,149 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
 
+struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id)
+{
+	return id < sw->lag_max ? &sw->lags[id] : NULL;
+}
+
+static struct prestera_lag *prestera_lag_by_dev(struct prestera_switch *sw,
+						struct net_device *dev)
+{
+	struct prestera_lag *lag;
+	u16 id;
+
+	for (id = 0; id < sw->lag_max; id++) {
+		lag = &sw->lags[id];
+		if (lag->dev == dev)
+			return lag;
+	}
+
+	return NULL;
+}
+
+static struct prestera_lag *prestera_lag_create(struct prestera_switch *sw,
+						struct net_device *lag_dev)
+{
+	struct prestera_lag *lag = NULL;
+	u16 id;
+
+	for (id = 0; id < sw->lag_max; id++) {
+		lag = &sw->lags[id];
+		if (!lag->dev)
+			break;
+	}
+	if (lag) {
+		INIT_LIST_HEAD(&lag->members);
+		lag->dev = lag_dev;
+	}
+
+	return lag;
+}
+
+static void prestera_lag_destroy(struct prestera_switch *sw,
+				 struct prestera_lag *lag)
+{
+	WARN_ON(!list_empty(&lag->members));
+	lag->member_count = 0;
+	lag->dev = NULL;
+}
+
+static int prestera_lag_port_add(struct prestera_port *port,
+				 struct net_device *lag_dev)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_lag *lag;
+	int err;
+
+	lag = prestera_lag_by_dev(sw, lag_dev);
+	if (!lag) {
+		lag = prestera_lag_create(sw, lag_dev);
+		if (!lag)
+			return -ENOSPC;
+	}
+
+	if (lag->member_count >= sw->lag_member_max)
+		return -ENOSPC;
+
+	err = prestera_hw_lag_member_add(port, lag->lag_id);
+	if (err) {
+		if (!lag->member_count)
+			prestera_lag_destroy(sw, lag);
+		return err;
+	}
+
+	list_add(&port->lag_member, &lag->members);
+	lag->member_count++;
+	port->lag = lag;
+
+	return 0;
+}
+
+static int prestera_lag_port_del(struct prestera_port *port)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_lag *lag = port->lag;
+	int err;
+
+	if (!lag || !lag->member_count)
+		return -EINVAL;
+
+	err = prestera_hw_lag_member_del(port, lag->lag_id);
+	if (err)
+		return err;
+
+	list_del(&port->lag_member);
+	lag->member_count--;
+	port->lag = NULL;
+
+	if (netif_is_bridge_port(lag->dev)) {
+		struct net_device *br_dev;
+
+		br_dev = netdev_master_upper_dev_get(lag->dev);
+
+		prestera_bridge_port_leave(br_dev, port);
+	}
+
+	if (!lag->member_count)
+		prestera_lag_destroy(sw, lag);
+
+	return 0;
+}
+
+bool prestera_port_is_lag_member(const struct prestera_port *port)
+{
+	return !!port->lag;
+}
+
+u16 prestera_port_lag_id(const struct prestera_port *port)
+{
+	return port->lag->lag_id;
+}
+
+static int prestera_lag_init(struct prestera_switch *sw)
+{
+	u16 id;
+
+	sw->lags = kcalloc(sw->lag_max, sizeof(*sw->lags), GFP_KERNEL);
+	if (!sw->lags)
+		return -ENOMEM;
+
+	for (id = 0; id < sw->lag_max; id++)
+		sw->lags[id].lag_id = id;
+
+	return 0;
+}
+
+static void prestera_lag_fini(struct prestera_switch *sw)
+{
+	u8 idx;
+
+	for (idx = 0; idx < sw->lag_max; idx++)
+		WARN_ON(sw->lags[idx].member_count);
+
+	kfree(sw->lags);
+}
+
 bool prestera_netdev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &prestera_netdev_ops;
@@ -505,7 +650,39 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
 	return port;
 }
 
-static int prestera_netdev_port_event(struct net_device *dev,
+static int prestera_netdev_port_lower_event(struct net_device *dev,
+					    unsigned long event, void *ptr)
+{
+	struct netdev_notifier_changelowerstate_info *info = ptr;
+	struct netdev_lag_lower_state_info *lower_state_info;
+	struct prestera_port *port = netdev_priv(dev);
+	bool enabled;
+
+	if (!netif_is_lag_port(dev))
+		return 0;
+	if (!prestera_port_is_lag_member(port))
+		return 0;
+
+	lower_state_info = info->lower_state_info;
+	enabled = lower_state_info->link_up && lower_state_info->tx_enabled;
+
+	return prestera_hw_lag_member_enable(port, port->lag->lag_id, enabled);
+}
+
+static bool prestera_lag_master_check(struct net_device *lag_dev,
+				      struct netdev_lag_upper_info *info,
+				      struct netlink_ext_ack *ext_ack)
+{
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(ext_ack, "Unsupported LAG Tx type");
+		return false;
+	}
+
+	return true;
+}
+
+static int prestera_netdev_port_event(struct net_device *lower,
+				      struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
@@ -518,7 +695,8 @@ static int prestera_netdev_port_event(struct net_device *dev,
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper)) {
+		if (!netif_is_bridge_master(upper) &&
+		    !netif_is_lag_master(upper)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
@@ -530,6 +708,21 @@ static int prestera_netdev_port_event(struct net_device *dev,
 			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
 			return -EINVAL;
 		}
+
+		if (netif_is_lag_master(upper) &&
+		    !prestera_lag_master_check(upper, info->upper_info, extack))
+			return -EOPNOTSUPP;
+		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Master device is a LAG master and port has a VLAN");
+			return -EINVAL;
+		}
+		if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
+		    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can not put a VLAN on a LAG port");
+			return -EINVAL;
+		}
 		break;
 
 	case NETDEV_CHANGEUPPER:
@@ -538,8 +731,35 @@ static int prestera_netdev_port_event(struct net_device *dev,
 				return prestera_bridge_port_join(upper, port);
 			else
 				prestera_bridge_port_leave(upper, port);
+		} else if (netif_is_lag_master(upper)) {
+			if (info->linking)
+				return prestera_lag_port_add(port, upper);
+			else
+				prestera_lag_port_del(port);
 		}
 		break;
+
+	case NETDEV_CHANGELOWERSTATE:
+		return prestera_netdev_port_lower_event(dev, event, ptr);
+	}
+
+	return 0;
+}
+
+static int prestera_netdevice_lag_event(struct net_device *lag_dev,
+					unsigned long event, void *ptr)
+{
+	struct net_device *dev;
+	struct list_head *iter;
+	int err;
+
+	netdev_for_each_lower_dev(lag_dev, dev, iter) {
+		if (prestera_netdev_check(dev)) {
+			err = prestera_netdev_port_event(lag_dev, dev, event,
+							 ptr);
+			if (err)
+				return err;
+		}
 	}
 
 	return 0;
@@ -552,7 +772,9 @@ static int prestera_netdev_event_handler(struct notifier_block *nb,
 	int err = 0;
 
 	if (prestera_netdev_check(dev))
-		err = prestera_netdev_port_event(dev, event, ptr);
+		err = prestera_netdev_port_event(dev, dev, event, ptr);
+	else if (netif_is_lag_master(dev))
+		err = prestera_netdevice_lag_event(dev, event, ptr);
 
 	return notifier_from_errno(err);
 }
@@ -606,6 +828,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_dl_register;
 
+	err = prestera_lag_init(sw);
+	if (err)
+		goto err_lag_init;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -613,6 +839,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_lag_fini(sw);
+err_lag_init:
 	prestera_devlink_unregister(sw);
 err_dl_register:
 	prestera_event_handlers_unregister(sw);
@@ -630,6 +858,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_lag_fini(sw);
 	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0afbd485a3a2..74b81b4fbb97 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -180,6 +180,45 @@ prestera_port_vlan_create(struct prestera_port *port, u16 vid, bool untagged)
 	return ERR_PTR(err);
 }
 
+static int prestera_fdb_add(struct prestera_port *port,
+			    const unsigned char *mac, u16 vid, bool dynamic)
+{
+	if (prestera_port_is_lag_member(port))
+		return prestera_hw_lag_fdb_add(port->sw, prestera_port_lag_id(port),
+					      mac, vid, dynamic);
+
+	return prestera_hw_fdb_add(port, mac, vid, dynamic);
+}
+
+static int prestera_fdb_del(struct prestera_port *port,
+			    const unsigned char *mac, u16 vid)
+{
+	if (prestera_port_is_lag_member(port))
+		return prestera_hw_lag_fdb_del(port->sw, prestera_port_lag_id(port),
+					      mac, vid);
+	else
+		return prestera_hw_fdb_del(port, mac, vid);
+}
+
+static int prestera_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
+					u32 mode)
+{
+	if (prestera_port_is_lag_member(port))
+		return prestera_hw_fdb_flush_lag_vlan(port->sw, prestera_port_lag_id(port),
+						      vid, mode);
+	else
+		return prestera_hw_fdb_flush_port_vlan(port, vid, mode);
+}
+
+static int prestera_fdb_flush_port(struct prestera_port *port, u32 mode)
+{
+	if (prestera_port_is_lag_member(port))
+		return prestera_hw_fdb_flush_lag(port->sw, prestera_port_lag_id(port),
+						 mode);
+	else
+		return prestera_hw_fdb_flush_port(port, mode);
+}
+
 static void
 prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 {
@@ -199,11 +238,11 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 	last_port = port_count == 1;
 
 	if (last_vlan)
-		prestera_hw_fdb_flush_port(port, fdb_flush_mode);
+		prestera_fdb_flush_port(port, fdb_flush_mode);
 	else if (last_port)
 		prestera_hw_fdb_flush_vlan(port->sw, vid, fdb_flush_mode);
 	else
-		prestera_hw_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
+		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
 
 	list_del(&port_vlan->br_vlan_head);
 	prestera_bridge_vlan_put(br_vlan);
@@ -312,11 +351,29 @@ __prestera_bridge_port_by_dev(struct prestera_bridge *bridge,
 	return NULL;
 }
 
+static int prestera_match_upper_bridge_dev(struct net_device *dev,
+					   struct netdev_nested_priv *priv)
+{
+	if (netif_is_bridge_master(dev))
+		priv->data = dev;
+
+	return 0;
+}
+
+static struct net_device *prestera_get_upper_bridge_dev(struct net_device *dev)
+{
+	struct netdev_nested_priv priv = { };
+
+	netdev_walk_all_upper_dev_rcu(dev, prestera_match_upper_bridge_dev,
+				      &priv);
+	return priv.data;
+}
+
 static struct prestera_bridge_port *
 prestera_bridge_port_by_dev(struct prestera_switchdev *swdev,
 			    struct net_device *dev)
 {
-	struct net_device *br_dev = netdev_master_upper_dev_get(dev);
+	struct net_device *br_dev = prestera_get_upper_bridge_dev(dev);
 	struct prestera_bridge *bridge;
 
 	if (!br_dev)
@@ -723,9 +780,9 @@ static int prestera_port_fdb_set(struct prestera_port *port,
 		vid = bridge->bridge_id;
 
 	if (adding)
-		err = prestera_hw_fdb_add(port, fdb_info->addr, vid, false);
+		err = prestera_fdb_add(port, fdb_info->addr, vid, false);
 	else
-		err = prestera_hw_fdb_del(port, fdb_info->addr, vid);
+		err = prestera_fdb_del(port, fdb_info->addr, vid);
 
 	return err;
 }
@@ -962,15 +1019,15 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 {
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool flag_pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct net_device *dev = vlan->obj.orig_dev;
+	struct net_device *orig_dev = vlan->obj.orig_dev;
 	struct prestera_bridge_port *br_port;
 	struct prestera_switch *sw = port->sw;
 	struct prestera_bridge *bridge;
 
-	if (netif_is_bridge_master(dev))
+	if (netif_is_bridge_master(orig_dev))
 		return 0;
 
-	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
+	br_port = prestera_bridge_port_by_dev(sw->swdev, port->dev);
 	if (WARN_ON(!br_port))
 		return -EINVAL;
 
@@ -1002,14 +1059,14 @@ static int prestera_port_obj_add(struct net_device *dev,
 static int prestera_port_vlans_del(struct prestera_port *port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
-	struct net_device *dev = vlan->obj.orig_dev;
+	struct net_device *orig_dev = vlan->obj.orig_dev;
 	struct prestera_bridge_port *br_port;
 	struct prestera_switch *sw = port->sw;
 
-	if (netif_is_bridge_master(dev))
+	if (netif_is_bridge_master(orig_dev))
 		return -EOPNOTSUPP;
 
-	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
+	br_port = prestera_bridge_port_by_dev(sw->swdev, port->dev);
 	if (WARN_ON(!br_port))
 		return -EINVAL;
 
@@ -1067,10 +1124,26 @@ static void prestera_fdb_event(struct prestera_switch *sw,
 			       struct prestera_event *evt, void *arg)
 {
 	struct switchdev_notifier_fdb_info info;
+	struct net_device *dev = NULL;
 	struct prestera_port *port;
+	struct prestera_lag *lag;
 
-	port = prestera_find_port(sw, evt->fdb_evt.port_id);
-	if (!port)
+	switch (evt->fdb_evt.type) {
+	case PRESTERA_FDB_ENTRY_TYPE_REG_PORT:
+		port = prestera_find_port(sw, evt->fdb_evt.dest.port_id);
+		if (port)
+			dev = port->dev;
+		break;
+	case PRESTERA_FDB_ENTRY_TYPE_LAG:
+		lag = prestera_lag_by_id(sw, evt->fdb_evt.dest.lag_id);
+		if (lag)
+			dev = lag->dev;
+		break;
+	default:
+		return;
+	}
+
+	if (!dev)
 		return;
 
 	info.addr = evt->fdb_evt.data.mac;
@@ -1082,11 +1155,11 @@ static void prestera_fdb_event(struct prestera_switch *sw,
 	switch (evt->id) {
 	case PRESTERA_FDB_EVENT_LEARNED:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
-					 port->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	case PRESTERA_FDB_EVENT_AGED:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
-					 port->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	}
 
-- 
2.17.1

