Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F293D337BB4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhCKSFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:05:09 -0500
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:12768
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230118AbhCKSEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJcviD8IbrgarE+aA3aicg+f2nY0nqoBUgT7zHxDFm856pWk0Cce4fslq63SjXOP/ga71eX3OMGjaQatFclFt4qZHG/Sav0Hzw0qsMC9pX631r6AfTN8t0x58lHTW4pisQCAHNx3U3xQF6y/cZnGb6CTHQpNOBucLZdBfoLFVmBe9emGhU2otR4PExMnqrXoxm0JK8/bi5tPlHXyYg6ZdquhxotnxFdhvFNQ7RdjtnPCxBSY5txf/yv9AkVJAC0iaQBCHH5KC1/Tp5u6zYssUPw6iJHI/dzOlmieE6qPloXiXCzLj1ZJGNcGyLrtA4qOak9CxGHjN+FrVc6jNwz2pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rzEYLvZTdANOTab1JD/2RtYDQinWQ0ucwdxyh5s2yg=;
 b=Vt6C95i+FRMS03R+T5n+yn8S6uBfMuuO8Rd6C3Gmcx/QS1B5fyD3ujdzwIY1+gppeBse/IdCby9oXe2kgpIPmXuE3S3lR1lrv6t6FbZJOr/PlEj6vAKtJ3eozn6HdDkdz8fqotEN8DI/2DcjA+7Qpz/foFxopbOaRj21G3l5F2cuvgxsj78ELRzVj4eS5SqIh25/7D2rhytckv53p9FugX1t9eirJgo/ylM1MAdoGpdZ9OF6vKpZ+0Zo2P2aI+QMejL79Qs9HiLElkUtQugJR6XHaEamN06yxSr9JuBUn8COrwtHL6sYCJy3Ix1frRny4UieLQ7RVSCmnOn7cCtqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rzEYLvZTdANOTab1JD/2RtYDQinWQ0ucwdxyh5s2yg=;
 b=n4UdBy/Yn8iylXRhOSyyjtS7w1ahID2ieaNtaqE/g+mNOhxdXHLvED4DYOAHpiXN51nQaTisM8v4kR3G4qLaVIMvM0Twf6AwXBtQR55ZAEh2H1UBy7YM5ThREo2Eg7zQV2fU1xm3JWu05JMVFsPkqhvVu6LuQ3HDkvAsnp1OjTrG0WNXpzehOz/Cmc0iyMrZOjId8CnK2yyRztoSPGokacCNLGgNbOo5kdOL46HdYrOP1oBoIWQZWGwIkNYDeIYX3ZRF5gCDs3S8atAklsC12or2uexHJvJFlxG/ZeG0Gftzb2YJewa2axx91KZtJzsIuNx5fybnFacjch1gyR+eJw==
Received: from BN9PR03CA0624.namprd03.prod.outlook.com (2603:10b6:408:106::29)
 by CH2PR12MB4969.namprd12.prod.outlook.com (2603:10b6:610:68::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:04:36 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::62) by BN9PR03CA0624.outlook.office365.com
 (2603:10b6:408:106::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:36 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:33 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 14/14] nexthop: Enable resilient next-hop groups
Date:   Thu, 11 Mar 2021 19:03:25 +0100
Message-ID: <b253811519abc7764f9509163da4134830591463.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b4621b3-b0d6-4160-5cc3-08d8e4b821b1
X-MS-TrafficTypeDiagnostic: CH2PR12MB4969:
X-Microsoft-Antispam-PRVS: <CH2PR12MB49696351D0CEB9ECE473EED0D6909@CH2PR12MB4969.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CSIFplDbNCDzFFeGs0NveQ7UrpLRjYeo4DL0G2AZJgpNFbS9k7TeofzmajoRqs7V0lt8GLdnjfLlcE86E28X4TQrZGsEzYZuSbEsPnNRk3b5gHRKOoVr4IayHtufk2UqnxJUzwui0s8K0+xORWw0c/nxSknYERUstXVwjwAMMu5h63Bk2DJf1bemSd4xoc/ka6W/9tovA2/M/Lp9nSkZ4L64DUx/Cz5cEayNTC5aKHiKr06D1ZFN+zCD8wu8G4nYa3u+GCiqwBuKpcRsUXMeBPNiMybJyEbJhWBui6IRxL2isofL4GaazQG048hpyNhLlcISObZNf8G/5NWkqNHCubzy5Uli0qVk9wbypj45tpzjhoun9SY+NGAiW+4OqA/K+WU2f03auRoRNX8EPelStX6yRKI8QquKukABgTwGp0bpCHcCbnswLN5dQLOWMJpEPUnNSlcNHE81FCRlbP9Kw/OhyO5CU7y7PH+RetS1i8L6zBISV0KUy8hFWRQuz2nfqSyenGME+bBeMmZ7cqCI6Ulc2qbSwsAhbF8TZKK7LBp/ih1gKan8DHb8EFQJy1/MTHcEMUyVYMotoiADRaB3/I12k9uDgIyR3uWtpV9+B76cvPiurDbQf8spKNduXFHmJ6J5f7jCKClZg+olYLSgSSX/M8EqfMazs1kkjqOcWkIkOI4Gvu5kBj3XNh2A/IGF
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(4326008)(107886003)(2616005)(70586007)(2906002)(54906003)(86362001)(83380400001)(426003)(6666004)(26005)(336012)(47076005)(5660300002)(6916009)(316002)(8936002)(4744005)(16526019)(34020700004)(82310400003)(36906005)(186003)(36860700001)(36756003)(7636003)(82740400003)(356005)(478600001)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:36.0823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4621b3-b0d6-4160-5cc3-08d8e4b821b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all the code is in place, stop rejecting requests to create
resilient next-hop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 015a47e8163a..f09fe3a5608f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2443,10 +2443,6 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	} else if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES) {
 		struct nh_res_table *res_table;
 
-		/* Bounce resilient groups for now. */
-		err = -EINVAL;
-		goto out_no_nh;
-
 		res_table = nexthop_res_table_alloc(net, cfg->nh_id, cfg);
 		if (!res_table) {
 			err = -ENOMEM;
-- 
2.26.2

