Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1A47AAB7
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhLTN4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:56:06 -0500
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:54593
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhLTN4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 08:56:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZFjkuWKE7LgFquiF1YI3/cJ8UIfZCnf7ONNbDAmURibYmpp0A/Jtq40WCJ1e0x9pSDDVGzrp0LNRocr0TOxTZE25wE4k4UGzkXyhQzD/arMWQunknNKaLAVX8GK+SIS+TnZIqgY9eTAmDluMktmmf5/QmckG3tYvKrVO2KhBfUY17KoZz6NMj6Xy8E1Wr/ZUpuqfHV8VQ9Z6J+Hwodc/WjNgF3x3K6iL3dXdMIiqYsZ12TJgkRegrcaiwR2ZgzIUlzSB59DINbDbxftGacPVwfdz9qats0vTKf1CT5Lwag8I3+5WWOaQVjCxSE+XsYr45emH3hsJyiZd71M9KeMnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apl1F4pskgRjY4azEhap9+Id6HU1zHbY3sY/TPwWkPQ=;
 b=FCUXUNSiqdOHG8gFpzRls/PJgMt8d5HP0HuJEMMHGqVJx1tIX1IuV8szPuv0rj8NvqsM1hcyyCLzajuxuXOnl16UdU8wnhH/hVbtKgLd2Fj+FTCan70M3x9DQhP8qJnqSWIsBqev7Jm0xFknMBNCf07dmLdDzX3ghsV9sdEtLgpO/vdtKrvrz6YLY1CbBkCWmDlS0Apb6NcpVNOtw0d9x7BIAkWu0QlPhg1cZWFUMLTsEWsfO774RbJwSWsYwIM7K8Qu8ioZz6EL1tokPur/+yd8fd0RUEvJqPf9l0wDLlyixuC8U1lqpGm671i6kzpmrzgTTesmMVtVWvaf5tjz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apl1F4pskgRjY4azEhap9+Id6HU1zHbY3sY/TPwWkPQ=;
 b=VdPby7kl0M3BUMdl25jZ5l52LCLMqsccbeFIL/aczm85JbRhZE0sNdTzHe18gSfpClg/KhLj9seKkddahUI3JAYHBBugPrIqVeItTkFt+8U1tfDr3QUIFw6RBomOa5e053nr1IVGxeTEWFCOUN5XtqABeHFsxOeHdnSERXVWGd4=
Received: from CO1PR15CA0051.namprd15.prod.outlook.com (2603:10b6:101:1f::19)
 by BY5PR12MB5559.namprd12.prod.outlook.com (2603:10b6:a03:1d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Mon, 20 Dec
 2021 13:56:04 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::4c) by CO1PR15CA0051.outlook.office365.com
 (2603:10b6:101:1f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Mon, 20 Dec 2021 13:56:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 13:56:03 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 07:56:00 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 0/3] net: amd-xgbe: Add support for Yellow Carp Ethernet device
Date:   Mon, 20 Dec 2021 19:24:25 +0530
Message-ID: <20211220135428.1123575-1-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48fb4345-ab78-4d38-b514-08d9c3c0765b
X-MS-TrafficTypeDiagnostic: BY5PR12MB5559:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB555975E34BA78255914EC44F957B9@BY5PR12MB5559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9uMOkpwxYm4gyoiPGlt8oeU2+U63fWjW3ovZ3wCduL11ZimUD0joeD4rxy6zvbDYHL/K7aNgE7uG1sFU8p/r/wKBV8ICYDv1+N2Plqt1wS8hghG0qJFagGbKzgKQuzoN3P14j9YrYOxILESlbr+L2f6To1b+2G/aUSviP+xt2IWRFms69T/hzm3Whs9xHCPx6QnRLVyfoiOpS61HxAbw579pLjCowDOn7saCn1trKrUNI3XVQHQc0Qmhr1Sg5iGTkz1AvC/ABfT7rClxNEM90n7qI+KTbYbZ+ceh9zJmlgB3BSvuXCYsiONCYC6gzBJZdO1yMhAFyMvN6D3BVrSQZtF4eSLq5wyCFSAOPlrya3t+xNilo4z5FRCzk+00OexH3axRoH0ciCLREzScEJzmekT26gjK2lUEn/QU9h+XPVLtghEf56v6ZgTFt95YUjEnL2r3DY57cPyDpGxmeQ8/sM9lcJRkDi6ro+EI1fJiLoX169FFfA7PesnmRIZAlBGugKqUT6H8QqweKH6XF/mqlbjv4S1rq4cAiFVVc5071r1wBom59WGLoCoh7p2ulsFsG02yRKubjGTidb5fVRBeGnwXsfZLsbjQP2/h02PutsGqZWBWQ0sOK8jpsqwhnoCWYLZaN1kv21e+CtjzhFx6vCFtnQnjvLWZB7/dcvZpOToToUxo5/jD9GFC1kqhgoYV0h7guZ19+2PkDNKX8ty+Maa9n0nGAUyhSU8hPmBB9GA7TMHEdGsJ7lCYYj2T+xnj5zhiLatsGNAuA/Y1tSKbTIFlHhqgHWXiYAMY1ia/h3s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(7696005)(316002)(2616005)(70586007)(81166007)(2906002)(36860700001)(5660300002)(16526019)(82310400004)(8676002)(356005)(336012)(4744005)(40460700001)(26005)(110136005)(47076005)(186003)(426003)(8936002)(6666004)(83380400001)(70206006)(4326008)(54906003)(508600001)(1076003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:56:03.4932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fb4345-ab78-4d38-b514-08d9c3c0765b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

Add support for newer version of Hardware, the Yellow Carp Ethernet device

Changelog:
v1->v2:
 - Rework xgbe_pci_probe logic to set pdata->xpcs_window.. registers for
   all the platforms
 - Add a blank line before the comment

Raju Rangoju (3):
  net: amd-xgbe: Add Support for Yellow Carp Ethernet device
  net: amd-xgbe: Alter the port speed bit range
  net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  6 ++++--
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 11 +++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c |  8 ++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.25.1

