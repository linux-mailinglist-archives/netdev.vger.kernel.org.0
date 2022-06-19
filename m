Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA1F5509A6
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiFSKah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiFSKae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30A9CE2A
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOmEua/uDbWfUmzU57CRIa8ZPTyP5p3qt+UeFmLaPN0nkYvVXpC8Sr/IgbOqxF8Fc5iDhZW7kN6/wWVMX53YB0GgPGiCO0Vv/58fAi/CofWRxkHPbSHTHOGfF0PBMnA32vF0h57PLhfNotI0X4NFPVuhZB1Jp3F0u3MA38fKY4XekGwUn/Xmg1CHVW4arm6dIRfyWcsRj7iS+OKmgY9YV69MtnPGWLXtfdwH2iUm6PW3qo3bNe2PlREL2imE1BJytzrCGPc/91JZ9yKQaqAK5hCrgCwswvF/2KiUk1FFKl36tk3EtUgoLINIl4cVt6UjrCQEEBwsWaj9Uxjt83EKXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLPi9z4+CgwJp3Cthza4r9uwfzWlMahilISh4td3UEc=;
 b=ZIBAcDkdt1QRJtpTMcj2QV4zYO8mXYiHigE3F6fie5eTmLzFjiuubsJwPOZgaFKgcUL+zsKGI7A6sGNzTwQJfnUyd/Zm9Myxy/LNk2ZLmazYV2JLrj0pUyxh+65m3uf5dFjifvG7krrMge29LPXRGHrm6fc8FahgbweQHcsv7oAX7v/AIpzwg8e9HvSsxGT+c9psugN+BJCDY9yX+IVXnL/kqED+LN/OYU/KcMFH6A7vm2Cjqs6QB/f7/irXoiu9piN6DVs0txg8PMHea5ZNHj4nV8F22sxnbK0NfEAO/zjV6iWt+/RP8ujssdO1JOoJ7AyoBwhKesgzc44efldUIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLPi9z4+CgwJp3Cthza4r9uwfzWlMahilISh4td3UEc=;
 b=ec9Zgefvn2NP9EqaM6CCgRRFNZJnNXLnj9DjnKzfLFGOGS/QgR5kj+JIYDUjvYtsfqR0iuZd1mb1OO/BZI+6YYe8tns/CUWIdWpmrBRi2AyjVTEI9y4e0rwsTgl794ubR2PqI2lH3rU4CgHw/iG+6aCz7j+CcSSm5MJJMXCFNaXtE1NuDs5y9P1ONioS2EjB90yQUWIPvPdeU5QWYcQcyZ3Uq90NTOLxYhSPSwK+EmPFXox2aRFDK13UKVjiMo9AmrY3WzOkdpdeUrMRIwNU4KtLKW8MOXPXjJlH/tWATDIOJWkS9u3HeIS+W0zouxLJ0FwKzddVo4H3c9ofTc3oMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/13] mlxsw: reg: Add SMPE related fields to SFMR register
