Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E494167AADA
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbjAYH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbjAYH07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:26:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009AA4A20F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 23:26:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayLkcTFh54DPJhgxT8rv6DLU4nlUEnws6hssGssxrPXhiTPap55U0ARY4e0FEEISFjC/9A/Sv8lP/FTD9xEKUHHupTr+QXtS6Mmdnoap1vr4U/Q9m31+tjeSPER62DFVf6DnPShqF1kQTQLwRc5YqDDF6ULXkjfdEGOljHD8iaaTeksLkEw/31fgu2Xjnc9bz3jrn4D64mv3NVL4hlaki5DO9RMeliIDfuQnrWnPIkYKC3vOhfimJVs8foFcha3Z8wT2xPpluUm0eCqDcfzQwShjwgRVaFmDrVBQ/FMyrvq3Ym3LtCW0rpstoZN8xLareTnR/dmmXJNuv7dY/90Zfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5fNAIcP0P95p6eCquyTOeldDK9SsHdl6SdWfzPisWg=;
 b=BXN1xPKXEJQaoVyLUeNNYSANBrWejWH1hGXCv10FInZR4S6UGz+ThGKl6EQZEGLzXZ9VdXD00CqKnbUE3usptqK73jI9fx5rWiYy0OxtsWffTfm00+b6oczxOtcmW1txZ8iM7NaAazfoLnfZN8S8UtuqsfqX024jPwmz6EtdKUHHTvBKf86oeUV2u/pwTjWCTNQ3j34NkxO/BsUq5r0Gqe5ZQA4D2Q/LRlDzhY26cvLUf/8/4PXQjdHswSqK1B5zBv/cDUxH3muu+a48FfsMtjjsfXa61Q6Ostvo8LPa1Sfy+blsEbLQDRdwEmsoFXuO78B8+Kx9sagnn01Cyz72aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5fNAIcP0P95p6eCquyTOeldDK9SsHdl6SdWfzPisWg=;
 b=M0yWsoMs2B30H77VgEbjy506bMyk2As7iD0zvqaNuvT2VeT+alqj9Yj0JHFdlx7yP5xupAvsdhL4PVRmH6IO9CQakxX3PDqNPZR6fSRxgD1XX8M2Le8D25Vfnk88w3UXAD3sbyXxzGftJoLtou9w7bQ93MJwfAH++8mAPpRDpSo=
Received: from DM6PR07CA0114.namprd07.prod.outlook.com (2603:10b6:5:330::29)
 by CH0PR12MB5370.namprd12.prod.outlook.com (2603:10b6:610:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 07:26:51 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::15) by DM6PR07CA0114.outlook.office365.com
 (2603:10b6:5:330::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Wed, 25 Jan 2023 07:26:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Wed, 25 Jan 2023 07:26:50 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 25 Jan
 2023 01:26:48 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 1/2] amd-xgbe: add 2.5GbE support to 10G BaseT mode
Date:   Wed, 25 Jan 2023 12:55:28 +0530
Message-ID: <20230125072529.2222420-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|CH0PR12MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d3c2b0f-24a3-4d74-89a4-08dafea586c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eRNn8BAWk7hsuHgw1ZIgsYFLrBv8dyPJ8JwY0wXG2hbRx/OlPWJM/1AECkr7Ar+N/lNTyE9nHWhZNhiWLSeCuwp88fMhfmDCDQg3Qt3uzyXn09pYsNGSL2PXrJ6u/1MuIEemWqF0dtzvkuLF+eFA79I8pSluNJXIsjbU2seSmqWGWHNFrIIhjl9121N5oOiuJI/red8etY5xQg9RRjEoYbDeeYD2lrnAgRczAonMHomHemzqSmMWgeMM+JYUhMQopYghP7GVtc6CU/U7cxyOHPT2ILgZRPtOrd5laLYInWF9XFwB+zwqtczPpZ0P2rHE4Jnz4wXMwvlNJUSrB5fsf8wt70TIp/QmY6gI+pHXoi4a8hZGWnxb6+EDLSOgJhH1ZpVqPR7lBCeexG0qVfrpfI8sy7rYyVdMHAjhQyT30RtozYNUHU1+qHLy+yeb0WL+RnuHNKOuz5suO0AAQ365RgUOEVpMKytAFkOIT8zV/3aEoYcwRMMzIGMRPH8tAd23VtNu17LqKWuZvuTSZV0JrJ01CWg2lAlG5wmF9BPBDl6wXb/DhylGJ9jg0j6htDzpyjzNSdh5kH4/3T7SeGuvcm1N0T5EJekxWH84R3azvzUjJiYnXtnFqvhSpwjjbLmNO4bNwNTba2fHi+eLSteUNaE3v+WAq7B+dPFdwshRCRbPbpoJxknc4QGtbU9KPkku3TevH+oIymQZCnnkCx/zLDQp/s2ePyzCh4gkX27jdWQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199018)(46966006)(36840700001)(40470700004)(36860700001)(40480700001)(83380400001)(70586007)(86362001)(6916009)(70206006)(4326008)(8676002)(316002)(36756003)(426003)(54906003)(16526019)(26005)(7696005)(186003)(6666004)(478600001)(356005)(336012)(1076003)(81166007)(2616005)(8936002)(40460700003)(82310400005)(5660300002)(47076005)(82740400003)(41300700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 07:26:50.9913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3c2b0f-24a3-4d74-89a4-08dafea586c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5370
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

