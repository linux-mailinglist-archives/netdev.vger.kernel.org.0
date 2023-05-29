Return-Path: <netdev+bounces-6085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EAF714C70
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BEB41C20A3F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDD68BEE;
	Mon, 29 May 2023 14:49:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D544479DE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:49:40 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2E3D8
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:49:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5147f7d045bso4496181a12.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685371777; x=1687963777;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GcrQMrKy+OprIuWHewbOIu72Ifyis4UMZQEl5zsj5eY=;
        b=5WKAVKkEka7F0V0UH/QnKyjgdHe+0JlZ0H/UYvuVK0qFeJdBKuUTGb7Ccq3NilLS1S
         TLrrUB/INdpL2M8vqh60VCxX1sHnDt2DHwOgVT7tbRB0l9UGhcELh2EFolhT5vfQTzw6
         nJoWcyC0TayAZCw1zX5V0ojydpm1ay5LFdludzqFNmOqKlAXg0t7WqmL7rg7t3HXKTG8
         Ypzx+MAqYQNJpxwl0l3oYtFp6aKR/KYTWkkDEVywSyM3UKE+h+fZWTd6QPJv4C0s4k0y
         oRLru+0fOFmYXUAX1BCuYBr59dsQTa3pzdT8WPotzHaURpElQoOuSXC2wB50IxO3KgVe
         AmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371777; x=1687963777;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GcrQMrKy+OprIuWHewbOIu72Ifyis4UMZQEl5zsj5eY=;
        b=ViPqthKyvKZH7k4qcm8ydZjkWi5G7fp+y2JhqsXaKw6j/qmtIJCqiMhsJiXiaSXOTv
         T809dhCfjbZ5MU234uNeWcsgYCuwwSMPCyueHz6eji5DeykU67owgNUqcR2Xgz+egLjI
         7bVRwvF+ZLKr2mS+L3F1aaenSqNh6Bp/EZSgIx4LIrObtvydBtnpDxk+C7tWmWv1EsMm
         4hO3cC2W/k15sgbNn7UontMpxtLK0bt/vEiBybaXF+rUzl46LQQjrN8CfG7VsF+YVcXt
         ph+2AuanD/q10bDnsxXMG+gAQIRv+dVkfHTZ87fpU5q35RcIx6DbkmwrnP8o0iPk0/gA
         k2XQ==
X-Gm-Message-State: AC+VfDx7tP+T2PXtmlh0Hkx1jZhHX4ZcJ9iDXS+ikg3+x7NzbWtU+O4V
	+atIgYPxxA31fVleLFIZGzdejA==
X-Google-Smtp-Source: ACHHUZ4CTx+wsIkMqU8r9brgNPXFOT4qvFlxNMOVfZ0JUFhyry3TT6MpnRC6crtec+uJwZDGjjJ3QA==
X-Received: by 2002:a05:6402:54e:b0:514:80ba:4be8 with SMTP id i14-20020a056402054e00b0051480ba4be8mr7877065edx.31.1685371777386;
        Mon, 29 May 2023 07:49:37 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id f14-20020a056402004e00b0050c0b9d31a7sm3182608edu.22.2023.05.29.07.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:49:36 -0700 (PDT)
Message-ID: <923b2fdc-6313-67d7-5577-720da309eccf@blackwall.org>
Date: Mon, 29 May 2023 17:49:35 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 6/8] mlxsw: spectrum_flower: Do not force
 matching on iif
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
 leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, roopa@nvidia.com, simon.horman@corigine.com
References: <20230529114835.372140-1-idosch@nvidia.com>
 <20230529114835.372140-7-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-7-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Currently, mlxsw only supports the 'ingress_ifindex' field in the
> 'FLOW_DISSECTOR_KEY_META' key, but subsequent patches are going to add
> support for the 'l2_miss' field as well. It is valid to only match on
> 'l2_miss' without 'ingress_ifindex', so do not force matching on it.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * New patch.
> 
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> index 2b0bae847eb9..9c62c12e410b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> @@ -290,6 +290,9 @@ mlxsw_sp_flower_parse_meta_iif(struct mlxsw_sp_acl_rule_info *rulei,
>  	struct mlxsw_sp_port *mlxsw_sp_port;
>  	struct net_device *ingress_dev;
>  
> +	if (!match->mask->ingress_ifindex)
> +		return 0;
> +
>  	if (match->mask->ingress_ifindex != 0xFFFFFFFF) {
>  		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
>  		return -EINVAL;


Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


