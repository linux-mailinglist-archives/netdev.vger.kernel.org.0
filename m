Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CF5700CF
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiGKLjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiGKLjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:39:32 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80103.outbound.protection.outlook.com [40.107.8.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B039E65CE;
        Mon, 11 Jul 2022 04:28:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwfdfYeYXOuignJFtm9peEfaRDRBqCUbWY5XNSJgvoE8VKRqMULFAuyZerIvLZ5qEHYKaBkdMwjMvnUALVYzJIwWd1vqSgjhUAMoBOrdqqYQvcaHBfTRyHbcjoskBnXMGcTSyc4YgSDKV519Dvj/7vi79TJj2eLMzyatsT6gVWhaDVwc46EHyqWbIFnyEO0ZDqlGLV3xDDTKH2EB5eAUp1bRO+IKPeoyXAtGULsWZIlMK+p0QqzOqDEgb8dJimUlwqsHFNRHvn7Fs2hIKgALU85vdceuLsW7NlY7GwoETp0NdHCl0XzAx0xVLps3K/0ivHh3pTknV6dOHMJUYgsp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=kTjdPI2U1rNKCN8MsgDjuTUADNPWp1pebhpMd58jpWr9MsEwvA/rjznYJeLySA7FABDSMrcErC+corxHKRAUxzJSeTKS+8Np+yvYbyYkNZRVKVQUP14E5dNBgVFHG0Fhhn2nGWZv82GX30QdT0oKpG07FR+NZyLjO8NsuoWsEK1jyvXOdAel2niQY4V0j1jMcgQDyO6oREPnXzauotwOLdNMTDytbUCO4bsjqh/LiVr3gZnl0WoajYKzvILd5eNLtqXbK6oF2FruboJF+y+f08S9cmYWh6LciuoGcXungeErCmTmKzD1knVGKzXOZ4V9mR0QJ7scELJZeTTw1kAw8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=C18gMiMrCtUkaP+6vcsMgMIvU1NFP9ZiINpHhtUZZM+LA1kjly1bF0TJ75Q8zwK/43TmdcdaVP85u8dNNqOLrOTocr/hDMvYXTbYhBcuykJj2L3Aa5+w+DPLsn0JAsca9BuNywL1XJ6oq46GUUSSp8d13BawZXxqtfQHg/GCvtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1208.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 11:28:40 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 11:28:40 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V5 net-next 1/4] net: marvell: prestera: rework bridge flags setting
