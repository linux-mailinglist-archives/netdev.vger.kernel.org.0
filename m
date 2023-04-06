Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F388A6DA0AD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjDFTHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDFTHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:07:51 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4573B11D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 12:07:50 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-502739add9dso1562617a12.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 12:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680808069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vUINqOYszvGwT0XKdDs8Gu9wUN5D6gThM9IEXkJj2w=;
        b=j6pFVDBS2MI/Ihhuw3fRPk/bgetdTJnUSrfSjSuWPWvnCXZ5uVpE0fvtFH1oXeTgC6
         99ux2icL3Obo4pvFwyTd+/J6EKX+B/17rRLMhSm/g8S7lJXXrW8Ml5glYE1m0fM/cBzw
         vswDUO1N5t5W2NiKCv3zjCbH+lJActf3RkEEaZDLBEkfXfy5HcquovIQ7NJfDq3NmFAM
         NoMIY0wle6/pxEbiAS2tjkVQsF7SypnUlz/uIKd13jeY2BR8GbpdFOwoMxzGNK552VXc
         NN+s0OTeVACT7FXt2ujbb4dJQyuXk5LKdw90H+6K/YjqMJQP8ofWfO5nzFjPeus2zn1d
         RqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680808069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vUINqOYszvGwT0XKdDs8Gu9wUN5D6gThM9IEXkJj2w=;
        b=INuaXh1ucYILfrJ18iBemw07/A58365aRiHMm+IwWGky/dU4FCMD5OnTJU51r99skB
         HjwzfAQu4KFy4qSJrmxyV7OI9vh6Un4t02GPcRgKGsiNhaCg4XPXLfbHBdNKKvqNXb2Y
         T5tcrCPdfMYJTADU7A9YKdAry12GnyvcTCQm4LU35HHM8QHNk8f05LfPaUuyBApQ+anR
         zR7HfZODyxpxUZ0+eav9j7/q+C+Bncjw2X6gQCFVH9LWEt8qBVzW/VwbbHw7IyEBU+ur
         l8aN3JpZAln7Z/lOOpli2aqY85w9/iSTg/Ez/IDw4v3g02LghlPwKO7QEzubdPrK/lbV
         XnsQ==
X-Gm-Message-State: AAQBX9dratGK/x3NR/H+7HCTWHhcsRDcLL5aHIx4atiwsqP1PAeRhrWV
        U6ZeDWcx3gwWHPBsx73QCviR8g==
X-Google-Smtp-Source: AKy350YwR3t8xnRd20pwg1W8Z/XQGMKGP6GoSbJXEkmmNkumWPAdRpK+bEf2QP7xEZ3diRjVyfh3Lw==
X-Received: by 2002:aa7:d290:0:b0:502:928d:4c93 with SMTP id w16-20020aa7d290000000b00502928d4c93mr491440edq.14.1680808068721;
        Thu, 06 Apr 2023 12:07:48 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed? ([2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed])
        by smtp.gmail.com with ESMTPSA id t10-20020a50c24a000000b004aef147add6sm1060608edf.47.2023.04.06.12.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 12:07:48 -0700 (PDT)
Message-ID: <23c8c4b5-baaa-b72b-4103-b415d970acf2@linaro.org>
Date:   Thu, 6 Apr 2023 21:07:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port
 bindings for MT7988
Content-Language: en-US
To:     arinc9.unal@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-3-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230406080141.22924-3-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
> to be used is internal. Add this.
> 
> Some bindings are incorrect for this switch now, so move them to more
> specific places.
> 
> Address the incorrect information of which ports can be used as a user
> port. Any port can be used as a user port.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>  1 file changed, 46 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 7045a98d9593..605888ce2bc6 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -160,22 +160,6 @@ patternProperties:
>        "^(ethernet-)?port@[0-9]+$":
>          type: object
>  
> -        properties:
> -          reg:
> -            description:
> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
> -              for user ports.
> -
> -        allOf:
> -          - if:
> -              required: [ ethernet ]
> -            then:
> -              properties:
> -                reg:
> -                  enum:
> -                    - 5
> -                    - 6
> -

I have doubts that the binding is still maintainable/reviewable. First,
why do you need all above patterns after removal of entire contents?

Second, amount of if-then-if-then located in existing blocks (not
top-level) is quite big. I counted if-then-using defs, where defs has
patternProps-patternProps-if-then-if-then-properties.... OMG. :)

Best regards,
Krzysztof

