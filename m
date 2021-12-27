Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DDA4804F7
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhL0Vxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:53:54 -0500
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:5358
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233635AbhL0Vxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:53:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQySQcI7fn8fwGBWDYnFK35WxWg4YOLLVCP1Ihoan1X3vIudef2zqvJi9DNq1qAAHgmV2oB0NPAXdf2I3e4cdekL2jCokwiuLAfN+xolpfatJmB85fzFJhTQMSHi3YJ6HimcacC/2IICd300kQmUk0gs2tCOn2R6Y+jGQoVsYmg9F+3FvS+UTazxyF+wGPUfPsrRKAxVj+1dCeacitQBOaSuaNTmgSFXs5fcdtFoHb3DUZALH+FeMe7enY9IFEWocAuMVyiLhj6JGUsfb2rNi4SC+ES3KD8qqwljg+nrtuAS9qiz98z+GBB8Fj+gGZj5Lzu/R9pqvo12zpQcjywgOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fKPo37Wta2+rTQliswIXHMTn/3JnRkm9gGEfrAFb38=;
 b=FfXetbybwusoLn0yms+SZZtvSj4+WuetfBhMTMK6ukcVB+fRSy9cIUVXln1alq0OvNcfJMgUsOEtmaMyGw1e/sC1oMrM/lvLzKaXHMkcUXHQdpFz2MIK0Ovr6Af55aE54/4Qww/xjzhHJg9QI16WgOT28PDHqOoWqYzN8VfDL8c3ygtTLxXDmcnNw0E7b1KAmWDWyOq8nLqX0FerG5Kyug7RKAh08igcFlf99fBUrsycbEVdbNj7GoHbq8W+izHYqaVMviaWJ4FTPEuwoSIsBsGzqbgyB+nmUFyjzgrtwFuRjQ80/++bpmkzv/O/l0muq65xhr6EC+K9ycoGdKtB7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fKPo37Wta2+rTQliswIXHMTn/3JnRkm9gGEfrAFb38=;
 b=m8+WpAjpIhzJTyrWWAbD40zFKPt7KR6m2OxJt02q1xOzs7dX83TofCeqdzynqss5PyXe09hmoBjXSCx9F8zb6L1AJW8X+8qyfjR4JZTQwIzd6/TbBjaOHcN1LIiCNnsvANqfNp0fdwHaXBsj3b3NJYu/iKn29CQcz634oZkhnX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:51 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:51 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] net: marvell: prestera: Add router interface ABI
