Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459346EF26E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbjDZKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240467AbjDZKnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:43:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D151E10EC;
        Wed, 26 Apr 2023 03:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6KBVv74BolM29XYR50vMkatavaJb32mcibGOhLQdefLukH49SyF4dyYFnLTCeh/oIBAP65u+VxgN6HsLzoxUyR07DGrdBZtkdDadSjEzRGHZ+Z/CmvvN8L14Y5aMaO3UrCwkqkllHWsMoG4OaFS/PZPTEIsb+QSjS70aBax4tnr6bA0xo9GYeetVI/G4MvNq4n7ilPIQRNLHuyRy7FQGtiS0NVDTqaz1FvHuH0ntN0zc+eAW7UIiYS16MMjHW3B4DbRaalYuORY3lMtC6oJ7D03ftYwX3kdKiBLuThiLYXh2M+RZ1zzse/A81ApAlJGmf1li1/ummVkRFbrBsdGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qWFyWDzv9iEIsKXgIuj5QvKwFPFeS/UsWsmsBVK7+Y=;
 b=H3LiMoOPJcvP2rh21Nven91aNyxec4y2JgES5vksT+gbQKAmHYO6SCdPPAfTcpQaHN3++KifDxRfATxpiBwq5KXml4DsD0obXFG8SC0COVRVTSwz54tnV/1yl1NnFL0DfSvZzZXOHCbppjuAoJg9JcSZfF30rJzy7wqqkywF/sEHcxsntQAFTESG7MqevQVuvYTTcpTs+EdNxyaGFN6si0SZRxxm4L4w5oodIUDkG0QmFq65jcFXq/2PFKUgN9as/hZGIj2y7w6sDNkre4xixw4wGwV5L0wNQ0RIx80B+/Nn5F3+lqKCGTtV7Fa/t8d7VvO5DsXRXa/DcU8U6WincA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qWFyWDzv9iEIsKXgIuj5QvKwFPFeS/UsWsmsBVK7+Y=;
 b=gRek+SAWzn7AUA7YmXptNdfvM0+3yfSHfL/KBlJ60NJVsxlgR0O8XKi/SiamNMr6mO4K7xmBpMfF1ZECRK29qQj/RJgZvM1dIoeB14wT87LvWsEUfpLQnehSpeKrlj6aqz53iD0AVUV324U6hrS0rd3UMfnWNdPcLlKi49oodvI=
Received: from MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::27)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 10:43:31 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::2f) by MW4P222CA0022.outlook.office365.com
 (2603:10b6:303:114::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Wed, 26 Apr 2023 10:43:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 10:43:31 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 05:43:28 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 05:43:24 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>, <wsa+renesas@sang-engineering.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        <michal.simek@amd.com>, <harini.katakam@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v2 2/3] dt-bindings: mscc: Add RGMII RX and TX delay tuning
Date:   Wed, 26 Apr 2023 16:13:12 +0530
Message-ID: <20230426104313.28950-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426104313.28950-1-harini.katakam@amd.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be0ae4f-a35a-4247-4e8e-08db464313dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKmJ2JVBJwEQnT+VCx7Fxtg8gldbUdV3Hmo5bLZML30Pg8VJx4mSaerONGLWCmApXGsZonZMB7OJJxaLFfVHAtLGPgJEh+z6PG6BGUXWANrokr3mj3VLVa6bwJclyvBUUxFp55pYS3BlCruCf3Cvtc97Cz2qqdEImT9i1z+WByO/Yk7LTEsBTmAEUknkktHshADoRxaxx92tdbvakkmdUbzYpVoFAgnr9ZBdDcVjqRKxkT9ObOovKEZwifbOYR+LcpYAwKEJCk7zFBvJlDg7DQabc4Od3X4N7uxnooW8ea2wpgONy56NzrArmRTP6qvb1Hnhuz7iPJozxASC1T7B/fXb37Ru7u+qz2ETtVcb89BEohKjKi0HfK/FwP0IyLJsoRrf4KK3fojlbb0i9NpWBgWaX0E+iFShiDY/IAL2/SgolgdL+k4QPHinZRLIXI+A6tz9Ej8k9E0K9nFNq2V8CRVLIOIFJ/A/0FxmYLkjHft5SO82evzb8aSB5ya7r0vjc9IlHtLT/USSpWzWYnx89CjxOd8gSfw6xx41UprfaXzfdpdCgBc027lDxoUfPaDfINV1zIOiA8g80HCtcoslz/ndvruSaKkSHnbeERGbx/3ElyIw1YGTEyggD5wfNl5TXvXQGSasogr5wypMwLi7tLQ1SWoxTWVcwbKzSiTpRbFJRVdDltmoAkobg+YhTmW+ZM4HDGskNOUh3pLSxDpVo+FmalihkniaZKuWjG64Gr0wkkdZmgWXWxCuiPwVwFd5
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199021)(40470700004)(36840700001)(46966006)(8676002)(7416002)(54906003)(44832011)(8936002)(70206006)(81166007)(478600001)(86362001)(70586007)(82310400005)(2906002)(41300700001)(316002)(4326008)(6666004)(110136005)(5660300002)(26005)(1076003)(186003)(47076005)(82740400003)(921005)(356005)(40460700003)(40480700001)(336012)(2616005)(426003)(36756003)(36860700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:43:31.1518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be0ae4f-a35a-4247-4e8e-08db464313dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Add optional properties to tune RGMII RX and TX delay. The current
default value in the Linux driver, when the phy-mode is rgmii-id,
is 2ns for both. These properties take priority if specified.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
v2:
- Updated DT binding description and commit for optional delay tuning
to be clearer on the precedence
- Updated dt property name to include vendor instead of phy device name

 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 0a3647fe331b..2b779bc3096b 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -33,6 +33,8 @@ Optional properties:
 			  VSC8531_DUPLEX_COLLISION (8).
 - load-save-gpios	: GPIO used for the load/save operation of the PTP
 			  hardware clock (PHC).
+- mscc,rx-delay		: RGMII RX delay. Allowed values are 0.2 - 3.4 ns.
+- mscc,tx-delay		: RGMII TX delay. Allowed values are 0.2 - 3.4 ns.
 
 
 Table: 1 - Edge rate change
-- 
2.17.1

