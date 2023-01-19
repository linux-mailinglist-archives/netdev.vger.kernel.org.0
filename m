Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA86673594
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjASKeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjASKdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51DB6DB2E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGzaizJ6x7nU4/vjQI8H2sYS1ebH4+WQIueymrlYtPp1MlNUfMUZC1SmkKrHSvhc2Wfq1iqZ91uS9GL2aFCSTHuT6TJbVjSPIegjWz6Z5braxQDztQ/rlTAlb9cNdZyWpBZTK+DNSmq/IMLM5FyTtcUH/7c1UBCUj/BeUCQHjibkMEI9Dh48OzNwsRlve5VkAhIPaj4iZC39cclCMQ9P+h6EJ/H13lBPU30VoIq/3Wi/8TfJdGJTi197gH0XwfZv19X/DfLPn0iZ1quebA4Sa+hfw978pyjjwQzpW60WT+mvGp9VkIbW4gjMglB7TBn3BkvbtbvAvFHUe7zr/NrWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfLKXZf+oB/shsi3gnGYsTtLGW6bSxR6BvWYQ120Vuw=;
 b=E5/fSYsR+V4cvtk3JwxWsHxKNX5gQxuvjfCXPVCwcYa1qA2P62SbjEr1h4cYhdS2v3GQw6xYO9vRoti3rXzlb/4tSV56qj6r8dPxkpsfKGRoh2juG3qM83BP/ENWfe5RC5Q/j1L8v6dPiD3s4jHeami0MhIQDvuktLVCBOW5GFfhJ/fuh1nL17BICLpuZkClxJIUPyR5LnILvoBo4Zy6NP+xulqa1q4bKglesgP1tOjO3CiHFDU1EGkA+DHF2jRzMVrA6jn3mgmCvPPZmwSgtyKAS8X3BU+/tzvQSKfqxiWhTFJv76gSV/Fv+xnyeBetEEZrt6bjegYLOA+2Ghsvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfLKXZf+oB/shsi3gnGYsTtLGW6bSxR6BvWYQ120Vuw=;
 b=JQDINN4tcJeBCUdzr+f6gGf54pybaCKCSDJiNEAsGjyoq18r0oHBH+uIo8WNIfkOUWQlaJiw8oeL+bVe97EnZdps5hSp0EI4ckl3/3MpMjcn4xAJ/Zd+fzcmNUg/MndTUO/gAFIG0Hop4kT2+nywUf6yT6JzOZKfHZJiUBqctenR7Jv595ASh0W3NHwfcuIjc6lMX72gLTzq7yza2J2jNT64oykZPr+cPg1llCzN0FBQVAQDI9GUcxHtRLjhs7G9csAPIOM+WN3p6In+IV1rhOghPa2SoZ8jFTA9Whx6FUguc8KMztj8wYvXFNJpDx10vfN9Cwl6NK5muWo+r9pFcQ==