Date:   Mon, 27 Dec 2021 23:52:27 +0200
Message-Id: <20211227215233.31220-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 969d0fd9-df72-40b6-fbdc-08d9c9835e45
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB014560080F260ABF4ED891E293429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eddKEbOk6lV9OryORwo6F1NgUvXwMFHfL7Zjv826j1fwO8coCZSNjUmkCnTsqhE/b1kZ92w4J8aPTFTRCvkeU6249z7gIXrC6VKYVA9SJ6lJWTPbv51cVb+M/XADU2qhUUrErB/KRbBoTFxtjErvoVPa1hJjoV/bN1SoY4Kd2tKKTvRTTyBaZmgHQwUFKslQ6E5I8kATYfX04mPnjFYjPcgTk5jGeE3azEY1lmQZNb/+xx/MQMzXU6IeGyjnXkQB6yArkgXTHBmceR9MmUWah1oeJn0WHK8ZZxA61oW/SASEA+lyHKWzuqP7+qcOHbT7t3wMy5OICNETlyIMhZ5TZcJl5QmEj8HYc0ISMA384ujY5hk/N4EbfUvoS2wc2HWB2kvRNJ9qnnXpLEtqg1oOArUF0Tg5eU74JnAC2Yg/TKsnEBP9myQ7MxbeqSMY5MIYfaI0qZixxPAGF7XNKkVL8Zw7pKZQCrfCVEJYste5EJK2sWkxhzIOwOwWdkVwYpNTeGU2MK/nYvqJ5NKcVPBjK7eNP9ni4mJ/bn/biq9LEdx8ViS8vzkWIH4OWOcDywNSVD9O7xCk18AfVLHHDRt1FRcWlZ+qeSv0nxcF9S386OM9gWAMplpp0YAgOTDmh5kJ48t/iIh0GDcmuS0JxKbhlAqqSdzLBX6J3aXMIbF6F3otMop7f7JEUxz0PaORAPr1H9C2HL53rhITOlnzBYjug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjwvJ5zGkH/3N0khMJOTSOd80PWcrfgck5kjLbHpe0fbZXXnE0S5qDS/bDcH?=
 =?us-ascii?Q?S+2ylcDW0RjW5CF4YpkVXl4adoDEclUcYckYqc9zNTNGc4VMaRfvY02pTwbY?=
 =?us-ascii?Q?77EnCSZ4n3+K5MJDgVQ6tbZnaeDFgdVfkGfqLEH06/QARDg82fcUlNgioflt?=
 =?us-ascii?Q?+eTDgzAxc7bO8pqw6WsjzOr2UWkDX97LjPBXKEdbveuPlw103wMetrleP2jL?=
 =?us-ascii?Q?uJpPP9XvG/oa3YqxHCvxD2EExzA/dAYqtJIlazRv/YgOUJKlydygfBvq75Ar?=
 =?us-ascii?Q?Xx6858GfobCK5YyCFjwS5rV5p622jYz+r5EknUsKNGiwvJp0tC4c6zOgbKWc?=
 =?us-ascii?Q?JMxnU2eI+89hE/37sj1Td8RHZ7AupJ2uKBwHm54xOTfu6vFxHpAh9S/Aq9Is?=
 =?us-ascii?Q?x2r03okOcKHsj8B7yxuknpqPHiOWwKNrbjXJhJCErGA8/68jyfqA6nHjvc4T?=
 =?us-ascii?Q?5y7T5qLl21vW5/yNxIGftJEKCRQonRGKYnbsrME9CVwrCQ8ADryYbVd8vwEq?=
 =?us-ascii?Q?tkMyRtS8ZuoUi0XuYIPRu9GeXDyZDJetFAswuvhHEsUqafyyrCVAHL7QrCed?=
 =?us-ascii?Q?w5JhxYOXJaZk0Q+pG6D4+nfbK+/CwTvbEmasx1GTSt4zoLIvp6KrSaFdYQvG?=
 =?us-ascii?Q?hAMXlSjowtfWsV6RCynbaoVK0QCa1S2TP7ZwI9aP9JkAD1zTqwwvr81FbloF?=
 =?us-ascii?Q?mWQjgHygeRfdfgbnvh3DjPhjahfalk/J6gD7G2q1d5puVIpIXvOQzdKe9UAw?=
 =?us-ascii?Q?pyrXEVlsKQveINd+mM8db5N/uS0hAghdEcn3pkrSLFONcWQF8BENQA1ce5pV?=
 =?us-ascii?Q?7qTa7iarmKvUVTGY5UejhXRKk2wltySVEPvtVAza6XE57whXPmH6LasfngR+?=
 =?us-ascii?Q?4vwq6JRywhLHElOr19ZzZyd+C0cQbIc9yEoEtaNwAA2klIfT0wlS/aAOBU29?=
 =?us-ascii?Q?TjN1iD5hI8GtBJSpuHVZYPdYqC4wiXZSdn5JUPhhinR3A1vYhHHU6EiHq6du?=
 =?us-ascii?Q?ZhFFVXG6faBR8XkNqS2DXwOyaV3NLc6EdspgkOzen2E+tp2zXPBkfC7DVx46?=
 =?us-ascii?Q?oSqAXdvUy8kvBuq0AL51BK5vTO87Z2B8+PYf81QEiuuHJ1NALPlm+243wWOr?=
 =?us-ascii?Q?g1CtPvkqUIc7q470Cx8TQonmlJY5HltKWtOwZ6J3SAHzpq4M2CQvq+RMBtZa?=
 =?us-ascii?Q?73laDoOlJXV0Y4t3NKseO7EfYKweE2+GyRagMXW5AoByEagvl2tXB3ZIWbt+?=
 =?us-ascii?Q?RZBEsmQUZt1PFPgotQB7paiFED82OH3NyV4dwWvRJGFSgSQEVQaI4z6qahW4?=
 =?us-ascii?Q?RkOWkTK9eaHrHoJkMjkJOP8J0j3Ni9jfXRUPSLRu7jehrWYwCcI0CPJjozfu?=
 =?us-ascii?Q?aX+5YQ1zPGqryxXzVa6vcP5vlvoBOWQPgCX+Hk8Jm6EShTu2KayCMpYO3QZ/?=
 =?us-ascii?Q?NbjGl2AhbvRIkd4vMJmIvpwnjqDXEhly7gxgqXcDl3LACt+r7bAQWvteoaH8?=
 =?us-ascii?Q?aQcQd3hkeaduUsDUeLpvMEezpIoyYWb6jwrnTQ5bpeFlF7ZvlDfNQh5owQnU?=
 =?us-ascii?Q?N18IxmqXWXlu8STso9iZpigwJb0vDtDA1lqFuwbEnfLIpPpv4MWXh91GFtOl?=
 =?us-ascii?Q?KQPwqKiZ4uwWuetPZxNLOExNC06OwHeRZslGHHoe9ErfUyiagq1A55PhAA7h?=
 =?us-ascii?Q?609Liw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 969d0fd9-df72-40b6-fbdc-08d9c9835e45
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:51.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kLt3kR1eHPMnMHP28F0sGSDYoYdyqotP/zG2lHPo73NOaJ+I2O7oCyozuu4cCYyilqOOCGMB9r3/9JcSmpkb2k0p4DoiqFJH/IvmDfiCco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions to enable routing on port, which is not in vlan.
Also we can enable routing on vlan.
prestera_hw_rif_create() take index of allocated virtual router.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
v1-->v2
* No changes
---
 .../net/ethernet/marvell/prestera/prestera.h  | 23 +++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 97 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  7 ++
 3 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 797b2e4d3551..636caf492531 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -225,6 +225,29 @@ struct prestera_event {
 	};
 };
 
