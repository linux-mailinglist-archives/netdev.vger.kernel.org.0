Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3EC4AB049
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbiBFPh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242568AbiBFPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:37:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A041CC06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:37:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmCab49sD1fnabpMq1wxlavBKMdhFDFSAr+ksQcOkwy98Ne0G1JMFWr2xQM4lUX2HBLUzIOgQ98q2E89kBbLGcF/M9hkWXH6ZpRrwy0TFQz2jCbj9nJ+cH/6bqykMnHydi0bssYMLIfrTlpdKL/FAS3RwyE04vPg2nMe0ID7M6SCLgOBrdj9OlaV6yrBpUsttXYA5VzK0UXbEomKbaFd5qxZbQn+dPshermyNWFmjdidHTSe0VFQqTJz9T1/s3Rk2cX932GAjhKEiOUdN01SXSLFbfFeW0i1DRk2Kc/m3FnGcAPMydITncSis2uJHgBxwdNi0m1FBpR7y/xixUXwkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhFZnaA0UcRkVu/aROFGmCXMJ3mwDyeA1oV8ELcRXNg=;
 b=OhGgIoI4FFxQJ7QFHxCHDJtdfQJ54xHoIiUoyi8hwLKDJUA1LwPD6QRwHuJm6jrkgGlPuHmNsc8awUBgVfFFonTUjfwJ67ACh4TI/imX/TDcS8wwrRve4wDPJ0dTmAedF5mUYttr0vycCk4oyFYyViJAVoqZl8DFfFtLOCoLBrZDJnyZLv5HDtDX5cO9de2bSyCGkvgYSrina5/YQQVg5VkG+5ZBM+uK3Av2B/SpNCGrKnFLAr1YyETicYRxqBREDC7JzY81q8GTgCUNGPtsIlE484OMomDUNAhdtoOCbWl4sYXeTCo8toVnkfUXSE6vFcMZgzuFGYgUCeJFM0L3ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhFZnaA0UcRkVu/aROFGmCXMJ3mwDyeA1oV8ELcRXNg=;
 b=ivHtCAn1ILq7d0xV4Vg8KURlsG5zI9dSaoTYwDVDzV9P+KBZkESdGXRepoBZahNV2GPWZ5+AqZyMEoUT4CpfvRY4N/871ocRDgkIS2cJD8FwPBB5rvaCp9dLZS3dmc8kVxpZc8SoeuSV5BmDgaF/jMWJowJ7Xg3jGx0ye0mDfDSCTh2vR6+G72PhB6IP6ihuiXsuZmPVqJCAQryN61fakhOiMoUqNiOGvhQ02lE1U6e4F7pMlMJu7xdQkjA/05LJ1McQrTwaSXfgpshaUYey+LcqV6rFftVKdzdnQNIfSpsKd2R2YhwsN14F02TGN59lMqBwV6qZO7OzmpNKTnWnbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3395.namprd12.prod.outlook.com (2603:10b6:408:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 15:37:23 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff%3]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 15:37:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv4 addresses
