Return-Path: <netdev+bounces-2228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0B5700D62
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9BE61C212B2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9AD200B6;
	Fri, 12 May 2023 16:52:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF69A32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:52:41 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3953A10D5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:52:40 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965a68abfd4so1928927966b.2
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683910358; x=1686502358;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=taY6vqOnlwfgSEUKM+GvHWsmve6rMezjk03XxW2GBtM=;
        b=s5bC9RjuY7Z/CpEJGe3WIlCKtFUKz91V1aHW9SOBhmzDGq9KZC17eIadz8N0ysfCjg
         WewAtmezjdhuCpbwrcLA08snxokQXL0rMBylLiUtRMpFQizwH12YCiNqf05FaXbSIz4M
         9qQHQgyhGhwBL/Pa0PSQC+VG1+d0KGGVTv/QFTCFVmhDjxHbm41gbix5RNKiUQWIuvsA
         WynGQIw1yO4aCRZshO5rADo0HhAeTL+Yf07+PT5tM3a0FmrQO5SQJxUBKgoW0ALW959J
         P8kvzjgaYpQXPtjPNPWSmTpIlEj7P1mKogk7+aUBfpaU7PNKSAJf9L1dt1QbPrGLvFgn
         uCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683910358; x=1686502358;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taY6vqOnlwfgSEUKM+GvHWsmve6rMezjk03XxW2GBtM=;
        b=GTsbMxh/enIj19sYUzk7dJjs8WXTjGEU4IXSdKTAA2CvQGZkvMSBFPHm9gIRUZYJvH
         5CamvFxtT1CD3rB9gVPA7vK4DLvkAhWkgTDhQagHo6zp7NEB6xfMf8VAehzr07uWfRPC
         qJu5u1HEQTGyWJWwBLq9wwVjdmmBcBpKGa5k5s+Hb3noIdZkPhyS/gCh/ZiJdlO3M7kK
         qMMfnvfbeougDuvlcHz1WUvVPB9zNWdyDiqqHt5sj8oFUyHmG12S1vu/3gPGFnTrEk4t
         tADqg17XcuA3NahtlewCwR2ImO3Zk0vMv767IES9U4/O1CMbTA5XmhtV6bI1q7JcMDJS
         YYHw==
X-Gm-Message-State: AC+VfDyfeGiNOJ3LB843VaEegqAvyOdV0GMiUrB0p6iC06s9LvMh8kr0
	kcmb8B3Eb9XK70z+lecMUA/dgQ==
X-Google-Smtp-Source: ACHHUZ59eFhWe1aXjkUV2GDKtKNfDQ9z13JZWV+UAdinGaGhOsxQrTLgqX2nVUOz8lj6XNB/0/btDw==
X-Received: by 2002:a17:907:2d0c:b0:966:5c04:2c5a with SMTP id gs12-20020a1709072d0c00b009665c042c5amr18475819ejc.69.1683910358651;
        Fri, 12 May 2023 09:52:38 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7ede:fc7b:2328:3883? ([2a02:810d:15c0:828:7ede:fc7b:2328:3883])
        by smtp.gmail.com with ESMTPSA id y18-20020a170906525200b0094f7acbafe0sm5694243ejm.177.2023.05.12.09.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 09:52:38 -0700 (PDT)
Message-ID: <e3c36382-f768-bb4d-4a32-dfac079cfd3e@linaro.org>
Date: Fri, 12 May 2023 18:52:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V2 2/5] dt-bindings: clock: qcom: Add GCC clocks for SDX75
Content-Language: en-US
To: Taniya Das <quic_tdas@quicinc.com>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Conor Dooley <conor+dt@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 Imran Shaik <quic_imrashai@quicinc.com>, linux-arm-msm@vger.kernel.org,
 linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jkona@quicinc.com,
 quic_rohiagar@quicinc.com
References: <20230512122347.1219-1-quic_tdas@quicinc.com>
 <20230512122347.1219-3-quic_tdas@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230512122347.1219-3-quic_tdas@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/05/2023 14:23, Taniya Das wrote:
> From: Imran Shaik <quic_imrashai@quicinc.com>
> 
> Add support for qcom global clock controller bindings for SDX75 platform.
> 
> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


