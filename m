Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0F64741F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLHQXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLHQXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:23:14 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B758C45A30;
        Thu,  8 Dec 2022 08:23:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfYaqoGCMKgM+PIxirjG7mARij2QoB2bhxjjgvHa46gxrvSaEsFgZKhxpp3zfHM7UQH6g1PEle7yxOqiAWI5FUFiSuW3pImC5yWw6eGLW3rm4Y7Av9JmnIvIqv3N5cGHDtnSY4rt1YsQuoBPtM0F8K5c5Rrxt0r4vU4Es1kjOQxpf+1Zu1+KnCMDwOmvY0OZtkbEjAhkDf9fqRGY2rs6IQMIHyh5EGqiwjJxC5v22Nflyi9bEEq6v/hE+j1hLanyEHLZ7MMg7RFZ/nHlMe3Xk0eiW+Lg3cAw1EpzUIGeEPSrm6j0xwjr5dkxBNkDk/42UGQD6N0pzKDSXYmtu65IdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm8JJSdTkjSjTmZq22MWrS28qNCU95/+FY4zoxpBUEs=;
 b=Ls0ZVrQlTR9WIDddF3DGWmotoOBwMnKSmwHBXY23xVcuRDgGbhXTt0xxZxQVxVENhr2ad0F9muNt9amQ0ioX1gdLxf5DiqgIrLMcDxD/hP+9S72rKhb92WIJQujB/maNzZAWgPbvJJFNKGBwvXylIFuaIVj99p/N+WjWHhBzx8tlENIBZ6I80JS1j50TA3cXrDpma3u8AzrDswk034EJte7rsF9bNBnhddwOyNKKX9KWJQr2o6sgY/0TfY1yNCU3GyO31AKc2xoWXdPOuwTSP4qB3Cvhu6jARPRaUvh/ds9mmtlf4YpC75BZjsAqQwywEp4zJ4Qz9iH9/9stCynAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm8JJSdTkjSjTmZq22MWrS28qNCU95/+FY4zoxpBUEs=;
 b=LBX0aSKiVpfkVkMo0bZ9hh8qJIezIn6vfOANy+X2CiXxilNBk4BZZcwcIaRniRUHAYz/h4DQg10ihKN7z3OVhcnsvHN5ue0a3fWRSw9xyzXIkonTZTNj+mPT0LE33dgRcGlIqpIj7+gHr1kt08xYGmnUTqXtwsDrQuztAkWgBsc=
Received: from BN9PR03CA0622.namprd03.prod.outlook.com (2603:10b6:408:106::27)
 by PH7PR12MB7869.namprd12.prod.outlook.com (2603:10b6:510:27e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:23:07 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::2b) by BN9PR03CA0622.outlook.office365.com
 (2603:10b6:408:106::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16 via Frontend
 Transport; Thu, 8 Dec 2022 16:23:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.16 via Frontend Transport; Thu, 8 Dec 2022 16:23:07 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 10:22:55 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net 0/2] AMD XGBE active/passive cable fixes
Date:   Thu, 8 Dec 2022 10:22:23 -0600
Message-ID: <cover.1670516545.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|PH7PR12MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 95789793-82c7-438c-6486-08dad9387d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dONnh9DOPJ53dHGnH/1InzMb4aG1qycha1Vn6xnK06X03I+OG4NEp+QSzTBliPYG7Z4kbJ9j4fbaXRApKzSBNJiHzFowqh54NegcRYTJTr9jPJ5p+/TRcEQUnmb1RpBdLIO4A4AHSeMHKPVThQDTC4mjE0qbJ47MH1VFiYJ7fQCkZ7SgenpNN8pqDsBG2nnfC4YJdagrD3GetBvqtNLH+AUNfnqWXami/WfKQJyHat9P8kJ9m8ojVXacMC2bT3wLk3KLRVYlwWznqJgT1BD5XtBcK+3lZBmaDbc/B4gtZlwheyOc0UJz+V169xX+DoOJdl8gRL/kp/R7tDgetYA9nU6qJSiLzTeNwsANndvwS2RyDUlxY3zU+40oNkMTM4RtU8T4gnlaOGVF1bgAZuLPmJRDVnVvJh5VayO3Z/K9vdU/1ZhIRUjb0CtRfTaQJ56NFrBwn5M88LmuSiNET/r2G7gLNzKnzQEeZSzzVXHY8EAn7fkgDrR51uMvYVNWGNQoxkVOUzHzA55owjXFmcdPSnqVKCCFU0DZrzD2XRdUlxKEUH+UYjZBj3ubgW12p0K1jvvF61xuBFri9T3oqtifhUe3pa4egic73mWkHoJFd00jXv6wk+WtnGW63XJ7cAD8gK/wSLltxJkaPuQiDVwcweSRd+ZdwqLdJjTmEYRn7HqkJBD3Gkx8fYK8uQ/OOBu4ZhHBu6yzoDlsLkuF9xzdqRraoosRLLCIn8Cpx+tva8Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199015)(40470700004)(46966006)(36840700001)(86362001)(6666004)(7696005)(40480700001)(54906003)(26005)(110136005)(41300700001)(316002)(16526019)(36756003)(186003)(336012)(8936002)(40460700003)(70206006)(426003)(70586007)(2616005)(82310400005)(8676002)(5660300002)(4326008)(2906002)(478600001)(36860700001)(82740400003)(47076005)(4744005)(81166007)(356005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:23:07.3429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95789793-82c7-438c-6486-08dad9387d89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7869
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some issues related to active and passive cables and
consists of two patches:

- Provide proper recognition of active cables.

- Only check for a minimum supported speed for passive cables.

Tom Lendacky (2):
  net: amd-xgbe: Fix logic around active and passive cables
  net: amd-xgbe: Check only the minimum speed for active/passive cables

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 23 +++++++--------------
 1 file changed, 8 insertions(+), 15 deletions(-)

-- 
2.38.1

