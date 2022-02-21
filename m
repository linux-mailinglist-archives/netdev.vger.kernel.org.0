Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0494BEC91
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbiBUVYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiBUVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AE012763
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMEwzPbp8OwX65TVd1kW8MnGxYk61yErQ2OcI5Grp3IZ/5lw2Wrr89OTHNKTzuL7I2GhXmOogwRnBRq9bAPooaNHvtlqr5AiyjHQptYeSS9mR2qg+Kr2zCBywJIY4OGOYqdPbjMfYnWBhOvpln4ubAn9CMDYrcMHwuENo8CZzqAr9Pa1pNx9GWwNyrdKwZJRyVd+bKlEdbawGPLRSzVnxXJX6o7clLcAi7SNcmQMcMDH1FJDxHvOW3/ELolA1iORJa9LBeW7i3J4nSh5kA3PytAiiK2fAWNJ3OOk6ZweyZ1BQlE7t1VbZRinE5Ztrv1mz1iSo26HpQXrpX1wPocBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8O5Ng/0oPlcW4Nhw9gvJL3Pjx0JHBB0P7tpRaUt6OsA=;
 b=hqd4ayHx4ctVJ9vsCHNho2F4RlH1m5qDP5r34TEMz0UGw4EMAvxTF99E8q/RzkEkIpL2jvPvP7Sz9MhZ4tlOcpE1ASbxF77J4LlcM/pOQWpSXGydmoasXo1YZnh0Uz+WiZoI8WkbLTRiQEv7Dcr6KNynVu+fRifXkGlfGNh+dF7t9GJ0xIxI+Rk3AnbPRy1t0j7sTA+xYpjpXV++59xFjv6cjKNeQlUwHqjkKyYW6JTufgln9g6QIwhWO5HFC449pMaLminEUfAb8jOOWjiSnAqkD6ZbeWVKxkb1pIOvg8dRCyspouervZ9ZvAEu/1lWMAAwh/3VoZCTKkAfZmvOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O5Ng/0oPlcW4Nhw9gvJL3Pjx0JHBB0P7tpRaUt6OsA=;
 b=IYzmaRdixbbRtuMh8TzxLe4Y8K85MjLwmfBEE+IAnbCJsJuq6QFNXooIu+4IaMAUVAXNUzViEb3c8sBVtlMcMB9VG+UKdLdXOcbA1NXZxp7VNvuscRIrpwts2oivYozT8KjZYC0m8vngnyjRXQ0JpWZ2HTuKCwuZ3gRvY/jCyiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 09/11] net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
