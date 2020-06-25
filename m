Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4698720A678
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404386AbgFYUOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:10 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6196
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405110AbgFYUOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:14:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSqnjxKm4KOv3t/A3eACJLNHqxkmuNc2w6jONaBCtH5dLFIUDStyXaHcJQ8liFT4riIfPBphMyqUQv4UD5yRADve1bhsP203fuvneM05eEBVJQUj9TxTN8GG0PjG5MP8O3rZGJjReeEk1ZIyB+x7mm5FQbVuK7NtEVQki9VACBSZ0ARl+DrBubaas8U4dcY0KwOt18ZcFuKkN/lMzCV6fyygyY0fSJaFbOPNeL1wUfob0hI041dwi4xwH1U9ShmYk642XyPr9oJiDl3Ihb0f1jj4ALsCKlc0N8gZ3hXFG/pdD7RlPbrzpTD0YgS9Bbl009LENvER2/5HqWDUpgM/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=jsfuMwvDRxUbdL/e1zVhduIuMT+Z6a0FVsc1wcGYST++W+I9SZ5C+cN0AHwOh8bruU4/yU4so86U9J7rqh71/OvhOIEllvrUMAZS7esY9IRuROlxgeLp+/QcitmEwOCtMCAdtG778rNvODT5BX+uDZog8e9gCVcnIEL1qR6Xta1/R7ghKoh7PLfFArKEAL2a19Cvt1/WNL27h4S0s9Y0sIrsmf/Lh+bFQEnbeqO3yjErP/pU9AT/RcqDw0hiay+Jx7ghB9azy/DXjY746vJyCxlUG+ICdR/PJ96erJ0PpWGrgsOiNQBHH7aPfCm7uBdJd/OoGtl/7o4O/jtwC4hOnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=aB/M6eQBg4jqsjoBqoIy4YBHKoZJ0soPtYp25P7ELff54IMWIA3MdDszH8Bigv3PIkcJfyFI/JAYk+1+2/RzgjHho/pMdqqcPmFvu03WakxdaDZWj4KNrOKHZBVYsFhDzOO8zXaZ9P5SUocEM1rXMVavlSDxbyGOOJi2ED5FXaA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 5/8] net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c
Date:   Thu, 25 Jun 2020 13:13:26 -0700
Message-Id: <20200625201329.45679-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d2d6977-0114-4515-5f83-08d819444b53
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448C64F2ADEB6686D0C455EBE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XrIkBAcgT9PQ4eNgBc/kS32FbiC5oJiw6CUyGpt2zDGeG6QgbDWBbZ745OnS/DDqq0h8UkNLaztLLUgFvpltr4pNpI5Xereixi6PjwAuLL6BHji13tziGw/AOplHuGoCSE6NU49i6DgWCEppOkFaxXVLBKkgU9oidq8x8TpABv8VvV94//CfEScc4Sjw6bWWhrMBWpOsE87gdiXMsOa7ld3DNdaeqg6aJ7yZCI4j2GrdYrqo6fgKfjiKi9QDNJHox03UhT9OvUk3AMAHYXSZhxJLy5qUAtkOjsW8OosrgDzVW1awFT6dBdzDrkzV98scmeLO8Bhw7Lz8aueeLcSdIxRz5rCsH6x3d4mWQhlMOOyn/6iNVSWFkX7Ub0bIy2WT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N5+nXlxqUv/lDlUDQGDRDK9q8u6BIDBmZA8JFoWxD7KdqeVDPnjZIEzxvNIG9QA8+6UvUXYyDPin3jZWELCcoXsdGTHt0uZ6BE21o+xa+9MnS6FmjUkF0mt4eJE0hV0fp8HS6UImQQycRfxdi4Mob4eFvZv/Vy/2iF3bcDrh9zIbKaS6WWqB+wQVnyTXM3x/ma6CAexR+nPzg5HH6Qg1gDgmwo/sUW2LJWjdknI6oz/omWGnaPJCRuf5BKmBQLcQ0rZWJY0RU9lgqQ7wPAtkRR4wQDGxVBq9HasgcOlrC0dH89tCJiOV7tBGq4uPqHHbK6syO5LdQmVEYi+z0IJI/qw7l/B6WBz1kwwOHQD94tsF8C15hij3/zMuIYndvHNTB8eArDw9KaWw7Mqi3QMd/dUUFrFIf4N7+mCbOqjH11aoMwbnaohF0zPlPJmC8oiWaEerKaNY611hCSf2CYlOFllnw9gT7CJYxWm1Zw+oU5Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2d6977-0114-4515-5f83-08d819444b53
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:58.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fruhBrlsSfny1J3bR5Ni6QFIePWV2wRE3QEHaFHz6S37pBSyfEc8eM4fBkarC+64iO/QAjjwA6gUg2r4q++XmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

After the cited commit, the header net/arp.h is no longer used in en_rep.c.
So, move it to the new file rep/neigh.c that uses it now.

Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c       | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index baa162432e75e..a0913836c973f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 #include <net/netevent.h>
+#include <net/arp.h>
 #include "neigh.h"
 #include "tc.h"
 #include "en_rep.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 20ff8526d2126..ed2430677b129 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -35,7 +35,6 @@
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
 #include <net/act_api.h>
-#include <net/arp.h>
 #include <net/devlink.h>
 #include <net/ipv6_stubs.h>
 
-- 
2.26.2

