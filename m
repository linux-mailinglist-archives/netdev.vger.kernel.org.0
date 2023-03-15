Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AAC6BBDE8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjCOUWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjCOUWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:22:33 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2504A1FC1;
        Wed, 15 Mar 2023 13:22:23 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id y10so17654118qtj.2;
        Wed, 15 Mar 2023 13:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678911742;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzmAID+913QMaOYV6+s6s0r2cvOwww0piYjgr2sNDOg=;
        b=VH2AlO6+Piss+JyYd7+v1v6baWJ2sAPDd6h0O5K0ufzIggGaJirAkViT23lvc2bqwK
         Xh7QSbe/NdUD2eLZakEtL2SJu1la/JBQnyDOS71y1MjR4n+0SNA8v1+8X6IjvpxW5quL
         Bd3y0O0uTXXZQ4AX6j4amSzdZCp/TGSSBuh5OKiujmhulgNw8HiyYDCkmSKEbuhgATty
         zgxUKwDMFeUW6TFWIGwygksamiKN0D/aER/uW55dKMT0LJBQtu4N1cF2+Nur4RxMLU3Q
         d0M0pw9wIouy61JS4Dm1tqK9br0pjZMszYuNOblBiGFeHEidWfY5XBl4XYBclRHFFxz3
         7lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911742;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzmAID+913QMaOYV6+s6s0r2cvOwww0piYjgr2sNDOg=;
        b=GObDJwRDsFTRrABpS/5+3GDoaxB4glrwwPzr5aJLlGQSpsRQEZ6pCuqIRlX1mhFWGE
         TvL7Ru7vQxHOkEFWGwoiB+zwFbdsjwr/wTyJQL05XHrcuq2kexlK+xSAM22CUrmlJqyW
         CpinUOyOpYYPSQu0wSh/lxfzmaEuDOZ2H2cK8QOboXVjsqu9qOkQaPUpvHWXx2P7oF/i
         pIXiO/9Bc++X8G/atMDRECP/bAB26jKNdX6rSzkHDAaKeVLpgAj8P8guNlH/h6cb1yfR
         7GkpS10C9XiSRCqsLi0qIZr2PZnaQ0gpcz09nafT2dz+5WE3PrfdBIkfznG38ka3nHOV
         Xyxg==
X-Gm-Message-State: AO0yUKX3ZQmMFtWH3Cy5nsYKvy7m7+x2n9JPhIAEkHgSO31YXUggpb2z
        JXJnONdt921dyYvlM6Tzz14=
X-Google-Smtp-Source: AK7set/ZVDuurYWBMJJ5xmYbuFl8BqSX3cOwwLOBBcvX1akJdGRrvIQUusJSBSXTorhkG/y8DxDsUw==
X-Received: by 2002:a05:622a:548:b0:3bd:6c0:9c8e with SMTP id m8-20020a05622a054800b003bd06c09c8emr2432676qtx.2.1678911742341;
        Wed, 15 Mar 2023 13:22:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t20-20020a37ea14000000b00706bc44fda8sm4434567qkj.79.2023.03.15.13.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:22:21 -0700 (PDT)
Message-ID: <27a21a67-88d7-ce21-71d0-1c016c7ff45a@gmail.com>
Date:   Wed, 15 Mar 2023 13:22:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
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

On 3/15/23 06:09, Ahmad Fatoum wrote:
> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
> with the expectation that priv has enough trailing space.
> 
> However, only realtek-smi actually allocated this chip_data space.
> Do likewise in realtek-mdio to fix out-of-bounds accesses.
> 
> Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

