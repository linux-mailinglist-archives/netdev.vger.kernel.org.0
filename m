Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B69F685F44
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjBAFvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjBAFvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:51:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8765B5B0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:50:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFnM/3a4K2UzHUAt3T3b/uqk1YpHEG++cmfEKXDkh7ueJx8PheA9thOeZTi9+IkpvGRoz4cca6/b56YgL0ncQlmj68BarSxL8nALiL8czBggkt41ipZptlt08pZAsYizlBeSsnVZXKlGhaCM+DvaLeZL+myoXcYOsEx6aTqjTINwrperNeA6rpPdztIMlEms3bBhzyVqqyukKmYvYdPyKJqMrPK+Z4BARAIKNkWrxTr+4yh/ctK0wLAFUs/9MAvlbXphE2Feii1K/vniw3CMjSdWjOKpwUVhlZAuf8plHcjV1KeFtutxANERxznN1ojygfVsZSgXgwSzn6E9rMTzfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5fNAIcP0P95p6eCquyTOeldDK9SsHdl6SdWfzPisWg=;
 b=Q3XUZ6071nGwrQ337Bwz9xCeSmRHckudIYlTQt9Fy7eaZESpXSulXMgPsSHKhw1BOocJCqKX+B3Xr5QJszkTRMRQSUJweb/J/7dsFFtdHGsHX4qsqRHI5SW3mchbeyiv457YzBq9meeNrQ58aXeT68D0pprFDKTeKzesCU6OuW0ogWJAOU/Fz7UF5pbyUTl6yWsFtQ6TFJ6ZGnI6fYoI7zA2H5mdNhR4gIqGagcaoWB8QWf+K9hw4IGzWHK2o9lpEpzkGVdWifxm0Mon0UAGR9TGgs2JPprFGZcCUS0sXZ6GVwIM5qcsikPNKGK7qZ+OejodlMrQTk3RbjDgI/dzOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5fNAIcP0P95p6eCquyTOeldDK9SsHdl6SdWfzPisWg=;
 b=R4AHBvQAOY3jGVf9MtJsh5BGARpKyXDQL7JRXK9bBXIR5cJsgmSbik2n0VUNbn5UV7W0wuMBGcucda+q8zucfMTQ+RzXT+FEAVcEjeQ+yMaWmgJ8a0aslujDp4Snk5HG4KjwKZrCAIUKUu4SjMF4KuUC1t2UIddPIPogRe+9ns8=
Received: from BN9PR03CA0124.namprd03.prod.outlook.com (2603:10b6:408:fe::9)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 05:50:10 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::e3) by BN9PR03CA0124.outlook.office365.com
 (2603:10b6:408:fe::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 05:50:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.24 via Frontend Transport; Wed, 1 Feb 2023 05:50:09 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 23:50:06 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 1/2] amd-xgbe: add 2.5GbE support to 10G BaseT mode
