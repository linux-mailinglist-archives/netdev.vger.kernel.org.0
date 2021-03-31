Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FBE3504D1
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhCaQl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:41:27 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:44664
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233831AbhCaQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ed2VEQZV5WDmULLdDEzdZuQzfvLS/ZrkLTrmjhd/f3Yk1FWg414Zhp+DysTa2XEMVPAeBA+j/rTqPDunJ7pbXkE2HAyPXNV8eV/7ke284ftcPdlqGzkE9O2+a+NQ1FBbKFJc1XczFWU4W3UckZQafi+TCSR5mn7DN4sTymUF5AZkxM68Db3SyaBEd2jwgYPqrUI9MaKHU/qI2Cr1Fv0YNXuZAN9orJMwZ0gvd507twqvrTAWHXiIRaBktJDX6hDmKsmDTdklpI0XiH1/rAvhaEIq1M0pxCzAC2SbSO+WjHVEwjfXrGO0if2B45wVEKKFkVfDdfQkbjQnnaXT8i3w/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAgfJlHBH41ujJmuevTv4H8G2VdSKHj4umCyWXYSWVM=;
 b=esR2KAopVV9/IbLquFiXHNgZ4qp3TfWB+RRoeL+BlN0xoeBWCvBdhwXgTsrz8HOiF+PN0yOL6m+4epdnaiHEsJSevCVTOndJM0O5O1dJgeZalnPl2bZLWl/hRjlOhbVPZx7QpD/QTQBkDE6DT44G5GWqe7oLhjl4O+ysHCYbKCv/2CIx7pvei8LMfVHDR8KenURgtIQf+g7T2UeH1DIdDK2q8guhP7hDmUYXWBOy9QQuggsX6O3BsXzAwe/5047kcWy624xBzGg5ZzmUEZWDxRab1tZAEivjxIPKm8vy8UawI5LQ089B5w8j7bDGC9ShJdlVPKS5xyCBe+LJ3K7jCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAgfJlHBH41ujJmuevTv4H8G2VdSKHj4umCyWXYSWVM=;
 b=hyyvz8kUdtiZ+syGdOPiYWZdC68CU9obqfoZ8gt/kHyqByNMb9vwD/Wbp3Z/t8NgP4EPPsHuxta5ZTp5tjRU2TwD93AmdI3fwz3GrIklar1Usw2yOelD97MkhDvsPddNi12zJbQRtclDqAnlIKeILlbFV3Xxa0D2TBc+AaRRoSiRTL1Mph5T09XgTZUaJUZX+G7vEQGi20YfPlrFQ6AGu3SpRYbt3dHlLRf2OC4oz6yYjVf9Hpsm0VBpRCwO8d3YK4kSIDgBEbPVgUPXuSGrl17yRL9Qr9xu/+GIgfdGg5KLeU7tpuEUTc9z7DGsK6jXatGhZ1HL02YWdEL/KHSzgw==
Received: from BN1PR14CA0011.namprd14.prod.outlook.com (2603:10b6:408:e3::16)
 by MWHPR12MB1517.namprd12.prod.outlook.com (2603:10b6:301:10::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Wed, 31 Mar
 2021 16:40:55 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::15) by BN1PR14CA0011.outlook.office365.com
 (2603:10b6:408:e3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend
 Transport; Wed, 31 Mar 2021 16:40:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 16:40:54 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 09:40:53 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 16:40:51 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH RFC 0/4] Action initalization fixes
Date:   Wed, 31 Mar 2021 19:40:08 +0300
Message-ID: <20210331164012.28653-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 399337f3-cbf8-4367-8fe0-08d8f463c0d8
X-MS-TrafficTypeDiagnostic: MWHPR12MB1517:
X-Microsoft-Antispam-PRVS: <MWHPR12MB151792FEADEC67D00DDE350CA07C9@MWHPR12MB1517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +AnH5dihKCj1SRgAYPDVJbwbrFl05AZ2kIQNGsCh37xcnUCX5ehEPJRQ9z0LM33YIplSYlKxb+B9d3AVbr/6H1iEF4vergHqG7FYhyv0xZyssBsvq1Ph3iwDFRTDI8Po4C6yuyKL/s1347m6VN4oNs87R/+VlKzhbwOKBMFpLU9F6a1Ije6ry36Ii439EjqPSELbzKJ57/QGBXr8tFa6jRUm2M5s3uWRwqYXhbak6PmdTVkbPs+AySAzORWJKjNRUod+byc3KXeliVAkxNxcim1/3JFkB9qWlPoh908WllXPCrF3KhuFMmfSZlqKVZRt5wZ32qCUB+0ehdz2cgafcGmE/3YG9y39Sdbvz1ya1zPtIrpHOJVgKn17SckX06echlV1X9kj7FHwuuv5f1jWVaM15+MBf7STWtu8flXLO2JRBxBcM0+tqY6QpRnNcoZqCwwU3hFoMDtg5gUc40/2Vru9mo1oYqQARkgGJx1MqngFnBTGiKdAOsHpY24zLUT44G0Wih4BU/NhKwxSUb7qTaqsMHWjvmiteIlz6RhlKo6fUvTyfVf6n0uueF2pPeTJJ8Krtpm81FPVrfvI8sB2Fq1y4Uj0d9Ne8uK4kJXnML0jtzm+pd0vdm1/WA1lEhM+BRk2DTof/S7fisk9Ft/b+PsHdrXLKh+/dho80I2zGt4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(47076005)(1076003)(8936002)(70206006)(4744005)(36860700001)(7696005)(336012)(6916009)(8676002)(26005)(70586007)(6666004)(356005)(82740400003)(107886003)(5660300002)(2906002)(316002)(83380400001)(478600001)(4326008)(54906003)(426003)(7636003)(82310400003)(2616005)(86362001)(186003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:40:54.5563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 399337f3-cbf8-4367-8fe0-08d8f463c0d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1517
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes and relevant tests for two issues that are being
discussed in mailing list thread "net: sched: bump refcount for new action in ACT
replace mode".

Sending this as RFC to gather feedbeck. Non-RFC submission will probably split
in two: fixes to net, tests to net-next.

Vlad Buslov (4):
  net: sched: fix action overwrite reference counting
  net: sched: fix err handler in tcf_action_init()
  tc-testing: add simple action test to verify batch add cleanup
  tc-testing: add simple action test to verify batch change cleanup

 include/net/act_api.h                         |  5 +-
 net/sched/act_api.c                           | 57 +++++++++++-------
 net/sched/cls_api.c                           |  9 +--
 .../tc-testing/tc-tests/actions/simple.json   | 59 +++++++++++++++++++
 4 files changed, 104 insertions(+), 26 deletions(-)

-- 
2.29.2

