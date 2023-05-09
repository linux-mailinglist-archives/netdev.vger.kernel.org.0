Return-Path: <netdev+bounces-1049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90266FC01F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F06D11C20AF3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABAF125D9;
	Tue,  9 May 2023 07:06:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB253AA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:06:23 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::622])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986824C31
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5TvogdBGhnzUQ8bzS1JkGHku8Z/z4fuuDtYhw1BLU0GbtE/no8IOEEfmm1YOqydrVEhqIAAqjV/rbcNlgB98Tok9rk1enAPv2Sh5on1oJF6qU1CkfeLVZ6ZPyTfqRvjcFFbzDIwmNagYHV2N8XNKaTZc7F/KQJRDcIBeu3r19lzbjrS2/iS+BB92Q8sVHfpa1djnM8d+af5a2v9vo/fiTkzVOL6WN/sBO8VNVXXH1wmDGZ3VoeMUfyyFWALf62uvpvB0W5L/EUTepbXYeSjAdz5f0p6PdM7TthhEkxdpstO7LlnqLYZrE1QCvy30XKNrrVWRBGJ+qFfd3jOc28elQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzVsWpsxg8gzs1LvHZ7mKUQ5piBodmCsbCSwsQDlS6Y=;
 b=n8GQH/Hkr8nkK3587PrnACBeiaFIxmyKgFOZsiHvPECKvpzzgtNO7X4hZR1/IzgceCttz0RrQWDfj13AXXftDiuMkmJBb6IG7fnugCHz1Vxv9IBQ5NoI3ZQ7HcqlalA3yzXioAq1FZSdrvKY8FelnYTSg7gYr+/6u9bUoz92yMoOCYUUmuMVNx/lwhroAXDNZHsdLuH5HBTuZgM5S74KCxyk8mmzh2a59tJjkNWvJJ+wYpvJIoDUSJ1RyqwP8btvnouE820KZsL1jQXb4IEKZoNFQpnzdY1lXEfRyD9sWfYhGZTJesO+vmP1lCz+5+MFj3smPRqdp55PxM01L87bPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzVsWpsxg8gzs1LvHZ7mKUQ5piBodmCsbCSwsQDlS6Y=;
 b=SlvMRxn4FRgjGX8toPOxHJb3LgJRnuUnvGOheKX+3hB0c3PS+ktOzIg9b31h/kUJP2EfwpEeUb+Der88hUH7vfA0DTkg2juxxoZAKZw8uVpboI44Fi+OI4G+Q8f8HBjpY280/gr305FLouAlJM8GMHzg1gvWL7qUYiWm6GiDOftA34B9arn1yY35oL+kIS0WPY/uHRwcyt8oXwXa7s1ZkSS6J9fTmk7D0VOBKqrW4IFIEB922Ky36Qtxr4d/IumNDrhmRtc7zN1Gf8jLhVi3PfXHPHbZzl/4qsZ8BhMgJMTw8K55id+9cNnpaemNN36j2Ik8vignub9wZ0CiXA5WGg==
