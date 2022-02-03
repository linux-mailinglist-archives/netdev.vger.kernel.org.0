Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D174A83BA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350494AbiBCMV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:21:28 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:2880
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350522AbiBCMVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:21:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg5XIfHUu8B+jpw3y1qTNR68l0N+JuUkgfETIcPpRLsKW7T/1VQoDWEStxoUNATku5jXz3nP4J1owSf4lur7/gNLx+1r5vLBTM2BnHt+KYNQoj06Dh8h1N8ZPAY3Ct1XhWpT0ll697g+b4fNugnoGDYIAPc0j3ko8WeKLssK5QIms7BWbfM+7Grs4jEsamTNtiduPLWQZhWkVurer6bmKtxp/erydC8pI3t42noqcwc6cBMeBwhVDcXtazdURnd4ZzQvvcT68wcz+OUcySnvu27aO2/kvU+//NxkQcvbhuJ7zb9HIRbH8FxcAXDtP49EwpH1hULz/nKiDoksKr/mOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUUWW/1Ob3dcu9fc1S443iI/+k6xyIuSs8Zirpuxnt8=;
 b=C2l6niZbmlgXLFLllsMnmsTa3azEqLbQ+mmBdd5BpxHUHNDQuULs7ksefujcsgEY7LfEqNkko5ZH1ezBycgGCcm4FWfsrgFwo1PDLRBStIOhDVkptKYbU7VuVlMH7RNIY+C0xLqPO8ISJarI2l3pDnt+suA2EvQBZYW5EPB4Qim4lnPiS+s4LakUF1gI8A7ndnHnqFz+VYQo29f8qodBxmbn/pWZuGXsnwao0E3i0VDqO5vtByma7flxUmndxMjgVr2kQovc30YNwAeawQqynEOlIMGn+kjgwVAnXWmJdC8pY+KhtD5RZfao+AshN0uuHqd+e/Zm0FwQL60gVNzkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUUWW/1Ob3dcu9fc1S443iI/+k6xyIuSs8Zirpuxnt8=;
 b=Y6vSnp5Mv+oLA0L6kLjSzA7/WgtPq5TyrWby2mqcRAKEBG+pw8zIkurSshyd+szMJ0y1YYNmq2ccnZ6cWuPu/DvqV6rHX7g2fwe1b/lGoCRfxlNPmCo3LUerYNghkrec9bfyVU8W/Atuj5NC6VIEIMlYAb7w0hVm4O1O/o8wW5XAvEtBz4S7Q6sa6DD/8dHWSvx3hZk0fZ98W/iztcp8miNtLzQxQSDAHdtsJceorJOR7ffbVWl43Ad04dRU4ZbDy6+siL/LcP0/vrBNaiGufZxp2i3lubufolq7E5/r6rMn85AShJGpyfr8XHRAiFJ5XElpPqr4q6nXkrADyKgDWw==
Received: from CO2PR04CA0093.namprd04.prod.outlook.com (2603:10b6:104:6::19)
 by BY5PR12MB4644.namprd12.prod.outlook.com (2603:10b6:a03:1f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Thu, 3 Feb
 2022 12:21:22 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::9a) by CO2PR04CA0093.outlook.office365.com
 (2603:10b6:104:6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 3 Feb 2022 12:21:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Thu, 3 Feb 2022 12:21:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 3 Feb
 2022 12:21:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 3 Feb 2022
 04:21:20 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Thu, 3 Feb 2022 04:21:19 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [PATCH iproute2] tc_util: Fix parsing action control with space and slash
Date:   Thu, 3 Feb 2022 14:20:46 +0200
Message-ID: <20220203122046.307076-1-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f519cf7f-7656-4c30-df39-08d9e70fb082
X-MS-TrafficTypeDiagnostic: BY5PR12MB4644:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4644250944E21F274F1B03F7B8289@BY5PR12MB4644.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hxjR4Ktop1wgCrIbCi2D02zkeogduOAyPibsssHH3H+tYgLgyWqkDyhXmoowYhsKHJH/jYigMVmjStbwmull9FcdwR7bMS1tCTrnaQ44rikUXBzKjCTFsJqplbYC9sDY2c1IO+cK0hEBogxnDAuWE2IxZJfV4SlD/kpoHrt2nPtYDnu/PAzTxDfVmW5Nw7ACXKaupd3UpbQZ//engeKc8macSPJeK7cBMwkAib7qDM/VkGV0+pAq/ZMgq0SEWbnlG9GCKQyhGjDBfSP+w02l8V/wBpfRlRLE0Bfcpl4FpJ0m1rvgav6+u83TXc0Qqm2NBPyv5JxSsceQ3HvYwot5iH3OP9RQrwbmR7BtqV3w5uviNEeXQkgscd7YtIhal52m+YP7Q2e3X3UB6JUpRbFHCfmZS4PLSSCMkO5vd/bHR1oTc/WebI91YapKH2Sq840ckd4YrvPQAg1V//4N89t5gYJ+LARY/mWCOekaMPUfLj6fz8fF7btF507KRndCoeS2J4+JPJKiiP5vzDOSFht63GQwBMe7fWk2mp5UUeJOivlp+udn0hM6xihHfB8N1fR403oieAG4ROb39X1MJmF6nA6birze5cRtEtpcGHLZaRhbwhmHBrLkJN0yiQ4cYhLGt2LzO/+VuFbeqdkO/MZTmf/b0NSo+Sr1Xns3ggyBD43NLI4E6YniYl/Q8Z9c0r60cZRNz+1dYRywz8FUMPAU1A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(4326008)(5660300002)(40460700003)(6666004)(26005)(1076003)(70206006)(6916009)(8676002)(54906003)(36756003)(70586007)(316002)(186003)(81166007)(82310400004)(8936002)(86362001)(356005)(336012)(36860700001)(2906002)(508600001)(83380400001)(426003)(2616005)(47076005)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 12:21:22.0434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f519cf7f-7656-4c30-df39-08d9e70fb082
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4644
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For action police there is an conform-exceed action control
which can be for example "jump 2 / pipe".
The current parsing loop is doing one more iteration than necessary
and results in ok var being 3.

Example filter:

tc filter add dev enp8s0f0_0 ingress protocol ip prio 2 flower \
    verbose action police rate 100mbit burst 12m \
    conform-exceed jump 1 / pipe mirred egress redirect dev enp8s0f0_1 action drop

Before this change the command will fail.
Trying to add another "pipe" before mirred as a workaround for the stopping the loop
in ok var 3 resulting in result2 not being saved and wrong filter.

... conform-exceed jump 1 / pipe pipe mirred ...

Example dump of the action part:
... action order 1:  police 0x1 rate 100Mbit burst 12Mb mtu 2Kb action jump 1 overhead 0b  ...

Fix the behavior by removing redundant case 2 handling, either argc is over or breaking.

Example dump of the action part with the fix:
... action order 1:  police 0x1 rate 100Mbit burst 12Mb mtu 2Kb action jump 1/pipe overhead 0b ...

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
---
 tc/tc_util.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 48065897cee7..b82dbd5dc75d 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -476,7 +476,6 @@ static int parse_action_control_slash_spaces(int *argc_p, char ***argv_p,
 			NEXT_ARG();
 			/* fall-through */
 		case 0: /* fall-through */
-		case 2:
 			ret = parse_action_control(&argc, &argv,
 						   result_p, allow_num);
 			if (ret)
-- 
2.8.0

