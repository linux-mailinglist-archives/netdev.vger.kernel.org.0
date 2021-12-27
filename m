Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729824804F5
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhL0Vxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:53:47 -0500
Received: from mail-eopbgr60135.outbound.protection.outlook.com ([40.107.6.135]:5761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhL0Vxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:53:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2N1lZ5Du8pWlmG6Q41BQAlqj7QSjyNU8olFIfRw1VESlWUCU/cKwIxRJtSk1VE7bCqGP3txHxQGRxOAJJ/NZYFCo/OXCwRrDQXou+K2CtsFFle0acwx5sD6f7b4WONUTTjUuYdKrTz2xFE2IQ/r68s8GnxMnoUWWUNTgj5EaEt+mBt15sUKm/1GLDf522MVmY96p9yblcKP1siE5Ygk6ElPNV+IWGw42ZhMqzS6y2UGLa5f/7SU0tgQiKCoGWhs/xMC+wEcFWMmf6eSAG8hfVm+1467WZg8OVsc5xBInap1jusV+iFDoYW4Gr6E/74YrZi8B4nd4dLJZ+9pbnLKjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMEdH1e7sVyEbgqfb6xlm3kvkBVwUOzzcRb4rminOmk=;
 b=i/EQXhv1m5OTkun0frGVYSp9hfnmY84gj8BSi68awvgjfXI4Mwvz9H0RekPJ9SQh2WY6Z5MBrZMkfiagd1lUOcYmrcUS3Kd66sAJSjYcqmiimU05ZbpcoTTgb03oHHDAIU1NqmaKhTkvw897/myyZToTY05EciUOPxD3RVRj66Eo+UeNRoC0AkHhNqDOlN/AXtS4WgJl1Vgof/mnnkDTpbCLpOV/VYxr9OwyOzux2kWHVsrGuPv/TOVe52+7f+JKTtuIHUH8e7AUnScVbSlPq3OCa6vSBCe3Trq+4jekUCQt4jkeJ7Cq+nK7a44GnmjOoLvRktSkdfVjuOxVYHnopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMEdH1e7sVyEbgqfb6xlm3kvkBVwUOzzcRb4rminOmk=;
 b=iioZ2PvICr5SCOgZ6id9wBvGfS1wteXsIFWMoRmBJax2M+9HffMNguOr/J2kc1/O1zU25T+C62SUP/XzhiZyLF5pjF31FyfWEB0r1maXps9ruZ8vZAGtIbMPE4jgCkrTGGVdgI0nosX/5wYcTfFMdHPcV3WMWBtztDlJjGl8Iyg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:43 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:43 +0000
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
Subject: [PATCH net-next v2 1/6] net: marvell: prestera: add virtual router ABI
Date:   Mon, 27 Dec 2021 23:52:26 +0200
Message-Id: <20211227215233.31220-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47ce926a-18ad-4c3d-d5c0-08d9c983599f
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB014585FA0C1FA4B64305BD5F93429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbLPeRsmdbjv9UJBg3qQ7qZgPQOxAMy0LvDuVPYewRkCf2mfa50opp4NBJ6k5469JS0HY5hKkPIhyO6ndFC4xLWrpQ5djCMpmMhVj1VjqnJdTWmhu9wSTTZpWbR85Z0TzgCgckV4F5/y27J+fB4LDAI54KZsXrmeO5exsHI8CtsB4Vw5nHBXBavLLLmqXNDw5EAqbuKOXVTueOWMrdXZmeUElMq7Nyw+n1nWwJi+EP/qSvBA4Jj7OIRemhsdIvy0o9rofafRF1tdA52DGICaFZVtpt//Pk3r/ZVLmblxvJCy1QB8KxW3Wq7AGoRYoNNPXE/ge76rrhqedFHoeH3E/fHA3josnS3F8CSTWpAnhxmv3eMwWmoS1VndIkOhiBPI8yp7O5eYAsQXHWprBU6/Nch4XXWc/uMC7Jyr7qdRB8FMmaZO2G+NlbhFFBxWj9c9xB3MA8opWHcQYcU8JjTydr5r8z6UScFk30UlgZ7JHmBjP7A/X8ul2a1R+l8Jt4HoRc/aN4pdmk7kh8kEmqjb3HS4oM7mcmb38JzWOnse8tN8/DIs0p05cGU1JOn+/OyDJ3uVoPonvBeYwehYEFjOT+L48KcP98ZzKMZ0kirDDtNMdlxmeZkg6FDV950C4evoAjZLWVLvX0VEsJv4TQmOKrb/sLlo+i6ga0RvxHcgbAKYIneC5qVg6p/D0g+hZYHUtkLr5ySp3R3fobHnj2D0Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EftbtOBaEP8lfAN49f0dkOJW4wnTNQzWsbKX2RBP24pB0AckB7wx9KtF98Wl?=
 =?us-ascii?Q?vdT85gHob4GgOosj6OBt63/IKRNAHzyZKO3Ouoyb0vWECahgJj4MGdWIfc0J?=
 =?us-ascii?Q?c3k6AClLX2MtCRnWNEp5bPtGNiqStMn28/5lLx4zrpQuWhMqBDfZC7IcUFUY?=
 =?us-ascii?Q?fyYbZlTGgllDyC468d3frmO9qTF4dryJsfRyPRlFhWOLmIJt3uY01JhHB7xi?=
 =?us-ascii?Q?0fh6Nu253JUoliyQo4o2jPgL/CtdU/HwGZ+OzilrhEeaKRlLThoCoE4ICmtO?=
 =?us-ascii?Q?PQDbOAsrVltz+FHEEOPvq5WAn8FIpGX9LPvGQ8O2woWExM1mA2jLORNpUkRI?=
 =?us-ascii?Q?JdLvdJnUGAufm9wTTXCEewi8M2npikYYAbezlDwUVJTCxG4LZUYYgYDOL0uo?=
 =?us-ascii?Q?KPpOTJ9KDogVUpjovAL4VNHM8d3vdWxZJYgvPw/I8G99DIUX7CNoY2LhT8rC?=
 =?us-ascii?Q?P0RWGwt0tKtVUTEROCoJP1M3QLH2b69mozEcaHkUrEx1Y/hGT6rqSXxYq7iq?=
 =?us-ascii?Q?7z4j0p5H47siD8IdoEot6mGG+64wZej4aVH1F+TP5lcrt6vcc01LiJX+5RXb?=
 =?us-ascii?Q?pTKdQ75zHfZxDnGBRGOpTPkOUdkZbsVKRJ8dtsy86Xn+5rFTrGXGKGkfsdlW?=
 =?us-ascii?Q?/wIWsggdB17e82+BXwAJUSQlEx0WA00A4Pa6HN/ddVj10SCh+jOys5xy/3Un?=
 =?us-ascii?Q?P5nFNE51dCI0ZgBYC3AYqj7MZ16hyuIOrsxZNHbEmLKLFxnx3qGnXK7FgpQU?=
 =?us-ascii?Q?9H51JMtagjLIo2w5J63Fvp7EuVEO38Uy2oEmA6iQTCnLBewTX5YzNqzuZ24T?=
 =?us-ascii?Q?LvbSJCq7eXwM7Ww1Lnj0jLlBvf0AcOiFhyYjKOGOvWdc4UDyvIdIFku+fDME?=
 =?us-ascii?Q?0YrrIi94Lx4oZRAdpHS5UP9I0j4m8GwqvQt2jFGvedWE0NbNfoGYeR5oZnty?=
 =?us-ascii?Q?TjK2f84EvaI/zkqDe3YXaF0nPvgLcIZPIogZY/7y9IrZDDpIhorvsfv5sOCB?=
 =?us-ascii?Q?bRz27NcEEvQshPnXCR4D50zSWQAQsnxlBIXmD7B33sNWkJD8wStznBTs+1Eq?=
 =?us-ascii?Q?D/zxDmYBjIBDenQw56Z36A1fF2hsLlnQ+UPnr8ZvZlE4AXpSvqmXrxOVUseT?=
 =?us-ascii?Q?qE85l+i1nQkuCLqGqN/bOd+P+ItrXMUO8Y50kUWoNW0Hw9Jb1y5GCOMFJOGe?=
 =?us-ascii?Q?jwAikipZ7zmF/c442D/ejr4My0MsAeuviwpy1J6kzjXfnaCCHwpWADeE1U2I?=
 =?us-ascii?Q?T3XljZ/t7xLRNJTIbcCr56It+MGkerZYAysl7l+2NZ3hePlORUq6Qol+sEQp?=
 =?us-ascii?Q?LxAly7Dr/eWAqM5K3uQ4hlBX534f1PCZX+n++rpQTmUa6zi14zKzD0FE6yZd?=
 =?us-ascii?Q?U/D9nvhhxOAAi+476Qi2MLqYsCuW32azbAuyw4jqNc2/xkkOIHovMaTjc9GZ?=
 =?us-ascii?Q?jl3imNMgpxmZhDiXNJkw9cTikbZsvY2XfFwhUteH9rIEY953tDhkp/7rkShb?=
 =?us-ascii?Q?PMuAuF29/58gdWERyPCkZisUfYLdFGghznV/FqDWKnJkjl0dJ/6czcoQuNZ3?=
 =?us-ascii?Q?45oZNI+kvOWYe99WB0ha/P6gsaM/stpjgWeRr9yTpqfiQMW4J9Ka0ipByBHk?=
 =?us-ascii?Q?qFUKiPq+ojEBGqow2xxBvaA4ipKFb3+UqEIZmtkcXm3IVLNZbi+RKpmBGsha?=
 =?us-ascii?Q?1wxVCw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ce926a-18ad-4c3d-d5c0-08d9c983599f
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:43.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WquXfImg7KdjXpIAnjFk5DYo4d1iSFqS89VUvw2kKitPfFH2U73/gKxAQGSJeglfRUQGhdPzzukPmbww4kMgfhcj4UE89+u/RMpRHo2AuKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions and structures to allocate virtual router.
prestera_hw_vr_create() return index of allocated VR so that we can move
forward and also add another objects (e.g. router interface),
which has link to VR.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
v1-->v2
* No changes
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 42 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 6282c9822e2b..8783adbad593 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -53,6 +53,9 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
 
+	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
+	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
@@ -480,6 +483,18 @@ struct prestera_msg_rxtx_resp {
 	__le32 map_addr;
 };
 
+struct prestera_msg_vr_req {
+	struct prestera_msg_cmd cmd;
+	__le16 vr_id;
+	u8 __pad[2];
+};
+
+struct prestera_msg_vr_resp {
+	struct prestera_msg_ret ret;
+	__le16 vr_id;
+	u8 __pad[2];
+};
+
 struct prestera_msg_lag_req {
 	struct prestera_msg_cmd cmd;
 	__le32 port;
@@ -549,6 +564,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -561,6 +577,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1752,6 +1769,31 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
+{
+	int err;
+	struct prestera_msg_vr_resp resp;
+	struct prestera_msg_vr_req req;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_VR_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*vr_id = __le16_to_cpu(resp.vr_id);
+	return err;
+}
+
+int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id)
+{
+	struct prestera_msg_vr_req req = {
+		.vr_id = __cpu_to_le16(vr_id),
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_VR_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 0496e454e148..6d9fafad451d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -238,6 +238,10 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
 int prestera_hw_span_unbind(const struct prestera_port *port);
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
 
+/* Virtual Router API */
+int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
+int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
-- 
2.17.1

