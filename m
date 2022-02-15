Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96434B780D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbiBORCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242110AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBFD11ACEC
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4v4TXu229VpxXZnWFJj/CHSSKFlGNf29ZsC3fZg8MLeTLTLrHDK6KLGBMzG+M/fsrG8OHUngRbxq+SkINZnRuqxNyASBmjalu7ePOd4pcjBSn5+VsCHOg7pzn8h1U8oeXeR2h0YQQp3qczdVoZzvs5l3Vjv9ONO0i/OujuxIJQKhxNQljSyU4YeZp1LOm3/wE5Lnh1zhd37fG2V2tvlfZpPwKTv74Myv/x0y75VzBXHf5FQGvYcEp8CQdEBZtkhoF0nqtysgePALIyxovqD3M2lN25ZoUqIRn1nVtRBOjCHMZ8GdVHcDnX1b+UAXQuVTMWZueiGf0jLRlZ96wMAPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwexyMKm4GBpDeXKoiUI0X7rXOvuOf8eXnpL2CtnKxo=;
 b=Re69jXL3dvHch2zLDanCMqkSrPVFuAZN1Put7ZS8/hI8r0xGEKACpiQrVflymNe+ZIRJh/l3OEfBuEIDQPbRq4JemZjBn4/cwmcI00a0EISOfqMbt8/HwEJNtDBBCdTWW4/8WzK8klWJoKfnPz3E0N8TdPWEU1skDL7+88clAPq4tz/zA7bYy7uqO3CXWTOsEhlPZOiYyomxv184cge50B5fQswp5D/VgjneN262pKSNKrQrRFYQ1dTdhndrSoC7wCaPieNF+UHI2fNv/TdqaBNqxQTm/XiOU0IGb14lZJONtQTt9MRFaBaSZa/kcTlaUub/kdlGHchvMC9z1bY8gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwexyMKm4GBpDeXKoiUI0X7rXOvuOf8eXnpL2CtnKxo=;
 b=U0TjZsDMk9NIPoC5bfqsLm3CdqNYmo7gatn4fcP68AjuYtRIc/A6lhbd8ro6gBxjtAq7/j2ja53PFn4IM04eHj+kZuFPmitUqo05+Gunahocpj68cghc0b8MRZ+iCtT04aZtOnAexqb6aKknPEKCTCgksKxK7QIut9HBwhFYv94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 06/11] net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of sync()
