Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278C0564D8B
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiGDGNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGDGNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732D8389A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBwwVOpzIWHzYxkJpDNsTDzKrTTLfgEgcI4/YH/13yFSmf/RApxW7HsSsmu6WXM5Q+BcCbzHGONNr7MskgnYB38K05Vl00pKSfrmDTBk0u7AIXu+cYhyr6bTe/4GhVbzK2catyM1wJ4qibKfAxqsfkVQqv2l9Jz4ogKfE2rzGh7SIZp2St+7UluSGMgnMDwDMfHm+7GKTsQNXdRQUCoWW6rT393VidYGfcbPtKs7n/MyYQ74pqBOdv1QsRLiTG7JhN/jEFR3/2HeKo9jRXsATGkoKtHIVC1MRiD0eXN8nZ48ZKaV+/EIynnonJ1Rd9UTyaqH8TYwUgkGlX/0pHWtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaW3JiSEJ/xK1Qn+SQpmM7tyNY66/Kkx3qTK1TG2FhI=;
 b=PPa4FsSDvOCXqCeOm140tfNBSCXw7m3C+KLYRWSC5Z0QLkNXSSRALmk3wVfP5NXoWXCOTjwTfJjFoxVG5gLrEgJyiMje4/coXLnaRhD7Z60LEKdQfEnW/tGHHgSeSB4e0laLcC6Z8KwBkYyC2XkD3FQI1HP4IS5l5DRKRXIx6SGpt4MEKwYO1wt9yNhoVGsYcW3sdGAhswkWTWwF6KMtpVo6xhZU7QXimKcpkXSI6g56xc9aEtzl3bQeHC6wrKqYOTtSIhrQeTy0ph3cdpSpL4pFNc90+1aN20DPh4ygN3/pbg12q+bhGIhkzwVbE6jETUANdikWvqj7MLJBWzOmxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaW3JiSEJ/xK1Qn+SQpmM7tyNY66/Kkx3qTK1TG2FhI=;
 b=rrZ4s9JEBahyuQTwHllgf4ZjrHQsu6j//DoUaG9INp+uj2y4GXrzNaSU80nxtSzUm3603CLnolC5sEYQzIPdrmQdxLeNQSyEntL6emqCyrbOiqFFqqBHvMzVzDlO2/Z9YdikQb8xipS5miM2Sxk+tqyWWDFl9+3tjI3+6fmmlUkQxa9SNlf6cw39DyRj2QEXl4OlQkLAT+nuOiZm9SWd0sUDOw3szcGvH/ZyfQT7XSD9PYkrErwFIf6r8Ceo3DRcFDnyskgE293Wc0IlIGRtOGw7BWXPxdTSIq/inASjFh3PvheLVJ7NO8qK78i/fGO5mlSV/sDbGuYMX1ObvIBadg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:12:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:12:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/13] mlxsw: spectrum_fid: Configure VNI to FID classification
