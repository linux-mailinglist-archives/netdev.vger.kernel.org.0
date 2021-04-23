Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8893691FD
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbhDWMXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:32 -0400
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com ([40.107.223.74]:19108
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242542AbhDWMXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWIm3ioYiokXMFgkldtIfVQ4XFpuaQgCPUeghkeRgj58D+PMIlm2OIEIfutZ/1AEXzWt38dXAEucF+EcFpD75eC/rhUgfSswkZ9YyTuErj94pCjl9nrB+PXpdpDTJ1TB7ftb7rNAM/Oi6PvHZMRnnJQ7JNTrJmcjQPfHMPURCT2CPJBlZiiuYrA0cS7kdqr91GCWwTrtg2LONh6DoYiBkDUtXV05A2HXSBC/++9N2SI+iFyhTcjc7IULrga0OiU5YsnyH/4522l9zprpeGGD8J/wd4o4u+++bH94VZhOf5A114zhAc5K6P3rHWTkqWovmIe3SfmRdaNbT7UEexWyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxNcMJ7AjsY3NXZShxR71YocN+B76Qtet5ZIV67cUco=;
 b=gkyOsETazQLfI+cAuSb08uW3tRzzeGQSjIeAv6CqzFZwxzw83e034mL4hJOwucp1wa0tGMP/Nr71f2zPVWLBT2Kq75ucFS7sJysDgf2nPiUMD9q/A3HajR2A3Ve6kXlRxT2Zq5NvRucw22xGbPKqbp4TfjJA/xMytcjjYqtmspmh68Sd2GRrAbDzyUzShg7VLLMwbWIY4a+s6I4FpIa70JiMl3Cd1bluZJyMerXI92JVp8V3X9Iy3Wp88H4dZxDJFLZlHzMPQwfh05AcRiUwc+OmlsSLjYThGtseREc3RNBQCCuBuYLBGTUEkgReySakRGzau55lfDPwkAtyoDjrqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxNcMJ7AjsY3NXZShxR71YocN+B76Qtet5ZIV67cUco=;
 b=quW7l/CkMNzLQq4sH5/TGrYtMkdJQ1NRMfVjLQGjc4Vnx0nD1It0z01Eaq/5eVaC3yQqsvmA1p5eHvX2uWFzBD2kVBkMBoyMqFD/jd2+AAG0JxbIyZ7zzjWVAEeYPYQUm/nvhBQ7S0G6zrKeAJw3W2IhJEfnwwNQ+ZB+kDok3Q00h9X013s4/yXM7iJE990pWp//s2XMHun0IwRu+PnQSB/u+vVfSfotz+heuhV3oEBQJ2VZsOYI9KvIQteDborcrLXPPvlKAY9y+UXF8q13izYbO/8x+XGeoq7GF8elrcKCTL3lWUd4Tv0RtDfutaDQTo00CbjmrbAW8j/8tkCG0g==
Received: from BN6PR13CA0071.namprd13.prod.outlook.com (2603:10b6:404:11::33)
 by BYAPR12MB3095.namprd12.prod.outlook.com (2603:10b6:a03:a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 12:22:47 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::e7) by BN6PR13CA0071.outlook.office365.com
 (2603:10b6:404:11::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.17 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:46 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:44 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 2/6] selftests: mlxsw: Remove a redundant if statement in port_scale test
Date:   Fri, 23 Apr 2021 14:19:44 +0200
Message-ID: <54a1517a6951c5bc84af3c2b5df323c153d04b59.1619179926.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: aa7df6fa-ff9e-4b70-1ef8-08d9065280ec
X-MS-TrafficTypeDiagnostic: BYAPR12MB3095:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3095F0E9343ACE0019D798C0D6459@BYAPR12MB3095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISjjO4MrVsQ8UFMq4WDNlY9ZOxvIg62M0xgDuiTPg1rUGRUUWfH4HSlrJHwdFtH9OUdq2seoVGdLelF6PBzXSfxRewxWidKGKeIFREEWKjPt5vfEfkPkIdJtAUBCMu16VT0WYCqfO9P82uhpUMaQw27OXRIe7m6c/Zv14XsRTJb3LPSVX5BzIgJvE7hK44jTSJEhyDyIP6vmIV9jeMlDBTmzBLFIQjzh/gp4r1MDk5/gf7RlLTfqRgwEiNr5qzAwNsbEtuENvFhMgFCmEM33TYEZEBnwhy1In/+kjo9IIgNS74CQu2QjXNAc3rQ/ZnyzrZw9Y5diPKuMm5/ZAl0fZsT5lGus+eIipes+ltoxCjpfCFOJA0iaVkdWphT7Tjnr/JyHuWyMxmKpLx5vTFRajvbDB7VZp8r2K9uyPxZSWFChlZIeD4ne3bOQSkE43WpPbPOS/+Gut8BFIROoAtDcwoM4PgLIrzG5p4DJDBkIbNw7ksKDKJR2IAcwhMgSSOjNecE0u1fBZGUxpQETY4YQYVvYvsYafnsSqZkPYcQPj/OrdK0HinYKVaYfyKKTIzrmvgLhaaPxl0L3q9IqBBKP6UHB0qY822slRJjLy9A8CCdtNI/SRkT/JG3L0P3ugXIZ+1gkQWvRqTwuA+qcv1XjCQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(396003)(346002)(46966006)(36840700001)(2906002)(86362001)(47076005)(5660300002)(316002)(8936002)(36906005)(426003)(336012)(2616005)(8676002)(82310400003)(26005)(186003)(16526019)(356005)(82740400003)(6916009)(478600001)(4326008)(36756003)(70586007)(7636003)(107886003)(54906003)(36860700001)(70206006)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:46.6940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7df6fa-ff9e-4b70-1ef8-08d9065280ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the error return code of the failure condition is lost after
using an if statement, so the test doesn't fail when it should.

Remove the if statement that separates the condition and the error code
check, so the test won't always pass.

Fixes: 5154b1b826d9b ("selftests: mlxsw: Add a scale test for physical ports")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
index f813ffefc07e..65f43a7ce9c9 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
@@ -55,10 +55,6 @@ port_test()
 	      | jq '.[][][] | select(.name=="physical_ports") |.["occ"]')
 
 	[[ $occ -eq $max_ports ]]
-	if [[ $should_fail -eq 0 ]]; then
-		check_err $? "Mismatch ports number: Expected $max_ports, got $occ."
-	else
-		check_err_fail $should_fail $? "Reached more ports than expected"
-	fi
+	check_err_fail $should_fail $? "Attempt to create $max_ports ports (actual result $occ)"
 
 }
-- 
2.26.2

