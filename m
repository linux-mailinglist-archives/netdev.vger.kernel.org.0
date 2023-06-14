Return-Path: <netdev+bounces-10615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA65D72F629
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49D8028133A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28A417F4;
	Wed, 14 Jun 2023 07:24:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A643B7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:24:00 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD18212B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:23:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5189f49c315so306782a12.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686727437; x=1689319437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X48c7AoEOD3TxiGjzZ730W7QuuocGN40Ji4sYGrasgI=;
        b=AtHampU+XnfOFRa3UiWqVTavPvWwSBDwj08vushK74etxW/+TzPgltr6/zw/btuhFE
         HzLAnfpiZuJqMPGBNjXFL1l+linJmw/NYyucs8WLnrQr2cYmFkO1+3WzazC+i7blSpBk
         jkYn3pmPeNGEhPaOntF/JU2Fe75Jw6cI1XmkL1gvZ6LZKhjlFRP7d2oQXwKyuPFVaiWD
         uGdfIbDACla6yu6/RIttUUMDBNBLoF9L7naUE6zMDq1imfFT1kwowe7iCF5X+YV5neGV
         MY0dSU0/H/nJLVNelsqd6dhVZKpxTbbmZZoevFNWK0EQbl4Loe+N8K5jUi975+y3mfLl
         tIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727437; x=1689319437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X48c7AoEOD3TxiGjzZ730W7QuuocGN40Ji4sYGrasgI=;
        b=K4xS8sMtihRiAd9y0+Xhh/dxAy4jlBRBbkdiTUg+qOEm5e0sJG1K496vlVV0a1V2uM
         RQOo8eM1sByJutXWBZ1vm9BnG/FYhBZrbPXKL2e2pBYv1fhM5gbaBHh/dFNXAnE2Hwk3
         iE9kA5UGYk1iPPLkfLePOPTlhpNoG/XCOur5F5oW6D39u+KeIhIcbf8BxYKYn7jKCHUf
         VMki2048D2jeunQpmKOVmkwRggB1KTaMgIOp3PESk6GEJb3kqgkptnNNJWwJ7fhOkhQn
         RO4fVbglgNe7xh+TRc9k4aUrhBrzNWiXYiFesf6nWdE5yHIUrFwA1FxQN74SLCcMwKow
         LmhA==
X-Gm-Message-State: AC+VfDwL6PreccT3JFV33YC6n4a4Kd0xMY2FmPFMH798GHETzFk1a9HC
	EIisCgL6DP5RQAdBXfRyf4fQVg==
X-Google-Smtp-Source: ACHHUZ7HprcUbY4Np2NnM2SRFCO1cDvQEs1A8ynQEvGZx3Dh5Jm8HUXXavnivFzBkFvto59qd1FDyw==
X-Received: by 2002:a17:907:2da4:b0:981:a949:2807 with SMTP id gt36-20020a1709072da400b00981a9492807mr9406993ejc.1.1686727436730;
        Wed, 14 Jun 2023 00:23:56 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id ce14-20020a170906b24e00b00977cc3d37a2sm7598052ejb.133.2023.06.14.00.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:23:56 -0700 (PDT)
Message-ID: <30d50e3d-b501-273a-66b8-6d38d63842b4@linaro.org>
Date: Wed, 14 Jun 2023 09:23:52 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 19/26] dt-bindings: net: snps,dwmac: add compatible for
 sa8775p ethqos
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
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-20-brgl@bgdev.pl>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230612092355.87937-20-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/06/2023 11:23, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the compatible string for the MAC controller on sa8775p platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


