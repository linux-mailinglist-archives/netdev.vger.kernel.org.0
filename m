Return-Path: <netdev+bounces-2230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74077700D6D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:53:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4428F1C21338
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF97C200B6;
	Fri, 12 May 2023 16:53:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D45A32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:53:09 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A29EFA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:53:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so15700657a12.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683910386; x=1686502386;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CN6pCJcBzZ51aATWk78TJrmoYzIoOv3jWdHbtYWFl7M=;
        b=UleUVIttaU4XHJvEB1+6GxxvA45kFC6nR72DdRpYznNa2jmdFVRDxIn86/suJca+1B
         tIGjCLwyVMCyPpPive1kMoRCAfLVtNELfcRIOO2H52H0HsKTUuOpT2/Zn7KQVyBasbDD
         6sJwRb+rB3jne30p9niet/wVvcQ7G4zoTy54k//kk8SVuL+i6WmGmUjpKVQ5lLA/3FoL
         30bQtM5bi+K1Om21XFzqcrOgtUZSNAZAKLWi0TNJzxoYuFsQw1MIFGOpeu19XhHinYrm
         Elph7pG9udbsnNfrx5/c2AJDFBZpmoG5h/KihNfm+tSIWTMkjzv8D4oeso2eDVY5eV/D
         fujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683910386; x=1686502386;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CN6pCJcBzZ51aATWk78TJrmoYzIoOv3jWdHbtYWFl7M=;
        b=YapCorPamjThYMrPIoou2IC05lswldqTrm+1H9yXCca6SbwX9Q/vo1W0RkmGrXhxWU
         aBX8sWEPehh+EC7G3BcqgRNuayCtErkGneAROwSpqTO5+ckvNbGuFXBQV5ilLvxPaVti
         XXYgIq1R6brXGzLEmK//2wYKaPb7yLiE0/ALkThMytcH/7Ks1jPS/bsCLfzX4IkfRlqx
         ijJIzU9GgaNvN/AMTqcnoSmdAQ99eE3tEYqlh/EBdapDBYuRtIrR8mHp+GDsn8bMFpeD
         BynrQlPl+5PgrCw1dOU3MpIxq07BkUjk8dR0H1tAFFKDNd7eXaFRfM9eNi2rIbHm68o9
         nIxA==
X-Gm-Message-State: AC+VfDxpQZh3IrzJvsIILiY4DH00W89EhEUFwLmEx6/8hh9hkrfqhqND
	6wrEZF76sOhYtmgsi+GqQJQpuw==
X-Google-Smtp-Source: ACHHUZ5giuXLk5Ub8rO6/Ah0SRPh0XXQGplyCO3M/vAYmJSQY6vGyQZ23uiBcc2mrclTGnogm7Tq5w==
X-Received: by 2002:a17:906:4fcf:b0:94e:1764:b09b with SMTP id i15-20020a1709064fcf00b0094e1764b09bmr24949873ejw.45.1683910386031;
        Fri, 12 May 2023 09:53:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7ede:fc7b:2328:3883? ([2a02:810d:15c0:828:7ede:fc7b:2328:3883])
        by smtp.gmail.com with ESMTPSA id 13-20020a170906328d00b00969f44bbef1sm4965177ejw.89.2023.05.12.09.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 09:53:05 -0700 (PDT)
Message-ID: <3a4abc55-971f-9e8c-692a-aa9acc4dd7ea@linaro.org>
Date: Fri, 12 May 2023 18:53:04 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V2 3/5] dt-bindings: clock: qcom: Add RPMHCC for SDX75
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
 <20230512122347.1219-4-quic_tdas@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230512122347.1219-4-quic_tdas@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/05/2023 14:23, Taniya Das wrote:
> From: Imran Shaik <quic_imrashai@quicinc.com>
> 
> Add compatible string for qcom RPMHCC for SDX75 platform.
> 
> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


