Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19DA3E01C3
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhHDNQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:16:59 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237972AbhHDNQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:16:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtwmDf6GMPqVkQTGTMBKnqzBWijAQob1mmaJ7KPd2S3GWd3v6C7+9+nsHouxsfOdMScJrw1UQPqrn8aSxbfI/Zlkyaz8AVtSXLj+DAUgkeUXhWTH3oWaRanE3PzuaIH3rwtSS+B302zZCfGoiCwwohH1/30F3DpaVaXSwhXiu5+vFTxXZS8sOCmOy52NYBHCCppbqM+HdBcqzdiTQNojz6/ZLpNhVaXJEZ3uky/Gww0cdbFYhnlkdw+uVgDxCk9GRmYNOGIJGfEzVyegy6GMdoPVZXIitpq8Jy5Z+lX9WdRSLqDbfJmtzPHxknfHHMuYzMlO2oWLlI3KNVU+lMEtDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=IDBEBmeLUBKqMCASu3AcuA4coKlPYPO5m9lMdGOXGv6aKDujdd0flbAjTl9dieo2P+CUByQXBigbyldQK/kGLDRbjs5ea4jIx4/aVcdXzYIA7ddi7uA9taSuS0rmYbtxKkIWSY/3Zy9ABRKLBOEZjbUCbhusYZDn4+Da0fjEIB5ZzImkv5n/dGfBoNUN0S9NXbf3dKKQ723e1hJDuLXae+0fHaWT7oU8sTM7Kejsow5Zm1UVXy3TQ1KReD7OOci/8r+ubpwauwJpmFqlkLqzkKSfw5/vH3fwU87D7bLaQc7gNKcwlSFgYGGjgOLRiCm9/raNuVITA5/7psAl4R8TFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUJQTskF/PxUROiNR9u0KutptxhC7rr7ejtMqyblQE4=;
 b=ahuK/WLOh0rMcrRCdBZ9QHP+O9Jt7dMFNRLxgjlwRY9LLbe1FtlBtsBObNbCAgt/NDa8ykdF2ZrU9+CEg7qGPtYrwGQKcCI4KF1Imyeajpi7+hiD0SfcqTPwIglijRXSzS+xLKW0eU1bZGUYObaPcZCE2aiuwRduoWlFUU4UkKI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/8] net: dsa: rename teardown_default_cpu to teardown_cpu_ports
