Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985BC606441
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJTPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiJTPWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:22:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EB0198476
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQSKGEIwJQRlqDVsuZRofME4zVYo0qzDyL9GjPw7SlHkBHiVDcJjlpBKnRy+O6XJtzr8/IbFl23ijZlqKw87sDdUmyG78/7cd19MJWBlZHWnf0P0epKOcwUYCHKB57bNrh2HzqvpMO5reUfgM2fyXzsYGN8oPtLE3s3QIrXPv22ILEeNxoY4ARHJn1r/gMl1UdwGAh2AeLbVFRSEyCcXgauSBCoDVWu1mTsHZCbjB9i+mplzAf40UaHbLPQU66DWlSLKK9OP/Pk96Dc1wVw1zY+jkDYotb/OIPYOl890YpgU511MkEMwQZ9ZyP4Zb9TCsbI5anf/GBRndM2I9qqL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvIOsMyYUapuXdji7RAnisH7vlXKYocv5J2zLAA8LfM=;
 b=Wpr1xkXqsUEo4zL+HDOKJz2eEoZpQuwqnsZj4mqLh/dSSSKocpIQNiCdnbKZOo3RTAZfGZtlvxcn12VlP7Bc+LeZvOeJFCUGIknN0snOmJufg1rDtjVkDkbRpo6P7aUNCXaQRH21rzUD8ScVGU5iV1PLVwoTp7lrvaV90tCyl9xoMDrDnRFsMHf+DOeXXxhUiYSbf7Fh2inahNSM/FnvDspTCHW3nkfYctJbRgVSkkQI4DjlYcI+jK1sgwtMixA3tLlydE6WXku3GlX87xt8bX/OeX9qtuWHRAaD01mWy+d8q/Y0t8S7Uj8943zWApsyQg1hoI4KyRv18WviXpJkwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvIOsMyYUapuXdji7RAnisH7vlXKYocv5J2zLAA8LfM=;
 b=EX38OzHGPFO8UOmgGt5AvoJSxijnUe76pqxnoWuwr3PWqc/8jCa97Ss923rDS/yVxwyeX1iWLUaeVFgF6AGnHBOs4Ru9aaQ6BaYzK04RyRfSnaVY6CBa11o+Iz46c7NI/ghfJEYHgNiRhlLMqM+jJY+UHbzSyWkZBTqHma2uQTNoqAFTKVNlN/ow4Hbv5a0y4R4EUzLmi2SwvGpl0HXL0x4wFK+/FITBoEB/mF/QrpvJpDyoWkp1kSy54Kv7nY34jEoLyO0hM87cdHukKZE7OzpHDi4cd9SBCKhQBzpHJs619LkErqmxc16h7Q7nUDARviUW7EcZPMiR0ImwY+J3SA==
Received: from BN0PR02CA0005.namprd02.prod.outlook.com (2603:10b6:408:e4::10)
 by LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Thu, 20 Oct
 2022 15:22:28 +0000
Received: from BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::99) by BN0PR02CA0005.outlook.office365.com
 (2603:10b6:408:e4::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 15:22:28 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=nvidia.com;
Received-SPF: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT116.mail.protection.outlook.com (10.13.176.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:22:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 20 Oct
 2022 08:22:15 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 20 Oct 2022 08:22:12 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Ahern <dsahern@kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: Add support for 800Gbps link modes
Date:   Thu, 20 Oct 2022 17:20:04 +0200
Message-ID: <4acc3f0afefea885b1e40a7a4b768351e7c9be19.1666277135.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666277135.git.petrm@nvidia.com>
References: <cover.1666277135.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT116:EE_|LV2PR12MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: 1648b14f-ec01-479b-6b3b-08dab2aee645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HtOod4uKctaLDgubT0UwZ7klighjOkexP99ezabLndTKGCbhulp753roqjsT6CrP/c+WeKnK60vEYhHhm6fKl7w5+ra10kLg2uHAV7Rtxk/DFGikIJ1YEtulTWcz7siR622Qlv9XjjKsD4Pr0OnMGD8cxk0ple6eOYFfXgYW46cr5Jh7Jj+Mu0PT+5cfiRugQ4RxoGQ4uzdGM+jsRwpUnRi0aBbJJkLZRjTgyibD4K5LgMjkYemgw+p2Fk6Rx+CSUof9aMKCEwTZMiWW6hGsPKVW3DrtAvRQpR37MVIuMBMtmwhLCd5Hgy1jkVxwtx7UcvJZELp8y7ZmndRYFtHTopNFEacPGP86fgjtWD0qF8ytSIjTqo/CaS+1zZdlsAHFjjoE2caHvvg3PdAwJ3IPRolZzIHa4bPzzV47R8EqWv4LybtA/9e1EIZHmg2nVPR1bNLkDw9aZxoedFayZ4UwuXxkcEEsEprYa6HcCv7pfXCYZtu4TMUvYmr8RpV2UTZnow6VTmO/AYzrF9cOmVKYZ6p9JP4OChkwcvovaB9tQ03ft+ygZwWALjGedEV4U5hxj6U4PDQnfTWvblvjJgd48gRyFHbbUBr2fFCuPY6dTkSNSHns94hGVgXotc8sYGm65nsYKj+l6TOUvNhlSqdHIkwcv4Kcfc4EXtpErPqc/Lft7LDYkTnM5guFTEOmlCGqLZ8d5O5+uZ9e4FHYWV8gbf5pnSi5sUiXNjZRpe8YLk87oN3MohTFRwic2HjPmBa77eJWdKZ3wh0ZC3MJOZh1/Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(46966006)(36840700001)(40470700004)(8936002)(82310400005)(26005)(478600001)(2616005)(6666004)(70586007)(82740400003)(86362001)(7696005)(36756003)(186003)(16526019)(2906002)(40480700001)(8676002)(4326008)(41300700001)(107886003)(316002)(336012)(110136005)(36860700001)(70206006)(426003)(54906003)(356005)(7636003)(47076005)(5660300002)(7416002)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:22:28.1678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1648b14f-ec01-479b-6b3b-08dab2aee645
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add support for 800Gbps speed, link modes of 100Gbps per lane.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 21 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0777bed5bb1a..b74f30ec629a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4620,6 +4620,7 @@ MLXSW_ITEM32(reg, ptys, an_status, 0x04, 28, 4);
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2		BIT(10)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4		BIT(12)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8				BIT(15)
+#define MLXSW_REG_PTYS_EXT_ETH_SPEED_800GAUI_8				BIT(19)
 
 /* reg_ptys_ext_eth_proto_cap
  * Extended Ethernet port supported speeds and protocols.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index dcd79d7e2af4..472830d07ac1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1672,6 +1672,19 @@ mlxsw_sp2_mask_ethtool_400gaui_8[] = {
 #define MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN \
 	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_400gaui_8)
 
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_800gaui_8[] = {
+	ETHTOOL_LINK_MODE_800000baseCR8_Full_BIT,
+	ETHTOOL_LINK_MODE_800000baseKR8_Full_BIT,
+	ETHTOOL_LINK_MODE_800000baseDR8_Full_BIT,
+	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT,
+	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT,
+	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_800GAUI_8_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_800gaui_8)
+
 #define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
 #define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
 #define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
@@ -1820,6 +1833,14 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.speed		= SPEED_400000,
 		.width		= 8,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_800GAUI_8,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_800gaui_8,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_800GAUI_8_LEN,
+		.mask_sup_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_800000,
+		.width		= 8,
+	},
 };
 
 #define MLXSW_SP2_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp2_port_link_mode)
-- 
2.35.3