Date:   Mon, 11 Jul 2022 14:28:19 +0300
Message-Id: <20220711112822.13725-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
References: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 266712d1-0505-4b19-d2d3-08da633080d9
X-MS-TrafficTypeDiagnostic: AS8P190MB1208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iabTHsEqeCD8/PwebH6O/wR4oIW+G3VLACz3V2C+vz4sjluqgejn47YHcexG+R180U2Wy3faFnNE5cZO51lOCO0CT9dz38nhFGf1TjulNyyEWCwzR2/KCKEGQDkh8lF9xaTsBOf19UPicLvvxyE2qUbJPxYfWt9MgqZ4t/DzDd1sil2KcV80AU1J8DlsIioxNXWezVxrULmtKVc5bn5EOD9AvU8UlJVWChSiHKlO3xe4QnbS65pHeXrgVD72r1HjMUbTeHawaYaHNSRLZef8uW/alWSDGDGGH1qOVNP8krG+8yNHAUHJ+Ii19BPsjD+iKANRp8aVE53vzpP/vJRnd5Dji1ePUngHooD0Vt1ZHIB744R5fRHHZWbOu7030NifrZBK7GfjfddzQIy1HpiUK/J/QQvVqgUbk9mlhc1C3KeGEV8D510Jb/YMzASG0hmUVRMPpNJ4r6oAaUtp6l72UmpEm8zHdKry+lBwDzibzF8Qv6R+h6j0CMBylqKfaT2sjNUIkUzNBjYuGjof80XYSOm1EmgRDRRf3rWg3Br9+D5csN47tlshRZQ7tEa3cWfrkQrqV3y/o37W7zZRJo55h60QBGRTxCJrYvkugx3F2nZ3wAPLrLGW7nJRoPSkuP8jxK/FMQTVNgrec3mMjfHo4I9Eu2IS54b+3PX07VlX3H4Ziwk4eh+ztXANLX5ppLqvosnRt2mbV00qocl6Qt4MOZXbxdQ9JyZMQtMkuS/lHhafg0+bvTS7Y91hOMKlOPpt6Sxwf5+TIdmwZ0pG8mZ6kB6CE24/NM5rF+rupeePQI/AsENIcZPY43+RegFbU72p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(6916009)(6506007)(186003)(86362001)(107886003)(52116002)(478600001)(1076003)(6486002)(6512007)(26005)(36756003)(66476007)(8676002)(4326008)(5660300002)(8936002)(316002)(66556008)(2906002)(66946007)(38350700002)(2616005)(6666004)(83380400001)(41300700001)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afvmgdQTkWpOuFbju0gl2iBvzcR77Zjbyq3KVojvQTXuUW+tClXkq/J7becL?=
 =?us-ascii?Q?DJ3j6kpF799rmWfGKgXF0SvjOT+F+n2M8qBU1r48f4PguyA4U8U36As5Uw0O?=
 =?us-ascii?Q?DWBSgFVVeMPlN/U6PgR/G/YdsNIiii99ACk9grDk93Em/6WJpyDo1+LWPumM?=
 =?us-ascii?Q?MYqyjXYd/mmw9HkSRPvgb5CqQat38NEVEINGx1COqyyKFv3nc2lSj1b5YC8f?=
 =?us-ascii?Q?8WuM6JOQhroMxy03LKQNSPWHoC8JBAX95RvnXXRkHFRC6ZuWTfz9oTavWtw5?=
 =?us-ascii?Q?kkB9+Qv5KosE7bn5lHkOBfAeVqroN3447nZ51y5Gy5Onox/loMVLvBxyZO12?=
 =?us-ascii?Q?UQQVIKRF/ynDgvJq7Sj0hLmXU8z78WJx/0wqwJVWy3VFyYsdoVi3pxYCAZXG?=
 =?us-ascii?Q?044BXBX9XnjJazIi5BzuaPGPPTFSVa9s+F9ybIpFnhrcXacFVbwlwSsnB7HJ?=
 =?us-ascii?Q?Dsn18YkcHD6kMunbP45CjjpSwYjyBp8GWEj7IMOpgmezgEmmStksOnYWFvMr?=
 =?us-ascii?Q?oF2qgODHBFi9a0Rkc1cmnKaYH4OyPXTAm94/qXne3chF9QR0tnhMCgiU8Amt?=
 =?us-ascii?Q?VvYUPzVhgRoxzm+BDMe+omkDl3oUCZDm284FXkdJ0DFY2ZeoEvp9XFiKbE33?=
 =?us-ascii?Q?+EP9W1TqnMLOShJ9X50Ig5XJv+RIVxR1N5qy6fByyZscIXyqW3Kd8wy4oq3J?=
 =?us-ascii?Q?owiQ32v7jukYV4EoW/GHHGAiQcOdjZtz+QcLYcq6BjiIIxfUm3avBbmO4h0E?=
 =?us-ascii?Q?I+vk+hAknrOOmuM03IXvsuQNEHExHdkJoHM/4U1hJbmi6K2+b84Va3LZHklw?=
 =?us-ascii?Q?4MTCDbtmQAF2Pi2DFM67nH4pMIH2Zd0Zo21/VqVjzjGNMVYXiQucrs3uGrmB?=
 =?us-ascii?Q?PkCZt7oHWq2XPtobd2vDxFJSgKYdgugccxbMRxiQYlqvcoVocCixbncQ8JKO?=
 =?us-ascii?Q?rLvg5bb6gSOjhgEOomFLnvR2b1D534/tcgxhzj1YuKXLrcKpZ87Lv8eSgtyN?=
 =?us-ascii?Q?lX4zUUAkRObsf1hrGZyAVBIq2ttrlIh3E2LFsCIVJ8pFGh3f4qK+OSqn05Y8?=
 =?us-ascii?Q?Abyl6MtS1OZG9bW6JF7Q6an3vuh+q/6Lkc5kAW6KRwAulIABUg/F+uPNW5Bw?=
 =?us-ascii?Q?ZxikmDVg7HuduMLQf/4paPne1ozepQtsSZ59r4r++Wly/jyHcauoOav8v8mK?=
 =?us-ascii?Q?D6H9IO5GxRwFFab9ZNHi5Yqhmxxj2NxtKVAQ4cCAze+MupIXc45X48xGByiR?=
 =?us-ascii?Q?6Cj6tDe6un2M3j1h+KFw54CGyew0DhT/gpts6t9lxoc2hdZVr9o8zgR4TLs4?=
 =?us-ascii?Q?pXVMdUyBc7Pwwqw/cFecMBjsAJlMTYeVsDZWoC3ZbqaA1Bs7VyezXmsEZ2rD?=
 =?us-ascii?Q?GR5QXc3bWFPHPizBxw0QHrOSA7+5fYG2Pu1n2hB0CI+aUV+0oBvQOddciEx0?=
 =?us-ascii?Q?srdRhgiZNl16lwYYJhyiAPU4orgIpEXcweQ2jLihSyiaR2L+hIkl+Bt3ubSv?=
 =?us-ascii?Q?RRX4Ak/gXgQ3/TKGIRRLNWfxZUDt3K6UJh+YRD1BBs887m2JB2hCyLG6XkJa?=
 =?us-ascii?Q?fMSNM7q98twAg5fFhNWCjpVcUzdU4IZypGzTGY+odIq9os6R59MiwXAclI0S?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 266712d1-0505-4b19-d2d3-08da633080d9
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 11:28:39.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8bA3BbyqlaucnxtkbKnvj9H/lvUMHY1RQK5/cp9wXX8gEKSluKjOeA49dJ0m0PIi35X2tOInx2XSrNsgWvQEt4XVkaluQlpNAdyT3Es7HI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1208
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate flags to make it possible to alter them separately;
Move bridge flags setting logic from HW API level to prestera_main
  where it belongs;
