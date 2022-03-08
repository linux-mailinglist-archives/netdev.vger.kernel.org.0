Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACE34D1323
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345287AbiCHJQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344104AbiCHJQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:29 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA0E4091D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erZtnPWeVwQ8Tr1vMbyWdqIxexZQRoG0eXS3Wp27SWkPXH2ZtXNCcB3hYDyBR7nrvpZd1xGa+vDGHSa6Ww7jmBjci7Zhjumg7uEDqPmxf8tiES6FoVKLL4YJpSiildLdU0jWot8ZTpIKgl7ZcBYr9OdDeHCe8YaNNyZSyvpaf6cNm8z2SclvD1+B0WKbhFlpVtlqYEtR0OzjMSOwofUPhs6qS5OR8Avawt7nGLcvnRChVoDVW10E/b4uTOtUtPs4sYaNSy6t3DSa2e4f/GyX9Y+n7HfEAmSWZmKhBPTc4owtQvM+0kqSR7D9snGc2ibXklq186MKMlKgYHoi6AW57w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnZ4JYKtp7FvriArNCrv6/fkUzIXprY2OsWXnaQOG1E=;
 b=W4GoCG2sZAWLOje6hUOG9AQVzX0vTaq+Ees99x27dk00eW/5edZ9WHFYuNECPFStkTPQ65Y9+ldh1GsoS20QSXt0CfxhadmAvielRJZl5UG4LPPddnGL+d1VIlOBcc7JjnIdcgTnFOoSb29EVCHYHX6kN/BLfbkOQ7LjnJLpbjT5fzNwuS1ivMTFDCTi8jkABFuLYByQpwoOHzGwZvWUtAvlYn+yJciUYylEpCSYXAOViL1HRT8crZJjxlNB0K1lppQqBg0u9mm14B0KJbk7lpY7sEAXvmk5yXnAaKGrN1UGXD68Wh3bwY5lUL7i38VzD4VYZlZGgOdYyuvWu+GMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnZ4JYKtp7FvriArNCrv6/fkUzIXprY2OsWXnaQOG1E=;
 b=UKCOInPicjIXOT+z9/3o1tm8J4LZXTUqKzaFN46DEUh6DeXtddvGLJmOcxbDkoVf26oVTv17H2u1yZsmGHvGFH7EWKSVznKIJjWfFt4Q4LggZdJN4SreKY8SQSOTaz5aBD/NPNMHt9N2eROhRmWdOQWnU9cKzgjhNlElS6tAGbw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4243.eurprd04.prod.outlook.com (2603:10a6:208:66::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 09:15:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 1/6] net: dsa: warn if port lists aren't empty in dsa_port_teardown
