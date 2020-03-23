Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F7A18F605
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgCWNoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:44:17 -0400
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:16612
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728434AbgCWNoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 09:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJLRHJoWwbzsCoKa2C2/cG0qrhS1cnA2Zjjqg39qmzXXDu41PXtdolNPVF3X8+2Q/d2NST4TgqW+Q/axL6j200MPdzCBU1r6i4RzSAzbXXQGS+e0JXBZWIFMOUDuwjh8TOuFizJaF3DNvxTBPPVoR6Nls9xjypz+7Ku8qG0tWtWvSSRE7sQoVlTtbAb6CLZbXdSdQ/KJljOnW/ZL9GnOcVR6G+cgAqCOZcrunWru3GrnfHZdVqZWX+mMtOTn+zbqVOstenaifWK435X9a1pxA/02dZv4asJtr+4dsnd6gUm53qlFtvY42lcyHJitlsYjYUpShnKBX8wiDaX6mAed4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLF0+vLlaPDa24FhyToXtQf1uIPhXXUW7x6snbU1o0Y=;
 b=X4i17JrS4mF2NWawMsPj1SNFdFPO+NYQQ6O8vQTIfZIU2bO+nUDZZligMGv0WyIjgUN++8/seMMn9GNofhk7Tfdjb3K2F7ILl4tqnzwb2o0tcHy51L23YEcZM6vWCau8HcNQ/LoaY4qfoOwFG5AQexf5FOOL87RGF6tR5uMtSX5d31mJSFi1HUOvO34Z0DLuNpUJrhS/W0pA1AxSk5D4ZFSY9dNzFzYo1WNt01ds5mIqgoNLKVSWqmc/hWurXiznc/B1d2DSiOPvYtOZAYJo/vC+TxNwscVd9kCU9Cndb1U4hA/EYSjyKD2j6BeMP53STtHGTQ6xZpHf4GRWq4i97g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLF0+vLlaPDa24FhyToXtQf1uIPhXXUW7x6snbU1o0Y=;
 b=ezr7LOD71GHQYIV9gzDsH+8j0RCNHCn5/1e64Zie2J1NQa0cI/d88VnXQxrLEyf1a2Yad3zWPUPH4kcXXgwTDQV68F/5NzV3ymMbDrbRG1GTxcRUVTpQR1v+2nM8/DH/jSIZjktxZUSUCzCidYy4VEMEVprMTU3zxxSm56Bnqec=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB3215.eurprd05.prod.outlook.com (10.175.245.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Mon, 23 Mar 2020 13:44:13 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 13:44:13 +0000
References: <1584765584-4168-1-git-send-email-wenxu@ucloud.cn> <1584765584-4168-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] net/mlx5e: refactor indr setup block
In-reply-to: <1584765584-4168-2-git-send-email-wenxu@ucloud.cn>
Date:   Mon, 23 Mar 2020 15:44:10 +0200
Message-ID: <vbf8sjrnq39.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0099.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::15) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0099.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Mon, 23 Mar 2020 13:44:11 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf19cbdd-f345-49fc-4f5c-08d7cf30456f
X-MS-TrafficTypeDiagnostic: VI1PR05MB3215:|VI1PR05MB3215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3215BAE84FC7BBE00D8D81A4ADF00@VI1PR05MB3215.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(199004)(956004)(66476007)(66556008)(36756003)(66946007)(5660300002)(478600001)(81156014)(8676002)(8936002)(81166006)(4326008)(86362001)(2616005)(2906002)(16526019)(186003)(316002)(6916009)(7696005)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3215;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2pFCSP2oSp9R0y9+N3TL+iEb087HWCROCVxqCn0NQ81OpAk0iKlzRZ/vWNDBeieen/3bj+FgwE+WkMFHsTa41AmmUUwWql7zwD2vWWFbTENQKgu9ps0F2d6+0xBE/dIAR4kZ+Ryju7qZy5ROB2O/aUHhQps9BiZK87MXZ9LlhKgGUcRaeqI0B0MGXgtFGBXauvauicD/8l09cdjMeXnJId7Pw55lAZ1E/7JeafzZ7T+0nCPov1z1taKGsBsW4dbfvsWp9MW7cEIkEXlomeehdxsjboXw31Is9LAYCfMgTxfBTXg+vsr9PtfS/dYiljVNA5o+7g92VIVCFrfpNAzKMwOrCmnK62MqFjT7d3+3t30EUQLtWy64tx7GZkz8hC5jtiQwWN0KtTpqHIyLnvvQIpbWeHTvHwaZrWqpnakk/eTI41veKBw7h/hM+gc0Y6M
X-MS-Exchange-AntiSpam-MessageData: pfQ5o8B3+or7+103xq1eSnCfYiEsuij+F5DH823K0ejbTT633OWnDzkp/XFfIM3OKWHXYUEqAWHoozXkZX+jrNV1vWY7zZxz2gHFI851zWhYoJulV9Tl2qU0yyJdyh5vTQ29c400AiyRREUY8iOyyQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf19cbdd-f345-49fc-4f5c-08d7cf30456f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 13:44:12.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5gAatzWpKV6//CpjC5AJyv9j2UUrxeNDQhcH1bz0hxv0uOV2BUFRfqNVR/HBRCFfRuuPt5XAiZnjPC3Cwb2DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 21 Mar 2020 at 06:39, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Refactor indr setup block for support ft indr setup in the
> next patch

