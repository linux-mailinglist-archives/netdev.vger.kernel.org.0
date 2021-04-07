Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C362735690C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350761AbhDGKHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:07:55 -0400
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:42848
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350662AbhDGKHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 06:07:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rvr7tl4Mr6cC6EMLsf0alpmvWC2jsyYkpPXQmwNJRFum6txnVr7OgpR6vtTRsAjAzmY/Otd9A5gjqOFI9Z4TAHqqAjN3ndgCXGBCBDwQCtwI8ietoU2mVCamH9ffxv80rAwDtjCy9O+fiWyBDTc2jkOXP3DSL21zkqHFIqrVt4V8RLYla0aoJtmry+MIHg/zr7anpQbFBGHD75bC6lZZD4sTVt0ij+wFArjObLg6jAoiaVSvj73PEKTf5/tHSQDjyjM6bDXBmkxubepkvPFX9faShF7rYRmu0GgLWAwo5NyUsW+PydmxwFhyjFVWVkFD756xqyQ2Oy4g9oCzY8cYnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qstC3I7mZs4DjwrHnXc9IygGYULAf8dD88aZ5CdijZg=;
 b=l+j6xuGqQLwf3ocGJJksScD7NVQZzC8jDkxOrnyzVhmpuIA6d3SPO/jzTmbpqxjfhhQFyaxyn5B92DKW/h9COwLk456rHzUlUU/eSzmYmE1/m5ORSZZEL+VGzIFqKKw0liPmPu/bTONK6++DIH3mb5Qs7yCpa2/r5nfpUPIk+YwdGW138sDbDjNF+lCvXiNxE96MHuV/mjKYuTv5KXleNfxWDQqzQmabaY9ROIgQsuxU97GX6i5Uhcxb1zzCGYSJJWygKG4n8X1XcHOYAwKYrt9aYF/VLuZjgNQ/oSJ+kTKLzFdKb0qsU63WUg38z5RV3wvREPQR1BblpezgPhHIvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qstC3I7mZs4DjwrHnXc9IygGYULAf8dD88aZ5CdijZg=;
 b=m4t8ojtN19LhbO4AwyXOO8Bfim+p4MQr/1jBxZrjPTwKFRQN/jUEm0F4kPwkrp+Xy/L4dcYZ98UjlxIiLOnrtRe0uTBqZrqb8nzFm0FmclTLaZ9mwycmRx/dyjC2LwEoXb9DNAOU3YqtIPDuU+zc7j1fIK6gY02IivWegPRE3+H2Dc0zRgSc7JMHpmLO7a4ajOHYfsvl3L1Ilzx/IDah06tB2Rm5lrHQv/k8l5JwLyOIoJBR/sbnwKh+rKtEQV7Zvv6cEb4rzFRmK7a+UpyQhHL6EK3AZMfba1NGWY5enmvtibriusDvQl5PJlKGgN9IAp0Jg+MckcCO+gHlIU33pg==
Received: from MW4PR03CA0224.namprd03.prod.outlook.com (2603:10b6:303:b9::19)
 by DM5PR12MB4680.namprd12.prod.outlook.com (2603:10b6:4:a6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 10:07:27 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::91) by MW4PR03CA0224.outlook.office365.com
 (2603:10b6:303:b9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 10:07:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 10:07:27 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 7 Apr 2021 10:07:23 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v3 2/2] ethtool: Add lanes parameter for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT
Date:   Wed, 7 Apr 2021 13:06:52 +0300
Message-ID: <20210407100652.2150415-3-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407100652.2150415-1-danieller@nvidia.com>
References: <20210407100652.2150415-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dab81e99-a8fa-4d41-6c55-08d8f9acf2ac
X-MS-TrafficTypeDiagnostic: DM5PR12MB4680:
X-Microsoft-Antispam-PRVS: <DM5PR12MB46801D4FA7CED8483261A970D8759@DM5PR12MB4680.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UxDqqajP7QA/DSZhyt43Wu5AnzDyEeo5qS27U9JxFZpaORts8PCPDhcFJEZ5t3Kln6PZmAKqhAx1GZ1P/e075ZqhQsxic4UNph46eK2P2e1AAs8RZv2E/zpipFKAeIR7rjRtfgjNoCAgUumnqKz+uVuNwShLEdUNeia/P2L1YwYtxj4eAmHaFi0l8GV0ltXMCkPH+9DiNGbGqFUOT2hW1rmhxwSGWwplVV7fypMzgUBw0l9RlcKYpCW7heBQ4HSEBT4Q5VCNd9cYgET0Q53v38BZhGeQopt+ngbDz2JC9vgQqoyxfGcbofmCtRlM/PeN4fjcdktbLwc6SE/ImWDVdcbH/ni23/RuS7gYNSjuGKzTiS519Ka6HzGt5J/TC3ZgbAwqbNbiJiWrl9zWCxWqhOpAUMrJY9Crg8kjSYaE5i0nf6SZPlWzntox8B3Hxzb2GD23fGqQNgiJkgvRqgH3Z+c3PcYbjDMmMlYAEStv/5Dxh2i9SVnJsDHVVi/cT9BfdVIR49AOfvANoIjSH7Sde4pMs3pXYy6080YE6UD0uAfsRh4UYfh0tnZE8bAGGR5MgiCIoQOBGS7qWM2V++GSHCuJOebFNgrL4sZlmDga4EELfVFugacNM4a8YoqhGKrzp6MVwXNvSRxYIeMDwNYBgXkm9i1ddIkwfiYkAz2HGo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(46966006)(36840700001)(54906003)(107886003)(36756003)(356005)(82740400003)(7636003)(1076003)(426003)(186003)(16526019)(36906005)(5660300002)(83380400001)(316002)(336012)(2616005)(70586007)(6916009)(86362001)(6666004)(26005)(47076005)(8936002)(70206006)(2906002)(36860700001)(82310400003)(478600001)(7416002)(4744005)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 10:07:27.2853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab81e99-a8fa-4d41-6c55-08d8f9acf2ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4680
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lanes field is missing for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT
link mode and it causes a failure when trying to set
'speed 10000 lanes 1' on Spectrum-2 machines when autoneg is set to on.

Add the lanes parameter for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT
link mode.

Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed and duplex parameters")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 030aa7984a91..f9dcbad84788 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -273,6 +273,7 @@ const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
 	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
 		.speed	= SPEED_10000,
+		.lanes	= 1,
 		.duplex = DUPLEX_FULL,
 	},
 	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
-- 
2.26.2

