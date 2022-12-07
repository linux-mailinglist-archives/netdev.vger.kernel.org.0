Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A564B645ACD
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLGNYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLGNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:24:18 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2067.outbound.protection.outlook.com [40.107.6.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A60275D5;
        Wed,  7 Dec 2022 05:24:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWN1Kx2UUuC9Mv6Z2XUx6ACaUHVUmXxjwThwz+HuuXyYeLOl8VTZ+8bsQHnbVXlGuSAlEwTDfMjerf9B9CB95bT8Y3QHCdcoPpX14v8ZkQL8jQD6IykCjdE0n69RmQRv6kJDZAhY1BJ5ZegCD62L7LtcJsh19Sectb0az8GOeYkrA9xvCRTzY8ZNVTImz/P5sYc5uTXsU965/YWvRdLlUgLRk2WhGgL8SOO/2OhA+OGL9iBo5hhlmywUMxHfBozf8Sr7QmGPZkTDw4bi1RRo2X60d1fcJJt0EToTRmCBjA8ZKS4TOW1VGwxLA7GG+X53GlQTODPHgxYTcwGyAFGQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CY5tFP91/Q3CSUI6if6M1GwyXKLj9bscrMh418YQ1Y=;
 b=E4vElPwBqlUmTX/u7x1rVuJShMZi8uMxB2E5r/Seg1ugXOr/4WdjNoLg1dI/PHHQvYvFkbLeo5EOxPIgMlvK5eOEcmWtZGNL96nfI0KGvutcWv2zQSyyL0nGZbEcAuOB2txTpiat2KZI3KmYa0KP5bH7b3Yp6m/KWOSY75+qK3ka0eaQG/dl031VQoBhmvkFxZe5I3hvnl8MO61tYdnrZ7hnI9fPBIKz8Kx0S9pyWjjKx2R0cn/gUNgOt0iFb3ZO56+1MBf04tfG4jTlQ4+yXNIo2hV95IKeFrYGDdKPUfcDQarxQvtpjgg2g4MqqzBX7YCLccUoTzlNYjGXrUkBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CY5tFP91/Q3CSUI6if6M1GwyXKLj9bscrMh418YQ1Y=;
 b=B4ZhLHsxB8+M9h/kEdjvK/Nqz/v/7Au8lDlQFaYcagfrWaQsWY7qzNJyKVXTecgoRJpJw/2T2N/poSg0tGSoX80kBFwW2XSO1zwCxwNM3OUl0RIs7z3smrjxR5IAIXOFZ7VHyOGQcs9dwjedPEarsKYpwkj1TJJyQG6gk9lsevw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM8PR04MB8002.eurprd04.prod.outlook.com (2603:10a6:20b:247::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Wed, 7 Dec
 2022 13:24:11 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9%8]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 13:24:11 +0000
From:   "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH RESEND v2] net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()
Date:   Wed,  7 Dec 2022 15:23:47 +0200
Message-Id: <20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AM8PR04MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: d8334862-627d-448d-a992-08dad8565391
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ACoLX8H1Jdn9iMBH1R8x4oO1HHY69Y2/bHiaThsL+ctGhc0RyOsub/UpCj7leBMu8vmRHNtOgTRhcAJ1/li5h4djt70X8UAnOSdNbiC/2ujbemjHgV6a2dwKGZ1tWyM/J1QbuYaSp1ezY0DIvHy4xuqtb2sQhGqK7sMFuhWGqmHPk5tVGzvd7FRit8kgJZYrzR5qrXaCwcB4s3DIQTrpffNa8DbPxhNeXdJ0UeW4BQjV/lckD82r+LAnJxB8LiIrftJmYp9ZvH7i0ZW/0qZxh01cZgtDI3NlOQdbNbH5g93HBDJbXn7EG5CN1Var67uCbnFIZUycfm+zyIT0li4lQjtV8dwsH/Xvs/4gRU3YByKqVxHmJtVTxP9ugWDGFNk49tlgtOWzXRLTTfYIw+ci0ty8cycffVV2dQKgfouF5tFNkwTQTLk9r556JiwndX8MBJlTXoy8HK/iqpseTbUOP4QroZdX5MyFYwqAlXndXRREjRkywMhGtQk0oycnzqO3h5HvzarpfoJ1aHLupn0Is7LhomUVWQfjVbHj74eX8X2VelZ9r7eEWH+Vrh+dHQMTwUP336onnhjsqstuuETlCU9dgARxJoC/5VXDoBT9J5h2lYtGLbdJIn+etxEufUjFwNpmfW0sG9XvGVrNlSfvhed80LZtj+FlI7ARTyaAa9zob0q3N1wK9rkiFlIwq4QW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(86362001)(4326008)(2906002)(8936002)(38100700002)(83380400001)(5660300002)(66556008)(2616005)(1076003)(316002)(66946007)(186003)(66476007)(8676002)(38350700002)(6486002)(478600001)(41300700001)(6666004)(6506007)(26005)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxXzJQlOBpWlcqYwprv7gl9TXj7m4KEWdiaMqu6V+wc/N6eINabj8fhhLqtr?=
 =?us-ascii?Q?O+sIReDGXi4HRrqqMR0/boXuT4oERTZgNA9p7aR4NrCdhxNH+HK2vKv0/zt3?=
 =?us-ascii?Q?qzVjDDHmA1WIv+O5fppqYWmYPs1Tpbn3QTKiXUTIa+PC+SakqjRRNd/janKE?=
 =?us-ascii?Q?crIQ53OsYpCZFIAMMkJEalLNzWIjLSiPRLa/ibkYVgaTr+mbflI2pa81z0yp?=
 =?us-ascii?Q?JqJM6ePbYR8RJyBkcGxAp+fDZciimMUlpqlQPa/bueh4AMp5o2J8QYMFBQcX?=
 =?us-ascii?Q?04GaDCikzPLtsv+JjMKbijAb6csm8mY3rgHQ5DNpJJnX2ur39X/XJpYzhZbE?=
 =?us-ascii?Q?RHzNRjDh5BshlAlPqvxRP/XimvwPvqw/m/jGUtVenAuyCjGmxS3ETjVgDu0q?=
 =?us-ascii?Q?0nNX85kio79H6ftf3KcLrFrqMzaDFHCK2N7WxYJJAkHwdVpwBP4Y2TkNPSoX?=
 =?us-ascii?Q?CoZNCjrqP68Y/FbLCyLBTO6NaLOpZy+InmyRUnSfM859R9+YQwt43Y0f+jZ5?=
 =?us-ascii?Q?dBE6kFbLNh63LTU08fqMCt32EIFF7ansyuycWUmJoEreLGNwMcyeC8yZyw1B?=
 =?us-ascii?Q?Tl7jYl1JCKZ0Y+txK82D3pqjnRYIwM4pjMSAaTy4/g6aikvz8PxITzCNGYNW?=
 =?us-ascii?Q?watFCs491W78WJL89YAMEWrkxI57HMrvSu0J1sv236Z0E5oB5yWOvwct6USw?=
 =?us-ascii?Q?Z9Wg9TzanUNSa/jF5ycnvCsM8cQlw+t2pzH4vFlOEUteRUuv+xnGY1u8zcef?=
 =?us-ascii?Q?bC10P1pYo+jZBcTb5OdGcrX6/0h+bGKKofmECfAO2gOPerBGu5+VuAPp9FA3?=
 =?us-ascii?Q?/YAbYq6ReAfvdo4QYbpsNA/q6+8Iug8kcTazZQyhwmVOr0QOWRRrHIpPiQRs?=
 =?us-ascii?Q?+8WCKEncIpk3GYO3k7s0H3/4DKUOnVrXcCau15WngsUZtcrIhUfktyUF7N3k?=
 =?us-ascii?Q?KLKyXMtQHd+sEUpQPqNKyaDuQUMj3APuBdqISJZr7sBBlGw3DTGk8sm3f+B1?=
 =?us-ascii?Q?7l+TzDfuCPld0lnJa8EzyQhdr9NecMsaB1ReUEemtMFpcj2z0eNWBTVKG2II?=
 =?us-ascii?Q?yBaUAYophS/OleNMfQv6pKSHGv38gxgMgllpLXCxodrllMPs4tFKFeNy+XZs?=
 =?us-ascii?Q?qaaFkh0b5NLmmi+4TAVOixx+zyrbZP+dMNmJKj1X0TdD0BT6cDUBaVZmTCpz?=
 =?us-ascii?Q?QkBSU9FmqcGAu7f8xzWNa8jPWr0BzuT9xb4IU11ncxNRNmhh1saF6XJF1pmh?=
 =?us-ascii?Q?8wio2NEx+/grKRDVPgpTk/fsLOH2Q7RAIsmnicTGEFROh14Z4VdpL+G5r4/x?=
 =?us-ascii?Q?Tv9esJIGT39ieWHlVi1KQ//ePj4AY0xqGP41K9EBLRVM4QJCzfzlujsGWT0H?=
 =?us-ascii?Q?wGrqufZQgO37Yl5SpfsOy78rODBVk/TiKnJWWE1r1KytJjWhKhy5J2l2sh/b?=
 =?us-ascii?Q?jKi06myA+S5pQ76Jrr+DSVRGmlSScz3wl52w7O1Z9KlyDFxzSwJwk/jcUf5p?=
 =?us-ascii?Q?oy5LRhvDtzM6hxY2kEkMZQh9Ff5kUdy5DiAxm4+DbObvUmeYPjSNIDwIY+hV?=
 =?us-ascii?Q?pam2FxWsFAWMgXI4KhVPMfGfuJ62uoJx4H05Bf1OwuUFVMsibLu1Ugjg7k90?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8334862-627d-448d-a992-08dad8565391
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 13:24:11.3919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TwfCpRl/hskVIj723LvCTwfK2h9uFSIiSQssFA14rsTyvJOUb3K6y0fhrf6k3qYSe5BYvjLK5HFz4tjRnDdE2vgAimAXLo4AnT57n2hd6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8002
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1105 family has 45 L2 policing table entries
(SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has 110
(SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
accounting for the difference in port count (5 in SJA1105 vs 10 in
SJA1110) does not fully explain the difference. Rather, the SJA1110 also
has L2 ingress policers for multicast traffic. If a packet is classified
as multicast, it will be processed by the policer index 99 + SRCPORT.

The sja1105_init_l2_policing() function initializes all L2 policers such
that they don't interfere with normal packet reception by default. To have
a common code between SJA1105 and SJA1110, the index of the multicast
policer for the port is calculated because it's an index that is out of
bounds for SJA1105 but in bounds for SJA1110, and a bounds check is
performed.

The code fails to do the proper thing when determining what to do with the
multicast policer of port 0 on SJA1105 (ds->num_ports = 5). The "mcast"
index will be equal to 45, which is also equal to
table->ops->max_entry_count (SJA1105_MAX_L2_POLICING_COUNT). So it passes
through the check. But at the same time, SJA1105 doesn't have multicast
policers. So the code programs the SHARINDX field of an out-of-bounds
element in the L2 Policing table of the static config.

The comparison between index 45 and 45 entries should have determined the
code to not access this policer index on SJA1105, since its memory wasn't
even allocated.

With enough bad luck, the out-of-bounds write could even overwrite other
valid kernel data, but in this case, the issue was detected using KASAN.

Kernel log:

sja1105 spi5.0: Probed switch chip: SJA1105Q
==================================================================
BUG: KASAN: slab-out-of-bounds in sja1105_setup+0x1cbc/0x2340
Write of size 8 at addr ffffff880bd57708 by task kworker/u8:0/8
...
Workqueue: events_unbound deferred_probe_work_func
Call trace:
...
sja1105_setup+0x1cbc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...
Allocated by task 8:
...
sja1105_setup+0x1bcc/0x2340
dsa_register_switch+0x1284/0x18d0
sja1105_probe+0x748/0x840
...

Fixes: 38fbe91f2287 ("net: dsa: sja1105: configure the multicast policers, if present")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 
Hi,

This is the v2 of "net: dsa: sja1105: fix slab-out-of-bounds in
sja1105_setup" and it is a resend because the first time it was send only
to stable stable@vger.kernel.org.

Cheers.
Radu P.

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 412666111b0c..b70dcf32a26d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1038,7 +1038,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 
-- 
2.34.1

