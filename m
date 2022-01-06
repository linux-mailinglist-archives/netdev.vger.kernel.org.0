Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51E8486756
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbiAFQH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:26 -0500
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:64913
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240983AbiAFQHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8GfdlipHMdKVg9mJa3TQRkzOrqmj/IAIZuW0pX9R6eqkJaMirPSe+/BxMWknI1gLqNdx6pHmzlj4Of2KrzLgb4NU5rxB+ZO/HG2EMzjfP/cPJlA1CVJB/26lYLRI4HB/wN8D2HZPJR4vJnTXqu4jC7+Qy5Pl/v2l9NInFrZ0xJS8y36So+/nKvGWoZ924tvbWqYJpVGPiJJkKYsvxol4mzoIIsoehHcIptsK7GvaiiNozwIC8TpDc5Es8HCEy7RnYp5JuNAmPGe/Qup9QbFEicrGaugiz7zLSyvAwJe0rDyxQhGWYNa2WguSK2O1Y452vceJHkYlam2w0C2+sDwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rith8m0QzWQdXM0enrf3J2o+YUHSoCIKXS0QtRTQgx4=;
 b=MYvCoxQxK/jOfyFTZUncCRyHpKYStFrfX9weTG7WyIouaDOtq7DvDGkG32Tbg7miShfx+kJrB0mP6uaVTTSODpY3aW7WRyAnJMwxD0mlmTO4bhMMQNFKfSvHafLwTPJj2Bd4YAbNiN0B4z8Hs44ufVoP91AY14ILOK7LcsXIZ13Ho/D4ClscsiSRnRxJQ55hDvR5DSyZuYA3uAzfyjo44Xdx2g/D1d32AzzzWWKMX9x/I9oghXft10qt9gPAbCqKw2TwT8+1iXHQIiqe5wct5l/rJ47Ckwltoas/MHWVrvQ7bG5Bu8hCzpkqIQpKEK8zHkXbgUe8s0itaT+ecoUoUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rith8m0QzWQdXM0enrf3J2o+YUHSoCIKXS0QtRTQgx4=;
 b=ZR3fWwf3b7cjrgDEwM7epPWUZcJkE+Bqvo6P9cBL1eaGkiml4BjQloKmk7uffL0xsFYFg9ZjPT6JTkZ9xIYDJke4f+fa+mPfG9wkErfnDT4EN/A15SSvzsmgO5KZ3Y0ddgqYmixalFbOsbxzJSES0dyFTxmIMn7J4IPyfZi5Mf6TbJC/cN2x1+fx6T1NNoa3VcRm6ZPPdWxhXuzj11fxq++oCJmmrKVz07VGaxFH8L5AZPTT9m0rpLmsGTkGaKq0GdhLjlsNAAS1camZfB+wMX44GWHTnJn0oYBett/5TMresA47N/Pke9Q+ucyuMo4+3VNqP6W+14nBhioeMrsDKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:21 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:21 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: Introduce flex key elements for Spectrum-4
