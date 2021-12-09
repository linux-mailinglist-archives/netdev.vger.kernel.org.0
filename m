Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7F46F781
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhLIXiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:52 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhLIXiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/KfeW12W/rTlK62wh2HYJFwYbJeCRuPWObps4VKOrZccC5D/8re79QIzAV3i8VaQcw4bY+7KYoWlF87ZOdTna52H2EvhXV49rl5AwsClxxt6Lf4pRBBBpFjE1Ofi1VZS/Uk9rvSEZeQ0BKx6BoJFGVU71TETSghzNsdyGcQtXEmZ8TBK2zMXdO143ZN1bcKPfnSCEfCu+EXVeXj7LnU7FAWkw7VnMmHiq/0eaLFvOwcaXiVBBN8LJ/bOCQL2IBGytxQz3dNfweSzT4sIleOIDGV5j6Po85xVvJ4dTkrl1Dko1PnlICTnUhc64Sbq6PMPzJsgXZ+gyBYMLS4cglEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vfKic7cF2g/1o65f2+5Lrn6MwGHz6mBjTwCxcLxeTw=;
 b=l/Ah7b3z/MVUrjA/ybSsRwYjV9Pb25uwPb5JecuLfd71BSCNYIXsPcns/WrC1KATDZxWx/lTpX0QfB/3hmuIDf+6gFyM8ukriuBBq3sagrqXwyZoF0TixaGccgePdRi5x8rolSeXBfs65nqphf98KR65ijmmH5chnjjMCxgKwI2zr3Ydqyq93w7+pL937V32uxmih4JON/Amc+7GEUsDJ+ovCNKCfAZyZZ2C4h4PMqK0Y8jTEYPEcs175DAlzrbGfhkG6WHOSfnMgnBI9mBkfr8Dph8jRu09DKOYBqAjMkdeiLz8PhPNhoYhiyKflxlNr7yIP+UoiHfWadlPdIUB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vfKic7cF2g/1o65f2+5Lrn6MwGHz6mBjTwCxcLxeTw=;
 b=AgpWQPidKcmO6L+pAtJ0RJA8YLzZgoeb0ICJQoz8jBM5SwyG5xaVL7kLvBNX2VuZc7RwkXMrpNrPi1/WpJLIPv19sifZqpEwJ/syAxVFfIalUGTo2ti+SjkBgbJsq2aEoHuvmo37Uit8maa/PaY4sT9FuVbtvLWNoi9N1iE99Rc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:11 +0000
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
Subject: [PATCH v2 net-next 03/11] net: dsa: sja1105: let deferred packets time out when sent to ports going down
Date:   Fri, 10 Dec 2021 01:34:39 +0200
Message-Id: <20211209233447.336331-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78b078ba-d43d-46c4-cdfd-08d9bb6c8b1e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408A871402B754A127D1625E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBH3xktAVxbO93AKitYDe0TBPhC3rqU2QBbjIccqdQiKJSo29sr20lIyTccCMCzSXzZ6OzGGONtW+t2NfOfpD4z2ym+swNkRnlNmqecHTJJOCKsDAtpwU2NARpiLj8bsk9T4yr7lxsCJ+oBquWx+4t2XEIEIUOFIN9xY2ngjybKv8IX75+tHcTiq2d4iRMjJrMSxrwXtIftq6NCjDegtpPwwDRavLsB94s3k2ImrxdA35uhegO4tcRFmH7Xz8sAWTGmD7chYqVMaBzm9yZlz5TBcTO0/KGUNG9ATOQwqMMygIvouBk4H4qAfLjqO9qZae1WvDjZCfa/mP9Wah64+cUGDAaoOWKpGOO4Yzf213Lb7VhN4gJ+UtKNbd8D1hkFn3crvxQ/+ZWiKwOBoTal0HQbTit3oVgs3bp719BmW+sC8Cjr3oQth2IAWN3+HfTQYPPH4z7jYB2hBLLJOCYm8Ia30NKkJdVTlzSpa4bQ3XXkqjn4dsxkLbclaXR1A455LOxitH5Vt/X+5yV+j98NDjzQ7UWx6ABd944bNA8JQGC63sgT91ctxiZcx/yP6UPpGrr7wbbW8aEvF107dOyB1Evb3TlBqjUmf7OtBJ9MHJuH+EjBCnpILBPRRKwoHj7fKws0PrH+cvM4b+aC+V+4kiSULRD07k32+gqtM8ycPolckZDHWXja6Hv4Xtx/cnZVz6goDE8HHAtDEa3mt9D/5bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HWN6rgupgmQZdhm7A6FNMtKNcNaW3U1KPd/HH4PLihLV3TSxQR9K38pwX2cu?=
 =?us-ascii?Q?Y/7EIr4XzSG1gFn3CxyOE2Dk5nCrOcDz2JVoAWnsnhV031dcsxCxFLlbBDsa?=
 =?us-ascii?Q?4naP4dGXzLoJRvb9u8hl5pJBChAab2Q/Y2+tFnYKZ4O3fe6rtQ0C2GlBrZ7y?=
 =?us-ascii?Q?lYnwBeE4USvWFns/6xrC+nhZg4JL4lMXSfmVIIddZpKBVvjtQVgcnUsfi52d?=
 =?us-ascii?Q?WqQxhYziFELutK7EcaYsQ2yqgRbOdbfAp8sFnT5y6ydSp/ZGc/tIpXGfXYTW?=
 =?us-ascii?Q?7021N/W1PGtFEyobZf+4AwTxgYI6yZ5ZCpS1rXZkDxUPbefV/7L3BAe+lR9d?=
 =?us-ascii?Q?cIC9JafIOFoLXXpY+1/m7SQA/zwv2hPnkYka/dn3HIGnYQPZU9paBS5Cxe+T?=
 =?us-ascii?Q?rrXx45S+y5DO4vvEdevXBMjcULcs/eXuMKn6qIP09UZYh3+1DV7wkHTUhRlk?=
 =?us-ascii?Q?EVGGO/s9OM0THR6w9hAMlTU21ptFkvrQOzaX0ItLhOhk4FUEDICM8Jk8gG51?=
 =?us-ascii?Q?lIAIhtpXGBsokepbKg+BinXJl7yhs3mYfGanU/Vd1FCZgcSEZefTC+W1mycC?=
 =?us-ascii?Q?g6sY2A8s7R9dO2RXHvO1shFXSPpWazGYdk+73HVTAWsWAhnaWNBx9aAOh5OE?=
 =?us-ascii?Q?18w3Th0jycBl/SxbB6UWfOVH2Q9Si7Ejp2jqUzAVjo6J04RqoM6DnkinoF4B?=
 =?us-ascii?Q?uzcjFI1/KDQSlHaTU+GNgeZhayEa44HmUTyHuQ3mcvc6yYeSm9328ggc60rl?=
 =?us-ascii?Q?hGXD56AkAGO/VRPJ2ke32mtctD0Ej4AOpQfCppED6gnw7RnMYdSXvOVh3oXo?=
 =?us-ascii?Q?o6FDkguxRHPrISFhnPljUF5yzX5HqhJOi/Xzg1C8mPI/oiXlOgl6Zr7/W2Sh?=
 =?us-ascii?Q?lDcJGO3mipQLsrG+v8G/1Jwd6dxSV6OP7nFPAy1HdcoQ7WeqI4QYAMcwW/09?=
 =?us-ascii?Q?r3jHoNOYM6HEMu2Tqgd1S5MOGPRl/OwLHLbOgw1Cqx/WiGK0WDDUYaN45BYz?=
 =?us-ascii?Q?juY2c0KU+0Bb4gPY3a76z6M3BnNVdcHZswHIgwkUJ4b/Pa+WG5rkMxzNqfmL?=
 =?us-ascii?Q?aM0SM0PqJGcC2TPorIrF332b/qG1WqvLFJazZ0z+u9T1WNbJionOaCH+ipZY?=
 =?us-ascii?Q?zTC8Ai+d6tde5CLxPZycDlmu0LPVLnVwzAsPMIsmCv2R2/tBIbxgWbVzTD4i?=
 =?us-ascii?Q?jC7WbJqlmn82fHGe2vubXvMtRwPnXLttmQTqwKtX1LKDnmcxBHusfqd98gG7?=
 =?us-ascii?Q?2nB23CK6HzUG2L9+u8XwML/Vbpt2IBBADAIRKS452e2PHY8KfgPZq4v5bfRj?=
 =?us-ascii?Q?v/3mtWFLqX5cn3KTlgnDptlKA1Wq+7R7gQYqAQEQJSuWVIE1ARJIrv07jpFC?=
 =?us-ascii?Q?9Rws1S+wDKW6/AV+z1iUKXhlLyu0eJCZzmGqkH7ay1S/6YbbvVaBLuaZjdB1?=
 =?us-ascii?Q?g9MIf74yrkAmgYKAczbANpbYzYCBbrWFEbgTBrjoqe4BYDWsjv462yOyreVx?=
 =?us-ascii?Q?CrrXZ9vwkO/MkdMhqE3ql7/UArLtsuY9Z7brje26RAdUQoNgdDHUJYy9xJkO?=
 =?us-ascii?Q?lRcTWtBR+HjPQQ88XQIlOozeK06XhL7E2fyaEe0q6CeNoZgdDXSuRdBcfp/j?=
 =?us-ascii?Q?mASOrCZ46+AIIeRFld0JIY8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b078ba-d43d-46c4-cdfd-08d9bb6c8b1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:11.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: po/2mr8JCDm02y3Nf8zAtGI2wchjR8Hw8ZfYdPsFr6hwhlSFJzX+okBw42uR1ghV5uXfvjEqCTHaAtFoBMnNBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
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

