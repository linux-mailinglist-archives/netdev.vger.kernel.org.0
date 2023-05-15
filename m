Return-Path: <netdev+bounces-2590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D987028F4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D63A128129D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B40DC2C9;
	Mon, 15 May 2023 09:36:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA03C13B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:36:21 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BF726A5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:35:54 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9659f452148so2281181066b.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684143349; x=1686735349;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HSSdUyfUPyGYycaIqfuqW/+pghUKLLVTSGYMfpy13LM=;
        b=D7GbvBX6PgLbCDR/Yqdo2kXDxg5n5V1DaOw9R41jA3f2HwW8Qv1g9yHj76/W/q7ZT4
         7pvp31roCIgy6seejg9uqmy1l//Is7be6P50+9GoKYlgFLdB6fm3DaEHNSUiINYbHmEg
         vHoBo+e/pvj2G155jQwlO1vvz3CavlYZgFmDZ+5MrPN9qj1W29XUt86sdNSsGl4wKozd
         Ndx28demcmGTOz05b1Mq6xWMv0dq6mS4sXNRzgDp9LVhF78Xe8Vrge8DTZap3xlu2nAo
         H3bc1/ig/YC78MTvoXHdH+FhXhcZOw6I4vHtnUOnPrVW3r1tNnTy2cYuD60RLdb38BPh
         +8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684143349; x=1686735349;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HSSdUyfUPyGYycaIqfuqW/+pghUKLLVTSGYMfpy13LM=;
        b=G6G9QqhejLfjL7zsOpBKqle2SLdMgiHH2jBH7oXNQKebkxRLPGwM4xFtC/vtZOjS3S
         6INOONWhC5cPUcnpMBegGxDtquZ7mNHcthCmzQCwjj/QNLg4+WceQneiLWQCwGT1vlfh
         1+o5pMG+per0uawVqw98sGR1q12VADp+CDlLxTp0iFv3WbQQ7D7kuydeV+eGMhpEQhFP
         rL6INxOJ00O19S0AwrqoyPZjaloPFNPN98BuTIUSuakM+wgjalzfP4ZjO8Yyc/8Xj5lZ
         f4/hM7StYrfXQahHzZy/DLZvic5sK2AhGXlfk4KH7BzWVY35sgCVIyIgy470F1EyFIl/
         LdGg==
X-Gm-Message-State: AC+VfDxoV2r9omeTat6Tq+6jZJuBf9r4HfKsH4g+52LjdHgTO/7ULsdk
	naUjDF+kXA/SHc2l9QxbA5A7+w57nblqOS3R5uvMKw==
X-Google-Smtp-Source: ACHHUZ5guZjQyt+ewDulYxDM52KKMRKk8m+mePj3t6ZRQDTy77O/PteUoTkSWv1vLYs8FVpLToDAYA==
X-Received: by 2002:a17:907:360c:b0:961:800b:3f1e with SMTP id bk12-20020a170907360c00b00961800b3f1emr31728686ejc.73.1684143349443;
        Mon, 15 May 2023 02:35:49 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id hu7-20020a170907a08700b00969fa8a3533sm8421674ejc.165.2023.05.15.02.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 02:35:48 -0700 (PDT)
Message-ID: <dc8dfe0b-cf22-c4f9-8532-87643a6a9ceb@blackwall.org>
Date: Mon, 15 May 2023 12:35:47 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides FDB
 entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <20230515085046.4457-2-jnixdorf-oss@avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230515085046.4457-2-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/05/2023 11:50, Johannes Nixdorf wrote:
> This is a convenience setting, which allows the administrator to limit
> the default limit of FDB entries for all created bridges, instead of
> having to set it for each created bridge using the netlink property.
> 
> The setting is network namespace local, and defaults to 0, which means
> unlimited, for backwards compatibility reasons.
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> ---
>  net/bridge/br.c         | 83 +++++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_device.c  |  4 +-
>  net/bridge/br_private.h |  9 +++++
>  3 files changed, 95 insertions(+), 1 deletion(-)
> 

The bridge doesn't need private sysctls. Netlink is enough.
Nacked-by: Nikolay Aleksandrov <razor@blackwall.org>