Received: from DM5PR07CA0118.namprd07.prod.outlook.com (2603:10b6:4:ae::47) by
 DS0PR12MB8765.namprd12.prod.outlook.com (2603:10b6:8:14e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Tue, 9 May 2023 07:06:17 +0000
Received: from DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::ed) by DM5PR07CA0118.outlook.office365.com
 (2603:10b6:4:ae::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Tue, 9 May 2023 07:06:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT115.mail.protection.outlook.com (10.13.173.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33 via Frontend Transport; Tue, 9 May 2023 07:06:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 00:06:02 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 9 May 2023 00:05:58 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<petrm@nvidia.com>, <taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/5] mlxsw: spectrum_flower: Add ability to match on layer 2 miss
Date: Tue, 9 May 2023 10:04:45 +0300
Message-ID: <20230509070446.246088-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509070446.246088-1-idosch@nvidia.com>
References: <20230509070446.246088-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT115:EE_|DS0PR12MB8765:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b2866e-0069-45d2-9f18-08db505be2b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TnGQ8GpL58BCqGd3e4aOUnQrvu8eNqRNlThWdKJ3+8xrYnEwRh+WHS/Ud7/Bvd83QyYO+BXcJW3B3kFt6r+SdvOoD/7kshH/6RL8iN7TLWSwUuvma0f8G8RJ6Y/++IGv4NKCPzotJmZZnsK5YR47WhO49sdwIxANHA4HfROuBU/3pelm8A1RhVdinvsZmUYSnu2xOu1PXbvn2TnEwTkVqYXuukHRaHfHWVlHBcsJ4nn5bMdVyuwO9rXsYLYgdlYR8fOJH+v1hEZDr3dvcWaCa6tN6JX3jcDV+Qb5GfQ2CO1v9GuFC6cENQ0YTs+omh+0G/1rjWmKsaQWR4SjTuPfzImOFyhWIi71zLnle8We4xTjrf34v/YcXhd7XWlVJpcX9qwsIU+WDxikD1JZ/TIuSQUpAy80ktq90ZJzNqZzFkG/VDwXkIiJn3xw+oGRW/xsBP7kyOv9vZsvN7pOgadZ+zFjKTLFWCxPlEydKoT2apzFaWzYC6NcA8IJDb9ZGxXcF1VeuHm8LmnF3L2/vtX1qG8QTURQE5sZRLMwHEh4oe/QuZCxC9YDdmZ1/o9PFZN2trdVK+JoS/YWpsJnX5n4YwfoZPbO5uM/bho+2mz7N27MIn0wDYJ1Bos28rrBe0vBijU4pdUvFB8jGnTyX+sPPJRmFuk4g7UZQ2W/eZ3IE8ZlV4D/HRkP4oZgbnGGhBtgG1v15IwNMuJag0G2sgG0vw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(66574015)(110136005)(54906003)(86362001)(47076005)(316002)(82740400003)(41300700001)(6666004)(70206006)(70586007)(4326008)(8936002)(8676002)(5660300002)(82310400005)(478600001)(7416002)(36756003)(107886003)(36860700001)(26005)(1076003)(2906002)(186003)(16526019)(356005)(7636003)(40460700003)(426003)(336012)(2616005)(40480700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:06:17.7647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b2866e-0069-45d2-9f18-08db505be2b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8765
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the 'dmac_type' key element to supported key blocks and make use of
it to match on layer 2 miss.

This is a two bits key in hardware with the following values:
00b - Known multicast.
01b - Broadcast.
10b - Known unicast.
11b - Unknown unicast or unregistered multicast.

When 'l2_miss' is set we need to match on 01b or 11b. Therefore, only
match on the LSB in order to differentiate between both cases of
'l2_miss'.

Tested on Spectrum-{1,2,3,4}.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_keys.c       |  1 +
 .../mellanox/mlxsw/core_acl_flex_keys.h       |  3 ++-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   |  5 +++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 20 ++++++++++++++-----
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index bd1a51a0a540..81af0b9a4329 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -42,6 +42,7 @@ static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
 	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_64_95, 0x34, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_32_63, 0x38, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_0_31, 0x3C, 4),
+	MLXSW_AFK_ELEMENT_INFO_U32(DMAC_TYPE, 0x40, 0, 2),
 };
 
 struct mlxsw_afk {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 3a037fe47211..6f1649cfa4cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -35,6 +35,7 @@ enum mlxsw_afk_element {
 	MLXSW_AFK_ELEMENT_IP_DSCP,
 	MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
 	MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
+	MLXSW_AFK_ELEMENT_DMAC_TYPE,
 	MLXSW_AFK_ELEMENT_MAX,
 };
 
@@ -69,7 +70,7 @@ struct mlxsw_afk_element_info {
 	MLXSW_AFK_ELEMENT_INFO(MLXSW_AFK_ELEMENT_TYPE_BUF,			\
 			       _element, _offset, 0, _size)
 
-#define MLXSW_AFK_ELEMENT_STORAGE_SIZE 0x40
+#define MLXSW_AFK_ELEMENT_STORAGE_SIZE 0x44
 
 struct mlxsw_afk_element_inst { /* element instance in actual block */
 	enum mlxsw_afk_element element;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 00c32320f891..18a968cded36 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -26,6 +26,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac[] = {
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_l2_smac_ex[] = {
 	MLXSW_AFK_ELEMENT_INST_BUF(SMAC_32_47, 0x02, 2),
 	MLXSW_AFK_ELEMENT_INST_BUF(SMAC_0_31, 0x04, 4),
+	MLXSW_AFK_ELEMENT_INST_U32(DMAC_TYPE, 0x08, 0, 2),
 	MLXSW_AFK_ELEMENT_INST_U32(ETHERTYPE, 0x0C, 0, 16),
 };
 
@@ -50,6 +51,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_ex[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(DMAC_TYPE, 0x00, 24, 2),
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x00, 0, 12),
 	MLXSW_AFK_ELEMENT_INST_U32(PCP, 0x08, 29, 3),
 	MLXSW_AFK_ELEMENT_INST_U32(SRC_L4_PORT, 0x08, 0, 16),
@@ -78,6 +80,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_sip_ex[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_packet_type[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(DMAC_TYPE, 0x00, 30, 2),
 	MLXSW_AFK_ELEMENT_INST_U32(ETHERTYPE, 0x00, 0, 16),
 };
 
@@ -123,6 +126,7 @@ const struct mlxsw_afk_ops mlxsw_sp1_afk_ops = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_0[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(DMAC_TYPE, 0x00, 0, 2),
 	MLXSW_AFK_ELEMENT_INST_BUF(DMAC_0_31, 0x04, 4),
 };
 
@@ -313,6 +317,7 @@ const struct mlxsw_afk_ops mlxsw_sp2_afk_ops = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(DMAC_TYPE, 0x00, 2, 2),
 	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x04, 18, 12),
 	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 9, -1, true), /* RX_ACL_SYSTEM_PORT */
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 6fec9223250b..170a07f35897 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -295,11 +295,6 @@ static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 
 	flow_rule_match_meta(rule, &match);
 
-	if (match.mask->l2_miss) {
-		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
-		return -EOPNOTSUPP;
-	}
-
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported ingress ifindex mask");
 		return -EINVAL;
@@ -327,6 +322,21 @@ static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 				       MLXSW_AFK_ELEMENT_SRC_SYS_PORT,
 				       mlxsw_sp_port->local_port,
 				       0xFFFFFFFF);
+
+	/* This is a two bits key in hardware with the following values:
+	 * 00b - Known multicast.
+	 * 01b - Broadcast.
+	 * 10b - Known unicast.
+	 * 11b - Unknown unicast or unregistered multicast.
+	 *
+	 * When 'l2_miss' is set we need to match on 01b or 11b. Therefore,
+	 * only match on the LSB in order to differentiate between both cases
+	 * of 'l2_miss'.
+	 */
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_DMAC_TYPE,
+				       match.key->l2_miss,
+				       match.mask->l2_miss & BIT(0));
+
 	return 0;
 }
 
-- 
2.40.1


