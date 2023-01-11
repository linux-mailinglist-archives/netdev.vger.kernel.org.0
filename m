Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC766661FC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjAKRcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjAKRaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:30:16 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470E335902
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+/0XTKGVtlDH559hASG+4ZiWTVj8tOaWYQ21DLcMLuXZNln8LVzrD5Cr6Dg2IE50KM/9l1sFAHSdzKWannWf2vLTK+GR6cKXwP2izfhodb29lQiioNOhNgINRQbwhIwKVN2Xkw2HnNPmGsB5ns0saeB/QGm5qKJaosrexIfl5tg/g53j70uQVU4ythT8DsoKwe+bGfkyF7m6Bi3PxQF2YesGHAS0e737EUpZ+ovxX1j7pxXB7/cf3QHZeQyHTShrOzRex8djNofinX6h9MF83ZrMzAZdvZ+67DZH0y3uh2D7JwMoFnWOsvKbrqx0ztdKhsXCaws/7LiZ24tNJ0IPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wWJKHuCCL9QGEaJTWLi3jncMyKmtnMIq3/Bkj0E93Q=;
 b=ZXEay3MAiGdPegryQ3/eWegw7mzn00uQabeJuPz2lKTzSh2Mu0GCu/AXj7Xlblv4pRbWxR2bNXoRFzhseR5maODSz2l6LHEXXC2TF2yIW+EK1/+xY8HApW1QE9fAv9t/sbmsnHHSdH1xi4WnpcZMocAnqI0JJhi1xAmzWwK+sAjorlWJxXXVlYxM/ncYnxiRpZb5hyEB0R/sOHCY3cGsW4CHpn4TfMoGtkwvwVKvDw4BZC2BPCsjhA/q+tC8Qqb/uP7wy8EQMihAdExIccwTTcovz4QCv8m+elgUhLNkekEbQ2SEblViNIASCUL7kxNps/3usOvE9UWBw4r0LYgllg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wWJKHuCCL9QGEaJTWLi3jncMyKmtnMIq3/Bkj0E93Q=;
 b=euyuwOGYadpbooqvgA+cLw9n+tlazS2bVwEUVDfaxMmK+BHYV0Xap5tQEyEf8q4BBaVZKkqOn7rdLlF20mrGPOKPTiVWAq0jdcXRu9RqNK+GG3KgZO83Z+KemV5nOTK06CtUov4te3W4GO/2VnRKeUWToAPB4+SdGgzGargkjCg=
Received: from MW2PR2101CA0024.namprd21.prod.outlook.com (2603:10b6:302:1::37)
 by IA1PR12MB6554.namprd12.prod.outlook.com (2603:10b6:208:3a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 17:29:48 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::e5) by MW2PR2101CA0024.outlook.office365.com
 (2603:10b6:302:1::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4 via Frontend
 Transport; Wed, 11 Jan 2023 17:29:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 17:29:47 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 11 Jan
 2023 11:29:44 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        <Raju.Rangoju@amd.com>
Subject: [PATCH net 0/2] amd-xgbe: PFC and KR-Training fixes
Date:   Wed, 11 Jan 2023 22:58:50 +0530
Message-ID: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|IA1PR12MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e83cba-676d-4d39-507a-08daf3f97015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYdbPfnTsg94dEso4Tnw1vQrVxZ8vxGzSJetFjCS5RfpnQIKwhLtzsPo0XiCvLtmv3ZW8IlscJOJaBwqX9jgQGUcBdTRsVeBM/7uz6K2QDAza6haH4T/5guQRzB4zNUpWHRagZ6QX0jUgbH/vAiKkpYRpiYxsWx3db75i4Fm14uhS4JPcs8Mr7axSO3aacB1EusDd6c8vLuBflDmKIWiXY+bmb7rLcq1f4ksgBgzHkpX58LWkvE/JSYtgJquZosebCSHJwaox9m05G/O2/e3x2B+NL72R/oL6v44LosU5No/czs8qQspV0pTq8O/CUVsXDOJT6AdAV2NAj63tljbdvFg3WYAzLsHrGxb5MeJ158fXoc0j3L4W1G0Xjta6h9Y9XQRJfThfoWr8jjlHY/THt5BoI24EgaZTiRMqowby1ZCzxscEB+mVDyrjDrhwnhp87aapFHG5ucCmcpubD9ktsW8R2XgWodzH/uh30I89aK+RK1Qx2owUGaT2DXcx5Xuq6fVDGpg2JVfksQVR1VlUunv0ckGrAWeJ02hvN80u2razmhkinKawX8Yk4hB0kbvBBoSbG1bXEyiC2IrW6s4TV0n5vcDibqj+AA6BNVCA3VlA3UPtf+H94mQ/S2A8RLDCczqeTIjAhbl4w0A4RXGkgNt6nr6xF21S1aFURsUpODNaE/Mignyd+tDisVz8oEo6FPfP8+PhWu4lsnaklNLMlH3EAqUn95dFYZq5+6DKiA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(2906002)(26005)(8936002)(36860700001)(16526019)(5660300002)(40460700003)(41300700001)(36756003)(4744005)(86362001)(8676002)(70586007)(356005)(70206006)(6916009)(4326008)(81166007)(82740400003)(186003)(40480700001)(7696005)(1076003)(83380400001)(426003)(6666004)(478600001)(316002)(54906003)(336012)(47076005)(82310400005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 17:29:47.7791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e83cba-676d-4d39-507a-08daf3f97015
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6554
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the issues in kr-training and pfc

Patches:

0001 - There is difference in the TX Flow Control registers (TFCR)
between the revisions of the hardware. Update the driver to use the
TFCR based on the reported version of the hardware.

0002 - AN restart triggered during KR training not only aborts the KR
training process but also move the HW to unstable state. Add the
necessary changes to fix kr-taining.

Raju Rangoju (2):
  amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
  amd-xgbe: Delay AN timeout during KR training

 drivers/net/ethernet/amd/xgbe/xgbe-dev.c  | 23 ++++++++++++++--------
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 24 +++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe.h      |  2 ++
 3 files changed, 41 insertions(+), 8 deletions(-)

-- 
2.25.1

