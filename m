Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFA620DA1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiKHKsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiKHKsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAA9429A4
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8CCPVYN88yZbOFqbtFxslNXtZkXl7bYefUetyIVeQOZiZ1Xq0/1HAo3tyCuQfWJpkl29s0Wlcoq8mq17wNZkVYedMxNXNHpu94TthxwtJlf1koHXZ656hVaakgsQgK9T8qNaKjsh+njbQt3CFt7wUFHHY06DBVDQu3lkQgSN/ahM6OkB1EZ7MDBvL1M5Imul+akc7JzeYWKiaQ5NqsE/R1eU/TJBRkbiLMKR7paruccdYTKb1zNW+b6+Q28P6nRQYr3dn4im5EnnTHeIbjUSwUuYUyzxvGGr3aZ7ZBaQRElxj5/6aVtnOXLZ4nHAKkS5UFvqbi+vxCXu0LNJqIW3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YR5OG9WVlRhkHNDsa2MkQOEA60efe6gGDhHFLTgsQU=;
 b=TxdqT81F2ZxX4PVRp4N2DTtdtNY+METdEEZ5rsL0ZKcPD8cqSmW1igfRShHbARn8O+SoQqOtJBhmIbbYzP3Q5cDnk7k7e8lJNUJfMwNKXzsIfeAgUli6HeE2DL7ka4ttb7eGMk6MAVfOIassyOTZnJUNzyIrwcex0CQA0EXo+1g3jRWNiGJM7F/ccV0ZCmpP2NcNk9eXGHnfoEkkSIH/JggM74bImCjzxEi83ybQWYuivWVrX655V3AFhy4Ugm6UfNqgDJ9K+jn26adLd8VxAtZJ6WnnK8ycQM2Tf+uHgjuWHc+YK0fZZhUCTg+Dam5+LgVmKDVGLoKRFE4v3eu/XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YR5OG9WVlRhkHNDsa2MkQOEA60efe6gGDhHFLTgsQU=;
 b=hJ7c0czasSouveSdeJdzdQuVsMcEprENPc4pKpqlkGXXkrLP2l0XRwaBocAoYbTAR5sFPlQwCwI46u1+yK8/azpnoEI30L8iTwyNVMRgBk7qscAdRWmEpGlSOq2cbB71BUzOJH/cWZS/cT8ybsFqTuAXYXXWwmKxZ9HMocgQxBp/yXFPNISKPFul1sQf407e4ILzh/5oAz58fPCFDoeDmuxUxCWMkl7u2WxZ1WWPysjWqeb98ICQX7a26doc85HfKj6jpshFo/IpfJcw+svq6z13s9l5YZ9mvh+CH2QQsmRsco42gF00QPAe8viXp30rGkEluuhKEoEEGNsT69Fuvw==
