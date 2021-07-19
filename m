Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758D33CD622
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhGSNMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:12:54 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:65094
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240761AbhGSNMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 09:12:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjsW5fmcPpcOidVqkFq4Sk5Wjr2LCf+jHM21Hv8taUhV75RGr+EsbLdV0D+pN0W20wE6K2XYfLm1XvNjDIE9ccJFto5E8GXqUZeL8amUWuKcXFkHZ1K+nhyGDvo1o0eIvDBwILdOVPjzxXA0fYBnGZORwchQeJZiDZeyZHKeiabmsY6ZS+h1hUTiFSaecCKX2fbMrixbOSSRbJfq86wx89VZp+0UI+FimfRxeYYWYCuJ79x7/Did/OKRA8ebGTdJVidyBXbEVOit6zgtGml0HqJIv9M8xg0U2U5EWZRDQdosBu5EDh4eWiJkMj1F3SAWhw5J1TWQWv6jO3oQ1Q/7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mcWNza9gQmSxGt3bwRx61Kopd5OlGB2WGW5uMng2ew=;
 b=ISkWFCVctNFBopAGCgPFQj8BHqpHVGH19D4FX9Smb6FlkQklqCFCJHL+742Bbf5UJpCzsX6fM62z9eTZgbayabWHECSr755DaLHkLL6SUyRgPLdIplP2k3dGkzj7QTnMVDVOiSdGiXEOKaWCTQRE7/5IpopN3T5tWdDqBSWoh/Iv9sgI2nc1yBpkRSL0BMUDPOC3kYSBm2uZEztBd5ccOvS08Hd5aiH4bbWMbxUR6q33p8tUHZWVBS+nhbAporBu3dc2qs2oZjTcKwZP0Igx0E/or5PC1abi5Am58v4Rf/k2tLHQb5/pOuLL8FQ96xayv2pjZfLozR+sRRhfekD/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mcWNza9gQmSxGt3bwRx61Kopd5OlGB2WGW5uMng2ew=;
 b=LAKmOlKypKvDRfZ6POm7X6LhpOgvXYVrHEXuUjMdu2s8PqlC1roe5rJdfZ6lQsLhdJDv+qwCQIWro8qIcWcTjHzGR1/RJrg9nQ3NEsMCf2mpMGIP2JxSFOkrq9oQomjkX8Z/KZi07e5cta41R2WXuEhnt7z1MiNdH5FT7QGgd2c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 13:52:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 13:52:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 1/3] net: switchdev: introduce helper for checking dynamically learned FDB entries
