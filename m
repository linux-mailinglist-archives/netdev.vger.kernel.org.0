Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981767374A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjASLqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjASLpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:45:55 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E6222F1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:45:50 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so1058681wmc.1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EegNtTy/sMvWBoyNWhH9yCq0I9Ve3LXWODIPFxTqqBU=;
        b=zclGPs8dfnB2v94HoRUfyCsXQnZE9vaqOARUnsItTYOj/BZ8EW/trKTeUrvR1DCYHJ
         VzmyzZLQ+trGjlmZLVL2ooBYGvFTtps/DYb3Lq56srB+EZSPMcJLaHxAaJUbdhWoZDV5
         aUvgzz5HEgMRxhNr45BF1iWmY5aIc3P5ibh5lKoO6QxPq02ERq4LCnCXJrRCi3AU515f
         8Y9GQQOeBLdV4o0v/9lKzDfBA8klXxifAqJKn+rMdzgq3tkqFVVsOe67qfmPjNtupZog
         i/s6VzEGYu+m/EQYJp8jmxQdgVCm3L2ubdG8NIWjrMv0kgoFUCHHHvBIi3peraRAJbK6
         CovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EegNtTy/sMvWBoyNWhH9yCq0I9Ve3LXWODIPFxTqqBU=;
        b=1RWAIOBzijIeLpEaWogvHXEz2UPE3srpWmScuFzqRUAjzUBi0A3PKuXsXVAOFkJQvM
         8k6qmu3JHDI+LQjNLc+zTuwhioyjq/PFr7hClOZ4Kz8Q40tqB4yiXrrmXVmDqkSTHtmA
         5IGkNePRc9NTV89cpdDWmXW0/2/sAsdj3YoST8UzN+nWcHgf1degnAHTL0xAL0WfVu6w
         olbVRg7kXR27cBStaV3JrdCmp0xzUZlRdOaxnM2G11NjaHBnq2i90DwuEjGlk0CStRBj
         l1Mgn2K/xe56yzfSvBNo7xOr+8fjgsXAfwS+l5GgGkWyfdnRf0oD5QnTNgEK5A9bV3la
         URXw==
X-Gm-Message-State: AFqh2krdO6N2fcl4E5rkJa2GTgiYT7HWQ+tnfBtY/A1Iog5o+X/w3cOm
        f6Zyxqku+eb9Jv1PD5ivOyn5Zg==
X-Google-Smtp-Source: AMrXdXvvILwOluVAOsH2m1VZJBTVlAxx87YaERZAYpsns382Rz32yl41uxvU8muTuIj0ImWPTBVf/Q==
X-Received: by 2002:a05:600c:1ca0:b0:3db:1ded:1769 with SMTP id k32-20020a05600c1ca000b003db1ded1769mr2214997wms.10.1674128749227;
        Thu, 19 Jan 2023 03:45:49 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id r6-20020a1c2b06000000b003a6125562e1sm4489912wmr.46.2023.01.19.03.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 03:45:48 -0800 (PST)
Message-ID: <77e5fbd2-636c-70a9-f4bf-3df631413a6d@linaro.org>
Date:   Thu, 19 Jan 2023 12:45:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v1 2/4] dt-bindings: bluetooth: marvell: add max-speed
 property
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
References: <20230118122817.42466-1-francesco@dolcini.it>
 <20230118122817.42466-3-francesco@dolcini.it>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118122817.42466-3-francesco@dolcini.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2023 13:28, Francesco Dolcini wrote:
> From: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> 
> The 88W8997 bluetooth module supports setting the max-speed property.
> 
> Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  .../bindings/net/marvell-bluetooth.yaml          | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
> index 83b64ed730f5..2fccea30c58d 100644
> --- a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
> @@ -19,9 +19,25 @@ properties:
>        - mrvl,88w8897
>        - mrvl,88w8997
>  
> +  max-speed:
> +    description: see Documentation/devicetree/bindings/serial/serial.yaml
> +
>  required:
>    - compatible
>  
> +allOf:
> +  - if:
> +    properties:

Wrong indentation, missing two spaces.

Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

Best regards,
Krzysztof

