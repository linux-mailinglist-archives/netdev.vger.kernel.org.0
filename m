Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264C046DCA5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhLHUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:37 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239976AbhLHUJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4PLEpho/DI87FVnBcFe+FfhuMUlO29a7OEy16MIoU3i8SKMcDJ1FVcDi2JThzfABsiAJfqQDE0MJhavJDdWJg6EV2sg4LuxU1dh04lZUA9s2TLZ/ph22rIg02AzUHgGfWiG4ZUsYGE6cIxh9c5o/gWSEspdmBepRMmTcW/5ZVaBS20xGPiyU6hdoP7SFm2MdiKBbzey9jIe4eY/03awqfkOiIx4ahL8S1+On3yjFC+XHwsGJh6KfBpxJApmf54SsevOCVTs2PTNYpPxTMLDvat23eQiqzgRpkPekWbaAdOQPR6qeKx6ZG4Ot4zx2clklMEK/5k7QcoXVXHyq0yGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vfKic7cF2g/1o65f2+5Lrn6MwGHz6mBjTwCxcLxeTw=;
 b=YGL09krGVuBT6DxzYhsqrSoz01Z2YOuYcUckuvXR+AioMX1UrxVMGRsV/RqVRBmkXBQuxthAwlgHQ6ObowbSojOgM3msz/fKPGAANiMhlPX679RNMJheBFI33jM5Q5IA5SWWl/Ej6g2SYCgER/+P60o1guIvC7PkgZ0LyCcq9Bqm/b7Mw9GbQgeTDyn+4um8I8oEMZDdO8zPgK1xx1wVinYcvKePKp75CilbcZ8ZnR0A8t/pI9I2I9xMX3mO9jFm5p4/pkvCyb7cYlOtti91PSrRmsgeCOrdI/IR/uTbuLgW9Idsw0uUvhO1H5lYUjodUSugZkMQaUz+sxIKfkVSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vfKic7cF2g/1o65f2+5Lrn6MwGHz6mBjTwCxcLxeTw=;
 b=VT7X8FEyqkLh+IfGDQlZQuHkTT+z+qSFSxJtcVXYCYUMDHI8dloJxlb+RNTbhLSFMsNNm9jQwqAacRaRr/jQ3+dRN5e7maY3vbbFxwYwXmC56bbONh/arkv1PoWRB7kGt+YcqeBbqp+fVGw4J2OTGxvVpkoeAmpL+KDpZ5UMjmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 03/11] net: dsa: sja1105: let deferred packets time out when sent to ports going down
