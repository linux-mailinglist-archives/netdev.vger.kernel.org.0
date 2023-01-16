Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFFD66B697
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 05:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjAPE0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 23:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjAPE0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 23:26:09 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBCE4EDA
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 20:26:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbGfdymH1YRve8cHGsIse5YU17fdQZgNZuxE7wvTAnwqSdqHeBYX5PBpGvUF7hVWbUcV9y8tiE6F6YGP9bMxknGsvohNutkb6q5y2oNcNuz5rozNKqy4um/s91q1X55+H82+uOoN2JUmHn4fqO5hom7AtU1kYWV9HuLMr9ixiwyV96OksT5IzBSzXOdXJ0vX2chRIUv0VAPUJB4Q8vld0KLBpbN1ybB3AOQ8zQHYai5XWm9vFEOhC1t7upOOMko3GnCLzSVnQsOo2+YKrWd4z4Z8arHkLZuHN4e2MPOI24IhucEv9kvcOFsc++l3O6aWzFZzDlKTaCSjFv9CVjdYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6Z6yU4FqFlEFKGKlzI2QNz7GgSCz8eti8MIg2sqLGk=;
 b=R0UME2akMtncuKtM67dyjIkBgON8g98DLMxjrvxGoJtWXSBvAnkMebVvOqKn7SzOhVHIbG6KomtCvz5HH14b1gHKbdpZx8PXJozS0gGi6cDJCvWVL7V06zeeGwwh59v1d+Vgj8JAfx18FSoq7ZBrR9Oh2Jw3AFNHh0iNtnlLqSG0jERK4m7bSjIRZ5i1+VGNIjhYiXBjb/XauKgCE7VrES/TyNpi0ou5EmEXQzNsOYOrQVYPBAeBchAzDMtabwVXakc1r/6lyDfPjp4BZN+zArkhmV2KZLUsNQa2+5wIYAZOjZB3kw51yM9/ukMPgE0mpa0rkoQeKufH8s8o8G5Iqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6Z6yU4FqFlEFKGKlzI2QNz7GgSCz8eti8MIg2sqLGk=;
 b=XeiK3HV5vByjUe7WULjsAcrdt45llnvclKlhKzvRWSD5yda/WZ6StTUvGzn71KvG0RQKd5Y/jae5vdBkqcaZc7D7Sxg3UORUksjZTOD3qTzvLAbezho1tgatAWh409aDimFjxvnLR6V9asjkMhgwAbK+TIQ7Z00aVNKu5WERHR8=
Received: from BN8PR15CA0002.namprd15.prod.outlook.com (2603:10b6:408:c0::15)
 by PH7PR12MB5808.namprd12.prod.outlook.com (2603:10b6:510:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 04:26:05 +0000
Received: from BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::98) by BN8PR15CA0002.outlook.office365.com
 (2603:10b6:408:c0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 04:26:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT076.mail.protection.outlook.com (10.13.176.174) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Mon, 16 Jan 2023 04:26:04 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 15 Jan
 2023 22:26:02 -0600
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH] MAINTAINERS: Update AMD XGBE driver maintainers
Date:   Mon, 16 Jan 2023 09:55:48 +0530
Message-ID: <20230116042548.413237-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT076:EE_|PH7PR12MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b250c81-f401-4c43-5ab5-08daf779c821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wo705ywgJqX48YEuwKCnqcTGrA6+FdT5dzweJUkYalV6qop8hTrMnwrWkyWyCuhNPl8MIavn4TO+vKYl4mLMZO8hPy/UQCOcU1XlmjMvFH5gesCZZjDVeHo9sBx2HKVGM82HXF1bmEFy+o00WSYxxKDbOtDlMT2+Lf0+5h/p/FkbY08dMuo/57/yyeBp8sjXWA++pAotWefuSoT6WGxkvm5QWNQFJN2VhrKfZhbnF9zlwz+oxpyPR+EReKFd3+sEZxB+YqsefcMMMY2HnhSTCBCEuTaOxynLcRAG73ZtFvl46iS3KiHOGkV4Evmfg8S0CVtGXQ5K4RiWGuJIWspFAU2GFP26wEp8QGNnOf4xe2Lc3ChKyC73DFVYcEw87kBEhYURMOAbA6530peNZAk2WzygLOVi6yPF+H/TWNOiJkgalFYAzrGsGGSWXmLnp50ymW2y2SqKetTh69aNxs6eW5gAdgCeuWnaGofmX1te5EDI1sq5cskgAvflGylyII1EmQYG+sigZEyTvvyQvWs9NwAxivBNrXdJ/mjklOZQff3tNLB5WNQAaQicZaxOZHUmFoaDelgSdFyzSAzKh6nG8P1WiFmSk7NowYg7t3yiueVjWAc4VVQbMA0BpNNkSpTpxMAz0KWSx8vkh2OrVK74FFFmCWxiEGOSSHFG/dfyuR+j6TM/oMTmh0T6cM66cRJwIEysZFip4FDdvBeEO+U1pyflhMV4cV90xJsvOkW2ebs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82310400005)(86362001)(16526019)(26005)(186003)(4326008)(8676002)(70586007)(70206006)(41300700001)(2616005)(47076005)(426003)(40480700001)(1076003)(316002)(7696005)(54906003)(110136005)(6666004)(478600001)(40460700003)(4744005)(81166007)(2906002)(356005)(82740400003)(336012)(83380400001)(36860700001)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 04:26:04.6610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b250c81-f401-4c43-5ab5-08daf779c821
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to other additional responsibilities Tom would no longer
be able to support AMD XGBE driver.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 046ff06ff97f..e9b1b0cf27aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1079,7 +1079,6 @@ S:	Supported
 F:	arch/arm64/boot/dts/amd/
 
 AMD XGBE DRIVER
-M:	Tom Lendacky <thomas.lendacky@amd.com>
 M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.25.1