Move bridge flags parsing (and setting using prestera API) to
  prestera_switchdev.c - module responsible for bridge operations
  handling;

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  4 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 54 +------------
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 +-
 .../ethernet/marvell/prestera/prestera_main.c | 15 ++++
 .../marvell/prestera/prestera_switchdev.c     | 79 +++++++++++--------
 5 files changed, 67 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 0bb46eee46b4..cab80e501419 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -331,6 +331,10 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 79fd3cac539d..b00e69fabc6b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1531,7 +1531,7 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1549,7 +1549,7 @@ static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1567,56 +1567,6 @@ static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.param = {
-			.flood = flood,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val)
-{
-	int err;
-
-	if (port->sw->dev->fw_rev.maj <= 2) {
-		if (!(mask & BR_FLOOD))
-			return 0;
-
-		return prestera_hw_port_flood_set_v2(port, val & BR_FLOOD);
-	}
-
-	if (mask & BR_FLOOD) {
-		err = prestera_hw_port_uc_flood_set(port, val & BR_FLOOD);
-		if (err)
-			goto err_uc_flood;
-	}
-
-	if (mask & BR_MCAST_FLOOD) {
-		err = prestera_hw_port_mc_flood_set(port, val & BR_MCAST_FLOOD);
-		if (err)
-			goto err_mc_flood;
-	}
-
-	return 0;
-
-err_mc_flood:
-	prestera_hw_port_mc_flood_set(port, 0);
-err_uc_flood:
-	if (mask & BR_FLOOD)
-		prestera_hw_port_uc_flood_set(port, 0);
-
-	return err;
-}
-
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index aa74f668aa3c..d3fdfe244f87 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -179,8 +179,8 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val);
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..0e8eecbe13e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,21 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn)
+{
+	return prestera_hw_port_learning_set(port, learn);
+}
+
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_uc_flood_set(port, flood);
+}
+
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_mc_flood_set(port, flood);
+}
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index b4599fe4ca8d..7002c35526d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -74,6 +74,39 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static void
+prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
+			     struct prestera_port *port)
+{
+	prestera_port_uc_flood_set(port, false);
+	prestera_port_mc_flood_set(port, false);
+	prestera_port_learning_set(port, false);
+}
+
+static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
+				      struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	prestera_br_port_flags_reset(br_port, port);
+	return err;
+}
+
 static struct prestera_bridge_vlan *
 prestera_bridge_vlan_create(struct prestera_bridge_port *br_port, u16 vid)
 {
@@ -461,19 +494,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		goto err_port_flood_set;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	return 0;
 
-err_port_learning_set:
-err_port_flood_set:
+err_flags2port_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -592,8 +619,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
-	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
+	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -603,26 +629,14 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
-	int err;
 
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags.mask, flags.val);
-	if (err)
-		return err;
-
-	if (flags.mask & BR_LEARNING) {
-		err = prestera_hw_port_learning_set(port,
-						    flags.val & BR_LEARNING);
-		if (err)
-			return err;
-	}
-
-	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
-
-	return 0;
+	br_port->flags &= ~flags.mask;
+	br_port->flags |= flags.val & flags.mask;
+	return prestera_br_port_flags_set(br_port, port);
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -918,14 +932,9 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		return err;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	err = prestera_port_vid_stp_set(port, vid, br_port->stp_state);
 	if (err)
@@ -950,8 +959,8 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_bridge_vlan_get:
 	prestera_port_vid_stp_set(port, vid, BR_STATE_FORWARDING);
 err_port_vid_stp_set:
-	prestera_hw_port_learning_set(port, false);
-err_port_learning_set:
+	prestera_br_port_flags_reset(br_port, port);
+err_flags2port_set:
 	return err;
 }
 
-- 
2.17.1

