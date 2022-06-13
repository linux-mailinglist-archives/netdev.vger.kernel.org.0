Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E87D549A56
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241750AbiFMRq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241630AbiFMRqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:46:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B475170659
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzphA8jrYV/W7vdn81McRCFjWwnisKhlEWUx2g1JIpAhWL3ucYdnSM72b1pW7C2fm7WOLeROYdrpZeApyGLCdyxfDwl3Er4Wf5j8MD9cPr8nN3ufQKpOqzfur9Ykhy6FNntrU7r4yKwt8cKfjQckct3mE9rMjjphcHWQ8tAm3CArYHb+SB54C3QE0pJSIDCXg7OS0vlbmY9bijIBatYj+aL055R9AjvAo92l+HnZNBnT4HlXrFm/UiRP4hTSdoruq0ALSKnuBObIhWqQROQJ2bdf/Gbn2r0PWpXw7DdPuJWyc7Huc0fEEOQuArrGtiL0cO1bn5eeHU6zh3+onY/uEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKKDOsqNeH9iG7pJ1cNQlW6knKr18VGjc3zQ+B+CPso=;
 b=FYJm5IatYkYKBfJ9RTGhj9qh139RXRwtG7OM6xCO5hDVCGgJmzS3XCAy+HNw/K3dnG719m6q4nWseJVgqLaTqu5fRTrUL+HK5S5rhV5XpGUvsZWnljEpmjDXlrptjQzle9UKy8i5JNfhu2ZevaknhTjDyrBfB5AnRf2f+UfNW745lQn0GnVYBCJMI+ozJPpyU8CFgv9yWKn4QQ6/eLK6mUDPatGVOJbHdLbj/Rzid0HA9O9Q03cRpELRaWrnIKfRxFckCKPL1Or1wHCeKPr26psxFnwSmZmvC0s+zETjyrZhCn0pnarZa+pw5BWwKxTM5hVJdeXx0kVbWvDcrOfBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKKDOsqNeH9iG7pJ1cNQlW6knKr18VGjc3zQ+B+CPso=;
 b=RqktnNUhRQZVIFaNK68eSJJzWj/16K8EHsZOr4wBm/2u+3Z/6YkqwB5VuDQ5Uq+R02q29gJymeRjt5A/BgGZK4qj447vV7sdjlej/3MAF1tjYyRG4BSNZxKTe9cbajO6JXVMmvA/rdM6V2Pzzk3i2LYE25nIhL0zdmDoDFu6fhNdGBFsIbbWRVpLfTCD88fTOTcCB/47xP2t5shI2fNR35/TanQXwOByYKeKrXDel+JKg6RgWfUFR0QgezM3WM6VeeROqqzgKj6LnbJopnShM3RFpHLm9q2m74Ig1RLWc6O/iwUZFlCBEPOJdvwKdtSRVHxq8f6HDDBqMeWfUe/ayQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 13:22:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 13:22:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: Revert "Introduce initial XM router support"
Date:   Mon, 13 Jun 2022 16:21:14 +0300
Message-Id: <20220613132116.2021055-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613132116.2021055-1-idosch@nvidia.com>
References: <20220613132116.2021055-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0020.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c3d0618-70e4-444a-a327-08da4d3fb439
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB536129E66019CCB6754F494DB2AB9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jw+RrJwhVaNMH3vfhs0XomQ07RyYxpkX1XALrWxTDScmVmOMNDFR7cS8LhnYIi9hW1iplS3aFZVUqpkOkajzxILv1IxXDBX2yhrH4u23Jt1NMEAMQZo1oDLaKvAheG7bc6cxbyjw1JdDYAwNCgybQxo3oBwl1PKJN/3w4jJjjHx0eJV6q5XC2/Uw8xNWkwGEgiKyhr5tWhUF49VyM3kRnMIFgzZvYk4EEixQV6CsEbe2aXeffZZ2925sEbPYY+JAO5bdLIUsg5jzS1waP3+7fJ1zO+VNfA04aRjDcVUzPnCk5vXyIg/ZoSOuOt4Bwt19oCpgQlaLpC3azRA38PgnvtCBWAVX+Jj3CNmnXK9XUi6KDBUTYRQXHYon9PVVHoKWIvSJ1CQw8wcJDlPvwEnFLpvcV4NPIjAhevTfPw4ZZuvJudemsP862F+W2VC9N7hpC6drVUJMipU7fXV5HTsuUdpWbu3ifXoMPDJG5xumq/4IsVA9Hh/DtNuwS9qPocY9O/che5mgNs1wUNFa+k39G6KLuFCt14BDAvdF+8NYDL4Rh7Gytn7wZ+k+R6LA6j1SyudF+uH4JcsgoG06MxfmpeEovpRp3kz/5ksxPrxVtLnXEM7XZu8OEvh0s2SlSac18okk67bz21yiVp8kASq/wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(6916009)(36756003)(66476007)(4326008)(66946007)(38100700002)(2906002)(8676002)(107886003)(86362001)(6666004)(66556008)(66574015)(8936002)(6486002)(6512007)(2616005)(26005)(30864003)(5660300002)(6506007)(83380400001)(1076003)(508600001)(186003)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y3gnfNwUGx0o0uPmEF+eLqE3C/+UV9ZzhFlryewbAiB5GK7+UwBbVMZXPxVd?=
 =?us-ascii?Q?EVW5UYmKnT3/vIpNUteasTSiBcONexaGP76WFznpGUBSrDTU5EetbYTUSpX0?=
 =?us-ascii?Q?NmRgOjOH81zKRyPZMAT5U4YUHVWYrtlCz/Sjyg464/vTXPUHWU6pLuKeAuNz?=
 =?us-ascii?Q?kus2de8R6HVUErHRAOallRchFU+u8ei+05QW7A8GeYrFwv2a9+dbMNebuTNR?=
 =?us-ascii?Q?Yz+JNAuXtoMuC3H+9dfu7rk6/+E+WbEd0RMjSYZSo+eQEXzLiBiTp+5D2sdl?=
 =?us-ascii?Q?RhHRoixyDvC/PEhq0MqU/99/+fb5nHv1TBeRdFTYq3wY5SCE4/u+/GbcgFB6?=
 =?us-ascii?Q?t4F3uQKm9KThyMrwiBrocK2UgEGocfJ62NzfcvfyvgOpnom0+NTMztN9grDb?=
 =?us-ascii?Q?zhDyWgfvQjE5ILfWxeMvAaL38uMiHi6F7Ii3F43ytxRgkDRlNPGFLwlJJtdg?=
 =?us-ascii?Q?+f+tjOcy0Arw3DEsv4+RoxbXNSzUtRI102kRKwLz3CZqzkT3eorR2hfMJhKL?=
 =?us-ascii?Q?7QtUFPRMFtaRCCSxTmeGYXFMSLEMnre42d7DtQKZJg7gloHDS62UoKImAnYG?=
 =?us-ascii?Q?CqjRKweaD8MIUZem09zDUdY7nM2zV7qZso4e8aMAxmwDGZJowZxXHPt6m+1s?=
 =?us-ascii?Q?6/J6MkbFsTouz976FMlrLrJOOqMqrq3tM2pgyh6rQ/4YOeYSkiQ3Xdbqauz/?=
 =?us-ascii?Q?ibF7aSS1BcZkikrjb4KUU6sx5ixGCsUl4cRa8FSeAMMoBKe9P6aOk60AK5kK?=
 =?us-ascii?Q?JhJdOMcyD8Qu4EBMpqFQlAPTp1VDOJBA89//C62xbp7eCTFzl64xRM47pqp3?=
 =?us-ascii?Q?RcHlos5QLITwMH52fdOY8sAwgehSAZBhMxV8hW1yydfoGLRLgtedCghwYAu+?=
 =?us-ascii?Q?sVxGCM6GvWyUgjkq7qVmZTWVtgYslCvLcJsk0jCf90uRpBQCUURJImI68uLR?=
 =?us-ascii?Q?62+ojhH2vhuqlzNflGyK1ln0CKW/3Ms61cGL8N8elEfTHiUy8mbdYXWQxOI7?=
 =?us-ascii?Q?7S/GuxR8vNmRj2eKizNuc71V8CdyRSC7NJFH2zZ+MCnVQchgjA4aATHM+ixD?=
 =?us-ascii?Q?KG37NOK5KRSNZe1huniqTU+Eoe7JVKOJgcyrIDsj4fJvS6BawleFeFwxtmGA?=
 =?us-ascii?Q?BbB8Wt5h/EfGzyZwnehq5ZFoDDQNB6ttXBcikKdwVxGH2j2ueb2O0XITk9cE?=
 =?us-ascii?Q?9uvJ3mDGye64mzleR+j+wFtrOsonK351JB0h0HWXTH/8DpqQfQjGnQDYB6Lf?=
 =?us-ascii?Q?70dI0cJS/aqXqoz8j8lySMLeFD3zIS7/DqCyJLBznmbcX+yDO51ikGcO91/w?=
 =?us-ascii?Q?BMg5D37Dp5Gk9MGue5AtPBLhZDydU52mLY2J0+kcKS/rAhxhW6a4R/P7gri3?=
 =?us-ascii?Q?CNuKGHi3KRIgw18ysrtb/6OlgoJRStN3ilDQflP/O+MoG+x41g1WgRMM/HZT?=
 =?us-ascii?Q?FVHQH/Mr4WjuV++y9L4vegVtU7Y76dWUF4tF494356me8SAmOcR1ibE3oVXW?=
 =?us-ascii?Q?wL8i2X/Frebrb2zUSV1IuBAWCbhZTlfTd6BVlNbuo+frDcC0T05p9MGdj4ZQ?=
 =?us-ascii?Q?OCSyIgPZ/KWn3uOrqGc0dL5RF0ZIyACjbNrYMUW5Bnxy8T2XjbslPWd0HtMB?=
 =?us-ascii?Q?dTJys5wNht8t9PmRYIoK7ifrzMdlyt+XpNojzK8XDlVvhzKtyglTyRTvJddl?=
 =?us-ascii?Q?Mm21CG6rDQoGrKnRRGgnga63I3hvotAT4xVk+lbYDdlXu/5mJ9MGhVTe3mbW?=
 =?us-ascii?Q?j8G02b3A+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3d0618-70e4-444a-a327-08da4d3fb439
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 13:22:03.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHqX284i8vvgikv/tty/oJ0B8xICdXG4Od9BA3MnNquSSP9SjJ+bee7t0Webp/DgQXsC6D6MdV8WbYO8gVK3hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

