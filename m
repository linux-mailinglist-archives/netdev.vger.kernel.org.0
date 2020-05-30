Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992821E8DD4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgE3E1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:35 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dL9K8ZbJ/j2PPIchwolN2OlsMok2NZGubdPA3/m7tmE8mMN5b2506Ux5ACXzvBJkd9/eHsp1ZNh63dUJKT5+nuen/Y5Rk/DbFZuh/Amp2hS8VWDLjMjtC4jjYiBGz057QShloE0YboU0Kg1CQ4NteponZ1XXtPQ69DWsqkzEbF/p8F89tLyRrTFtwzW6lpwzCZCmlCrG8rbjSfFrSFgpzdFZBuaw6XB7VbD4Yi30fKn1FvZuWO5Sl2DXFLlqWz6M3M1gKE+cFIf01hqsTiNM8XvKws5moXVmpvmqCB8W2rlQX4FG61KjHof/WzkqL14MIqahRCdzjq0JbiOo2tTjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxlm2WM03q2RTaF1ZbUEihOnGkHtCSyNmPzJDEUqG80=;
 b=VGXZ1kUhDu3l7rM6TUtWWdn6Wrl3T5a9Oc04EhQOSXnZSbYNB1eCw5C1cw7XfNIqP0lSp00pajtdQ3yhPCiAyG5KTD25QinSBI7kxXQyACggcgN0RWcP7/tio7EDvqd8zHN0cMEgEYSMNsRKfKsT+6/TPiqgw/3TH8Qa5cFk7gXn11rhYeyHTOPl7+sZB7UrI3QOZ4OAyT0x64v0A2ZNEn55mLhD8fCPxZl2Fnt7Ge8zZv4nsNTjsZcT0D5/dg3Ii4guqByoYLu7fvEiwTEy51Kq0kFTTV0uqO0F5UegNndoeLeUSuzTtLBzNCEhxGclMw88frXshv3pVjheIVNfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxlm2WM03q2RTaF1ZbUEihOnGkHtCSyNmPzJDEUqG80=;
 b=k1ok/zGk/ufPOCImhD4gHJDBSOt/eRpkmHqT2Z95fcH/jXh6giNeC3zj4JqNsbanwedIpwasAfzLUj1Fh5tdArvsiNc3wLSSvsAa4UhxDrN/2DcuwvtLXxPLBJcm7cX32mc38FSUufjEv8B48EVWBanMOQPULoIlnuG9yP2hvD4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: en_tc: Fix incorrect type in initializer warnings
Date:   Fri, 29 May 2020 21:26:24 -0700
Message-Id: <20200530042626.15837-14-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93d75606-c22f-4145-47e6-08d80451bb36
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340861E17009DCB6EE75DA62BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R52aT1bsNbY0/XRB+vFUr2XWY572FBkWKYhJ4TUH7bJVjQOjwxSZOgSV7OgLiQUj8YETqj7PQbSNOiblY0WrMsuTsptCN0XcNPJXkmqsM12fv3x1hK/ZkROFvCX6UOGiRqsV0CMETLwNsPfCsq0Dsh39+USTP5SZP+TmxYp+SV1b8F999O2CFmRQMDbhOaWi76dREebmwCU7gyQIUSLo3UqkWoJ6uru9ckDDhXcz3Vz7hceuqGiSkQYOHMWEeD/kWjzcvfgCXr9Ec2qaVNWoyjAy6MDYDdkP2fkM12oo8GKJgiBjz4GrZyvZew/RYovY62bbBUBKuuhs21UuGRSKY5VhAcIdr5rFQyD/tMF0NmOEVgt7BmJX2vEoGY9g2UPM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(4744005)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kKHd1d1/BxfH2XdhWyBgZMHdZxtkRmY2oJTUZSnLN81NOUGbZqumgLo9YJwx5RGBWSFEx8nJqKcJQmzYaaMU06uC5IVaY2BRq6DHo3dNWUk+cDV0g6wAabe1iycxRoKoj8KSFywKwsY8AYPaTGDh+avdqhix61vLy9f2zuMaPEpOWO0DlMr5TyzPgqO7FUHYTJ5tap3yLJ0z9qHl1vW2JAf3+vRHcD6aytlNYrnW4fJVl+MUFZDaNv/mfegvzUBm8XskClXlZCgPcRoITWPiOkvrj4O2cwX3hXsNziMS6PT4qPxPf55eBbbow9fkWEqvf2tU8F5OvzekqCijtxhSJpf446LVRZu13q9JAOV7UTqmjMoDW2L9y5en2BhoX23QkbCyZ95xgzLIWvkmvHiqOLBazOzR0j6YIWCAe2/0pLUZNOgzUTKN87yhPmClcgrCu0j3zp1gn3VjHkUsYzWDevZCKEXyixjIKXK55DxgTQM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d75606-c22f-4145-47e6-08d80451bb36
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:15.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hEYKl0e8jBQPfiUOPBrCQMk3MGEwwK5E1W1iJABGyQzVRbD5tLI/6Sj4C3BSujZMrrJCxFvqDvc5K/3TgL7jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some trivial warnings of the type:
warning: incorrect type in initializer (different base types)

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ac19a61c5cbc2..e866f209f2523 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1873,7 +1873,7 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
 		    memchr_inv(opt->opt_data, 0, opt->length * 4)) {
 			*dont_care = false;
 
-			if (opt->opt_class != U16_MAX ||
+			if (opt->opt_class != htons(U16_MAX) ||
 			    opt->type != U8_MAX) {
 				NL_SET_ERR_MSG(extack,
 					       "Partial match of tunnel options in chain > 0 isn't supported");
-- 
2.26.2

