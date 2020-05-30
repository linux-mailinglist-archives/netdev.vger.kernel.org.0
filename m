Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6901E8DD6
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgE3E1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:40 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728794AbgE3E1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EE3UXw96I91ICcj+HC4JHuLniJsPWzYyOwLzTyQi3Alg5usjcWc2kC2a+Q9hfJePNcSLTk9NlbbBY1eLf0Vq3e7nOeJTmrg2EUE/Bl1qr2WX7wq99I5lDDQw+RpSAM64qihO4HEQczYXpDPPbjJ7HdsY80Bmvq+zKjDVRYn+ZtTgSmuZfoaI/9iKa4hO7KtolawehOYl1pD8gR0nMbJhuXajVT2G3Q6zcMPw6BZYxBsLGEoCIz9WtnV75p7wL+OjgYFB+OL02ww7sEnOsLUAOuaYKDfhzxtRg7R35oVYuE/NqaqQJDu1adXxb5AGThYfjOzj7W/pCWTWGb9AOAgcmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMd9vbM6Z4M2oL4SAtc6uMC4E5Txi7A1Csc8yO/uJ/A=;
 b=dsT7530cSu5At0ylMymnfctnqN40sDpMbIgmxgik/Q60mKOAZqILxzr2E/SivQGU7dpxjdUGAxO1LlzyjcjmCj1a1JBehGmK4NIN3FBRwxORbNQbJxJFvYk2Sw4PHeKllHLO9NlLRqbAVF3xFMoxUAgPVru+tid/DgR/Poevm4GBRZrwnEDYDv8IYrVOEc1I35arfyXJDjz3xD+T1HP10G0lez02JGP+rwnYmX9mC4yBZ4KdGW+TJhsWfihgNvkT0n4NAjM69qw6YTA0MoTvSKpZF7LMmlbZJz5DNY8lXhi0DQONW+ERay20ivvBpPKOywCSWzhqS57CqCoifcgPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMd9vbM6Z4M2oL4SAtc6uMC4E5Txi7A1Csc8yO/uJ/A=;
 b=FoF2Djhrc5lLXEFIg4dmfUdA8z96+BsgLnJTkInS1M5VZuruguWasyrPnul7knYAbtYZbOJLCAS3ZfRWGxKafAJ7Fj0h7slb0Ao5qtfFPKwEoHUa6zS2yBPOxMFl1yV2FaJsRMGct0/a7X66BjtLNpyLcvX7U02jYxrBp72+8Wk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: Make mlx5e_dcbnl_ops static
Date:   Fri, 29 May 2020 21:26:26 -0700
Message-Id: <20200530042626.15837-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:18 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc95260f-21c7-4813-aaed-08d80451bde6
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408337412F5F40B5D15C800BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sHoFZ4+aOiBGbSQpgod40sRyOYhMC2eq/nwtreJihCIPAeIqVx70DLWbnYFbnwWdcSr8yJ/p5ssJvaW/S9BOmE73Gnq2hQCXO6kdFURK5mgR1fJZheo3Yb9cpcMhc/ULkxbnEgvq8PKQLyeKuY28asRY46mijaSEKeDtGkxhcpZRkRxE0xGJjaI8e2o3nrbEZPP7HN0m843LYI4X5qZo9HAVSa9BpyVaN/qomYBD1uGvhG2ho/vQ4BfQ6/reM24CCcGAW5KBynIGFTVQ65YhEYkNjnkyQKNUAYVQpLwR7CyhuZtq8rfwTH2ZjLkux3we7blHuId4RPbPMFGZ27eFVsDr6f/LicbsqqhBMUSEuo9Zoli6TFp/FJlnpMMAkKD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(4744005)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YQ7+4fl9PwCkl0KwqrZpLhgN6+AiC/im6xe9fxf+n2uk05YSEeEv0TD+oO2bLNsaVy4Oxlp6ht5hHH2dm28nNgnqcXn7UD7B6GMe7no7w1J0D+jHMV/kO39nHTq02s8odUvt5CFOPl5oePo8zm7L7ZkRXhVO7k6trJ/QP1xgkpaX6EDds4HmsMCCaAEAvZHzMpa/8CLYIizV/t4Ikj7g5Nd4CmftgtMO4vLXc2yS9KGwJjBOGM8/2h/vPCWlu3DukRTHB3pO5KpBYVgHBB7QJHxXUOC8DdJHKoIhqZoCWINLyiG72/XM3oEpbn8neBVR3dhO2S+u2YzF9sPEyb9CnGDN95ww4WhDU4tfu9VJOVge+R/lsEFn5QmQjX2tmiABgxx+cIrrNcug9y5535oUWYCl30QrDuH5z2q1gz9o81VsAPbIFHhaNYjNOU+mO0rq5ba9V+zKWIUjoeNLvZfI6ZzXcnji8Ael4pnQSUUOzQI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc95260f-21c7-4813-aaed-08d80451bde6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:20.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SsVNhr0yaANNVz+OtiREF9St+YCAsbAUjEpgFOsYLFPVhbuCXmJ0k5lg504HShs6CP6E8/D2RMAb36nMKmHXSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:
drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c:988:29:
error: symbol 'mlx5e_dcbnl_ops' was not declared. Should it be static?

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index ec7b332d74c27..bc102d094bbd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -985,7 +985,7 @@ static int mlx5e_dcbnl_setbuffer(struct net_device *dev,
 	return err;
 }
 
-const struct dcbnl_rtnl_ops mlx5e_dcbnl_ops = {
+static const struct dcbnl_rtnl_ops mlx5e_dcbnl_ops = {
 	.ieee_getets	= mlx5e_dcbnl_ieee_getets,
 	.ieee_setets	= mlx5e_dcbnl_ieee_setets,
 	.ieee_getmaxrate = mlx5e_dcbnl_ieee_getmaxrate,
-- 
2.26.2

