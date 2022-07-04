Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A32564D8F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiGDGNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiGDGNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C046938BB
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxKfh9B/PphguYY9+NOzysaCab7d+NbAlIcR5BggfkE7elEl69zIbFZ1yg+dbZCsUuLGc8jU1m5SqTe59Dzpay2Nu7p5JOs44hzwNSTDsOYUAfAhywepB+lzkNZntEJRAyokSW0EyptkThKPs2dRMavA983V2TO+AASQJDzDH7LfMFqs5iqHvU4YyMJ0v2yO+41rHFjc3L2Ydz6vmTXQaJt3lTEKmzx3Che3UKWUZIY8Zuic5l6MW6bBqtlumWR2sfwMzVD3JVArCE2eusfFuoiinjiEAGOrPruKn/tUkzstJa/T0I1KM4Zoq1g8J1Kv52HcRqmo22WZZ67IKz9TnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0TKWZ0l3lFW0LzK0rTYNFE0qSVt71HLMupIioC7CCA=;
 b=mF6QyJ5uI9hXvU8VI1dDERGWSsj0xRy1yBsck0XP9XKrmvO83kF5y0aycqk0uHknLTA2rYNb0yFB7a1dTvI/hBeO/QmtZxPv8HmJDZtQHbeQ6nJz5KILQTQuhi2iV9n/h8b0BFjQO8ELl6e8bW2Y8hj1F6oYb5UpWn4Z+8GEoK5oO+CCfH4t4DiDFTP3+e2f/XjkTpbN+lv39MEJ4MrT3m9xjjykt2k78aEW06wSjLfIHexm+VoqsYoHD8X9wqHplq4LqUP12Eoac3E4vqqwnfzWEJ7x75oyOB/UDsAzmdj/8jK0D/hkd+oq2HLSTxArIazpTc7TWkBZX25eDhsQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0TKWZ0l3lFW0LzK0rTYNFE0qSVt71HLMupIioC7CCA=;
 b=GSxYGvLLYe5iARFhXZ7wXgjEMLJKYgwdZGYi/gYNm9TBbfjFODsUvRI/NE0U0WQZy+lXUuBf4/uq+GIxCJIwoBVr2IWF4IgX/jCscmhjfFxk8HzmV81hapYdR/b/Mygy4xbkVo9BpqX5/gCK6t3yTHon5JLDDYZzLIeu3FL1SGU0di3ftQwSwqTXMcuzll0O9VamDm2m3rzABbDVR6z3N9zBWlzT+5YdG0Y87CEJeGDPaQLv1q8gBt4AuLYZ7JgeJ/c5xkumHqhjkd8A6FIgW+w/FawmXxJW1wPsliy7dgQ1XEglKCLIG6Mh4o+DcRyMupHT4/4nft9lo6pdru7BxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:13:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/13] mlxsw: spectrum_fid: Configure layer 3 egress VID classification
