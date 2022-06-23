Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679B5557461
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiFWHrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiFWHrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:47:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C0846C8B;
        Thu, 23 Jun 2022 00:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAmlFKtXWZ3fTzn/vQn2FxUpwkuM2Ij8iOykV7K/ljKix+9w5uNjwNbZlD2hf7ylCa2/bOyuZL2JmViAR59dPhcSa77MlNa4sygh/hOpVo7AUY6dc7fx7yqOktrHNArYbV3lHteYKIz/iBY/ohEVK92LO2yvnXnmbbpfuBWonoUKvrRqIL1r2TEiPl/JT7Np7nbI6EBBZypcpvBvGRnet70YSz9Vjn/3mOCknHepc8P/d0O3TthnTJwWX8nNVquoHNbB15iH9OAEmsLpHGGkXM67mdVlBj9EUG1gA3I06fOv3z5hKVMflpKAid52dKUL3SsIaUX/Uy2m3Wfnsn0LHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duE/e4XTTpszxkZaeGq8i0IE0Kk0iyIXfEb19EuID4w=;
 b=Hg3/sKFQkXwcQyCligMdT9QcqwYFV7seQNM5jXnKngdEFYhKDgvLTlH8xb7uFL49bakY+A6yXQa7cyhd2WemyPNEyPIh1SyIEAo9y2fNOGnxKBgh/HbvtuuiZqAdjbssIoBWuKn9xnc1OKXdU3PMeza/jzL8bpWmcfSN16N3SgCknJTelJ/aqRlZVWcILQ5ftCliKFALto+o7LOTwEynJqX57a5+mnwc4boW3IfHxyYxPigPdQ7mM8DoujbL7Zc0p9b47OUjyK3K9lL/DEEBlx+hOcVTXx0GPVT/bkX8xMjwdvOq4LxlhYys0QTr2OzAwnjkOp2fEMJP5djFXK7KbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duE/e4XTTpszxkZaeGq8i0IE0Kk0iyIXfEb19EuID4w=;
 b=HPdEup0izrFfBkaXx+FwAG/vJ1DPa5KxCUciI6tD6lLAwPkr3HPsZyt5ZEPwU8W2R+Pvo8qDo5JhgrDLqi1/jTGX9FYQlnE1fnZJPp2Jn3qNZHp0jFlYIyKIXM2N1BwHLXgPOqpaTGFLuTLDW9r8CBXFVuzQSmMFM5D0nz1HgpiS7rdK/QsWFfOcN/SS3myEdkOQnyLucq5HYr487tyP8tBmzWXqzcVbZPO4Vm67Gk8NxGvYgQAHF0bWAq7azABsI67oppbYV5FaTYkmTns+Yps3JX7kJ/Tsl6fJPY2yIxVZG0Z3a8Ntw7XvfBAkGZO7fy3F0M9Jjwoesl3sFYUb4A==
Received: from MW4PR03CA0037.namprd03.prod.outlook.com (2603:10b6:303:8e::12)
 by DM5PR12MB1867.namprd12.prod.outlook.com (2603:10b6:3:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Thu, 23 Jun
 2022 07:47:06 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::8d) by MW4PR03CA0037.outlook.office365.com
 (2603:10b6:303:8e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:47:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:47:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:47:03 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:47:00 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 7/9] arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit
Date:   Thu, 23 Jun 2022 13:16:13 +0530
Message-ID: <20220623074615.56418-7-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aedd3adc-1736-45c1-9b81-08da54ec91b0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1867:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB186758B7398726A35DBA9835AFB59@DM5PR12MB1867.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKIQuuolZxU5dJkNW7bhVoUIOYg4XZE+/CddvQjkHWJgQFr04M663KyDgMf6sXdZX7YMufE38aRIP79fqGiK2vZa9KABRyaPZyLC+gd98X8oZ3NFsdiooOAP0ez1R74s2Jkvl+AZHaRvdE1EXZ+MXJ6k5TqYSGNQ9UkKTNUlfyAYhEl5R1A8713kQPf7IMOIgmb86uptZt9n8VbKzc7wwoiU89LuiQpFcmX4I5N0ZLB1P0ogBeju7iFOVTgZ/PZg1TUWIgXwXbMHEqUqG5R66rRN1b03wZOOaZKc6GaGUyPXnKX6zPrrM2X1jVkJeU8YKneB2UlYP9i+36sQyZpQrsXQotCxV7WU6VUL6ROLukDeSB5NF8DzMVWjW3GDSdfBf9l1OeFVKDbrfGSMpd6nkl8uWkUqo1iJxLgZROrWqo41AgnnERkQxjzCRooikVoRTCqsVtHZ2FEezNoe11kj1CKcPB9AzO366tZrTFLxJbOGWpRI6Kgib1CWF7EpuUSMM6rxGs0ttbEPUq+8R96ZDQrFMw0eCouquFVhskIEYLaSCEloW0nBvQbMaedldzNbUe3igutob7Hs4QhMFa93lLlJwQTTGOEoPROxpFFGi6uRHw8byQnEnixdeO1LnjOTxeDNob04ZY7+enIfx31NwlHiu6Kw3ES+31LoJHS66XoUwihF5CEam8KuN5OgEyJ25Qa2J3OQH4/XSXC0iExEvoXVfvmsK2O6IzjnPHfhY4QJ0mP/esiByiD/toJh9beztiC60VpPjIixz6p1EP3U3hmrYLmc2qaabHUySZtyc4o=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(8936002)(478600001)(5660300002)(86362001)(2906002)(26005)(70586007)(81166007)(6666004)(54906003)(110136005)(7696005)(316002)(40480700001)(336012)(47076005)(356005)(41300700001)(36756003)(36860700001)(82740400003)(82310400005)(8676002)(107886003)(2616005)(426003)(186003)(70206006)(4326008)(40460700003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:47:05.8538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aedd3adc-1736-45c1-9b81-08da54ec91b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1867
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Change enables MGBE on Jetson AGX Orin Developer Kit

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 .../nvidia/tegra234-p3737-0000+p3701-0000.dts | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index eaf1994abb04..8e2618a902ab 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -1976,6 +1976,27 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	bus@0 {
+		ethernet@6800000 {
+			status = "okay";
+
+			phy-handle = <&mgbe0_phy>;
+			phy-mode = "usxgmii";
+
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				mgbe0_phy: phy@0 {
+					compatible = "ethernet-phy-ieee802.3-c45";
+					reg = <0x0>;
+
+					#phy-cells = <0>;
+				};
+			};
+		};
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 		status = "okay";
-- 
2.17.1

