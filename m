Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1778763B2BA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiK1UE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiK1UE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:04:28 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527AFBF4A;
        Mon, 28 Nov 2022 12:04:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 130so11563434pfu.8;
        Mon, 28 Nov 2022 12:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nq2obDql/SvoqdGDGhq2FSglDN+k+dj8tWzgIrUSRGQ=;
        b=PvHd88p2dkeNSPDNwv2LNFENr8gU5q9YJnjR/ZadgGPvSVk3tEhnn0RzxNaU0xUslI
         FOKbEZ0xIF46XOj4JzS6+YAeG5Ve89E6kD032+dNpmvT/RdOwodT7rsWL2FclK5mK0FR
         vcrWO5TQ8H4ds8g/pzjuLzGX7RBg9Bdj/hcLM9pdmSnl6kwW2WzpWBXnEFnmJlTkV/On
         GSTeFVyBq65IqqF2F4F8EFVhlqLqwPIzdE16jD/XaHdFxdRin8VlDeOLQTQs324uecE2
         6DnZ/d4we8clbQcMwsnHjhdp4KxjZUcr0Y9H6BOcH5Y9DXp4FDMGG2zIi2wInrF10kVJ
         42cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nq2obDql/SvoqdGDGhq2FSglDN+k+dj8tWzgIrUSRGQ=;
        b=cVwpV9UjSGpAvKoeKcCxuuE6lZyshecLJHMfNxYktr+LfNOjds8eD3q+JEjrq/U7Rg
         dgv61F7Vlh8kk5TwcIC9If41GcD68fN7C162hADjFKH5f03gKTpJETYfH2rOvDQKfHvA
         Q8uxRd1i7udAQzCzC/PIs9a+zgRoMB0h7pHTmUWWtFzVIOVqkPsWGUytbxnoF9S+Kp4/
         GG6innYVm/kdGeHkCVVvfpqQEY3+M1duKb7rYlOAM3oOlFME7TkUrC1T4myHJgK4owVf
         0h0zmZ8ZYtioI6bVkySh0//KD5HKqpR1CiOTraGddeyUB2+6LKbzz1si3BJ+ufr7b1CY
         hmoQ==
X-Gm-Message-State: ANoB5pmDkimpSQr2c3VIIEBabqbAzJkd/H8TTd6tQ7bWiSyJrNhppwUl
        5VK1Cn1jnjdy994WxDcQeXa7LrmIzq4=
X-Google-Smtp-Source: AA0mqf47DIQHjZ7ptCb74TWFe8jUseUyRUs5/iybM/ApKWJ151EahpRGq1HvLkuxuNxFJIrMenod6w==
X-Received: by 2002:a63:e411:0:b0:45f:b2a7:2659 with SMTP id a17-20020a63e411000000b0045fb2a72659mr29450315pgi.132.1669665867643;
        Mon, 28 Nov 2022 12:04:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oj2-20020a17090b4d8200b001fde655225fsm67357pjb.2.2022.11.28.12.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:04:27 -0800 (PST)
Message-ID: <9619489a-1325-4124-d2c8-3dddab1fc625@gmail.com>
Date:   Mon, 28 Nov 2022 12:04:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [net PATCH] dsa: lan9303: Correct stat name
Content-Language: en-US
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221128193559.6572-1-jerry.ray@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221128193559.6572-1-jerry.ray@microchip.com>
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

On 11/28/22 11:35, Jerry Ray wrote:
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")

The Fixes: tag is supposed to come above your Signed-off-by, I don't 
know if the maintainers will fix that up manually or not, but in any case:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> 
> This patch changes the reported ethtool statistics for the lan9303
> family of parts covered by this driver.
> 
> The TxUnderRun statistic label is renamed to RxShort to accurately
> reflect what stat the device is reporting.  I did not reorder the
> statistics as that might cause problems with existing user code that
> are expecting the stats at a certain offset.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>   drivers/net/dsa/lan9303-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 438e46af03e9..80f07bd20593 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -961,7 +961,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
>   	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
>   	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
>   	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
> -	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
> +	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
>   	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
>   	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
>   	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },

-- 
Florian

