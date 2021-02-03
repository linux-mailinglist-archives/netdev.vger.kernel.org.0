Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6B30E063
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhBCRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:00:44 -0500
Received: from mail-eopbgr00102.outbound.protection.outlook.com ([40.107.0.102]:12569
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231346AbhBCQ6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:58:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcOpSeYYs2upq9Vs3nh1WpQudJbNbC0GgWLf4Yn0oUKmvuarONaTC3mlhxjvQAPNbXp5ZR1An6X6B32ANiOgQyo/veD/Vx+YqnHVpqnGAEWfIHT/RJiWNUkAJxMRw9CWXwztpYd5XUE0F7IpJ4oxV856VQmw7ZXxDURkgz1ltT7vcmxbilej5AjrDDxxcmaVAUMcEwDlGWmNbzvKvILdVPvV47frbGzxMn5D+IdT0ZQnNDkxUD5LtW2c66pyk9T8daEE0ltWvUWcSDJFbSSoK2BjT8a5wTg+hE81IoYd57Q7rHfadfcmxNQ5lUKm9o7ZvNgjs2VzabRUg2o835Q89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zpfapr/sa3BpW0murgJm1XZxqAkEZMYlcfEr0buk54g=;
 b=BJiNAgR7oWZ+87XXDrG7LGzzfkU6FsqYJEWcPQ99cm3+BztYw1aaFGoJB0Y1Uiw3792bN3X9JLMRcPQ6yJAdbbOlMRBSGRVDVmO4iPhu0IS/Yh48Q+JgAblTd/FuKRStGEG/YoTnn3qS6OZL8GbG/9Rcr4hbKKHHbIiOLLQWB5cPT80uI00jImgHYR08WtT7VPzNVrccPDFTYEbtuJCLweqqMzPVdJiLPGCw2rdWKKGOZ1x+Ntd0dGUBCK3TyptJtlvGwXyR4EbK94De21uLHyWaovEf0HylR7RORznzVtJh8xi3uhR345x9EfpD67sOofbFCMfrZhWO0PAoWZL4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zpfapr/sa3BpW0murgJm1XZxqAkEZMYlcfEr0buk54g=;
 b=tSzTIQEF6y0HeD7GZ9UO0pFKEnqQ/WwALbwvPzo0TYend6QArhxtOon6GolLq6JcKzpaZzm+6nMbOcBqsX927piXrsuib/aakUDSp03FquBtd2q6DQHSihycTKAICYo1oolB+WPIMtCbW7VkRTjiuGtwYkiXgnl5V4bAz1w94h4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:59 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:59 +0000
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: marvell: prestera: align flood setting according to latest firmware version
Date:   Wed,  3 Feb 2021 18:54:57 +0200
Message-Id: <20210203165458.28717-7-vadym.kochan@plvision.eu>
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
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea929631-b43e-48cf-3581-08d8c86494b2
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05393AE9157F8AC4B389176D95B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSNauWN7h6pYwnZ8GNYVhzk++neyOaB3ySV6+o5RRNMfLSTlSb4GZsmuZd94p2FlZYVMJVaOAzwBd90hyGg+aJ3xN58+ZUrPLaBeBy8QoZ8FtHMJdgMqRldbH2JWoK02Pu5iQaZX3NC7BXNKvEGi3tUYOJSs/m21sQIfiJHXsu+qQ6cfARwjRK71fRP7sIM0VL56aveJp6GgVPloxfPxXGMJrGCHGNDnyaEa6kGEduZniZ/91Hk4ocmTLz7bNMnUQZgkaVKBGoK4x1sYMu1zdj9JOu1txckPzXCcL5flcTjLL/i94cceQA/MOi+EPdApjiorXCW6l7VG9i4sSgwqOAm/ZiYV5afKOyaC/tc5hweWUmmw8xwrZqL+enPvFsSRpdG90xLB1dcpFQEKuue/hLdRSiX+gPY0wWRx83xzhw7y4C9WSXxH6oqJEC9ekykCXSNLmKdpJ2qc5/sAv2Os2P3q8o2ej4JM79mwzcDMASpsZmwSjBAmCmXmXjtlD6pC+tY6UWokmfjHu0jtOTJv1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(83380400001)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(1076003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zVoe7KahsrwTzzMoLCk1ZlsY+n4mGTTnmBFyV62ANzKJ+WthXWxUCTPL2MQK?=
 =?us-ascii?Q?/Yc7scxB0hYC1vJG+SNfRlZthA7axqvqCbt850uK45QQnlu/IhFkmHyYyeAa?=
 =?us-ascii?Q?RZOCd7bYw1KU0aM5CxOLILBKYsTNBav2u01b8bBhUqUvvjhngt9wxuMdhEvV?=
 =?us-ascii?Q?lb/R2e9g2KGKeWEpjTAyC35CRiaoCmuMSkiVBbtzay/9Hsr13zN/yOO54F+P?=
 =?us-ascii?Q?di5OdwZczQGjD9oEzF5n6cYl/5i8ruHj+ZYcc9HXiOt91RF5USRIXDhW7RSU?=
 =?us-ascii?Q?D2CJ73R0hDCjzWB+y9D8nOi7drm7vPgmIepsdcBfvwrd7+BhOxPk9vUru16N?=
 =?us-ascii?Q?yjepbeXM00YuhiZ4aHusoNcbmtvs2RDMH+EYw1QkDKq28b0KZeBGpMnF2nIW?=
 =?us-ascii?Q?BoppPCPWZPkIhMRHP9cOKNgX8bYooMdFp/swtIzr99JCx3/NKH87pqG+j89q?=
 =?us-ascii?Q?TYgZRvdjXGQkhYvJhmC7/BCzvERiaP9qo562F63nka0VhTS27m3K7oBr6hh1?=
 =?us-ascii?Q?rj7xTuelYkbk0u8Y1G2oaL39FSwkB4snzT+N6zrdlIFchuCAvf8XFChCHLcs?=
 =?us-ascii?Q?VWvzgZU/BySzTxhIZJHdcwVNN0iS8hlxpX8GFrwSiAEo2n9bjt9mRGiRb1v+?=
 =?us-ascii?Q?YBitXF2iVhEekt2wrPHE1s7Jzu6UWj0Gb4OK7gaD5ptEO+2adxvJ7Cg/DUQf?=
 =?us-ascii?Q?wfOEXwhUsFX2wkH6w55SxU4OYbaM7XC7F/PqZaO/52kBMerTsqW89SWI69FC?=
 =?us-ascii?Q?Cwofg72Az3BFF52SSahNqQ0vNlXQ7XR5AWKQAVa6vzzz6XiXU4l4sVkgpp1a?=
 =?us-ascii?Q?iIsGIdmWbAwCPmlQWQqVWwhgoL3Q9RwMNPmcfDuNgcKoZ0nWtpoIv/stnlgo?=
 =?us-ascii?Q?kLX0bkIWdJlbAfTWHjIQ/v24oakNMVR0RoPnq6oNzBVGjAe3HDgd6BBevwhe?=
 =?us-ascii?Q?pPf1vz5vCYzuW0FDhMn30ZFgC6J+UBK2dBDUzs+Z4988ZE7WXgRyiu8Q9m7C?=
 =?us-ascii?Q?Fa1axB4SwtxZGaiGy+aB7R0rAn328luuvH6YKEApW86nHDy6K5HFbeA5cbZv?=
 =?us-ascii?Q?GF2wmTJSfJxZ47esuu2+ILDJa3eI2pBEctf3frvP+/4eCSHZGt17ukxQI2Ta?=
 =?us-ascii?Q?tdK3p+8bvrQieJOMPFJd208B1MmlyR4ss3quRLppCrFAsjTcWJYZYMESxH5B?=
 =?us-ascii?Q?qLo1taVxFpSXn36qFPR5lUA+rktRPfPQGSZ59J12ZfVJ4hyEGao3f9sM85RI?=
 =?us-ascii?Q?F6FXTV42vMcW6TGoeInB0tdZYNEb0pdJZaT/yKHxaTNqi0HS9+YDf6ZAGMaR?=
 =?us-ascii?Q?ui8rBypwRVxU6ci7d1saLlW7?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ea929631-b43e-48cf-3581-08d8c86494b2
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:59.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJ6vqzai84J3pIqRnNEC4ibADpR2lW/nUkM2jB9j9TLelmRRQH4BZp8fZaSreILldxNdtZCPg/tcoixuBYUZpbyvRwHyLc+G3xCO4wWYqCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Latest FW IPC floow message format was changed to configure uc/mc
flooding separately, so change code according to this.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 37 +++++++++++++--
 .../ethernet/marvell/prestera/prestera_hw.h   |  3 +-
 .../marvell/prestera/prestera_switchdev.c     | 46 +++++++++++++++----
 3 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 8afb45f66862..75034dcb3649 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -90,6 +90,11 @@ enum {
 	PRESTERA_PORT_TP_AUTO,
 };
 
+enum {
+	PRESTERA_PORT_FLOOD_TYPE_UC = 0,
+	PRESTERA_PORT_FLOOD_TYPE_MC = 1,
+};
+
 enum {
 	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
 	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
@@ -201,6 +206,11 @@ struct prestera_msg_port_mdix_param {
 	u8 admin_mode;
 };
 
+struct prestera_msg_port_flood_param {
+	u8 type;
+	u8 enable;
+};
+
 union prestera_msg_port_param {
 	u8  admin_state;
 	u8  oper_state;
@@ -209,7 +219,6 @@ union prestera_msg_port_param {
 	u8  accept_frm_type;
 	u32 speed;
 	u8 learning;
-	u8 flood;
 	u32 link_mode;
 	u8  type;
 	u8  duplex;
@@ -218,6 +227,7 @@ union prestera_msg_port_param {
 	struct prestera_msg_port_mdix_param mdix;
 	struct prestera_msg_port_autoneg_param autoneg;
 	struct prestera_msg_port_cap_param cap;
+	struct prestera_msg_port_flood_param flood;
 };
 
 struct prestera_msg_port_attr_req {
@@ -1030,14 +1040,35 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.flood = {
+				.type = PRESTERA_PORT_FLOOD_TYPE_UC,
+				.enable = flood,
+			}
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
 		.port = port->hw_id,
 		.dev = port->dev_id,
 		.param = {
-			.flood = flood,
+			.flood = {
+				.type = PRESTERA_PORT_FLOOD_TYPE_MC,
+				.enable = flood,
+			}
 		}
 	};
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 68ce41595349..03b52db6f359 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -138,7 +138,8 @@ int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
 int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3750c66a550b..8449539fe944 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -443,9 +443,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port,
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
 	if (err)
-		goto err_port_flood_set;
+		goto err_port_uc_flood_set;
+
+	err = prestera_hw_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_port_mc_flood_set;
 
 	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
 	if (err)
@@ -454,8 +458,10 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port,
 	return 0;
 
 err_port_learning_set:
-	prestera_hw_port_flood_set(port, false);
-err_port_flood_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -567,7 +573,8 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 		prestera_bridge_1d_port_leave(br_port, port);
 
 	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, false);
+	prestera_hw_port_uc_flood_set(port, false);
+	prestera_hw_port_mc_flood_set(port, false);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -609,17 +616,28 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags & BR_FLOOD);
+	err = prestera_hw_port_uc_flood_set(port, flags & BR_FLOOD);
 	if (err)
-		return err;
+		goto err_port_uc_flood_set;
+
+	err = prestera_hw_port_mc_flood_set(port, flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_port_mc_flood_set;
 
 	err = prestera_hw_port_learning_set(port, flags & BR_LEARNING);
 	if (err)
-		return err;
+		goto err_port_learning_set;
 
 	memcpy(&br_port->flags, &flags, sizeof(flags));
 
 	return 0;
+
+err_port_learning_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
+	return err;
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -914,9 +932,13 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
 	if (err)
-		return err;
+		goto err_port_uc_flood_set;
+
+	err = prestera_hw_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_port_mc_flood_set;
 
 	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
 	if (err)
@@ -947,6 +969,10 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_port_vid_stp_set:
 	prestera_hw_port_learning_set(port, false);
 err_port_learning_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
 	return err;
 }
 
-- 
2.17.1

