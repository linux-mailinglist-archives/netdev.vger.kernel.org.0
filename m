Return-Path: <netdev+bounces-11128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41184731A31
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA182817C3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E4715AF4;
	Thu, 15 Jun 2023 13:38:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1498495
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:38:40 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6658B3C12
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:38:11 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-977cf86aae5so267431766b.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686836253; x=1689428253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mYo4mo9LxJ5Bb1u21M6AxJhHfaaBpi4Yfj8oS2RZGik=;
        b=gwnpCAL+9XD9YTcrhW22JHHze+0ln59G79fG0PbzPCPkUume7cpPMe9N1MpVazB8T0
         1VNcvHhrMsDbjcPaCwwELzdmSj2CInEWwxUmLYNOwRUXECqbkD21NOCA6zL0LkId1xTe
         Jmz5KNhEGQlTF8AQJe7uUwDQ4+pi/99NutlpmFMGKD3/SppKORWaGtI+PmV14ZbcTUXg
         SQ/xFGrRUrJug8frUn3FxCFoHdEvGjOv0zxfZtED6wTv76W+YYbrOe0XjczsTNc6FnX6
         BTbrSi6sWw9Hr8PLExxfqiIVT6LsvR3Q/5vN6OlV0JnK2Yv0FbMnNpMYEzZJu4bCBpMD
         RaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686836253; x=1689428253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYo4mo9LxJ5Bb1u21M6AxJhHfaaBpi4Yfj8oS2RZGik=;
        b=NaWd1waDz1hNgz2iIm8nvgDKIQIE7ecLoKXrdWiRxEnNP54sEXbbgyuZgvjqJFTM5F
         GNDnb1DROVHbVnkh9YNvfxQD9r/w4r96n3Uu5TMzjCNPBWXrO3A2RuQjBDlwvAKYbIO6
         EM6PYnJbOGgXRgbS4wfBA6jo5WFZbEeuBzdE2WuJBY2JoPz0njWrnZ5+A9r83NEk+w36
         jjLjyYHjhb5Q+ZjajXKQmx9CeHZTzXQkN9rO/RKlcbUShi/4je+T7UlK+YBhLcF8Bu2w
         zcslJcdzHS2yQg/XuOU8ppMjA4dvk/SstsF+w38S5OnFMtUhhtnZ0aufI/IbxO1wOG0W
         iB2A==
X-Gm-Message-State: AC+VfDxovQFffoyDwjZXlh6QOs6XXnqJ0zb3UhNsrmSlfv65dkTmT/LW
	TtlPwQxUgj/ZzaN7JN2TCX3AVw==
X-Google-Smtp-Source: ACHHUZ4+n13L4jhgYrrrc4ptTI3RmwMq1dwvCZV4MDbjtdu4sLMN7fnVBOOcDFGxP2/w6+shDoBlfg==
X-Received: by 2002:a17:906:6a07:b0:982:a376:1d3f with SMTP id qw7-20020a1709066a0700b00982a3761d3fmr1542823ejc.41.1686836253221;
        Thu, 15 Jun 2023 06:37:33 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id d23-20020a17090648d700b00982c84e5dadsm196414ejt.170.2023.06.15.06.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 06:37:32 -0700 (PDT)
Message-ID: <b326151c-24ed-e603-d1c7-3ebe8dbaa6c4@linaro.org>
Date: Thu, 15 Jun 2023 15:37:30 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 17/23] dt-bindings: net: qcom,ethqos: add description
 for sa8775p
Content-Language: en-US
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
 Bhupesh Sharma <bhupesh.sharma@linaro.org>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Giuseppe Cavallaro <peppe.cavallaro@st.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230615121419.175862-1-brgl@bgdev.pl>
 <20230615121419.175862-18-brgl@bgdev.pl>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230615121419.175862-18-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/06/2023 14:14, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the compatible for the MAC controller on sa8775p platforms. This MAC
> works with a single interrupt so add minItems to the interrupts property.
> The fourth clock's name is different here so change it. Enable relevant
> PHY properties. Add the relevant compatibles to the binding document for
> snps,dwmac as well.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


