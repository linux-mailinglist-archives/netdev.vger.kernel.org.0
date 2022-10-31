Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD1F613168
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJaH7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaH7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:59:51 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1CEBCAF
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 00:59:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3B+k7jnt/n+s0vqVTAgkTeFsf8/lfNEphJ8TyV2Yb4O+7ZOj7RXfETYJ7zosC4i0h2uV6lp49VgGa1Ri1rlEhQD0sETgvT7+LTZV0o353zvpZiZ1aD/d3VngiIzwtJzLIJuzhZMPadNeoQYZzJ/nUodEHsEGH5zPby7Fur2ljunH4zpQ/3lmHKpHBOBSH1jAVwXcAqAzpnDggYjuSG5dk5k6hSi+gpfHDtp7Yh+80fNqSPehltSdjvJ4UJEwIvloq6oqEZrLoQrMBOWJTou6/QxSWvWhEUgXJQqPtsiSTtHy8UY0VvZAyBLHjRDJN4MuN3SntSlsx3W+Tz70ogHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iv3gkzkajlNuhedC0e3dQbc7kY41GVYyakY+XxNzeJI=;
 b=KnKYJwEWBL8UbxjAMdDgg7rroypIKkux+mcvRsu+osdeWdLwu0B7pET57dxUgTWPMWtHx6FOOrUSG9I9xNggRYEzcb5e5+HEtlTvaE2jSNYa/9182tFtPEM2Vn/Qn4kigOnANt3kddQ1vbVFfdn/F6wKCLABmyK+e345gt7pE85NV7KGty6Ucp1pzPylVSV5F1KgJmeX0nIQqvXVNNqU2Twd9/ps35on/D5Kfba10zlTEGxPaiTnFuSVptFFGqxbnitCDYGqukj9sk8CouwHoFFmwtniPZigzqt/LRJCJWe68Ut8YQOZL3+RR2uMeWXkBJQfJ+VLX4Q/mbmrjU/fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iv3gkzkajlNuhedC0e3dQbc7kY41GVYyakY+XxNzeJI=;
 b=ajGbrXzvslGZVBcBTnyu9yk4AOew+OHNz8yL9UQb6RDHnJvin1TteeQwimm+JfZjqn4vYjO7PEhnfON96f8XQhWKr+nczc2WaMzWMuXHW2D/M4raG9lzHDsmQ44RWqufKqPOwYzmQEYkQvHvph1GeBdEozqCiKlQ06cvUJSstM7oIl83p/KJaEV6AQJPY4ycSIA91ghr4/9h1+S1SpY+/UEpP5WPk0ZRZrJrUGWT7PmrdP/qzodArgyjIPAloh4ttCnGUs9djdZ0+h+/dRRrKJTwCcHKBTIKzhOlDlNJsnK+LSmLBIKDwVggxAsitmpfGylZqM4yBvuqpu7mrsdMhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 07:59:48 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 07:59:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@resnulli.us, vladimir.oltean@nxp.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] rocker: Explicitly mark learned FDB entries as offloaded
