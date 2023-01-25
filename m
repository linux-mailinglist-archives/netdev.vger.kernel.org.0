Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5EA67AADB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjAYH1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbjAYH1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:27:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BDD4B1AE
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 23:26:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haWEkSzm7oQ9hWgg81n5TaM0kjiyAISLLQqDiqMK06B01UAAEAMW5nijTWYthd4bWriPjx0g8FQQqvOYRXkHaNSO/Vi3jUT70c0OLDe7ZUDIH7WAaHANnDTgObEh6YY9yITZW254zc3LsvFw3q7SqcApllX9a3hMvD2SRdZqVIjF9+R/97LDc506wwygEiza70Y6VPB1x1TJMtx/Gi8NAMt7sdxvVb1s6gEtWhVSJZIX72eO5KWhw2dnDxpDv4BELF2N65/fHI2aOaCo7rFU/DSzGj7RJ3yT18vU//NUdanGkaDUq70N8pvLDHt37I/KjdIV5Ttlfao98cATpyiExg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Du/sSGL4PE9GBIXI1o7VS5UwFnNm2qPAVsgIWcBzQbs=;
 b=NWwbeo+j69kZV+cW05Ooxv2EuoJRbhXO/osBwfhg0ZwcVRCrkhyrisG/RaoZgR99BVa/wwMSRwFTCOllQOxMFJ4jWNvzZDFwM1YCe2AbsHmhMphTU58n9ponQW5kfxt6Bt0VcCvJOCSvsFrBu0RaxV722kRGguqVZ6suY6NwoLZ6896/+fbBTLFn8YC1MmU055r9ukKu7/0tA9SFX0lRzGN8xkrJG9W32XG2Pg5OlRRaHh3VzYgBiW4ZhFLE2ei8zKtw5SNeuuqTQx3D1MLax/41CzutT61or+mJLHOwmCX0iUaMBBZuBolBJ6CvH0fgmiRlnafuQgaZ6Yx+SWyKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du/sSGL4PE9GBIXI1o7VS5UwFnNm2qPAVsgIWcBzQbs=;
 b=Yc0H2+0OewYzqRj77OCZ/Nu1mHUAl8unaGn09XW2J36NNy+9l2a8spnelHKWZmdVdKu3aMtrvLqyEMIEiX1qAjkLDDcczqlDZvQl1GQ3Iof/EI+hC4xqIe1jj/+tUdc7mmiyboFAy7LLkYEyJFkdGqaNv3yIG8c9EfmgKnO2Hw8=
Received: from DM6PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:100::16)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 07:26:48 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::34) by DM6PR03CA0039.outlook.office365.com
 (2603:10b6:5:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Wed, 25 Jan 2023 07:26:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Wed, 25 Jan 2023 07:26:48 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 25 Jan
 2023 01:26:29 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 0/2] amd-xgbe: add support for 2.5GbE and rx-adaptation
Date:   Wed, 25 Jan 2023 12:55:27 +0530
Message-ID: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f16e175-ef31-43c1-8d23-08dafea5851e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlXzoazoli+VsQ9c411jhvcLJUC+UZr/46GrxkGWlL36dzkfYbNN6jfAdM1Rcv9TNbTK6uIj9gg4yOOgHjKC0VKPyqKTQM5ipIMZAQlLyu7AJNh4PBtxdZSQAqIPLwfN0g3uUrwMzBoTp5YTnmiT9eyPPyMBsxtFPRmKQdGYf08LL3pDIQ7U04okYG40DVrwpmX4wFWHHi3JkB+MzJq0rPCCfrmyMI8XrM+bCrapb9LsXpWRb7xBO6Un/tPeUYRj44FqGfyr6Jxho1CDVvgF8XsLm6O9ZxWFEDLzUrc2aQZ4cKUpr3mPGCoYhKa2vrZYCu1jZ1TBglfyoQyJ9AcuBZqjAvsJufsU1YXqwOfeiu3XwoUAAiJo7P+ZZT1DbpuvtJR4wTN5IumH9ebsdLGBlp0zkHaI3fHtXBaUcoyvSS6yLLxAGEOjN0oYzlD88ogJYTTIPtwWcNS7K6i09fT5el80Nhc6D2eODes3SFETuf3rgOrH6rZd2rZ8FUaKFG8tacZ129tb3p95qJc1njbxYFrZBCgjiqfIQFqgZu6Hzv4HIPnCsvlWwU78+NzgjqXoWxNPOGdOUmO6O2ABSXFznK6uZ0qSRkp3pkrKlCN6X2Tfhi/wtN7nqli/OTiwE4C5xzY7fJWKYFkeTbRGd8n+F5Kx7vNDGg1/gA+3O5v/kp0AjpNk08QU6NnGjyZliz0L5U1w9rU98Ho2y/zbP49pUTr0fIt9HN8pBnKxYBor4Wc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(81166007)(36860700001)(16526019)(6916009)(36756003)(316002)(4326008)(86362001)(70206006)(54906003)(70586007)(186003)(26005)(8676002)(40480700001)(7696005)(83380400001)(356005)(478600001)(336012)(5660300002)(426003)(1076003)(47076005)(8936002)(40460700003)(2616005)(4744005)(2906002)(82740400003)(82310400005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 07:26:48.1996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f16e175-ef31-43c1-8d23-08dafea5851e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for 2.GbE in 10GBaseT mode and
rx-adaptation support for Yellow Carp devices.

1) Support for 2.5GbE:
   Add the necessary changes to the driver to fully recognize and enable
   2.5GbE speed in 10GBaseT mode.

2) Support for rx-adaptation:
   In order to support the 10G backplane mode without Auto-negotiation
   and to support the longer-length DAC cables, it requires PHY to
   perform RX Adaptation sequence as mentioned in the Synopsys databook.
   Add the necessary changes to Yellow Carp devices to ensure seamless
   RX Adaptation for 10G-SFI (LONG DAC), and 10G-KR modes without
   Auto-Negotiation (CL72 not present)

Raju Rangoju (2):
  amd-xgbe: add 2.5GbE support to 10G BaseT mode
  amd-xgbe: add support for rx-adaptation

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  37 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 175 +++++++++++++++++++-
 drivers/net/ethernet/amd/xgbe/xgbe.h        |   5 +
 3 files changed, 211 insertions(+), 6 deletions(-)

-- 
2.25.1

