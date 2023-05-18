Return-Path: <netdev+bounces-3651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7603D7082EF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331812817D9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6827611C95;
	Thu, 18 May 2023 13:39:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566AB23C7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:39:56 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C031BF
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:39:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9659c5b14d8so318692266b.3
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684417192; x=1687009192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TjZBlEcYTCCpYd0EWrlM/xAExh6zuB4ZIDwlVPxXTM=;
        b=UtoOLaPCtVZiaeUG2eAR+BoX6XervPJ44kNitEkB2i8nE19OiPwe4WPG71xS9pCu1x
         sArEfo/YPzCZZXlyjAVWSv9fIlagSo4a8k6kNho74FfM9XXGpzGQEcgLCu8w8ZMnnb4e
         fnFrD1VfE8ksxCsbIbxMofGopGZ0wBoauS5ABMJnQjdKof/lo+ROYTs/DLGV56IsRO1k
         SzkjlYnDFU0m9lpu1vDEBGXnDQf/5Gz9LoMDv7lVcUWFEUg/rrJhDYvdBp6b+i1XoRr6
         /gKp4CLyot03bsSfuT3b8edrPbizU3BXXnxcR7JLjO9S17y4Z7N1hIEuuVkVcw7HnA36
         guUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684417192; x=1687009192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TjZBlEcYTCCpYd0EWrlM/xAExh6zuB4ZIDwlVPxXTM=;
        b=g5GWgslgzQlguq5NjHg9Y5QKdCRBhj3tDwPk7fNus9QqVy2fIj/wYT629EpPE3UGQK
         Z7KaYZekZVYTX9aK6hv4PYBOpVQWxX+5nIOp9ii23axpt7BcI0A8ewwBlR+dlhLJsQew
         Q15Lq+lhb4DO6lvBDTqBybHZ+j4DQnLDwgwtr8OcSDpPe3bmhJWH3i94TqJmvX+Y7F6Q
         jt5Ynp9RPUOXlngcAct5mMOTbkF++fmo0BMBOTLA/tubXnmpvVSlwGkKa5s0rrd/w+5V
         lpAaoch5MrrkUUMiiEG7gjU8U0wZsyaMPLiNa+QmQhA1Y3l217ezoU6oteCBQbUnryJW
         t4qA==
X-Gm-Message-State: AC+VfDwFms2yAw3WqmvWXgFOCdUI1VMcVS5kV8NKKBwngxQtUjkG841X
	mHy2VrOUgMQMt9TJ4IVCeQUDoQ==
X-Google-Smtp-Source: ACHHUZ7BmIRiwtmUUF+QH7l8KYeBPlkWIy0PM9v8f7UFbcRNmiiSYH5CXMZJR3OovEEGm8cP3klyJQ==
X-Received: by 2002:a17:906:7303:b0:965:6d21:48bc with SMTP id di3-20020a170906730300b009656d2148bcmr42875928ejc.75.1684417192268;
        Thu, 18 May 2023 06:39:52 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7e24:6d1b:6bf:4249? ([2a02:810d:15c0:828:7e24:6d1b:6bf:4249])
        by smtp.gmail.com with ESMTPSA id i24-20020a1709063c5800b0096f0c21903bsm1003848ejg.31.2023.05.18.06.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 06:39:51 -0700 (PDT)
Message-ID: <b93a1717-acde-0df3-ab8d-7a3e33fdb1b3@linaro.org>
Date: Thu, 18 May 2023 15:39:50 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 2/3] MAINTAINERS: Update the entry for pinctrl
 maintainers
Content-Language: en-US
To: Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
 andersson@kernel.org, konrad.dybcio@linaro.org, linus.walleij@linaro.org,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 richardcochran@gmail.com, manivannan.sadhasivam@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
References: <1684413670-12901-1-git-send-email-quic_rohiagar@quicinc.com>
 <1684413670-12901-3-git-send-email-quic_rohiagar@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1684413670-12901-3-git-send-email-quic_rohiagar@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18/05/2023 14:41, Rohit Agarwal wrote:
> Update the entry for pinctrl bindings maintainer as the
> current one checks only in the .txt files.
> 
> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


