Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2753365B92
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhDTO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:38 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:3798
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232921AbhDTO42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTAPz9m+VJP62ORGbriX/8yHwTeXR9uAIl4k1sYjmBryeyw/FwwUsq8XhmwZ31appvdfS1oFB+J9ZhUF1m5wgnAqNY7Q3ky9uL1gBljKTZF03F+TKjrj/3P7lAoftyIw09BNBtDp9vDIC9arvblEq60BqLJbcQppBqta/uOu/NSZXToApNC0oTPI9Pf9qthWRJ8UA7huckv2d9rwpyxsYwy/dQu8ZYzwyjlmNQ0fuve0Sz5sCwV8gfuZJdVWY2EjnNvMxB+cLCuGqWqTWVZE6P2JH+Jg9ZVBQ69bU6G37BxpK+8HLI0/EpKx9+1negFUWQP9fD8xyONU2wE4/Gla3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r/1BfymZJgmUsu4HnHX8jy+rG6AsDC5bTm3aU2+Afo=;
 b=i2yWDgPWd6WryqU0z1pQgGRHpH+NSwgyoKbCgOPc7uaI8kkGdiC5FMH76ae1/b5tIktEOI8uUJL39odsX4UxsUyAWN+kXG5F7LW7q7nRhSS9ZIMF3paMIQtJoG4+58sIL4qwsv4+P+Eqv1MkPg1esxUOHwiqW9pIJN7uF60tErvw1eFpwmT9Mg2uCJxjRredtddTGDC7CHtSWr5JM/UtpXzQIWbDqbgIzD74iGxRKVzQINKJxC4VJ+KQTKjBnFqcph+lh7ROkZ213bzzgPdoTwFT5pcoxN80RBs1/BaWvqLMhaG1kRSaSOnwv0/HeUF7yJxVArY/BChDqHP0xBLNGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r/1BfymZJgmUsu4HnHX8jy+rG6AsDC5bTm3aU2+Afo=;
 b=TvXDM3vFu1OqLDxQHuIl/3TXJJIIOoVXznpyf5RNO7+PBAl4LSlNoQGmMOPOkcUkW/Ie+M4dKdavg7ejQ44VgR1RETzNY/10xpxvH3LFxgfLilT+Syv0ROL4Kc/0s0JrReDMOhbDjb5GD0DbUSn8G3GEd43kqQCyxrS/y91uRk16ZvqFYsrqdBRIcOwKaCxK0JwV+b84ypImssxR7z8MMw7vsUkyaZDo5DnWTZwh4yzDzclVKzNS1OC9Gp8Oas2/suV50v/MRzVOlq/oPRlu68AOhgCekmUK1bq7QIvuGMTjQ8Wu51rWhZwGvooPwWKmh9uxjXnVgkgkzY6pCSEolA==
Received: from BN9PR03CA0341.namprd03.prod.outlook.com (2603:10b6:408:f6::16)
 by BN9PR12MB5050.namprd12.prod.outlook.com (2603:10b6:408:133::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 20 Apr
 2021 14:55:56 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::81) by BN9PR03CA0341.outlook.office365.com
 (2603:10b6:408:f6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:55 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:52 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: sch_red_ets: Test proper counter cleaning in ETS
Date:   Tue, 20 Apr 2021 16:53:48 +0200
Message-ID: <1f44a5666de7cb9da7102e4b585d732814d51a73.1618928119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618928118.git.petrm@nvidia.com>
References: <cover.1618928118.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed80904c-c083-4ddf-e174-08d9040c669c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5050:
X-Microsoft-Antispam-PRVS: <BN9PR12MB50507D53388CD8244218AAD2D6489@BN9PR12MB5050.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UvBcvGRxpcXhRUKotFrLAvmr5WdNtTFKlIwst5m9N/Xrb2OJqwt8hxn5oe/9Fb4VkWxqKfLJYdntoFhnQsTjcvdFs/4PebNvadI0ZaWjslY8Hs2xnkCf1SGJs+jjLDoZ5Qy7Te1E5ItZfXMzNe4KS6AraAKrl0LXEXPzVNu8vJnJZ8dmoGLixd6CJZI9YIWH4iSE5t9qOl7M2f3DhQHLLPWtAWEm2am249U8lNGi6gOu/rj/NFn+9cG2hRwuFmg/mpiakXCjJvatHRh/GEyQ2JWMHaECoATfzhBVzlx9BFgacXrAQeuUkBhXkQb8qfmITR3hXvCRV3lM0v2ilqHIqcg0OkFWjdYAINd7QBrhwMYQidl0dIogAq2S9AcpYjk+njqpImsrf2gTSx1Y4AwQ3m2JLszYJ+uVHIMt3McAvorJNiOvbX4w9lQCNJYjI9hpBKYtRaSoYhRQqc7dv1pKRsllHlHk0SxwhEr3lbiOAw6h+AQFqUUgrCG9FwVG64eQ2x9Xd+TfkkbvNAlfEdpjjJJn4BM2nh50N4fXAbe7n7CSbgL10HxNn3S56q40Oeb/leIi8sLo5KZEC/n0nKrdtd6w+aiUlfpa8RVKH8FUwteVOzZkgRWxQXSQRcJ70+50Uxkf/xfSLUuGKsaW4mWdz7RZ3MpmQZo5uUtgzG0vRM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(2906002)(6666004)(36906005)(26005)(186003)(16526019)(316002)(54906003)(2616005)(47076005)(8676002)(8936002)(82310400003)(5660300002)(107886003)(70206006)(4326008)(70586007)(478600001)(356005)(6916009)(86362001)(7636003)(36860700001)(336012)(426003)(36756003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:55.5412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed80904c-c083-4ddf-e174-08d9040c669c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was a bug introduced during the rework which cause non-zero backlog
being stuck at ETS. Introduce a selftest that would have caught the issue
earlier.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 3f007c5f8361..f3ef3274f9b3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -67,6 +67,13 @@ red_test()
 {
 	install_qdisc
 
+	# Make sure that we get the non-zero value if there is any.
+	local cur=$(busywait 1100 until_counter_is "> 0" \
+			    qdisc_stats_get $swp3 10: .backlog)
+	(( cur == 0 ))
+	check_err $? "backlog of $cur observed on non-busy qdisc"
+	log_test "$QDISC backlog properly cleaned"
+
 	do_red_test 10 $BACKLOG1
 	do_red_test 11 $BACKLOG2
 
-- 
2.26.2