Date:   Mon,  4 Jul 2022 09:11:30 +0300
Message-Id: <20220704061139.1208770-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0009.eurprd05.prod.outlook.com
 (2603:10a6:803:1::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dfd00a0-c791-4cdc-340d-08da5d84448e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YpmWKyOpWb96zMGChzQtmrZug7YcdrqtFOBjhVdco9e23ESdxIvuzG8UAgyZeQ0af88kFhLO+sBmY/PZgFYALXWk8bKFKoqgvOmWv9sRlZY4EjUyDgRnuZS0A+E5CmDLpgpbSwF0Zvl32reblH8wR4k7Anvbf3FJHs6p52a2ei1fU4fuDzL3pMywFB+8zaGxJKA2i4gi85IrJZ5ykQ32YuTinX3/9nxgMGmZG7NhIo813bcouMrwPIUpGOxCSsetMPo8WN/3AT2+vuVKGL4RyZjUlzHKNk/+EKR1loVDSWEXXV8TfoKfr7yeqmPC562AF22BXxxQlQKrUk2idqKkMJd+CF1DHxrnK4fJWDNmnfUrlXh8/OZytiBap5u8MpP87gyx4v8meUkH9HK2mt1R8Vsx/CLasGMoO1KunsPIeYRmjLXcflZ+gFJX2mgIxe5+AoVrx28JrJeAB56/GRA9TK9tcM1S+xAVrmaqg4ybqxXJIY1amEPtVqaPNFlfVvHpAbkdmOmln+1rw+fPzVVzK4GMUm89imzJ9K0Rb537z/mCwqgKQNWwVN0G+EzV/8nUzGy63MJBQiKuM+w5U71k8RjZeSUQW6lvxw0FZep4R4hky6aFwsB/w2yuTp4qx/IQHHM++oUCQHqn6imi0xZ4L1HotdEH7HJMHshZIMjZVnnTVje/OdBjeR7lnIXguODw75Cr9sYlPyzFDP19vaBRRCu0LsFCuThw6KMly4SY0lCBF5/Gd2SkR31/JwMEMDS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pXAjTZR35wmHocr0Dhj19WmbEHgOrcR+NgnsSuYTL/jbeFsRSmBMWz+YTIrX?=
 =?us-ascii?Q?TpaWDQTWw7yC5B1WIfFJf9/mv18b362XxRhUyX4/DxYF9SwcWofmOeWC+SIK?=
 =?us-ascii?Q?mi9UR/xhr67edVZ9iDABsXKz5e7AcRDce1SNsfw1JesQxNfT25SAKOrARmz4?=
 =?us-ascii?Q?jNik9Q9HxQRGd8Oj6rxV7hyfxrAtQybSXPTQJqcyNsCl/pOPAdCs+hTcBKXf?=
 =?us-ascii?Q?tc/hqH/blp++MHqZwS+ckEjTDoT5+YNBnlPVdBv08x4EVLHMHGDqFXVkUsmC?=
 =?us-ascii?Q?351HqzClcjjPagQlhCvaggl9enlQtr0BBVmvKILamvvMjW9RVmCc6JZ8CRml?=
 =?us-ascii?Q?o8aS1ldKtmRw5PQW4laN197FzfGNSiK+x9B04GnvCGRDM6sBbEjZeHoGpOyW?=
 =?us-ascii?Q?cGC+/pjHVAMQ0S2DkWxGWIiAbMZJNNqHVx/gf+gBCTWEcag0f42pDg9mINc3?=
 =?us-ascii?Q?C1+7qkhAeFpCyITo4guC7XDrIE0e2aPg5kTv9RZBTDICqegTFhLgW4eBATlp?=
 =?us-ascii?Q?AhRMOeYcuGL9+3EL3CSXACeSOGR2cu6NbSJjNDNbvnlKG9eeo++Y5wSy+UnN?=
 =?us-ascii?Q?vFsRMKj2zZ0bxgw8P2ZnggmviELhGpxpm0jH8/83pS/h6hve5Be8knjshHO0?=
 =?us-ascii?Q?EoIcosbU9gAGs+0z9hGQWnauArNkdJq9mheE+07st5k4y0gVPrZwsiah/gPf?=
 =?us-ascii?Q?mZKd/V0J7rq37wvRvjuKgo+dRBr9MITBAPsYX9NzCLNbdtZ3I1VydJGgi5rF?=
 =?us-ascii?Q?rbz2+57Gz74RedxJ5hwJ6BCvicHwMIJuA/XrPx9baueifw5Vnkj6lKOczIHx?=
 =?us-ascii?Q?bhhRfW7fC8pOwRd38I883+gHaMGIF49IdCkX2/REQmXmSWqNSSwbCE9nOocl?=
 =?us-ascii?Q?W2YIa8GshjTnJ+jMtqsCWgh9F139r9Utt/NCAsREaAsTRwVx/uB6vPfKJHyT?=
 =?us-ascii?Q?iBLMtWsEDhoEM5QYP9C3QSFn3gG00kqlyMgpLgI3i2/UL1MmSTfezFoon9wi?=
 =?us-ascii?Q?n0xw1mdZ7hcPJPjShY3uOw6P1mmSEYlu4+1ldgiu6x+lRC+ptD21ZuryW4W5?=
 =?us-ascii?Q?6n96dx4GOpMCBLQX2sQ+yJn+lSSNsimQzgQFd3Lvev+erkszYCdwSnGA/h9w?=
 =?us-ascii?Q?twNA8U+7RP8golwbQlh3TiC9D23Nckz15PwY7+cYecNiUspVJLGGn+7wOpJ9?=
 =?us-ascii?Q?D3+3xShdPspZEs3O3SQhrqoTLym3QVM603O7pMXvOvhOLpAsVo1+MC2WzpWl?=
 =?us-ascii?Q?6Z6kKPTP6sEE9dRAnM/1UNqYiq4dw5lCDCPHUuUmf4XH9PiEpDDab3kNib8E?=
 =?us-ascii?Q?q7XZq7sDPlyGp5HVOclxZuZA9fDqvlEflYH3vma/rLDptMe0a9PEvIMAfQ0t?=
 =?us-ascii?Q?Dd9ogJH2AWx1By0scIlL1qmQDgOzagFQvkhb2NRqclMDhj1n7h3hO9HtRuKv?=
 =?us-ascii?Q?MS1RInlQF9WjZxpQQdJo7vim7mJrUbs8R8N8QoJaBtN070s90xvPSQi33FRT?=
 =?us-ascii?Q?hyx8uquGn2ECx5flK7Y7xKZBEmH+F7UAh3nwPQJboHMGt8szmD1u+vj6xgIv?=
 =?us-ascii?Q?BQog+XXZf326bZUlSi5ypCB1z3b3qxe3o3SBp0RF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfd00a0-c791-4cdc-340d-08da5d84448e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:09.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLHBw80DMnoymn33qwd5VMNZTN/YeUXwaCyJ8/Npo2uIhdTjauaJ+u/t10490AzWC7eapjVTSsE9vvYII11xVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After routing, the device always consults a table that determines the
packet's egress VID based on {egress RIF, egress local port}. In the
unified bridge model, it is up to software to maintain this table via REIV
register.

The table needs to be updated in the following flows:
1. When a RIF is set on a FID, need to iterate over the FID's {Port, VID}
   list and issue REIV write to map the {RIF, Port} to the given VID.
2. When a {Port, VID} is mapped to a FID and the FID already has a RIF,
   need to issue REIV write with a single record to map the {RIF, Port}
   to the given VID.

REIV register supports a simultaneous update of 256 ports, so use this
capability for the first flow.

Handle the two above mentioned flows.

Add mlxsw_sp_fid_evid_map() function to handle egress VID classification
for both unicast and multicast. Layer 2 multicast configuration is already
done in the driver, just move it to the new function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 142 +++++++++++++++++-
 1 file changed, 137 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index a8fecf47eaf5..c6397f81c2d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -590,8 +590,82 @@ static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
 	}
 }
 