Date:   Wed, 1 Feb 2023 11:19:31 +0530
Message-ID: <20230201054932.212700-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201054932.212700-1-Raju.Rangoju@amd.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT030:EE_|DS0PR12MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c4ad4b-2232-4126-8a14-08db04182dfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ac911K45k+yIQwkuMFb2Tw25LEVXNZFjrSgaT33ndFQ8+Bh5MftJJOd/RuAafpeAokP2X98FyC2+k3ETiA2XTLthTAW+q0XxwfhwCE8tEbpuCmtPo/sD3o0YQkws/HkijkIP00O4rAgTsdBy66o/ouqQAiZ2gtcDIYB21rSKItO5aKWrG5YllUUNT3xUbhhlQvXJIvKGuXs1q1FFrOYgoQJtpfHv6MeJhfYTAwicR2McgHHwQ3zgsDuSsQ9uj6uGdwskv8np98q6bec7c8CESaLXZKhJCeEAVe8EEoK60obA8ORbLtGo897TDupneOALDgwYlPFpxW5ekEyxJLZb+CFH69SJiz8WNJz5z0XrUt4wWU3utq3T7v176k/rwckfALvbd0A/sHbDAqYCAK7guHZSPRdK41UKz3stjo6bgJV57zcp8IQJ7QI4RuqZWjNIg+h/ZC8tZXqpXfEWgCxt3W2A9InBrEtWe9OgH+GsM5PCLT4/ZGuRFHDrH4QCcrcch3Aepk82pJw4XAm0DLESPIe3guGGVTXxswdgwoNtKsz9XgKU3V05UTjyEqPFzr3L8uPvgGRxLs+QoE8dcgHXyKw3h+ASrvr+E6KbsTh/Hh7+JUmvjeCqmryKND6xwExiSsmykB9OQld2tLdMgdumGMo3wKFPYVbsShlq1NV+EjO3kkiYBSi0SP99to3Y3NOHu5MQRpQry2Bkl0al6knx7MUM4MeyR9ePHIhPFTZY49U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(70586007)(4326008)(8676002)(6916009)(70206006)(8936002)(54906003)(316002)(2906002)(41300700001)(5660300002)(82310400005)(40480700001)(82740400003)(356005)(81166007)(6666004)(426003)(83380400001)(47076005)(336012)(1076003)(2616005)(16526019)(36860700001)(26005)(186003)(36756003)(478600001)(86362001)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 05:50:09.9658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c4ad4b-2232-4126-8a14-08db04182dfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the driver to fully recognize and enable 2.5GbE speed in
10GBaseT mode.

Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index f4683d53e58c..eea06e07b4a0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1882,6 +1882,9 @@ static void xgbe_phy_an_advertising(struct xgbe_prv_data *pdata,
 		if (phy_data->phydev &&
 		    (phy_data->phydev->speed == SPEED_10000))
 			XGBE_SET_ADV(dlks, 10000baseKR_Full);
+		else if (phy_data->phydev &&
+			 (phy_data->phydev->speed == SPEED_2500))
+			XGBE_SET_ADV(dlks, 2500baseX_Full);
 		else
 			XGBE_SET_ADV(dlks, 1000baseKX_Full);
 		break;
@@ -2282,9 +2285,11 @@ static enum xgbe_mode xgbe_phy_switch_baset_mode(struct xgbe_prv_data *pdata)
 	case XGBE_MODE_SGMII_100:
 	case XGBE_MODE_SGMII_1000:
 		return XGBE_MODE_KR;
+	case XGBE_MODE_KX_2500:
+		return XGBE_MODE_SGMII_1000;
 	case XGBE_MODE_KR:
 	default:
-		return XGBE_MODE_SGMII_1000;
+		return XGBE_MODE_KX_2500;
 	}
 }
 
@@ -2644,7 +2649,8 @@ static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_prv_data *pdata,
 	case SPEED_1000:
 		return true;
 	case SPEED_2500:
-		return (phy_data->port_mode == XGBE_PORT_MODE_NBASE_T);
+		return ((phy_data->port_mode == XGBE_PORT_MODE_10GBASE_T) ||
+			(phy_data->port_mode == XGBE_PORT_MODE_NBASE_T));
 	case SPEED_10000:
 		return (phy_data->port_mode == XGBE_PORT_MODE_10GBASE_T);
 	default:
@@ -3024,6 +3030,7 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_100) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000) ||
+		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_2500) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10000))
 			return false;
 		break;
@@ -3474,6 +3481,10 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 			XGBE_SET_SUP(lks, 1000baseT_Full);
 			phy_data->start_mode = XGBE_MODE_SGMII_1000;
 		}
+		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_2500) {
+			XGBE_SET_SUP(lks, 2500baseT_Full);
+			phy_data->start_mode = XGBE_MODE_KX_2500;
+		}
 		if (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10000) {
 			XGBE_SET_SUP(lks, 10000baseT_Full);
 			phy_data->start_mode = XGBE_MODE_KR;
-- 
2.25.1

