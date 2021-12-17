Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F27947951C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbhLQTzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:55:08 -0500
Received: from mail-db8eur05on2129.outbound.protection.outlook.com ([40.107.20.129]:25972
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239208AbhLQTzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:55:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D55XlncfvZxJeioQK7T0gfZbKbOgTPOS5lk5LONq1BVoyfKdlZcGJZ0sxT1srR+YtA5iKAIgIsqbjgEb0HBE5pGOFHQdMFiNaoMKCF1L2aS/u4RoMxSRc92a1Es+DVCFAEhyToKCEHcCDtLYNSDUavOdtJDyZNIHPzgVchQIOoKWQh762qOjQY9nJ7PLJpgEww9PwFuwPPl9s1SZxrQ6Z4ZhPCnKtmu9q+R91FxMhmNDLbE3IOC8QW2Dvt4Kzf4sMWKc49+jFW/xvFQhPRm1NrHEs2KfOzdOBvTx75SDKeSVbn21PVh3HlH8srPqXSp+pC9/Sz78fnIFNcaVTjE0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsNmKlMKjhyNmNdrOUTpZB3EUTkHlFBtACeubQi33do=;
 b=T3P4A1uLpAzKJkdtdBjp0QMKgC5mLqJV7dBbvDc0YNyt/tTD2nhZ3A3vFEs02n9k60O0qhtv8RA7XwCeaFGF8rjcVlfzUDqAeCk8z1PJ4maIvAsZEecQRWdUWQfsF+YaY39JxYoA/UeB0NditJAjq9UM1ybUJsI+W567lGfGG1TJLvbgeZ9xvaGBJ7xUN1I8pyfgc4kZr2zk0Pe01OiYsuCmrZXVAqFSxa+nkXvjgQmu+Pclupb7ILtSG8VM2hUp9MStOeYXvq1oyfgIopUfbma19kRnT0HrOe4WCMTRk7ipGZZTDSsCw/EjL7FP1bmBqQxP/jejbVGa7KzGbwUobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsNmKlMKjhyNmNdrOUTpZB3EUTkHlFBtACeubQi33do=;
 b=Zz2xLTnGWMUrpzbH1HC12iNcedGvsYQ+thob/xqdwBMn5RPBdvYaU1fOMoTdo6FJAAE3n9YowCdlmDto4u3S6Jz5kvvOupL0Jj6ZnSu5LQTfFqrcp9so0CGKH4FgWBuPRxVEinM7ozHZxvn+h1M5WiZJpuffS4xBsiT7rTn4rpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:06 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:06 +0000
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
Subject: [PATCH net-next 1/6] net: marvell: prestera: add virtual router ABI
Date:   Fri, 17 Dec 2021 21:54:33 +0200
Message-Id: <20211217195440.29838-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23f39fee-bfe0-44de-98d1-08d9c1971f7d
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1058293C85825E8069CBB32493789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNqrZZgE8jDu9hsgM7yaLwvtLpdyOyeVn3GzL1GbQoCkMsSZAtqc8I8WEPxA2tszs6raoLOtu006yGbBZPfMPZP4ogkx159TacPdgQrUgwtU/PgoC08Jvb94sxdsAstTOINDKzogKnd8AhAbJsg3UiuY+L+KRQy4Oxfvo9jDp5AYNeagaQ0v+UGgii5G4+YSbhnhI3L07iPTcjn+ZDz7La7tiinAsQ2Jo/Wa6XwluZmLzo5B/vmcxVsLqrAbMe6r84b4pnOT6wr5OFc9iSQJ3tczBFmB5VSg87LWsREGadgPyBN3WfH0QEECHeMPUxB2YA3Y3eyyAn2DLRq6P84xcHLZwNr5Rwv7ZfSoeXFp4INwtrL9NkHF4V+DCBpNKGE2Oa4g8bSADVrfCuN+uvNqenfSCHVuf/xMRSxBHnmTPF7I0rqehKNhtz/drxr1V150XPtJKun8GKZ2cNw0372ruFPDM+n4mQPjwwbKWZd0zrA0KpZWFVWXR/y9voUDZm+RO+37HDmuTmgu4RjZqlTQqoPk6422H3byej+OV8zs5zYkqodz5TnRdHG4JkU0DA4P9g/qDsHirBLRkiYjWxi+KQi/YCqyMwlA3nGwm/V6FVt+/Y42FQQHnpou7hv4UKGnsEzbk9UyDdP2SX47j/gXaksyBsw/9dw0b84fMweSu5lmHYnuZ7kcHh7ApI/MzNZsqBHQ1/6cufPbHzKGQNERow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EdxPLnm3xDDWPrBaLLLBx7eqQKEZhD/1YPO1zx7Z6Zi/oXoV0bAElA6co7GC?=
 =?us-ascii?Q?TP10qLL/k3JRX8WgiRy4fFZAzClHkeHN+ozDbHgzoHHWqdule6HL9fc658qr?=
 =?us-ascii?Q?krOvNcaBE08O3UbEUP+QRsuIG00HJDqFXqxksH0s/I1R40R0VxfXpPKmPZmB?=
 =?us-ascii?Q?b2SwGSuTXr3CYgtHgsazemrxYOcZy0jC1+HYb2iQktn8wnb5TGwp0aCSNGY+?=
 =?us-ascii?Q?pKgr8OQswDJLNQQL9bs8c8MjORDRez+sQ0HWAJNCwUq7OT8hd+tJbLz/mYa/?=
 =?us-ascii?Q?b2v6V8UVE0ZNN7jeY8+Aa1cG3icLQDX+HRJZRI1bXSK5GFbaS3ok+WWAeLL2?=
 =?us-ascii?Q?7GQVpr922FRVsrs3LL+O5klTr3oo7vibyNivDfDjvkxIQFXmlPeCOWF3dmzh?=
 =?us-ascii?Q?GA+JP30aaS1oY8h6oZqMJ3Gzm9fUzndR7W+AIt3Hngeznrn38qS0NYtyGHFd?=
 =?us-ascii?Q?n/YzfCZgmM1snukN8Ziw/j+YfFURZ0URmAkO/dmixB3TZsJl6trmbD1iPsMT?=
 =?us-ascii?Q?TyJot+zz9CHW9hQq8hVJcmpHkguLNMwhtP/wJ+m+OH17nlNFKv08mLguIFpm?=
 =?us-ascii?Q?xZElJK24Uhe0tMNad4D0YiR05G6AiCIvPiEO/M2MvBMTd/ffPPtmCPVY2MOx?=
 =?us-ascii?Q?rnB4a6V7JnX5q5BUyzz6c6iYmWANzQA/eDyCJSSWH/OcYTeBFx6F8XF1mFoy?=
 =?us-ascii?Q?/veS5JbPMjBYA7wNRZPcI35c8eEONATzCgWnXMmQSUivO7CJ8ji5Vbf8qCZP?=
 =?us-ascii?Q?QFi1BTWOYMWk+8tEvLqw/UVMRm1DB3xYxGOXpI6itCPNTW5ASHeh50MaJXgc?=
 =?us-ascii?Q?cdTr6oWeEhfyZuFcQtI+mV4jiXvPTx4F06UnBj6lbVVY52LBx4grFKE+MEkJ?=
 =?us-ascii?Q?NdNKGDefO+aW5faA53udSkmV3HcdyfCznwosalIxDgChFIeCC4sowX6qF+zZ?=
 =?us-ascii?Q?hXHH0+SrksNOy7aaMw7EgHy3XDyCg1QbnBsjTo/JQRHX7WPhBrVYl/fFLMqT?=
 =?us-ascii?Q?Hfg30vpYgGk8vJuWKBQ/WOWcRniwo8CDWQbK3EYaN6YwykoW3OyLJosTvsxm?=
 =?us-ascii?Q?/Cgq00O1liYxHuR87SA5vx9bMZ/X0UNAt0I78zz7rqrTWXzAyxKN2g7W33KX?=
 =?us-ascii?Q?n2G0k0X3qACfKgdWS0VUbcKm/Ji5dcatS5IP5rLpyyBDq6Hztvdkd/BFSO0w?=
 =?us-ascii?Q?tO+0iNFwCDY3rSTTNu1Ym0jCEsFw2lOjQVilUIFI+gG2prPVVJQMfcALKHIy?=
 =?us-ascii?Q?0I2TuFA1yocx2fpJv64+WzioB2UE4A6GGtf9cPNDKFfwYhz59hNCZF09Jcjg?=
 =?us-ascii?Q?Ph27LkfrOS7/nqg2tIlOCGqicaGFsOJ+B7BvszDM+1DKyinyigO39ka7ieYd?=
 =?us-ascii?Q?Bo61TXcluh/Zv7+lJMkE4v5zZSLc+42b4jiOU1Ld337ed/yYYVPwUSxUq0ja?=
 =?us-ascii?Q?DhxqUcxMNRonWrpZlSY1xBFtllikFKX57iwc/HY+H2nqgFJPqB7EwzP+peOL?=
 =?us-ascii?Q?wa3SegjFf6rG4dmO53ICFrVkq2c2sTVSJUR0S4SHL8aTZXda+OsoTdxsvshB?=
 =?us-ascii?Q?UzTgunDhhvJdTVpMg5z9DODdNgvv541qo9rJYIYBJ4T9/naQbE6APkQG+V/m?=
 =?us-ascii?Q?rTFhMk3mOBWfrvK805+kEjXYSqlyTvSi/u6fmaVj03DPbhgl7j3ynoSmv8e1?=
 =?us-ascii?Q?6xvNGQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f39fee-bfe0-44de-98d1-08d9c1971f7d
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:06.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQs8CfraNDG26MkLzNHogPsOWckKI2srMSZq8fq/tMrrlco82CCDsk0t0Xvcd5eIbNZ27pumBpvgAk15Mq9SpZxvXFxcyIyWDbLVPqCNgoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
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