Date:   Wed,  4 Aug 2021 16:16:15 +0300
Message-Id: <20210804131622.1695024-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e02d7dc-d893-482f-8149-08d9574a19e3
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39679262076C50A2E78C38C8E0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6qauFheyLhpyMihRDFkZ1qpua55el4aii+OCpL/Adha927F7sIoA+eHZqbhhOGdWb3wquJwWxEqg0PeNRtl1tgcxSXL41Qpd34qS4m+Gm8Ekq2rR7NL6Ab9H1bNzb5AE1i+yI78/9UoFXCxqdX0BRFlmt96QsBZ5xrGw5rnouz3wD5LQRX0hLRzr2EELRuU4DNxdF9xnGnP0055fClhrJnw5Vidz9ckC128Z4+fI7p0mVurUfwad4GtSTMeEmKGwlCtcwwv4bMsF+hBY7N5K4tTklZ70ZfMexm+yxReyWRd6OAm67AbvDdIFb5kGW5gDCXix8pTqchEDugyMHm+DLPMoGH39KfEaDkd+4i3wj4PmDGkoe4HtD5Y/8W8Cot3u1iSkWGl/XDUvizrkaH+0XSxtjCbIjpHJEOY4AuG/Y5q0gEr2NEsIU6aktp3NJwsbIXlcT0DteP0irFlZ5+buO5bA2o56MiAkppLQ8WCRG0cJH3vipPG4+hx2cmlntgF4aaHY64R2kanIVrrsYEu9bMPhlhjxED1IdcIUkq03AVVBoLkGEGWzKhKLUxWCF+KopWK7wqEemmwB51SdqD0bNyleGJVggZqWMn8lJ257CBoBDctZ6mojixPRO0RNfySMtRjZRQll/61ol0q5vEi9aEp811iI9g+y6nE3WU+wlCD5+2dhk3BnD+vjz93tsKm12723toylsogoJIZtLmGPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XUQzScDS7m7FnMNaBR3LcsfScwIiPtPeke7Px4FkTzcNJQXR2dZMlNtUX5TL?=
 =?us-ascii?Q?4b9ghxNM60u2XGn9+N3N0LCuhOjnsbiKR8x5ja84KWgKNxgXVSEWuv6wt01J?=
 =?us-ascii?Q?IChRxbR5r6y3VJ+8TavObd+On10SKsIQtJuC7IlZ1ErBkpwvNrMVc8DR1Abp?=
 =?us-ascii?Q?yKQnL0LrEpBUZ0jCOpALf4BFpRBhSYPIEZ5RqdlOEfw3EwgbkI9sAQhH7UsP?=
 =?us-ascii?Q?AuDcH7O73npcYpheg7eSGlZuLe7GXIYaUBk5USi/4Y2G0OIxNXZ6mW682/Nt?=
 =?us-ascii?Q?gp2GNPq1omQUm46gzUYX7yL5GIWX/uwRPZ/s0Wh4z3OA4xBH3FTEXk3uVgAJ?=
 =?us-ascii?Q?0t58p8omR0k6pp8XsLKfhIf0EGurhXQnK/OjZ6BAdOIGX/byJRTxLs9TfIWn?=
 =?us-ascii?Q?zkc2fn1o+7HlP/tgOu73OpaFiYqDjfQbFxoDk8XDyeIbDvOZYgN9Xlx4RbrR?=
 =?us-ascii?Q?9b0CyeKbggBc/OUa4KKE75dQGukuYt++18/dwBXsXtjclG6sGxfIxU6MDszd?=
 =?us-ascii?Q?DjNIWI8Dsgz1yUKM4ussKAGg9v1jlU7iCYyCaNGgBq3ihr89Lu0GhLgSfwfi?=
 =?us-ascii?Q?ieJLwEPYpSQUGaZtvrp4zcYkTXk+p0xYbZdYTHSBAbSUmF3P9GWdLDOEGMP1?=
 =?us-ascii?Q?kzdpoZrct2awVMMGeu9U+e6l1EWZ6AZjnc0nkL0ldw31HV8WLa1Iam3Ad/AX?=
 =?us-ascii?Q?6tkKyGfQv1pog1HYxXyGiehodLOVcsfQjWRTjQm/5PXFZ4FCnn71AZ+q3Oyo?=
 =?us-ascii?Q?mYRUpzj5Ew451lLhArAJ/VoQJ/PKToQHJhvjaAmV8IHwUbfNCUknzP22+DbL?=
 =?us-ascii?Q?gHy+8qbEjJkFTkSQggYuiY/QhP243UVv5l1Fvq2gLPVNkIdBHVpF8r0LI4/Y?=
 =?us-ascii?Q?kH7mI/GzpwCJuKBgj6OIVy3sRgEbXWoWKWX5MfPOHYnfOqwqx9e9kqnqK44Z?=
 =?us-ascii?Q?pAXlT+7+/CPkCgUQUYKjPx8nyYErgaj3maLxFSwuNGwcH7DAbSN6f1Mh+Ocf?=
 =?us-ascii?Q?vKkfeTcm9k7rZufN9tMGonN3ZDHgiumlgYACxDmxwqK8uyYXKnGLpT6gAz3U?=
 =?us-ascii?Q?09BfnVpoDMSwnjul+CktReodQe1sFYaNEfIzvViqwXBswYXKs96Yryv55K0z?=
 =?us-ascii?Q?EKLzuro6v2+lnXiIYt+QiFfEarH8NNWKo81dLuKuonmhzPOLcnDMTZgA5JZN?=
 =?us-ascii?Q?P8JBIjRG1J/w4rYJhmk7SIvCiUXqCQglFEnDGLzq+NXHEIDambu9nnPC4gLQ?=
 =?us-ascii?Q?jVXng6HKEontVSp26x8Vm0qSNOWf8xilnaejKio5tr4JbGJXhNx6oCF5dnUA?=
 =?us-ascii?Q?EoP5xP97UsarrDbnrr14ZxLU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e02d7dc-d893-482f-8149-08d9574a19e3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:42.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sz8eBR/5G40z/msr2TCpAUbGyryhmXHTMr46cwVPYVEc0OvZ03edkZjE6tbWMJTmWOKksEHYBTaV5h2O28hhAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
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

