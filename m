Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540F118FD28
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgCWS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:59:31 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6538
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727179AbgCWS7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 14:59:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0qAKLHbxqbR+A9AG+LAfoAC+iwPZQj74lfKhaS7cCjYsXYHFdNYqHosyjNit5LqKA2PZScjnVpa84osa7mAPhd0jy0vBQwUNsCWI0wZ+mbXYkUqMX4JK8l9hzWSm8dCMYCXqeoETuLNb0LQf9ByLfPyiBTrWvHIUVcKpfkbdhsRf0sZNGze9kouzBGAcwkmFwhzm+iLV6ctlpx9gSFH53KlClXagZTuKibUzt6cwNaybbmubgww//aav17dZcsS/8xM2QBiESGsbA3y3UsBRL6Fe3VRGjhFHJ/jKsKfzYFoNKXeF0LarWIbt/QfkACLCEtFPyxNEV1D7HHMrDHpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT7zh85Rhyxd+pINjq2uY27yXx9YEcHhxz9JZvLKbpw=;
 b=ggOpf0rDUSrTtDumwcO/b9zED+lmEEiJTGapsHjDb/9Onvi4nCPSMS/jJaNAFp+lb0l1bZ/Yqccy4E12juMczwQtV3ynBm23o1kGJYXmQhbTxfS6kkxRgUG5RY6IvxCbwGKat89+D5VvDNCggFjP2oXBNnIZsCj6UY+6SqbeK8Znfj6vG3DxeLztCDPLVLa8zQhyKiQE7lv3G5jdjHsCKLsFjclS08ghRX+n9NGac7nmjeEMVbGXIkRl79Wow8gNB+xGwt3O2WZXa8tafq/1KaoXw0L5ykhsZslCJ28N7ZerT8LbaB8Of2fSdkEDhfbGbZ2lbgX4Z8feA0JnO+pJqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT7zh85Rhyxd+pINjq2uY27yXx9YEcHhxz9JZvLKbpw=;
 b=GRdGmWz36sZ8LmWnUPfA9qEvQAKyg8weNmfJt9OqKlo2m4HW0ME/bx2plvpqOf66ih0rHhkz13fny4zwA5hIwXo++MfFW7pjV4TF+7WesbI4LcRFiaeV1wb+leMZCq5Mb3AQtCZahWo1uQbeXhSUpBGl2TDw+eP4x/40qqeEXRw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB6941.eurprd05.prod.outlook.com (20.181.34.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Mon, 23 Mar 2020 18:59:27 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 18:59:27 +0000
References: <1584973629-18728-1-git-send-email-wenxu@ucloud.cn> <1584973629-18728-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/2] net/mlx5e: refactor indr setup block
In-reply-to: <1584973629-18728-2-git-send-email-wenxu@ucloud.cn>
Date:   Mon, 23 Mar 2020 20:59:22 +0200
Message-ID: <vbfv9muyk1h.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0036.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::24) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR2P264CA0036.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Mon, 23 Mar 2020 18:59:26 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 437df81c-e9bc-4555-a0c6-08d7cf5c4f6c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6941:|VI1PR05MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6941CD69D73E2AE4001D3CA5ADF00@VI1PR05MB6941.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:185;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(199004)(66556008)(8676002)(81166006)(81156014)(66476007)(66946007)(478600001)(2616005)(316002)(4326008)(956004)(7696005)(26005)(186003)(52116002)(86362001)(5660300002)(6666004)(2906002)(8936002)(36756003)(6916009)(16526019)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6941;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8lBOFDc8dxW2dpbqVJH0CKsxpqhoFDcE8O1AJK3I7PlLmuDR8dEe8Qaxr/IKnkYCAUGC7/mxk/eZ69a70AwsBDU5v7NWxMkbjTFeQKnc9uo2CjSXmonKY92B/dWD/2/9WNipwJw1X/evhz2gN95SYEJHNd0bhiw/uyvFxQlYdL0x3HelmdyIaHSmyPyrDcExD66Yk/ztqDF+QDx2eirWR8VIzzrWdz2KFjUfvAue7J/s3lz+2zk7nc7oaAbaBOHe0G1bRU9nvEJeEF0JuJN77fXunQ0k1zqxjslaAkDVU5uYLmg6jkCoDqXqGBVc7VyErh/aBbkeRqOTC+WDZOtIvyLmagjkQw7RD40BEcIt70MhYqIPunTkQ83WgfHdaYJiY13IWTcFD1wYmVxHOYKWzvmc7dJHhUPDoHOsarYSK9HuYgeJywQs5KcUbimpBci
X-MS-Exchange-AntiSpam-MessageData: 3PyT1W8XbKiPExo+LOKHGqiPFNnTJqGhqre6QBYHXDaxQgEsEWNR99kgPfcBNEVFepmAfW23pb47R7bpaLcmt7vVUPfeM8w3HIHchDp7OFxNijc9VhD8qlU0ymk9VV3hI316Ro9E9ho8xUmbbTy5MA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437df81c-e9bc-4555-a0c6-08d7cf5c4f6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 18:59:27.4953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnA6lUegMcVomjVDlqcCU5G1InkLloAf0irsSf/9DHqhJZ0tisTu8VOUNqG11l99Ed2W1wCbSYWBK+xhNU0MIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 23 Mar 2020 at 16:27, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Refactor indr setup block for support ft indr setup in the
> next patch. The mlx5e_rep_indr_setup_block can be used for
> both tc and ft subsystem.

This doesn't really explain what is going on in this patch. For example,
it seems you are exposing 'flags' in order set additional flag for FT in
patch 2 of this series. I can only guess because commit message doesn't
provide any explanation.

>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: add some comments
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