Date:   Tue,  8 Mar 2022 11:15:10 +0200
Message-Id: <20220308091515.4134313-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 588cd0dd-36e1-4151-eab6-08da00e42ff0
X-MS-TrafficTypeDiagnostic: AM0PR04MB4243:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB424360A71AC28D3AB54664D9E0099@AM0PR04MB4243.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLxkX9Nd2V+6OjeXgJI6ggyGn+hy8Jjo4L5+hgi7APtLZv5dzf7+zTnHRUWXsCNRVDFUl53wOjvPO7VFo9YpRa2Slxsv/fw34IsSAAHc1oJoxdw78sVsWRy3ZC8f6WdufE/W+nVxMRfRyAI3NIpfZgc7gNEPOIKNkyJ81pVPN+oDFQajGXrYtM/WjFo29jl3dv+QI7SDGaBOQg9xYv66TTS0AWOqqpdtt1TprUWzXp+3T8wUP2ST5YwzTBwJjRxnWzfPn5r8TVfIrzS5u/VCNPCLmcqN6RphXGpCj0wdzOk8yb/XwLb3bstJz4LLCzFwDNVYjI493AvbE+06FH5cwW87JXhlD/kdmdQ3UeLEWvu6nE2uWbAdymwCKHInj8PsXQdUtUWMUsLRUCMqvyv8lqpioteYlHgm4NRh9w7VXLnUNYYhjvlQrdwVYT7OMbIWX61CDjGN/PG59WOf7ySeybR/NalgShneoNPIBOyqZjjjNpTegVYfXajZxZrjupEk5b3Cc4c4wVsFSidVcZLeIQezqwWIL94Ww6IgEvi3Aj5E0/qh0LxFoCvmox7uWItO4Byupl+FmZ4jAJ+b3ZTZX9MfMwFdfezuDaEGPjepxArj6F18BuTb2PUGQLb+tBGiOMlXd9q72nDTMudOuX1TIyGNpXe6m8eiZy42nH7hbG/5nvu+mTDt/AQ4MPfa84MGVXIC8ERqvcK7/HeyPWLX2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(498600001)(8936002)(7416002)(5660300002)(6666004)(6512007)(6506007)(38350700002)(86362001)(38100700002)(2906002)(4326008)(36756003)(8676002)(52116002)(6916009)(83380400001)(186003)(26005)(54906003)(2616005)(1076003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SsoksN1OtD1SNMHnZzlkGhAxKnVdgYqWMNb7jLzkgJawXxejUFmm3X4DQzCy?=
 =?us-ascii?Q?ZrlFI0V919fQijCVN0DnVG0QuDjGyFyF6T+n+KzAwHrBT1WG0bNI7cI1g041?=
 =?us-ascii?Q?nG0vQ4a333L4MLc3y1Ya6Dw6xMFuvERFqRFZwd5bssion8LHy156Nw44ChZq?=
 =?us-ascii?Q?U5Ql24AKOolHvOVjsHSS1H/NkoziB2yrL7c6zTYHsegrKCIikz+65rfj6iIT?=
 =?us-ascii?Q?ZfkXuHEEC/v9MRw2+fcVpHe9PQLxXAEotJW1oBwS2tQM2ksPnC1OFZVSRd8k?=
 =?us-ascii?Q?VOQugw84Fd5WEEko1uzZEv0ip89t7DMQM+W5zDd3vPQMJhvHVjiHFnBNLMU+?=
 =?us-ascii?Q?3WtFU4jx9iJ4CTL1v+1vKAZPAEEh2zAaO6l7mseG8ifhloG4gSV6AWtdz9H0?=
 =?us-ascii?Q?Ns2HcAXEk6ukYeX8HpfcanmiZoECvXMH3dgIuyc4MrsOyk0oJSrUMS9v0smA?=
 =?us-ascii?Q?mAa9ZjAGUwerkDeAcpXZFH5rfv6Wts/DBtTbT8JcN22/Qz+vRfdXJMt5x1Ic?=
 =?us-ascii?Q?CnX2ure4JPVwxh648oW9LzImoVtcqh5/3YkpdWaPCRwRowt2dOPYPfio7Oms?=
 =?us-ascii?Q?lkhPUJ2OhRo+1Gyz1jJQfRkAe6dWfbLUeeEx3aIBNghTt4MRshyU9sh3Aa45?=
 =?us-ascii?Q?D0H0hKnI+qUmIDOTyljvGqgIeTjOeoKDNt3XoN5FiudP1SxDe/i/CWPQjjGZ?=
 =?us-ascii?Q?KUCartpLHis1BVnidCT4ekq2835WNFTAQhXUmUZ2A2pzphrW5/ypYv4LtI+R?=
 =?us-ascii?Q?hZIp7FTp9HK96k9qFwAVbArL9CxUNqDaz729b8VbzoLWCe332E5mApNckrVs?=
 =?us-ascii?Q?OQEHAaH3VnkMU6pU5GJoKxd0pIXVAFjvJ7eQzQwxxD1wxHthVfWPJnWbFoKJ?=
 =?us-ascii?Q?RbeA4T3l2s1+tQOtd5YbegpujuOMEspNmOZH18vCjX31RMoAbipPGb/q5nmi?=
 =?us-ascii?Q?O0bFmMgrLkwGcJogUDBiBiHWac4xF1JwaOngIw8ZV3VzmO7N5YyafOgcIL0G?=
 =?us-ascii?Q?4WYRK3NADLl/n93XP43Tmm0o2xmh56rS5bRjPfwuHRZuSH9EfZIaLODHVhVm?=
 =?us-ascii?Q?OyJQ3CefJP3gLFq5q6z0S1a23YuVUdip9fGFdBOM7CXOCc0SLSs2kikguO9p?=
 =?us-ascii?Q?FIKdcP9FBUqPucFVp5bFXe/U68N93Z8S0nGCVJBRFfpKKC0ETTfGdZeZCqXj?=
 =?us-ascii?Q?pGPqD2PT8ll8oRuhESzWBraFmmIVA5+e59DHw2gl9/w0uTeqfHZe30pwmXA8?=
 =?us-ascii?Q?AR34Z525fM2gPUYA85jt0os/QnBLCOP1LwYD8IPo/u3iKh6X48kh41FfgqgJ?=
 =?us-ascii?Q?r6Kqpxvs490ViSB8Sf9UmgcKjjnSJoXQHihS20VS2xQSeoCDv/FRds9RkKZX?=
 =?us-ascii?Q?OimSfC26Yir6WcnLxxGE3/etnK+YfD8n6LuOfwr8GtZqzrrD5FsM61/LBFmO?=
 =?us-ascii?Q?XJ2U8f8v1CJMaJDb/fJNpD8X8DYGuugGhjgsOISfm4I+MrNN+DQAE6AsyUm7?=
 =?us-ascii?Q?hRIcJeKrdlTMOz9/3xeYyYmTu+jXOLFDo4cGKvP83r3m7Bv1TIOkXGie4Jb4?=
 =?us-ascii?Q?qsDZf10mfGxYQLzO7nu2GeAvzyvka2ecpWYG09a/QOJl+1t3N/AFXOAkpMfa?=
 =?us-ascii?Q?qHhv/L3exOiWOpnwiD5ngd8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588cd0dd-36e1-4151-eab6-08da00e42ff0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:28.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXlRaIEkmLLmroOa/jAqUVpF/YJ6fy4cTPSrCCG+D0H5GHsCDNFeLwyzWL99sUAKZACEJEJnMidITyrQM3yHCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4243
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been recent work towards matching each switchdev object
addition with a corresponding deletion.

Therefore, having elements in the fdbs, mdbs, vlans lists at the time of
a shared (DSA, CPU) port's teardown is indicative of a bug somewhere
else, and not something that is to be expected.

We shouldn't try to silently paper over that. Instead, print a warning
and a stack trace.

This change is a prerequisite for moving the initialization/teardown of
these lists. Make it clear that clearing the lists isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index afea4f7a41c0..396ea0b4291a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -568,9 +568,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch *ds = dp->ds;
-	struct dsa_mac_addr *a, *tmp;
 	struct net_device *slave;
-	struct dsa_vlan *v, *n;
 
 	if (!dp->setup)
 		return;
@@ -601,20 +599,9 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
-	list_for_each_entry_safe(a, tmp, &dp->fdbs, list) {
-		list_del(&a->list);
-		kfree(a);
-	}
-
-	list_for_each_entry_safe(a, tmp, &dp->mdbs, list) {
-		list_del(&a->list);
-		kfree(a);
-	}
-
-	list_for_each_entry_safe(v, n, &dp->vlans, list) {
-		list_del(&v->list);
-		kfree(v);
-	}
+	WARN_ON(!list_empty(&dp->fdbs));
+	WARN_ON(!list_empty(&dp->mdbs));
+	WARN_ON(!list_empty(&dp->vlans));
 
 	dp->setup = false;
 }
-- 
2.25.1

