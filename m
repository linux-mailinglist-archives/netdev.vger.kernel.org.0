Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54B85509A8
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiFSKag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiFSKa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD2CBF73
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQSehKIlq24SCVrG9/4yFbjaUcIOBXAcqToSYrsUmwXdxJPEFDNdYGX+f9a3vV5RcCVvvucJ+BxIKcvyq3ySRgedC7/9ifgeq8jsCQETavjiiGT+NJGNmsURCOSxl/UMZfYqfuDTwkB4oBcpJOioxponFqVTfcfrXMWyAQVwvsddsaMf2iAz+Wo5xmLsKV2bgaUB8psKzNgztQOUBxvFNO/zfnDcx+RX8yNpgFlJG5+3PLDHuYpB4+PRhsFcXvRKq9rccqI8NiYbQ+cPuAOx2hmz3NTOsaCr44VRd+Pwut7cnywAS/D1y8i4NbARWFyySI4TrGITFwBDcXNlTnyEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huUVw5WUha5hBkx4PZPTQ3DFF5KXiv4FLqub/N3uyd4=;
 b=RdQANalLl2SUh4qjaTDGjK0BAvcoe/OegJefj7IuI6iVwm/GuR2So4MsNEObeX5tYmGhhTp436til4L03DxancaI5q7NRgBMeJVSMrWfubHOqW3LbQ4hMtnYLcjDPgNIbgRaOwpuUBtX4Ng5zZe5BpZe+U8tuk3lVYHDNaxaNIlz+4I0rBDnD3QjuqTJu0kzvs6EHuY9wKf+ryXasooyKy3Dhex6rN+YxIEa5PUbFf0TX6ivYgC/gpwp7TVPTyWNSftXsGObgosLY+VFqOs13w5SX0qJMVZ7OXrU6nI/XQFZGxW1+82gJuXlot8HA1QCWP7/s40uZVgxZpqsDqMLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huUVw5WUha5hBkx4PZPTQ3DFF5KXiv4FLqub/N3uyd4=;
 b=G5q7WMa3cGzhNcQABwO9JMbchOy6yG20YRA1w8wQWQECG6y+b31cYezTUShqCjuSbJ8U8Vv1jOXIx+TCoCAQg+D6HUPDYcryqRd7k/RWrO97GHK61O+dtL21+h9LrIeNxR/FPNZbhGa2y9haRoNHUU8Uq09/mRkOLVSPg6qlQk9M/Ed5rJRViKzsam+Q+8TWYIF5uXkn+MtgSvHlTaGj7OJ86mWuOSOL33KCDWWKaZ0MjMEYxhAL3H/tToEc1n3PQIu2AqoK0tFZQUx7o+aCs2cgbBIOj3MRJghLfedj7GRrdZBJnrNFBSLCJxlgxhlP5I4GpKwxmYwUrTV6G6JR5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/13] mlxsw: Add SMPE related fields to SMID2 register