Date:   Sun, 19 Jun 2022 13:29:14 +0300
Message-Id: <20220619102921.33158-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0156.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68bc3f2f-f559-4559-d8fa-08da51debb29
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11932A9B1F358C52E76AD933B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rK4UtBOEqanY2b2UPtdBUpw5C5BP4WtcdYnh3dO2jcUxgMfneNrkypJ0ot0gI/vXF9YxrvJScWIC1zdlZ7KSq1Ku08aebJjkZ/Unh8oDOkmKacFod8GxkngTsjeyojW2yHOmnlLO3GHp193x0oZOIpzdUEmdD5KAHx9g5AxZLEIiePjcFAp81GiEv/9gy6VgNxfuXvHx3viEiBO9V3+qBOWoj0Sio3S2c/QHuF/4jxc8NWds+TNnY9vIDYhLxkZDbuC+tU+v2/mOm9ILPET/pP2m4KMqBgpUhrdjS6fX5eAcxX1JPDBaHSW9Uv2andtuHwmP/I7YY9n8YdTk5Xb3GCJ/qKyGPyK8cc0oXba/UOTmbIF2Wsa9wDjKwiOGC88nzwrezvwDk5v2hc9soyK6UqgruncPWPlDOhVw582P+RKD00NxjnetUawiFTaeqwFxyZIfjhtNcsU/xcxEfa6r0A+uKhwQt/G6a5w46K4gw9H7Vx9fcZeNQPdf1KM2YuZ075bAwtcNDJBBuiA8/I/GccGlnP8IdUg2uzQVcZHCgAAIXBFjzsyuGSun2ujepVfwJqH/RpEho4QUIkb7sjJ6l8jeRNQWtiKszipNOz0BtwKyOH4iie9FciLDzt2RpV60TbDHNpravbnxc/1fuQnnqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?na8rNO6Db45vMDRp8JhKhiFKRpTZZ9Pc1OdEGWFi2MwxySRSbxA6z11WhZJT?=
 =?us-ascii?Q?EqNSNPrFsaYHqvimzIWQfmTOKY5gJ5MBofrMCINmBxOY1aIBJN2DCAQkTmVX?=
 =?us-ascii?Q?C6JmTEzxNcbH8H9vkIenrBJ/ilTJ8/qi5f62tVQdktbnVIXYYqEEqjG0erDN?=
 =?us-ascii?Q?6XybOpY/5fDw7fXk9cbPqcTY1IwbCT4ZC0OoH5Z7QkAAjYHJBIusnagY/CIp?=
 =?us-ascii?Q?YKlF4oTKKDo7clMaBb0PMJdbMdFgDYY/Vze70vySS1XsPZunq4lBE0cMkgTC?=
 =?us-ascii?Q?78gb/gf3lew1jYrN6r7ciwLAY0ImhKvgkpRf90FAvzvvYRtGudVic+yijOGc?=
 =?us-ascii?Q?pTA4wzaKuU3pPXFficui0OtaujdHjNUcSLAti8z64vut5GHxuzeHKLllHLkJ?=
 =?us-ascii?Q?M2+gYqODZUZpMhRa2hdE3vWf3bTi5xhMRE1GiFW4CP3XGE096ZrFSIAE8K6o?=
 =?us-ascii?Q?epP8pcV6mWBiLMHhrqWH7VgL12TkTN76etzba84052ab5OQyQYfWjiGESb/U?=
 =?us-ascii?Q?BHYorZGHyE0DtM/VNMcJvQG0Ro6HuhxU9x7HV2HePlpN1nyvu6dcwKRyrnKb?=
 =?us-ascii?Q?9tgD3R/epO/s8a1T6OtC7U1N3suKa/CZiVD6i0ylsZ82CNwkiFReR8kZhBC5?=
 =?us-ascii?Q?dYe5Llk4linfOQMk54aX9TMUEAsM2COUu089RoGUyS1YSzLjvRmy0Xgvjk+p?=
 =?us-ascii?Q?e99qnnKdy9UVwOhNeik1oxSCTj7J+FzFH/MmC2t5CCSjZzTaU1E1FekFmKtS?=
 =?us-ascii?Q?w5uRllNp5EOIOnaJjMimUyD6To8ySBNusYOdEpfSUB5SdoZMAxXDS+QlygWt?=
 =?us-ascii?Q?9RDuiNX6kwfA/hF4yz/nppVE9Z8PdElRAf7VepaOkupsLOxRPZED9KvXnRyz?=
 =?us-ascii?Q?zYoUDoB3Vu8+RkwdGKeWSGSqazPw1tRbRAJedI2tKTb4jbJbkXhfDbSezizn?=
 =?us-ascii?Q?zsNW2trE0BRWZeDXzkuAuuUqd4UlvOQe4MwvswOHgYiELAJy0qpFq2JPJNbl?=
 =?us-ascii?Q?TqMPq4dglVXHM9qPx33L3r/c16gnspkI22mzIpnM62r/owje0aiupqNBrxJr?=
 =?us-ascii?Q?o5XO49NfxKqM6Cg0UKlHtWPPqaRMfTGwnm0NO4nGlm7oMA8dJcys3hSjvwy0?=
 =?us-ascii?Q?j9LcyClVasbKoVoauzirkvdGW1w43sxA6kSIRxAykis7d55WqyIZmldoFgSf?=
 =?us-ascii?Q?hKvuvw3XcE3qBxUGYB9z1HklXs0hIf7usdZIVdKuwcdZ2+eAdYY4M4I4ANKR?=
 =?us-ascii?Q?NRml47l8Uzw/o+3gFypiguC77C0hgvGQQFpz9A3uqVdry7t/r+iszshyXLIk?=
 =?us-ascii?Q?OUtFq2n0+NojFk2Af2AKczRbdy2agZpKxlAfqYE2VgTkuvlJvRYrwgrfg+9I?=
 =?us-ascii?Q?2o6amfWNXAqNn9nXYR5MTlBPZsMGEi3VPgXxDxvdL1NmXc2T0S5SPQkc7Wm8?=
 =?us-ascii?Q?pDN+i08Nv/2TWZGhqCetdUiIswTH91QncIjCrKDEFM3PDygdQdGM2AP/f2qK?=
 =?us-ascii?Q?NQ0B9mhwKYd3g7GjbYgK5D4O0E+djh3SVeDROcYbPR5s5QcABQfQ/9FMlvXX?=
 =?us-ascii?Q?lY3stdlAF1/e66X9iBBSQmySwS6xXwQz3zIeBaW6JCp/6ChkMXTqLvz5H/U8?=
 =?us-ascii?Q?Xrh/sxN1/cwi6/VbwzXxIUehxZFG4Bn/OgHMvJ1ouu5nDXdi0o4A85lUBoi8?=
 =?us-ascii?Q?DXrj4Dl4cSENnsy19WTCsIkRtefhvq3I0STgdqtDoeApPf6gMzfaKpZGKnDU?=
 =?us-ascii?Q?f+dWrAJMVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bc3f2f-f559-4559-d8fa-08da51debb29
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:29.1955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02BTKss7fjO9leObrboNS9YMu0SXCDdXhDvXhNaGusxa1tlHzocDDNTOrKGJmTLqLOXPrS8QgA0Ukj486iMtrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFMR register creates and configures FIDs. As preparation unified bridge
model, add some required fields for future use.

