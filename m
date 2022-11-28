Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB7763B267
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiK1Tjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiK1Tjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:39:32 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FCF2A255
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:39:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqqIMKBFYWz0G1++LxCvsWQDFBtZyX8TaeH+/C3ZgoB2hy9M4cQXRJ8ORxFvQ94v1B4SE1lGwZsiTD6/QaCsDbwPvuAfUl1eJ3fEYb0Nhq34vaUpP0cInG0Sfdr0k4prKN8JZpn2c5du/jsCfwD1x96jOab9e/vYlYWEp5XtxHq6bKnhQrvnBLB0tvPqrg9L+5Tixccas2bLUk1U8/l1ZZc6vLyyA4ZE/lKZSDTzRCWWHXNctMh+3PJgGaAl3hR475tktSBqA3nbzrjKCujxC390gG50pOU33/r4kxxB4X0KQHwYgPTxZ3OqMr6BidccyQi5JpbVRQx6FNOL8xMouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUQG0OHGGrmYqE7rjy+fbNVYDkP85XD+O7CzDTDuzTE=;
 b=NxUkHKhvxU0c1oD6u4Eh4xhUma/RDq6RGqDkEZ1lhb1rmHulMZ3WR5cxhcwSoiYqPMDhSD0yTTq8MWdxYcz2sOzJFhcWxXerGGv2YPDOfFcjHRSZydVJC/N0K+lbTBxAiuH1aamfMxlO1e+sTzkUQb7U/mrgD9dUug8tWpk15SGi1qwQQ0Nz/IZwkTS2GsZLTT81jBvXP2ns8U6bxXMAXrivdgeDgCufLW4nuRu1t5EpeYSEcRfC3suixHgz8SAINpzu0hE3yieA0q0wPzUXnD2T2U1u9rPOpVDJG3IpVphkhW56UyFslLoHDLE5KC/ob+WsJjUB23LmIWJebp3F4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUQG0OHGGrmYqE7rjy+fbNVYDkP85XD+O7CzDTDuzTE=;
 b=QNugFp3K+Q9yk+/BlSxql64oLlAsLIIRX9d2GA3wxSUtoZRnkrZYFJlED1JWlpELjuwwpyji4GyBGJhEJuyHxqY5qgEveq2UMYIt7PaRJc0EW10q3N+mwxbtfdZVgW2QGrc/LzE9DwZvGZ3lVnePNbdnftlttyHFPQaO9qkw2n0=
Received: from BN9PR03CA0286.namprd03.prod.outlook.com (2603:10b6:408:f5::21)
 by CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Mon, 28 Nov
 2022 19:39:29 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::9b) by BN9PR03CA0286.outlook.office365.com
 (2603:10b6:408:f5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 19:39:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Mon, 28 Nov 2022 19:39:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 13:39:27 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH net] ionic: update MAINTAINERS entry
Date:   Mon, 28 Nov 2022 11:39:10 -0800
Message-ID: <20221128193910.73152-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cc01ab1-c1ac-401d-2b18-08dad17843ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRr48lCqOIvxsD2a+cZJWkCWE6BOCPtH3TdjDSzmz3UaF5vmwu+Em6ZLstU1n55+OJ2IrBfhwQ0iGaUPPIpsv2yVq2Sf2rmBiblAWJexDKezOs+cStX5jN1qM0bSuusQXt84m+CNbWPJeKHaDMf1XQzzYrsnL5VI/73u0/Sd8uqEpSA3ZAAxbYPtdQkmUDEDeWqYFx8Eyg5LuZyvhFCY31/iJwhaFjaPX4q+OS/nhnix6dQlgzPeQBGAIJmIl2rHiuSUFXJZ/TfYB+JF18EjGce9O1e38LjaRJRLzvsTTcadSeQuEVCsPyclT6saAj31U0Nfs8H3iNpqq592Jt8iSCQO0HugFn44m7lGMo8NJQqZqZnOqAwVFskgEhzpl4eCQYT6hzRcBbisgEin1rdIIfjjUv53twFwJkrPWRBMxNNxYo0qlNc38CulfPtq+F/c9no2mwOTkRPKd/yfTQMXhaKtErvg4JSYQvIOyEX9IQP3yh8fsdHb3z1lFyGKMt8llT6wnWJINfIeg1/QVI6VcBItD7kVJCbQKBCNYZzHeet4vy+StKxjaA2JeAHUFdv3ot3ai7Wg4PLsOKGGgUdBzBXUzgZJfctQ6wWOd167NXddF8GvEIA1uAmeDjbRmeh23429bXQ1attPM7SDt8XujxulAMFCZ8mGJMWzVlT4sZW5cAoQEXDUbTMJ/kBmCJtkj0xzTZ/DsajEpDf/TlD0tyz/PB3JOJHaShBvQB2KxC4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199015)(40470700004)(46966006)(36840700001)(15650500001)(44832011)(5660300002)(2906002)(4744005)(41300700001)(8936002)(4326008)(8676002)(70206006)(316002)(70586007)(82310400005)(478600001)(40460700003)(36756003)(26005)(2616005)(110136005)(16526019)(336012)(1076003)(186003)(6666004)(86362001)(82740400003)(40480700001)(81166007)(36860700001)(426003)(47076005)(83380400001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:39:28.8432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc01ab1-c1ac-401d-2b18-08dad17843ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that Pensando is a part of AMD we need to update
a couple of addresses.  We're keeping the mailing list
address for the moment, but that will likely change in
the near future.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 256f03904987..44f33c6cddc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16139,7 +16139,8 @@ F:	include/linux/peci-cpu.h
 F:	include/linux/peci.h
 
 PENSANDO ETHERNET DRIVERS
-M:	Shannon Nelson <snelson@pensando.io>
+M:	Shannon Nelson <shannon.nelson@amd.com>
+M:	Brett Creeley <brett.creeley@amd.com>
 M:	drivers@pensando.io
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.17.1

