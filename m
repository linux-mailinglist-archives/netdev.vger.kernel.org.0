Return-Path: <netdev+bounces-608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D431B6F8822
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17CDB2807F3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5A2C8CA;
	Fri,  5 May 2023 17:53:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EECBE73
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:53:15 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0DD20757
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:52:49 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bc1612940so4029496a12.2
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 10:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683309151; x=1685901151;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6sUv+mxYLqvu3NJwUUp7JPVxNoacj7K8gOnMggCQwI0=;
        b=M1VZtkM0ywzlajTqWZXGk82E3QZX7h/h9qN2QiTl5IB6oCnyM7vqfryA1Cy+WAtERo
         JS66N5pzJJQ0lgPBcEt+33wkO9kO24juExekk70M8ri7Za8L79eCLw/L9esxyM27SOwD
         xoUHriGv05ZG81jrceRk4HKJzBhR+9nmKWX7lD6XLBreg8XQw2N28uxVLq6oIv8M1lDe
         CoDNhfupqIaW8lO3dvoP1o7HJcU/MqYzIDqon/xoEQJoPzxTcouuFnht9fys8u1apaiY
         QC8664pXj9ZX9guj/RJbGQ5lyzu3AGhzwmX9Rt7mC9ovXdoueV2xUTK1yCxuGfiKbIKa
         /+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683309151; x=1685901151;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6sUv+mxYLqvu3NJwUUp7JPVxNoacj7K8gOnMggCQwI0=;
        b=BGa2lxqHWUfY9+f9rh+jPtfvdpK6Ll5nICKipIsYtHEerd+RLDRXsAVEwatUMSzNlV
         /2F87U8onqCFWtVWdoT8qH9obsJUgU/dC30Dg6etHseGa/7zPvBZjW5HbE5h7Kryl2vr
         rfSh+ZTD3j0cw2oTDmUduf7a9nKX90iDkHkqJmOxlpojPchy87BPwx5L8p5CQ6Ddr83T
         NHuDPopQKCVH/FBkkFvPbCTOCn8Ef2l8JyyxTDU8+lNMqkMO5zaKHweq35/UOHgXTxn7
         FhDB5ZuJGu3Zhwqxd/LMhfWSLDaweQZ2VDldurnAYcErPcKerSKltJQBN7VMeANm0Z9q
         0t6w==
X-Gm-Message-State: AC+VfDyqd0JMMjzqRERQe3+f8z/O8OFNDR/ClqXQrysWAtMQdpDORFyY
	m7oVsQ16R8ID+KPobZ9ZdPYyfQ==
X-Google-Smtp-Source: ACHHUZ5KpVgBxX/ctiq3aH7QlmcztFKjWUetQv4Px3BNI5sTnDbBf1pnLETF1U6N9rL6emZOqvn+QQ==
X-Received: by 2002:a17:907:1687:b0:958:cc8:bd55 with SMTP id hc7-20020a170907168700b009580cc8bd55mr2736877ejc.0.1683309151533;
        Fri, 05 May 2023 10:52:31 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:52e:24ce:bbc1:127d? ([2a02:810d:15c0:828:52e:24ce:bbc1:127d])
        by smtp.gmail.com with ESMTPSA id bz6-20020a1709070aa600b0095850aef138sm1202538ejc.6.2023.05.05.10.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 10:52:30 -0700 (PDT)
Message-ID: <5e470654-11c8-929f-cfd4-5ca03519bec2@linaro.org>
Date: Fri, 5 May 2023 19:52:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Content-Language: en-US
To: Samin Guo <samin.guo@starfivetech.com>, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, netdev@vger.kernel.org,
 Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>,
 Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230505090558.2355-1-samin.guo@starfivetech.com>
 <20230505090558.2355-2-samin.guo@starfivetech.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230505090558.2355-2-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/05/2023 11:05, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, the value range of pad driver
> strength is 0 to 7.
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml    | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> index 157e3bbcaf6f..29a1997a1577 100644
> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -52,6 +52,18 @@ properties:
>        for a timer.
>      type: boolean
>  
> +  motorcomm,rx-clk-driver-strength:
> +    description: drive strength of rx_clk pad.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3

No improvements after Andrew's comment.

Best regards,
Krzysztof


