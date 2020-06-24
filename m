Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19478206B61
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388832AbgFXErl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:41 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728681AbgFXErj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X986YY4xW+a+UmRSW+neATLBBLvyB4Ec8xHkmzKTUZsYXb1dMnl8ZEL8LBIChx9IMxB2DPdpPI+MFxDl9IezxOdno7pecMGG5N+B0Xmd2xNifzz38+WH7OzadgV2xD9/ZkN1YehjS8i2SxLORcptFAQTr8BrL5kq2Vpvja+rYA6igLYl4BnO/C881TSs4F1/J1ikm3kAnf7XHZdC0UDEXf0TM/bt4LRCTL8zO10f9cujReooBV7ZkmeogvU6+fJRckAErJmX8+wp26Zdibx5ty8ZQMiGLP/pZ4DzoI5ppaawC7/vrqro488+H0Salh1ogkL+PdM+PD+Dk2X8HYvrVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=VcQ2ISu176u7s5575eAqXdeTLdHL/wqQ5vF13Eqe+vv8/e+appVm/CA7oQhJM8WAraxv4znZUNTy6TpAU2Qrt1SVh0qcImEAU6pYn+9bbtgienC8nI7qbhxM6+zqnpS0HVPkWT0ib0kDnUEeb77pQeTJmlM7E5x72ZLVPKl01puhboAuGwuhD2YbcruvWXcf7ZhLyIimPUH7dIi0L2cmvtnjvbdsIiBEWWNgbURFe5twvl4mEm37NEt7pTS51NvCKkOye2BVnM6nI7iTkPR0RbcIbasGsnBL2H+cO1hmoRC0Mp5i8bn8tk05XNckKq/WfpU+pndl0fL1PfvpXWbd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zg9r5Ue4CW0wUqYgmYiV4zVImDOouDWcHhIUBBHv1vE=;
 b=ObdCJR8HebgfhJKfn7zCgIyfI/AQauFCiP3mmOlE3g3cZLpDnSb3KL5rlIKz74jgJleXj53qQnDX/NvjBhDllWTwdaD4VcIy+h0c+qu1bmKjtouQB7lEMuRu0fchCsSCvXrNB7Fi9o8QdnPIVZIjXYcjp+R9HxCX7WoI7/TJuFY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 5/9] net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c
Date:   Tue, 23 Jun 2020 21:46:11 -0700
Message-Id: <20200624044615.64553-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:26 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d84915e-b7f4-44e7-4b7e-08d817f9b257
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5135C81CCE95CB887E1E0D2CBE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbSjSY4l2oeGYFU3w16xkvO0s1nsTCHTD3UHBoVBVPr0a+YUBRsVyczRzfFO1p1CUVjPMwF8JEfxTximpRcsSX9WX50DNfR7DrwWUjEQVxGjJmtb2lDw6t32Y11uVnzxnMQvJBC7mjzh5UstCC8xmBRqZyrYCnL8Lac4IbpAOPKp6zXevGpMxbZs6s2ccL50Agb5HF7ZCsBBedkuNFdzHVbGGx0PmB8HzLCFSSzLjewifiC/fDf+0UGqLhEAKzgb3wjbaUQ+Z7MAGVyf3awTwECPYaRGy9Q0ll/7KJlCKKnuh/ewvm50F3nQWcOnMjzdvNsNMwhcPyD7sVNX6qLuHWNjd+drDJi6LGnz8XGbdi9qmNK1SepNIeNf/HdWnBXl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Pi11mXr/luNW8z0OqWL5iNcLr2w6VRGL6C7/i6igWF2y+shIcfslVyyZl175Qnhj93s7RqI7mdPIzlmq/Kpvu9Y5lKUcTidIYkdixAl70HxpTMHnIY4vhtQBKSOdSx2m0PVAUdzpLPQX+Ja/cNNQGJGmwhFc3b4UmaOQHAZhEAqebkIAXUxrYQ1d1n2bmF2yMHprEiNAbwPxlykup1caniaROfBRzJY9vhuHECS/Kst/cLRRXz3ss6KM//vpNqgjglooj3MdxFXv3UUNr2ZRjGmvSRxVyVSseUDajDW2ELpMdD3futC18xOjO/gDeGiCG7u1SgG5TupaoebGkF79T/6+R2bOrkCRVYz6Pqik+cz2xxKkDXA4jmXJ64FAdj/oZYoFFP+VquNkp1DB8d9kOGonqhXY53EWROS6a6YW5bNkKuEnvGTIYc1YmwF5WH2EvH5hbMQJT+wuLICAsDk6NR7ua+qaZwIx1DXSqv+KYy3ybtEwSDn2Tzj8YLwr2+7z
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d84915e-b7f4-44e7-4b7e-08d817f9b257
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:28.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuQOs4vRuC7cDdPhjoUrgcaLdnv1mn9AP974iJTkColjP20hn8yh8m6IU/nMgzJOxMe7KJfqTc1cn0AGsz01YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
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

