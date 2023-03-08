Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC766B047F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCHKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjCHKd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:33:28 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48545360A5;
        Wed,  8 Mar 2023 02:33:10 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ec29so32903891edb.6;
        Wed, 08 Mar 2023 02:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678271589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pwo4XfaJv1l+YyIqkO63KCYdFtndy43/Jv+5mIkKNuY=;
        b=ZUB8sK21OulKnzNxhk8o4Tm/6oQvYHUNqK4LvAuOynQxFERypQTAimNcMMK5s5ergm
         UuR8gssFK0/tSydfyX6IsZbkpZyRt7mweTFdPQ1Lw6ig+WPusGE4rS6DxilSgrWTopBu
         pj1AxSbprAGehkGglIr9adW2+WpCC18ohw8qoNrxkpFKqfJdOa1SHWwYMw7FdROO+9om
         taO9B6P3JuHB6QIaIvCuqsUmKcQIc1lHl0sa34aBgjz9GPOnfa7HcO/yyPjB2TJ16k8b
         LzQcgVEY/to+NB1ivortZz4kVcnvJjlxDtzryZDxWT7HBDPJznyoZuMQM3jV+fsvI8Kw
         uVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678271589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pwo4XfaJv1l+YyIqkO63KCYdFtndy43/Jv+5mIkKNuY=;
        b=VBUAbgZQGzqFQLuJa6N45Vrus2s4m4tkCjuAQePwyY5oSgS6RybDhrOh6M6rRAy004
         lYYcEsz+YpvtJDTHTGrSRt31Es60fATSdQBNxxizb8HDMsNjT6xzgOMVo5DrbjInrcaf
         FBlTifbVGorWZ9p0G6EEP1YCVnwl+qb37xLIaw3HysZeODqRBhhaMOYrw6tSCd4VGmVI
         rRkXft0FLiaoL2g1ib6gGyfo4d9M6jZt7WP8uakTPpa8nEVOEppO7dyCDnTIr1ZXVX4/
         lCXjcjZLtfBeo8W8ZFcCuyG33JsqsiPN4MLXGB3TWD9AIDUAaOviaYp5bTd0DXyhac4T
         t7Lg==
X-Gm-Message-State: AO0yUKUnR85SbRZJVYqY61pq9Wo307DjwMF0NpGV6/yjh6frTCgrTNqt
        J1kGSoE5A4uPH8K2b4mAAS0=
X-Google-Smtp-Source: AK7set9FCQme2WIxMktswVH1yDyaoK9EaoL4xb34/tL3jJaTP4qKfGuhE1YKeERitSI1H7VnCWhvZg==
X-Received: by 2002:a17:906:ce34:b0:8e0:2887:8263 with SMTP id sd20-20020a170906ce3400b008e028878263mr17200058ejb.39.1678271588642;
        Wed, 08 Mar 2023 02:33:08 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id se9-20020a170906ce4900b008dd3956c2e3sm7319989ejb.183.2023.03.08.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:33:07 -0800 (PST)
Message-ID: <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com>
Date:   Wed, 8 Mar 2023 12:33:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com
References: <cover.1678200041.git.lorenzo@kernel.org>
 <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/03/2023 16:54, Lorenzo Bianconi wrote:
> Take into account LRO and GRO configuration setting device xdp_features
> flag. Moreover consider channel rq_wq_type enabling rx scatter-gatter
> support in xdp_features flag.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>   .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
>   .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
>   4 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 88460b7796e5..4276c6eb6820 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -1243,6 +1243,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
>   void mlx5e_rx_dim_work(struct work_struct *work);
>   void mlx5e_tx_dim_work(struct work_struct *work);
>   
> +void mlx5e_set_xdp_feature(struct net_device *netdev);
>   netdev_features_t mlx5e_features_check(struct sk_buff *skb,
>   				       struct net_device *netdev,
>   				       netdev_features_t features);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 7708acc9b2ab..79fd21ecb9cb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -1985,6 +1985,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
>   	struct mlx5e_priv *priv = netdev_priv(netdev);
>   	struct mlx5_core_dev *mdev = priv->mdev;
>   	struct mlx5e_params new_params;
> +	int err;
>   
>   	if (enable) {
>   		/* Checking the regular RQ here; mlx5e_validate_xsk_param called
> @@ -2005,7 +2006,14 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
>   	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
>   	mlx5e_set_rq_type(mdev, &new_params);
>   
> -	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> +	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
> +	if (err)
> +		return err;
> +
> +	/* update XDP supported features */
> +	mlx5e_set_xdp_feature(netdev);
> +
> +	return 0;
>   }
>   
>   static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 76a9c5194a70..1b68dd2be2c5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4004,6 +4004,30 @@ static int mlx5e_handle_feature(struct net_device *netdev,
>   	return 0;
>   }
>   
> +void mlx5e_set_xdp_feature(struct net_device *netdev)
> +{
> +	struct mlx5e_priv *priv = netdev_priv(netdev);
> +	bool ndo_xmit = test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);

