Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114B205C35
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbgFWTxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:04 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387416AbgFWTxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3TDw7ZSVFQC3yLNC7Ix5I22y2wupinzzmQlkR1KL6NkN/qkuIII5eVf21mCSbqJd5w+6/UP/E3lQ8rspvr09qz2P45Y8N2KHrmr2TuRUDDjmxZzLjzXcpKxVjb5opv1pUGpMpB0PTMSHlSG/4jai1wTTSVI9l0Zlx5JkwCAdOyOb3cuJ8Q2DG154LV+ENoKjZS9BnVD1SfbvfNw64NqBHOlAXG0CTqObldcVCjggDDsI08f5TuvLiLoC5q4qIxk/iJJ11wJNU+8S04blr0M63bYgeG26EGCr09GBrq7rIqM3OQFdd7NOL5F98gsvaO/yB2mnR4GjoAk/Vtr9GXuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Znk5QwGW175BvUBP0Wht/sVVWuqnGkW98nuAdNdjMtU=;
 b=AQ0TjHYel8DUzlLcOOhfRfBlhzvxpizpzBYz+lbD2JULEknAHzFWg4n9jAhtJUx5vPGimd9KNMqrQwhqBSVut9gsK/cH0GJaDTrWEzX7ioRDeZa3RbVef9zVOaupeyy7PN45XqWHqAw93rHVqhsBXCI9DSNNSUafIOLqI7RWhbk7ZWTzdmsoa3bosbINM4L03+DV8tTckqUTye0b2EeH4toVBTQxC+0fRScVRl/6F8B9bL1R2BFDjOUOZEjoMsV1UBIn7wGDiF1K1+BJVrnltdH0sRKJy4ld9ZELmktd70X5Non6NU7VAMZZIQ2WWXVVENr8JjcS5PTzZrcGvixytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Znk5QwGW175BvUBP0Wht/sVVWuqnGkW98nuAdNdjMtU=;
 b=pHpFvSHJlABUVSV91kN6u4+SPDHwPh2KjgUnPzxSihGtHzKlI7GPrjg4yYtjYCNO8qaJcg8nQ4l3daHp8yqWJdA5DKXLPKoPSCfusnnbimYEmJmvVKkXFpq5wo+agcKRBbt6ZefgBccaK4pPG4UsnAO9D+1EACZNCf82+kFkTRI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:52:59 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:52:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/10] net/mlx5: Add a missing macro undefinition
Date:   Tue, 23 Jun 2020 12:52:22 -0700
Message-Id: <20200623195229.26411-4-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:52:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb49a555-96a5-4573-530d-08d817af07dc
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB610100F5E94CF6DFCF26F38DBE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QxekbI84Ro+Krk2scoENM3NdchStBVxUz0tlTBty24G+OOXOxLwPm9JRzx6nRPSHT3Hbc5o4svk5KJ36pPfPYb4XQ7j6qirehfEOVXlrMQnJa4S8y60ncIoPaVeyH7y41QyDo2p578iSgLE/ul7U4Lg28e92y115D+mtWuTDj6UpCeURGWBq1mm/SeYP7vnhz5omiXfuQYPoz4tCYuFNwuGOXXkSwYYwnz6scAYzp1slk0bqCwB/ba1UvKWGhKRbXnc9Sa3cFRCfsPmz2NZhOKZCIjgeSp//qSx8XSQ7rSkqLDzSQ2I51BBbf1q/1MoyTv+3RMF/4XVSDwAvKRrQgDTMJiqYv+g3dGlCKdan2x7dx+COQLG964a/2MEZILOH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(4744005)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G8iMdX2ZLdqfn0fH2/DH8dG4PERYBnTaS6a0K0mAo0/Tlurg9qMBXPa9sm6Kmy1estOMlJy7o1l2jR4RcDtGlvTKZskeSLpV+ZxNdTvjTRJymkPE3PxXCX+QB191Mi2vGBm6b/8iX0yig0sM57VWYg6/FMjimnIuBNw6j6j4t3ZkG+9exqwd1Ttpb4LAg/fBybw3t90pX8YxflaPLEm/osyzvQ/ll0qSm+r5fQ336+gQc5Opg4mbdxffx3rrPdenlJ/LfaZ1N0Dzcv4hGddMOtTOWCXf4ssD1QPTMyEhWzAJdGPx5GjbHY8xMXi21OCaHp1OXnoKNGEI/W3fWs3PmfiDTDOTFOWS20jjJ2OzVwj3VxkvsnLeZDfZZGBmPtcYNnENsB1U1mNO6tF4PjRoKQvzV5wJfFvWiQfWLlvNjiY28R6wa7l6J39pCiraSOCS14aD9B8smCddQ+5cZAJPxZXIimW004nQEF0U4T+n5/g=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb49a555-96a5-4573-530d-08d817af07dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:52:59.4468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKpjRPjxSN+3lZb+NhmiocLE+d40EUK8QoYiqjm+Mq9qBGHWM0SfpeAlExnJxmIk7tjJFdDzmbnUOnxqn2WJXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>

The macro ODP_CAP_SET_MAX is only used in function handle_hca_cap_odp()
in file main.c, so it should be undefined when there are no more uses
of it.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b658908f0442..be038ed1658b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -489,6 +489,8 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
+#undef ODP_CAP_SET_MAX
+
 	if (!do_set)
 		return 0;
 
-- 
2.26.2