Date:   Mon, 19 Jul 2021 16:51:38 +0300
Message-Id: <20210719135140.278938-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719135140.278938-1-vladimir.oltean@nxp.com>
References: <20210719135140.278938-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 13:51:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af336278-e453-44b3-8d9d-08d94abc61d4
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74713EA5C21FCD97E62B0624E0E19@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmjyRX2xOdcCIvzLVtWVsXUI/xxJIBGwYICrHH7WafYVMEtU7Kik8sIpYfHgH07AiK0R1NBYC+ogMSFfAKq5wmAGDFnT+WzSiMBb0aftorgRfVVPmBMXdUwqo2puoOAYpRYdIQbmwM6y0Ubj0FyrLceK162uP2eAkCSiosjfzGPN3toBqtpsd6J2i4aLp71b71EjgHLADYID5G5S0t/oP799HCbl/PbYZvBmPdNaGHh978wKL4QZ5vH4IioINswsOnL6x0H6R6NSxuwvwq+4ivYJibnviAtlnWY8vXMaqutz78eIMYVhzCgA7SX5uYQiWNniTJCzRr0FAMDrbntA1RuF0Wi5Op/NW2D0UQ+AMWL6ANLPwZEz6zqG1lttJ9Xblx3h8JmI+xdh92Mn53lWD76NY3Gwh54gp2jc1wZEAz9XxXrxEteK2Q0ND9IRFz/szddg+MNy2Mj9JmAfjbeDy6V1542wmzYVBgvzF4pb6N4r2J/wleqSTbr8VGWGdwlZfx4Zy3Y1uawChr8otUh408o2XnuWtEAWOfZGUdeth9xTHPZ0EaJWunZz8ijoM1aovxRG3nN11BKxYIt6zWt7YVcWKF4eQLH1mKIhQnPUK2br6Zs/7znld7uGOj/YYP/bdedZNTaZ9nE47168cm5RCsXs0Hwp7lAOv+xKinTIJOFgkOBeV80YRBcsY0FePDh+xvBi3Jw6RGkuNgKdUhHV3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(6506007)(8676002)(7416002)(1076003)(44832011)(5660300002)(52116002)(110136005)(316002)(54906003)(8936002)(6486002)(66556008)(6666004)(4326008)(6512007)(36756003)(478600001)(83380400001)(186003)(86362001)(2906002)(38100700002)(66476007)(26005)(66946007)(956004)(2616005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cG1D0D6rcqxEjqE6qEYVaycWrL6bH+Lhzp7yiOKxAk7GQgiEzuLryAAUyOEr?=
 =?us-ascii?Q?E5MNQKDxzo8hZTaayWND+crIeO9qkx5zCmCOIeFWZI4fSaDpdvElTMetjVT+?=
 =?us-ascii?Q?lQsZ6lrV18/tWWxCqiEfG8J3vOtrYgl6mBOZpl6+bVukaOmeTLA5FGqz+H1J?=
 =?us-ascii?Q?zlctegxL2qtzd11qQWlZJSS5V3CXoCc7OOd6Owf5rMXPXV49jBbYG5sqUhYb?=
 =?us-ascii?Q?ckUqSbYXv82agEV56bb/RIZEOvBtLH/Q7qQISg6RW2F1IS6VNmZiQljHdXm6?=
 =?us-ascii?Q?GDbCdGCmL5SRLGQpf8P+DH0K0wh5VOdvkQ88M+30Eim8hvN7+Mz/gfV7rJ+G?=
 =?us-ascii?Q?YuNCs53ChsHiUCawvmwbaQng5dliloLiYeR/eF91hJjcASPZ1w3xsGB8axQM?=
 =?us-ascii?Q?IJdx7eV/Egnd+MFEykpUqHKJy039QbWPtJf3HTdgfZoUWxFpwfdDqU2XM1Ad?=
 =?us-ascii?Q?YnNfEX0AiV1X8BpJmXJOSBr56RCpZ0GSvqE2zkpriIT1/uQD4vChdRVmzpnS?=
 =?us-ascii?Q?ks1btXk1YoT58e2DDiMFN4z9vxiotsZCiCyxRByFtFwgDx1xe0yoCaBab0lc?=
 =?us-ascii?Q?svZqs+aI7653pq/IZqP/a6ZaFnSZ324Csei/jQUPo2A5APyPmVu7gk2EyWJ9?=
 =?us-ascii?Q?dK1/RGe9hx14/31kmIMYbfsENjntOzlabIjyZcty//T7DCEk5UMqnHskkQpF?=
 =?us-ascii?Q?EKW5/kroRZmNWnAinsVwogsKXiLfEZ+7/kLZmtMQPooNB7itaVcWS3AwkmUj?=
 =?us-ascii?Q?oKilGuvnNqTJ0UkUkxPOPgiyc7Ctpz1UhWSAhJek7yQn82XkuYJDJbuAnPA4?=
 =?us-ascii?Q?DFYY5zjrQW3q2g7nI8skGWYl3Gi1b4+KiwghQ74dyx5n83Juu0WycATZMRfY?=
 =?us-ascii?Q?WyKsVqThmwGa3M81ZZ4+wFGJpyusRbAasJoKMAjKSGxSoR5CRepSEdPmGs/u?=
 =?us-ascii?Q?BshHNW6yh0a1mYV1XtNR9mln/JL+QGMJTZGTWeeSypHsRYHniRcTk/70Vrtd?=
 =?us-ascii?Q?a3RHYp1YETbeMq8GlX9iTiVwImECQh5KVSw01LrD6+7bCOump9wJn4a/Ufyo?=
 =?us-ascii?Q?7lz8vpkuE6C25qrurdlAbnroTvJlykpVw1PHaOTZK0lVG8pMpmdAGm4Gmsxw?=
 =?us-ascii?Q?HAqJ58A7IEwGAujjUmuQjw8ObQvlbgcHkYCisiYDW3pnoPxdG2w7O2s2XDUJ?=
 =?us-ascii?Q?f5reDxVATRAGk/W4LDfpkvjbpay2t+ep9FaxVtHpiR6UOYgO7xMlwggFep7O?=
 =?us-ascii?Q?z5/nNoJFSZKE5/0LFjckx3DuV5FoR7htkLXzfDw+n9NPOGk5OD0Sieo5v0a0?=
 =?us-ascii?Q?unpnjMqCGOyx38QXCkE7rizU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af336278-e453-44b3-8d9d-08d94abc61d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 13:52:00.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qu7zo4yhKFq99p6zX5xttqCn6ENHPiZm4duSiUEP7ggmeLT1Vxm6zce6ulFdATvf+9LAc6dSRCSVEDHznLaUOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a bit difficult to understand what DSA checks when it tries to
avoid installing dynamically learned addresses on foreign interfaces as
local host addresses, so create a generic switchdev helper that can be
reused and is generally more readable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h | 6 ++++++
 net/dsa/slave.c         | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index e4cac9218ce1..745eb25fb8c4 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -238,6 +238,12 @@ switchdev_notifier_info_to_extack(const struct switchdev_notifier_info *info)
 	return info->extack;
 }
 
+static inline bool
+switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return !fdb_info->added_by_user && !fdb_info->is_local;
+}
+
 #ifdef CONFIG_NET_SWITCHDEV
 
 void switchdev_deferred_process(void);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ffbba1e71551..feb64f58faed 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2438,7 +2438,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * On the other hand, FDB entries for local termination
 			 * should always be installed.
 			 */
-			if (!fdb_info->added_by_user && !fdb_info->is_local &&
+			if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
 			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
-- 
2.25.1