+enum prestera_if_type {
+	/* the interface is of port type (dev,port) */
+	PRESTERA_IF_PORT_E = 0,
+
+	/* the interface is of lag type (lag-id) */
+	PRESTERA_IF_LAG_E = 1,
+
+	/* the interface is of Vid type (vlan-id) */
+	PRESTERA_IF_VID_E = 3,
+};
+
+struct prestera_iface {
+	enum prestera_if_type type;
+	struct {
+		u32 hw_dev_num;
+		u32 port_num;
+	} dev_port;
+	u32 hw_dev_num;
+	u16 vr_id;
+	u16 lag_id;
+	u16 vlan_id;
+};
+
 struct prestera_switchdev;
 struct prestera_span;
 struct prestera_rxtx;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 8783adbad593..51fc841b1e7a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -53,6 +53,8 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
 
+	PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE = 0x600,
+	PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE = 0x601,
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
@@ -483,6 +485,36 @@ struct prestera_msg_rxtx_resp {
 	__le32 map_addr;
 };
 
+struct prestera_msg_iface {
+	union {
+		struct {
+			__le32 dev;
+			__le32 port;
+		};
+		__le16 lag_id;
+	};
+	__le16 vr_id;
+	__le16 vid;
+	u8 type;
+	u8 __pad[3];
+};
+
+struct prestera_msg_rif_req {
+	struct prestera_msg_cmd cmd;
+	struct prestera_msg_iface iif;
+	__le32 mtu;
+	__le16 rif_id;
+	__le16 __reserved;
+	u8 mac[ETH_ALEN];
+	u8 __pad[2];
+};
+
+struct prestera_msg_rif_resp {
+	struct prestera_msg_ret ret;
+	__le16 rif_id;
+	u8 __pad[2];
+};
+
 struct prestera_msg_vr_req {
 	struct prestera_msg_cmd cmd;
 	__le16 vr_id;
@@ -564,8 +596,12 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 
+	/*  structure that are part of req/resp fw messages */
+	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
+
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
@@ -577,6 +613,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 
 	/* check events */
@@ -1769,6 +1806,66 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
 			    &req.cmd, sizeof(req));
 }
 
+static int prestera_iface_to_msg(struct prestera_iface *iface,
+				 struct prestera_msg_iface *msg_if)
+{
+	switch (iface->type) {
+	case PRESTERA_IF_PORT_E:
+	case PRESTERA_IF_VID_E:
+		msg_if->port = __cpu_to_le32(iface->dev_port.port_num);
+		msg_if->dev = __cpu_to_le32(iface->dev_port.hw_dev_num);
+		break;
+	case PRESTERA_IF_LAG_E:
+		msg_if->lag_id = __cpu_to_le16(iface->lag_id);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	msg_if->vr_id = __cpu_to_le16(iface->vr_id);
+	msg_if->vid = __cpu_to_le16(iface->vlan_id);
+	msg_if->type = iface->type;
+	return 0;
+}
+
+int prestera_hw_rif_create(struct prestera_switch *sw,
+			   struct prestera_iface *iif, u8 *mac, u16 *rif_id)
+{
+	struct prestera_msg_rif_req req;
+	struct prestera_msg_rif_resp resp;
+	int err;
+
+	memcpy(req.mac, mac, ETH_ALEN);
+
+	err = prestera_iface_to_msg(iif, &req.iif);
+	if (err)
+		return err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*rif_id = __le16_to_cpu(resp.rif_id);
+	return err;
+}
+
+int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
+			   struct prestera_iface *iif)
+{
+	struct prestera_msg_rif_req req = {
+		.rif_id = __cpu_to_le16(rif_id),
+	};
+	int err;
+
+	err = prestera_iface_to_msg(iif, &req.iif);
+	if (err)
+		return err;
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
 {
 	int err;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 6d9fafad451d..3ff12bae5909 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -137,6 +137,7 @@ struct prestera_rxtx_params;
 struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
+struct prestera_iface;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -238,6 +239,12 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
 int prestera_hw_span_unbind(const struct prestera_port *port);
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
 
+/* Router API */
+int prestera_hw_rif_create(struct prestera_switch *sw,
+			   struct prestera_iface *iif, u8 *mac, u16 *rif_id);
+int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
+			   struct prestera_iface *iif);
+
 /* Virtual Router API */
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
 int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
-- 
2.17.1

