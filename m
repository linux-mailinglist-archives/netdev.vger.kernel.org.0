Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E10B190D05
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCXMFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:05:20 -0400
Received: from mail-eopbgr50073.outbound.protection.outlook.com ([40.107.5.73]:24750
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727295AbgCXMFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 08:05:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJciDd9kon73SXeK4HpliKwC6wjZlw0XapQihUZzSllpNNkVEyBq+itMy7soDVl3hy4w3OswqnZ4PemVxjiKNUc5Mv8OVHhsHZf9Q7kG5RC4XeaXoLCFhQ+4c1kzvnzgaTK5cYILE7Oma/cKwh86D3QHlTZPUjYnHyQEqOClde0CnSvgb9hsCy18fR0u1S5RusjWmswEbbJhwxaZwQi6UKSp6btIsgTP2pCKcyIU/cq2PHji0mnHMocyA9q1jx6CiZjoxCbzDXb9PkZK1NTDdIaEiI56kO8yChYHi4rDcdGLMtti4oOPLrfgfCdf5iI2PdN2s51bttgrmFwKb96Iqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS5AeyRQ0Z2vDpH7jEBAKByGWKNZPh6D5Wu+78p5KN0=;
 b=gNNCK7Pb5uP6paNojmgr+D11p4npwOtVd2PAj9IQZRfdZQTUGttKtyZ/0AwGv3wgqH43uAgl8QBQDIBvEJAfzEsHm/4gTn4LvsZOFuTAkOq+hOFPBg+lnvzwDA8HzcKWTGipzlDcxjnqor3+oonsbV4ziiVA5YPqHc88JP0fM1jPgkPgjlkNlrytBe786YZSn2KK6UpXHrJ0p19/ykUXnI1Zun/Gr99Zz+9hrBkxT7ke2OdZaRrludlknKiLYGvBydPMnTM6wHQVDTwYsxoOMzwufiOfvz7uAorXx1GktJzrnYBRpW6/FfVaw7t+uZsz1T+gqY/pH2OoqKz9wU4nGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS5AeyRQ0Z2vDpH7jEBAKByGWKNZPh6D5Wu+78p5KN0=;
 b=ldi+uFe3pRerm2jNgvZvnDLPIXUEdY6yHNhC3IWdpeJ1YRr7IqBHYPIsMbKEQ9g/evMrAJLKz78gBrUYV7hpmMuMiPH0tuKvvrP81GTiT3Q0xzK0AmDjKXMIWyI5m3a5dWos1SKsirU8aSlA3fMayaSGuKmO8269ehu4qXj8KwA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB3357.eurprd05.prod.outlook.com (10.170.237.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 12:05:17 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 12:05:16 +0000
References: <1585007097-28475-1-git-send-email-wenxu@ucloud.cn> <1585007097-28475-3-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
In-reply-to: <1585007097-28475-3-git-send-email-wenxu@ucloud.cn>
Date:   Tue, 24 Mar 2020 14:05:12 +0200
Message-ID: <vbfimiudklj.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Tue, 24 Mar 2020 12:05:15 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e151b395-81aa-4617-2ac6-08d7cfeb9da4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3357:|VI1PR05MB3357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3357281C44244CAFDB91D02EADF10@VI1PR05MB3357.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(346002)(376002)(366004)(956004)(16526019)(8936002)(6486002)(478600001)(6916009)(6666004)(186003)(36756003)(4326008)(86362001)(2616005)(52116002)(66476007)(66946007)(26005)(7696005)(5660300002)(66556008)(2906002)(81156014)(81166006)(316002)(8676002)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3357;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xgjh5oubu+RTPj1OGyLH1wVguEcUTUHAYl6QqBGqTQzubFljTL0crgo5gFRMJWZY+MJCaF7u4SS3qZkcJGcZsR7tgRjqgIwcwNe6YfJK0kHC9C00ia1fNpICLphW4puy7lkpIDcc7k7CstbPkGVQKP/KvCdZQqYFAPT+PuR/DUTh0TpRpH1eMovEzYBMyWjVWfTCP6ZUMN7mQQiTCwWFw/9dOEUK1X6Nsw00wH8PSOpNgGIgOk8+WRjVQcpjZHTFE/s93c6uvJcoK6WYYYn/zsz7TQxUM7aPnisnITchW/vFdN0jYXAuhKNGE6gbtqfKO/On2ZiqBSRfFP58D9DGdAleXzj2q6S9dGHPja+aiQTDiT7JLPnEteuQ5khHG4uixJkkgpCyQuuTMCbiY8pUwLosTTtaAxez4Dte4BYMa3e9kaf/52+fvQ5tnNJ/31oeJ7xf9pHCJgw0yqLa+wrOIZhWunH3FgxAPRA3M/tiTJv+15xZEdTz/WUD2J/a9f5
X-MS-Exchange-AntiSpam-MessageData: SBsm1i5rR18kQZifoy6RjaKkowAwoLthoH1/WU4WJpimkbhpfyARox4jZO4JKNDuNJRtiynVfAsE/amTZRa9TWZx5dchKW+VQmmz9PsSNGrwEnTtaXO+j/7HjGKC5cIdlqypZOOFIDU9+XXatTT1dg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e151b395-81aa-4617-2ac6-08d7cfeb9da4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 12:05:16.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: beZRaN7ZMlaWFidxSNv+O1LBHhF9RllFcTw2Vq1K1f0ZVj9YByY3a7oVIvq5aN//SMhap2OEn6Zgu5cVfvNcjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Mar 2020 at 01:44, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
> in FT mode.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v5: no change
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 52 ++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 057f5f9..30c81c3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -732,6 +732,55 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
>  	}
>  }
>
> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
> +				      void *type_data, void *indr_priv)
> +{
> +	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
> +	struct flow_cls_offload *f = type_data;
> +	struct flow_cls_offload tmp;
> +	struct mlx5e_priv *mpriv;
> +	struct mlx5_eswitch *esw;
> +	unsigned long flags;
> +	int err;
> +
> +	mpriv = netdev_priv(priv->rpriv->netdev);
> +	esw = mpriv->mdev->priv.eswitch;
> +
> +	flags = MLX5_TC_FLAG(EGRESS) |
> +		MLX5_TC_FLAG(ESW_OFFLOAD) |
> +		MLX5_TC_FLAG(FT_OFFLOAD);
> +
> +	switch (type) {
> +	case TC_SETUP_CLSFLOWER:
> +		memcpy(&tmp, f, sizeof(*f));
> +
> +		if (!mlx5_esw_chains_prios_supported(esw))
> +			return -EOPNOTSUPP;
> +
> +		/* Re-use tc offload path by moving the ft flow to the
> +		 * reserved ft chain.
> +		 *
> +		 * FT offload can use prio range [0, INT_MAX], so we normalize
> +		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
> +		 * as with tc, where prio 0 isn't supported.
> +		 *
> +		 * We only support chain 0 of FT offload.
> +		 */
> +		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
> +			return -EOPNOTSUPP;
> +		if (tmp.common.chain_index != 0)
> +			return -EOPNOTSUPP;
> +
> +		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
> +		tmp.common.prio++;
> +		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
> +		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));

Why do you need to create temporary copy of flow_cls_offload struct and
then copy parts of tmp back to the original? Again, this info should
probably be in the commit message.

> +		return err;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>  {
>  	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
> @@ -809,6 +858,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
>  	case TC_SETUP_BLOCK:
>  		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>  						  mlx5e_rep_indr_setup_tc_cb);
> +	case TC_SETUP_FT:
> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
> +						  mlx5e_rep_indr_setup_ft_cb);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