Date:   Wed,  8 Dec 2021 22:04:56 +0200
Message-Id: <20211208200504.3136642-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdbd7c10-0ea0-48d2-4e7e-08d9ba8620f6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB6638313A3720A185E7366F17E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AX4yADT2/8G3Up6ri85MsXa0wgfhIAc4mIXWTtZ/pRNrn3xpBJH3ZmgrVV0tA2AkdfO6UQJf5qnOOv3Vxq4Vqy1uQQv6ZuU1KYHPst5qH7f01YzFIqGd9ovXeIk9Qk6Xn7w3Nl+gzOLWp9FCEv55WhqQAj/aMmTBmC68WvT1lcQNWyrdeMpHNtih06bQhHpakqf+zKlWYyESvCQmpPfcWmHHMRWCUA37a+/BDsPr1xeMvgey1IPG2Sa+8QBZ6ECzWQclFcbVcFO7/UszP6SvxS4pM1Qytw0GjLxLBLLPxShqO7J9DNcHMNDnexXoiZgJWZwB7m/7RrYBmrUGugRVkoPs5jBIovLshv5L9JEMp4zLeNb6q1FBUXQShHGdNZ5Juz3Slef1bRMUl1PYhghfv5zKj1qEpbIFQ3NZfgDeOpIbKWPCloj/g+P4Uhr0VPOCHs9XcZdwbvBl3VKa6qbVZhynP2Rx3PaMWKrXtCCmK0Q805loTklFM/LwV2CjS/iAhNC96+Ho9cou7U/loDkUxaZxu9sL6CwuhZQLa5iVn89lPXgF2PdZOZuRrOTO5z2tinO71CulupVzVcdgzv9Hk8oaaYrRwsZ5AhXDjU/ipfyYdw7b663gopig32ZVLsvgf5iINtQUEEcoDetI0xNIuE9EcJ6iAhckCtEdADqnBknPj+Kn0NkeM/p4bSKh9aBCcmv8zY/qkUw+qz+bWHoA2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EouxPUo1RLNdZXurZcoyIrJXynDy451Rub7DOPiInvyxIf52sf1P32WwI2sg?=
 =?us-ascii?Q?6JrgD7Fp6WF6JJVPYNDpUzvTiw+AtaHU+OlVFjIAQZnnuzut5qnwnHwGjwVw?=
 =?us-ascii?Q?hv3qawOQY66N3KPnmPt5H4SdmzSJp4nRj5PmAKpmAX6ucIis3N+fa5PdJeR+?=
 =?us-ascii?Q?+xJyBR0R9vuzgI4BpQ/WYAyGswliToVmSRxJ0E3xaUs5j6lovzE3kmyUPqGD?=
 =?us-ascii?Q?aii1EfXfA9gXrRY1i2RwosptYP4kvwRHdhH07/kyJN/7E9SGHdVfQX7VqN/7?=
 =?us-ascii?Q?l4+bAfq+unx0DEDAZmlQlwXgqnk6B1TxC2mah5WHM1B5zmmnbZus8leH2+D1?=
 =?us-ascii?Q?qtLrGg1Lbm8rHiZ3zmdjyBVFbVBhQUVgs0wA/kyLCQvJ9YuEWUIuBnX8Hxj/?=
 =?us-ascii?Q?i8SEq+4yr2sfDjiVg8oz3s32pujhzpxY8XqL9//ZjX/nQagogaUia0QE78Sx?=
 =?us-ascii?Q?8Sq7/TtD/NsP3KdQ/tdgWIUfyM9Q3nxk8gFpJlxEyfpnxk43tpHb/pN37ylM?=
 =?us-ascii?Q?aX9YQyHAI3oFWs7m8Vq4wuL4vwptcs3z0BuoVDYtKmoSiosyz/wHhqEcdogY?=
 =?us-ascii?Q?2XksABVQlT974kpxhoxqUFpqQOCMKLv+SECITGdY70GMRTfRmUrnNbzDg+zC?=
 =?us-ascii?Q?xUVmPxjcuO4Foqm7T5dSoX5XK4M9bFH5zjt0Kr7390mO8FU2+9i+qMruxh6j?=
 =?us-ascii?Q?DurpQwjMhpuZakW3KWTcQV8crLPreD0B1z+7El+1ot+MMdGt2JJTz/4XeMJf?=
 =?us-ascii?Q?f8a+l0D3YPyC+qyCr7CvcMQW0dXlUNBq3SCZZhZSOcN4JD83U2dZZMravZpW?=
 =?us-ascii?Q?5QcoaMg+W8u2wlXP5ha5LhUC/x9y/nX2APGWquJ+FGI3ve8b2m+SzowSm3q/?=
 =?us-ascii?Q?fluTxpUc14IctdOBDOqBg+z+dj48ZLc7USQywuXDjPCsXnaASZQAphDxwa2u?=
 =?us-ascii?Q?iRMFM/PsL1fjx13eE/Tq5xNwhcp5iFxQ3Hned83nNgRwEPizqZmQOcv922Ia?=
 =?us-ascii?Q?8nGlG8Y+eGa+c39O1cr7tBlleaPYtrwNeJzikIaG481lKKCHTJPimxjBig5r?=
 =?us-ascii?Q?8aUYyYDWHU2QbMfiZIGlxxm6RpnMyIg303zRF2Fb1TWLpXxkvVdYFfV8KVB1?=
 =?us-ascii?Q?t3nXKyYrQbV+B1Lg+Jflg8O40HdRPTNOETqz+roVghOUQGV5S19iCPPYhEAS?=
 =?us-ascii?Q?IFspu+JMauIABLhaX5M/GtHNQA4opT7EMnNVoonh1vWlWlnjG+0kJ5IJwmPY?=
 =?us-ascii?Q?v6Ik9TYPnFaXJT+lU70h3IvLfP/LyzinvFNyzptQpPDrari6H9aQYTtBFE+C?=
 =?us-ascii?Q?71WCZOZ+9fXRTZQEwhN6X7VziFF64KZBUskcpuOrg5wVK1jOu8ME8xsVGk5Q?=
 =?us-ascii?Q?NxPJKGBP/ZjebNo/ckbY2xvxnkLq36Vp8dXsVG+TfuKPHPuiaN0g83HaKGLY?=
 =?us-ascii?Q?QbwkJk95v42+wiICCqBGh+G+5lbJUSotYn/aDLypcFvPyW+3lQJQ2/asdPRp?=
 =?us-ascii?Q?M01fVFF5Gp+PHo6Hc5pQryisL/7nfY6H3Ynh2NN+Fq/oBAbM8tFYPyAkQ+vw?=
 =?us-ascii?Q?KcJQdJpZmR4LDQNE7BD3mGluzZdqqYPVpzrhTboYuTUI9Bpvtx9MAN4ns0qE?=
 =?us-ascii?Q?H1/6/y2tWpD46stIRB11NuA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdbd7c10-0ea0-48d2-4e7e-08d9ba8620f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:49.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEIf2JV97GapvnWjYIMETOPCfSy8/UGttc9K7wyJNQCj412xkwBW9+JKsmOEJJZ8lLXPo9ZfmZTqpZQih2aOmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is not necessary and complicates the conversion of this driver
to tagger-owned memory. If there is a PTP packet that is sent
concurrently with the port getting disabled, the deferred xmit mechanism
is robust enough to time out when it sees that it hasn't been delivered,
and recovers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index cefde41ce8d6..f7c88da377e4 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2617,18 +2617,6 @@ static int sja1105_prechangeupper(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void sja1105_port_disable(struct dsa_switch *ds, int port)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
-
-	if (!dsa_is_user_port(ds, port))
-		return;
-
-	kthread_cancel_work_sync(&sp->xmit_work);
-	skb_queue_purge(&sp->xmit_queue);
-}
-
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 			     struct sk_buff *skb, bool takets)
 {
@@ -3215,7 +3203,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
-	.port_disable		= sja1105_port_disable,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
-- 
2.25.1