The device includes two main tables to support layer 2 multicast (i.e.,
MDB and flooding). These are the PGT (Port Group Table) and the
MPE (Multicast Port Egress) table.
- PGT is {MID -> (bitmap of local_port, SPME index)}
- MPE is {(Local port, SMPE index) -> eVID}

In Spectrum-2 and later ASICs, the SMPE index is an attribute of the FID
and programmed via new fields in SFMR register - 'smpe_valid' and 'smpe'.

Add the two mentioned fields for future use and increase the length of
the register accordingly.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 62e1c2ffb27f..d30b32c02cfb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1761,7 +1761,7 @@ static inline void mlxsw_reg_svpe_pack(char *payload, u16 local_port,
  * Creates and configures FIDs.
  */
 #define MLXSW_REG_SFMR_ID 0x201F
-#define MLXSW_REG_SFMR_LEN 0x18
+#define MLXSW_REG_SFMR_LEN 0x30
 
 MLXSW_REG_DEFINE(sfmr, MLXSW_REG_SFMR_ID, MLXSW_REG_SFMR_LEN);
 
@@ -1858,6 +1858,25 @@ MLXSW_ITEM32(reg, sfmr, irif_v, 0x14, 24, 1);
  */
 MLXSW_ITEM32(reg, sfmr, irif, 0x14, 0, 16);
 
+/* reg_sfmr_smpe_valid
+ * SMPE is valid.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used, when flood_rsp=1 and on
+ * Spectrum-1.
+ */
+MLXSW_ITEM32(reg, sfmr, smpe_valid, 0x28, 20, 1);
+
+/* reg_sfmr_smpe
+ * Switch multicast port to egress VID.
+ * Range is 0..cap_max_rmpe-1
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used, when flood_rsp=1 and on
+ * Spectrum-1.
+ */
+MLXSW_ITEM32(reg, sfmr, smpe, 0x28, 0, 16);
+
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
 				       u16 fid_offset)
-- 
2.36.1