Date:   Mon, 31 Oct 2022 09:59:22 +0200
Message-Id: <20221031075922.1717163-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0056.eurprd03.prod.outlook.com
 (2603:10a6:803:50::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ec853e-8a79-4dc8-badd-08dabb15e179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdn1DYYWbqBGrBeF219r6qbFtbuvoFYcgeDZfK6gHTSaRuXnbX+5Z6ZM38FUgrlik/adGJqIwOv0+nxx+5qincoF46EP+yzY2hT9vFUESQtIXTYUwABUzhxAGyICwuvtC3xG5UH8UrPU7c85MorY9KCqXm/qNMVy3sg/K2jcA+4xUy2RA0uDqDXvP4ZHM/i375+r2VIhUzgCn0aQRy7+YlcVIPLPsRXO2cDshIQppah9U+bWjNM74rz9K1oVtcQ3kh4jczLnPnu5c+yiAwAvhfAq0jyHpXtl02GfqGiOAgEE9EfBUuitWtD+Gmt1o7ZMLBmlNedIxCETr4l9jG+6pVhuv+lpxoS7rBTmhK4GDClEE5NLmg/cDgWCeUuXq3CIQ6YwLj+CkPQBOR2FAjM6AzyVFkgUSvmKq/YoBo6I+jHCO3+J/oi1jPlzv2KWHKmzijCLlrPgPJxwMJlDbXOSuH6SxTHa1OCpb8JDmxjCYC9SEdaKkyjIzcb1YIx/1nxswA60jOA1EgLDCRMHwZEspGzOX0ANDE4rbFq/KoCbUZet2GR0WaQks5hLIvO6oQkyQwRk0c0FYBiEsPMYLR+dQ4fogA3wlewJHVQmUrfgcmNMuH60zLjSOuhHgCvKx+854EFRUp5QKLeG9TQz2oZ2u+ye/vYnQ65Ir22D9wnPvtQ55KBpj0IObeLNg5Ywpj+LA7xBrGtWpwCBF5sTvHc8Omkx5OZtszmymtlZqeHn2MSfLINvfMpkJeRCTObb34Qry1Ci2bCgTocx21LnUx3Tm/OqzZRmsG6LSMR0rpiToOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(66476007)(38100700002)(66946007)(66556008)(4326008)(8676002)(6916009)(41300700001)(316002)(2616005)(8936002)(5660300002)(1076003)(36756003)(966005)(6486002)(186003)(86362001)(6666004)(107886003)(478600001)(26005)(6512007)(2906002)(83380400001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FgZg0gHUEc6xMQJGKgZwwSkFGF3YlEdv4aG5YwCqMoalZ0MTqUIgctT2oPgF?=
 =?us-ascii?Q?7XwYJkLkfbntyeYRJ46Um1MRiuoBwSmbn61pv7V9rfoLKGYGsff0ZVSBg16F?=
 =?us-ascii?Q?weOZ8xcfQbN2lsYiiccPZIs7zYdMXWeSZcIj0P8OUoQ/gx3HeU4tpbb7jbQG?=
 =?us-ascii?Q?hxq8A6jWHQAlZnQM+mf0uaNMzTzcb/4OmGibLapkq52D5kMuql8+LHjDiyAa?=
 =?us-ascii?Q?FIDreHSnck4nHja1ebxaEHcmbW7fz+ZEBED5GtNm3K3Hu5Rob8BVDR4GsTFb?=
 =?us-ascii?Q?AMdT+tTMc1rtYA6btR/dlZetR/UYSHRkr4oLcd6WLulx8Two2/T8kAoti2WK?=
 =?us-ascii?Q?rQuYYOi8haMQ5gBaWzUoMNfJMx1N+G3fB4GLXm1p4WHGumtfMyjVSwrfuwbu?=
 =?us-ascii?Q?nUv6a8OdIrlnh+A8hiPy7VIw39UZO9rJp+PdIdmORV+33+4yPvnMXQyRh2MS?=
 =?us-ascii?Q?7jwtpRSb43IQAOUDrSjhbgOG70k5VB0tAnJTUWokzAlS19w9ZubfmlLSgqv5?=
 =?us-ascii?Q?fJM2kxPUj1e0sa8gqVN36dZ3zNDf8O/2B0tGvzPS6shT3wHdH4f5lNd1bYAZ?=
 =?us-ascii?Q?zblA/l5C2y3FUDEqcyEilGej87GieVcgJvvrdxqBwbEzwxwGnzGQZtfHYw7J?=
 =?us-ascii?Q?8A4vEqe16rm/SE0+cgLZfBUs77RFuE7FxQJNE9w/1MCUEFYqvwZ8HaWV5oz9?=
 =?us-ascii?Q?dJwc2ttHl4K4yRKTrZxqjks/wk8syMlbgHRQwh5phHWebe/LUaoKtQsMwDeB?=
 =?us-ascii?Q?sJ0SUdaUd4MtvtB38XVMrLBsrJo36sh+sz5cp2LmRaVHPIh1qVs+PI/KBXwk?=
 =?us-ascii?Q?H9GthfkchJRBWd0S1lXSIiSAnty4YO7PUzdb/zrwpmSkX29ZzhX/fR9Pbunn?=
 =?us-ascii?Q?Qgsl3dCV7WKcYMLpOP/OhtsPYnqbWlB/2JEK63zm7grtw/RdXjcglLkPnnlO?=
 =?us-ascii?Q?vZX7MzpeMqTI0SbsV4BG19zqWWpCE+E6cyBV1lHS7EPeBow0Y0pka5flKGec?=
 =?us-ascii?Q?ncAYgYx6qc9LtAavO37YfrvGdGgi2zGvf9tgkhOB5o3Db2glQ/0pxORfbd9a?=
 =?us-ascii?Q?8i9xs2DosS5aDzVhJfBiQT6fYKXXXKECQvrNpwjQiNUuhCfJTw6p4+0WsCUr?=
 =?us-ascii?Q?R9KV1NpIKijuIgwXWZMLOVJv/fY4FyM5doUb1YdZIfcgfL2R/87cKrbNkBsh?=
 =?us-ascii?Q?wmv6Jt/TkLooQZ9CKsvLIOaXOUqMiz9/7HBvg5zKzyzdpBhLRQWQsFjUHSWw?=
 =?us-ascii?Q?y0VrPsSDhEFVgdkPhcYFkJeOqbGD2VuGXYLCbilub4YnL6emiQiLaTKOoXri?=
 =?us-ascii?Q?JtNjykyLQXv9V8AW1mNBmxA0qpdtCXT6ic3EfQyuLFOwp4ttxReggWk4Y7yo?=
 =?us-ascii?Q?oe4O1Ev+1sEE1EKlH95FFXmku0TtUUTaZZ1LIEnWzxHucuoCX7FzxdixwF8v?=
 =?us-ascii?Q?lwyCiCHbjnqUq9Ko9xjJm9y1782y4hwheTMjO0WtJK/qZvKJ0pyR6PpXrxjg?=
 =?us-ascii?Q?5GXxh7773QM2qV3gKnI3vq6QOplndiUfysVq+9WkGANzeuIS37zq3M1yX2qD?=
 =?us-ascii?Q?pAQ1nUUE9jYKZ4cUIbvwmQo6ze9BN96qwS/6Vm5S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ec853e-8a79-4dc8-badd-08dabb15e179
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 07:59:47.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PdMe22SFKRC7KRUeEewriWTp/RqUPr5E+R6I2EbmA4cvxEQdhjw1kbFb2to6txb/xniTAoeCrtVrz5rlqjgGzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, FDB entries that are notified to the bridge driver via
'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded by the
bridge. With MAB enabled, this will no longer be universally true.
Device drivers will report locked FDB entries to the bridge to let it
know that the corresponding hosts required authorization, but it does
not mean that these entries are necessarily programmed in the underlying
hardware.

We would like to solve it by having the bridge driver determine the
offload indication based of the 'offloaded' bit in the FDB notification
[1].

Prepare for that change by having rocker explicitly mark learned FDB
entries as offloaded. This is consistent with all the other switchdev
drivers.

[1] https://lore.kernel.org/netdev/20221025100024.1287157-4-idosch@nvidia.com/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/rocker/rocker_ofdpa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 58cf7cc54f40..f5880d0053da 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1828,12 +1828,14 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 	info.vid = lw->vid;
 
 	rtnl_lock();
-	if (learned && removing)
+	if (learned && removing) {
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
 					 lw->ofdpa_port->dev, &info.info, NULL);
-	else if (learned && !removing)
+	} else if (learned && !removing) {
+		info.offloaded = true;
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 lw->ofdpa_port->dev, &info.info, NULL);
+	}
 	rtnl_unlock();
 
 	kfree(work);
-- 
2.37.3