Date:   Mon, 21 Feb 2022 23:23:35 +0200
Message-Id: <20220221212337.2034956-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43e91de7-3c8e-4cc9-3b5e-08d9f58082a1
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB56456798E71EBCDA66EC315BE03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ffP3Eu5hzhkxomjHWxo5gnGQEvqFjbXGzVBoYrM3aTq/kC3vTP4kjOtgIjcoQpvPgms8OOqmWg5EcZ2Ca77rW22Ghrvm0b92oHQoHqSMu3EP/DlQQAUotAUeDhSNMpjX2eXV3gw7Z2BjIAvKCtjdwbCm2yqmdlHg9MaIiPiFWQonBfkEYrO17gWgf1xt0lf0EjIw54PKBDtglUBNMwrSQgJxn66voRPkGvoladFkA1hVICbysg0jOGy8FBufZMx59sTuWz3K0ekatI3F9HGU91FEm8SUcgp70h38nJlqKggjl3lb2Za4UZ1cSDbtYFvTPZPybALB60WhNP+5dVf+0BT+w0fM2u2EaApdwkyalKTK3a+5LMNLfVdBmmSXGb88vRAIRVsIp5t7jI/Fx4c95P/i4j7oruylHhJSmAD0yLtO/00Yp8NZd6CTYcGG+AJzOXTFe3V7dm27ZJH6gckKMKqUgUlIgGHVIVmkf/Ksr0ZOlbTroCd4RFK9vC7S5OCKJZKX2HygtLh69ASMCMhZI43jb2Lzi78IIFI3suq/no5BRXbceSRzlUZHdzSNk4Tqp9b+uo9nDQ3gC58TezXCVSF/ykAp5mbHztyzNU9iWfbPq+XzrGiWa3pv5fML5uPs2QYLrohR3xCD56GtuZ4/tpad9YOC5hCYc4+aPlxZkEnvi/mTs3Q8uQ1WsR1HT8SWzkVgn8SAH95KioLhxAMfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?inhHVP2keX8zT9NgcNa5fWMMKpQ+KGYcxVHitBWsGJvcsWGhpfXa20n3VYdk?=
 =?us-ascii?Q?lvgBP7LgvMmDMJ3RI1+8mQJgbSCgjPZUDJyoQvVRGMg9iGPssHZ2CzG+Z1p+?=
 =?us-ascii?Q?uUE3ItU/W4CYg54gWd8BLZIYIKYdLdH9/SSNGX8+E3PAlcp/HcXoMsRDvIre?=
 =?us-ascii?Q?JFwjZThowxgRc7nIt5960mXSNm8/AazyvfCW1xO0bLLQ2A0R0tRuT7+KOmof?=
 =?us-ascii?Q?Sc//ULqfFv98/Ss4E4lpsrdmj3SFRshrHqONJ+K2O5a7swMx+22vnbHBtW1u?=
 =?us-ascii?Q?s94+JLncxHHxSPuNevwgaLDLGa6r2kW4MIKSIUDM/Yn615sat3UM3Qq4bCZr?=
 =?us-ascii?Q?1cil5AUWRs9FO4I01VvoIypfuHRQxHDlqkEBvPWNPLEYK6xE+DHl5h9p4j0p?=
 =?us-ascii?Q?2Av+U2uwTKHZtXts3YhEzRW5CC8t2QvBu25A+0AjckViMJ1n4XPvgUCt4Soz?=
 =?us-ascii?Q?Vvql0wwDaPJm7D1QjN7Pc+bdudxxlOJRjHQoVlLy/qOg5dz/rB0UWWVnLnvC?=
 =?us-ascii?Q?URaLkBgzvWxpcaiU/9zC8DXFtQ7+hMMK9+poOetuottWNTXuUshQlGV/sLqC?=
 =?us-ascii?Q?+RQGUwcQwlNkVYKu50E5fy28psyCzEbscTmKnj49JRInPLBC4zZgU29NJtN3?=
 =?us-ascii?Q?9bKW27xTioGEGpTCpOJT+42G0eUPFOc04X1HaiFxqr0wZ5icGRvbn43S0zUv?=
 =?us-ascii?Q?9LJPxEbq2QOs1dFyWbYOUqtgYlpQz5Z3L59p3fpPeAZBEo971lAP8P/9Z8C0?=
 =?us-ascii?Q?p//f9piwHH+h1h7+R5BleI6n1Hedu1DiHLhYXEkXxVsCiKZT3fIHFOIZw967?=
 =?us-ascii?Q?dSlbxNlig0CsimD6AR8GuEEWoj+7bBjsTyBlfVMw4ROQs2lywT8hcKjEhTfR?=
 =?us-ascii?Q?Eedsh3HWWMGhUYAWPTgo6v+w+gzBfzL0vpjYE607qTkYw0UuRS53W0qxQ/i+?=
 =?us-ascii?Q?9xVVRh+scjW14gY5yi6XWNOvecSKly5AOLrmeRqkNLCBfpRLCQFWEVNGKfRr?=
 =?us-ascii?Q?5Q1SNor5y+9sWMHz3iz57aYTrQA6pms9pJuHtdlPOGy4XNPPzRfwHXi/vkzs?=
 =?us-ascii?Q?uZRSKGjJcKxz00WsR8kaxHH8FwBQ5cYRBs895H7ZR1qFG686ZBL5YOVqEIEB?=
 =?us-ascii?Q?NX0apmTR11jqXDS+PKF2rZ1d+4X6/Lb/Qem0LlspdT9MBsnIOTRpvRNITsJx?=
 =?us-ascii?Q?2gcRR00vfIet8NMPSCl2fdBrIPG4t6yGKuKJb9qhpDh0nr7XSj6HhTYdKWL7?=
 =?us-ascii?Q?+mWgiIIbjq+nJBFFShfIFHoCnr3MA+QIo3DTMQhmBkHe6j83TDLfrRwS1euW?=
 =?us-ascii?Q?nMr5zGJu54G3MkaiDBYd/fGtWl6izEw38pHI+1/tLyH9dYw9SrngyLC0XoOu?=
 =?us-ascii?Q?0v5nLLF0ztFEfoadbj4ao5xKBlYl8ZdRzhQMwPpxjrM90Urfoz2oJP6YoXG8?=
 =?us-ascii?Q?ORY7dYoQSYam5bahyovQdorCCrzpaQTiFZrW42XYpnCFjhHoV98qruu6h2NF?=
 =?us-ascii?Q?GQMC2KzcAun5XZ5th8ybVgdrke/BiU+IrSQwBhttAYKs+C4nQkMNsP7im0ir?=
 =?us-ascii?Q?KJFFULm8Vx3n7oKOOSTH4Rni7GuEEpK3dJmyrgoWwwMHzdm+ldF1HM4fuayS?=
 =?us-ascii?Q?ws5r1k4cxAtJ4T4h9sxCelU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e91de7-3c8e-4cc9-3b5e-08d9f58082a1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:14.8671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHPeG1uJSyDwWlrQvyxZztSw9BNoLFF0rVHVSx5vLLRKEnhta8xHDWHYz8morDSfPC19XzwiiJ4huOO0l2Vu6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switchdev_handle_fdb_event_to_device() replicates a FDB event
emitted for the bridge or for a LAG port and DSA offloads that, we
should notify back to switchdev that the FDB entry on the original
device is what was offloaded, not on the DSA slave devices that the
event is replicated on.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none

 net/dsa/dsa_priv.h | 1 +
 net/dsa/slave.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f35b7a1496e1..f2364c5adc04 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -120,6 +120,7 @@ struct dsa_notifier_master_state_info {
 
 struct dsa_switchdev_event_work {
 	struct net_device *dev;
+	struct net_device *orig_dev;
 	struct work_struct work;
 	unsigned long event;
 	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7eb972691ce9..4aeb3e092dd6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2378,7 +2378,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 switchdev_work->dev, &info.info, NULL);
+				 switchdev_work->orig_dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
@@ -2495,6 +2495,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
+	switchdev_work->orig_dev = orig_dev;
 
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
-- 
2.25.1

