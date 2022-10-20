Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE10A60577C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiJTGnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJTGnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:15 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD1F1290AE
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bS5Z+dV7M3aBzOVQTmn6/AbYoY6UzIYNKrzctFu4miX3i0PgESxP/BkTvF/YIzLeKGuygc5lCF/XlPNnF/Z0PL+ES3vF6HV7eO5NY5UdYAKk4Ek4EiCVaW9erfJZgU3+iKoYDLyMsMtgv8FbNxokP2EZOzNNoBHr2G1N7go572HfeYo0SdSn5k1R+HdotRJSnc0JT1rZcN8sI8gBlb3VU7WSgnCsf9zrCFiOgYB6zPVC+Xl0nzHtM+VVu3Qa0EQg965KjKC7q7dx9BxHZHwdAl4aMdIrEJt8Kl4CAw1Afpm3Gjg5FRN2dYlLABHI+wJPfb8z9onFtXrZK2oWyGR+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wMqZZj1Vcb0xXWjbsjKAlUdg7GeRATJu0ACrVWu2mw=;
 b=fLKoT+CzhyQtgNhLZNCdYtNScga7kni//cXZ0H+PzP6y+7VGewUhKbCLXqKpql10uh71d7wCtCmXNTiV9cylkSPJHO/eo2JGl9cTDH1+o6ew23OfV+aoinGvf124d6SM1B0E7lzEoylVqlWFBKmW7qz6Ff1WQDWFDs8dNzeZMRPCreNJjt8NLJ0IA14bSWwjYpSpXuKTy0jAUKBzfO/PFYqljREM741xwhFzYWoz5hBMdyxBhaaSEL1wR8fD7Re7O6WCTWbActtlgKiRqzHjiBX/qiNKW0MuFC0wFXO708WJIY+aD93EGNjKJ7n8j1ZRv3RYKXBLVhBWzfKx/gAjjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wMqZZj1Vcb0xXWjbsjKAlUdg7GeRATJu0ACrVWu2mw=;
 b=D/9z6wQ90oO/UTlpolv9RfqpG2LQM+9rWoGuzSOCM4M81PPMxhtZw1c8AQeUH3FkbMMhYkEaAg0NP22CYdfyOoBAEyAeXePy8xDLm14lnhaX/jdHmj+K8A6Si5tJgz8OMlaat+B/NOIkiZZCh/kuoMPJQEwhUej9IL1abpYN3TE=
Received: from DS7PR05CA0021.namprd05.prod.outlook.com (2603:10b6:5:3b9::26)
 by MW3PR12MB4538.namprd12.prod.outlook.com (2603:10b6:303:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 06:43:10 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::42) by DS7PR05CA0021.outlook.office365.com
 (2603:10b6:5:3b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.11 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:09 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:06 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 0/5] amd-xgbe: Miscellaneous fixes
Date:   Thu, 20 Oct 2022 12:12:10 +0530
Message-ID: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT020:EE_|MW3PR12MB4538:EE_
X-MS-Office365-Filtering-Correlation-Id: 8882e930-661c-4743-ad9a-08dab2665a03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fHarTqpLGhHuQnwGFU9rYTqEtrsPmbvnqcc7rq1RlIuc+sdDySbHVR5L5v4XPl7ua6t3dK9qV/oGts/JQuBy+6MxAJJocW3XHIrDXTpFrnllkmaXz9S0dDhA+MoihPqTWTUODh7itWkeINp9eF70Rpgo5LVvf/X8hyTzUfCGpPi92Pmg/RMCBaGgstRgPgD85T3m7WHUvHLIk6+WA0QNSEYoywJkmddRXEPml3efNVU6l0WB28xLFSCvVisZ0JHHSTPNbDv9/uhNVyxEE0Wq3ivqpW63psYQ7qltxI2TXLkj+zKyW/dpySoYQJR8c7VnSi2c8eii3sXsL8ihKJvOJmN652JknZl1E5AE9HhAekmiaXWsrVoyII3s/YnonDDDgJgg29hDoa1GS8g8B27oHFR054v5UFsQ1m4NhjMjDq6DYrpBAFfRkvH7Yn0Jg07WhWwRhjyHtYxYeaEAwcwtsPN1Ze7XVX+xtqysir+1ApAMQ7cdiuvTHwRXOBYUyvPqTsf6ShNzJtx6qFHWq9J0ecCC77QZ+6euekPyzZODEKVA8xa4ogUvDJFjTv8fMYyOvGcjiR5iGyn+XF1I0bskeIegUYQHhKysT92D5WUifYuoKt2MVqny8oFF7ZWGidjUhP4jS94oDWgXRLpFvFkSbWXl1iIgExUddbBn+nrLxPKobrAxKzC7viZQEhaZ96OuZzplvzLl2c660+UOLZwRE236e8vMH+i7nUl7un11U/cgfeAtqaAomM8M4z0oHG9hXrMxhEa2hy/1sVhgP/V2KZIa5ZaNU8YRXT14UiSpmU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(86362001)(36756003)(81166007)(356005)(82740400003)(2906002)(7696005)(336012)(5660300002)(40460700003)(40480700001)(6666004)(26005)(1076003)(186003)(16526019)(2616005)(83380400001)(47076005)(426003)(36860700001)(70586007)(82310400005)(478600001)(110136005)(41300700001)(70206006)(54906003)(316002)(8676002)(8936002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:09.2320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8882e930-661c-4743-ad9a-08dab2665a03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(1) Fix the rrc for Yellow carp devices. CDR workaround path
    is disabled for YC devices, receiver reset cycle is not
    needed in such cases.

(2) Add enumerations for mailbox command and sub-commands.
    Instead of using hard-coded values, use enums.

(3) Enable PLL_CTL for fixed PHY modes only. Driver does not
    implement SW RRCM for Autoneg Off configuration, hence PLL
    is needed for fixed PHY modes only.

(4) Fix the SFP compliance codes check for DAC cables. Some of
    the passive cables have non-zero data at offset 6 in
    SFP EEPROM data. So, fix the sfp compliance codes check.

(5) Add a quirk for Molex passive cables to extend the rate
    ceiling to 0x78.

Raju Rangoju (5):
  amd-xgbe: Yellow carp devices do not need rrc
  amd-xgbe: use enums for mailbox cmd and sub_cmds
  amd-xgbe: enable PLL_CTL for fixed PHY modes only
  amd-xgbe: fix the SFP compliance codes check for DAC cables
  amd-xgbe: add the bit rate quirk for Molex cables

 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    |  5 ++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 58 +++++++++++++--------
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 26 +++++++++
 3 files changed, 68 insertions(+), 21 deletions(-)

-- 
2.25.1