Description of why this refactoring is needed and details of the change
would be nice.

>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: no change
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 42 ++++++++++++------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index a33d151..057f5f9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -694,9 +694,9 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
>  static int
>  mlx5e_rep_indr_offload(struct net_device *netdev,
>  		       struct flow_cls_offload *flower,
> -		       struct mlx5e_rep_indr_block_priv *indr_priv)
> +		       struct mlx5e_rep_indr_block_priv *indr_priv,
> +		       unsigned long flags)
>  {
> -	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
>  	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
>  	int err = 0;
>  
> @@ -717,20 +717,22 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
>  	return err;
>  }
>  
> -static int mlx5e_rep_indr_setup_block_cb(enum tc_setup_type type,
> -					 void *type_data, void *indr_priv)
> +static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
> +				      void *type_data, void *indr_priv)
>  {
> +	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
>  	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
>  
>  	switch (type) {
>  	case TC_SETUP_CLSFLOWER:
> -		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv);
> +		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
> +					      flags);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
>  }
>  
> -static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
> +static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>  {
>  	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
>  
> @@ -741,9 +743,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
>  static LIST_HEAD(mlx5e_block_cb_list);
>  
>  static int
> -mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
> -			      struct mlx5e_rep_priv *rpriv,
> -			      struct flow_block_offload *f)
> +mlx5e_rep_indr_setup_block(struct net_device *netdev,
> +			   struct mlx5e_rep_priv *rpriv,
> +			   struct flow_block_offload *f,
> +			   flow_setup_cb_t *setup_cb)
>  {
>  	struct mlx5e_rep_indr_block_priv *indr_priv;
>  	struct flow_block_cb *block_cb;
> @@ -769,9 +772,8 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
>  		list_add(&indr_priv->list,
>  			 &rpriv->uplink_priv.tc_indr_block_priv_list);
>  
> -		block_cb = flow_block_cb_alloc(mlx5e_rep_indr_setup_block_cb,
> -					       indr_priv, indr_priv,
> -					       mlx5e_rep_indr_tc_block_unbind);
> +		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
> +					       mlx5e_rep_indr_block_unbind);
>  		if (IS_ERR(block_cb)) {
>  			list_del(&indr_priv->list);
>  			kfree(indr_priv);
> @@ -786,9 +788,7 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
>  		if (!indr_priv)
>  			return -ENOENT;
>  
> -		block_cb = flow_block_cb_lookup(f->block,
> -						mlx5e_rep_indr_setup_block_cb,
> -						indr_priv);
> +		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
>  		if (!block_cb)
>  			return -ENOENT;
>  
> @@ -802,13 +802,13 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
>  }
>  
>  static
> -int mlx5e_rep_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
> -			       enum tc_setup_type type, void *type_data)
> +int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
> +			    enum tc_setup_type type, void *type_data)
>  {
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
> -		return mlx5e_rep_indr_setup_tc_block(netdev, cb_priv,
> -						      type_data);
> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
> +						  mlx5e_rep_indr_setup_tc_cb);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -820,7 +820,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
>  	int err;
>  
>  	err = __flow_indr_block_cb_register(netdev, rpriv,
> -					    mlx5e_rep_indr_setup_tc_cb,
> +					    mlx5e_rep_indr_setup_cb,
>  					    rpriv);
>  	if (err) {
>  		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
> @@ -834,7 +834,7 @@ static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
>  static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
>  					    struct net_device *netdev)
>  {
> -	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_tc_cb,
> +	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
>  					rpriv);
>  }

