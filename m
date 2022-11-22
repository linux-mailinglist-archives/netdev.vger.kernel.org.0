Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11B8633B72
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiKVLee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKVLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:34:09 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D47A528AB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:28:11 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a15so17590131ljb.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/2KboP7aDBe1NYViL1rOGOSS6zsKqMYiIoKfwCQQMI=;
        b=Ov0oib1k0t+e0P2SjXf8SFwdPHnACc12Z7xhLVbLKFLWGS6fL84ftsb360QmyL2t7r
         ZhgtI0TtjU+xg8ti0yLYMagM5arx8xDoh1cGIZxhCuAd7ghzwCm3wIbLISuXb1SbBQcc
         ChGFJFoeMvKuttgRkFV3RpVOAjFLvc5nJSI9UN1Y/dLN8gsvjaX60T/neFN8TFODFrwd
         /axyZ973o8yoJQb0rT8RFfHVDJca0SGX1E+Ksu9iGzeDVoq4+ovUvb7Xl4pSaYYO1mlu
         rWxdj6JRmlXxLBUDipy7XVKp77KRRA4A/ZxKe6XmDQDc4kk6zGj9lzR6xm5ifzWlB/3F
         51kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/2KboP7aDBe1NYViL1rOGOSS6zsKqMYiIoKfwCQQMI=;
        b=H6JMc3vlhEV8scAg5Y9xIMpjiP0JL+TV2V6rAgLu8MEXyu0hg6hFEwe+7CGirrIbBx
         IHtbxitwKWeo5+0HXOViDsO6QYq83zThifof70rHm6gynQWZvi6LTBHnYA09R92rfR/X
         5EuvfBy79bPxI5iWVqY65wpHmSIy0GRn6vjP01EuRoUjliirBFk/Ac7EoolTbtKqAoO/
         N5DTCXKQmPBHOd2FakTaAndvX4PkqfqIERFZiFHeyN9e6DdAbK6LkKm6h9zi7D1kI0BJ
         cFBAvdNPzJ+2KiAv/mz43FXKHyHkcgaHSmEguMP3Ljoe6LurKpEhZiLvkFo8W3fgeUB4
         sHAg==
X-Gm-Message-State: ANoB5pltd591c0JRmevhIY3TW6tyVfYkrausGzqGvNyAjIkYrnfINFTw
        ZGhicbrSTzOb3CzWXM/iEcZF1Q==
X-Google-Smtp-Source: AA0mqf4A0miTCOCsyCp2t2s3vA+Q5w7x++fFSlnVreMOjo+8Lbol4ErFhuD0e8A7sPn4m43VRfsWmQ==
X-Received: by 2002:a05:651c:241:b0:26d:e38f:7e21 with SMTP id x1-20020a05651c024100b0026de38f7e21mr6990303ljn.273.1669116489716;
        Tue, 22 Nov 2022 03:28:09 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id t1-20020a056512208100b004b4e4671212sm75843lfr.232.2022.11.22.03.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 03:28:08 -0800 (PST)
Message-ID: <c47b0ab1-df50-36dd-5a60-8cdc4f632fb6@linaro.org>
Date:   Tue, 22 Nov 2022 12:28:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2 2/3] nfc: st-nci: fix memory leaks in
 EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        sameo@linux.intel.com, theflamefire89@gmail.com,
        duoming@zju.edu.cn, Denis Efremov <denis.e.efremov@oracle.com>
References: <20221122004246.4186422-1-mfaltesek@google.com>
 <20221122004246.4186422-3-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221122004246.4186422-3-mfaltesek@google.com>
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

On 22/11/2022 01:42, Martin Faltesek wrote:
> Error path does not free previously allocated memory. Add devm_kfree() to
> the failure path.
> 
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Reviewed-by: Guenter Roeck <groeck@google.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

