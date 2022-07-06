Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41979567C68
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiGFDOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiGFDN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095F61CFDB;
        Tue,  5 Jul 2022 20:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+pcJbjNiMMK3mU5B1mq0QE02SJ4gSib1+js1DjFmm0diGqjEDUCXF5+sa0usxV7HJJWKuu6yUgQ/u1a/Gx1yD7H4HbhNzWroZVBfMojmcOnHz3Ct3vBrmWUnsEmrJgBR4QI2gNONDN0jS9F0yNa6okAOfT8CAVW59wIMbt/8Rasn50CiKkg8rDbuMU0hUDuxvokFg0t+GA3FdVAIoqufupY/Uznrkc1hIj/uiYa87Qph/zBWkNDNVyRqO+U4L3Nu9AmqTFDQk4+i6zktlB5qnKfCwCHvxOIOh/kBOkjlXQboGuW4jkNZhKhxvRCIfzKcAp44+CEr8MCUnwpg07f8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duE/e4XTTpszxkZaeGq8i0IE0Kk0iyIXfEb19EuID4w=;
 b=MEpuUBwfsVmdBWg5iKcGmrTWGlpzxUVDgyqgOEzL4Jh/CioHwlqMXVlTmD5cCcEaD/Nbmhda+ZToXm+CcRcyD/IourjtBtl1N+oSQUwka9HamMvweY3SB59JhXuUQzgYkjmfhqn52XfAMCqzCZxfWg9QQmRi2LUuj5fdP0NxByh6OdjMteK0D2qJ8fdaJ0VTT0+hBmBd1zoRkuJwsQX4FHQo7CXwDrIFldAgZE4ohiYlXtihs9MOtOX6SkqULb1LzUAf+Z+yLLYpeJrKv2En2GQ8bdTQiemLwzPGC1WUlGSsiZMIRHfEXv6eu+EuaJJpsgtQB10mGhfPn6yZN7vAaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duE/e4XTTpszxkZaeGq8i0IE0Kk0iyIXfEb19EuID4w=;
 b=QgDtKQ7bqLwFZNHKw/hVyls8kWPTfdaAzW5nYyasNP/y0VQhC++DlqjZ3cb3PpX2OHlTL2iuiKF5ZnvhALAQxthwcmbTNq/3Jc51D2TjbP2E8fz6tjOKnWnh373sxepiRlfCx72yDXT9Hs1RkfyjY2andNpwXb2w6jNTFlB0YH3L+CJaBbQwkZ4JUrnh6JsVyzglHIdJVRyA6kYUPTd4InMJHsCxzMl8jMbfojsC3GhRWuda7gu9qJ23RZt5TVgPJ8GObWIJ7ocLLuafJlBMaX+KV3oupUeqky+j67xGO7BsMZDgKxiYVzp8OsqnGLH/3fFQbr2KTJvoQD2ogUUsCA==
Received: from DM6PR03CA0045.namprd03.prod.outlook.com (2603:10b6:5:100::22)
 by BY5PR12MB3793.namprd12.prod.outlook.com (2603:10b6:a03:1ad::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 03:13:44 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::14) by DM6PR03CA0045.outlook.office365.com
 (2603:10b6:5:100::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:43 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:39 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 7/9] arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit
Date:   Wed, 6 Jul 2022 08:42:57 +0530
Message-ID: <20220706031259.53746-8-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1ba74fa-3f17-491a-e8b1-08da5efd88e0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FdRpOwgoxBFQj5qyzL/pAA9Jlue37RubMfSK4+xMSBo44BRJTl3edLGU7xuGGlaXlOcZNrrQdecusvbmyHLSGlk7PTV8Z1OGxuIGNudjcWPmpwzKDTdRUkkNboFZbibdJdZwaocrVQrI+y3grvhp9SNHnyDDdC4VDABYe061fVYAlTnKEDuecaalpPJrn7bjQOA1RLb+ZM6R5Fy3T9031qhQ1EyhIMto2pLg3/CBve1R86X0pQ3yj5KmLAedv5E4sUiXrVjvvrh/mxfXcdagsWT8jaAAt5mAuehZFaKS6T3TKBpHRC4H7NToxw/iQyCT0rJPbLP6iwq6A0qZlHI1VmXfXZDtsOcC0jFu8STTP/78YD6rmsVT+a+6bgko5Kw/3GON4erPZJVr9941pO0+nmo7NIB3fADdLO4deQCLWY3gNod/OtL2fqjdMZkvlMoah91lqEvrznpTpESYtT5M7JR2o6czRfv0oSloT62mmQGGKzf1r3cGUhxcUoSMf5F4s1B3ocCBsOrPbEF5pGbFNGPgx6iPYy/UsB8q17JmX6bJDWhuDZGTD4L3oFwlBNFD6hdmMWkzpkQnBsifdGOGsMAkQ4X8JOvZh2f1fhBxfpj4Xu6ftKxYTCCQ3J0gVSKG2bZhW9ZMU+8Qzx1JeDPeejnFUnObewu2xLym39m8M6eCBGnF64rfrfauBQ6om31nGyKBD1iAMVsHSr0eB/YqTewkJ5Jpeib2Lxk4QAccTuzzvVik3pH8OobZDL5/GcX+2PqY5k24Ih9AIuzVYm9+p7YjCIRXRBrwcKs+ubynsWgIEgaaoeVzFNydwl4Gdeese6oRbybU413wXw+871AcqjgySWLyCeIHR9yEyApsI5w=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(39860400002)(40470700004)(46966006)(36840700001)(70586007)(70206006)(82740400003)(81166007)(41300700001)(6666004)(8676002)(7696005)(82310400005)(356005)(4326008)(36860700001)(186003)(107886003)(86362001)(1076003)(8936002)(36756003)(47076005)(426003)(336012)(40460700003)(5660300002)(2616005)(7416002)(316002)(2906002)(40480700001)(478600001)(26005)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:44.1430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ba74fa-3f17-491a-e8b1-08da5efd88e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3793
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