Date:   Sun, 19 Jun 2022 13:29:13 +0300
Message-Id: <20220619102921.33158-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0032.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cd5c5bb-3db9-44df-723d-08da51deb807
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193A9DFFB67595EFEDDB1ADB2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ENCBGndg5wyvvzlGvJ7PC4ZL1LNLGr3Zd/FUzxDEq4OjbjRUW3nSMsUliJelR+z3oI6WOGvpKjUSLt1QhtiJpCJ3M+sI2WRygLTkLf2oHf9uOdnRpGKGdCtPYmhH+e+ydTX9pzrMl7MWLWuDrl8lhpZ/vJP6hR4Hll8nuOGDl/dBYVpmxPOL8CCLTgNF68ZoZu5738pb4PzriyvpnKgvxcEPY/Dgjww2qm2QNwPxXlEGMcmWclXcTdKbu/m/Xpqm8x5AvGKH/nV0RfiM2wa0bMr5pICuQg4HVT+x19iiOPeb/n6zupZI94d4kFU8xMbOUWDJRwz6kbS3HQcLOnEZCQfOMfam5MAzkF+Di+rsl6Tms64JlFfrhimDLCaejhALzq6/ImVzZRP+rFtEup9kjT74mx3NaWKI2U+tb+9CA3Kh0ZWoFLf44nNmYh8jJd4xQacvoLOpz5HcxTWqNmWcuf13fdOS/53bLbza5E5EHUs0HnNAQPUSvho+FLW2RJUkfkK7W3GzybW3lJsjTjVFVkS8OZs2vKn09Z2XucHmtEzltruVUWHLDW3GaKSlZTME3ytbY+HsODkioWPwKJ88ZXMjJ+LZpraEuyBMT9taYw+lBED9IAZkc8qpox+DLw/zAEhjteRvCk6Hz2qCxiSDSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqLRpIJ/Xro7S7L41LlxD7Hsm0Kwzu7gKjs/7x2nVgACXbHov8BvuTmPkEl8?=
 =?us-ascii?Q?rExIJ8vnALfiztMJ9OY1m6guSgTks/fMlju641CWMquvqFyMTLYSnG48fCgA?=
 =?us-ascii?Q?Pua5j8Jc/ZEKTh38OJXIkBOiBGB0NH/hypybqw3FtR2VY1koioG1NSViXNt3?=
 =?us-ascii?Q?IXFumlJV7fiVvqo54FHa/gAFkjhUVF1cc9Z2O/X2Lnbto6BqR+41Hbi9sASl?=
 =?us-ascii?Q?WmExUkH+NlQ84qU1n4UzzuwOP5tfiGn6JEuaQMIxQtOW46ve8whlg0U8BPkH?=
 =?us-ascii?Q?bYzUkoG3W42jt/vITGCj1Jynq6Uew012f5TEVgC89gXFwqzY4cTjOmPfRy1f?=
 =?us-ascii?Q?syrgzV/TNLbmd3h7l7irAEGNDBucMHV+E3ZuRDXI4uOg/+zmaoXH3ZVLDXo4?=
 =?us-ascii?Q?fzZOcQaLeBzFi4F3BJPuJjm4hJH+OZ71ENfvfsys9QPzBgQ1YChqcudp8dGv?=
 =?us-ascii?Q?HlXtZXlD/7UaSDBZxuRQchPHsedyNOn2l1QB/wGtFk95pRGv9HZeyP8ZKzrf?=
 =?us-ascii?Q?iUoBBKzBoU57pGCzV7Z12KmDaH6mPKMZfNvRKouc0xqSGxKM7+xWbb61jBmI?=
 =?us-ascii?Q?Bj3ox3cv5WLYR1NSAPIZoXvBip/Z2mDUeCazrmgUGaOP3sBGMqQ35LDsvlzF?=
 =?us-ascii?Q?LJqgppH45uarOR3ZD7cIw9ZSaCeQ/kSJ4vBvUHXXk9Dmb91aRJiCFIw2FUoR?=
 =?us-ascii?Q?gmQ3p1xFMhWxNSRhXEcYIFxpQy+jks8XoeMPi2fxUyaL2mJIncQvWyi0JSdA?=
 =?us-ascii?Q?hhaa7i1uawGE8QgSeTV0wdAqJp3gzaHQIkWgVza4xN4MUnD1tzabMeyI7tBn?=
 =?us-ascii?Q?LkO5CULeGqK6VoqirrQrE2xFGRKBB/DQFHyqNWhbLwi+KuTwhFTkBZNppXg2?=
 =?us-ascii?Q?D9roCE3JST/drGSWkm8x5vfDeH2zVAOMRldC9t53pFfedkFyVcNr5sBgyDzv?=
 =?us-ascii?Q?Nri1PGk9px7hQjVQJvi+eS3LQUz5LsyCPKF22I3fkG2q8YzYv5gFjNoawRKs?=
 =?us-ascii?Q?X5DUFSb13M/LV5FOMTK9NkyflaWqHE5RRB5TOtmE1ZGNdqMqjBNzpsrDS/I1?=
 =?us-ascii?Q?1FKkETAxXaYIHmeQjp0fWcONMNPF8HSDU04fRRr+tjL7eFaOvw+X1EljB1L7?=
 =?us-ascii?Q?mi8XwF83E1xzAHCc9L+FEcZBbKWuwfo+Y9ZSK2cBb3xW/jaWKQ9dikzPWXtk?=
 =?us-ascii?Q?IFCXTGCBbg19nRwFrQYIdfpN+4MHJ805vwehQKwC+AaMjTwXgoBYwPKgCneE?=
 =?us-ascii?Q?kAXar0fM8HsiS7E2RQ4boLM2VLb2IDxJlev/JbRKPe9WUCyGcqYuE1xrdNDr?=
 =?us-ascii?Q?2K9GL2SNHMJ18p5st/BLNciIzuNxSD6ZwFxRzzt+eABjf2h3EycWCcQFjmyQ?=
 =?us-ascii?Q?BweegH7xtvfNVaMcvX6kbkgQPTmHeO7W8X4WQg3k+/YPhuH72YfwpOi0b16s?=
 =?us-ascii?Q?2RAIjmAWWLTs/e5DraUYPOHmF3zEXlSbkcIi/yuErSDIE5WKy6F1inbDy583?=
 =?us-ascii?Q?iWn1s63m5juYrAszZmdpTQ7LicrokudoklDJSbO2AGbMEs7VqTAFDSVt4Uf8?=
 =?us-ascii?Q?qSfd2c3TCeUcTntaNs8tvv6yGQopIgZxUDhOAAxxee5fLfaIWP8BoniPyMxG?=
 =?us-ascii?Q?q5V0Id+W0me9+K8iQkev5xalbQo2oa+LTm4ACEUaa1ikMK0xlKhiLaFgHQsx?=
 =?us-ascii?Q?yVNTwYMhVbgoYQRXozHz2WCmibereCkj3B49dx7xMp9Kv22/phGgmY/SMUnc?=
 =?us-ascii?Q?iXeyHwpAyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd5c5bb-3db9-44df-723d-08da51deb807
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:23.9535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAp16vXJZN+TE20t72OPB9bPZsdvNcdjJra8dbdNOpvBrUaJtzuCpWPHOpsDoEX5ZFQYMtvFeN/ATEx4rYddhQ==
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