Received: from BN1PR12CA0005.namprd12.prod.outlook.com (2603:10b6:408:e1::10)
 by SN7PR12MB6909.namprd12.prod.outlook.com (2603:10b6:806:263::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:12 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::be) by BN1PR12CA0005.outlook.office365.com
 (2603:10b6:408:e1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:47:56 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:47:52 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
Date:   Tue, 8 Nov 2022 11:47:11 +0100
Message-ID: <861f29bb2764d19e9c8a60749c1ad3b187e948eb.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|SN7PR12MB6909:EE_
X-MS-Office365-Filtering-Correlation-Id: da2711a5-ecc0-4218-75df-08dac176bb4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtQDC3KJwPTK1cCrfUrqQect6esOgcSFvyT52ZtjjAYTRDK9BTlFIWw3knTS1B+jO0L7VNkKt0SG/56Z35vIpV3+wdMst5jcgoaoAMqKTp2kyhhPHIrvWJ4AxXPCYuEykkMhBUQjheYJ89ssU8JCv6PNw/pkVGtv2O0iktcHnOA+cWEU6EYLCFnb+fePdC09WxwcBZx4nsYkGYzv+IDy9UArBQ6EHXf0TFA73FslAdQ2oQ/1+H2l2PAUdeBVoHuefidxCrTF4xXm4TadwMANMT04fKEEN3yvmTzJAWmARb5ETYD6LrJb2/UeFAkQzDzErQpDTz3FiJSqkcGIKEOts3gzIIUxbUxGSvWJO0BdPxXgMe0UJz+EoBV+KepCB/XAYtymVF/L2UnuCrrFjHXP9SvG8JddE7PAySXd0ulqJxIeyIJsUz0OG9T8nsOFLwWg7y0vbW0nXbPSL14zNWlgCRd2nCwpiN+y5gfrkoIcxiYuEvLXwWUjExx9bJWDjcC2Y7suHcqpo3EQEz8tYpLkxyfDVP2g9xjIB5/RvOmFSFLXa0KBrSqPnqZH3VlM6LIdr17T3KiFKlXB6exX+a4qVThpzutBifHWzrx4UrFZeez87OR82g32Wob23NVQGTVjEh6CR5rjmWPhy8n5IANf0pSx5WOkNoABd7y5S+JLrQ8qp5k/mCd50MslGuSSed+VUrvoCWTvVwBSTJQvqBxJaEakH+zILqX6530nBkVQyNTmTItmZi6xIzcH1E8SwZ+Ilq2PyJenby1X5IgK9dRCog==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(36756003)(82740400003)(86362001)(7636003)(356005)(40480700001)(40460700003)(2906002)(7696005)(47076005)(16526019)(336012)(26005)(186003)(107886003)(2616005)(426003)(83380400001)(6666004)(36860700001)(8676002)(70206006)(478600001)(110136005)(54906003)(82310400005)(8936002)(316002)(4326008)(70586007)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:11.6901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da2711a5-ecc0-4218-75df-08dac176bb4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Register the previously added packet traps with devlink. This allows
user space to tune their policers and in the case of the locked port
trap, user space can set its action to "trap" in order to gain
visibility into packets that were discarded by the device due to the
locked port check failure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 25 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b74f30ec629a..7240af45ade5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6316,6 +6316,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_BUFFER_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_EAPOL,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f4bfdb6dab9c..899c954e0e5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -510,6 +510,9 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(20, 10240, 4096),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(21, 128, 128),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -628,6 +631,11 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
 		.priority = 4,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(EAPOL, 21),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_EAPOL,
+		.priority = 5,
+	},
 };
 
 static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
@@ -1160,6 +1168,23 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 			MLXSW_SP_RXL_DISCARD(ROUTER3, L3_DISCARDS),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(EAPOL, EAPOL, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(EAPOL, EAPOL, TRAP_TO_CPU, true),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(LOCKED_PORT, L2_DROPS),
+		.listeners_arr = {
+			MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, FDB_MISS,
+				      TRAP_EXCEPTION_TO_CPU, false,
+				      SP_L2_DISCARDS, DISCARD, SP_L2_DISCARDS),
+			MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, FDB_MISMATCH,
+				      TRAP_EXCEPTION_TO_CPU, false,
+				      SP_L2_DISCARDS, DISCARD, SP_L2_DISCARDS),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8da169663bda..83477c8e6971 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -25,6 +25,8 @@ enum {
 	MLXSW_TRAP_ID_IGMP_V2_LEAVE = 0x33,
 	MLXSW_TRAP_ID_IGMP_V3_REPORT = 0x34,
 	MLXSW_TRAP_ID_PKT_SAMPLE = 0x38,
+	MLXSW_TRAP_ID_FDB_MISS = 0x3A,
+	MLXSW_TRAP_ID_FDB_MISMATCH = 0x3B,
 	MLXSW_TRAP_ID_FID_MISS = 0x3D,
 	MLXSW_TRAP_ID_DECAP_ECN0 = 0x40,
 	MLXSW_TRAP_ID_MTUERROR = 0x52,
-- 
2.35.3