Date:   Tue, 15 Feb 2022 19:02:13 +0200
Message-Id: <20220215170218.2032432-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 256b28d2-07ab-4145-d258-08d9f0a4f3f5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB534202598668E51F5A470507E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NESxnTqTQ1/pkcfoUZpC1FMHE7S0lBT6ZwE4mDlhnMp7ZNS9AQHysaBsO5FP5b9cRo8Z/lhGNB24WBED8AovuT3GH3tiLGfiLC4yrGxPOXvHUSI/t4+4dnF/uzDSt2ejulL3x2FvT2BZf0nUxUblMOzq/DLS6zmwBWbW6rTQ4nQ3l54TD3VQS8bzhS3KNrfMRAHG9hEl2GHMBpkaLPL5x779M2ihlDsPka9zj9ZZTf20CnoMhDWGaoAU5+Dbp8uPe56iCQPDeTbLZ/cSWApVfQZAty4e5qYxnlHaoatylR9Zx92elywG85817AV2NTVkieY+NgkbWkojOLDkfrdPPoTPjBRNUbuzwPSwT8lmA3SHai+ba0iEwtVCVecfll6Su3U1s551madBJu/FdIigNrtUzPR2TxKcUOmWwz6VDHD7Hs3TtYPypswGm8JSFA6F3aRCph7/QK64cD0/bQvir6ImWNSzPq1XVHyouj7yv0t6ClTYeLMAEWBi7tKGMHd9UJzG2+S8xGsoojGIe50K3QX7Gjo5ViN+/7wmj/KD2RAoWrxfHmiMUuc2phsa+iBRynCE4UFD8sjWQ3ZAMC8d/B8SdZHv0frtUOOlcFakv9znDOwY8hZRDrtKkQ51n/063eot4Adav2bf948JT6GOxXNsVyOhemWpXW0zuBeXTSAnF0eQuNsjkaoOtYIxwiDgWg9noBDSt7RHTeqgyJyMeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Di3M/c2OPaUfDqsoW+YbwFoW+URaLA8K0VvG6UVIGe1FVkH3AEWZPVXdzBMm?=
 =?us-ascii?Q?ovY3rglaITQmboy+nQMI2oQFk+AzEK1rT6rc81sV9J/sHt5wdKXkfGzjGriD?=
 =?us-ascii?Q?z2gXEq0rzm4zsZRBdWbEaA2nPsPA45fIn+p2HUiJ+y/JcRMFoMa9/kcgGK9W?=
 =?us-ascii?Q?iyx7NYfV0z85MJPKS5hZ9ARLTJkeZw4byhGpEW4QCmxFqkX9mNx0hq6iXHZl?=
 =?us-ascii?Q?6VI4ZlJNE0KaIXU97aUzk44dOWwhMf0FGqcibY40f5Tu0tQJHDIkK3MuIern?=
 =?us-ascii?Q?9N2gdGx2pfSsfo7R8W3zSkdpj7ukC5/TVuR5hZwly0ez2ktfHiFVybEpfLlH?=
 =?us-ascii?Q?M9WbcANQuAmkqLwjaBs4g7Xl5Ej8ruNiCCNT+zFn9FlXyJR8QG+WDm1k0c1Z?=
 =?us-ascii?Q?ywtLYHYHeML33z2+zlwGPUCCxw7RyL5CkLD1MOEmBReYzsQMh7lWmJoZQM9M?=
 =?us-ascii?Q?yVIeCT647jDGy3IjLviiQzXhSbwCfBXKs6GwVlix0eSXKX3rdYu07XECu6bc?=
 =?us-ascii?Q?zN+m6WNToUyTK27awB7Dccnk1KIJNIp4BnPSnGWOVOCAZqYkTlEzW4lGmzK4?=
 =?us-ascii?Q?aHZLrjuR0Xvm/xzYvUETTZ7X2yGiuydi3DzgxqoBi1gwps0UJSgkBSZdR1lc?=
 =?us-ascii?Q?d3xT4xFIL1LtExoSL9k8WajBH9fP5GHPhdHUfwRvm5m+joTbhJzwDBIsnXIx?=
 =?us-ascii?Q?lLtqC02JTNQAIWmmEwynAOYVqbl0IS8W/U2d95aUZsbgn0CS89O8BrVJ3Pff?=
 =?us-ascii?Q?8UD9EnkuATt6F/RCBXHDBVjhzPGvtvDrRIv8s2PLFJ5VAlDsU4sxsSbESoX6?=
 =?us-ascii?Q?GaSj5M36gTrD3V83isK8Hx9WSq8w9WfQNxOjBXubHddo+khXThkBAfHE6xSd?=
 =?us-ascii?Q?uijhPOGdbDCxRSW5gg2BYn3QuAdL8EXfvCcSMwCC8K5o+hNQSDGHpdpq2nbQ?=
 =?us-ascii?Q?Y0D+hqMtdDUAkBvUMch34EYTHnMgSiAfsJtxrCfZ70uWTuk8YiSKFy2ZZe7O?=
 =?us-ascii?Q?M6JvXFnzL6ClaMnF8dy0QfPGE9HupeG8x4Ing+hRdCS8V6NJ/WbtNISbQbAS?=
 =?us-ascii?Q?KSvLjQZFBOAHPaWyqhig59p2x1shAWTe2wE130aD3OE51Ws1auAh/EIHkLNS?=
 =?us-ascii?Q?yY0p5xK4Y0ML921ikwIyr9dr0saFxM9ib1tjiguoagdcz5+klh2MMSrCYsTB?=
 =?us-ascii?Q?UEzotnUv2KhnDmtA676eMqFY82ecNVkSBIfC/9uUJs5gbgMRciUAHspino/q?=
 =?us-ascii?Q?hyPXdkkKDoD6cG6+f5NirrBWEcXNCduMw48UJlnJ+jafOB8oivXniLCzVKwx?=
 =?us-ascii?Q?PrQyrGk/Fg5u0eVSeXlWZOWv5QASHZ1nSelZwE1u0WbLdGTxDo9ZyFEb2K4S?=
 =?us-ascii?Q?MGx75diByFWuBHb47iOffyXJsPrMJqYbj6T0pAXP2/bw2YJA6O9E1ZSzfhDo?=
 =?us-ascii?Q?chYdyxK2nz+WjBCS7R8CilDKUmqdAEXCKKfjIOq3DdAYlPjjLZLis6V2Mmyg?=
 =?us-ascii?Q?FU2YAhxnORcBeb0WTP7nHd2nbEm7LVb0wlXZALUoMzPIJL2s1wHBhWGSxaKK?=
 =?us-ascii?Q?6+ycMSPKGM6TXQ5+lsqeIrRB/lv+V/tU6jGtzklDzuuftvuVIzYke7+Qpk41?=
 =?us-ascii?Q?/FN+rwBHPXIGS7BKZZY5OPY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256b28d2-07ab-4145-d258-08d9f0a4f3f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:30.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZ4aYq87IAxjDewPHQfUGmeH2LuN6VTaWh6OQr8acmIB53sOzmdWeC+w8qCfEFJ5rf+7LU6J71UcX9srSTpEGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There may be switchdev drivers that can add/remove a FDB or MDB entry
only as long as the VLAN it's in has been notified and offloaded first.
The nbp_switchdev_sync_objs() method satisfies this requirement on
addition, but nbp_switchdev_unsync_objs() first deletes VLANs, then
deletes MDBs and FDBs. Reverse the order of the function calls to cater
to this requirement.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new

 net/bridge/br_switchdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index fb5115387d82..b7c13f8cfce5 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -707,11 +707,11 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 	struct net_device *br_dev = p->br->dev;
 	struct net_device *dev = p->dev;
 
-	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
 
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
+	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

