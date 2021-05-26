Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2365539143A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhEZJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:51 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:12576
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233728AbhEZJ7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLjYvPv8bIrqD7hINYjbAppa9y3GsUldZeBsr+eD6jyjbvwWl8Doi/x6YFFRpmr+/4b9O+D8R05RfX8SIZZuE8ckMB/S902CmhbcQPgwbBbowqYa+hFlBk+7iXOSCLRShAV/VL0+f+L2PHcshFWAGYpDPCickUs1Ls8oPpr6PBOZst7McxzHNIKbnBEEhQrkuyVWZwQBZq/XLmYieTjSsVfuLIdmMSx/X5h71LwZT2OOVx6+vEMS87Rxir12s2Kn0LFg9MnE6fqpQSgIiHR9NFvK4c2+jRSmnbwpd9rfLc8677LYzSUV5AIIKIB4Tr37laIwHBSWaNa1KO19/xyygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSo3G/SuWkPTSEBHC/GXh45A5rwT6sIQjXRYBwqHJWA=;
 b=hEwLUOZAUKCahwlPT6heSLpd69ne1ROsjctiUzKZytVs/aK4YH6vuq3wKA1KzojgUq9EV1K0YCxhfmDfiESsQL+0QTDCo7h3CDGDsxaAb/TJ3ebVDcI9wySehI8tYpSUKvD7bxxis9W39ftT/FsmyH+a8/tsU2gU9kVZXXS4Sthl9nOdoS+6jguNcUA1COz0Vbm8H6ehBGPX2lXfh4uGMHo0FUIP9pTradP3P6sHUBac8SIGkL8b5/4+xg7ez3qfM+B6RD5141WZ5g+2GzKNlahOkbLUjc9d9d9Kl0MVlUO87E4UDoadFezlAPskk/RBbRnfqmdpPy1qLV8I1xaKoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSo3G/SuWkPTSEBHC/GXh45A5rwT6sIQjXRYBwqHJWA=;
 b=PPzkAuumJ8tO4rGaAKhwWpMva4CnlIdQ0g5ME9ZQBUGIqp2HLmLsYmbQfbNB7qwHppXO98qo9MI6Czi9M1b0PPon0jdwDIAuIKdnRtFYIq7jWV5QGvI/tHvR1U57K93gTmdaEiUop0I9RtEXCzTl7WjSjM/WeB2IBA5MAuNJJoTpF5kYuggJCJWTBytbCWkxcudmYzAhNn5z259BumogKg2R9m7Ia5WqgC6ZfgiLOshdBHEnrMBcRremAMfP8vGkj0QtWdfcUBiWRYp6W9O9elnjzNJXYy1v75gkx6qiC5YJ/FS4UdX2phnunZKtnJwRrzJ47uRlv9HsOasoeYr9Kw==
Received: from DM5PR12CA0005.namprd12.prod.outlook.com (2603:10b6:4:1::15) by
 CH2PR12MB3703.namprd12.prod.outlook.com (2603:10b6:610:2d::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Wed, 26 May 2021 09:58:13 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::8e) by DM5PR12CA0005.outlook.office365.com
 (2603:10b6:4:1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:58:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 02:58:12 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:10 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 2/6] net: Disable TX TLS device offload on lower devices if disabled on the upper
Date:   Wed, 26 May 2021 12:57:43 +0300
Message-ID: <20210526095747.22446-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b610199-c39b-4a6f-b9eb-08d9202cc680
X-MS-TrafficTypeDiagnostic: CH2PR12MB3703:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3703ADBA62EFDF6020A0882BA3249@CH2PR12MB3703.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nkQApXsAEYdhQ8eJxrSKqDmsia6XDHWHmDUxWmGYSPgafDj4SgX6sNTxaYQ+SQo7P4cU2k9IJYTVbEaMEfwlfs+E6uX7+pSL3Y9bYHFwJEtt+NrKNPjVW5/DOn0Xb8Gw2H+QHQvMc92vgKqtL9JuElVjED2+QMpOjh13NdbnCJ27wVKJ9TTo/HAY5NZZJBVPeNq6CcJoK2lr1Ent7BqqnQF/v1ZqM44MTo12/00UhiV5Vf3dkeaqOvW0rLfj0d/CqpCwCqSDPXLtfukVMOerVSL/gJVWoKMS9EG+1BJeQ2KUvc+mSCT2M3LIg0zr5jer0oCdZPGYHF8vpbw/iX/G9Z4uGVwLmP8bKjLp6vfSCx0efk90Q2Ct7t0fO4F+SJbu1g+LbZpHpXC3ff4u6sOeiWOdhOMcJIrcJ1xC0klD0Cvsk3EWTaR9KRVkJf0lc48+k+sCosa8A7OsVY5CAFJ51ieUQiVH2SSxhgrONtzjedRuwkwo/AkJs5VTXN8Hy95dG+EICU8R+Q4CQ8nDTCbXEAB/T3a+0c3A5tea56VdFZipM0oTh3mP6B9vVPbAjM0Xx8yIYIPc7BYamBiB/6paVvUG0aR2XvzSGv/aawi2JNcvVD+8TDVnFQCUH9zr8aV6jJBGU/4qRs91UPwxB74fR++PJbYm4ucxCuy0JmK0Ig=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(46966006)(36840700001)(8676002)(82310400003)(356005)(6666004)(4326008)(83380400001)(70586007)(7696005)(5660300002)(478600001)(70206006)(426003)(2616005)(107886003)(86362001)(8936002)(110136005)(47076005)(54906003)(2906002)(36756003)(7636003)(336012)(316002)(26005)(186003)(1076003)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:12.9551
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b610199-c39b-4a6f-b9eb-08d9202cc680
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the control flow of the TLS device offload feature, the upper device
gives a pointer to the target lower device. All struct tlsdev_ops
are called directly against the lower device, bypassing the upper.

This means, the upper device has very limited means of blocking/disabling
the TLS device offload.

Today, for instance, disabling TX checksum offload of the upper dev
automatically disables the TX TLS device offload capability.
However, this does not affect the lower device at all, and it keeps
doing TLS device offload for all new connections.

Here we fix this, by propagating the disablement of the TLS TX device
offload features to all lower devices.

Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdev_features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 1a5f0c51bc99..0061c5b988c1 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -239,7 +239,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
  * If upper/master device has these features disabled, they must be disabled
  * on all lower/slave devices as well.
  */
-#define NETIF_F_UPPER_DISABLES	NETIF_F_LRO
+#define NETIF_F_UPPER_DISABLES	(NETIF_F_LRO | NETIF_F_HW_TLS_TX)
 
 /* changeable features with no special hardware requirements */
 #define NETIF_F_SOFT_FEATURES	(NETIF_F_GSO | NETIF_F_GRO)
-- 
2.21.0