Date:   Thu,  6 Jan 2022 18:06:46 +0200
Message-Id: <20220106160652.821176-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::19) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d529031-8660-4369-b48a-08d9d12e9f04
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058C271B4CBB432A4CD0120B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coHwL+e/CkHekDA9JsTTniGciPuXFXfP+tC97ATRYl9OEUpZ6TOZLtgRJnH/GC9hki1QeUC3GZ7sBY7IPROYbAOuvcpc2HkBkESs1k8RiA1q1cepvk9EyVcxN65KkmF+BpTCEqvy4yXZEP9okUBmX8Ew6lJjAPUiRMaeJ+vq1oQWTWI+XpOYeecq+I9LqE1q36/0vG7XrB2OCSUbhbDOf7DuyW38WLD7OheNOyzzsq2NvlpSBbjnHbZJeeX1WwR84m4mAxYeNpvlVFIjfAQOpcxBKN8VRfHuUXP73tHOoVl/JofEFFdpkhiDAPDr3SnXyf4OHVQweJJ+gxejE6VExG33mXfTAb3pcTKgtLkA/jDcvtp+tRvk+5/fuqjzqPfDeXuDH9DZi9NCFyigCt346dK6J1pvopN2IZZZMgy0Y96XO7Gp5bWyhPjFVRDg1lkvvYTdswQ5vsQpv52jILEA+QDx1JYIXOLex1MMkBwKUFXwmpd8lnOSdckVLPAN7Uf/4FMr6rctnk2wU8/ZVBF1T0vc7q5Ad34An+RjQcVs7jJA85Wl0B/dRu9JfvTcZvRzxYacVxHlm0qPB5Ks97jDP5kbPShmY/AcxaaMiR/eDyf2y5IyI37R4lGZhf452KUOLKo5oBIjYCWxCTNWgvIvJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(66574015)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RXM0xJrkKoR0+NSiLEHEpP6sKLN+hco2oM0+/m8ll6W52+FwHSD2nunpBCV?=
 =?us-ascii?Q?QsZTXZfw8lcyy9tO/ccPkZ3WdjeusIJYLNlJjV0gMNZceULLvuXnmCS4EDmc?=
 =?us-ascii?Q?AEZblQOUvTVMYCG/qCdbtQ0RCaOmlYWQo+84n+v8VW0wN4Qow4duqMaQP1Ah?=
 =?us-ascii?Q?m3p4Bk3TGwQEO5CLPTyKBmqWyzDpF38rXQhdgloveS7sAOU87kXwlwAC+2NC?=
 =?us-ascii?Q?Jy+iW8Dkwzuc5Lae83KshHvSN9v+ev6nB4reVPJYgB9K0yZimjH0ZDNgsxLB?=
 =?us-ascii?Q?nVZHRdff/SuutvEpUYEm000f19rHNC85bhs9k85StUnRfsCbKBTnxpLuIKx4?=
 =?us-ascii?Q?JGnJ2M349ZiisERVP9S6iTkgseHBKqaNCE+2yeT47Xkgfm8ehCKqpgRrVC/9?=
 =?us-ascii?Q?Pf0/IEAIYhrmd9pEYHwY+8jKJQExsyVQzSRHx60WCTrN6IzQcL5AGRM9ddYF?=
 =?us-ascii?Q?ZmIZDt55QSYzkb5+tR4z5SWJCSO9auRYib9fubHxk7IeacR8FoQczKF2cS/g?=
 =?us-ascii?Q?qS9M9/RfgpGGvlY6874//HFjeKGJx+hb2Xm8n4p7aipWKvR4UHQOSf1lmQI5?=
 =?us-ascii?Q?oymm4km4T7EwD/DhGE4CFsWn76j4vzTMnlL0VFg5GnsHqgvBeZWGJaaPirIf?=
 =?us-ascii?Q?u9+tTkdgxiJOG9oF7PFKZbQSgJRG7VilWcyjNrP8yLiDCYvhm6SrgSgeuSDb?=
 =?us-ascii?Q?FpMRLFXWirZLX5Nrhmy3mhjQ2seWz3ZOU6x+CorKb1bMqxEFALjaUI0TGnIR?=
 =?us-ascii?Q?0v4TJG/3yk995qBPLLEDAhHmCUpjfN3UowekXUnN/qene8sViHQZsXFI+pL0?=
 =?us-ascii?Q?1hDCO0oocYSinlRmkRXrurpnFEZXNhXmDOfn45S4gVKBqLmNAaYLTYNpCaX9?=
 =?us-ascii?Q?Epnmj/9npWButsK7Rx9vJhOJXqLDXdg/q9JHj9lksFzKfo8a1muJrM70GsQ/?=
 =?us-ascii?Q?EfbiKq408zVkp2Zmk2GlpvluKGm5IQfvL5KmZEn8z5XHpdYy1mmIR5a4N024?=
 =?us-ascii?Q?pBE3Y+ZMjS7B+Hc9i7QuTbW7Wl8TG4Bm6kUzBMy38+/PFwCoyUjXW+IkG8HI?=
 =?us-ascii?Q?maNGOYq5Ie6IWWYpPlAxB6iHSZmixKn0dunkyvSwpVIL3TfdH7ScSUe+G00p?=
 =?us-ascii?Q?r3ILQw51evu5in7G/RWaCQeWHIjCz4RnZqvx4mmx6EYqljcXQMAN76VcHrvd?=
 =?us-ascii?Q?sYxKhpHWbVZN2mrKuqFiKMpLsHnLMNBOo+2aaaJcvg6BczfSBcS4aW0VEzaD?=
 =?us-ascii?Q?FucoC5AQ7qL5NGMOmZebA070H1INRI0O2tOrOz2fTHvOJKYhilEd4RV2bDXp?=
 =?us-ascii?Q?ld4TWy43Z5s9tqxByFP5hkuJwd+e1FQX3A7FMFeGkcsP2DdQ+HTRmqAAwnMr?=
 =?us-ascii?Q?yZY1cAZFBIjeGv/o5Z3kdAqAOs8DvcM3/iyyQT9Mak4CfG0AKXOea/Cc9q7P?=
 =?us-ascii?Q?e18cp+bML3LKUgw+PkBAFq/bUYcQhnnE35zCWyF0iuj145V51gak0Py9Vfxc?=
 =?us-ascii?Q?2ljYO4TYCFGFAfhlPs1LQ/jIM693UfzLvgNhHTzXoGBb+9ikBPku7gDobwBW?=
 =?us-ascii?Q?YVQiRUdlVc7fOGHF1rXIjRGGpl2P9R+LCIzIle0kzD892TVWxDM2HWLrjY3r?=
 =?us-ascii?Q?/eRFqRNbjwV0N4mPPdsszzI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d529031-8660-4369-b48a-08d9d12e9f04
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:21.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWSJEPsQFjPVtFDX173d0dLOUEdu4DdUAiZqGhMTxmZqf2fHFVfI+mmeHB6uGI/KbXupfLkyn6BIjEafzkdFTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum-4 ASIC will support more virtual routers and local ports
compared to the existing ASICs. Therefore, the virtual router and local
port ACL key elements need to be increased.

