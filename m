Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37BE369200
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhDWMXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:35 -0400
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:17633
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242570AbhDWMXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwsihMBONP0c2CUwvada0kMPWaShqeDOMzMDN9UdLJqb+BfJwc2cuV1izG9qmPejPHoJfodc9ObCUsSKHUnUd+DQHRHZVcd/AcLCKHRS7D5GeASUcjV38RiOEbUtmlXiW1cWF0eYBRyNLZx8SRpXGoFiRT60YxsBI2wljxmLgi6GLhxHsS4WXvOqkrA8emWX2q6VIiUaJpJqpLSRGSt/rpcly3Wntw/jcUKtq4cWkaSZjGLN7t5yY6bkrN8u/aZORgm3cRvkj4BJY/GyNuL6E7SK8fGRuQ6tLE2PTHzwUriPidEAtGvFz2NQkeYwv0z1bD/J5KV2B8y5bb00Xj6FPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0S/4fpUmdT6IXxuo+10lCKIIHtsZgEZCGFNMZH6upQ=;
 b=SEBLCsuXx23FY4t6jMx2dTr12efPWm4ezQ9sUa3yuvmpScLZG3S7/UWwmlcFl9H8qkeT/6URVcvmlDXTw3O/Cov0vOXApFEZSBplJqlNBnjLnH35PYl5aAw6/FIEPBkbNVbF3R5ZeHcIA/3xXs6BSOapvp2ziWONhSKEoZudzgvCwehTRldI7kJ6bM5JiBTiOnb+nJN4/2zArhmoNfqAAPUtqdM3HQE6+99F10j31XiEwQHEfW45/ZDk1bplFxKf3XovG6kDA59ppRviknw2WyR2FV2Rh3u272rNjO//DiqKja1mmTQtlZ+Gra/CyDDvt91tEZo+82w5TA0J5Z/v4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0S/4fpUmdT6IXxuo+10lCKIIHtsZgEZCGFNMZH6upQ=;
 b=KUDvjY/uWrW3YZlNDdyhLfEqO38jwgHkrURUihWFi2+sW2PWwcvWwIb5oW0+MscK8eacxabKFem9CYfQgqkTE8FxTx1hIOYRGfm8dBgjxYJOkzOb3+Vj8Q99AO7JdmEeFLaF+qll1NUqm3f7jKHAyGKPfKYqkzSx5NKfdOTmKdJZo7erxqWuM01srMXgw8krxngkACpkHCvPcSzsb4/Yk+QVdXBN6qADbFGqLuScQpxruaq1vtj+QSmeQ1peiobP3gzfhUw7r/NPAhdPhfSTMxSLbrGk4Eo3de0PXqzDIFlL2vIlJ3q7EK7fJhoAYx2QiO0SgkvwlQ493O6vfX25Yg==
Received: from BN8PR04CA0010.namprd04.prod.outlook.com (2603:10b6:408:70::23)
 by CY4PR12MB1639.namprd12.prod.outlook.com (2603:10b6:910:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 12:22:54 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::ce) by BN8PR04CA0010.outlook.office365.com
 (2603:10b6:408:70::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:53 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:50 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 5/6] selftests: mlxsw: Increase the tolerance of backlog buildup
Date:   Fri, 23 Apr 2021 14:19:47 +0200
Message-ID: <d53eff3b2ec168f350195e8325f867bd87ad65e4.1619179926.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1619179926.git.petrm@nvidia.com>
References: <cover.1619179926.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10d7133d-bb0d-45cd-285b-08d9065284f5
X-MS-TrafficTypeDiagnostic: CY4PR12MB1639:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1639BDF4396EFABE7A60CED2D6459@CY4PR12MB1639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwhOimdzkUji9N6aNYErmRlT0U9xYSK3NS0q8LQaK3edDX/QfxLoFPf7lUR4dWlZ8ObzUrTr79JRC7gpxqdrpiSdryQ+GqumehKnZ/bPr/deieTTbeSQsf0uQvnxtdG7FWnDD64UMNZslpjhoGomaauIkpSn/zlso9lFJat2qO0l8etdkkwiiHOw04jsWQfyG9q6MDA33rfOhofDeb/8ly/rc8RAZHhrG+zeENBG2NWRIy9eFUkSEMQ7Jh+Er5qf7T1V4+MAd23pXE0kkYBcpn0kV2d6MKHkCzdsgd2hDcu9auWMjDBta1UpCYmljvA3s+l/tE3yNteaC2VfJJVBi/v22PVul2aJFhhiND9aWjU5wnFkaD9JmlnDxzJ3g+JBbQMBsPgLu3Rje5e7zUmchwop21uIpeOuehHCCefAJYtwfVC2TE+k1LpbezcB7w8YJtE0wB4SepAcv+Mn5/sbWimzk31TghAk5JA8/f4CYnS3E7kiyZ/iCEhfyeVwnCm0zZ6TidVFBO6Z/E7d0WlZ2/aVuw62f0xyozQwfQt1kt7KJ+kpHrDXsIPVPBEoOUareqivoNwmH1faThCbkYlXRm9RT7gzrbMTTxogwp9NfJmmEgF2iArMkp/sORmLaO3NgelGxS2HRKVUuIH8+DYbhgT8I3s2mFDNIDlNW+XpHhI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966006)(36840700001)(336012)(426003)(6666004)(186003)(16526019)(86362001)(5660300002)(26005)(47076005)(2906002)(82310400003)(36860700001)(2616005)(356005)(36906005)(8676002)(478600001)(54906003)(83380400001)(8936002)(82740400003)(316002)(107886003)(70206006)(7636003)(70586007)(36756003)(4326008)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:53.5650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d7133d-bb0d-45cd-285b-08d9065284f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention behind this test is to make sure that qdisc limit is
correctly projected to the HW. However, first, due to rounding in the
qdisc, and then in the driver, the number cannot actually be accurate. And
second, the approach to testing this is to oversubscribe the port with
traffic generated on the same switch. The actual backlog size therefore
fluctuates.

In practice, this test proved to be noisier than the rest, and spuriously
fails every now and then. Increase the tolerance to 10 % to avoid these
issues.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index b0cb1aaffdda..33ddd01689be 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -507,8 +507,8 @@ do_red_test()
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	local diff=$((limit - backlog))
 	pct=$((100 * diff / limit))
-	((0 <= pct && pct <= 5))
-	check_err $? "backlog $backlog / $limit expected <= 5% distance"
+	((0 <= pct && pct <= 10))
+	check_err $? "backlog $backlog / $limit expected <= 10% distance"
 	log_test "TC $((vlan - 10)): RED backlog > limit"
 
 	stop_traffic
-- 
2.26.2

