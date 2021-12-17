Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E7747899E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhLQLQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:16:38 -0500
Received: from mail-bn8nam08on2044.outbound.protection.outlook.com ([40.107.100.44]:4375
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232235AbhLQLQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 06:16:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K12Ky9vOi3FX8oYpW8aFx8kTZtTgpjDu1clbxSx1Mdig6Y0LBDaI8txloCfYTUs4m+qetg3XuNxJ7Zu+0pQzqtFnSzVoOo6ZNqUOYp5MCIVACzT+2Tie3n1OevntuYdaIkHeo9DjqRomJTf4uxpdQ08HllzBWC5cNtlBQFjn+WrnwUgOyG1N0DRVHCMTzSHv0rmMeYwSQNe4LJpnzig2ncrDN4/APysEHh97ZHJGFNPc9qg8KKlVPCUWMtt5AaEScPakbEvhL2965TfRbPeqqy5UAOsGibJ/+AVOWs9nSgEpe8EU4z0kbvQC/uuJK1uKG5W0A2twYPk46Pqh/dED2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO3nZ5PDkb1WocjNdpn7TCHMMn80jGBhoh/bKfmZhfw=;
 b=KRkFu66BmFnNkfpaPs5QvM34l+Hs1OT1yCte4yb24qG5CUAKdQ9F51mINYOKir7YUOxe22W+Gm2TlVfp+ym8LePk3FPMD6elbFZ1bSqz0ZHCyxJwkk0Vm0UOznv5Xln8vCIVj5KE9bDqP6qRMQr+7WrX1tpcfb57YH0FUk0i1bF3M+lN5EULiXypImD/zq+5eG6I27JhfWAmjJ7YML8QpsSHiD+JS8cxUEnXuQbuwpGnOT9+XAWVmU8zVYbnlOd3qIdB9ceOf1t7gRkJTW7DLeNkeklASZbF0MtYxtSmUxCUI7y8n0qGQaOLJ3UbOBe0KGM2rRDS6vkMBNj8BRHPBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RO3nZ5PDkb1WocjNdpn7TCHMMn80jGBhoh/bKfmZhfw=;
 b=16EPE0IGSJ9rIcQ7zCr/rZmbpQAFdX0CR79hZ+IPLbMpeC2IrLeF/4+O4o7cbnfkjXoBiRvxiqFIWvH8gSOvtmJuQfDkkXOWrn4jrshuLuo5eZKQXst/w3mYKWVEUp03iYpwimnTiD+Y0vpXmwUTOAWnivnhjYkPEJsv7MxTzCU=
Received: from DM6PR10CA0017.namprd10.prod.outlook.com (2603:10b6:5:60::30) by
 DM5PR12MB1660.namprd12.prod.outlook.com (2603:10b6:4:9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Fri, 17 Dec 2021 11:16:36 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::fe) by DM6PR10CA0017.outlook.office365.com
 (2603:10b6:5:60::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Fri, 17 Dec 2021 11:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 11:16:35 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 05:16:33 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 0/3] net: amd-xgbe: Add support for Yellow Carp Ethernet device
Date:   Fri, 17 Dec 2021 16:45:54 +0530
Message-ID: <20211217111557.1099919-1-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e2a7039-a3ea-4228-4da6-08d9c14eb035
X-MS-TrafficTypeDiagnostic: DM5PR12MB1660:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB16606294AFB9DDDFCB8B2AC795789@DM5PR12MB1660.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kkb4XqlksgNmhooUhbZwqzDYFWaLPcI67EvsSNyYhTVywe1/80dodmL5owJspM3v88euT3/82nqsX4N6nNN8ZSozcQ7+MaRaIoPmNae30sZW28jT1DSUd0Q1Ir5HdroZiL3p12+6zNqRytczE11xHVQkJA1bwzxdlUElrfY1xJEg8Dj98KArPorA11HRtUcRbFityrhj8i70/MVQRPpHeVhU/bTyk11KTy/skKdaBG3J+LJ9iREYyBy9C/FUxYiDtYm+et6I7J7+CAwkWVQZVB4NJZLtpvILvE8Tfu+p8tRrVJFifQebnuibOhGEA25oT5k8bwbD44Xtxrf3Lc+lNrCorZ+iXk4zWh89q5oLXpHzupl0KIBBgICygFUQHp8d/2Pao55++ZwQsrgF7KHGtTDDROTT3ChxW7HfLUS17IuKuK0Dg/qapx+ZqoJ74Gbg/NIAOaf+vZkpMTdtXDQYnnfoN85nnbRE+xc1V8nxg+XofDcRxwBx7+VXO9ac3nHWErYHCBlOIuOsFQECd2b+/yz9ZOTFeQ5Q6Kdqhh0ZTMqCN5e9kFehl4dLCOuj98UZ3E5vFIZMMRIy5AaHIdsguWI2iXoqwvukilO/lOB/nsf79Qk3XPfUbolQjA5/iQEWzQmwwRc6YGV4+BvwisJGzJiZ3wYPhA24dMWxpXygjZtms7cSI7h74SNoB/y07FUn61DlrbTZWEjSeaKPeAQfsB4PFw3IGSSK1FCV3VoOz3rxK6KU5TSVm0Lh8jL68s8NNwApqKick+G20+60A3wc2VIpPm4XfRj2K7mng7S1RVE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(426003)(7696005)(2906002)(70586007)(70206006)(36756003)(336012)(2616005)(36860700001)(47076005)(82310400004)(40460700001)(6666004)(5660300002)(81166007)(4744005)(8936002)(83380400001)(356005)(8676002)(1076003)(316002)(186003)(26005)(508600001)(110136005)(4326008)(16526019)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 11:16:35.6591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2a7039-a3ea-4228-4da6-08d9c14eb035
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1660
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

Add support for newer version of Hardware, the Yellow Carp Ethernet device

Raju Rangoju (3):
  net: amd-xgbe: Add Support for Yellow Carp Ethernet device
  net: amd-xgbe: Alter the port speed bit range
  net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  6 ++++--
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 18 ++++++++++++------
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c |  8 ++++----
 3 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.25.1

