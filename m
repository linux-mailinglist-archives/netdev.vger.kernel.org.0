Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56BA643683
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiLEVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiLEVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:08:57 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084DA24BD2;
        Mon,  5 Dec 2022 13:08:47 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id j26so6038199qki.10;
        Mon, 05 Dec 2022 13:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/GV8VNa16pKMcgfrYYM0FiCObRvy591fmJOaAa4LAE=;
        b=k6o2Mc2cwgDsunbzKQvn7qCjIp//ox8KqetOD+3/wb/3i/X/8ZNK5yWqK2oxM5Vo51
         MMv0g71MHpFz+h9El0cW4gRIIr0JdV7D1qqjqNKq6mU3y5heNGbC0yWlWHYZnFrYY2OZ
         9Lry3+zbShpIyJm/pNrnI6DgS083vjXyCLcALpfHGkpsf8l6zIBf0b/+ZH5UHwYpw9wA
         VfW2iKy8agea6HchL3AAhU51uq/E0muJ4lCxzbMSmwFUcbfCrvKC9fucGrZ1bQAyVMyK
         gBr/lUAC3asyN4kLsByGzJINTQIHGfx41joP9nNFzmlhEWLgN4I6hovC2zuvCb+rjVWW
         jSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/GV8VNa16pKMcgfrYYM0FiCObRvy591fmJOaAa4LAE=;
        b=YKGAhM8IPJZFycerRnkaRaSGpdCRGZpSrcDct06AhCtlEl9Lr8P9LA2XswEuSV4WW6
         KQcrrlk+0hppKJl7dG7PgrmdsGe8fgRzZSV5Qp0rcXKsu6VcNkfuqLz/O3uWxCiSuuCM
         QtKCMTHbCP/9ucfd70Tl2bWmHev/UkV30fSn7Yej8tqcMj6uK0AW4stAHXaGHJxBfXjZ
         1K4tykV0moR7DaHN7OVamHsxbWBinTRLxm8PgddoxCRX6iydPJS18/6qMtlL7MKZL3gc
         sbD2oX4NDx7nvGbuSlSRJwUBrQ1MlvJmo9TjUu2Ky94unmVSOM5W+kmD7u/CEtN0Izsj
         f3cw==
X-Gm-Message-State: ANoB5pmsQE6vMdP6poBIvqHqZHBXqLHKH5x+q/wwL48b7KMz1ryj71tw
        akB0wwsEi5IwZdmSI0RQIgo=
X-Google-Smtp-Source: AA0mqf6UWpQcmTwf7we9GQqWOV1BCXBfo1L7eATa41eEfVrSKaarPMVbIZGDRk7SbPe+8YMYTjEsIg==
X-Received: by 2002:ae9:f701:0:b0:6fc:9f87:6961 with SMTP id s1-20020ae9f701000000b006fc9f876961mr20909382qkg.171.1670274526019;
        Mon, 05 Dec 2022 13:08:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j6-20020a05620a288600b006fc7302cf89sm13567641qkp.28.2022.12.05.13.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 13:08:45 -0800 (PST)
Message-ID: <adbcc0f7-31ed-5b92-27ef-8f6f4981a3e2@gmail.com>
Date:   Mon, 5 Dec 2022 13:08:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: fec: properly guard irq coalesce setup
Content-Language: en-US
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Ungerer <gregungerer@westnet.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 12:46, Rasmus Villemoes wrote:
> Prior to the Fixes: commit, the initialization code went through the
> same fec_enet_set_coalesce() function as used by ethtool, and that
> function correctly checks whether the current variant has support for
> irq coalescing.
> 
> Now that the initialization code instead calls fec_enet_itr_coal_set()
> directly, that call needs to be guarded by a check for the
> FEC_QUIRK_HAS_COALESCE bit.
> 
> Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to defaults on "ip link up")
> Reported-by: Greg Ungerer <gregungerer@westnet.com.au>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>   drivers/net/ethernet/freescale/fec_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2ca2b61b451f..23e1a94b9ce4 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1220,7 +1220,8 @@ fec_restart(struct net_device *ndev)
>   		writel(0, fep->hwp + FEC_IMASK);
>   
>   	/* Init the interrupt coalescing */
> -	fec_enet_itr_coal_set(ndev);
> +	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
> +		fec_enet_itr_coal_set(ndev);

There is already a guard in fec_enet_set_coalesce() so this makes sense, 
thanks!
-- 
Florian

