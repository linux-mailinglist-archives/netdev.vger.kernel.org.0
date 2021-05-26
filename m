Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23166391439
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhEZJ7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:50 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:7648
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233264AbhEZJ7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lswFct16koTUBT+5VbGSOevPpM9nksn5oEmo7e5Fanpba7B65mDIwtZ9q9xbHO+l/9Z2BUEpw+wx6sJ9occbnlInBSbH+9h0cMIbrgQt5ERbYLMzbM7HOyGCbdjpdT16OGITr5qxVOWKGXbgYguZCFBttJY6lw1Mf0BeGODYj/E7GlTUW+vQJYsghtO8ZqFWl66UvpBaJY72IBc4wx0y2A7O7KNMKG1MpKrZfAm6lq+loY0rBiy69Dh5t27UjIYo0MDicZ1udfaDvedkUQUaYaUCbXlBHg3Lc4bCxsH6/qGbGQ7vCMkVq/QN8/IFBvcDC5cuVbb+TiqteN4KQbO6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XzvUJqm9kbQ4S8OvilFXQU0ECjg2dIHQ13EJygsVQg=;
 b=dGN2TrJsiLHyukOPSEtrwCkcNTNFzyZJVt7ZoimhdIRfzXlN8lKVuvVhSkESfpK5neY8IzOcJtFms2RE7myrdIhwZgRC4g+ZK8PWdT5Lyd4klT/1PVSMHxTX9HGg1Ttp4Hd0fuu2LvHfhLznyGlSDhuFxu7WU6x+UrvSavyLRC0dBVWEsujRr/+gNKECKVzjrw0Zaz0RX6LCZsJ0yTVmrNxLsaGXp4k/eIv1qh+XyJLP8TXJ2FvEIeM3SsANLmSnUGH7OiJy4k8N35nPRw3wVHxjVsGNd6KhHxZeRWLw886UPflAUent9kxeKKb5UcBccZ2l5YGsPaHhZSACXbc02Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XzvUJqm9kbQ4S8OvilFXQU0ECjg2dIHQ13EJygsVQg=;
 b=CELa7qj0XJ78QInLPrjUnBIM8dNtiInVfpa8d/c0VVpDy4E4r8KyTOT+obEuA7te65OlDUDuPaCdK9qE/n2J0HNaxRxh4S55hrd3EwcBTXMDZdjnuDRijEi1AVibPQRg+o5nKRl1WZ/8u93cUSpLtAjJ70RNrGfDwZV7TUFt93aIBlil8KZtDjU8J18MuhPiohOwWsonT4i5FFsIZBdec49SPUPiWvz+1GuFj3nKYkfdPIKoRZsfn8eBri+AHHzqGsmHequ7gYsnTaLgPW3AXW3UZO8pUlR9Becn1a063sDmp8vnIKsc4FNFAj1CZ3AqaSERjGY0ugsL1H911H68bw==
Received: from BN1PR14CA0016.namprd14.prod.outlook.com (2603:10b6:408:e3::21)
 by DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 09:58:11 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::c8) by BN1PR14CA0016.outlook.office365.com
 (2603:10b6:408:e3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:58:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:10 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:08 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 1/6] net: Fix features skip in for_each_netdev_feature()
Date:   Wed, 26 May 2021 12:57:42 +0300
Message-ID: <20210526095747.22446-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6113a137-da9c-4339-b082-08d9202cc542
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28434BD56FCB8828290863BCA3249@DM6PR12MB2843.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47rk1Sf4Hx1gq39zKb8+1QGzCmwzFK83p5mCwifZvMCgHjzaZXH8s6t/jcqmII77uKlW0MSUhzPlzw5KSsYjtUlN1rusYwlF8+iYx+4cK9xq97JucXtErlQHKqrygzB95D3mydW6bVFAZL77pzT+HjlG+UwtH0vmRYqxMAZJrTn44+ePYR1JjI9XdAXHpo8CUW1IBjqI9H55IJP5NoGoJEQ7lfnTren5wCfcYf4i2sgMEIlApXxKdJIkA5xCKebBaEWWwwd7LtPVO4pJ51o1f3+byPx6KkmTxbF8Nh91AmCWTXS6P0A71hJNDHPvvOsEfa8ZQlvWYYjg/s2/BsPZOImVdiOVzKS/qxORRUxwCDFkQHtno/KJQKcQ919v97tnb9Rj2Gx55KtJ+V0+CSQ+CtqeQP/tJ5kJ6dCTS/X86VMtN+KrqLEJ4IiNGtCxYgY+8pGIvVYI6aqS/gpU9oNB9x6lWUZRYmOGp1KDdmPUtiAbW8Qb6VNwBN4INazhg4d9Al5aC1mXAsmYIq3ZsleULLi9Mg3dr9VZ6YIlUseEKiga8iydqrVX2zc/EpGUCHTqYffqVYW+0Nf1aZfec8GTwdp6/6F+IsQtDTsCGn8kvy9OWLyz1wjIskFqbA1pI/QelTZ3qgpiO6+VLCn1VPjnoX2JccjOJeCG3qCRg9G/eNc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(6666004)(110136005)(4326008)(478600001)(54906003)(2906002)(86362001)(356005)(8936002)(36860700001)(5660300002)(7696005)(36906005)(70206006)(70586007)(82310400003)(47076005)(316002)(2616005)(7636003)(186003)(8676002)(83380400001)(426003)(82740400003)(107886003)(36756003)(26005)(336012)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:10.7509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6113a137-da9c-4339-b082-08d9202cc542
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2843
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The find_next_netdev_feature() macro gets the "remaining length",
not bit index.
Passing "bit - 1" for the following iteration is wrong as it skips
the adjacent bit. Pass "bit" instead.

Fixes: 3b89ea9c5902 ("net: Fix for_each_netdev_feature on Big endian")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdev_features.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 3de38d6a0aea..1a5f0c51bc99 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -169,7 +169,7 @@ enum {
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -188,7 +188,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-- 
2.21.0

