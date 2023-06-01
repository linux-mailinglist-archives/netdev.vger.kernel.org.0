Return-Path: <netdev+bounces-7204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE8C71F0DD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B009281869
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CE64700F;
	Thu,  1 Jun 2023 17:34:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556C542501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:34:25 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE25F2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:34:22 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2af2d092d7aso16630911fa.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685640861; x=1688232861;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y+b+rm5/R5ibyZ6r+rF+iVWDROGMd6iETnPBcFk9ix0=;
        b=DjlDIFNQZZGoxm1uB8R37Rjp2aLRL2RDbSWtuhgWaVxwcGTOcOj6y3qv+MKdft3aGn
         NdtUdrvjh32aTOHDk1kgv5IC3amiUISeVyqGPOtEiSBH32tHleRafyshPLJbdMtffK77
         pqUq3ztqF/ZTblQjr3nCozLnKPrC97dU/uw5YEbTR3nO3g6/O2ukfhKEEG7bn44BU1pQ
         rKAd645Psbmxs0qH57GZ8d1dHPiLNZyzQgHj3T3/qMOMh5JfYms0ETSmvSIoefTdbmz+
         o01d6TxTpIf82ewAeqILFkUQn7DdWUb1mnmRH6HsPj1TletzRiko4juIJE4a3lFdPcJ7
         82+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640861; x=1688232861;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+b+rm5/R5ibyZ6r+rF+iVWDROGMd6iETnPBcFk9ix0=;
        b=b549hYjNt2SL7VgsagOUCS3DvuDZtOvA1r67Zvgxu3isTjU5OZTYbZtSYpeh/eMe7N
         sXmREk0L6T3OgR1ZjCogHeTTQD30xywPWeGjU54nvczw1I8JKUECjAyeqDOWh2mQc1Nk
         TzohalKbVhCzKA3GmjFQX5euIPkMrZVogsRj1v0r8yErk5bvbU/9m65dtFgnfVKez/kF
         DcxS3riNrC13yms6APBJA2tkpibYhvMaxDByCqq0YhDdbeA1d2jLI6S+9RIiZcy83S7J
         FrZCmIzEkXAXOlFhqEwb8B8ZMY8EX427wn1ak4O5IWo12YQCyA6SV/RYDO0MwoDhGPd6
         LJHg==
X-Gm-Message-State: AC+VfDy05IXzVhF9WADebiX+q+ZK/3HcST2ofa/OydwjRYhMp/F1TJRe
	+f/RjRfTJwdq5BgQJbQEU0LiQg==
X-Google-Smtp-Source: ACHHUZ5irQ0RkTnQ1lBHCjsd2sQ1wVrK2U3EDXl6D//XltvtFhl1/qp+G0DqX6qDFNUg5cCMBSrGgQ==
X-Received: by 2002:a2e:8ed0:0:b0:2ac:79df:cb49 with SMTP id e16-20020a2e8ed0000000b002ac79dfcb49mr97407ljl.27.1685640861002;
        Thu, 01 Jun 2023 10:34:21 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id y1-20020aa7c241000000b0050bfeb15049sm7294362edo.60.2023.06.01.10.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 10:34:20 -0700 (PDT)
Message-ID: <d74a4aea-7e8c-cde7-0293-2c3a41997e41@linaro.org>
Date: Thu, 1 Jun 2023 19:34:18 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: pse-pd: Allow -N suffix for
 ethernet-pse node names
Content-Language: en-US
To: Oleksij Rempel <o.rempel@pengutronix.de>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 netdev@vger.kernel.org
References: <20230531102113.3353065-1-o.rempel@pengutronix.de>
 <20230531102113.3353065-2-o.rempel@pengutronix.de>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230531102113.3353065-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31/05/2023 12:21, Oleksij Rempel wrote:
> Extend the pattern matching for PSE-PD controller nodes to allow -N
> suffixes. This enables the use of multiple "ethernet-pse" nodes without the
> need for a "reg" property.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


