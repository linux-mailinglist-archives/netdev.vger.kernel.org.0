Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A007573FA1
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiGMWcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGMWb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:31:59 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4973C8D8;
        Wed, 13 Jul 2022 15:31:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pmf6aEPkizUE4cvHub+/FclqO2MHABrASR7g7i2deDTZb+DodbD38pgeU7vcCRrtXXmqQREZii/8vWOcvlScwebqsp3+LCXXHw5kdbm6U4JULdQPdVn0cbqE9zQDzqyN7Z5pRO+/WbMf4uYyDu1frk0qK3HlK1HFBqRcsJSjHSurhUJF+7tCxy1VJfDkiqB6CmEHzdEEt1abDNjtCD6VnNtgHrersUlrwqv9cMXBz95TT3hqS7Y9WfyW+HD1REPHWS4NporlUEJY6EDOZinoP4kr5e0QDOA57XmUYmVuHFiAtYDRUCdQbrwTmdwZWrBHYNPtuHZrgPALduiO4X1pEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5HOS6zqV6PQGrx9b+PqTeJi/XHFO7+Vptyee3OMFoE=;
 b=XoRKCzEUZW90EuxLLYwcycG7MCdAkG/mcA6BAGcdc7MlcWO1VpSHP4TsKxXmuYXMKFlgr3+vwVG/N8suxPKu2FMr4ZDBgxdfeiIwUyEiV3VFompKIzn6kY7COe4hhs9ChYgO1zSiOoJA7mBDXJP4r/RzxAT+cpjDRjgd0BIqcZ/3PFrBmV3yTCEPxKlLrddQTYfefKGjbQhNgD558nHkhOFexYbqOId7erzucyrJ/b9Lficv96nFNbiuOaZVcS4LA4WPw0EJP3OqaaUJgwtl29MHYewZLKhP3eo3hjvUq9txEAoz/cUBqozG72Bp2rz6dgA3IMbXZFAXD7Kv72hocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5HOS6zqV6PQGrx9b+PqTeJi/XHFO7+Vptyee3OMFoE=;
 b=E1+WGxMXYnYAtxpqk3Mu9MTDLlBYFMCdcnChihvSawKuN6V/ivtsLzzy9Cx/y9Uy+muqgJaJYtjdvA4wKg48CqqzJLkomIob5LOdZEiuqRoqzpeqz3HQ+EkA+is/k8dsyA8EsSqd8JJv5i3K0JYqEjlZKyfwQMo/n1ADMqy2A3s=
Received: from MW4PR03CA0305.namprd03.prod.outlook.com (2603:10b6:303:dd::10)
 by DM5PR12MB1404.namprd12.prod.outlook.com (2603:10b6:3:77::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 22:31:55 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::37) by MW4PR03CA0305.outlook.office365.com
 (2603:10b6:303:dd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22 via Frontend
 Transport; Wed, 13 Jul 2022 22:31:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 22:31:55 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 13 Jul
 2022 17:31:53 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net-next v2] MAINTAINERS: Add an additional maintainer to the AMD XGBE driver
Date:   Wed, 13 Jul 2022 17:31:41 -0500
Message-ID: <db367f24089c2bbbcd1cec8e21af49922017a110.1657751501.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9db8fdab-3791-4593-c779-08da651f7dea
X-MS-TrafficTypeDiagnostic: DM5PR12MB1404:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8X8lYEKcYegcKJm6M76gVi8bfKyxmdTGgx4rW33VxbIft4dd3kZOLTXtL+aSCcl1uEJiW3hlQ61PThX+FOx8TUbYWmdEX+wQTDPkyMwBLRniVuDH5LvaqUqjY/N3W8wcl5RfL7k/LDCejNJOEaMPHfTyjK7sksNRKGIfms/bY8ZhRRRlt2FBPBR/G8CphJNc47a2HQ09R/GWjKJ2JXcSyLkkaP4OqONq9i1FsI7wy+fmJnKuE+gUOK6eRtrzD+qtsPL6llQxkIGYYbEa+4NecfimVU24rPb2trFeWGii6TH0xe0SwG1Ck07MH5E3ARfKYQccgLXbhBXGS40gl2JK2pmQ0j2VMN+jnOhQSILnSLVPUDoGxP2R4cRba1r2wIDvhqwAls3/kVe9yEQjZWKozOyShsEQAFnoqUsmf3y/B19iHTtPslS57GPEZhY27VkgzpaPUulll1jFHJK4ziD8WglRmVxWMXQJh3brkSluo5ighRSPQXeBzgRYGWd33xnHkjIoqvzPZ+LC3qaTzGlr/VktxBCBG2KIAFTUcpQM/DoM9hmMrqVNwdSN0j125apKyDmoG/Xhqv4TDBTgSt8NQqryVWThkDQfqlm0Dyx1kFJ7CyF1xI9gBUER/+g5IkNgOjMdlK56ira++vRZ/0lOu+H2YGl2ge3XPiZ5NJjj/sNEO17BdL2YUiaNjCUtv3H2OkV4w503Kk7UcbfKUXytHrXNj5WY6aTnbDVl/WdWDMpdqzvlO1EfAo9Hhb7P/Jj6yGPxVGWmjakB/lfpWbwB3FJwTPuPlt3VdXYhuU9OnbGVIr9Fcg7NMd2TlwA5Tgb0LSXLW8PGWE9cqaJ3XpX5+mKtPTS3bMVa1K0eaHsiaM8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(39860400002)(40470700004)(36840700001)(46966006)(4326008)(8676002)(40460700003)(70586007)(40480700001)(316002)(82740400003)(8936002)(5660300002)(26005)(36756003)(110136005)(70206006)(54906003)(4744005)(36860700001)(478600001)(2616005)(6666004)(2906002)(41300700001)(82310400005)(426003)(356005)(86362001)(16526019)(7696005)(81166007)(47076005)(186003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 22:31:55.5401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db8fdab-3791-4593-c779-08da651f7dea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1404
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

Changes since v1:
- Added quotes around Shyam's name in the file (although the result when
  running get_maintainer.pl was the same before and after).
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5fc2af7eb9bd..4bd8dd827311 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1039,6 +1039,7 @@ F:	arch/arm64/boot/dts/amd/
 
 AMD XGBE DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
+M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	arch/arm64/boot/dts/amd/amd-seattle-xgbe*.dtsi
-- 
2.36.1

