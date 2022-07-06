Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B47567C72
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiGFDOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiGFDOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:14:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41841DA6D;
        Tue,  5 Jul 2022 20:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyxyitYp+CkQNPBtw7EUkcU/hiCCkv01i8xd6zmdGCbQ5WHcx3Bhtg0c4W+IVD8XjCDbheAbaGqJaxynI3wHhkRFBbmoNkttM+Fasj8qnbxCCw7ToH6OaaY9yuFjVuPzWPY453shntn1DgvgB9zvelda+niKuGT+Cc4+KjCp4HEpn3eStSZD4vchsKk2FvnqyhZX2G2+CIxYHx0rz6ETQ7jS/w7ayqmPSBhCAWiYe7lOwAiTojJowo1hlmmfaiL856HZo+hyEJxsdF/wj2g0vSJO3+Lin2mgMe/LoAKqrgYh0COOZntDjqSFDxalZ3fkv3tVHkBaUEBXgawtR99PHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSGJf24W5VSpcSXwRsgckLYnbLA6N4FEG3oeJkAxJwk=;
 b=l2iTBYM+aGDU0S28zhMEsPO9tVR8P53J/ufSbaoPJ6jmIhRfQMS/KkRGdQ2kABvc6QesbqLr9yPXONL5dkxAT4c1T9uhDn481AyONfaJPCg5OuVBR0wVjMvWbeFJ+WCZ0tU3Jm9l9dPDg/wBOI9ADN/ULfDdmvaXK3fxhC4t2dXnBcNCA+PEhKGQ5nFreFCmiUqM+rinq53tKdO4GboO5usryO57bi1kFZYTK3xjgedq0xv3rvUzWmjJJ4iGjtHh5L7jMf9uF5WLnFsagcOuR5HfxOmWplwL2I0vs6+MmF91OxXmSZr3PiRKxjtZ0HiRdpr40K8nkvUBYl5+X/B6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSGJf24W5VSpcSXwRsgckLYnbLA6N4FEG3oeJkAxJwk=;
 b=LG+m3+2iUP04deVCFtye2QSWf5ktroIAhSAq0fko2sM0vW4xyFoUdTbp2ap/2oVW7aM879zNkjrdyupIGgHYAcOeTOBtE8XzNXtKEaOxa6Fj8meZ6/5RTje23j8KNQZiLB4Zhmbqdc6tkRXOk6DSTAnLcZUJQiBM8SqOXQKWf323nr/vgUMTkwXHd1xDTL62NqhH09gct3AYkRadx7zRMl/e8fZrdd48KHtJFevwDZ8uGa7hXVNRYN5WjkX7s0CNhIjcR1NfUE/Pu3OBGGS7jbAb+TVZNnRJwmiqKVWowp4O1UHYXjPKakAurIewC6iYgq4DTBxTgfY61Fd4cNr0Vg==
Received: from MWHPR22CA0047.namprd22.prod.outlook.com (2603:10b6:300:69::33)
 by BN6PR1201MB0114.namprd12.prod.outlook.com (2603:10b6:405:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 03:13:48 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:69:cafe::61) by MWHPR22CA0047.outlook.office365.com
 (2603:10b6:300:69::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:47 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:43 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 8/9] arm64: defconfig: Enable Tegra MGBE driver
Date:   Wed, 6 Jul 2022 08:42:58 +0530
Message-ID: <20220706031259.53746-9-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26b6022-130e-42b8-eac2-08da5efd8b21
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0114:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vi8Xl/nITtTkL9wBB4EudwZpgg20Qo7JmHo5o28JG5YM9Rhhg6ga82cTtseH0GSy0+dOkFT8WmWbMuSU79ayqe4XtmcZ0D3y4T4hVdXhMDEDF1adKwdIZIKdHdN6mO1YN6JNZUYLtgg4tFEuz+pIu7UjC1uDhh8zbUEowtvbkO9RzT9btU//x0IzC2MfYkAHc5qxxIo1v/kOqwNL+C6IrPOO+YyrnLoEQcJc/TtVyk9IuFOPNY50OOWjdXrAIPLh0Ioul5mlfMPf6u034Ug/fMc86QaaFjvfkULhiHjsVVyxJTpaaBHoNWaapNXClRsSJox3wMG0Un7JQFNGevqkep8kX0mSlKpwvO1g6zwY/Sgr63xN38Av6nkuQeIuSkyeolJJsi8RguLVVEPyfHU5A4YihG0a2o/JmqFIKitWEdApoRhrBqcQq+Lpg4WLFCCHRSJ8QysIWMQwSD+f7kc2g0y43TfqJHbeKJNPTVpGtblYTK8UJ75iq7F1frMXacUenbxWhDYo8IK/s9ebvjiap1CSCWmib99udTtH6RiD6z+hsQwLOKKu5xuhNUTK2GSMn5Du8gTBOppQhRQAiISDo6cFEw17/VJ55Pki6pJdtjMQ8fEivRMtKUpyLfzB3ebdpzHyRDoq7DUL2/OXSA8sggkBCr4nmCB7+3KfiCMTj+OQ2FQ+03LZ0taxyT+AXh10Ft2t9aiFlZEQQAyeZb/0GTSN4lQSevGZ4uTSwsJQbtB4tcSZFWv/rG8wj2CR+F7MWG6tfZkFB52Gb+4ooxSTQ06CKv681fZXH3mFrYhRMjeCL4ceIjHOfDpTuvXJF3r5sp+2zW5lF52LZdOa/oOHhjhGl5KQtID6WPcnnMWNonw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(346002)(376002)(36840700001)(46966006)(40470700004)(186003)(336012)(47076005)(70586007)(70206006)(8676002)(4326008)(478600001)(86362001)(7416002)(40460700003)(4744005)(8936002)(5660300002)(82740400003)(81166007)(356005)(26005)(82310400005)(2906002)(36860700001)(41300700001)(40480700001)(107886003)(1076003)(2616005)(6666004)(7696005)(426003)(110136005)(54906003)(36756003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:47.9245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e26b6022-130e-42b8-eac2-08da5efd8b21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0114
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable Tegra MGBE driver which found on T234 SoC's.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 7d1105343bc2..f80142abd9c6 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -359,6 +359,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_DWMAC_TEGRA=m
 CONFIG_TI_K3_AM65_CPSW_NUSS=y
 CONFIG_QCOM_IPA=m
 CONFIG_MESON_GXL_PHY=m
-- 
2.17.1

