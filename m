Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF363DC1D2
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhGaAOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:32 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:14636
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhGaAO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgK3v6dADlAzJtBdXGBTSXabU4vrl6Lf0s2U/2cWB7rg6ZeSVxODVwOAOZtmoK444GVFh/Jz0hX9yMUOPQOyQLCfOcf9ddkGfYZEFuFOqgNMutizGC+GrwESeNl7qe+7MPI7nRQ8cMQv+L6YR3AsI0dydudGibl1Byh7b57/FykV8R5dNUSyt8kDHJkSQdWhPu2/e1JsFvG2njCBy3GQ1z4dk9Qan2wwtmYoGE4Q2tHiBoM7JBrGH9TPMsUCmwgChy8qrbxgFGFbMMh11kWp2eidt9GJTtzIpW3V8l9S3ykVDG4ZFTwQ4LlnSPoCIbsGcFyXcmV+Kgh2m17L2BxT/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=BOfuZpxfWU2F8X6qq1Rg74hIJ+lxO0LacewDnnLz8xrKGejesoeiu5ppV9sAlprK7YK+wXeL2gT+PqKh2gVAhN5uPYrNPrevbMYI2uMGn2po2QDHSsQr+LQn1vfFCSw/+gCjKkFqQJNPPHjJCuS5t4Me8E4y2niIMNNmvWD5nLO45m5NhqTDEIjwV11A+nZm8k7/AWS3qZuJe7WYL8QI1K6PSk7cGb+ZzlqcRXLXyUL0tXA1PKHNmFol0xQF22FfXGyLA6AN1Eypynmm3WxbPYSRr8QgsTdwuinuzxelYPmGYI+h3vWyy5VgBFFldtjEoU9hN2rhwFsXfjSmhTIPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=Kvdl5oLg6lNM7+prRD1CwcdCuOYj51LI3dQPctah8/Khp6DuEX5irbUJn7NFsSyz9vIcEGA/cOb+KRAdbSBUHXAmSBUfoyuMTbAz+wA9VbuoS6ylKWOxASPKxcOV8374cKIkQWo81l7nQ0wNdGsMAKr0FEWSpU7EHOG36rHrzi8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Sat, 31 Jul
 2021 00:14:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 01/10] net: dsa: rename teardown_default_cpu to teardown_cpu_ports