This reverts commit 75c2a8fe8e39 ("Merge branch
'mlxsw-introduce-initial-xm-router-support'").

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 -
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  30 -
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  12 -
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  33 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 585 +------------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   5 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  23 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  10 -
 .../mellanox/mlxsw/spectrum_router_xm.c       | 812 ------------------
 11 files changed, 8 insertions(+), 1518 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 1a465fd5d8b3..c57e293cca25 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -12,7 +12,6 @@ mlxsw_i2c-objs			:= i2c.o
 obj-$(CONFIG_MLXSW_SPECTRUM)	+= mlxsw_spectrum.o
 mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_switchdev.o spectrum_router.o \
-				   spectrum_router_xm.o \
 				   spectrum1_kvdl.o spectrum2_kvdl.o \
 				   spectrum_kvdl.o \
 				   spectrum_acl_tcam.o spectrum_acl_ctcam.o \
diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 51b260d54237..91f68fb0b420 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -343,23 +343,6 @@ static inline int mlxsw_cmd_boardinfo(struct mlxsw_core *mlxsw_core,
 				  0, 0, false, out_mbox, MLXSW_CMD_MBOX_SIZE);
 }
 
-/* cmd_mbox_xm_num_local_ports
- * Number of local_ports connected to the xm.
- * Each local port is a 4x
- * Spectrum-2/3: 25G
- * Spectrum-4: 50G
- */
-MLXSW_ITEM32(cmd_mbox, boardinfo, xm_num_local_ports, 0x00, 4, 3);
-
-/* cmd_mbox_xm_exists
- * An XM (eXtanded Mezanine, e.g. used for the XLT) is connected on the board.
- */
-MLXSW_ITEM32(cmd_mbox, boardinfo, xm_exists, 0x00, 0, 1);
-
-/* cmd_mbox_xm_local_port_entry
- */
-MLXSW_ITEM_BIT_ARRAY(cmd_mbox, boardinfo, xm_local_port_entry, 0x04, 4, 8);
-
 /* cmd_mbox_boardinfo_intapin
  * When PCIe interrupt messages are being used, this value is used for clearing
  * an interrupt. When using MSI-X, this register is not used.
@@ -674,12 +657,6 @@ MLXSW_ITEM32(cmd_mbox, config_profile, set_kvd_hash_double_size, 0x0C, 26, 1);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, set_cqe_version, 0x08, 0, 1);
 
-/* cmd_mbox_config_set_kvh_xlt_cache_mode
- * Capability bit. Setting a bit to 1 configures the profile
- * according to the mailbox contents.
- */
-MLXSW_ITEM32(cmd_mbox, config_profile, set_kvh_xlt_cache_mode, 0x08, 3, 1);
-
 /* cmd_mbox_config_profile_max_vepa_channels
  * Maximum number of VEPA channels per port (0 through 16)
  * 0 - multi-channel VEPA is disabled
@@ -806,13 +783,6 @@ MLXSW_ITEM32(cmd_mbox, config_profile, adaptive_routing_group_cap, 0x4C, 0, 16);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, arn, 0x50, 31, 1);
 
-/* cmd_mbox_config_profile_kvh_xlt_cache_mode
- * KVH XLT cache mode:
- * 0 - XLT can use all KVH as best-effort
- * 1 - XLT cache uses 1/2 KVH
- */
-MLXSW_ITEM32(cmd_mbox, config_profile, kvh_xlt_cache_mode, 0x50, 8, 4);
-
 /* cmd_mbox_config_kvd_linear_size
  * KVD Linear Size
  * Valid for Spectrum only
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index fc52832241b3..ab1cebf227fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3151,18 +3151,6 @@ mlxsw_core_port_linecard_get(struct mlxsw_core *mlxsw_core,
 	return mlxsw_core_port->linecard;
 }
 
-bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port)
-{
-	const struct mlxsw_bus_info *bus_info = mlxsw_core->bus_info;
-	int i;
-
-	for (i = 0; i < bus_info->xm_local_ports_count; i++)
-		if (bus_info->xm_local_ports[i] == local_port)
-			return true;
-	return false;
-}
-EXPORT_SYMBOL(mlxsw_core_port_is_xm);
-
 void mlxsw_core_ports_remove_selected(struct mlxsw_core *mlxsw_core,
 				      bool (*selector)(void *priv, u16 local_port),
 				      void *priv)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c2a891287047..d1e8b8b8d0c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -261,7 +261,6 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 struct mlxsw_linecard *
 mlxsw_core_port_linecard_get(struct mlxsw_core *mlxsw_core,
 			     u16 local_port);
-bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port);
 void mlxsw_core_ports_remove_selected(struct mlxsw_core *mlxsw_core,
 				      bool (*selector)(void *priv,
 						       u16 local_port),
@@ -296,8 +295,7 @@ struct mlxsw_config_profile {
 		used_max_pkey:1,
 		used_ar_sec:1,
 		used_adaptive_routing_group_cap:1,
-		used_kvd_sizes:1,
-		used_kvh_xlt_cache_mode:1;
+		used_kvd_sizes:1;
 	u8	max_vepa_channels;
 	u16	max_mid;
 	u16	max_pgt;
@@ -319,7 +317,6 @@ struct mlxsw_config_profile {
 	u32	kvd_linear_size;
 	u8	kvd_hash_single_parts;
 	u8	kvd_hash_double_parts;
-	u8	kvh_xlt_cache_mode;
 	struct mlxsw_swid_config swid_config[MLXSW_CONFIG_PROFILE_SWID_COUNT];
 };
 
@@ -478,8 +475,6 @@ struct mlxsw_fw_rev {
 	u16 can_reset_minor;
 };
 
-#define MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX 4
-
 struct mlxsw_bus_info {
 	const char *device_kind;
 	const char *device_name;
@@ -488,10 +483,7 @@ struct mlxsw_bus_info {
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
 	u8 low_frequency:1,
-	   read_frc_capable:1,
-	   xm_exists:1;
-	u8 xm_local_ports_count;
-	u8 xm_local_ports[MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX];
+	   read_frc_capable:1;
 };
 
 struct mlxsw_hwmon;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d9660d4cce96..d9bf584234a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -359,8 +359,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 	/* Create port objects for each valid entry */
 	devl_lock(devlink);
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
-		if (mlxsw_m->module_to_port[i] > 0 &&
-		    !mlxsw_core_port_is_xm(mlxsw_m->core, i)) {
+		if (mlxsw_m->module_to_port[i] > 0) {
 			err = mlxsw_m_port_create(mlxsw_m,
 						  mlxsw_m->module_to_port[i],
 						  i);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index f91dde4df152..8dd2479c7937 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1252,12 +1252,6 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_kvd_hash_double_size_set(mbox,
 					MLXSW_RES_GET(res, KVD_DOUBLE_SIZE));
 	}
-	if (profile->used_kvh_xlt_cache_mode) {
-		mlxsw_cmd_mbox_config_profile_set_kvh_xlt_cache_mode_set(
-			mbox, 1);
-		mlxsw_cmd_mbox_config_profile_kvh_xlt_cache_mode_set(
-			mbox, profile->kvh_xlt_cache_mode);
-	}
 
 	for (i = 0; i < MLXSW_CONFIG_PROFILE_SWID_COUNT; i++)
 		mlxsw_pci_config_profile_swid_config(mlxsw_pci, mbox, i,
@@ -1271,30 +1265,6 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	return mlxsw_cmd_config_profile_set(mlxsw_pci->core, mbox);
 }
 
-static int mlxsw_pci_boardinfo_xm_process(struct mlxsw_pci *mlxsw_pci,
-					  struct mlxsw_bus_info *bus_info,
-					  char *mbox)
-{
-	int count = mlxsw_cmd_mbox_boardinfo_xm_num_local_ports_get(mbox);
-	int i;
-
-	if (!mlxsw_cmd_mbox_boardinfo_xm_exists_get(mbox))
-		return 0;
-
-	bus_info->xm_exists = true;
-
-	if (count > MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX) {
-		dev_err(&mlxsw_pci->pdev->dev, "Invalid number of XM local ports\n");
-		return -EINVAL;
-	}
-	bus_info->xm_local_ports_count = count;
-	for (i = 0; i < count; i++)
-		bus_info->xm_local_ports[i] =
-			mlxsw_cmd_mbox_boardinfo_xm_local_port_entry_get(mbox,
-									 i);
-	return 0;
-}
-
 static int mlxsw_pci_boardinfo(struct mlxsw_pci *mlxsw_pci, char *mbox)
 {
 	struct mlxsw_bus_info *bus_info = &mlxsw_pci->bus_info;
@@ -1306,8 +1276,7 @@ static int mlxsw_pci_boardinfo(struct mlxsw_pci *mlxsw_pci, char *mbox)
 		return err;
 	mlxsw_cmd_mbox_boardinfo_vsd_memcpy_from(mbox, bus_info->vsd);
 	mlxsw_cmd_mbox_boardinfo_psid_memcpy_from(mbox, bus_info->psid);
-
-	return mlxsw_pci_boardinfo_xm_process(mlxsw_pci, bus_info, mbox);
+	return 0;
 }
 
 static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 93af6c974ece..de7718b5c21a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8926,582 +8926,10 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
-/* RXLTE - Router XLT Enable Register
- * ----------------------------------
- * The RXLTE enables XLT (eXtended Lookup Table) LPM lookups if a capable
- * XM is present on the system.
- */
-
-#define MLXSW_REG_RXLTE_ID 0x8050
-#define MLXSW_REG_RXLTE_LEN 0x0C
-
-MLXSW_REG_DEFINE(rxlte, MLXSW_REG_RXLTE_ID, MLXSW_REG_RXLTE_LEN);
-
-/* reg_rxlte_virtual_router
- * Virtual router ID associated with the router interface.
- * Range is 0..cap_max_virtual_routers-1
- * Access: Index
- */
-MLXSW_ITEM32(reg, rxlte, virtual_router, 0x00, 0, 16);
-
-enum mlxsw_reg_rxlte_protocol {
-	MLXSW_REG_RXLTE_PROTOCOL_IPV4,
-	MLXSW_REG_RXLTE_PROTOCOL_IPV6,
-};
-
-/* reg_rxlte_protocol
- * Access: Index
- */
-MLXSW_ITEM32(reg, rxlte, protocol, 0x04, 0, 4);
-
-/* reg_rxlte_lpm_xlt_en
- * Access: RW
+/* Note that XRALXX register position violates the rule of ordering register
+ * definition by the ID. However, XRALXX pack helpers are using RALXX pack
+ * helpers, RALXX registers have higher IDs.
  */
-MLXSW_ITEM32(reg, rxlte, lpm_xlt_en, 0x08, 0, 1);
-
-static inline void mlxsw_reg_rxlte_pack(char *payload, u16 virtual_router,
-					enum mlxsw_reg_rxlte_protocol protocol,
-					bool lpm_xlt_en)
-{
-	MLXSW_REG_ZERO(rxlte, payload);
-	mlxsw_reg_rxlte_virtual_router_set(payload, virtual_router);
-	mlxsw_reg_rxlte_protocol_set(payload, protocol);
-	mlxsw_reg_rxlte_lpm_xlt_en_set(payload, lpm_xlt_en);
-}
-
-/* RXLTM - Router XLT M select Register
- * ------------------------------------
- * The RXLTM configures and selects the M for the XM lookups.
- */
-
-#define MLXSW_REG_RXLTM_ID 0x8051
-#define MLXSW_REG_RXLTM_LEN 0x14
-
-MLXSW_REG_DEFINE(rxltm, MLXSW_REG_RXLTM_ID, MLXSW_REG_RXLTM_LEN);
-
-/* reg_rxltm_m0_val_v6
- * Global M0 value For IPv6.
- * Range 0..128
- * Access: RW
- */
-MLXSW_ITEM32(reg, rxltm, m0_val_v6, 0x10, 16, 8);
-
-/* reg_rxltm_m0_val_v4
- * Global M0 value For IPv4.
- * Range 0..32
- * Access: RW
- */
-MLXSW_ITEM32(reg, rxltm, m0_val_v4, 0x10, 0, 6);
-
-static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v6)
-{
-	MLXSW_REG_ZERO(rxltm, payload);
-	mlxsw_reg_rxltm_m0_val_v6_set(payload, m0_val_v6);
-	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
-}
-
-/* RLCMLD - Router LPM Cache ML Delete Register
- * --------------------------------------------
- * The RLCMLD register is used to bulk delete the XLT-LPM cache ML entries.
- * This can be used by SW when L is increased or decreased, thus need to
- * remove entries with old ML values.
- */
-
-#define MLXSW_REG_RLCMLD_ID 0x8055
-#define MLXSW_REG_RLCMLD_LEN 0x30
-
-MLXSW_REG_DEFINE(rlcmld, MLXSW_REG_RLCMLD_ID, MLXSW_REG_RLCMLD_LEN);
-
-enum mlxsw_reg_rlcmld_select {
-	MLXSW_REG_RLCMLD_SELECT_ML_ENTRIES,
-	MLXSW_REG_RLCMLD_SELECT_M_ENTRIES,
-	MLXSW_REG_RLCMLD_SELECT_M_AND_ML_ENTRIES,
-};
-
-/* reg_rlcmld_select
- * Which entries to delete.
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, select, 0x00, 16, 2);
-
-enum mlxsw_reg_rlcmld_filter_fields {
-	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_PROTOCOL = 0x04,
-	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_VIRTUAL_ROUTER = 0x08,
-	MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_DIP = 0x10,
-};
-
-/* reg_rlcmld_filter_fields
- * If a bit is '0' then the relevant field is ignored.
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, filter_fields, 0x00, 0, 8);
-
-enum mlxsw_reg_rlcmld_protocol {
-	MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV4,
-	MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV6,
-};
-
-/* reg_rlcmld_protocol
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, protocol, 0x08, 0, 4);
-
-/* reg_rlcmld_virtual_router
- * Virtual router ID.
- * Range is 0..cap_max_virtual_routers-1
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, virtual_router, 0x0C, 0, 16);
-
-/* reg_rlcmld_dip
- * The prefix of the route or of the marker that the object of the LPM
- * is compared with. The most significant bits of the dip are the prefix.
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, dip4, 0x1C, 0, 32);
-MLXSW_ITEM_BUF(reg, rlcmld, dip6, 0x10, 16);
-
-/* reg_rlcmld_dip_mask
- * per bit:
- * 0: no match
- * 1: match
- * Access: Index
- */
-MLXSW_ITEM32(reg, rlcmld, dip_mask4, 0x2C, 0, 32);
-MLXSW_ITEM_BUF(reg, rlcmld, dip_mask6, 0x20, 16);
-
-static inline void __mlxsw_reg_rlcmld_pack(char *payload,
-					   enum mlxsw_reg_rlcmld_select select,
-					   enum mlxsw_reg_rlcmld_protocol protocol,
-					   u16 virtual_router)
-{
-	u8 filter_fields = MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_PROTOCOL |
-			   MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_VIRTUAL_ROUTER |
-			   MLXSW_REG_RLCMLD_FILTER_FIELDS_BY_DIP;
-
-	MLXSW_REG_ZERO(rlcmld, payload);
-	mlxsw_reg_rlcmld_select_set(payload, select);
-	mlxsw_reg_rlcmld_filter_fields_set(payload, filter_fields);
-	mlxsw_reg_rlcmld_protocol_set(payload, protocol);
-	mlxsw_reg_rlcmld_virtual_router_set(payload, virtual_router);
-}
-
-static inline void mlxsw_reg_rlcmld_pack4(char *payload,
-					  enum mlxsw_reg_rlcmld_select select,
-					  u16 virtual_router,
-					  u32 dip, u32 dip_mask)
-{
-	__mlxsw_reg_rlcmld_pack(payload, select,
-				MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV4,
-				virtual_router);
-	mlxsw_reg_rlcmld_dip4_set(payload, dip);
-	mlxsw_reg_rlcmld_dip_mask4_set(payload, dip_mask);
-}
-
-static inline void mlxsw_reg_rlcmld_pack6(char *payload,
-					  enum mlxsw_reg_rlcmld_select select,
-					  u16 virtual_router,
-					  const void *dip, const void *dip_mask)
-{
-	__mlxsw_reg_rlcmld_pack(payload, select,
-				MLXSW_REG_RLCMLD_PROTOCOL_UC_IPV6,
-				virtual_router);
-	mlxsw_reg_rlcmld_dip6_memcpy_to(payload, dip);
-	mlxsw_reg_rlcmld_dip_mask6_memcpy_to(payload, dip_mask);
-}
-
-/* RLPMCE - Router LPM Cache Enable Register
- * -----------------------------------------
- * Allows disabling the LPM cache. Can be changed on the fly.
- */
-
-#define MLXSW_REG_RLPMCE_ID 0x8056
-#define MLXSW_REG_RLPMCE_LEN 0x4
-
-MLXSW_REG_DEFINE(rlpmce, MLXSW_REG_RLPMCE_ID, MLXSW_REG_RLPMCE_LEN);
-
-/* reg_rlpmce_flush
- * Flush:
- * 0: do not flush the cache (default)
- * 1: flush (clear) the cache
- * Access: WO
- */
-MLXSW_ITEM32(reg, rlpmce, flush, 0x00, 4, 1);
-
-/* reg_rlpmce_disable
- * LPM cache:
- * 0: enabled (default)
- * 1: disabled
- * Access: RW
- */
-MLXSW_ITEM32(reg, rlpmce, disable, 0x00, 0, 1);
-
-static inline void mlxsw_reg_rlpmce_pack(char *payload, bool flush,
-					 bool disable)
-{
-	MLXSW_REG_ZERO(rlpmce, payload);
-	mlxsw_reg_rlpmce_flush_set(payload, flush);
-	mlxsw_reg_rlpmce_disable_set(payload, disable);
-}
-
-/* Note that XLTQ, XMDR, XRMT and XRALXX register positions violate the rule
- * of ordering register definitions by the ID. However, XRALXX pack helpers are
- * using RALXX pack helpers, RALXX registers have higher IDs.
- * Also XMDR is using RALUE enums. XLRQ and XRMT are just put alongside with the
- * related registers.
- */
-
-/* XLTQ - XM Lookup Table Query Register
- * -------------------------------------
- */
-#define MLXSW_REG_XLTQ_ID 0x7802
-#define MLXSW_REG_XLTQ_LEN 0x2C
-
-MLXSW_REG_DEFINE(xltq, MLXSW_REG_XLTQ_ID, MLXSW_REG_XLTQ_LEN);
-
-enum mlxsw_reg_xltq_xm_device_id {
-	MLXSW_REG_XLTQ_XM_DEVICE_ID_UNKNOWN,
-	MLXSW_REG_XLTQ_XM_DEVICE_ID_XLT = 0xCF71,
-};
-
-/* reg_xltq_xm_device_id
- * XM device ID.
- * Access: RO
- */
-MLXSW_ITEM32(reg, xltq, xm_device_id, 0x04, 0, 16);
-
-/* reg_xltq_xlt_cap_ipv4_lpm
- * Access: RO
- */
-MLXSW_ITEM32(reg, xltq, xlt_cap_ipv4_lpm, 0x10, 0, 1);
-
-/* reg_xltq_xlt_cap_ipv6_lpm
- * Access: RO
- */
-MLXSW_ITEM32(reg, xltq, xlt_cap_ipv6_lpm, 0x10, 1, 1);
-
-/* reg_xltq_cap_xlt_entries
- * Number of XLT entries
- * Note: SW must not fill more than 80% in order to avoid overflow
- * Access: RO
- */
-MLXSW_ITEM32(reg, xltq, cap_xlt_entries, 0x20, 0, 32);
-
-/* reg_xltq_cap_xlt_mtable
- * XLT M-Table max size
- * Access: RO
- */
-MLXSW_ITEM32(reg, xltq, cap_xlt_mtable, 0x24, 0, 32);
-
-static inline void mlxsw_reg_xltq_pack(char *payload)
-{
-	MLXSW_REG_ZERO(xltq, payload);
-}
-
-static inline void mlxsw_reg_xltq_unpack(char *payload, u16 *xm_device_id, bool *xlt_cap_ipv4_lpm,
-					 bool *xlt_cap_ipv6_lpm, u32 *cap_xlt_entries,
-					 u32 *cap_xlt_mtable)
-{
-	*xm_device_id = mlxsw_reg_xltq_xm_device_id_get(payload);
-	*xlt_cap_ipv4_lpm = mlxsw_reg_xltq_xlt_cap_ipv4_lpm_get(payload);
-	*xlt_cap_ipv6_lpm = mlxsw_reg_xltq_xlt_cap_ipv6_lpm_get(payload);
-	*cap_xlt_entries = mlxsw_reg_xltq_cap_xlt_entries_get(payload);
-	*cap_xlt_mtable = mlxsw_reg_xltq_cap_xlt_mtable_get(payload);
-}
-
-/* XMDR - XM Direct Register
- * -------------------------
- * The XMDR allows direct access to the XM device via the switch.
- * Working in synchronous mode. FW waits for response from the XLT
- * for each command. FW acks the XMDR accordingly.
- */
-#define MLXSW_REG_XMDR_ID 0x7803
-#define MLXSW_REG_XMDR_BASE_LEN 0x20
-#define MLXSW_REG_XMDR_TRANS_LEN 0x80
-#define MLXSW_REG_XMDR_LEN (MLXSW_REG_XMDR_BASE_LEN + \
-			    MLXSW_REG_XMDR_TRANS_LEN)
-
-MLXSW_REG_DEFINE(xmdr, MLXSW_REG_XMDR_ID, MLXSW_REG_XMDR_LEN);
-
-/* reg_xmdr_bulk_entry
- * Bulk_entry
- * 0: Last entry - immediate flush of XRT-cache
- * 1: Bulk entry - do not flush the XRT-cache
- * Access: OP
- */
-MLXSW_ITEM32(reg, xmdr, bulk_entry, 0x04, 8, 1);
-
-/* reg_xmdr_num_rec
- * Number of records for Direct access to XM
- * Supported: 0..4 commands (except NOP which is a filler)
- * 0 commands is reserved when bulk_entry = 1.
- * 0 commands is allowed when bulk_entry = 0 for immediate XRT-cache flush.
- * Access: OP
- */
-MLXSW_ITEM32(reg, xmdr, num_rec, 0x04, 0, 4);
-
-/* reg_xmdr_reply_vect
- * Reply Vector
- * Bit i for command index i+1
- * values per bit:
- * 0: failed
- * 1: succeeded
- * e.g. if commands 1, 2, 4 succeeded and command 3 failed then binary
- * value will be 0b1011
- * Access: RO
- */
-MLXSW_ITEM_BIT_ARRAY(reg, xmdr, reply_vect, 0x08, 4, 1);
-
-static inline void mlxsw_reg_xmdr_pack(char *payload, bool bulk_entry)
-{
-	MLXSW_REG_ZERO(xmdr, payload);
-	mlxsw_reg_xmdr_bulk_entry_set(payload, bulk_entry);
-}
-
-enum mlxsw_reg_xmdr_c_cmd_id {
-	MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V4 = 0x30,
-	MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V6 = 0x31,
-};
-
-#define MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN 32
-#define MLXSW_REG_XMDR_C_LT_ROUTE_V6_LEN 48
-
-/* reg_xmdr_c_cmd_id
- */
-MLXSW_ITEM32(reg, xmdr_c, cmd_id, 0x00, 24, 8);
-
-/* reg_xmdr_c_seq_number
- */
-MLXSW_ITEM32(reg, xmdr_c, seq_number, 0x00, 12, 12);
-
-enum mlxsw_reg_xmdr_c_ltr_op {
-	/* Activity is set */
-	MLXSW_REG_XMDR_C_LTR_OP_WRITE = 0,
-	/* There is no update mask. All fields are updated. */
-	MLXSW_REG_XMDR_C_LTR_OP_UPDATE = 1,
-	MLXSW_REG_XMDR_C_LTR_OP_DELETE = 2,
-};
-
-/* reg_xmdr_c_ltr_op
- * Operation.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_op, 0x04, 24, 8);
-
-/* reg_xmdr_c_ltr_trap_action
- * Trap action.
- * Values are defined in enum mlxsw_reg_ralue_trap_action.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_trap_action, 0x04, 20, 4);
-
-enum mlxsw_reg_xmdr_c_ltr_trap_id_num {
-	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS0,
-	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS1,
-	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS2,
-	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS3,
-};
-
-/* reg_xmdr_c_ltr_trap_id_num
- * Trap-ID number.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_trap_id_num, 0x04, 16, 4);
-
-/* reg_xmdr_c_ltr_virtual_router
- * Virtual Router ID.
- * Range is 0..cap_max_virtual_routers-1
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_virtual_router, 0x04, 0, 16);
-
-/* reg_xmdr_c_ltr_prefix_len
- * Number of bits in the prefix of the LPM route.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_prefix_len, 0x08, 24, 8);
-
-/* reg_xmdr_c_ltr_bmp_len
- * The best match prefix length in the case that there is no match for
- * longer prefixes.
- * If (entry_type != MARKER_ENTRY), bmp_len must be equal to prefix_len
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_bmp_len, 0x08, 16, 8);
-
-/* reg_xmdr_c_ltr_entry_type
- * Entry type.
- * Values are defined in enum mlxsw_reg_ralue_entry_type.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_entry_type, 0x08, 4, 4);
-
-enum mlxsw_reg_xmdr_c_ltr_action_type {
-	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_LOCAL,
-	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_REMOTE,
-	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME,
-};
-
-/* reg_xmdr_c_ltr_action_type
- * Action Type.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_action_type, 0x08, 0, 4);
-
-/* reg_xmdr_c_ltr_erif
- * Egress Router Interface.
- * Only relevant in case of LOCAL action.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_erif, 0x10, 0, 16);
-
-/* reg_xmdr_c_ltr_adjacency_index
- * Points to the first entry of the group-based ECMP.
- * Only relevant in case of REMOTE action.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_adjacency_index, 0x10, 0, 24);
-
-#define MLXSW_REG_XMDR_C_LTR_POINTER_TO_TUNNEL_DISABLED_MAGIC 0xFFFFFF
-
-/* reg_xmdr_c_ltr_pointer_to_tunnel
- * Only relevant in case of IP2ME action.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_pointer_to_tunnel, 0x10, 0, 24);
-
-/* reg_xmdr_c_ltr_ecmp_size
- * Amount of sequential entries starting
- * from the adjacency_index (the number of ECMPs).
- * The valid range is 1-64, 512, 1024, 2048 and 4096.
- * Only relevant in case of REMOTE action.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_ecmp_size, 0x14, 0, 32);
-
-/* reg_xmdr_c_ltr_dip*
- * The prefix of the route or of the marker that the object of the LPM
- * is compared with. The most significant bits of the dip are the prefix.
- * The least significant bits must be '0' if the prefix_len is smaller
- * than 128 for IPv6 or smaller than 32 for IPv4.
- */
-MLXSW_ITEM32(reg, xmdr_c, ltr_dip4, 0x1C, 0, 32);
-MLXSW_ITEM_BUF(reg, xmdr_c, ltr_dip6, 0x1C, 16);
-
-static inline void
-mlxsw_reg_xmdr_c_ltr_pack(char *xmdr_payload, unsigned int trans_offset,
-			  enum mlxsw_reg_xmdr_c_cmd_id cmd_id, u16 seq_number,
-			  enum mlxsw_reg_xmdr_c_ltr_op op, u16 virtual_router,
-			  u8 prefix_len)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-	u8 num_rec = mlxsw_reg_xmdr_num_rec_get(xmdr_payload);
-
-	mlxsw_reg_xmdr_num_rec_set(xmdr_payload, num_rec + 1);
-
-	mlxsw_reg_xmdr_c_cmd_id_set(payload, cmd_id);
-	mlxsw_reg_xmdr_c_seq_number_set(payload, seq_number);
-	mlxsw_reg_xmdr_c_ltr_op_set(payload, op);
-	mlxsw_reg_xmdr_c_ltr_virtual_router_set(payload, virtual_router);
-	mlxsw_reg_xmdr_c_ltr_prefix_len_set(payload, prefix_len);
-	mlxsw_reg_xmdr_c_ltr_entry_type_set(payload,
-					    MLXSW_REG_RALUE_ENTRY_TYPE_ROUTE_ENTRY);
-	mlxsw_reg_xmdr_c_ltr_bmp_len_set(payload, prefix_len);
-}
-
-static inline unsigned int
-mlxsw_reg_xmdr_c_ltr_pack4(char *xmdr_payload, unsigned int trans_offset,
-			   u16 seq_number, enum mlxsw_reg_xmdr_c_ltr_op op,
-			   u16 virtual_router, u8 prefix_len, u32 *dip)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_pack(xmdr_payload, trans_offset,
-				  MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V4,
-				  seq_number, op, virtual_router, prefix_len);
-	if (dip)
-		mlxsw_reg_xmdr_c_ltr_dip4_set(payload, *dip);
-	return MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN;
-}
-
-static inline unsigned int
-mlxsw_reg_xmdr_c_ltr_pack6(char *xmdr_payload, unsigned int trans_offset,
-			   u16 seq_number, enum mlxsw_reg_xmdr_c_ltr_op op,
-			   u16 virtual_router, u8 prefix_len, const void *dip)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_pack(xmdr_payload, trans_offset,
-				  MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V6,
-				  seq_number, op, virtual_router, prefix_len);
-	if (dip)
-		mlxsw_reg_xmdr_c_ltr_dip6_memcpy_to(payload, dip);
-	return MLXSW_REG_XMDR_C_LT_ROUTE_V6_LEN;
-}
-
-static inline void
-mlxsw_reg_xmdr_c_ltr_act_remote_pack(char *xmdr_payload, unsigned int trans_offset,
-				     enum mlxsw_reg_ralue_trap_action trap_action,
-				     enum mlxsw_reg_xmdr_c_ltr_trap_id_num trap_id_num,
-				     u32 adjacency_index, u16 ecmp_size)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_REMOTE);
-	mlxsw_reg_xmdr_c_ltr_trap_action_set(payload, trap_action);
-	mlxsw_reg_xmdr_c_ltr_trap_id_num_set(payload, trap_id_num);
-	mlxsw_reg_xmdr_c_ltr_adjacency_index_set(payload, adjacency_index);
-	mlxsw_reg_xmdr_c_ltr_ecmp_size_set(payload, ecmp_size);
-}
-
-static inline void
-mlxsw_reg_xmdr_c_ltr_act_local_pack(char *xmdr_payload, unsigned int trans_offset,
-				    enum mlxsw_reg_ralue_trap_action trap_action,
-				    enum mlxsw_reg_xmdr_c_ltr_trap_id_num trap_id_num, u16 erif)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_LOCAL);
-	mlxsw_reg_xmdr_c_ltr_trap_action_set(payload, trap_action);
-	mlxsw_reg_xmdr_c_ltr_trap_id_num_set(payload, trap_id_num);
-	mlxsw_reg_xmdr_c_ltr_erif_set(payload, erif);
-}
-
-static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_pack(char *xmdr_payload,
-						       unsigned int trans_offset)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME);
-	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload,
-						   MLXSW_REG_XMDR_C_LTR_POINTER_TO_TUNNEL_DISABLED_MAGIC);
-}
-
-static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(char *xmdr_payload,
-							   unsigned int trans_offset,
-							   u32 pointer_to_tunnel)
-{
-	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
-
-	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME);
-	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload, pointer_to_tunnel);
-}
-
-/* XRMT - XM Router M Table Register
- * ---------------------------------
- * The XRMT configures the M-Table for the XLT-LPM.
- */
-#define MLXSW_REG_XRMT_ID 0x7810
-#define MLXSW_REG_XRMT_LEN 0x14
-
-MLXSW_REG_DEFINE(xrmt, MLXSW_REG_XRMT_ID, MLXSW_REG_XRMT_LEN);
-
-/* reg_xrmt_index
- * Index in M-Table.
- * Range 0..cap_xlt_mtable-1
- * Access: Index
- */
-MLXSW_ITEM32(reg, xrmt, index, 0x04, 0, 20);
-
-/* reg_xrmt_l0_val
- * Access: RW
- */
-MLXSW_ITEM32(reg, xrmt, l0_val, 0x10, 24, 8);
-
-static inline void mlxsw_reg_xrmt_pack(char *payload, u32 index, u8 l0_val)
-{
-	MLXSW_REG_ZERO(xrmt, payload);
-	mlxsw_reg_xrmt_index_set(payload, index);
-	mlxsw_reg_xrmt_l0_val_set(payload, l0_val);
-}
 
 /* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
  * -----------------------------------------------------------
@@ -13084,13 +12512,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
-	MLXSW_REG(rxlte),
-	MLXSW_REG(rxltm),
-	MLXSW_REG(rlcmld),
-	MLXSW_REG(rlpmce),
-	MLXSW_REG(xltq),
-	MLXSW_REG(xmdr),
-	MLXSW_REG(xrmt),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
 	MLXSW_REG(xraltb),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index cafd206e8d7e..c949005f56dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2105,9 +2105,6 @@ static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
 		return -ENOMEM;
 
 	for (i = 1; i < max_ports; i++) {
-		if (mlxsw_core_port_is_xm(mlxsw_sp->core, i))
-			continue;
-
 		port_mapping = &mlxsw_sp->port_mapping[i];
 		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, port_mapping);
 		if (err)
@@ -3410,8 +3407,6 @@ static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
 	.max_ib_mc			= 0,
 	.used_max_pkey			= 1,
 	.max_pkey			= 0,
-	.used_kvh_xlt_cache_mode	= 1,
-	.kvh_xlt_cache_mode		= 1,
 	.swid_config			= {
 		{
 			.used_type	= 1,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9dbb573d53ea..31984c704cd9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -551,12 +551,6 @@ struct mlxsw_sp_vr {
 	refcount_t ul_rif_refcnt;
 };
 
-static int mlxsw_sp_router_ll_basic_init(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
-					 enum mlxsw_sp_l3proto proto)
-{
-	return 0;
-}
-
 static int mlxsw_sp_router_ll_basic_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
 {
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralta),
@@ -586,10 +580,6 @@ static struct mlxsw_sp_fib *mlxsw_sp_fib_create(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib *fib;
 	int err;
 
-	err = ll_ops->init(mlxsw_sp, vr->id, proto);
-	if (err)
-		return ERR_PTR(err);
-
 	lpm_tree = mlxsw_sp->router->lpm.proto_trees[proto];
 	fib = kzalloc(sizeof(*fib), GFP_KERNEL);
 	if (!fib)
@@ -7770,7 +7760,6 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 		op_ctx->bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
 				  fib_event->family == next_fib_event->family &&
 				  fib_event->event == next_fib_event->event;
-		op_ctx->event = fib_event->event;
 
 		/* In case family of this and the previous entry are different, context
 		 * reinitialization is going to be needed now, indicate that.
@@ -10534,7 +10523,6 @@ static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 }
 
 static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
-	.init = mlxsw_sp_router_ll_basic_init,
 	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
 	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
 	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
@@ -10646,13 +10634,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_router_ops_init;
 
-	err = mlxsw_sp_router_xm_init(mlxsw_sp);
-	if (err)
-		goto err_xm_init;
-
-	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = mlxsw_sp_router_xm_ipv4_is_supported(mlxsw_sp) ?
-						       &mlxsw_sp_router_ll_xm_ops :
-						       &mlxsw_sp_router_ll_basic_ops;
+	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
 	err = mlxsw_sp_router_ll_op_ctx_init(router);
@@ -10799,8 +10781,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
 	mlxsw_sp_router_ll_op_ctx_fini(router);
 err_ll_op_ctx_init:
-	mlxsw_sp_router_xm_fini(mlxsw_sp);
-err_xm_init:
 err_router_ops_init:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
@@ -10832,7 +10812,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	__mlxsw_sp_router_fini(mlxsw_sp);
 	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
 	mlxsw_sp_router_ll_op_ctx_fini(mlxsw_sp->router);
-	mlxsw_sp_router_xm_fini(mlxsw_sp);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 37411b74c3e6..e95dd7d51186 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -24,7 +24,6 @@ struct mlxsw_sp_fib_entry_op_ctx {
 			   * the context priv is initialized.
 			   */
 	struct list_head fib_entry_priv_list;