Our driver doesn't require loading a dummy XDP program to have the 
redirect-in ability. It's always there.

I actually have a bug fix under internal review with Saeed that 
addresses this.

In addition, it cleans up the NETDEV_XDP_ACT_NDO_XMIT_SG as we do not 
support it yet. I have a series that's adding support and will submit it 
soon.

Any reason you're submitting these fixes to net-next rather than net?
Maybe it'd be better if we integrate the patches, here's my fix (still 
under review...):

Author: Tariq Toukan <tariqt@nvidia.com>
Date:   Thu Feb 23 08:58:04 2023 +0200

     net/mlx5e: Fix exposed xdp_features

     Always declare NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit callback
     is always functional per our design, and does not require loading
     a dummy xdp program.

     Although non-linear XDP buffer is supported for XDP_TX flow, do not
     declare NETDEV_XDP_ACT_NDO_XMIT_SG as it is yet supported for
     redirected-in frames.

     Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
     Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c 
b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 53feb0529943..9a5d3ce1fbcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4741,13 +4741,6 @@ static int mlx5e_xdp_set(struct net_device 
*netdev, struct bpf_prog *prog)
         if (old_prog)
                 bpf_prog_put(old_prog);

-       if (reset) {
-               if (prog)
-                       xdp_features_set_redirect_target(netdev, true);
-               else
-                       xdp_features_clear_redirect_target(netdev);
-       }
-
         if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
                 goto unlock;

@@ -5144,6 +5137,7 @@ static void mlx5e_build_nic_netdev(struct 
net_device *netdev)
         netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;

         netdev->xdp_features = NETDEV_XDP_ACT_BASIC | 
NETDEV_XDP_ACT_REDIRECT |
+                              NETDEV_XDP_ACT_NDO_XMIT |
                                NETDEV_XDP_ACT_XSK_ZEROCOPY |
                                NETDEV_XDP_ACT_RX_SG;


> +	struct mlx5e_params *params = &priv->channels.params;
> +	xdp_features_t val;
> +
> +	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
> +		xdp_clear_features_flag(netdev);
> +		return;
> +	}
> +
> +	val = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> +	      NETDEV_XDP_ACT_XSK_ZEROCOPY;
> +	if (ndo_xmit)
> +		val |= NETDEV_XDP_ACT_NDO_XMIT;
> +	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) {
> +		val |= NETDEV_XDP_ACT_RX_SG;
> +		if (ndo_xmit)
> +			val |= NETDEV_XDP_ACT_NDO_XMIT_SG;

This NETDEV_XDP_ACT_NDO_XMIT_SG capability is not related to the RQ 
type. It's still not supported at this point.

BTW, I have a series completing all the missing capabilities (multibuf 
on Striding + multibuf redirect-in), should be submitted in this kernel.

> +	}
> +	xdp_set_features_flag(netdev, val);
> +}
> +
>   int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
>   {
>   	netdev_features_t oper_features = features;
> @@ -4030,6 +4054,9 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
>   		return -EINVAL;
>   	}
>   
> +	/* update XDP supported features */
> +	mlx5e_set_xdp_feature(netdev);
> +
>   	return 0;
>   }
>   
> @@ -4762,10 +4789,14 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
>   		bpf_prog_put(old_prog);
>   
>   	if (reset) {
> -		if (prog)
> -			xdp_features_set_redirect_target(netdev, true);
> -		else
> +		if (prog) {
> +			bool xmit_sg;
> +
> +			xmit_sg = new_params.rq_wq_type == MLX5_WQ_TYPE_CYCLIC;

Same, not related. Still not supported at this point.

> +			xdp_features_set_redirect_target(netdev, xmit_sg);
> +		} else {
>   			xdp_features_clear_redirect_target(netdev);
> +		}
>   	}
>   
>   	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
> @@ -5163,13 +5194,10 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>   	netdev->features         |= NETIF_F_HIGHDMA;
>   	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
>   
> -	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> -			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> -			       NETDEV_XDP_ACT_RX_SG;
> -
>   	netdev->priv_flags       |= IFF_UNICAST_FLT;
>   
>   	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
> +	mlx5e_set_xdp_feature(netdev);
>   	mlx5e_set_netdev_dev_addr(netdev);
>   	mlx5e_macsec_build_netdev(priv);
>   	mlx5e_ipsec_build_netdev(priv);
> @@ -5241,6 +5269,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
>   		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
>   
>   	mlx5e_health_create_reporters(priv);
> +	/* update XDP supported features */
> +	mlx5e_set_xdp_feature(netdev);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 9b9203443085..43fd12fb87b8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -747,6 +747,9 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
>   	/* RQ */
>   	mlx5e_build_rq_params(mdev, params);
>   
> +	/* update XDP supported features */
> +	mlx5e_set_xdp_feature(netdev);
> +
>   	/* CQ moderation params */
>   	params->rx_dim_enabled = MLX5_CAP_GEN(mdev, cq_moderation);
>   	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
