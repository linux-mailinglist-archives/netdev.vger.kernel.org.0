Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489926A3BED
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 09:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjB0ICd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 03:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB0ICc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 03:02:32 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC0F1027A
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 00:02:30 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so5170211wrh.9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 00:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vfziqb8YksBosxbn3K0pIcuXigp7qU5wKoiZkbxkiDg=;
        b=yOlNJenzkYYnKk8n6E3S2GLZAQIwpz++zn1jYc82ndkv0N5idZQfiS9pBgejEMkBao
         1pHu8vgq5nry5galU20LKtE7B4ySaycDfEnqYBQJawifOkV4mauFenQVS+irPhr8wkI6
         NZJy1v3JOtn5Oha6JK/KrkYeBaAslfDg80UNBwtlDEE2X06XWsWojg+75DszZVjQZlge
         wbXiySg0L1V0hPTmS/lPYTlpoLeNTq1qQLsqAw+rc7Dimz/TJ2wbNWLJ6EaTWwSHJ4zg
         LkEq3oFuZVKlVW0D+XRAOU6S4EibY2NAQ1yDHQzkd2q5ByYsPVQSCVxYSTSnM6QFacMQ
         /Jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfziqb8YksBosxbn3K0pIcuXigp7qU5wKoiZkbxkiDg=;
        b=5xDy1ku3NTKx69WoP8Q0Z029nMVjCklfuhSfVt/nDDBPUy39PzZfrAIZA8V7zrhY7E
         FF04n2UZomxPF6RkptOrFOi16ijIQTvb39/0dMhh7PZTCf1A/t2R9VlKnh0FBoRjoPPT
         r/vtGi12AnCtJRiiwqMrV02XBxxSvDoh1Rajv9txgff1RkBATV/V4M/FCTOObI9wZeAP
         8tXXYu7tFyI7s4rhM7DL8scYzwnPe9PWwqGQKPCuETEbejqWZvNrit0ff779hItUhjhz
         TZKPIGzErQ11G5ii8m4b9PrcrBt0R8QSZfBiAjAJFMNFSZ3S2fiZj6EF7BqjgVAPpR/K
         Hvyw==
X-Gm-Message-State: AO0yUKVSNHOjj+vGnzBCdF8N5oMtR0tO9D5JGl2VWrdLJdb0AqKcYYDI
        MwHZ12w/MXuqh5DnzP+4s7tTTg==
X-Google-Smtp-Source: AK7set+y7rgcS0Yor/fhOZ2XgFF/YWcH+WLOGtlxUX4URNezF1NGkg5ut3i6aNa2gFiveQNe6M8xCQ==
X-Received: by 2002:a05:6000:1b8f:b0:2cc:459b:8bc7 with SMTP id r15-20020a0560001b8f00b002cc459b8bc7mr573961wru.2.1677484949033;
        Mon, 27 Feb 2023 00:02:29 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id w15-20020adfee4f000000b002be5bdbe40csm6312729wro.27.2023.02.27.00.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 00:02:28 -0800 (PST)
Message-ID: <35ddd789-4dd9-3b87-3128-268905ec9a13@linaro.org>
Date:   Mon, 27 Feb 2023 09:02:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] nfc: fdp: add null check of devm_kmalloc_array in
 fdp_nci_i2c_read_device_properties
Content-Language: en-US
To:     Kang Chen <void0red@gmail.com>, simon.horman@corigine.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <Y/t729AIYjxuP6X6@corigine.com>
 <20230227014144.1466102-1-void0red@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230227014144.1466102-1-void0red@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2023 02:41, Kang Chen wrote:
> devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
> out-of-bounds write in device_property_read_u8_array later.
> 
> Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
> 
No blank lines between tags.

> Signed-off-by: Kang Chen <void0red@gmail.com>
> ---
> v2 -> v1: add debug prompt and Fixes tag
> 
>  drivers/nfc/fdp/i2c.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
> index 2d53e0f88..d3272a54b 100644
> --- a/drivers/nfc/fdp/i2c.c
> +++ b/drivers/nfc/fdp/i2c.c
> @@ -247,6 +247,11 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
>  					   len, sizeof(**fw_vsc_cfg),
>  					   GFP_KERNEL);
>  
> +		if (!*fw_vsc_cfg) {
> +			dev_dbg(dev, "Not enough memory\n");

No prints for memory allocation errors. Core prints it. Just go to
err_kmalloc.

> +			goto out;
> +		}
> +
>  		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
>  						  *fw_vsc_cfg, len);
>  
> @@ -259,7 +264,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
>  		dev_dbg(dev, "FW vendor specific commands not present\n");
>  		*fw_vsc_cfg = NULL;
>  	}
> -

Why? Line break seems nice here.

> +out:
>  	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
>  		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
>  }

Best regards,
Krzysztof

