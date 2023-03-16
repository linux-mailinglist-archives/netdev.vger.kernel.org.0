Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69A76BC64E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 07:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCPGtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 02:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCPGto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 02:49:44 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555004E5ED;
        Wed, 15 Mar 2023 23:49:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x3so3481567edb.10;
        Wed, 15 Mar 2023 23:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678949381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NobcGFjFqRwtEdv6+swHPVneynH/FVlXOlQI5RE6hRs=;
        b=BiKPjQ7E3suXHFkCVj7KMC4WC1lsQ1DXAnEqXXgL6ae6/w7GNLN1G90DXcBYANYVe2
         OjhNN0HtOVhNUoqia5C6ml4JQKEsIMYVMXfW+vVemZbcAIk/2jEjGyI88S9OaipaN1eD
         8D+NoFr3Sbj3FvC3tqQ/XeOGYt04lMcVC2sB5+8tQ+cI9LZoQshUPuaiBEcQ5dXik2Wq
         7ffya8zzW7cfYaj+/yB+kX4x652CSm0Hie+AEkIExfNDDein0M99Qh6arZEKbqSzPsG3
         F4exh75E64oIkYf1787pzTAtrhSPrk/FjormmT9nPu+Q3gzWATc4k5BaZEs5nSIe0KIj
         u9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678949381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NobcGFjFqRwtEdv6+swHPVneynH/FVlXOlQI5RE6hRs=;
        b=7Lpx8npNSdN9L/eR5ZSUeW6uJx8CmjoV3pl4redCooSVlmhkwuRcE7KS54mqyPIRpJ
         M/CIwSikteXB3JmZdusqGAfSrpPgqdTl9Z2YmXrAz+nIIinS3cAHY+HJX8Bn9YMPxaUa
         Gg1YB/+kLgUveUCIGGEvDL8+/+LSTstcy0HFDXKbbMvmAGlRcw5XXeG48xDcuaH81suU
         9xigIfnhheVCzXhcAP1UaRVg3n/cSTAbSbmKE4gUc5PWlF8FuWX/935MPn4hNG0tKSzs
         lM3eAmoUKKdItFfnx0dzkTB6gzFhir6nDk4+woIZ5AA2WrIxj4j5O2b6QquL5vMHgcc2
         DK3Q==
X-Gm-Message-State: AO0yUKXJWnz7ait3RWUCyIiQ5TTaR2iTrP7sv/YarHLC24eNKQHRrS0S
        JFJX8WQvNHk7OOoNkztD8ss=
X-Google-Smtp-Source: AK7set/J9BodG25oa0qgrhp5hsw5qnwrJkUXfeWalep4xc33qBAinWsauY9LbMdCfVRiaC+jeMnYEQ==
X-Received: by 2002:a17:906:d79c:b0:87b:d3f3:dcf3 with SMTP id pj28-20020a170906d79c00b0087bd3f3dcf3mr9008494ejb.35.1678949381339;
        Wed, 15 Mar 2023 23:49:41 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id kq13-20020a170906abcd00b008ec43ae626csm3389712ejb.167.2023.03.15.23.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 23:49:40 -0700 (PDT)
Message-ID: <ebe10b79-34c2-4e85-2cf7-b7491266748e@gmail.com>
Date:   Thu, 16 Mar 2023 08:49:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] net: xdp: don't call notifiers during driver init
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, lorenzo@kernel.org, tariqt@nvidia.com,
        bpf@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
References: <20230316002903.492497-1-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230316002903.492497-1-kuba@kernel.org>
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



On 16/03/2023 2:29, Jakub Kicinski wrote:
> Drivers will commonly perform feature setting during init, if they use
> the xdp_set_features_flag() helper they'll likely run into an ASSERT_RTNL()
> inside call_netdevice_notifiers_info().
> 
> Don't call the notifier until the device is actually registered.
> Nothing should be tracking the device until its registered.
> 
> Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfiguration for xdp_features flag")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ast@kernel.org
> CC: daniel@iogearbox.net
> CC: hawk@kernel.org
> CC: john.fastabend@gmail.com
> CC: lorenzo@kernel.org
> CC: tariqt@nvidia.com
> CC: bpf@vger.kernel.org
> ---
>   net/core/xdp.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 87e654b7d06c..5722a1fc6e9e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
>   		return;
>   
>   	dev->xdp_features = val;
> +
> +	if (dev->reg_state < NETREG_REGISTERED)
> +		return;

I maybe need to dig deeper, but, it looks strange to still 
call_netdevice_notifiers in cases > NETREG_REGISTERED.

Isn't it problematic to call it with NETREG_UNREGISTERED ?

For comparison, netif_set_real_num_tx_queues has this ASSERT_RTNL() only 
under dev->reg_state == NETREG_REGISTERED || dev->reg_state == 
NETREG_UNREGISTERING.

>   	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
>   }
>   EXPORT_SYMBOL_GPL(xdp_set_features_flag);
