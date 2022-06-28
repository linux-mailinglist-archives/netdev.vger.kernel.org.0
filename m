Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6E55E455
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346393AbiF1NTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346326AbiF1NSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:18:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE38232072;
        Tue, 28 Jun 2022 06:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol45hEM/KYtPb7PgavY29rZgD9CBtssqLLqDSLoNHL4+nDIZkxS6aGfyAD2ZGUDp+K+qBfyQsfcOBbuyDhZ9K4Iz1xKU3T9pkpuFi3w8weafPycpD+AA9JECnQ+DNmfWPtHpgqvVoK1E2i+2GgIuzjtjj7SLEs05D8bqDLiyoTuw5aX/OeF2A3imFOsJGoy3NyCyUWGhipGtS8i7Cy4JNVrCXRI/n9tomdkQ5R0gW5ayAHAmzAUfkQ7UMPqyj3g31DX7AiIfjnWtoR8Qpq0xul0K1cDkhstoCNKvVQFD3LNnGC/LaS+0/t35UZZEqhxws7dsW34NKrjS0dOyDNPrTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2UbPmcnfG8sMRTmFidZQdgh99g3UPf19YWr29qsh7E=;
 b=dWX6t5WyPrywaadkZXSkfpQYSss7R+PeoRlYQ0iT76qMJLJ1PXHNv73q6nqhn8rznMxsy/JpFQ3fEdC+lrf1bRxv7GXEJDJnHjulQWkW1c8lBQoNQu2uv3fhCNpD2CV3Q0XX30bWCWnuJKjc75i6VNNDEsG1ZbLNQcyywB2kgzaDZjJtac2ppY30Enc9qyqwnUr50vSNgqrLmlI9BxUbzfFA2y+TnUEvkxNBdqrFRTsyx0rn7jxrXHflckW3kIBdqtJXZcnwZqA7jXI/vAxoraMigbvleHjfBwr26FuWs0HWCxwEdhtnhm3nBhFGKfGDtF1cG4PdDNfqVd1Hln7rXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2UbPmcnfG8sMRTmFidZQdgh99g3UPf19YWr29qsh7E=;
 b=qpMvG1Uc0nCJwgSq1gV0XALBG7rtmpLz8RCwTucAEopjzYYMPFwT0MPkfl1t+KKPwByvhyX2AHOvOxWYY6EbLG/XhIT8Sg3qOmo2a1121jxJ44vy0aatn1ZBRjqHVZzPrRsc/LhnnP7W9mYB3vACDhYm8mleYUIl6lht6BO4Zn4=
Received: from DS7PR03CA0084.namprd03.prod.outlook.com (2603:10b6:5:3bb::29)
 by DM5PR1201MB0105.namprd12.prod.outlook.com (2603:10b6:4:54::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 13:17:44 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::d) by DS7PR03CA0084.outlook.office365.com
 (2603:10b6:5:3bb::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Tue, 28 Jun 2022 13:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 13:17:43 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 08:17:42 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net-next] MAINTAINERS: Add an additional maintainer to the AMD XGBE driver
Date:   Tue, 28 Jun 2022 08:17:32 -0500
Message-ID: <324a31644b29f7211edb13f26b5ad9ab69a7f0e9.1656422252.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c61e65-752a-4f40-a978-08da5908962f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0105:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ndLEx/nWUQMyCl9pfLNlvUB/rzy4dE7eA4VnoKvWkipFk9Jv8q8XHSfqmRcyhTPN8OSJq8Qnug1HSR0iRVLINfCdyzaXx8zlKzqhYVLpKMaluuOh4o+dG9tidGoaX7Tx6lHU8G69tXUhOnRAYJLGnEqnSLkqtBO4GtwOS2yQQKjvEnPzAykR8OqkAEyszp+Qure19qpM+VPiOzEXlow3m8npp2PfNsvzDO3oZtZTme5rNSYJWdJFPwPn7UH9Zj+afO5XJo88T5eTJ3xWJgsdM7bhqGzy6knAdJNFryapys/92BWu5d3qRMcrVr3ckrkhwJW7ENR5K+Pw4MErtxO55N69ITnmcbMEDfBOpSOs7B/MQppZb5swb0GDR17JWU7LN4v3KiJ/J8C5MxEt1+1Yi/BpMTO+uiqRjp8DNmLHe8WNSEVxngpwB9f6tZnesnKZHbOkRxx0D+nllHteJCGfH/jgk20PzY8gthXBNweDpWZcD5DZADb1UtqX0hFRiYiDzVDDbVw814Ltzd65/D4iofXP5WleOnB62GbB9EHz0vJk6xCDgRai67kLUDvuPinSwPTFBw9w01ORDyq2IMkCz+U3O0m4SD0hDIonZLiBbWfZocPok7y+Nz4YiJd206llrcg+dCQyD4WmONDugw4T0fMqVO3HW1jHKLoxOpu2D9w5bow44ATJdBzx0vsKwgXoIJUxCxLmoey0S+J7+4Pn+yrZaZw0vTRHSdvMkoULjj/Q3Uq/kyJPmDkEfYM+2Lhwn2Uu6SP/nueWoJHae8J4AHYDJKqIkz48fgtLypbog1tsToJwCqsgZkiGXbPSJ5Rls0Kn/Tnb9ri9oEv56fq8xA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(40470700004)(46966006)(36840700001)(186003)(426003)(40460700003)(16526019)(82740400003)(47076005)(336012)(36756003)(82310400005)(81166007)(6666004)(40480700001)(356005)(41300700001)(36860700001)(7696005)(110136005)(26005)(4326008)(54906003)(316002)(478600001)(2906002)(2616005)(70586007)(70206006)(4744005)(86362001)(8676002)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:17:43.9725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c61e65-752a-4f40-a978-08da5908962f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Shyam Sundar S K as an additional maintainer to support the AMD XGBE
network device driver.

Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 36f0a205c54a..02e0d0464312 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1037,6 +1037,7 @@ F:	arch/arm64/boot/dts/amd/
 
 AMD XGBE DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
+M:	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	arch/arm64/boot/dts/amd/amd-seattle-xgbe*.dtsi
-- 
2.36.1

