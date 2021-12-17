Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D618479520
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbhLQTzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:55:38 -0500
Received: from mail-db8eur05on2092.outbound.protection.outlook.com ([40.107.20.92]:63360
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237469AbhLQTzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:55:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvUhOi0s3OJYpmqjpOFtHMad5rJlL9Y0/vLYwI02rts6O4kOGLMpMHmUJkpORXndiGHMKQoBdgA/m08g1S8O8gom+I719oejRkn4QNnagnV/3jeF0e1QIImYUOG5HdYeHjFj41CaumCn+UXgSiAqIoRewRfGHMJGnEyqro9nxucuuonyIwhguFJQmZgvpolvYWwe7gbUD+903q6gBkNFJ7igJYQuQoB2Gp5SupgIUt90M8l5+vUFxHQNj72p6eOiQgUnGaq8R02kfGo66gN0twdtyzWXq9ryxFQhc4Dh4wyJmXUjiUOUhC8B+MbNM1y+Gvx/5ReWRG6/KEuH4gpBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHplTSdZbD5pBgxiEetAjzz64gAEHRXm5/rrtGAJ7BU=;
 b=enKmC10r7l61pChHjwY3GSZYgQuBSjxoRenp5XknU02e40Z9mrrwrP/elC27pWSqGt+EgTiE2yDtTzXc8lZCk4EroGgiqUq+gQ16es8XWQkwJdOSF9k2Fxr3Nks6/5GkNkBx+le9xS7scCEF1IqjzWpXG+pTro+NDb6dogUhGAI742u8gyKWzD8mmGspLQQ9NP2Goe2hAd+7lvvLhigjRC8oC+6F+vePJXYn3AY41WFMcSrSm6TMqyGKS0Y/DN5lU2vj5t+bG1gstMOMbBsXuYYiruTsLhkuvn3Xw9iwdADm/z+eueIDfAq5gTAqXCWFmltBinp4Ea5qroUY05JCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHplTSdZbD5pBgxiEetAjzz64gAEHRXm5/rrtGAJ7BU=;
 b=jGNj0H/PjDO1z1AaSk6P8Pk4afoaC9PpYH4q0GACfDUfwVLGFlv9vNFWbuXALbnW2r8U4KKZh+KA2griubbe9DIUyPrLUTtg1fQ45pTfTqAkI68cd7EdJzIqVQ4oHljmEvOna9ql30x6GJcnj+4fI3KMA414+ptRo61+D9omI5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:36 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:36 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: marvell: prestera: Add router interface ABI
Date:   Fri, 17 Dec 2021 21:54:34 +0200
Message-Id: <20211217195440.29838-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a2b75c4-0c58-4252-e7da-08d9c1973142
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB10587EE1F9F46407BE778C3593789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUycg9AZ+qc/PiWHx0QqpKWaXyNLlOb5s5VcWbzc1H/JgrhupjQ06z/86WNCpZAyf689BDLU+xSkeMmToN2Ok5gTBTKUyStRhE2rsxBtL3mvif5UneOA3qz+yZnAQbeKiUOwHMyc9FomjLBqrv8vitaz2LncV7oh/RaD3tWIw1zITygzmxpzVs/CTF407x0PmY3slYbndk2UbP2k8zy5W23cPkGoPwEYxB3yArRR/O5RkrjijDt1OfqGrxkBnjyCzPpg5ITD64Mr1VxYfjC3G0+YrWRsUmzfxrGYeF9zOghMG318UmAZr3X0w+gUJpnXGYnnfKJ9W9eSG93YHxWb48wyCab5KPuk1Rc8VjBTs4wM65CoqRTqLpbx512GzDEV8okmn7W1yLmf4Y5wANFvtlPtTTqspc4j1Ows5G63lQ1KP1DJgHK/4tVA0PXdaLzEMK1fOYrqEgrPbVpDsT5h2bcnsPnb3TUcnppDhqOf6RcuIIK8rkQAmrmH98agTu0PzlevwRO/j/wUaIgJqqUh4Pxp5qXt0jJsjSzTPiyW1MU6fZL7QT+YRqU7CMVfkSenaDz0PIwMY+p1EjvsGL8IMp3btevLP1WPjZ2/lfmfdtfGMfOwFzZ0sXJjBqFqbJ7/5xnzrGn7qb3/DUhCoBwqEbBJq7AcB6wFToBrow8pPbVBd8HBxsc7zg3CbBxGf+QQS3Iy+4Dwryp0MWNB7Ue8dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HQ9uhdbauN8KdZlUthFexEc8jACHvxQx5yu5nm7hKx7nmNRJmcqOF3dPvLG+?=
 =?us-ascii?Q?7Lte/XycV/Fbwnjm0KeXL4cQjpiOVMGcnDxvcZDY2aGRGgAugB4jUKfdX2hV?=
 =?us-ascii?Q?8JH7puZa8r2iokUKG83q7af7laAyw7zFXPWHUSH8AWCigkc0ttSe7j7XEroU?=
 =?us-ascii?Q?heCEEqyqKfEETsST3czR/lzACSmWB4kTeCakadISTvp4YLc53ADhy3id3wmS?=
 =?us-ascii?Q?PDEyfpt7vExt/PkQnp2hjEF/v34nlALhwzrbiKm0+RdQ7G8PfE47b9S3Cq0v?=
 =?us-ascii?Q?sBbNkn+N09SbeVmJpo/Ywk/Sq89sh12r1rufdX+tHII8xe8JbQXO1kQPwAwA?=
 =?us-ascii?Q?NlBFKBJoyRkFh4bgGRIdltlk4MqE6uYa2jBmB+xVAnPw3v1MVdgB7Tgn7ftA?=
 =?us-ascii?Q?AW4hg47I2lsfmIaqec4Es7qoy07Zv0LgopHa3s72gUkJYheAbhEiYGzb25Px?=
 =?us-ascii?Q?r2+jasSl6Zm6e2EE5xbpzIPOfaLQ9HjBdXH9iJqX1GofJYs/4IRPN/sDmH8O?=
 =?us-ascii?Q?41cUPdF6MLO6UZdcO1wOqciSEBATg7JY6njnw6lu+Leg2ci3kXBdCfh21U7S?=
 =?us-ascii?Q?wgf6Pj0yp7Ji2cWylR45/Ij4Vw1zXtvldJXuWcdLF2dFoRs/w7wFZ/3CWaXT?=
 =?us-ascii?Q?wKlReUakpTgZ8io4ai0rvvyvHndSygutfQsZAPQDcrX2vy4U4giegnrNjw1e?=
 =?us-ascii?Q?Z8GLhSan7hgRYZaDNBMipZSs8EzHqerByhb07Z2UUI77gkU6uOQvJTt+5/fr?=
 =?us-ascii?Q?fiMFnGtSyZ5xKDqH17ES64Beq4qhyiW5md3S3pGbECX3+vMQgsJVmLJ1PQDP?=
 =?us-ascii?Q?+oIt5nOcfhVvUSxFcHnRsxTRNhO1QSNvYe0f7127l5FqQZ9o2xYRsnmevfNb?=
 =?us-ascii?Q?5sP6Kwre9DiNKtZbo1PAi6gHrHfw+aXOrzedj+B3EH5wEhkdomknbNpiIFaS?=
 =?us-ascii?Q?H03OUZS1dCDEQjc2QcIVR2s/JMHboFlSNbP0MRyvbFk2WA0wqzgaedlnExFw?=
 =?us-ascii?Q?Oy38g+WhFF0r4U+iJXWEyAC9P9EEXkL4xtkdajkYD+851yH6kCKqqLNwWhk6?=
 =?us-ascii?Q?2mcUPw36xylwtfEN/HjDOgxuHhpZ/2fC8Oh65aaj+4xPdCLr6BtdvTIq6ryA?=
 =?us-ascii?Q?PuyyCGZNnvB+wogtw/MhptNoBSqa5ySt4Zml5TooSr97ridFajkp84PRuRAk?=
 =?us-ascii?Q?B8SYHveOLxIc9rvNKG7sVNPAU+1+lCOFLJxYJbvGx4jFyJQUMB5J/9fUtECO?=
 =?us-ascii?Q?tk4/EWwl3a6vrJzU70p0VgRymxyKyfKSJf/0K5Hk89TkBmuKIE0eD9mYaQes?=
 =?us-ascii?Q?ZygUg3VbkH5NguhTad51RwN7oSrZHHNkZNOyFdeN0yBvAJuMRsTgOLgia6gn?=
 =?us-ascii?Q?+n+AEDuGwvgsoFOyAS52srSJfSp7nbCKYa0HABQqu0yl4B0NTbgTP4Ek5J2m?=
 =?us-ascii?Q?glZ/wEgKBwvLet0dQ5mPh5yXtWZfc/KeAXa18pTv+FDGEawUN7rFH+0wsDiC?=
 =?us-ascii?Q?WiG3RTLK2q5CY/JHbg5vsuPC+pcHKkP0EwGfTZWgY02Mg6Vgl5+qRYNexgqV?=
 =?us-ascii?Q?c424ie+j4HxbFWaHewIgjD2EWkIL/ztA/fviot2s1CrfWzvJ49hwBKDEblCS?=
 =?us-ascii?Q?kkOy9jI89LBBq//OIG1au6kWGJkYQQ+VOyU3CQ9j7P3FexyOknK1YUHWmO1N?=
 =?us-ascii?Q?QKNV5Q=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2b75c4-0c58-4252-e7da-08d9c1973142
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:36.1419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oikY1zQTKt6TH0reFyYft9rg6adY5kwpOZG+tEIitX1zHhZmIiPmYclwDHtd1mQKc33mozbtqSNg6QURwEOPGPmcR2yU/y+ZMB9v7ttSHu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
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

