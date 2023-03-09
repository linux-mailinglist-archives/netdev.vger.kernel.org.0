Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439A56B1C34
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCIHXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCIHXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:23:18 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6737B47422;
        Wed,  8 Mar 2023 23:23:16 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ec29so3274663edb.6;
        Wed, 08 Mar 2023 23:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678346595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XonFLReJl2P3EpwCNjlfwyUq9MTgotAm7d68RTIWWbQ=;
        b=pqubWPOspaSv0rEXJkd2z7BQhdpk/wnsoVI1OuKDfWxLu53Gy88408LAKS5g6msXCQ
         rJKI7T9kvzsFx0tICAWFrEE9TmE1wZ1iQ3ySyajZLtMu+wKcv5J0eR62RK6r6kfLt7Uv
         zH8JfG2V9XyvEtWIvEjgt5GIrxTSs7dyh+c13E419Md2GtDV+26xxigCdQnN819+v3Dc
         6e3WGEkkhZD1xfW30yLYKT3QosQ6qz1TxJBpO37vFM3mhgokcmhLHW02+cSnGy9uXMpK
         +KHUG1Shum3uxL/PC5ohLnFGqs06jVJQ10EnAZ2ZNcuTBfhYZbi3eM3DPCuzP/6sK3Gn
         9snA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678346595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XonFLReJl2P3EpwCNjlfwyUq9MTgotAm7d68RTIWWbQ=;
        b=tWk+NeNAM8VW13+IjkvRuUwXfkBjvO3wi0HWEnakcFntXlC6/Jq8wlCrJQTLynn9bm
         tkdMJmSd0dEGPk/OtTONLvIDh1bCoq23ASGEUuwHstpujAf7FHTVVwQeRX9oPeCZSmFu
         kjf/RzErIfKoAH4ePxIUGckc8ugloZWNf8JY0kabi7IfjEIz5j5EY2gyyr/BC9U+3sy8
         J/jtyPeRavtpFNCCGB7pUPpVQMFyHeMxU5O415BsokOINkAxPKzkYjAs+0fqLUcaspuE
         pEPK2MiNRZ8J3q9kLDvyiAbQjU1wE+aD7ZDxzpzyyuQn83snO16ypkLRz136XDtl1zO1
         uENw==
X-Gm-Message-State: AO0yUKX5iAYFKwtsPFR2LjEZdz+qy/c5MeWJ5UFy4rMIITxt89b4cjyl
        R4640dQkSZVp6/sX2zredDg=
X-Google-Smtp-Source: AK7set/Sqg7MNcTL8C1EaExaQK/YmIkhnxxJMcQ6BGWWn0E0Er6VOO2PaxSZCUUD4FSKeQqZwscp5Q==
X-Received: by 2002:a17:906:30d3:b0:8b1:3d04:c2da with SMTP id b19-20020a17090630d300b008b13d04c2damr22416148ejb.45.1678346594748;
        Wed, 08 Mar 2023 23:23:14 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id r25-20020a1709067fd900b008e125ee7be4sm8511172ejs.176.2023.03.08.23.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 23:23:14 -0800 (PST)
Message-ID: <03095151-3659-0b1b-8e67-a416b8eafa2b@gmail.com>
Date:   Thu, 9 Mar 2023 09:23:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        toke@redhat.com, teknoraver@meta.com,
        Tariq Toukan <tariqt@nvidia.com>
References: <cover.1678200041.git.lorenzo@kernel.org>
 <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
 <c2d13e84-2c30-d930-37a4-4e984b85a0e4@gmail.com> <ZAiuKRDqQ+1cQb2J@lore-desk>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <ZAiuKRDqQ+1cQb2J@lore-desk>
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



