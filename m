Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7239143B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhEZJ7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:54 -0400
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:9888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233751AbhEZJ7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjtG4ionUQwXaA8HvZY1jjLTCLgH6rDIHHz3c8ld9ZKRB0FhMCwUU/agExh6zB/jn/KPae7NLBmyuhnYoxq4FO48AtfbcMY3OalMPUbr+UqyexPohKEmMeWwYJLcUlX0dHdPFtOpvRWZf6mZLwuP9gPcveKypzq/KrFEeKGMHVAxYvcoIlDjzwjklLsl+oZEb8S26tzeavjFapi1lxyab4w7cn+nYXH6oSTwSp8M5Ol/Zge4QQmLwew64JxiVOVqeJ58jwxgbGDkCQ8BqmA2EOMgAc5LMGHV5ZExMsQ1mZjpaZ/Ylcg+9VIXuV1NsfYtnwPjnW2b/wtHpvmtRwPoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZ8f/ILsypibjjcY8Ki/KTv9w9ZC8Nb2PwPEEkcjAyY=;
 b=DNxliqhXg+4QSGqR1d2LhC6jPCCEyOgiPUqdsFaBhXCy7JCJjG+Rug2f4q8DNhP0exk3g3W+DgDJaiWR2uBjPckCd6zhqVm5yvx9sLDy2eZP2w8s4pZQ/Welip9K+RfniIcqSH43ztNJgVZ/KMwjLUdyEhXcnHzRwUxeOOAQfUNHkOmUFfOmxTwQ38RyEv7dgX+6kN3DOw+2d4Pn0aAKKULnl9c7iEhU/bb3Ny1lR5G/+Ghbb6Fn9P2o6LFdc6TkRIdAw64szdDx5zd+l6B5cgEPiR1QNx39G6sR6mGL1ZjnXQmcRQfnSFXX3H66a3GIU8YCEG9wiUor0fTeFGpnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZ8f/ILsypibjjcY8Ki/KTv9w9ZC8Nb2PwPEEkcjAyY=;
 b=nQhPaEmec1Ef740/GoRuLP03xzYShyLjUBFJE8OPrvipQjRZMbisUSSiX2MiXrwt8Ki3gIlNzEwuJNHRttSfCWToToAjndWda8R+2gwK18nH87WLf2Qs0MiGlpBXWWER28/r+P81W8fdOE2NTVgPQR4y7HgYgR/l9qaMApb2kPgEjcPTsINJZvlrB1rxUhCmVF4aaEeILxD7HVZNqtvUJGrAuzsa5RdcyqUQrNgISck94yIAFFNEBTvrqNnsEEFBg/c98+dSBfmVR2gx5gKlwBZqqp5jC5qjysQSLFATBBY4b6VyVqMJnkaxqU7f7HcpTchJryPYOGhh9QzXf44dbg==
Received: from DM6PR08CA0051.namprd08.prod.outlook.com (2603:10b6:5:1e0::25)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 09:58:15 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::36) by DM6PR08CA0051.outlook.office365.com
 (2603:10b6:5:1e0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 26 May 2021 09:58:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:12 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 3/6] net: Disable RX TLS device offload on lower devices if disabled on the upper
Date:   Wed, 26 May 2021 12:57:44 +0300
Message-ID: <20210526095747.22446-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef37ad41-de50-4ce5-88ea-08d9202cc7ec
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53049EBF2BE4DB19240D805BA3249@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ro8z5y2/lt61Wf06mU2zH/ix+Mq21duQ6Qid3dlmNdj55GskIalEgWk6/jy5oXe/tR3QZqImoi+8KXZpMYR5y5iUNC/VP+LkfbFnjTvReFGXWZq6qQtoyLZz8xNagwuvXIc1EhivX06uywRoO3u3GKUxdNaGNWx3NTJD1/QpntxfuQC12i8I8e63+EUEH/M4EmZtKqrH2psaaXREDWCgr4RIdpA7JfEingHy6MZqz0vY5/C/pNAYqu83dvdjkn3sQjkGtdpW4ONyHBVjWFBXqcCllJ2xxeBaBesKFGI5m+EwUVRL3U4XVsXkhytkcpEn3e6UhSoU94Y71gw5PH3Cbn7w/7EMU5Z4vItAqiXb502vrigvLrWbf0x/PPzvyp4SKuZ9rhXTiCm3YP/w2L1jYFa/1vfMb2eoHBR/TUx0vtecT0HZD4rdoJK6dLOhCP/ZweN6KdCMoYhtK5EVXO1/qFEvHP54gA5jcSrsfeHqt/VPuril7itNVptzl1HmLDLcOy5YBn6XjuDXDou1o8sI/uMcgVEHIAHYTTTm7dqGZLD01tiIyB9ctypDJ9Vt0pyzwk8yxko/oLYBHbFr3QXn9ySGtMsXFqpy42UxP/QYWq/BuOHDCpIs7GaMDJD7qhra6kBLDSBiNHJCtjpTpv6KU2PEAqWJ9OCcLRmO+MX48h8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966006)(36840700001)(107886003)(316002)(82310400003)(6666004)(86362001)(4326008)(356005)(8676002)(1076003)(70206006)(5660300002)(2616005)(36906005)(2906002)(26005)(70586007)(7636003)(36756003)(336012)(478600001)(82740400003)(110136005)(8936002)(7696005)(83380400001)(36860700001)(47076005)(54906003)(186003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:15.3283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef37ad41-de50-4ce5-88ea-08d9202cc7ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the control flow of the TLS device offload feature, the upper device
gives a pointer to the target lower device. All struct tlsdev_ops
are called directly against the lower device, bypassing the upper.

This means, the upper device has very limited means of blocking/disabling
the TLS device offload.

Today, for instance, disabling RX checksum offload of the upper dev
automatically disables the RX TLS device offload capability.
However, this does not affect the lower device at all, and it keeps
doing TLS device offload for all new connections.

Here we fix this, by propagating the disablement of the TLS RX device
offload features to all lower devices.

Fixes: a3eb4e9d4c92 ("net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdev_features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 0061c5b988c1..a8b33313ad17 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -239,7 +239,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
  * If upper/master device has these features disabled, they must be disabled
  * on all lower/slave devices as well.
  */
-#define NETIF_F_UPPER_DISABLES	(NETIF_F_LRO | NETIF_F_HW_TLS_TX)
+#define NETIF_F_UPPER_DISABLES	(NETIF_F_LRO | NETIF_F_HW_TLS_TX | NETIF_F_HW_TLS_RX)
 
 /* changeable features with no special hardware requirements */
 #define NETIF_F_SOFT_FEATURES	(NETIF_F_GSO | NETIF_F_GRO)
-- 
2.21.0