Received: from MW4PR04CA0283.namprd04.prod.outlook.com (2603:10b6:303:89::18)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 10:33:26 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::fe) by MW4PR04CA0283.outlook.office365.com
 (2603:10b6:303:89::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 10:33:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:15 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:33:13 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: Add support of latency TLV
Date:   Thu, 19 Jan 2023 11:32:32 +0100
Message-ID: <713595f5e15879bfe06dca8cc3f040d9dbee46cb.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: f6dcec2e-b066-4874-034d-08dafa08996b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcajl2gkO/dT91kM6OyQk2v3MwbMzDuWgBXTuZNjFK0kU5r9NeFBj8sU2EfnIgyzzMqd1axuPVIM+cgn/a+ZzyqXoQezMCcFeBUxll6woRVPO/ohQi6xITP+xjnO2ZN+6+rRUwfx4dRtFtu553NSOq1XBHH/EuVPUqQx06XBBlIQ7B8uoaKnu8S9TWm+wh2+LKaYGiqq/vcq9YFxy5YQIFI8gjJCLa8bEl8OcKMaap2jBnI0l0RcLCGg2uGDSW/Psq2QDsyg3JsOZZP2wZpx9nsFz+X5IXaxaWHSOWCVi/BDdWZaItHwXe4tPX3Lh3i2yBipCXjTY9ni24ROptGydF/B4Do3NGr7AxJjbTMHriGnQ/IFWMeedOuygx49qJx4bVzwJnVpQIDHHNCEpyZ9muMDTTMZyrTwu3MQAZOBzfGj8v48tf8DN7OsNhuRqoMI2x9X4ao6Jo4ACjVV3HCzfyulpbocL7Xqoslgv9qTwxfSSBjXJPEFuVwDtKeeTNIYQVAJOkzFWKkUNzrLb6nU7xwUyMb5l1reHbd3DmFyBvEKP7uPnWKDSoEaeBr1hG6QaEnEchr/ZMhm/ZCmFlgIcqD4/D8F9zpBIbA4ry2KUUHKy7SPyIFFNC89r3egDn4k6mxhJJYAa2h84/9i5evx9oj06iGOsn2RBMtLAjkjxGMolvjcRIBK+JX45dxH5sTnLTHbgbojOOoqu8zX5kkQgg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(356005)(2906002)(70586007)(8936002)(5660300002)(36860700001)(7636003)(70206006)(82740400003)(426003)(54906003)(6666004)(110136005)(107886003)(7696005)(316002)(86362001)(36756003)(478600001)(47076005)(82310400005)(41300700001)(40480700001)(4326008)(8676002)(186003)(16526019)(336012)(83380400001)(2616005)(26005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:26.5393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6dcec2e-b066-4874-034d-08dafa08996b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The latency of each EMAD can be measured by firmware. The driver can get
the measurement via latency TLV which can be added to each EMAD. This TLV
is optional, when EMAD is sent with this TLV, the EMAD's response will
include the TLV and the field 'latency_time' will contain the firmware
measurement.

This information can be processed using BPF program for example, to
create a histogram and average of the latency per register. In addition,
it is possible to measure the end-to-end latency, and then reduce firmware
measurement, which will result in the latency of the software overhead.
This information can be useful to improve the driver performance.

Add support for latency TLV by default for all EMADs. First we planned to
enable latency TLV per demand, using devlink-param. After some tests, we
know that the usage of latency TLV does not impact the end-to-end latency,
so it is OK to enable it by default.

Note that similar to string TLV, the latency TLV is not supported in all
firmware versions. Enable the usage of this TLV only after verifying it is
supported by the current firmware version by querying the Management
General Information Register (MGIR).

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 35 +++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0ba38c8f7b8f..de5d1e715f3c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -78,6 +78,7 @@ struct mlxsw_core {
 		spinlock_t trans_list_lock; /* protects trans_list writes */
 		bool use_emad;
 		bool enable_string_tlv;
+		bool enable_latency_tlv;
 	} emad;
 	struct {
 		u16 *mapping; /* lag_id+port_index to local_port mapping */
@@ -477,6 +478,12 @@ static void mlxsw_emad_pack_op_tlv(char *op_tlv,
 	mlxsw_emad_op_tlv_tid_set(op_tlv, tid);
 }
 
+static void mlxsw_emad_pack_latency_tlv(char *latency_tlv)
+{
+	mlxsw_emad_latency_tlv_type_set(latency_tlv, MLXSW_EMAD_TLV_TYPE_LATENCY);
+	mlxsw_emad_latency_tlv_len_set(latency_tlv, MLXSW_EMAD_LATENCY_TLV_LEN);
+}
+
 static int mlxsw_emad_construct_eth_hdr(struct sk_buff *skb)
 {
 	char *eth_hdr = skb_push(skb, MLXSW_EMAD_ETH_HDR_LEN);
@@ -506,6 +513,11 @@ static void mlxsw_emad_construct(const struct mlxsw_core *mlxsw_core,
 	buf = skb_push(skb, reg->len + sizeof(u32));
 	mlxsw_emad_pack_reg_tlv(buf, reg, payload);
 
+	if (mlxsw_core->emad.enable_latency_tlv) {
+		buf = skb_push(skb, MLXSW_EMAD_LATENCY_TLV_LEN * sizeof(u32));
+		mlxsw_emad_pack_latency_tlv(buf);
+	}
+
 	if (mlxsw_core->emad.enable_string_tlv) {
 		buf = skb_push(skb, MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32));
 		mlxsw_emad_pack_string_tlv(buf);
@@ -520,6 +532,7 @@ static void mlxsw_emad_construct(const struct mlxsw_core *mlxsw_core,
 struct mlxsw_emad_tlv_offsets {
 	u16 op_tlv;
 	u16 string_tlv;
+	u16 latency_tlv;
 	u16 reg_tlv;
 };
 
@@ -530,6 +543,13 @@ static bool mlxsw_emad_tlv_is_string_tlv(const char *tlv)
 	return tlv_type == MLXSW_EMAD_TLV_TYPE_STRING;
 }
 
+static bool mlxsw_emad_tlv_is_latency_tlv(const char *tlv)
+{
+	u8 tlv_type = mlxsw_emad_latency_tlv_type_get(tlv);
+
+	return tlv_type == MLXSW_EMAD_TLV_TYPE_LATENCY;
+}
+
 static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
 {
 	struct mlxsw_emad_tlv_offsets *offsets =
@@ -537,6 +557,8 @@ static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
 
 	offsets->op_tlv = MLXSW_EMAD_ETH_HDR_LEN;
 	offsets->string_tlv = 0;
+	offsets->latency_tlv = 0;
+
 	offsets->reg_tlv = MLXSW_EMAD_ETH_HDR_LEN +
 			   MLXSW_EMAD_OP_TLV_LEN * sizeof(u32);
 
@@ -545,6 +567,11 @@ static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
 		offsets->string_tlv = offsets->reg_tlv;
 		offsets->reg_tlv += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
 	}
+
+	if (mlxsw_emad_tlv_is_latency_tlv(skb->data + offsets->reg_tlv)) {
+		offsets->latency_tlv = offsets->reg_tlv;
+		offsets->reg_tlv += MLXSW_EMAD_LATENCY_TLV_LEN * sizeof(u32);
+	}
 }
 
 static char *mlxsw_emad_op_tlv(const struct sk_buff *skb)
@@ -813,7 +840,7 @@ static const struct mlxsw_listener mlxsw_emad_rx_listener =
 static int mlxsw_emad_tlv_enable(struct mlxsw_core *mlxsw_core)
 {
 	char mgir_pl[MLXSW_REG_MGIR_LEN];
-	bool string_tlv;
+	bool string_tlv, latency_tlv;
 	int err;
 
 	mlxsw_reg_mgir_pack(mgir_pl);
@@ -824,11 +851,15 @@ static int mlxsw_emad_tlv_enable(struct mlxsw_core *mlxsw_core)
 	string_tlv = mlxsw_reg_mgir_fw_info_string_tlv_get(mgir_pl);
 	mlxsw_core->emad.enable_string_tlv = string_tlv;
 
+	latency_tlv = mlxsw_reg_mgir_fw_info_latency_tlv_get(mgir_pl);
+	mlxsw_core->emad.enable_latency_tlv = latency_tlv;
+
 	return 0;
 }
 
 static void mlxsw_emad_tlv_disable(struct mlxsw_core *mlxsw_core)
 {
+	mlxsw_core->emad.enable_latency_tlv = false;
 	mlxsw_core->emad.enable_string_tlv = false;
 }
 
@@ -902,6 +933,8 @@ static struct sk_buff *mlxsw_emad_alloc(const struct mlxsw_core *mlxsw_core,
 		    sizeof(u32) + mlxsw_core->driver->txhdr_len);
 	if (mlxsw_core->emad.enable_string_tlv)
 		emad_len += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
+	if (mlxsw_core->emad.enable_latency_tlv)
+		emad_len +=  MLXSW_EMAD_LATENCY_TLV_LEN * sizeof(u32);
 	if (emad_len > MLXSW_EMAD_MAX_FRAME_LEN)
 		return NULL;
 
-- 
2.39.0

