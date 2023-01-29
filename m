Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488D667FE28
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjA2K0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2K0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:26:53 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEDA20047;
        Sun, 29 Jan 2023 02:26:50 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id m2so23892974ejb.8;
        Sun, 29 Jan 2023 02:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovxUQ/V5TcqN7BqebdwkQNb4pbvMOfkJ9D3O8GSI0hQ=;
        b=agFF7uN71aQ+hCMyIfo2ZUbt96fqep8Jxj58lW1laQM67Mea5FEUPCCIM0jJP+g2ro
         YJojag30Kbf2u6yUD0FfcgP/uXDlbMkVVwqbRxvnIwCweGVsCmK37Eepgc+Kc98qHqx2
         uoqtCFqqcX/CsHroAohNXVL/vRQWV8yf0rsq7/7ReTjwOc2kIjGNQKLYSneCCCFXWQX5
         qrPOidUqBYwhRZ3tis0WGXvAUjTQfx5CNDFqJI5RolzDNGIefazn4oxrgs4cpMONZoXO
         SlGygsUTXMHox1P8IcpkvrKAWX1cwQKdphlJ9T83cH/noCEIcb6BqcF48oH8BeoeerJB
         m2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovxUQ/V5TcqN7BqebdwkQNb4pbvMOfkJ9D3O8GSI0hQ=;
        b=rhPnSLyWEuaTbrhxnSfJ4YuMRaDFOcXknHhxt/SIAdCoOTytv1+JfvHR6PGxWgceVV
         AzPfQA0Z5rpH5688xLbTEnpOlDXXZDR7s++LfP2Is/G2GD3JwZosFq0dqFdKK79sK6tq
         QGDkoULSjEUkZdB72RMzjJPkA+YVUjW3KLcnTV9mQIz7lqV4EZxla1Hsiu0fVNwvOz/j
         lcJ29R1W0dGN2Fw63OdNXM66GP2FsfK8MLy2H2OxY8N7IlZqiAca0cjkrB2g93fTAuA+
         bqutrvHcK9h2wcgpeUa+NLBzeinRviTz1JjnqIycpeWuT60RxsOtzLWVAOxngeqtLutM
         JhYA==
X-Gm-Message-State: AO0yUKUh81GrpNVHXGCkH3XLZxNb0CyAlaEvw2P5iCZa3cZdEdXgsZQ/
        7ISD6py1J3FVkpNXamtFTOoIXIYpMso=
X-Google-Smtp-Source: AMrXdXvbwS/S5KZGamBzCgPOBYm2o/4/jSpanUXMp21D45Lfe6P+AqaIcV6NNT4MROLNs9cvaMSGvQ==
X-Received: by 2002:a05:6402:4447:b0:497:c96b:4dea with SMTP id o7-20020a056402444700b00497c96b4deamr100372527edb.5.1674987998398;
        Sun, 29 Jan 2023 02:26:38 -0800 (PST)
Received: from ?IPV6:2a01:c23:c5b5:3100:da7:b18e:20b4:eee8? (dynamic-2a01-0c23-c5b5-3100-0da7-b18e-20b4-eee8.c23.pool.telefonica.de. [2a01:c23:c5b5:3100:da7:b18e:20b4:eee8])
        by smtp.googlemail.com with ESMTPSA id v15-20020a50954f000000b004a227e254dbsm2015167eda.80.2023.01.29.02.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:26:38 -0800 (PST)
Message-ID: <76e0aeea-2c15-528e-da21-4ad1f9281a13@gmail.com>
Date:   Sun, 29 Jan 2023 11:26:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Chris Healy <cphealy@gmail.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
References: <20230129022615.379711-1-cphealy@gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/1] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
In-Reply-To: <20230129022615.379711-1-cphealy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2023 03:26, Chris Healy wrote:
> From: Chris Healy <healych@amazon.com>
> 
Hi Chris,

> The Meson G12A Internal PHY does not support standard IEEE MMD extended
> register access, therefore add generic dummy stubs to fail the read and
> write MMD calls. This is necessary to prevent the core PHY code from
> erroneously believing that EEE is supported by this PHY even though this
> PHY does not support EEE, as MMD register access returns all FFFFs.
> 
> Signed-off-by: Chris Healy <healych@amazon.com>
> ---
>  drivers/net/phy/meson-gxl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index c49062ad72c6..5e41658b1e2f 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
>  		.handle_interrupt = meson_gxl_handle_interrupt,
>  		.suspend        = genphy_suspend,
>  		.resume         = genphy_resume,
> +		.read_mmd	= genphy_read_mmd_unsupported,
> +		.write_mmd	= genphy_write_mmd_unsupported,
>  	},
>  };
>  

thanks for catching this. The same issue we may have for the GXL-internal PHY.
Did you check this?

One result of the issue is the invalid ethtool --show-eee output given below.
Therefore the patch should go to stable, please annotate it as [PATCH net].

Fixes tag should be:
5c3407abb338 ("net: phy: meson-gxl: add g12a support")


EEE settings for eth0:
        EEE status: enabled - active
        Tx LPI: 1000000 (us)
        Supported EEE link modes:  100baseT/Full
                                   1000baseT/Full
                                   10000baseT/Full
                                   1000baseKX/Full
                                   10000baseKX4/Full
                                   10000baseKR/Full
        Advertised EEE link modes:  100baseT/Full
                                    1000baseT/Full
                                    10000baseT/Full
                                    1000baseKX/Full
                                    10000baseKX4/Full
                                    10000baseKR/Full
        Link partner advertised EEE link modes:  100baseT/Full
                                                 1000baseT/Full
                                                 10000baseT/Full
                                                 1000baseKX/Full
                                                 10000baseKX4/Full
                                                 10000baseKR/Full