-	unsigned long event;
 	unsigned long ll_priv[];
 };
 
@@ -79,7 +78,6 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 	u16 lb_rif_index;
-	struct mlxsw_sp_router_xm *xm;
 	const struct mlxsw_sp_adj_grp_size_range *adj_grp_size_ranges;
 	size_t adj_grp_size_ranges_count;
 	struct delayed_work nh_grp_activity_dw;
@@ -105,8 +103,6 @@ enum mlxsw_sp_fib_entry_op {
  * register sets to work with ordinary and XM trees and FIB entries.
  */
 struct mlxsw_sp_router_ll_ops {
-	int (*init)(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
-		    enum mlxsw_sp_l3proto proto);
 	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
@@ -232,10 +228,4 @@ int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 struct net_device *
 mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev);
 
-extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
-
-int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp);
-void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp);
-bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp);
-
 #endif /* _MLXSW_ROUTER_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
deleted file mode 100644
index d213af723a2a..000000000000
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ /dev/null
@@ -1,812 +0,0 @@
-// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
-/* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/rhashtable.h>
-
-#include "spectrum.h"
-#include "core.h"
-#include "reg.h"
-#include "spectrum_router.h"
-
-#define MLXSW_SP_ROUTER_XM_M_VAL 16
-
-static const u8 mlxsw_sp_router_xm_m_val[] = {
-	[MLXSW_SP_L3_PROTO_IPV4] = MLXSW_SP_ROUTER_XM_M_VAL,
-	[MLXSW_SP_L3_PROTO_IPV6] = 0, /* Currently unused. */
-};
-
-#define MLXSW_SP_ROUTER_XM_L_VAL_MAX 16
-
-struct mlxsw_sp_router_xm {
-	bool ipv4_supported;
-	bool ipv6_supported;
-	unsigned int entries_size;
-	struct rhashtable ltable_ht;
-	struct rhashtable flush_ht; /* Stores items about to be flushed from cache */
-	unsigned int flush_count;
-	bool flush_all_mode;
-};
-
-struct mlxsw_sp_router_xm_ltable_node {
-	struct rhash_head ht_node; /* Member of router_xm->ltable_ht */
-	u16 mindex;
-	u8 current_lvalue;
-	refcount_t refcnt;
-	unsigned int lvalue_ref[MLXSW_SP_ROUTER_XM_L_VAL_MAX + 1];
-};
-
-static const struct rhashtable_params mlxsw_sp_router_xm_ltable_ht_params = {
-	.key_offset = offsetof(struct mlxsw_sp_router_xm_ltable_node, mindex),
-	.head_offset = offsetof(struct mlxsw_sp_router_xm_ltable_node, ht_node),
-	.key_len = sizeof(u16),
-	.automatic_shrinking = true,
-};
-
-struct mlxsw_sp_router_xm_flush_info {
-	bool all;
-	enum mlxsw_sp_l3proto proto;
-	u16 virtual_router;
-	u8 prefix_len;
-	unsigned char addr[sizeof(struct in6_addr)];
-};
-
-struct mlxsw_sp_router_xm_fib_entry {
-	bool committed;
-	struct mlxsw_sp_router_xm_ltable_node *ltable_node; /* Parent node */
-	u16 mindex; /* Store for processing from commit op */
-	u8 lvalue;
-	struct mlxsw_sp_router_xm_flush_info flush_info;
-};
-
-#define MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX \
-	(MLXSW_REG_XMDR_TRANS_LEN / MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN)
-
-struct mlxsw_sp_fib_entry_op_ctx_xm {
-	bool initialized;
-	char xmdr_pl[MLXSW_REG_XMDR_LEN];
-	unsigned int trans_offset; /* Offset of the current command within one
-				    * transaction of XMDR register.
-				    */
-	unsigned int trans_item_len; /* The current command length. This is used
-				      * to advance 'trans_offset' when the next
-				      * command is appended.
-				      */
-	unsigned int entries_count;
-	struct mlxsw_sp_router_xm_fib_entry *entries[MLXSW_SP_ROUTE_LL_XM_ENTRIES_MAX];
-};
-
-static int mlxsw_sp_router_ll_xm_init(struct mlxsw_sp *mlxsw_sp, u16 vr_id,
-				      enum mlxsw_sp_l3proto proto)
-{
-	char rxlte_pl[MLXSW_REG_RXLTE_LEN];
-
-	mlxsw_reg_rxlte_pack(rxlte_pl, vr_id,
-			     (enum mlxsw_reg_rxlte_protocol) proto, true);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rxlte), rxlte_pl);
-}
-
-static int mlxsw_sp_router_ll_xm_ralta_write(struct mlxsw_sp *mlxsw_sp, char *xralta_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xralta), xralta_pl);
-}
-
-static int mlxsw_sp_router_ll_xm_ralst_write(struct mlxsw_sp *mlxsw_sp, char *xralst_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xralst), xralst_pl);
-}
-
-static int mlxsw_sp_router_ll_xm_raltb_write(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl)
-{
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xraltb), xraltb_pl);
-}
-
-static u16 mlxsw_sp_router_ll_xm_mindex_get4(const u32 addr)
-{
-	/* Currently the M-index is set to linear mode. That means it is defined
-	 * as 16 MSB of IP address.
-	 */
-	return addr >> MLXSW_SP_ROUTER_XM_L_VAL_MAX;
-}
-
-static u16 mlxsw_sp_router_ll_xm_mindex_get6(const unsigned char *addr)
-{
-	WARN_ON_ONCE(1);
-	return 0; /* currently unused */
-}
-
-static void mlxsw_sp_router_ll_xm_op_ctx_check_init(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						    struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
-{
-	if (op_ctx->initialized)
-		return;
-	op_ctx->initialized = true;
-
-	mlxsw_reg_xmdr_pack(op_ctx_xm->xmdr_pl, true);
-	op_ctx_xm->trans_offset = 0;
-	op_ctx_xm->entries_count = 0;
-}
-
-static void mlxsw_sp_router_ll_xm_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						 enum mlxsw_sp_l3proto proto,
-						 enum mlxsw_sp_fib_entry_op op,
-						 u16 virtual_router, u8 prefix_len,
-						 unsigned char *addr,
-						 struct mlxsw_sp_fib_entry_priv *priv)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry = (void *) priv->priv;
-	struct mlxsw_sp_router_xm_flush_info *flush_info;
-	enum mlxsw_reg_xmdr_c_ltr_op xmdr_c_ltr_op;
-	unsigned int len;
-
-	mlxsw_sp_router_ll_xm_op_ctx_check_init(op_ctx, op_ctx_xm);
-
-	switch (op) {
-	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
-		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_WRITE;
-		break;
-	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
-		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_UPDATE;
-		break;
-	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
-		xmdr_c_ltr_op = MLXSW_REG_XMDR_C_LTR_OP_DELETE;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return;
-	}
-
-	switch (proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
-		len = mlxsw_reg_xmdr_c_ltr_pack4(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
-						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
-						 virtual_router, prefix_len, (u32 *) addr);
-		fib_entry->mindex = mlxsw_sp_router_ll_xm_mindex_get4(*((u32 *) addr));
-		break;
-	case MLXSW_SP_L3_PROTO_IPV6:
-		len = mlxsw_reg_xmdr_c_ltr_pack6(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
-						 op_ctx_xm->entries_count, xmdr_c_ltr_op,
-						 virtual_router, prefix_len, addr);
-		fib_entry->mindex = mlxsw_sp_router_ll_xm_mindex_get6(addr);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return;
-	}
-	if (!op_ctx_xm->trans_offset)
-		op_ctx_xm->trans_item_len = len;
-	else
-		WARN_ON_ONCE(op_ctx_xm->trans_item_len != len);
-
-	op_ctx_xm->entries[op_ctx_xm->entries_count] = fib_entry;
-
-	fib_entry->lvalue = prefix_len > mlxsw_sp_router_xm_m_val[proto] ?
-			       prefix_len - mlxsw_sp_router_xm_m_val[proto] : 0;
-
-	flush_info = &fib_entry->flush_info;
-	flush_info->proto = proto;
-	flush_info->virtual_router = virtual_router;
-	flush_info->prefix_len = prefix_len;
-	if (addr)
-		memcpy(flush_info->addr, addr, sizeof(flush_info->addr));
-	else
-		memset(flush_info->addr, 0, sizeof(flush_info->addr));
-}
-
-static void
-mlxsw_sp_router_ll_xm_fib_entry_act_remote_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						enum mlxsw_reg_ralue_trap_action trap_action,
-						u16 trap_id, u32 adjacency_index, u16 ecmp_size)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_xmdr_c_ltr_act_remote_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
-					     trap_action, trap_id, adjacency_index, ecmp_size);
-}
-
-static void
-mlxsw_sp_router_ll_xm_fib_entry_act_local_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					      enum mlxsw_reg_ralue_trap_action trap_action,
-					       u16 trap_id, u16 local_erif)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_xmdr_c_ltr_act_local_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
-					    trap_action, trap_id, local_erif);
-}
-
-static void
-mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_xmdr_c_ltr_act_ip2me_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset);
-}
-
-static void
-mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						   u32 tunnel_ptr)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(op_ctx_xm->xmdr_pl, op_ctx_xm->trans_offset,
-						tunnel_ptr);
-}
-
-static struct mlxsw_sp_router_xm_ltable_node *
-mlxsw_sp_router_xm_ltable_node_get(struct mlxsw_sp_router_xm *router_xm, u16 mindex)
-{
-	struct mlxsw_sp_router_xm_ltable_node *ltable_node;
-	int err;
-
-	ltable_node = rhashtable_lookup_fast(&router_xm->ltable_ht, &mindex,
-					     mlxsw_sp_router_xm_ltable_ht_params);
-	if (ltable_node) {
-		refcount_inc(&ltable_node->refcnt);
-		return ltable_node;
-	}
-	ltable_node = kzalloc(sizeof(*ltable_node), GFP_KERNEL);
-	if (!ltable_node)
-		return ERR_PTR(-ENOMEM);
-	ltable_node->mindex = mindex;
-	refcount_set(&ltable_node->refcnt, 1);
-
-	err = rhashtable_insert_fast(&router_xm->ltable_ht, &ltable_node->ht_node,
-				     mlxsw_sp_router_xm_ltable_ht_params);
-	if (err)
-		goto err_insert;
-
-	return ltable_node;
-
-err_insert:
-	kfree(ltable_node);
-	return ERR_PTR(err);
-}
-
-static void mlxsw_sp_router_xm_ltable_node_put(struct mlxsw_sp_router_xm *router_xm,
-					       struct mlxsw_sp_router_xm_ltable_node *ltable_node)
-{
-	if (!refcount_dec_and_test(&ltable_node->refcnt))
-		return;
-	rhashtable_remove_fast(&router_xm->ltable_ht, &ltable_node->ht_node,
-			       mlxsw_sp_router_xm_ltable_ht_params);
-	kfree(ltable_node);
-}
-
-static int mlxsw_sp_router_xm_ltable_lvalue_set(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_router_xm_ltable_node *ltable_node)
-{
-	char xrmt_pl[MLXSW_REG_XRMT_LEN];
-
-	mlxsw_reg_xrmt_pack(xrmt_pl, ltable_node->mindex, ltable_node->current_lvalue);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xrmt), xrmt_pl);
-}
-
-struct mlxsw_sp_router_xm_flush_node {
-	struct rhash_head ht_node; /* Member of router_xm->flush_ht */
-	struct list_head list;
-	struct mlxsw_sp_router_xm_flush_info flush_info;
-	struct delayed_work dw;
-	struct mlxsw_sp *mlxsw_sp;
-	unsigned long start_jiffies;
-	unsigned int reuses; /* By how many flush calls this was reused. */
-	refcount_t refcnt;
-};
-
-static const struct rhashtable_params mlxsw_sp_router_xm_flush_ht_params = {
-	.key_offset = offsetof(struct mlxsw_sp_router_xm_flush_node, flush_info),
-	.head_offset = offsetof(struct mlxsw_sp_router_xm_flush_node, ht_node),
-	.key_len = sizeof(struct mlxsw_sp_router_xm_flush_info),
-	.automatic_shrinking = true,
-};
-
-static struct mlxsw_sp_router_xm_flush_node *
-mlxsw_sp_router_xm_cache_flush_node_create(struct mlxsw_sp *mlxsw_sp,
-					   struct mlxsw_sp_router_xm_flush_info *flush_info)
-{
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-	struct mlxsw_sp_router_xm_flush_node *flush_node;
-	int err;
-
-	flush_node = kzalloc(sizeof(*flush_node), GFP_KERNEL);
-	if (!flush_node)
-		return ERR_PTR(-ENOMEM);
-
-	flush_node->flush_info = *flush_info;
-	err = rhashtable_insert_fast(&router_xm->flush_ht, &flush_node->ht_node,
-				     mlxsw_sp_router_xm_flush_ht_params);
-	if (err) {
-		kfree(flush_node);
-		return ERR_PTR(err);
-	}
-	router_xm->flush_count++;
-	flush_node->mlxsw_sp = mlxsw_sp;
-	flush_node->start_jiffies = jiffies;
-	refcount_set(&flush_node->refcnt, 1);
-	return flush_node;
-}
-
-static void
-mlxsw_sp_router_xm_cache_flush_node_hold(struct mlxsw_sp_router_xm_flush_node *flush_node)
-{
-	if (!flush_node)
-		return;
-	refcount_inc(&flush_node->refcnt);
-}
-
-static void
-mlxsw_sp_router_xm_cache_flush_node_put(struct mlxsw_sp_router_xm_flush_node *flush_node)
-{
-	if (!flush_node || !refcount_dec_and_test(&flush_node->refcnt))
-		return;
-	kfree(flush_node);
-}
-
-static void
-mlxsw_sp_router_xm_cache_flush_node_destroy(struct mlxsw_sp *mlxsw_sp,
-					    struct mlxsw_sp_router_xm_flush_node *flush_node)
-{
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-
-	router_xm->flush_count--;
-	rhashtable_remove_fast(&router_xm->flush_ht, &flush_node->ht_node,
-			       mlxsw_sp_router_xm_flush_ht_params);
-	mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
-}
-
-static u32 mlxsw_sp_router_xm_flush_mask4(u8 prefix_len)
-{
-	return GENMASK(31, 32 - prefix_len);
-}
-
-static unsigned char *mlxsw_sp_router_xm_flush_mask6(u8 prefix_len)
-{
-	static unsigned char mask[sizeof(struct in6_addr)];
-
-	memset(mask, 0, sizeof(mask));
-	memset(mask, 0xff, prefix_len / 8);
-	mask[prefix_len / 8] = GENMASK(8, 8 - prefix_len % 8);
-	return mask;
-}
-
-#define MLXSW_SP_ROUTER_XM_CACHE_PARALLEL_FLUSHES_LIMIT 15
-#define MLXSW_SP_ROUTER_XM_CACHE_FLUSH_ALL_MIN_REUSES 15
-#define MLXSW_SP_ROUTER_XM_CACHE_DELAY 50 /* usecs */
-#define MLXSW_SP_ROUTER_XM_CACHE_MAX_WAIT (MLXSW_SP_ROUTER_XM_CACHE_DELAY * 10)
-
-static void mlxsw_sp_router_xm_cache_flush_work(struct work_struct *work)
-{
-	struct mlxsw_sp_router_xm_flush_info *flush_info;
-	struct mlxsw_sp_router_xm_flush_node *flush_node;
-	char rlcmld_pl[MLXSW_REG_RLCMLD_LEN];
-	enum mlxsw_reg_rlcmld_select select;
-	struct mlxsw_sp *mlxsw_sp;
-	u32 addr4;
-	int err;
-
-	flush_node = container_of(work, struct mlxsw_sp_router_xm_flush_node,
-				  dw.work);
-	mlxsw_sp = flush_node->mlxsw_sp;
-	flush_info = &flush_node->flush_info;
-
-	if (flush_info->all) {
-		char rlpmce_pl[MLXSW_REG_RLPMCE_LEN];
-
-		mlxsw_reg_rlpmce_pack(rlpmce_pl, true, false);
-		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rlpmce),
-				      rlpmce_pl);
-		if (err)
-			dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
-
-		if (flush_node->reuses <
-		    MLXSW_SP_ROUTER_XM_CACHE_FLUSH_ALL_MIN_REUSES)
-			/* Leaving flush-all mode. */
-			mlxsw_sp->router->xm->flush_all_mode = false;
-		goto out;
-	}
-
-	select = MLXSW_REG_RLCMLD_SELECT_M_AND_ML_ENTRIES;
-
-	switch (flush_info->proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
-		addr4 = *((u32 *) flush_info->addr);
-		addr4 &= mlxsw_sp_router_xm_flush_mask4(flush_info->prefix_len);
-
-		/* In case the flush prefix length is bigger than M-value,
-		 * it makes no sense to flush M entries. So just flush
-		 * the ML entries.
-		 */
-		if (flush_info->prefix_len > MLXSW_SP_ROUTER_XM_M_VAL)
-			select = MLXSW_REG_RLCMLD_SELECT_ML_ENTRIES;
-
-		mlxsw_reg_rlcmld_pack4(rlcmld_pl, select,
-				       flush_info->virtual_router, addr4,
-				       mlxsw_sp_router_xm_flush_mask4(flush_info->prefix_len));
-		break;
-	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_reg_rlcmld_pack6(rlcmld_pl, select,
-				       flush_info->virtual_router, flush_info->addr,
-				       mlxsw_sp_router_xm_flush_mask6(flush_info->prefix_len));
-		break;
-	default:
-		WARN_ON(true);
-		goto out;
-	}
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rlcmld), rlcmld_pl);
-	if (err)
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
-
-out:
-	mlxsw_sp_router_xm_cache_flush_node_destroy(mlxsw_sp, flush_node);
-}
-
-static bool
-mlxsw_sp_router_xm_cache_flush_may_cancel(struct mlxsw_sp_router_xm_flush_node *flush_node)
-{
-	unsigned long max_wait = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_MAX_WAIT);
-	unsigned long delay = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_DELAY);
-
-	/* In case there is the same flushing work pending, check
-	 * if we can consolidate with it. We can do it up to MAX_WAIT.
-	 * Cancel the delayed work. If the work was still pending.
-	 */
-	if (time_is_before_jiffies(flush_node->start_jiffies + max_wait - delay) &&
-	    cancel_delayed_work_sync(&flush_node->dw))
-		return true;
-	return false;
-}
-
-static int
-mlxsw_sp_router_xm_cache_flush_schedule(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_router_xm_flush_info *flush_info)
-{
-	unsigned long delay = usecs_to_jiffies(MLXSW_SP_ROUTER_XM_CACHE_DELAY);
-	struct mlxsw_sp_router_xm_flush_info flush_all_info = {.all = true};
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-	struct mlxsw_sp_router_xm_flush_node *flush_node;
-
-	/* Check if the queued number of flushes reached critical amount after
-	 * which it is better to just flush the whole cache.
-	 */
-	if (router_xm->flush_count == MLXSW_SP_ROUTER_XM_CACHE_PARALLEL_FLUSHES_LIMIT)
-		/* Entering flush-all mode. */
-		router_xm->flush_all_mode = true;
-
-	if (router_xm->flush_all_mode)
-		flush_info = &flush_all_info;
-
-	rcu_read_lock();
-	flush_node = rhashtable_lookup_fast(&router_xm->flush_ht, flush_info,
-					    mlxsw_sp_router_xm_flush_ht_params);
-	/* Take a reference so the object is not freed before possible
-	 * delayed work cancel could be done.
-	 */
-	mlxsw_sp_router_xm_cache_flush_node_hold(flush_node);
-	rcu_read_unlock();
-
-	if (flush_node && mlxsw_sp_router_xm_cache_flush_may_cancel(flush_node)) {
-		flush_node->reuses++;
-		mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
-		 /* Original work was within wait period and was canceled.
-		  * That means that the reference is still held and the
-		  * flush_node_put() call above did not free the flush_node.
-		  * Reschedule it with fresh delay.
-		  */
-		goto schedule_work;
-	} else {
-		mlxsw_sp_router_xm_cache_flush_node_put(flush_node);
-	}
-
-	flush_node = mlxsw_sp_router_xm_cache_flush_node_create(mlxsw_sp, flush_info);
-	if (IS_ERR(flush_node))
-		return PTR_ERR(flush_node);
-	INIT_DELAYED_WORK(&flush_node->dw, mlxsw_sp_router_xm_cache_flush_work);
-
-schedule_work:
-	mlxsw_core_schedule_dw(&flush_node->dw, delay);
-	return 0;
-}
-
-static int
-mlxsw_sp_router_xm_ml_entry_add(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_router_xm_fib_entry *fib_entry)
-{
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-	struct mlxsw_sp_router_xm_ltable_node *ltable_node;
-	u8 lvalue = fib_entry->lvalue;
-	int err;
-
-	ltable_node = mlxsw_sp_router_xm_ltable_node_get(router_xm,
-							 fib_entry->mindex);
-	if (IS_ERR(ltable_node))
-		return PTR_ERR(ltable_node);
-	if (lvalue > ltable_node->current_lvalue) {
-		/* The L-value is bigger then the one currently set, update. */
-		ltable_node->current_lvalue = lvalue;
-		err = mlxsw_sp_router_xm_ltable_lvalue_set(mlxsw_sp,
-							   ltable_node);
-		if (err)
-			goto err_lvalue_set;
-
-		/* The L value for prefix/M is increased.
-		 * Therefore, all entries in M and ML caches matching
-		 * {prefix/M, proto, VR} need to be flushed. Set the flush
-		 * prefix length to M to achieve that.
-		 */
-		fib_entry->flush_info.prefix_len = MLXSW_SP_ROUTER_XM_M_VAL;
-	}
-
-	ltable_node->lvalue_ref[lvalue]++;
-	fib_entry->ltable_node = ltable_node;
-
-	return 0;
-
-err_lvalue_set:
-	mlxsw_sp_router_xm_ltable_node_put(router_xm, ltable_node);
-	return err;
-}
-
-static void
-mlxsw_sp_router_xm_ml_entry_del(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_router_xm_fib_entry *fib_entry)
-{
-	struct mlxsw_sp_router_xm_ltable_node *ltable_node =
-							fib_entry->ltable_node;
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-	u8 lvalue = fib_entry->lvalue;
-
-	ltable_node->lvalue_ref[lvalue]--;
-	if (lvalue == ltable_node->current_lvalue && lvalue &&
-	    !ltable_node->lvalue_ref[lvalue]) {
-		u8 new_lvalue = lvalue - 1;
-
-		/* Find the biggest L-value left out there. */
-		while (new_lvalue > 0 && !ltable_node->lvalue_ref[lvalue])
-			new_lvalue--;
-
-		ltable_node->current_lvalue = new_lvalue;
-		mlxsw_sp_router_xm_ltable_lvalue_set(mlxsw_sp, ltable_node);
-
-		/* The L value for prefix/M is decreased.
-		 * Therefore, all entries in M and ML caches matching
-		 * {prefix/M, proto, VR} need to be flushed. Set the flush
-		 * prefix length to M to achieve that.
-		 */
-		fib_entry->flush_info.prefix_len = MLXSW_SP_ROUTER_XM_M_VAL;
-	}
-	mlxsw_sp_router_xm_ltable_node_put(router_xm, ltable_node);
-}
-
-static int
-mlxsw_sp_router_xm_ml_entries_add(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
-{
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
-	int err;
-	int i;
-
-	for (i = 0; i < op_ctx_xm->entries_count; i++) {
-		fib_entry = op_ctx_xm->entries[i];
-		err = mlxsw_sp_router_xm_ml_entry_add(mlxsw_sp, fib_entry);
-		if (err)
-			goto rollback;
-	}
-	return 0;
-
-rollback:
-	for (i--; i >= 0; i--) {
-		fib_entry = op_ctx_xm->entries[i];
-		mlxsw_sp_router_xm_ml_entry_del(mlxsw_sp, fib_entry);
-	}
-	return err;
-}
-
-static void
-mlxsw_sp_router_xm_ml_entries_del(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
-{
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
-	int i;
-
-	for (i = 0; i < op_ctx_xm->entries_count; i++) {
-		fib_entry = op_ctx_xm->entries[i];
-		mlxsw_sp_router_xm_ml_entry_del(mlxsw_sp, fib_entry);
-	}
-}
-
-static void
-mlxsw_sp_router_xm_ml_entries_cache_flush(struct mlxsw_sp *mlxsw_sp,
-					  struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm)
-{
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
-	int err;
-	int i;
-
-	for (i = 0; i < op_ctx_xm->entries_count; i++) {
-		fib_entry = op_ctx_xm->entries[i];
-		err = mlxsw_sp_router_xm_cache_flush_schedule(mlxsw_sp,
-							      &fib_entry->flush_info);
-		if (err)
-			dev_err(mlxsw_sp->bus_info->dev, "Failed to flush XM cache\n");
-	}
-}
-
-static int mlxsw_sp_router_ll_xm_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-						  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						  bool *postponed_for_bulk)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_xm *op_ctx_xm = (void *) op_ctx->ll_priv;
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry;
-	u8 num_rec;
-	int err;
-	int i;
-
-	op_ctx_xm->trans_offset += op_ctx_xm->trans_item_len;
-	op_ctx_xm->entries_count++;
-
-	/* Check if bulking is possible and there is still room for another
-	 * FIB entry record. The size of 'trans_item_len' is either size of IPv4
-	 * command or size of IPv6 command. Not possible to mix those in a
-	 * single XMDR write.
-	 */
-	if (op_ctx->bulk_ok &&
-	    op_ctx_xm->trans_offset + op_ctx_xm->trans_item_len <= MLXSW_REG_XMDR_TRANS_LEN) {
-		if (postponed_for_bulk)
-			*postponed_for_bulk = true;
-		return 0;
-	}
-
-	if (op_ctx->event == FIB_EVENT_ENTRY_REPLACE) {
-		/* The L-table is updated inside. It has to be done before
-		 * the prefix is inserted.
-		 */
-		err = mlxsw_sp_router_xm_ml_entries_add(mlxsw_sp, op_ctx_xm);
-		if (err)
-			goto out;
-	}
-
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(xmdr), op_ctx_xm->xmdr_pl);
-	if (err)
-		goto out;
-	num_rec = mlxsw_reg_xmdr_num_rec_get(op_ctx_xm->xmdr_pl);
-	if (num_rec > op_ctx_xm->entries_count) {
-		dev_err(mlxsw_sp->bus_info->dev, "Invalid XMDR number of records\n");
-		err = -EIO;
-		goto out;
-	}
-	for (i = 0; i < num_rec; i++) {
-		if (!mlxsw_reg_xmdr_reply_vect_get(op_ctx_xm->xmdr_pl, i)) {
-			dev_err(mlxsw_sp->bus_info->dev, "Command send over XMDR failed\n");
-			err = -EIO;
-			goto out;
-		} else {
-			fib_entry = op_ctx_xm->entries[i];
-			fib_entry->committed = true;
-		}
-	}
-
-	if (op_ctx->event == FIB_EVENT_ENTRY_DEL)
-		/* The L-table is updated inside. It has to be done after
-		 * the prefix was removed.
-		 */
-		mlxsw_sp_router_xm_ml_entries_del(mlxsw_sp, op_ctx_xm);
-
-	/* At the very end, do the XLT cache flushing to evict stale
-	 * M and ML cache entries after prefixes were inserted/removed.
-	 */
-	mlxsw_sp_router_xm_ml_entries_cache_flush(mlxsw_sp, op_ctx_xm);
-
-out:
-	/* Next pack call is going to do reinitialization */
-	op_ctx->initialized = false;
-	return err;
-}
-
-static bool mlxsw_sp_router_ll_xm_fib_entry_is_committed(struct mlxsw_sp_fib_entry_priv *priv)
-{
-	struct mlxsw_sp_router_xm_fib_entry *fib_entry = (void *) priv->priv;
-
-	return fib_entry->committed;
-}
-
-const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops = {
-	.init = mlxsw_sp_router_ll_xm_init,
-	.ralta_write = mlxsw_sp_router_ll_xm_ralta_write,
-	.ralst_write = mlxsw_sp_router_ll_xm_ralst_write,
-	.raltb_write = mlxsw_sp_router_ll_xm_raltb_write,
-	.fib_entry_op_ctx_size = sizeof(struct mlxsw_sp_fib_entry_op_ctx_xm),
-	.fib_entry_priv_size = sizeof(struct mlxsw_sp_router_xm_fib_entry),
-	.fib_entry_pack = mlxsw_sp_router_ll_xm_fib_entry_pack,
-	.fib_entry_act_remote_pack = mlxsw_sp_router_ll_xm_fib_entry_act_remote_pack,
-	.fib_entry_act_local_pack = mlxsw_sp_router_ll_xm_fib_entry_act_local_pack,
-	.fib_entry_act_ip2me_pack = mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_pack,
-	.fib_entry_act_ip2me_tun_pack = mlxsw_sp_router_ll_xm_fib_entry_act_ip2me_tun_pack,
-	.fib_entry_commit = mlxsw_sp_router_ll_xm_fib_entry_commit,
-	.fib_entry_is_committed = mlxsw_sp_router_ll_xm_fib_entry_is_committed,
-};
-
-#define MLXSW_SP_ROUTER_XM_MINDEX_SIZE (64 * 1024)
-
-int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_router_xm *router_xm;
-	char rxltm_pl[MLXSW_REG_RXLTM_LEN];
-	char xltq_pl[MLXSW_REG_XLTQ_LEN];
-	u32 mindex_size;
-	u16 device_id;
-	int err;
-
-	if (!mlxsw_sp->bus_info->xm_exists)
-		return 0;
-
-	router_xm = kzalloc(sizeof(*router_xm), GFP_KERNEL);
-	if (!router_xm)
-		return -ENOMEM;
-
-	mlxsw_reg_xltq_pack(xltq_pl);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(xltq), xltq_pl);
-	if (err)
-		goto err_xltq_query;
-	mlxsw_reg_xltq_unpack(xltq_pl, &device_id, &router_xm->ipv4_supported,
-			      &router_xm->ipv6_supported, &router_xm->entries_size, &mindex_size);
-
-	if (device_id != MLXSW_REG_XLTQ_XM_DEVICE_ID_XLT) {
-		dev_err(mlxsw_sp->bus_info->dev, "Invalid XM device id\n");
-		err = -EINVAL;
-		goto err_device_id_check;
-	}
-
-	if (mindex_size != MLXSW_SP_ROUTER_XM_MINDEX_SIZE) {
-		dev_err(mlxsw_sp->bus_info->dev, "Unexpected M-index size\n");
-		err = -EINVAL;
-		goto err_mindex_size_check;
-	}
-
-	mlxsw_reg_rxltm_pack(rxltm_pl, mlxsw_sp_router_xm_m_val[MLXSW_SP_L3_PROTO_IPV4],
-			     mlxsw_sp_router_xm_m_val[MLXSW_SP_L3_PROTO_IPV6]);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rxltm), rxltm_pl);
-	if (err)
-		goto err_rxltm_write;
-
-	err = rhashtable_init(&router_xm->ltable_ht, &mlxsw_sp_router_xm_ltable_ht_params);
-	if (err)
-		goto err_ltable_ht_init;
-
-	err = rhashtable_init(&router_xm->flush_ht, &mlxsw_sp_router_xm_flush_ht_params);
-	if (err)
-		goto err_flush_ht_init;
-
-	mlxsw_sp->router->xm = router_xm;
-	return 0;
-
-err_flush_ht_init:
-	rhashtable_destroy(&router_xm->ltable_ht);
-err_ltable_ht_init:
-err_rxltm_write:
-err_mindex_size_check:
-err_device_id_check:
-err_xltq_query:
-	kfree(router_xm);
-	return err;
-}
-
-void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-
-	if (!mlxsw_sp->bus_info->xm_exists)
-		return;
-
-	rhashtable_destroy(&router_xm->flush_ht);
-	rhashtable_destroy(&router_xm->ltable_ht);
-	kfree(router_xm);
-}
-
-bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
-
-	return router_xm && router_xm->ipv4_supported;
-}
-- 
2.36.1