Date:   Sun,  6 Feb 2022 17:36:11 +0200
Message-Id: <20220206153613.763944-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220206153613.763944-1-idosch@nvidia.com>
References: <20220206153613.763944-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0072.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::25) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1edae700-e1a0-42aa-28bd-08d9e98691b6
X-MS-TrafficTypeDiagnostic: BN8PR12MB3395:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3395858448D12A20BAA4D39AB22B9@BN8PR12MB3395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4DRQjjNLqif4dDcChZ/6cy6olawPIW9FW7f7X/PuzkRlG+seiP+hkCtBALGJRTjrIit3qNbgjaOPE4k9Xg97HMl/B96jMmpY4ltOI0pbODkEP+tkS4Hpun3hHLrHTo9Onj0CoVhiC6tRl9W6U2hVWgXrAlBrGCtKQQGYwowHKcs6gsvrX1voiSSzYu7dZdwbtpNsVfUhXivzf2sTEXqF9zgJs32cF6n+sln/MbjEr4J4hnVaA8ElXFTODedQZuKEPyiHeTqT9x2D+ak4XF7fioRsXvq7L7v8JNrTF7ZhNA4nffJWAxkeh11lSSun4v0KY26sDa8DG5NOh53PekCHuEcHThOngdJ/piyhzAE2mJVp6l20+9wYHf2j+1JDY0M70QeMPDDcCnZdftDFqiQuiZKrSGG5OYv96Jp6kQJbdx+qzTGTrJWllXK/QnqAlswAGlc5dUauyzEhxndV7ubGosHUkt4YGa9A3ZUIhhPYmma9RPsXr3Ihp3esMDUYedgXrRUinsYp22QTcxi86ri56Qzy4jLJW91mItryqqVD7LDggjtBlP/8MUSgEZgkj7J5pBTI4gi2k5/1997BWNpntaY1cK2fVitS04icIKRoSrEykZEBCpz8BGvE6bdVWcHhFIw4s95q4lYtFuMDN+LMzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(186003)(83380400001)(6506007)(6666004)(6512007)(5660300002)(6916009)(316002)(36756003)(8676002)(4326008)(2906002)(66556008)(66476007)(86362001)(8936002)(66946007)(508600001)(107886003)(1076003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3HVuKdxTYGdl0VhjO/pdYKzt0kHT8txpM8osbxgnHp03QLYfceVp5KMrBfT0?=
 =?us-ascii?Q?aVc+ToVtriNpnKtjMh+Smj7ncLlgL6H/v3smLobxd8tm6TsptP+NqHMYKUky?=
 =?us-ascii?Q?DrUKEOZODJPs/vfDclwGuN3/HuMMyyZcxR5lzX2msDAlCiAGGLAZdpqK6cLA?=
 =?us-ascii?Q?vDTkVKhLGAR2eNAod+E1rDEL7/zJKKEkoNbUAZhl6Z/Y4ufeyoa/Y5VX0BkK?=
 =?us-ascii?Q?0JKl1NKn7Ef5tbWpMvTbF4BzxOwcjnteNkPz6AADUz0pu5k39LlkwXGIW9JH?=
 =?us-ascii?Q?6HQEoTHTXC0j/fePDZ13FeMWjquv9/0FsIDfK9hqvb6rR4MOAVEBZ072YoyH?=
 =?us-ascii?Q?C/SF1BXWJPBm/g/+mae4b/6NKAJc03SEP7YopS73hpa6GKyzYO4vwjxSVVL3?=
 =?us-ascii?Q?F93jgca27ZWGrMSQZZ9AYZlhl15dK1Cn/2WO1iUYw6idaeiNgsOItt9DaoeE?=
 =?us-ascii?Q?QNRFtiCMnvDsuHppFp+qXDcQJECK/KBUNhJALxmKphVQGDJgGnBXJt7Sf7YO?=
 =?us-ascii?Q?edY+QDeDMl5njJH3KYvX7UNpa0NWWq4wcfdtUijs5ROtyZYsW//fWTNzskWS?=
 =?us-ascii?Q?lolJb81gX/y0kUHQd0iCuvLeyQsBzWOLHOSKPQKWYOMiWzy5CMa+v1x5P72E?=
 =?us-ascii?Q?gSg1/x3aR4Uz/AiJ2JIw/D8MSu//Qa47DXZ3gRq2dRF1HGd9PwKyl555sTzP?=
 =?us-ascii?Q?UJ1Cyd9t8TLyVXgkLcPpQvL5TZz4mapulqskPs+FIzPOfVJ7QVuzr2ddrWBj?=
 =?us-ascii?Q?9DgKCitRnQexlqBueUcdebCkUaH24LOyoDr1YIHwBiF/ZrzjB94X5ONOg3Fs?=
 =?us-ascii?Q?u7JcTQP06EIt2qhWlOu1hCyfCU9725lG07dFjHYQcMwkdWtlLFuh0PWsjoD3?=
 =?us-ascii?Q?CSCFPsTxmolfOld/LHaeQjYWMh92NeTCYhqBr9vtUD5LhmqOwLF4zZrjILd2?=
 =?us-ascii?Q?2B+EKItfoYOWp0zgZibeHmcjLXE9nvNcd4ZhlXVDkX5Mvd8ulHPy87KjXyH5?=
 =?us-ascii?Q?WOR5vwSZ5wt8if106nLv4V0G7AfiuHDha2MOl7DphPG+w51FxWtnckbHjUl0?=
 =?us-ascii?Q?UGZFMK6ar1INxzCgQ4k9xjUu7JjKrPWDZ8ezgQPv6iwBHii4T1R0YgwU1nRP?=
 =?us-ascii?Q?VywterAvUIzqswudp3GZ4u2yXfxaJleLYFAN4i5Xd5RRs989nf/pgkumBEug?=
 =?us-ascii?Q?gQpO/NI8/fp0jwORcVHl3OtPUnEvqI6lxgSF7JGC8/jvKxVdDkImamzJ09p8?=
 =?us-ascii?Q?Ah2MOo3kuOMGZEX7l0iIWLCOKmCZR7a8kzs7bj0u+Vg6JSWNKBxyaf4t5WEr?=
 =?us-ascii?Q?8Gf+085HemNqztZRJK5lmXvLOTe7TeARXMiWUUaLj05psLmYlgu5aQbuxi0P?=
 =?us-ascii?Q?CVtOqyHNKjz5srxzonRnEUjqGh2EavTRu4ztRYTq9v5O3mkRo28wqBByuy7T?=
 =?us-ascii?Q?lc6sbY8mfd4tfZTjk837xe9KiP+nNnRcF2+oegsldnXwjWcTtJc6U5fCYZfW?=
 =?us-ascii?Q?cXRFNDEJ9oxOqlAG+Q02OEyJuwScrWFL5ti0eOLTCF8V6fxcAZ6IWzR5Swya?=
 =?us-ascii?Q?7PaMM/zoVEHCy6ejFkdrNUf5Tjo5BifwVPvrisyTGObwrGnVNUwMpnZYoHXc?=
 =?us-ascii?Q?PGC0zSJAr3Vw0QetWRC5N/o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edae700-e1a0-42aa-28bd-08d9e98691b6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2022 15:37:23.0721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQhqHcfv0umiepVtMM/OAEIcaeaXYYjnrbL6Z4NdcLYEUdfzplDT3T29cuFpGp0klTrZmYmJiMR1/pCYQADkxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3395
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Spectrum-2 supports an ACL action SIP_DIP, which allows IPv4 and IPv6
source and destination addresses change. Offload suitable mangles to
the IPv4 address change action.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 32 +++++++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  3 ++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 12 +++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index b6fe26ee488b..fa33caecc91d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -2002,6 +2002,38 @@ MLXSW_ITEM32(afa, ip, ip_63_32, 0x08, 0, 32);
  */
 MLXSW_ITEM32(afa, ip, ip_31_0, 0x0C, 0, 32);
 
+static void mlxsw_afa_ip_pack(char *payload, enum mlxsw_afa_ip_s_d s_d,
+			      enum mlxsw_afa_ip_m_l m_l, u32 ip_31_0,
+			      u32 ip_63_32)
+{
+	mlxsw_afa_ip_s_d_set(payload, s_d);
+	mlxsw_afa_ip_m_l_set(payload, m_l);
+	mlxsw_afa_ip_ip_31_0_set(payload, ip_31_0);
+	mlxsw_afa_ip_ip_63_32_set(payload, ip_63_32);
+}
+
+int mlxsw_afa_block_append_ip(struct mlxsw_afa_block *block, bool is_dip,
+			      bool is_lsb, u32 val_31_0, u32 val_63_32,
+			      struct netlink_ext_ack *extack)
+{
+	enum mlxsw_afa_ip_s_d s_d = is_dip ? MLXSW_AFA_IP_S_D_DIP :
+					     MLXSW_AFA_IP_S_D_SIP;
+	enum mlxsw_afa_ip_m_l m_l = is_lsb ? MLXSW_AFA_IP_M_L_LSB :
+					     MLXSW_AFA_IP_M_L_MSB;
+	char *act = mlxsw_afa_block_append_action(block,
+						  MLXSW_AFA_IP_CODE,
+						  MLXSW_AFA_IP_SIZE);
+
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append IP action");
+		return PTR_ERR(act);
+	}
+
+	mlxsw_afa_ip_pack(act, s_d, m_l, val_31_0, val_63_32);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_ip);
+
 /* L4 Port Action
  * --------------
  * The L4_PORT_ACTION is used for modifying the sport and dport fields of the packet, e.g. for NAT.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 16cbd6acbb01..db58037be46e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -92,6 +92,9 @@ int mlxsw_afa_block_append_fid_set(struct mlxsw_afa_block *block, u16 fid,
 int mlxsw_afa_block_append_mcrouter(struct mlxsw_afa_block *block,
 				    u16 expected_irif, u16 min_mtu,
 				    bool rmid_valid, u32 kvdl_index);
+int mlxsw_afa_block_append_ip(struct mlxsw_afa_block *block, bool is_dip,
+			      bool is_lsb, u32 val_31_0, u32 val_63_32,
+			      struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_l4port(struct mlxsw_afa_block *block, bool is_dport, u16 l4_port,
 				  struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_police(struct mlxsw_afa_block *block,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 70c11bfac08f..6e43a6ba09bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -511,6 +511,8 @@ enum mlxsw_sp_acl_mangle_field {
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN,
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_SPORT,
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP4_SIP,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP4_DIP,
 };
 
 struct mlxsw_sp_acl_mangle_action {
@@ -561,6 +563,9 @@ static struct mlxsw_sp_acl_mangle_action mlxsw_sp_acl_mangle_actions[] = {
 
 	MLXSW_SP_ACL_MANGLE_ACTION_UDP(0, 0x0000ffff, 16, IP_SPORT),
 	MLXSW_SP_ACL_MANGLE_ACTION_UDP(0, 0xffff0000, 0,  IP_DPORT),
+
+	MLXSW_SP_ACL_MANGLE_ACTION_IP4(12, 0x00000000, 0, IP4_SIP),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP4(16, 0x00000000, 0, IP4_DIP),
 };
 
 static int
@@ -615,6 +620,13 @@ static int mlxsw_sp2_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_afa_block_append_l4port(rulei->act_block, false, val, extack);
 	case MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT:
 		return mlxsw_afa_block_append_l4port(rulei->act_block, true, val, extack);
+	/* IPv4 fields */
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP4_SIP:
+		return mlxsw_afa_block_append_ip(rulei->act_block, false,
+						 true, val, 0, extack);
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP4_DIP:
+		return mlxsw_afa_block_append_ip(rulei->act_block, true,
+						 true, val, 0, extack);
 	default:
 		break;
 	}
-- 
2.33.1

