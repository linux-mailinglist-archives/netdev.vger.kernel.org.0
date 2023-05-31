Return-Path: <netdev+bounces-6891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C79718948
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCC37281571
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B2B19BBB;
	Wed, 31 May 2023 18:20:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77571950E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:20:59 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265391A7
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:20:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9707313e32eso1121837866b.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685557255; x=1688149255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i1T0GTPGXW58WMv7iRFoetMGLQWxPwUhy+uBYYQwBrQ=;
        b=RUljuDGZQ+xc1tqWrfne2m4p6nekeCHFYliuni+8zdX2FUrk/lLA9AhUPTZSzBfnAt
         ehNGzmpYe1Kd5mM516HyvfpCvJzHMlV/vAp7pLJ4lGa1vy0Qj59DWYibYcLDyr/BBKVY
         Vm69064WKNMp0kaEtyyJHBmO/zTEhogaatH5dMvvSdTxpjsAhq2EKgZubpGuV7dZm4VF
         C7WR2PqMa9HEGJdla6EQd0+1Kx08nghkMMd83IVBYX6DTgntApqFJDCIyXhPUO8Per3X
         ZuJ6V42lrfYiSDK2QqJazjaezl/O4iH8QV3QZblcA168YT39Owxbsope9rBQLPqraKyr
         mkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685557255; x=1688149255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i1T0GTPGXW58WMv7iRFoetMGLQWxPwUhy+uBYYQwBrQ=;
        b=C8cEzfMfgPFH7356aGvwXilITO58EayEtBGzB4BxFvK2JjeuPZn0cRifk9eFR5swyA
         tzBQS6C3U4rJ2BM9zgxK9Qn/Bxi9A1a2Z8N79KTQ6lZQxqkEbbEnuss072YMXbd6nTTt
         DCyqjzsMM1mvXBkeqk2vtzDFbS59saPvDGAiAWAQI+xaX7V+M/32YgOpM3/Rt92FcAkN
         6YfTIwppWy7dWj7oujsUuQYmnJkStoO1pvqY4OfFjy75jWpaOstedZIO1Gp5+0ZB7Hik
         bM8OLtdwWdMQTNAPOqCWjhPQSDP5wA69uZDdUVjDVhkrApvl74kaerKDSZBv8C6eLphJ
         AdiQ==
X-Gm-Message-State: AC+VfDxOfGye1UB5E9WJdxN3kXFq/dqn7cdee48yPPDKt5wlWywzKdcS
	L1fSPEMUkec0FO9L93feOjsGgw==
X-Google-Smtp-Source: ACHHUZ6j2/tD4LCUjTT2RVx/mXxK7yKQZJ1QwN4PQ3FTEquaIlsa3kjWbZDdeZbOsRdvp9vBW/lKXQ==
X-Received: by 2002:a17:906:6a19:b0:974:1d8b:ca5f with SMTP id qw25-20020a1709066a1900b009741d8bca5fmr5717416ejc.9.1685557255491;
        Wed, 31 May 2023 11:20:55 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id v15-20020a170906338f00b009663cf5dc3bsm9320865eja.53.2023.05.31.11.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 11:20:55 -0700 (PDT)
Message-ID: <7b08af5b-650c-677f-54ad-e2511b169489@linaro.org>
Date: Wed, 31 May 2023 20:20:53 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth
Content-Language: en-US
To: Tim Jiang <quic_tjiang@quicinc.com>, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, quic_bgodavar@quicinc.com,
 quic_hemantg@quicinc.com
References: <20230530082922.2208-1-quic_tjiang@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230530082922.2208-1-quic_tjiang@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/05/2023 10:29, Tim Jiang wrote:
> Add bindings for the QCA2066 chipset.

Do not send bindings separate from their user. This is one patchset
consisting of multiple patches:
1. Bindings,
2. Users of bindings: drivers or DTS


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


