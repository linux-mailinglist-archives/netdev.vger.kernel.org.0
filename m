Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF53D3C17
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhGWOPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:15:51 -0400
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:12641
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235438AbhGWOPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 10:15:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIywXbzv40d5l9rOoFcSz8WSYRr4kO0UWelGjfCNbjLpfzyt3syHawEVWulGf3HX71x+zeyEMJafmbVK2aTlMqhaXDUQiH0/GIzJ9Tikde299lKLgOVsEwK+owUOZYNC4grLFHbFEXQBLz5grXZrPE9t0AW2Iu7RoTnIS91vmdh6LfSzpP2jEmGXzlv4Lexn8zYj371BQRGDH8ee5f/f+7rDlir5O3E5G2/ORwwXsFu/1jKuryhZfxmo9XfcHIM6XF4GOca2RoCvxkjTs7OS5xwtT5UGAf5hPUDeb3bCwuf89WGHLlKE3AWME5bVFRvn/f/V9uc3AYbMvJkBOGrZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvjp2Y+6+kf/7kdvC9SuA6txTqjufGMQltPTG2uSmz0=;
 b=asn/2QLP8IH4mOxf30KWffJJ4zJejpX4T2oS7FBjxZNVM3ZfeUkVeB+/2cgKTC1QRnJDrlLVOZ3JVWb/C2TFrWaLMT5+AkJ0InteRlrwrxKKtHRg9/C5UHexnkQjQLTaFBulxYWZkM/Id7+TCgqIdWT/4ovJ8UNRX18NpD7Cc3e98/BccRxLsi3RgVbvZv5KxMs/DOmLuMfaPH0b+lFz6KwNLluOheWTs0px/k1gFZePDngzpk6n79ZOUYKa3NTTEKwPjyO54hpZ7V/UIg4HwU5I/mG+JgrTMtMc+JPn7hi/8yOGkrB/vhDR3AEB89xPAeqqcV5AHj2A6FZ8iXq/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvjp2Y+6+kf/7kdvC9SuA6txTqjufGMQltPTG2uSmz0=;
 b=Hw4lxLz1N+kz5XurAM/Z3q3G2PfmfO1X4I/eCP7ie/Pbzpq5zNo+u2OWZsZ/IhIqpk4FaV3Bxmnx8KfNiZghb38fLH7scHjFdv+32bAiVLp6hGhXrbdopn4jaUYZWV5D51X0Crq7tyM6q7EJD1JSI6VBnr2uTFVY7kaqmignFJL0XbNt0KV+QY/qa7tw7821MJdPsujrTqwdHsDAQrenpavAxTRf8DjOG18waDq8NSBzI23VyqZCZva7K72Dv3wo5qXt53dCWmSpMg9vObiMH04uqN5Ezbb/eadnEHyfE/O94PnQcM6W37afZI4QNeaImlp77jS+N/fw31eu6fKJVg==
Received: from BN8PR07CA0035.namprd07.prod.outlook.com (2603:10b6:408:ac::48)
 by MN2PR12MB3021.namprd12.prod.outlook.com (2603:10b6:208:c2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Fri, 23 Jul
 2021 14:56:22 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::24) by BN8PR07CA0035.outlook.office365.com
 (2603:10b6:408:ac::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Fri, 23 Jul 2021 14:56:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 14:56:21 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Jul
 2021 14:56:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <saeedm@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH net] devlink: Fix phys_port_name of virtual port and merge error
Date:   Fri, 23 Jul 2021 17:56:00 +0300
Message-ID: <20210723145600.282258-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dec23aeb-e93f-4625-cd43-08d94dea092d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3021:
X-Microsoft-Antispam-PRVS: <MN2PR12MB30215134C569D6C44446EF65DCE59@MN2PR12MB3021.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYQx5ahNMuyM6JXH9Ptmn/wd6IR2wSgGBHtqiQ3U/ZLAJuSsIC2gaI+4R+6pKnpyG8vT+cUJiStx5Fa63AMnzSpvxzHQdqCjzjZl9wBdzxjffjSWmG7paDADYSr/h17scNzH9d3wX9qz7ZnvVqqm8bzqT2xlg6ycmzmiZcIUEY3XM77mEutsS3WI1nyuDKwC/JLEMGulwEiDNIckGR833cdLZA+8BZ/jBSfC04+zqH8IUodUCVrm7o9T1Et9ZCSqDBhJovbRBs63qv5fN9qv2dF3pV7OruPNt8k8Tye96Ii2etQpqPzyUATC09y0ogR2GgdiJmEUA8M7wuOZ62wuoakegZFsyJugmriBExjtYcNkpx/8l9DVPc1IIB3S95SigyG9hyko4bVgM9OiQPgAXVHRGMZdtRG2YyEwWWXufT0vRyrXNgt2kM6XAf0fubGw7GTuQh6P9wrnerls071coa8DpjB8UexighLRz/lTP++zqsGfLugid44+DEWujQhnlWICwdJBHs3ceQFffcxwi3MgvDiO0GMFhRCKyoNWF/P8nNyn7ymNb1dNInNyJ/xmjcyABjVieScbQMaoNLIUU595fj7fWX3bX7DwTzocghUeXNyluBYpB54L8anbYU6CpzvhOUPCSbqOC17QjZVt0BSe4XkhS6e2A2G6FZuCIaxoCRrtYGSPHv3emDsxWMwb773sE81nHDEuPEa977h+rw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(46966006)(426003)(356005)(4326008)(47076005)(70206006)(36906005)(70586007)(316002)(2906002)(36756003)(82740400003)(54906003)(16526019)(36860700001)(7636003)(110136005)(82310400003)(86362001)(478600001)(1076003)(186003)(8936002)(2616005)(26005)(83380400001)(5660300002)(336012)(8676002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 14:56:21.9729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dec23aeb-e93f-4625-cd43-08d94dea092d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge commit cited in fixes tag was incorrect. Due to it phys_port_name
of the virtual port resulted in incorrect name.

Also the phys_port_name of the physical port was written twice due to
the merge error.

Fix it by removing the old code and inserting back the misplaced code.

Related commits of interest in net and net-next branches that resulted
in merge conflict are:

in net-next branch:
commit f285f37cb1e6 ("devlink: append split port number to the port name")

in net branch:
commit b28d8f0c25a9 ("devlink: Correct VIRTUAL port to not have phys_port attributes")

Fixes: 126285651b7 ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reported-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 net/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9f386d8e4828..302a185fbe4e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9343,18 +9343,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		n = snprintf(name, len, "p%u", attrs->phys.port_number);
 		if (n < len && attrs->split)
 			n += snprintf(name + n, len - n, "s%u",
 				      attrs->phys.split_subport_number);
-		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->phys.port_number);
-		else
-			n = snprintf(name, len, "p%us%u",
-				     attrs->phys.port_number,
-				     attrs->phys.split_subport_number);
-
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
@@ -9396,6 +9388,8 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf,
 			     attrs->pci_sf.sf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
+		return -EOPNOTSUPP;
 	}
 
 	if (n >= len)
-- 
2.26.2

