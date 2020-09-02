Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B295F25A897
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 11:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIBJ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 05:28:39 -0400
Received: from mail-bn8nam08on2065.outbound.protection.outlook.com ([40.107.100.65]:3809
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgIBJ2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 05:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REt64LoJM1vif0zhtpbg6/PS5Xsijq+mDCG966cGd/rc70AEUpLuURf60lUN9ev2+dUQKDfwtZnX9366oURbUzl7uQKOxuTehA4Qse9jR4e2U2SNvfxR81HaaL6mljFXQPcaNE/aeYzjHmu+qWKLX2BvxiinYYJa2lW51DAm3pizrnu6R9sIc4lJSpSEmgTolN9/csTSIjJcca9tatcXuFvhY0MQmcumViEWGNQ5nzIeRqdNrP+7l//slc/NNeO3YtrFLhZk0J/CGiLsxIuxpGcS8EejNblxNoe59vGQO4tXAUJKkZ/C2haAaCQmUx7ykOIppVav4eyYi3lmzkhXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtXuOKsw5JUn9/acKgAbIcn4wtdr0XyjmLkLIt/zsPM=;
 b=SbTMstZtjsFYg1YMyyhZdA5oKK/J5w0MVfTcnugpyYrmLjdaKRUVcE/RTvjD7Mdk4jN+9tdU4W45qAKCnESuoaicRlXXd+azct/srTYoipNcA0liv3ubYX3UlFFLuQ6CUTb4CpZY7Ls+4v2t5SScUUaT2C4RyNJsEC7m9B9+WYG3bL08b+7egPDSPCs7SM5xETvyb47jGnqQwZFj/6HnYj3v29uSkaOXM8aNE8ZYOgQCYKN7MNYDYrQT5d6uKCPY+Jbn61jwpwH6AcfvMWIk60MXm5cAfugOV9ZU7uYNmlhKeuLo0KSdwm/gbY1hqVlV0TFgsrp+v2BJbq9pARQwDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtXuOKsw5JUn9/acKgAbIcn4wtdr0XyjmLkLIt/zsPM=;
 b=es1ZuKPlPlV7w8wGktEyU+JA1MG/5EXPgr+6OMdQi4ou/VfHdMsgFwlN1FLtLwclS90cDUpiglJRvdPpdb1zdoh9LMoy6wTkUAMDdY7SoWGUskwfUi1zKDdEaMafmAkL+zspMiyvttR0l4Ui0bMOZ6+Kj4OloYYwRHXG+HYWxSY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0268.namprd12.prod.outlook.com (2603:10b6:4:54::16)
 by DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Wed, 2 Sep
 2020 09:28:33 +0000
Received: from DM5PR1201MB0268.namprd12.prod.outlook.com
 ([fe80::c0cd:3c45:554e:dc8a]) by DM5PR1201MB0268.namprd12.prod.outlook.com
 ([fe80::c0cd:3c45:554e:dc8a%3]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 09:28:33 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH] amd-xgbe: Add support for new port mode
Date:   Wed,  2 Sep 2020 09:28:07 +0000
Message-Id: <20200902092807.2412071-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::21) To DM5PR1201MB0268.namprd12.prod.outlook.com
 (2603:10b6:4:54::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MAXPR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Wed, 2 Sep 2020 09:28:31 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aff97d24-9fb4-45cb-a173-08d84f228fd9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3227E6CE9319B39C89E8148D9A2F0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgJmR+6n/4P1Q+e6Difl96sz8hJeYrTDd0G9/iwQ9Ei9fZbDSHEsUAfSXiccLKIWV3KMGJHITPOLhKtbQENeUQrwHY+cUCDju6L81ODd0tgmXE1B5OsDKJsjHPuzM7EPvVizWtuBkrWNzE6q0pMfir1DyySkpC7Y4+Qu8/0LeBoTrBLk/M3lyig2gr7wcF8IjGB6G6hp42jR4yfHpI40VGm8wQ2kIbLJg/WmIpPt7Rmz+VoN9y5peiOdR4oeJoEUv2oezYM3IxDfoMCF7L1ngv3LloWnupfke53JlOWQTTa5NX5X8lgif3oy+GLFfKAkKtVOlNocrS7cvC8C6xXMAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0268.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(316002)(36756003)(1076003)(8936002)(478600001)(110136005)(16576012)(8676002)(5660300002)(2616005)(66476007)(66556008)(186003)(86362001)(66946007)(52116002)(6666004)(26005)(2906002)(956004)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XXhTl40VP7zb95sLInmNVKFei5nIbfADWjs9oys4coN6ThQwEqS2mk9rX8ivt8F1ICDYgXjrXQxsD9k/1Ckct6gCeQwTA4IRSUq3ZuE0R13sRwMCj8P8nC1s848do0kVK+TEWuC0UdefcJgc1YdCruReHY4GOLaPeZwnhlI2rBhdD80QRCRnuEJWJAiQVNvPTQ0Z8FkSp10g5iNcJDmc7ZeNdRk5ij+AU7sU4cjncSEwb78F2moDpG3mS46mCRO8/OZzUhi4Xp+NqkUxtjhIy8sjtA94bn6XRY1Mf/ak7f3mgKXLQBpj67UmWItQd8jWndanJl501DpBmdNM5//l0YWao0QLANPlDntIOwlk+Izo84QBeypZBvs0uzaVzmLFqLkKHi6pELK/JfcN3nn3sZMrCBQdGtELUlUaQqWZBBh1lha47L/X7Epxh+NHFVuorVfZx4h1J7JzdTXR1Uf8y+rZBN/LareKMxTNifB9OFysqcp5aUWx0e6bJQE9q8b5wuCLBW9BbqD1RPMRlo+iH9VCEz6FrV7uXCOGMP42SicnKWYOQR0lKuVBpbXGUqgVytBxgwgNszRn0W1K0gb3o4V+Ades2kvn7ORSzN0XhzkjKNE+vLMGhOBgxyIAl8Kuos/J1spNUbWG2H737NKIoA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff97d24-9fb4-45cb-a173-08d84f228fd9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0268.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2020 09:28:33.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hC5922/1AVdYOEFPeZGQ12Fn3JJ8jWEmB+As/yEBYfYVnIr/1jW6ihF5LnH/sP+BxRdQ1Ah0+kyYJyrNVa/mTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for a new port mode that is a backplane connection without
support for auto negotiation.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 46c3c1ca38d6..859ded0c06b0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -166,6 +166,7 @@ enum xgbe_port_mode {
 	XGBE_PORT_MODE_10GBASE_T,
 	XGBE_PORT_MODE_10GBASE_R,
 	XGBE_PORT_MODE_SFP,
+	XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG,
 	XGBE_PORT_MODE_MAX,
 };
 
@@ -1634,6 +1635,7 @@ static enum xgbe_mode xgbe_phy_an73_redrv_outcome(struct xgbe_prv_data *pdata)
 	if (ad_reg & 0x80) {
 		switch (phy_data->port_mode) {
 		case XGBE_PORT_MODE_BACKPLANE:
+		case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 			mode = XGBE_MODE_KR;
 			break;
 		default:
@@ -1643,6 +1645,7 @@ static enum xgbe_mode xgbe_phy_an73_redrv_outcome(struct xgbe_prv_data *pdata)
 	} else if (ad_reg & 0x20) {
 		switch (phy_data->port_mode) {
 		case XGBE_PORT_MODE_BACKPLANE:
+		case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 			mode = XGBE_MODE_KX_1000;
 			break;
 		case XGBE_PORT_MODE_1000BASE_X:
@@ -1782,6 +1785,7 @@ static void xgbe_phy_an_advertising(struct xgbe_prv_data *pdata,
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		XGBE_SET_ADV(dlks, 10000baseKR_Full);
 		break;
 	case XGBE_PORT_MODE_BACKPLANE_2500:
@@ -1874,6 +1878,7 @@ static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata)
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
 		return XGBE_AN_MODE_CL73;
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		return XGBE_AN_MODE_NONE;
 	case XGBE_PORT_MODE_1000BASE_T:
@@ -2156,6 +2161,7 @@ static enum xgbe_mode xgbe_phy_switch_mode(struct xgbe_prv_data *pdata)
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		return xgbe_phy_switch_bp_mode(pdata);
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		return xgbe_phy_switch_bp_2500_mode(pdata);
@@ -2251,6 +2257,7 @@ static enum xgbe_mode xgbe_phy_get_mode(struct xgbe_prv_data *pdata,
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		return xgbe_phy_get_bp_mode(speed);
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		return xgbe_phy_get_bp_2500_mode(speed);
@@ -2426,6 +2433,7 @@ static bool xgbe_phy_use_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode)
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		return xgbe_phy_use_bp_mode(pdata, mode);
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		return xgbe_phy_use_bp_2500_mode(pdata, mode);
@@ -2515,6 +2523,7 @@ static bool xgbe_phy_valid_speed(struct xgbe_prv_data *pdata, int speed)
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		return xgbe_phy_valid_speed_bp_mode(speed);
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		return xgbe_phy_valid_speed_bp_2500_mode(speed);
@@ -2792,6 +2801,7 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		if ((phy_data->port_speeds & XGBE_PHY_PORT_SPEED_1000) ||
 		    (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10000))
 			return false;
@@ -2844,6 +2854,7 @@ static bool xgbe_phy_conn_type_mismatch(struct xgbe_prv_data *pdata)
 
 	switch (phy_data->port_mode) {
 	case XGBE_PORT_MODE_BACKPLANE:
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 	case XGBE_PORT_MODE_BACKPLANE_2500:
 		if (phy_data->conn_type == XGBE_CONN_TYPE_BACKPLANE)
 			return false;
@@ -3160,6 +3171,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 	/* Backplane support */
 	case XGBE_PORT_MODE_BACKPLANE:
 		XGBE_SET_SUP(lks, Autoneg);
+		fallthrough;
+	case XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG:
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, Backplane);
-- 
2.25.1

