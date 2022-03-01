Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAF74C868F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiCAIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiCAIea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:34:30 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD432D1CD
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 00:33:49 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 235743F19A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646123628;
        bh=UT1Wzz4wpktDA/wQ5edeBOYkNXdbIzJM75NIJS96iDU=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
         In-Reply-To:Content-Type;
        b=sh/h1Hi+4ppq/rrzJBBzGo+h8iwOrieah+AwF+Cn+smJOFrmXgrjPjKeyZS6cIYoI
         yV86CvKmw1E2joRhvZHpKWH3PP3QNVufMx+jUTQZrUDaQ4ZYTOHjoq8AygUtADymYt
         MHrCt1jeH7HcLZ06LOlsM+fM1N8Epl95n0fSvaCTiocG/zmMx0aF3VCXi90Sv1JnWW
         6SzGF5H3Jj3yRSNOguatl4BxxHZOecXyhl00AVCW86EB3/ftafkmEwg4tA13evNU7K
         Ve48ve16M9qHDJxsAoNDwL/6i/Lqhm/nusDy53eeQ73IRkttEZaG4IrgJlLSkk3zHY
         mV2QnaWNCrvjA==
Received: by mail-ej1-f71.google.com with SMTP id c23-20020a170906925700b006d6e2797863so1117535ejx.14
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 00:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=UT1Wzz4wpktDA/wQ5edeBOYkNXdbIzJM75NIJS96iDU=;
        b=vTkIPGnyqA+t3OWUaKLrj+WKTYBhVEIfz7EWkIL8mAClw+4Kmk7KMCvClnyBzKAphz
         pbw/B0+b/xNYj30bgjZiKbrPwjs1VEPSWwna7UHdqPWZZbjO688QQfnA63iau3kmdkOg
         QotTfPcZzClDWiFhii9B5EvUFjTWgPjWRHMwgNVGG5E25xNRKL9S5s9pJBI7OIG7jrIJ
         iXgJ41mc6c1yoa2c64U/6nQLJxM7/3C/PtZslD64O9G4IiA7uV056n9pKwZ35Hm96mqy
         WX660fOOK+/YAfUxAiD2Z+uNXWwqddsnMa6JFnSFC0Evn792N3vKnTN9gmYDVnJnhBdY
         zvkA==
X-Gm-Message-State: AOAM530hfuz7/pjSJOjYFkh50Cp7TdJ3j8+toVKKcsLM1bWPa97f2DN0
        sTA9w0wsU95lw0AYdkpyFuKNkVqtB+YcnrLaAqj0rZ40TuQWjCOOGVC5LCeEqv4mpOLbIge/m5V
        dTj7vlXzvMA6E9jCvSGY4AI6rtlDj7l2KrQ==
X-Received: by 2002:a50:fe14:0:b0:410:8621:6e0c with SMTP id f20-20020a50fe14000000b0041086216e0cmr22830638edt.356.1646123627829;
        Tue, 01 Mar 2022 00:33:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEPrnoA3fQNEEAjhdiffSfB+NwlBhlPUCIVWodAeFoRpldBhnYq7BoMI2/T4od9758NGQfVg==
X-Received: by 2002:a50:fe14:0:b0:410:8621:6e0c with SMTP id f20-20020a50fe14000000b0041086216e0cmr22830629edt.356.1646123627627;
        Tue, 01 Mar 2022 00:33:47 -0800 (PST)
Received: from [192.168.0.135] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a21-20020a170906275500b006d10c07fabesm5100378ejd.201.2022.03.01.00.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 00:33:47 -0800 (PST)
Message-ID: <926ccc54-6388-37be-0064-df3fd3972da2@canonical.com>
Date:   Tue, 1 Mar 2022 09:33:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net/nfc/nci: use memset avoid infoleaks
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220301081750.2053246-1-chi.minghao@zte.com.cn>
 <664af071-badf-5cc9-c065-c702b0c8a13d@canonical.com>
In-Reply-To: <664af071-badf-5cc9-c065-c702b0c8a13d@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/2022 09:20, Krzysztof Kozlowski wrote:
> On 01/03/2022 09:17, cgel.zte@gmail.com wrote:
>> From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
>>
>> Use memset to initialize structs to preventing infoleaks
>> in nci_set_config
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>

One more thing. This report seems to be hidden, not public. Reported-by
tag means someone reported something and you want to give credits for
that. Using internal tool in a hidden, secret, non-public way does not
fit open-source collaboration method.

What is more: the email is invalid. "User unknown id"

>> Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
>> ---
>>  net/nfc/nci/core.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
>> index d2537383a3e8..32be42be1152 100644
>> --- a/net/nfc/nci/core.c
>> +++ b/net/nfc/nci/core.c
>> @@ -641,6 +641,7 @@ int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, const __u8 *val)
>>  	if (!val || !len)
>>  		return 0;
>>  
>> +	memset(&param, 0x0, sizeof(param));
>>  	param.id = id;
>>  	param.len = len;
>>  	param.val = val;
> 
> The entire 'param' is overwritten in later code, so what could leak here?
> 
> Best regards,
> Krzysztof


Best regards,
Krzysztof
