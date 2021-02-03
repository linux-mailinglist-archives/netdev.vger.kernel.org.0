Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE6B30E053
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhBCQ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:58:25 -0500
Received: from mail-eopbgr60107.outbound.protection.outlook.com ([40.107.6.107]:21313
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230070AbhBCQ5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:57:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwGX2TLo+EtSp/r/qAtn3+x+lzb7Vv//JUlW6ZqQnNDpoGYcuJutFx3Pkank6oaTDPdFosasZRFobGdKqN7QQzsNxg8QnuxQNKkq170+rY6q7PmquQsXdymHGCOTE6c0iV+33xtintfmJibExCldkwXRj2Y3ztFJP1bYBbHWVqC6UIA8DjVsOOUKTGG4W6wU5sKkuaxQYuogQhiluZq8ADU6O9WuTJOeANrdw2XRup6siFfFXLa+rb45PuYaRl3LxHaRPqnMFfXEQXyx9gsCinaqyziwb7aMefll2CAnNr6CbXDtVoiCaykkKXRK7AaYgmJyWe5ntfq4z9+3/K6Lqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mc9UlU1qnjKE/hKVAU0Vimn26h85YaJesg93lsuAZA=;
 b=AMOkrx8zqKv8l1jjYrNuI5aCM4hP40AncH7tnWeUq70l+/qXSZDMzKriBcWIJlHNw1uDxwt0KqYtG8aJLLqqc4Hfsx76+WsLStjMemTYIUYEETo40vY3C8dD19rleALiWZonI0xgEL2ewKLAMBfGJk11ia90jpz3TFszwW3RG9G9M0QOytFoml9ZPeE/GthgIt8W+5UIGWB6bWgRGsS0rYr1B9WD7hukokbzE5VvTX986yQwMG8rT9in6G4oLprh8GvFv5YMTiDnmCTlI+94d5lLi3H1I0EMxbdo/wxZ78H++9+DqZ611cpwPXYrLOHeZKVwQXOV6C1kX7Nk6qkkNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mc9UlU1qnjKE/hKVAU0Vimn26h85YaJesg93lsuAZA=;
 b=pAyLZ7haVHz6/LEjwM6QexYUynyfsury4pNOCu4pox7opSNeLAESzSf7oHrps0Xx9JCMeQSfK8tHBukDa+var7x2rOvbBalU1ga+8KhC75oed1eFsIoUs8w9SIMLhSviaBLwPjLb7n4q1D9iRlVva5/vIjdBXIYMpLJcJ24P1rs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:58 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:58 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org,
        Andrii Savka <andrii.savka@plvision.eu>
Subject: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Date:   Wed,  3 Feb 2021 18:54:56 +0200
Message-Id: <20210203165458.28717-6-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25441b93-1359-42d3-f7a1-08d8c864940d
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB053911F3CE1009DDE0D5255195B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bH5zGna/rHImBowPh0Oj2yNEykRBheUu4g79b7XYl9Q5jAaBWbbnwjHbVPFi5Y6knoxGPB9DE6tmYodOl9CM8rZNJcWY4Sq1lyfqS45OX+w42qnFuaBJ3x739fX1kPnTmeleZxxzsYBVC3bXw1cPznKZ1WKNy0NeUuuGj0+Y0MgScyxMKbGtTkInfHxOFViMU3Ne16eMdfEe4yu8DGfeAH2cah+5ARJPsyeDoNClV6gvlIfxJIvEhyPi+/tkPDDT83ij1Rnjiu6fVpRqpIrBy9Vsbt3se78i9lwBzoWaW3wPDqvV1r/eNy8X95+mE3/W80keBVsISjJBxg4BLvsbwqtLsXq7znO7wtFlqTRGxx+luTITTVyPQfdp0RkrcJcmsvgbjZskD+/hDcEgCRDxK3Dxdn9r55mev51sLd1pd9q7c0memuFDEx3U7q0S3a2MJuzDTlRTneXMaCu5fnhsk/OstdZDA0QRqDTuxhEt1LE8BiuA7VODGNjtM9RHGAEn172JrNovjXM4dU+XSgyNRE81jfkCHWr/bf5AcRBQ4h00gvLtj0TQ1563gHmsS2uRtMOWkiRW52a2178UVSU4ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(83380400001)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(30864003)(26005)(6512007)(52116002)(107886003)(2906002)(316002)(2616005)(66946007)(8936002)(1076003)(66476007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ctb4fT+A8eFsXsse16QOPO2Gxzg4ys3MY87gZm9JVHZ0ZXLIUkrZopn2a0wu?=
 =?us-ascii?Q?iBj5cL4pEOXqWca8FKpKTeMqlD2k5B5BkDpx0l+owj35F2pga5noC/QeUPzz?=
 =?us-ascii?Q?euu1eTkySQYt5MbWf8B6z2xiLJ8R89eFxq+PthsHkGOCtlxyelDM/YiXY2P0?=
 =?us-ascii?Q?Aaxg2/4khYpHHHWHcAP7QQik1zbxNnnVyBtpcLuh7iW//v+tkS6Q3sutlRzx?=
 =?us-ascii?Q?qqSq5VPyiBuiTVTYCqtqhWNlzws0KuyiAqcurmGJW2KEEfelBEl8ry/JYZhf?=
 =?us-ascii?Q?tXbK59yUle+6CgBIEEAkDvfkN+4FwdRRBZr2/39ASz3HDlYOfW+umgyV6YYB?=
 =?us-ascii?Q?3YxTyAMcH3U9JxbV7gHiglu46nJfrh7ftSuvs0VA72psJ8HxYYR1iIsyphjJ?=
 =?us-ascii?Q?MmKnFN3Gy+uozr2hrfeW5zDf3hWMRwjfie6vTOou3rIogSBscjep1oiZDeRo?=
 =?us-ascii?Q?/MXKL6NogRrndJOFHXnRdLWulTSzVMSjCnl6CanZHusKt3RevfNplXczIlcF?=
 =?us-ascii?Q?GWe8ltIX5lvzaga8/j694IUbmVooxsS6iqpBb1IdrsuI3oWnEn9q/dhxugew?=
 =?us-ascii?Q?NoUSoD1AUOIaMNgAotFgYhi6ptBf7ilgetmUryuRpbBjYbjelmSIS2SX75bO?=
 =?us-ascii?Q?Bzf+VhoBFfxHzLE5sos/8KVr+jdfwi6+jcKcVzs1f4vgvmWcidii48jG1xPt?=
 =?us-ascii?Q?L56v6uMCkKSq1K1AbCKZG38dK2KVW9oyIk7IYmMrKKyPtoWaW4fjJb1t4FcH?=
 =?us-ascii?Q?Y5Smwz7ASlslkhTNBUWZ89VUR5EAnQitGP0Z3s/SUGvv0lT6DXEllIF5cE8d?=
 =?us-ascii?Q?YLOvIHv18wGmr+Au3TRGrUqDVz5LG2UZJIJSXkx/EA2A+onw0rb+uMUazriz?=
 =?us-ascii?Q?RdOVUMToWk95TYbpkAMvd+rtavTHHFAja/zymRr47M7WK4axXl7YlDG5zyv+?=
 =?us-ascii?Q?PVjtjPe/ZOiI8Ensyd9C0hc0VOjBVt0agUVyRZY7qOVpAxk5UVEZUukL/TqN?=
 =?us-ascii?Q?D250vQftLhpfk4Ql7n801gyZrv8oGlCIbTEZyv3oo0x8JkabZfBWrJSgFVNK?=
 =?us-ascii?Q?IhrHHCnfoXH3XxIJP348BcZMn+ekLwt26pEx2j2EyZR3j9pQADpzScmram6B?=
 =?us-ascii?Q?kXtQjFK30ts0QxKfP8SCgeNpxItBcsE9YU6oE7GrD398uZkAWHu1QdFSIWob?=
 =?us-ascii?Q?w/QNowCGzoW9mlhUmqE9jKLTayKIdviLcVbNkDCFwwqVBe8un2IvVMqlFE1e?=
 =?us-ascii?Q?rqCo5JwcWWz8RmoR+ox1q+lZ9ICQElb8alyKtaXKMaOXWXD8Zv8ewt33rtAy?=
 =?us-ascii?Q?numEtZJCDQ8cfXHfGRcgw6JN?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 25441b93-1359-42d3-f7a1-08d8c864940d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:58.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V2wxUAJNAOnjk2wDzSBxVCXeajekbA9C+/rqoGZ38QobN1yaDCdL8va3NL4LthD+S5uFzmUR5zFAQvD/zcZUqVSfirF+S7ytHMoprs0wBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
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
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  30 ++-
 .../ethernet/marvell/prestera/prestera_hw.c   | 180 ++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  14 +
 .../ethernet/marvell/prestera/prestera_main.c | 247 +++++++++++++++++-
 .../marvell/prestera/prestera_switchdev.c     | 109 ++++++--
 .../marvell/prestera/prestera_switchdev.h     |   4 +-
 6 files changed, 538 insertions(+), 46 deletions(-)

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
index 0424718d5998..8afb45f66862 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -39,6 +39,11 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
+	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE = 0x901,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_ENABLE = 0x902,
+	PRESTERA_CMD_TYPE_LAG_MEMBER_DISABLE = 0x903,
+
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
@@ -127,6 +132,12 @@ enum {
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
@@ -168,6 +179,8 @@ struct prestera_msg_switch_init_resp {
 	u32 port_count;
 	u32 mtu_max;
 	u8  switch_id;
+	u8  lag_max;
+	u8  lag_member_max;
 };
 
 struct prestera_msg_port_autoneg_param {
@@ -249,8 +262,13 @@ struct prestera_msg_vlan_req {
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
@@ -293,6 +311,13 @@ struct prestera_msg_rxtx_port_req {
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
@@ -315,7 +340,10 @@ union prestera_msg_event_fdb_param {
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
@@ -386,7 +414,19 @@ static int prestera_fw_parse_fdb_evt(void *msg, struct prestera_event *evt)
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
@@ -531,6 +571,8 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 	sw->mtu_min = PRESTERA_MIN_MTU;
 	sw->mtu_max = resp.mtu_max;
 	sw->id = resp.switch_id;
+	sw->lag_member_max = resp.lag_member_max;
+	sw->lag_max = resp.lag_max;
 
 	return 0;
 }
@@ -1067,8 +1109,10 @@ int prestera_hw_fdb_add(struct prestera_port *port, const unsigned char *mac,
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
@@ -1083,8 +1127,10 @@ int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
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
 
@@ -1094,11 +1140,48 @@ int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
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
 
@@ -1121,8 +1204,10 @@ int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
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
@@ -1131,6 +1216,37 @@ int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
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
@@ -1212,6 +1328,46 @@ int prestera_hw_rxtx_port_init(struct prestera_port *port)
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
index b2b5ac95b4e3..68ce41595349 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -179,4 +179,18 @@ int prestera_hw_rxtx_init(struct prestera_switch *sw,
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
index 53c7628a3938..39465e65d09b 100644
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
@@ -474,6 +476,151 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
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
+	struct prestera_lag *lag;
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
+			return -ENOMEM;
+	}
+
+	if (lag->member_count >= sw->lag_member_max)
+		return -ENOMEM;
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
+		struct netdev_notifier_changeupper_info br_info;
+
+		br_info.upper_dev = netdev_master_upper_dev_get(lag->dev);
+		br_info.linking = false;
+
+		prestera_bridge_port_event(lag->dev, port->dev,
+					   NETDEV_CHANGEUPPER, &br_info);
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
@@ -507,19 +654,54 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
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
+	enabled = lower_state_info->tx_enabled;
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
+	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
+	int err;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
 	upper = info->upper_dev;
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper)) {
+		if (!netif_is_bridge_master(upper) &&
+		    !netif_is_lag_master(upper)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
@@ -531,12 +713,60 @@ static int prestera_netdev_port_event(struct net_device *dev,
 			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
 			return -EINVAL;
 		}
+
+		if (netif_is_lag_master(upper) &&
+		    !prestera_lag_master_check(upper, info->upper_info, extack))
+			return -EINVAL;
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
 		if (netif_is_bridge_master(upper))
-			return prestera_bridge_port_event(dev, event, ptr);
+			return prestera_bridge_port_event(lower, dev, event,
+							  ptr);
+
+		if (netif_is_lag_master(upper)) {
+			if (info->linking) {
+				err = prestera_lag_port_add(port, upper);
+				if (err)
+					return err;
+			} else {
+				prestera_lag_port_del(port);
+			}
+		}
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
@@ -549,7 +779,9 @@ static int prestera_netdev_event_handler(struct notifier_block *nb,
 	int err = 0;
 
 	if (prestera_netdev_check(dev))
-		err = prestera_netdev_port_event(dev, event, ptr);
+		err = prestera_netdev_port_event(dev, dev, event, ptr);
+	else if (netif_is_lag_master(dev))
+		err = prestera_netdevice_lag_event(dev, event, ptr);
 
 	return notifier_from_errno(err);
 }
@@ -603,6 +835,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_dl_register;
 
+	err = prestera_lag_init(sw);
+	if (err)
+		goto err_lag_init;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -610,6 +846,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_lag_fini(sw);
+err_lag_init:
 	prestera_devlink_unregister(sw);
 err_dl_register:
 	prestera_event_handlers_unregister(sw);
@@ -627,6 +865,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_lag_fini(sw);
 	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7736d5f498c9..3750c66a550b 100644
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
+	else
+		return prestera_hw_fdb_add(port, mac, vid, dynamic);
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
@@ -394,9 +433,9 @@ prestera_bridge_port_add(struct prestera_bridge *bridge, struct net_device *dev)
 }
 
 static int
-prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
+prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port,
+			     struct prestera_port *port)
 {
-	struct prestera_port *port = netdev_priv(br_port->dev);
 	struct prestera_bridge *bridge = br_port->bridge;
 	int err;
 
@@ -423,6 +462,7 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 }
 
 static int prestera_port_bridge_join(struct prestera_port *port,
+				     struct net_device *lower,
 				     struct net_device *upper)
 {
 	struct prestera_switchdev *swdev = port->sw->swdev;
@@ -437,7 +477,7 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 			return PTR_ERR(bridge);
 	}
 
-	br_port = prestera_bridge_port_add(bridge, port->dev);
+	br_port = prestera_bridge_port_add(bridge, lower);
 	if (IS_ERR(br_port)) {
 		err = PTR_ERR(br_port);
 		goto err_brport_create;
@@ -446,7 +486,7 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 	if (bridge->vlan_enabled)
 		return 0;
 
-	err = prestera_bridge_1d_port_join(br_port);
+	err = prestera_bridge_1d_port_join(br_port, port);
 	if (err)
 		goto err_port_join;
 
@@ -459,19 +499,17 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 	return err;
 }
 
-static void prestera_bridge_1q_port_leave(struct prestera_bridge_port *br_port)
+static void prestera_bridge_1q_port_leave(struct prestera_bridge_port *br_port,
+					  struct prestera_port *port)
 {
-	struct prestera_port *port = netdev_priv(br_port->dev);
-
-	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
+	prestera_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
 	prestera_port_pvid_set(port, PRESTERA_DEFAULT_VID);
 }
 
-static void prestera_bridge_1d_port_leave(struct prestera_bridge_port *br_port)
+static void prestera_bridge_1d_port_leave(struct prestera_bridge_port *br_port,
+					  struct prestera_port *port)
 {
-	struct prestera_port *port = netdev_priv(br_port->dev);
-
-	prestera_hw_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
+	prestera_fdb_flush_port(port, PRESTERA_FDB_FLUSH_MODE_ALL);
 	prestera_hw_bridge_port_delete(port, br_port->bridge->bridge_id);
 }
 
@@ -506,6 +544,7 @@ static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 }
 
 static void prestera_port_bridge_leave(struct prestera_port *port,
+				       struct net_device *lower,
 				       struct net_device *upper)
 {
 	struct prestera_switchdev *swdev = port->sw->swdev;
@@ -516,16 +555,16 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 	if (!bridge)
 		return;
 
-	br_port = __prestera_bridge_port_by_dev(bridge, port->dev);
+	br_port = __prestera_bridge_port_by_dev(bridge, lower);
 	if (!br_port)
 		return;
 
 	bridge = br_port->bridge;
 
 	if (bridge->vlan_enabled)
-		prestera_bridge_1q_port_leave(br_port);
+		prestera_bridge_1q_port_leave(br_port, port);
 	else
-		prestera_bridge_1d_port_leave(br_port);
+		prestera_bridge_1d_port_leave(br_port, port);
 
 	prestera_hw_port_learning_set(port, false);
 	prestera_hw_port_flood_set(port, false);
@@ -533,8 +572,8 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 	prestera_bridge_port_put(br_port);
 }
 
-int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
-			       void *ptr)
+int prestera_bridge_port_event(struct net_device *lower, struct net_device *dev,
+			       unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
 	struct prestera_port *port;
@@ -547,11 +586,11 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
 		if (info->linking) {
-			err = prestera_port_bridge_join(port, upper);
+			err = prestera_port_bridge_join(port, lower, upper);
 			if (err)
 				return err;
 		} else {
-			prestera_port_bridge_leave(port, upper);
+			prestera_port_bridge_leave(port, lower, upper);
 		}
 		break;
 	}
@@ -745,9 +784,9 @@ static int prestera_port_fdb_set(struct prestera_port *port,
 		vid = bridge->bridge_id;
 
 	if (adding)
-		err = prestera_hw_fdb_add(port, fdb_info->addr, vid, false);
+		err = prestera_fdb_add(port, fdb_info->addr, vid, false);
 	else
-		err = prestera_hw_fdb_del(port, fdb_info->addr, vid);
+		err = prestera_fdb_del(port, fdb_info->addr, vid);
 
 	return err;
 }
@@ -1088,10 +1127,26 @@ static void prestera_fdb_event(struct prestera_switch *sw,
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
@@ -1103,11 +1158,11 @@ static void prestera_fdb_event(struct prestera_switch *sw,
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
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
index 606e21d2355b..70e9ed87e24a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
@@ -7,7 +7,7 @@
 int prestera_switchdev_init(struct prestera_switch *sw);
 void prestera_switchdev_fini(struct prestera_switch *sw);
 
-int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
-			       void *ptr);
+int prestera_bridge_port_event(struct net_device *lower, struct net_device *dev,
+			       unsigned long event, void *ptr);
 
 #endif /* _PRESTERA_SWITCHDEV_H_ */
-- 
2.17.1

