Return-Path: <netdev+bounces-1510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 723CC6FE0CE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44670281505
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB06154AF;
	Wed, 10 May 2023 14:51:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328498C1B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:51:05 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3D2A276
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:51:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-965a68abfd4so1379144166b.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683730261; x=1686322261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=634QqYCO4e6YYkg9HogXcpMtMk+Nqei671dupMxD3uU=;
        b=CpQE9gcU+nOsxso1W8WnW0sBuBszcV5bm98RKhg3mQCCf8eXyc1+M76/bUNrX25MV1
         mjGgjoZTxLCRLZpAcfxGDlG09OjkVFfMol0RuQDpQ+Vp8xfepP78up43AQf0dcSclvlh
         GZUIiB7z6nN2khwM7CX99SSDulayzIfoJrg9KuwnykbzZhjxMUnu8bvlzlZLAGM5Jgv4
         AOK1Hy4hWfgUg0gl8PivfB1Ppx6naSp3dR00UIoNLHptCJVF2MrDvRMf8KPC9bq+aeiT
         pbqaw7h5G4bWYzyuVSyXhGe6yJQZ7LVucbo0VWwcOM/ftnJfg59X7pgDQvaFhQD20kuJ
         Huaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683730261; x=1686322261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=634QqYCO4e6YYkg9HogXcpMtMk+Nqei671dupMxD3uU=;
        b=FLnyv0HlD6u95IOn6kU5MlxFAZns55gkkUp9FCgsx6cAy5S2KxJPVOQTRej9RvUFw8
         IMYX0HvwSmNKvQnY1dJECiWx08ecYMjEBHPHwZhyuwh2f8Qo1I/dYC5WvjCfuL/xJYoI
         TEI3hzSr7mEpizg0ay0RSgLzlA/NMSYDqqCGOQxfxGkTcbusfelUJFN9LvNLetfXe05I
         +o4bg7udJMjyJWog0xKi7ddZEl+ecI2ibmS1kaPb0cDWc4F5W24KqPXePXvYWPARhMir
         JRgs8xjfXTfqTnDxZLsz0gCjvMDj9mGcv1ch20RH5S4B6KGs/bLBuwtT48sStOMITnlr
         ZzPw==
X-Gm-Message-State: AC+VfDyCLp8sA007upS/aJEMQ/EsvzD3D6pk5ogiwwrmmWjzBwR3BGaY
	/1xuH+7tTnIzl0vgF1gJWG258Q==
X-Google-Smtp-Source: ACHHUZ57l5b3kNlo9y2XGG6tHhsx/v2ViJ/oCrgPAj474IZCIVQl7t5hfSOajPXOPXUzUmyQERnmkA==
X-Received: by 2002:a17:907:3686:b0:94a:56ec:7f12 with SMTP id bi6-20020a170907368600b0094a56ec7f12mr16731180ejc.30.1683730261473;
        Wed, 10 May 2023 07:51:01 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c175:a0f9:6928:8c9d? ([2a02:810d:15c0:828:c175:a0f9:6928:8c9d])
        by smtp.gmail.com with ESMTPSA id l19-20020a170906939300b0094e7d196aa4sm2709662ejx.160.2023.05.10.07.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 07:51:00 -0700 (PDT)
Message-ID: <ec0a3553-2c11-301e-d838-f0bc70353b17@linaro.org>
Date: Wed, 10 May 2023 16:50:59 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 5/5] dt-bindings: net: ftgmac100: convert to yaml
 version from txt
Content-Language: en-US
To: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-6-fr0st61te@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230509143504.30382-6-fr0st61te@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/05/2023 16:35, Ivan Mikhaylov wrote:
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>

Need some commit msg.


> ---
>  .../bindings/net/faraday,ftgmac100.yaml       | 110 ++++++++++++++++++

Missing actual conversion (removal).

>  1 file changed, 110 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml b/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml
> new file mode 100644
> index 000000000000..98cd142f74bb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/faraday,ftgmac100.yaml
> @@ -0,0 +1,110 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual-license, unless you copied some chunks of old binding... but was
there old binding?

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/faraday,ftgmac100.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Faraday Technology FTGMAC100 gigabit ethernet controller
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"

Drop quotes.


> +
> +maintainers:
> +  - Po-Yu Chuang <ratbert@faraday-tech.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: faraday,ftgmac100
> +      - items:
> +          - enum:
> +              - aspeed,ast2400-mac
> +              - aspeed,ast2500-mac
> +              - aspeed,ast2600-mac
> +          - const: faraday,ftgmac100
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      In accordance with the generic clock bindings.

Drop this part. Obvious.

>  Must describe the MAC
> +      IP clock, and optionally an RMII RCLK gate for the AST2500/AST2600. The
> +      required MAC clock must be the first cell.

The cells depend on clock provider. Do you mean something else?

> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - enum:
> +          - MACCLK
> +          - RCLK

This does not allow two clocks... List all the items and add minItems: 1.


> +
> +  phy-mode:
> +    enum:
> +      - rgmii
> +      - rmii
> +
> +  phy-handle: true
> +
> +  use-ncsi:
> +    description: |

Do not need '|' unless you need to preserve formatting.

I will stop review, because it depends whether this is true conversion
or new binding.

Best regards,
Krzysztof


