Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EEE205C39
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgFWTxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:17 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387522AbgFWTxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7pMUKYgtCTaBVBoajpuAgUYjwyzqP3vWpV4nugvF3yamMa6r+NRyz//Dx5+ltV0J02tEQnrUyVh9+NoubjAwsW2KZzlzZgvP8BetOmxzouKqQXllWf9J18cBW4HWdvjtjq/HnBpa5hr8bhad4nIEY1E+RGX7FelVNyxMZOWYXZeT+J4b+RMRqAms/rAAi/Odx+URbKeFRgDHiKOGw0JYCh3ACAE9wzcLyCR4GMTfv6Xrb8nAvoJyHGv/vzdeaXxN38QtSYnS0UDs2o1PUzLg5lt8IRA+6p5vKFdtIcjwc0UjvSIJ5F8V8A0QP2L5R9h5wElKwzdiYC3bSQn4nh6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMpnjZ0HHXqZHoYKguY2xzGJaW3HQdRLPB6772RYdq8=;
 b=hcUWTzcLNCnqYbtL1ymEFTk8nBjH9CfU7FETrInWUXxYYUTW9Zi7xTRAl3+B3BONFygw+ZQ6Zysft8gmC+7kOktegMaZopRUpIOC/MpTkd0N66Mfh+MpcWjWUCc/8gpSkBb341b3kPRol3/omqhS0yBzUus6PgVGchli34bRkTlF8yNMFUcsUN6GsI70IAQeEjhd+xCyTmW3YFbXYtOf8RR5Nq4AZF3o/XN+6z2S3BBH6l65XYUthX1nHJHiJNGl5zY8/cNZpLGdhKKp2l3Wqf4+9vQdoGBQ5Hee8knQZp3Sm+LJjfoOWgGVG8yDMM+MKqQKQSa4NNt16y0wh4rxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMpnjZ0HHXqZHoYKguY2xzGJaW3HQdRLPB6772RYdq8=;
 b=mO8FAlH8PikdolSL0o+F65+lm6NrGZuGbisWkF8Db+I1BEkgfDUP3bTRwm1fn94/pk4ZgsMO+F+OyE5kmbt8QrYbszlkeeIIrXleX+noeCZ/jRArvtlJT3Os7zi7pexUEsITvvclCz02Ft+1QbbkeZHp8MpelZthAZ1d9S4ttCc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:05 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/10] net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c
Date:   Tue, 23 Jun 2020 12:52:25 -0700
Message-Id: <20200623195229.26411-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:53:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0a0ab56-af18-4db9-46dd-08d817af0b97
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6101BC6249C0176AD9028AA6BE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1zg+Bx6GtumAgzxZ7Dx7EMhVQ7mwSiO7/dtffrrV9pNcM7vdytsDYOmpbvfXb9tcnByWSl5Df8AS2ekIxEu2tE2fye/wHLKa4FU9VGf25e+J4O9crFIrhiwhHiVFHJXcMOmYm62bbWpviJ7h43xYEknnd4V7OiOH4KY01iibPxZePRWZipeIYOcU4ewoe9CsvGqgW0uJvWbi4pdf6/3fXR4AnjsJnwPNUZsWLAb5maKJtOsH8DsFZ2JLgKMIs3kf7YvB2mvc79aIrRUjDqHAjD4QFp7HvhareiessvhV1ir0yN1LIyrIrEJWH3YMmPi4RmQiObIwgmtYw+wj+BZZ88Rlg4RBAhSqaDfDq3qTfbJK0VcybSsZNDFdRKKiTTun
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ieLqGrYHRLLPo8ycIVjPMGQyDquQOiRmUIxvAj4ycP4YuoSuRHvNVrlpX/3MJbgmZUkTfsC1qfFmijABxE8jUm/hGADRMDHhWPxvZccvIfn5ofnp000r5fFnPW2CDM83yUXKrcHi+EIn/lfsDTaK7wfE0+wiW21gT8iLod1rUAeGYsYaA0NojH1z71zab46pgEgK6TrHsSa1wnY/imkkLCb7tQWY7DAFUsmmJc3bF1PwyctzZJU1gMRrYHyahIDTLcsFCxw0HSyMG0OlcGxpFandY4MuvM2YYRWvurO5U3/T7P1DkoQ8O1n+PYxYWphWz7URbTnbXMBjm5mDKAFpxQNXqPHjOD2wB7kk6H73zVhOuk2qr1jEh7zrZl5sE8TO5xRpGYjtmaQfJodwZF+lIciyuLroV5KITRP+Sgmfxi8XLEhYATX3KLte0j+wvGjXLlDfPhT433HE+O6/1P2r36z48f/LI81+LCI76BIjB8w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a0ab56-af18-4db9-46dd-08d817af0b97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:05.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+9trktsLEmNud4AYMRVQoZlmjlfVLaQpE/i1o7N90egm7TZ9XtDv1i79MJenx+LOZ/WlkOaF3AL7NPRVvwmQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

After the cited commit, the header net/arp.h is no longer used in en_rep.c.
So, move it to the new file rep/neigh.c that uses it now.

Fixes: 549c243e4e01 ("net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c")
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