Date:   Sat, 31 Jul 2021 03:13:59 +0300
Message-Id: <20210731001408.1882772-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1aa0ada-c75f-428f-7baa-08d953b82529
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB585498F103A7EFC1EAF9B57FE0ED9@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/BSZzLCHShica2KoO9t+xKQHywyFTjRO7XkmNdfibeiWc24GuA/PGvCCV9AcD03AHRUEqHdn3fYD8cP4SYB8wFiMMKkmAGVnJgG3d63zvg407ejd+IfJLpLEF6+4bYDRost6hD1fTh5OSVTolaNVyhz13STFl5ZjOtH9WylRIE0el1fwS6nJjQK17ByullOEEgW7pqhuxCH4riKrANgVCvgDAYm536yU0yF607V2f631W2sSwZtL40x00/JZTUuK+ebooUlc7cnRkpLpkHpJoGVcee+iib8kzsVWP8la+KU8oYUNkh99eDLbT9t/AtBp1OqC5DvEJukI2vrw+a2u3DtlZm+MrA6qcsscZDb2HIA2v2c8WoJ0AbAMVmax9Ptq14HznM0/0yDJWw7eX+/gSUytD0fwU1YcjbMe3sUb0XnIsyR+SzZCjmGIh5A5RUzftgiHCKFJgBeyE1mhffTrHhU3hb7hzk/IZjlfEBexlzxgnrH1/35poiriyDr0h8zE+yN5LfwiPXhuN4wbBLbYLppaEnuajjJppej1oDj1Hop3ZqIYa48UEPJltA0jt9T8W8cnJ5ubhyXkUcXsjqWEAFcwjfT4U/47V9sjt0JGWUBfUtS3GeYxjdEHdQaLX3KPfliUvMRrdlF/yPafRzsYHd+VRovNnKJVtaNITmOMCEaTEqoGw7w2gUcOmjqup7RevHcuniIIFtc2ZROj5qj2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(136003)(376002)(366004)(478600001)(83380400001)(6666004)(110136005)(54906003)(66556008)(2906002)(86362001)(52116002)(38100700002)(36756003)(316002)(66476007)(66946007)(1076003)(38350700002)(44832011)(2616005)(8676002)(5660300002)(6512007)(6506007)(26005)(186003)(6486002)(8936002)(956004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?elccm5YvLUifAcelNyqj5zs0ERaRzrpU63zz2kc8UHcT+znhHIuS2eRKCd2D?=
 =?us-ascii?Q?2FaWEsUL9e6hLO+QeDw6Z6LTLLKVuG1EPa8rvpM4X8VNmwPzHiHVzh79UTAE?=
 =?us-ascii?Q?TA2aB1pgP9vSfc3vBt95CV4/AmfzZCvVBjms1unySNWZna0SjjWMEIOUIuxu?=
 =?us-ascii?Q?vEcB1lVzEUjhTRT6B5VaRL3OWFfuaeSHBdyNwpqoAmRRqsEdqDeISpeJfnzw?=
 =?us-ascii?Q?b03XTmX0NW9ZKgxyhuThlsYWwVmkp3AwQ4Rq5jWtUIVIi9oukKPpfaN6w5ww?=
 =?us-ascii?Q?o60+lOGpIcLdMWzy/sZ4vGcfOZghqaLDyNCIIJ+M7Io6wa035aSm0uYkfISl?=
 =?us-ascii?Q?3ZKLvFDh3h7CXMegzSPgBcewy/tg43o1a1XoNokkal2YuoILNDzNmGTbzlYP?=
 =?us-ascii?Q?gv7kitbB8eTtxPv+eLf+LrqYyJBzjSDQ0nm8vEoKxqmvql+mnNPOT/K75OiY?=
 =?us-ascii?Q?2HHejR6STJYXQcE3UyGppGO1n3HRFB8PFtGtMK/Uq/llAogaSg9w0w+NE0R4?=
 =?us-ascii?Q?srmdz7BEjHNMk+GMw0CAzlCaNfTtS5Fo35+xVkH7Pvmn1dnJmG0v/hNh1obJ?=
 =?us-ascii?Q?FRZOvAIA5bP4t6J71L2fLq+rA1gSsVihHN9at2JJFU5PH0tCHkJPJ0DASmo6?=
 =?us-ascii?Q?0vXugC77NgYCNRF64ZdU3bRDpmgbvYQynSouq7vncAdPtT611UufnzuontNX?=
 =?us-ascii?Q?ShYhoubPMAvgFVBgbd7rZXA8ZQZyfBzDdsr+yCDFKW2HK+pG7KqSee3Ngna7?=
 =?us-ascii?Q?Y3Xl7iyHrYR8sXSmDPPcm1+4mfHt1SZJwxQhCy7KuHxXqbs200uEdwLqArPs?=
 =?us-ascii?Q?2U0j+FFmvGR+Rk6W9EyQdrnRwM+reae7EQcV9TKPTZAYLkuTAr7SnE2GE4aR?=
 =?us-ascii?Q?HL3KAJB/A54LPjf4Qkz/iUiWxqV3UYH/pRDl9OY8AXVv4KYcagI5ki/7S2mM?=
 =?us-ascii?Q?jWD89klFVzMT4Tto2mgL0rgFPR+oxESfjxsPg/ykS7QTPvzYjvDfc2xLvh+F?=
 =?us-ascii?Q?12mR1Tw+awpdS8nJy9L/C5qY9zebG4qqN9RF3serXkvly9SQnw6wPYCN4bUP?=
 =?us-ascii?Q?WVOSele1DKDn+I3uW0ZH1WBUEcmADme0Bq6tGTTfs1zsli1qhzsFjbgtzz1t?=
 =?us-ascii?Q?+2blC7Jtbt6BgcqoiPaJJXbARpEn8yRcbOB6f7jFqmo2RzpNfcGtIELA3Uhg?=
 =?us-ascii?Q?KHBnMM7lwq8MsuN76bBa/ucHaT1BQ08VXqDgZDfItdvIo9pge8HFVMx9On5C?=
 =?us-ascii?Q?HOVLHQrqWvX8BYtWfk8uENLWbLXJUxk1+nUn+t92KlTYwFKCIsholdQk7JLz?=
 =?us-ascii?Q?RqjsLPYcQLAwed6w+tBeL4Ly?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1aa0ada-c75f-428f-7baa-08d953b82529
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:21.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZftUqf01jvooDTAn4HqkiASpixJn2Nkav4fFoXjqhPplQU970y4fEOtXKnqe06j56PZSmDrYXHurx6ursTAFsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is nothing specific to having a default CPU port to what
dsa_tree_teardown_default_cpu() does. Even with multiple CPU ports,
it would do the same thing: iterate through the ports of this switch
tree and reset the ->cpu_dp pointer to NULL. So rename it accordingly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c7fa85fb3086..4f1aab6cf964 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -329,7 +329,7 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 	return 0;
 }
 
-static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
@@ -927,7 +927,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	err = dsa_tree_setup_switches(dst);
 	if (err)
-		goto teardown_default_cpu;
+		goto teardown_cpu_ports;
 
 	err = dsa_tree_setup_master(dst);
 	if (err)
@@ -947,8 +947,8 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	dsa_tree_teardown_master(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
-teardown_default_cpu:
-	dsa_tree_teardown_default_cpu(dst);
+teardown_cpu_ports:
+	dsa_tree_teardown_cpu_ports(dst);
 
 	return err;
 }
@@ -966,7 +966,7 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_switches(dst);
 
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_cpu_ports(dst);
 
 	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
 		list_del(&dl->list);
-- 
2.25.1