Date:   Mon,  4 Jul 2022 09:11:28 +0300
Message-Id: <20220704061139.1208770-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0009.eurprd05.prod.outlook.com
 (2603:10a6:800:92::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c922d18-f0c9-46e5-a046-08da5d843d15
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCelqR/znOfX4WgiErvMrpnsBz5bFFkEtjdsOPe8OEoRwD7flL8J3wS3/HBTxyjz+45thKebMDYtzAfSe2H+TLvcAvxqR9NTKU/XRWguAP9HjXmHYSblaGYBs8sREzUz1++sf1Mw7hNBvuajivQnF+HqBH/ViwHGN8ShittCY2LDTK+bsZPgwer7qnnAcINOR9fuEKoCN3YvrvbrvOPz2cQISD7InQZVh92o4r4ba4HLrGaDD9zLHDw5VSSwW5oWMHwXHdkyBfPE2oJgUzaXsAWqRzp/+pZRInBAA3kvQQBlZeyHeBibBFFBBTkRtRlDXlNIsu7iD90mkx1i2mKQSUjAs5qX7nXISQoDTb7v8/YQPST/CM8PmKuvPcJUEddnrPkWXS8WYZWlEbPe6B3SV5B0dqiIBV9IJA0h5t+O0dgxt8rHJUyek574/zB8RHTUA0Ttnd1l7AXSezgXMYdMac1f5jZy+gRGpDyZMPqXj5Ew3FIfZjpedWEa6BsVEA8PKV23msRwRTQ/bPzCcs5nzJlMzs5IFQZ1dvtKmlMrvnVT1Szg7x+qim0QpwkCKXFAbio972rpPfqLcZzgUUWzGtRgKsOi6f/HJjw3Ce/hBtGSGu/9nUc2fasHsjpktq9S6GHraSjc/RPmISVXm+8DgSc6tp4Gfxy10DBwhB5NprqlcfMP6jp1dj2JFgz2Lo4UlsjMdzmOKvGELAPnj7ukxR2UgRfrlkz/bShQheAtWI912yt35INPNBIbR2g1Ng/4xukvJe3Iq6M+0xdwzEL+kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TFsdUHi0UlHHeq1pcbPTcjlkxaVj+2K1OfVh+vhJMn18N0ucC+MinEqZe80v?=
 =?us-ascii?Q?ZfHMvc8eQQEv1N3nYgxXnAhy0YZD8g8Wq15nq3eRmgZfkr8wHvHf4l3IKwI9?=
 =?us-ascii?Q?rXbyqlz4zybtGzl1Eg8EgO6maNx3NiX990ru1bqwoPMb/Wrv8Aq6fBkz6KDd?=
 =?us-ascii?Q?+v5SIqf20MJL0eYn5ynKkJbv8lbN1igAb+Szvcnf4wt91VNkOJEUxSZTt829?=
 =?us-ascii?Q?ORWNbEw5ZmgW7CiVwUUOjT2TzJ7kxvM8CDVVEP903dp+ROPcjUauR4shtUS6?=
 =?us-ascii?Q?4U/dF9JDCg3eI3cj7p1NrI5RwunEHVWP41INM0W8L/KA0zRuCc77AES3m2rt?=
 =?us-ascii?Q?ANqeBnrF5dHup360YAzyBmHNcPE0zndeKRKuW8lZ2u2YKHJLopPafaRBLzbp?=
 =?us-ascii?Q?0HYGmyq0ErneKA5OHQcMv0jwnN4TZSULDOjivmLxcYHiMUS9FheX/AARd/G2?=
 =?us-ascii?Q?aeSTuFQ6Y7xynrv4Xvhf/NbgiVd+t7ci2tcQNaadcmUs+s1qe/d7Qmexx34f?=
 =?us-ascii?Q?qWbMnDFWaa15ne0AtSkfOcY6r5vkus9RPTuF3GKbJeEDT/EbGlqrAXhd/sIp?=
 =?us-ascii?Q?vWicfhNP+Sd+smNZB+3lSRBINDTh1l8NMLX4t/dX+0rBeWHptznD61P9m3dO?=
 =?us-ascii?Q?fAnO7Umhrb9s1g/vqEH9l0Y4+o8RB2d5BRpOAjMMEhUO/KQhVCsk6pSyNB1N?=
 =?us-ascii?Q?+7GyiViqANZ1tLGyat89YvZill3lVQLZ6QgmLYo3DsI/70CoojFs9qB6Z8dQ?=
 =?us-ascii?Q?qYDU4G/AKlJ5imQp6bkBK9NNWziaX166I/eja1+Fcr08CsGsljb512O0Efg2?=
 =?us-ascii?Q?/BpOhz08e+ord0VzMO/D66IyJMdg1eHW5M0aZVtk7c2ZgOqXwlZ6fVMh4rFq?=
 =?us-ascii?Q?Rtu/dGyT+teYyzdPWw5hGlUmQA/vV60CmYMDWyAHtSgPbe5UlJSg+r2jawey?=
 =?us-ascii?Q?LorxWIhHEXZ133I9XX2mfe10ZKOCl4wCypCDCmCSUIjvByJvIRNlaCTtPFaR?=
 =?us-ascii?Q?/t39wHAV4lXlf4c64v4lPltEzUdou7Vky4yL6hANJ45OGwKMf7ZFg8BMJpr1?=
 =?us-ascii?Q?wnce0Vak/D8U+w75ZqPBgQggzW7xaUrwhbl8tN4kTPd196PxK1oNOhJTedK6?=
 =?us-ascii?Q?HS5kr9DViT5knqiQ1yTAzGKeLxONzk9soDiGIjB76qn9tuJaXcJvFNzZJijn?=
 =?us-ascii?Q?hSpozt/jcF/34iWcfIMBY0NdmkeoyUgco+WCVU9CMexyPmclotkUZ21XKI8q?=
 =?us-ascii?Q?Gqd91yLHeMc4KgVNwQ3DGUXsT++O4qNJ0lWmxLV7B4dkXCQOltpEe2fbc1oI?=
 =?us-ascii?Q?TDI0bPovupgu1bnq1W/3XWGXQNOeGNzsWonfYgAniBJ7U5Uzwjy/CYuwlLU1?=
 =?us-ascii?Q?GegyC1XFGnTdPkZSgvxO3hze1rNReKA7W4l6lQpTekEyfBfc/9kR7YynmLe3?=
 =?us-ascii?Q?FuBohdE2wIncYfzd1T4N1nIQF0bG33m4IUYyEZ+TeJDjKKmWLE7vj3v/p95n?=
 =?us-ascii?Q?brSm39NzQUsGyOxwUCcYlevWWo1qPSl60TsyicI73g9ttTwaP3zi9StAQ2V5?=
 =?us-ascii?Q?lYSTZb07YutmarKN98A+Zl6Xn2MABQNtlQ2vgPsW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c922d18-f0c9-46e5-a046-08da5d843d15
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:12:56.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: guH9Ly4BlPy7qTSca0yLZiDBrXLpsfgIQVE6lUiQ9x1Dy/WPD/gA1M17/nQo9V+QXeZ9hf+Qa9TgoSZ4bTiATg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In the new model, SFMR no longer configures both VNI->FID and FID->VNI
classifications, but only the later. The former needs to be configured via
SVFA.

Add SVFA configuration as part of vni_set() and vni_clear().

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 38 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 160c5af5235d..ffe8c583865d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -487,6 +487,40 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
+static int mlxsw_sp_fid_vni_to_fid_map(const struct mlxsw_sp_fid *fid,
+				       bool valid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+
+	mlxsw_reg_svfa_vni_pack(svfa_pl, valid, fid->fid_index,
+				be32_to_cpu(fid->vni));
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	int err;
+
+	if (mlxsw_sp->ubridge) {
+		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->vni_valid);
+		if (err)
+			return err;
+	}
+
+	err = mlxsw_sp_fid_edit_op(fid);
+	if (err)
+		goto err_fid_edit_op;
+
+	return 0;
+
+err_fid_edit_op:
+	if (mlxsw_sp->ubridge)
+		mlxsw_sp_fid_vni_to_fid_map(fid, !fid->vni_valid);
+	return err;
+}
+
 static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 				       u16 local_port, u16 vid, bool valid)
 {
@@ -724,12 +758,12 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 
 static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid)
 {
-	return mlxsw_sp_fid_edit_op(fid);
+	return mlxsw_sp_fid_vni_op(fid);
 }
 
 static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_edit_op(fid);
+	mlxsw_sp_fid_vni_op(fid);
 }
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
-- 
2.36.1

