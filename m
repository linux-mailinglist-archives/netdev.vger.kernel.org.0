Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA026206A0E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388315AbgFXCVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:33 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388207AbgFXCVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV0R29c402rQKsIIw5yA3tADD6JlyQocF74B16tvD1IFmEkBktjGRv2IGs4gzgeKEs58knITqvtnFdW551uI0U7bhRuSuRY/lTo6Y14nnEXvmFWDVpwiqeRPaISbrvWWHhQioJI7PXiyfDyguMXJoNlFQFidknzRn6qcf2Mb9ea5XIsFBq9CXrbd4BlCVupB5+HvEmvD/37OIqaD1UMGx8L4LJbG5BVTHX0x4tzpsey2Cyo4WJEKv+02xY9YRdmJ2ayMMk6pzbezA839Do3NKlMLRwhFFDV1xEVFimy8AGi5858WzDMB9O2LC0DJdyh9MPeloM2L19HMJGO6Bt/E9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=S+IpA3eMrxqW2MPt2Nm/5OtuRYyEPrAQjGbMh82PiGImUYjbTlVKe0mvndvj9HWBbgNG2h/GBPJmzJRw7i/huRvo0NslGAzvvVTnAawXQH7ouWw2ISZLt5qSH6mtDvTimdpILZo8+rex48+yiyWt6eiDUf2LJLmbTDKPL/Mfby8S+MXeobIi2I/tSPX6wFUDKSq0FChdZD761Bn0ezuaQWgfHDY/BdBM5SIrWcRu+Qk6aQp1EcvvM+vtok7IE1gQIe6qfepBsZHLRZQnmuJv/vi8sZ+4xSYrZQbd30gQuwoqfkpqqjR7eozemNsB1XZmZmFqR2g0pkcNfnDWLBBX1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=LFWK6maDLva970rHmSJTVY5WB7A+C5bgngSmkPe1f+RjNfWvNFcRTK4ntHOSX1trVLeYSCFcBNQ48sDPWp/Xv0TdUtAuyZjFYefLbU4NYbPA252MmEIckAho1ZBQxtDHupl23crG2Iw44AZkdMOFUlDgNu+az8N7PCbh3OD/OSQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/10] net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c
Date:   Tue, 23 Jun 2020 19:18:21 -0700
Message-Id: <20200624021825.53707-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f361fd7-b595-4923-be8a-08d817e547da
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70225626483F22E5916A0A9BBE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6pIv1quLsfTcDpdNw6q3QKhVf4hCLxH+KMMLsl7baWtvPF/MLrjL73Ew6l0n48jvpKH+qmYIA+FLovm+0TX7SXZn93Jk/nltuzSqUBhidSdFu0LXg6TmR42wsFJnRCWjlpMl5YB6rYcCsYTTkXzopcI5X4wa2pT2YLW+OC71QuMjD7SVU7W+QeS6dZ3IIrHMt1cCHf/Wv8iWOFRdquC6ydVrziN3Eyf5wZhn9WE433vJPMehuYTgMZFvpj3QECe2tYW9ymD+hRn2V4jCiyOhYDp9IbObMahkwjQIMr+aZ9UMbECAFkbjQ8Fdfk8oJOrqGWmujuskAxdaHDngSV98jP7GZAhbb6puaV5V5D8rU66XjUjjXLv+AXPrszJBZGhH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X5ONvRjYJf/9oJ35Y/fDVrVYmH/KoCMS96TA61/0SkTj9zthL+metKcIXFY74dcnNd+piPpjzguqZIG97W0EPoS08d6jX14IwSKZ67V1OcX3ixRtzhGRKyDGXFDN570ymHiO9WYhZNhJwREFqLOKO9dxfFHzCGAzImayxSQBDNaKRDysQSOBRl8jaOQPliQ2U6AOxhvTKqPvGDvbZwfptJn2b9Y0xbvSk/NscoAb+YVcVmabP5HKI5CfNxWjmDICHvJXEPjr7L56augQ/Nv6oBAFRm8dMSST3ag7eUwVyDPBKFfbXEdGHPn6i/schH6EplaZ2Vdfaf5lcLdUV6jlgEDm2sd8ta/Qhq179myNk5Q9XcVXs3vLNrOltmgHor8gwiFaC0t6KfTFqSQ6IaxGWHn91lAljZS9huBsHsYgE95aOnpXQHIloXnj4Rqts4uYycsZR7OEFn0v70KAkux3cDRr0edpHSsJuEfYasBFnsk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f361fd7-b595-4923-be8a-08d817e547da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:19.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xO7CHbNL8A6nFPx0aIvVCQLjMwfrgHeaJvE+DtrWXldYq0gc7sTs3iCwCAy+8QNeGn9JUZ5rUNZyz18kytxsuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