On 08/03/2023 17:47, Lorenzo Bianconi wrote:
>>
>>
>> On 07/03/2023 16:54, Lorenzo Bianconi wrote:
>>> Take into account LRO and GRO configuration setting device xdp_features
>>> flag. Moreover consider channel rq_wq_type enabling rx scatter-gatter
>>> support in xdp_features flag.
>>>
>>> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>    .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
>>>    .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
>>>    .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
>>>    4 files changed, 51 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> index 88460b7796e5..4276c6eb6820 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> @@ -1243,6 +1243,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
>>>    void mlx5e_rx_dim_work(struct work_struct *work);
>>>    void mlx5e_tx_dim_work(struct work_struct *work);
>>> +void mlx5e_set_xdp_feature(struct net_device *netdev);
>>>    netdev_features_t mlx5e_features_check(struct sk_buff *skb,
>>>    				       struct net_device *netdev,
>>>    				       netdev_features_t features);
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>>> index 7708acc9b2ab..79fd21ecb9cb 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>>> @@ -1985,6 +1985,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
>>>    	struct mlx5e_priv *priv = netdev_priv(netdev);
>>>    	struct mlx5_core_dev *mdev = priv->mdev;
>>>    	struct mlx5e_params new_params;
>>> +	int err;
>>>    	if (enable) {
>>>    		/* Checking the regular RQ here; mlx5e_validate_xsk_param called
>>> @@ -2005,7 +2006,14 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
>>>    	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
>>>    	mlx5e_set_rq_type(mdev, &new_params);
>>> -	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
>>> +	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	/* update XDP supported features */
>>> +	mlx5e_set_xdp_feature(netdev);
>>> +
>>> +	return 0;
>>>    }
>>>    static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index 76a9c5194a70..1b68dd2be2c5 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> @@ -4004,6 +4004,30 @@ static int mlx5e_handle_feature(struct net_device *netdev,
>>>    	return 0;
>>>    }
>>> +void mlx5e_set_xdp_feature(struct net_device *netdev)
>>> +{
>>> +	struct mlx5e_priv *priv = netdev_priv(netdev);
>>> +	bool ndo_xmit = test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
>>
>> Our driver doesn't require loading a dummy XDP program to have the
>> redirect-in ability. It's always there.
>>
>> I actually have a bug fix under internal review with Saeed that addresses
>> this.
>>
>> In addition, it cleans up the NETDEV_XDP_ACT_NDO_XMIT_SG as we do not
>> support it yet. I have a series that's adding support and will submit it
>> soon.
>>
>> Any reason you're submitting these fixes to net-next rather than net?
> 
> Hi Tariq,
> 
> I am fine to repost this series for net instead of net-next. Any downsides about
> it?

Let's repost to net.
It's a fixes series, and 6.3 is still in its RCs.
If you don't post it to net then the xdp-features in 6.3 will be broken.

> 
>> Maybe it'd be better if we integrate the patches, here's my fix (still under
>> review...):
>>
>> Author: Tariq Toukan <tariqt@nvidia.com>
>> Date:   Thu Feb 23 08:58:04 2023 +0200
>>
>>      net/mlx5e: Fix exposed xdp_features
>>
>>      Always declare NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit callback
>>      is always functional per our design, and does not require loading
>>      a dummy xdp program.
>>
>>      Although non-linear XDP buffer is supported for XDP_TX flow, do not
>>      declare NETDEV_XDP_ACT_NDO_XMIT_SG as it is yet supported for
>>      redirected-in frames.
>>
>>      Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
>>      Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 53feb0529943..9a5d3ce1fbcd 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -4741,13 +4741,6 @@ static int mlx5e_xdp_set(struct net_device *netdev,
>> struct bpf_prog *prog)
>>          if (old_prog)
>>                  bpf_prog_put(old_prog);
>>
>> -       if (reset) {
>> -               if (prog)
>> -                       xdp_features_set_redirect_target(netdev, true);
>> -               else
>> -                       xdp_features_clear_redirect_target(netdev);
>> -       }
>> -
>>          if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
>>                  goto unlock;
>>
>> @@ -5144,6 +5137,7 @@ static void mlx5e_build_nic_netdev(struct net_device
>> *netdev)
>>          netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
>>
>>          netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
>> NETDEV_XDP_ACT_REDIRECT |
>> +                              NETDEV_XDP_ACT_NDO_XMIT |
>>                                 NETDEV_XDP_ACT_XSK_ZEROCOPY |
>>                                 NETDEV_XDP_ACT_RX_SG;
> 
> I am fine to drop this my patch and rely on the one you provided but it depends
> on the eta about the described patches because otherwise real capabilities and
> xdp-features will not be aligned. Any inputs on it?
> 

My patch doesn't replace yours, as it doesn't fix the missing 
features_update according to striding RQ and HW LRO/GRO.

I think we should combine them, either take mine as-is into your series, 
or squash it into this patch. I'm fine with both.

>>
>>
>>> +	struct mlx5e_params *params = &priv->channels.params;
>>> +	xdp_features_t val;
>>> +
>>> +	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
>>> +		xdp_clear_features_flag(netdev);
>>> +		return;
>>> +	}
>>> +
>>> +	val = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
>>> +	      NETDEV_XDP_ACT_XSK_ZEROCOPY;
>>> +	if (ndo_xmit)
>>> +		val |= NETDEV_XDP_ACT_NDO_XMIT;
>>> +	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) {
>>> +		val |= NETDEV_XDP_ACT_RX_SG;
>>> +		if (ndo_xmit)
>>> +			val |= NETDEV_XDP_ACT_NDO_XMIT_SG;
>>
>> This NETDEV_XDP_ACT_NDO_XMIT_SG capability is not related to the RQ type.
>> It's still not supported at this point.
> 
> ack, I will fix it.
> 
>>
>> BTW, I have a series completing all the missing capabilities (multibuf on
>> Striding + multibuf redirect-in), should be submitted in this kernel.
> 
> cool :)
> 
> Regards,
> Lorenzo
> 
