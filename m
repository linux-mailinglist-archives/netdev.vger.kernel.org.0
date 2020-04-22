Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22771B4ADD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgDVQt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:49:59 -0400
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:59903
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbgDVQt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:49:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqOu3lx4xLTXMBwj8DE/qW/Ijn0TicEXUyX1pOYmi+M5I7VYx5VJPIQZKQpAmo+Gr3DPSMyOoawQpPCf57AOP4YUO+8gB3zuXssD3E2XGuYkg0Ax6wO7LAT0KamC/oUm+z/PpacU28XTdx0K/BgDWMLlbkcRX6VfkveOb+hDOCMZ0EchG9ZY+8arEDzw/DfJ+uCrtBdRbl2VNaorCoNxP0lBDZPwDUbEDdN/b7wQopqu/DlH7Kfz3AO78gxfrBs/ebH2vZxlhXkqO9o3VfjiQKOdTHHdjwC0zfq6Vw4x4cjDrI/cnRYoiE4ySD/msxWp5QkxgN5I3wield96dqTOxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Qq23kPeuOx4JiOLSfSXotlSRMq9zGfLjnuy1PEwrnM=;
 b=XoGJXaTVkW0rhLSK7B04knoZuHzbemmffpYMoYjDWXvIuUAa0WG7EiQcSzBo0RRUbJHb/GCvAszEWe5UrSpbeKOuZYLGsqZYVRygIVt2XY114vud1SVOAy1jy0J5kqw+0s3VYY7ExiAI7d115/AG2UIodHLXDj60ibNhzTQGPxZUxU+G8UwWGwOEYSTWbzU5kdSqYXH/6BOuUH+EVCth+bhnwxIb9+1U19fpOPiaPLOivHsFiIILUArhV45IgTNVYaO1bX1SlHhXpblcc1XxifzUJTpG86eVkPIe7xqTOA44oWkgxpiMknhSNfPGq+LhD+GmnEcisevT83KQ8TXJIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Qq23kPeuOx4JiOLSfSXotlSRMq9zGfLjnuy1PEwrnM=;
 b=q49K4cFJ/1cSGEkn7Cm2c/EhEnGZdcJTnNvkw+NI5sjWt18PoDlpRIFrqzkX2i1+nRIgcsFqOyLPhWidTFHupjzkN++mXdxrrSeQpvRbiYQCXCNDGG9U7tbbe9WJ73/FRLFWeKiV7LwKAV/s5I4WvU70KR79jz/3e4G9dFMGvnE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB6055.eurprd05.prod.outlook.com (2603:10a6:20b:af::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Wed, 22 Apr
 2020 16:49:51 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 16:49:51 +0000
Date:   Wed, 22 Apr 2020 19:49:48 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 02/24] net/mlx5: Update cq.c to new cmd
 interface
Message-ID: <20200422164948.GB492196@unreal>
References: <20200420114136.264924-1-leon@kernel.org>
 <20200420114136.264924-3-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420114136.264924-3-leon@kernel.org>