+static int mlxsw_sp_fid_reiv_handle(struct mlxsw_sp_fid *fid, u16 rif_index,
+				    bool valid, u8 port_page)
+{
+	u16 local_port_end = (port_page + 1) * MLXSW_REG_REIV_REC_MAX_COUNT - 1;
+	u16 local_port_start = port_page * MLXSW_REG_REIV_REC_MAX_COUNT;
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *port_vid;
+	u8 rec_num, entries_num = 0;
+	char *reiv_pl;
+	int err;
+
+	reiv_pl = kmalloc(MLXSW_REG_REIV_LEN, GFP_KERNEL);
+	if (!reiv_pl)
+		return -ENOMEM;
+
+	mlxsw_reg_reiv_pack(reiv_pl, port_page, rif_index);
+
+	list_for_each_entry(port_vid, &fid->port_vid_list, list) {
+		/* port_vid_list is sorted by local_port. */
+		if (port_vid->local_port < local_port_start)
+			continue;
+
+		if (port_vid->local_port > local_port_end)
+			break;
+
+		rec_num = port_vid->local_port % MLXSW_REG_REIV_REC_MAX_COUNT;
+		mlxsw_reg_reiv_rec_update_set(reiv_pl, rec_num, true);
+		mlxsw_reg_reiv_rec_evid_set(reiv_pl, rec_num,
+					    valid ? port_vid->vid : 0);
+		entries_num++;
+	}
+
+	if (!entries_num) {
+		kfree(reiv_pl);
+		return 0;
+	}
+
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(reiv), reiv_pl);
+	if (err)
+		goto err_reg_write;
+
+	kfree(reiv_pl);
+	return 0;
+
+err_reg_write:
+	kfree(reiv_pl);
+	return err;
+}
+
+static int mlxsw_sp_fid_erif_eport_to_vid_map(struct mlxsw_sp_fid *fid,
+					      u16 rif_index, bool valid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	u8 num_port_pages;
+	int err, i;
+
+	num_port_pages = mlxsw_core_max_ports(mlxsw_sp->core) /
+			 MLXSW_REG_REIV_REC_MAX_COUNT + 1;
+
+	for (i = 0; i < num_port_pages; i++) {
+		err = mlxsw_sp_fid_reiv_handle(fid, rif_index, valid, i);
+		if (err)
+			goto err_reiv_handle;
+	}
+
+	return 0;
+
+err_reiv_handle:
+	for (; i >= 0; i--)
+		mlxsw_sp_fid_reiv_handle(fid, rif_index, !valid, i);
+	return err;
+}
+
 int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 {
+	u16 rif_index = mlxsw_sp_rif_index(rif);
 	int err;
 
 	if (!fid->fid_family->mlxsw_sp->ubridge) {
@@ -611,9 +685,15 @@ int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 	if (err)
 		goto err_vid_to_fid_rif_set;
 
+	err = mlxsw_sp_fid_erif_eport_to_vid_map(fid, rif_index, true);
+	if (err)
+		goto err_erif_eport_to_vid_map;
+
 	fid->rif = rif;
 	return 0;
 
+err_erif_eport_to_vid_map:
+	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
 err_vid_to_fid_rif_set:
 	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
 err_vni_to_fid_rif_update:
@@ -623,6 +703,8 @@ int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 
 void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 {
+	u16 rif_index;
+
 	if (!fid->fid_family->mlxsw_sp->ubridge) {
 		fid->rif = NULL;
 		return;
@@ -631,7 +713,10 @@ void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 	if (!fid->rif)
 		return;
 
+	rif_index = mlxsw_sp_rif_index(fid->rif);
 	fid->rif = NULL;
+
+	mlxsw_sp_fid_erif_eport_to_vid_map(fid, rif_index, false);
 	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
 	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
 	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
@@ -844,6 +929,53 @@ mlxsw_sp_fid_mpe_table_map(const struct mlxsw_sp_fid *fid, u16 local_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smpe), smpe_pl);
 }
 
+static int
+mlxsw_sp_fid_erif_eport_to_vid_map_one(const struct mlxsw_sp_fid *fid,
+				       u16 local_port, u16 vid, bool valid)
+{
+	u8 port_page = local_port / MLXSW_REG_REIV_REC_MAX_COUNT;
+	u8 rec_num = local_port % MLXSW_REG_REIV_REC_MAX_COUNT;
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	u16 rif_index = mlxsw_sp_rif_index(fid->rif);
+	char *reiv_pl;
+	int err;
+
+	reiv_pl = kmalloc(MLXSW_REG_REIV_LEN, GFP_KERNEL);
+	if (!reiv_pl)
+		return -ENOMEM;
+
+	mlxsw_reg_reiv_pack(reiv_pl, port_page, rif_index);
+	mlxsw_reg_reiv_rec_update_set(reiv_pl, rec_num, true);
+	mlxsw_reg_reiv_rec_evid_set(reiv_pl, rec_num, valid ? vid : 0);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(reiv), reiv_pl);
+	kfree(reiv_pl);
+	return err;
+}
+
+static int mlxsw_sp_fid_evid_map(const struct mlxsw_sp_fid *fid, u16 local_port,
+				 u16 vid, bool valid)
+{
+	int err;
+
+	err = mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, valid);
+	if (err)
+		return err;
+
+	if (!fid->rif)
+		return 0;
+
+	err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
+						     valid);
+	if (err)
+		goto err_erif_eport_to_vid_map_one;
+
+	return 0;
+
+err_erif_eport_to_vid_map_one:
+	mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, !valid);
+	return err;
+}
+
 static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 					   struct mlxsw_sp_port *mlxsw_sp_port,
 					   u16 vid)
@@ -858,9 +990,9 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 		return err;
 
 	if (fid->fid_family->mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, true);
+		err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
 		if (err)
-			goto err_mpe_table_map;
+			goto err_fid_evid_map;
 	}
 
 	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
@@ -881,8 +1013,8 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 err_port_vid_list_add:
 	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
-err_mpe_table_map:
+		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+err_fid_evid_map:
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	return err;
 }
@@ -899,7 +1031,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
+		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 }
 
-- 
2.36.1