SMID register maps multicast ID (MID) into a list of local ports.
As preparation for unified bridge model, add some required fields for
future use.

The device includes two main tables to support layer 2 multicast (i.e.,
MDB and flooding). These are the PGT (Port Group Table) and the
MPE (Multicast Port Egress) table.
- PGT is {MID -> (bitmap of local_port, SPME index)}
- MPE is {(Local port, SMPE index) -> eVID}

In Spectrum-1, both indexes into the MPE table (local port and SMPE) are
derived from the PGT table. Therefore, the SMPE index needs to be
programmed as part of the PGT entry via new fields in SMID - 'smpe_valid'
and 'smpe'.

Add the two mentioned fields for future use and align the callers of
mlxsw_reg_smid2_pack() to pass zeros for SMPE fields.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 21 ++++++++++++++++++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  7 ++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 03c9fa21acd0..62e1c2ffb27f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2198,6 +2198,23 @@ MLXSW_ITEM32(reg, smid2, swid, 0x00, 24, 8);
  */
 MLXSW_ITEM32(reg, smid2, mid, 0x00, 0, 16);
 
+/* reg_smid2_smpe_valid
+ * SMPE is valid.
+ * When not valid, the egress VID will not be modified by the SMPE table.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and on Spectrum-2.
+ */
+MLXSW_ITEM32(reg, smid2, smpe_valid, 0x08, 20, 1);
+
+/* reg_smid2_smpe
+ * Switch multicast port to egress VID.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and on Spectrum-2.
+ */
+MLXSW_ITEM32(reg, smid2, smpe, 0x08, 0, 16);
+
 /* reg_smid2_port
  * Local port memebership (1 bit per port).
  * Access: RW
@@ -2211,13 +2228,15 @@ MLXSW_ITEM_BIT_ARRAY(reg, smid2, port, 0x20, 0x80, 1);
 MLXSW_ITEM_BIT_ARRAY(reg, smid2, port_mask, 0xA0, 0x80, 1);
 
 static inline void mlxsw_reg_smid2_pack(char *payload, u16 mid, u16 port,
-					bool set)
+					bool set, bool smpe_valid, u16 smpe)
 {
 	MLXSW_REG_ZERO(smid2, payload);
 	mlxsw_reg_smid2_swid_set(payload, 0);
 	mlxsw_reg_smid2_mid_set(payload, mid);
 	mlxsw_reg_smid2_port_set(payload, port, set);
 	mlxsw_reg_smid2_port_mask_set(payload, port, 1);
+	mlxsw_reg_smid2_smpe_valid_set(payload, smpe_valid);
+	mlxsw_reg_smid2_smpe_set(payload, smpe_valid ? smpe : 0);
 }
 
 /* CWTP - Congetion WRED ECN TClass Profile
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index a6d2e806cba9..a738d0264e53 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -887,7 +887,7 @@ static int mlxsw_sp_smid_router_port_set(struct mlxsw_sp *mlxsw_sp,
 		return -ENOMEM;
 
 	mlxsw_reg_smid2_pack(smid2_pl, mid_idx,
-			     mlxsw_sp_router_port(mlxsw_sp), add);
+			     mlxsw_sp_router_port(mlxsw_sp), add, false, 0);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
 	kfree(smid2_pl);
 	return err;
@@ -1584,7 +1584,7 @@ static int mlxsw_sp_port_smid_full_entry(struct mlxsw_sp *mlxsw_sp, u16 mid_idx,
 	if (!smid2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, 0, false);
+	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, 0, false, false, 0);
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
 		if (mlxsw_sp->ports[i])
 			mlxsw_reg_smid2_port_mask_set(smid2_pl, i, 1);
@@ -1615,7 +1615,8 @@ static int mlxsw_sp_port_smid_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!smid2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, mlxsw_sp_port->local_port, add);
+	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, mlxsw_sp_port->local_port, add,
+			     false, 0);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
 	kfree(smid2_pl);
 	return err;
-- 
2.36.1