X-ClientProxiedBy: AM4PR0701CA0014.eurprd07.prod.outlook.com
 (2603:10a6:200:42::24) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM4PR0701CA0014.eurprd07.prod.outlook.com (2603:10a6:200:42::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Wed, 22 Apr 2020 16:49:51 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7bd6b0d7-d367-46ae-ffec-08d7e6dd2cf7
X-MS-TrafficTypeDiagnostic: AM6PR05MB6055:|AM6PR05MB6055:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6055C60E72AEFFC46A70FBC3B0D20@AM6PR05MB6055.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(110136005)(6666004)(6486002)(1076003)(316002)(54906003)(107886003)(86362001)(5660300002)(9686003)(2906002)(6636002)(6496006)(52116002)(15650500001)(33716001)(186003)(16526019)(81156014)(66946007)(8936002)(66556008)(33656002)(8676002)(478600001)(4326008)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/1e0eloc1YVAmrMNzCmFKSskwYNEcMxY9kwbCbrREL43bkjEjsZTgN5Zih49c5TCwvamG6QKPLTbUyaUvVOzmkvW0jHyqNAG/n0qIlItM40oJroA1Axkc/FyqIi8KvfEJuMbJT0C6yWnhunGlkBYkf0pZHoQa1BlDFR69C+yoHmvHtA886cxi6T1GF32xy4qN4gwvHy8IhimKXmFhWYn8kpkwXsObTo1swBWedIQ3OQX+5RMMZLxaTylZx5DQ83rFDUaiLa7bMy5CV2N5NhHX8oL1j+bMa7+81AMqwHvtD1Cj5UnQkp3DQlNL2/4SeXmlJJAsKhjIfT3FSNygiAT2uVaqFw1joYHm5Dy7IkTcAr4b4Ku8QLA1Etbe4mKucmpGu4pnBIHPAUucdtn52zlxw5m5Z+BcthLQuaBQ+LHSV5nqnWMgRZsdzRQubEP5me
X-MS-Exchange-AntiSpam-MessageData: fQnYq4zhXPeUo94lHvfVeASXXNWSp0pR2sXAexAib1faMaXRRAKvItyGI1yjLuKV72Q344zdi/HIWFfAaCXf+Rq8JRl8jcnSxOUnK0p7NPnhn+MT6IDZ/UbQpqToHa+ZxHSI559dgzBpeHokWG8UMslgJofeZOXm/e3DzRFL39U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd6b0d7-d367-46ae-ffec-08d7e6dd2cf7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 16:49:51.4215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpQE5lmntSVxaXrrqjIkRwpVMJOw/uGoRXj8bX87G0xJj1lM/HplbK91Oayi2kBrb99a21lDicR/ik26t4orww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 02:41:14PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Do mass update of cq.c to reuse newly introduced
> mlx5_cmd_exec_in*() interfaces.
>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cq.c  | 24 +++++++------------
>  .../net/ethernet/mellanox/mlx5/core/debugfs.c |  2 +-
>  .../ethernet/mellanox/mlx5/core/en/health.c   |  2 +-
>  include/linux/mlx5/cq.h                       |  2 +-
>  4 files changed, 12 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> index 4477a590b308..1a6f1f14da97 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> @@ -90,8 +90,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
>  			u32 *in, int inlen, u32 *out, int outlen)
>  {
>  	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), c_eqn);
> -	u32 dout[MLX5_ST_SZ_DW(destroy_cq_out)];
> -	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)];
> +	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
>  	struct mlx5_eq_comp *eq;
>  	int err;
>
> @@ -141,20 +140,17 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
>  err_cq_add:
>  	mlx5_eq_del_cq(&eq->core, cq);
>  err_cmd:
> -	memset(din, 0, sizeof(din));
> -	memset(dout, 0, sizeof(dout));
>  	MLX5_SET(destroy_cq_in, din, opcode, MLX5_CMD_OP_DESTROY_CQ);
>  	MLX5_SET(destroy_cq_in, din, cqn, cq->cqn);
>  	MLX5_SET(destroy_cq_in, din, uid, cq->uid);
> -	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
> +	mlx5_cmd_exec_in(dev, destroy_cq, din);
>  	return err;
>  }
>  EXPORT_SYMBOL(mlx5_core_create_cq);
>
>  int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
>  {
> -	u32 out[MLX5_ST_SZ_DW(destroy_cq_out)] = {0};
> -	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {0};
> +	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
>  	int err;
>
>  	mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
> @@ -163,7 +159,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
>  	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
>  	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
>  	MLX5_SET(destroy_cq_in, in, uid, cq->uid);
> -	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
> +	err = mlx5_cmd_exec_in(dev, destroy_cq, in);
>  	if (err)
>  		return err;
>
> @@ -178,24 +174,22 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
>  EXPORT_SYMBOL(mlx5_core_destroy_cq);
>
>  int mlx5_core_query_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
> -		       u32 *out, int outlen)
> +		       u32 *out)
>  {
> -	u32 in[MLX5_ST_SZ_DW(query_cq_in)] = {0};
> +	u32 in[MLX5_ST_SZ_DW(query_cq_in)] = {};
>
>  	MLX5_SET(query_cq_in, in, opcode, MLX5_CMD_OP_QUERY_CQ);
>  	MLX5_SET(query_cq_in, in, cqn, cq->cqn);
> -	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
> +	return mlx5_cmd_exec_inout(dev, query_cq, in, out);
>  }
>  EXPORT_SYMBOL(mlx5_core_query_cq);
>
>  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
>  			u32 *in, int inlen)
>  {
> -	u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {0};
> -
>  	MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
>  	MLX5_SET(modify_cq_in, in, uid, cq->uid);
> -	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
> +	return mlx5_cmd_exec_in(dev, modify_cq, in);
>  }
>  EXPORT_SYMBOL(mlx5_core_modify_cq);
>

This hunk needs this fixup:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 1a6f1f14da97..8379b24cb838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -187,9 +187,11 @@ EXPORT_SYMBOL(mlx5_core_query_cq);
 int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
                        u32 *in, int inlen)
 {
+       u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {};
+
        MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
        MLX5_SET(modify_cq_in, in, uid, cq->uid);
-       return mlx5_cmd_exec_in(dev, modify_cq, in);
+       return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
 EXPORT_SYMBOL(mlx5_core_modify_cq);

Thanks