Introduce new key elements for Spectrum-4 to be aligned with the elements
used already for other Spectrum ASICs.

The key blocks layout is the same for Spectrum-4, so use the existing
code for encode_block() and clear_block(), just create separate blocks.

Note that size of `VIRT_ROUTER_MSB` is 4 bits in Spectrum-4,
therefore declare it using `MLXSW_AFK_ELEMENT_INST_U32()`, in order to
be able to set `.avoid_size_check` to true.
Otherwise, `mlxsw_afk_blocks_check()` will fail and warn.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   | 42 +++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8445fc5c9ea3..a49316d0bd37 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1106,6 +1106,7 @@ extern const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops;
 /* spectrum_acl_flex_keys.c */
 extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
+extern const struct mlxsw_afk_ops mlxsw_sp4_afk_ops;
 
 /* spectrum_matchall.c */
 struct mlxsw_sp_mall_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index fa66316234c4..00c32320f891 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -311,3 +311,45 @@ const struct mlxsw_afk_ops mlxsw_sp2_afk_ops = {
 	.encode_block	= mlxsw_sp2_afk_encode_block,
 	.clear_block	= mlxsw_sp2_afk_clear_block,
 };
+
+static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VID, 0x04, 18, 12),
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 9, -1, true), /* RX_ACL_SYSTEM_PORT */
+};
+
+static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4b[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 13, 8),
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER_MSB, 0x04, 21, 4, 0, true),
+};
+
+static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
+	MLXSW_AFK_ELEMENT_INST_BUF(DST_IP_96_127, 0x04, 4),
+};
+
+static const struct mlxsw_afk_block mlxsw_sp4_afk_blocks[] = {
+	MLXSW_AFK_BLOCK(0x10, mlxsw_sp_afk_element_info_mac_0),
+	MLXSW_AFK_BLOCK(0x11, mlxsw_sp_afk_element_info_mac_1),
+	MLXSW_AFK_BLOCK(0x12, mlxsw_sp_afk_element_info_mac_2),
+	MLXSW_AFK_BLOCK(0x13, mlxsw_sp_afk_element_info_mac_3),
+	MLXSW_AFK_BLOCK(0x14, mlxsw_sp_afk_element_info_mac_4),
+	MLXSW_AFK_BLOCK(0x1A, mlxsw_sp_afk_element_info_mac_5b),
+	MLXSW_AFK_BLOCK(0x38, mlxsw_sp_afk_element_info_ipv4_0),
+	MLXSW_AFK_BLOCK(0x39, mlxsw_sp_afk_element_info_ipv4_1),
+	MLXSW_AFK_BLOCK(0x3A, mlxsw_sp_afk_element_info_ipv4_2),
+	MLXSW_AFK_BLOCK(0x35, mlxsw_sp_afk_element_info_ipv4_4b),
+	MLXSW_AFK_BLOCK(0x40, mlxsw_sp_afk_element_info_ipv6_0),
+	MLXSW_AFK_BLOCK(0x41, mlxsw_sp_afk_element_info_ipv6_1),
+	MLXSW_AFK_BLOCK(0x47, mlxsw_sp_afk_element_info_ipv6_2b),
+	MLXSW_AFK_BLOCK(0x43, mlxsw_sp_afk_element_info_ipv6_3),
+	MLXSW_AFK_BLOCK(0x44, mlxsw_sp_afk_element_info_ipv6_4),
+	MLXSW_AFK_BLOCK(0x45, mlxsw_sp_afk_element_info_ipv6_5),
+	MLXSW_AFK_BLOCK(0x90, mlxsw_sp_afk_element_info_l4_0),
+	MLXSW_AFK_BLOCK(0x92, mlxsw_sp_afk_element_info_l4_2),
+};
+
+const struct mlxsw_afk_ops mlxsw_sp4_afk_ops = {
+	.blocks		= mlxsw_sp4_afk_blocks,
+	.blocks_count	= ARRAY_SIZE(mlxsw_sp4_afk_blocks),
+	.encode_block	= mlxsw_sp2_afk_encode_block,
+	.clear_block	= mlxsw_sp2_afk_clear_block,
+};
-- 
2.33.1

