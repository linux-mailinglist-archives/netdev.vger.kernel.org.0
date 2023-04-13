Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926D66E0848
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjDMHxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDMHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:53:50 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3B5FF7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:53:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f26so29106162ejb.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681372419; x=1683964419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U/YJtAtwQOxzM2PKtqSVApFOVTBHVhiK+yqYr21hnD8=;
        b=z0MTefKoqXACfyo8p36uETj2EvxbGP0CIy66wcqMoy6RpyLnevrdhzcov7efjr78Pr
         Ybo2Sm6gqYXI8/72I1bw15Ll1XhGo/CjsZS5xG33WlWiY7oUnTR2RhaofI7zPo+c2PKO
         Njipec2ZSQ0Qq8/uSp7JNy6dtsg2qxfhqkq68hrz0LHPLw5TAJQQxrz5IzXbVrhP+EUp
         31Bf41K3DRezXsL53onzaeqQGBczPse8Y6S2M9n1FqdvFwouhsDWNA2BCedhVkFVT2FD
         a1cVta/ojaLoWi+WRJeWQUT54gmcVfUkFzDJ9D37RePszkxSo6r5ZLui/2nO3ZcZDVzF
         AexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372419; x=1683964419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/YJtAtwQOxzM2PKtqSVApFOVTBHVhiK+yqYr21hnD8=;
        b=ggtFHBrmdTMMKw4Wr0oTSeRKQwA/XrcAhsknmxGdTL8fgKG13JeLlFbTyOgcwU/pLA
         W04lPuZ9qeQXdU4Y7eG22puhxXvth+wkt0F1ieoJ4ccCLamFD5dI4YqfMPMRLCi84aSo
         tHZxSh18Xhz08VxHQbNJ6mb8//sNQHpSCc1WaYxujU2Etzt/vW8nff+/3Zzii0yMYVGQ
         e0201Rrsdbr+t+Kl0jGaBZX5arZajcvIsqpFYD/MLfCVT8kzb0XgJ4oXf5S59R8+2R4z
         JwVFGQDZB1Nd1xsvg5Nb0jV+n9YlVHdW4jjT1DhiZGpJlAWBSCpVB84IIsTlcphXbmSd
         DWNA==
X-Gm-Message-State: AAQBX9cIGH1S/0gTNN33kLyituG3gR9hBxMRSvGWtytv0iIrrRRGa8DN
        OL/dmJ3UD1eYXwPOcR/Mt5p7HQ==
X-Google-Smtp-Source: AKy350YTeTeiNB4gNruFHqdFawYC7qaYf2tatuF9BLrVs+4s2K7bHluv7sGNn6WG/m5DT/4H6Ubn5w==
X-Received: by 2002:a17:907:9617:b0:94a:88aa:93b3 with SMTP id gb23-20020a170907961700b0094a88aa93b3mr2408327ejc.44.1681372418793;
        Thu, 13 Apr 2023 00:53:38 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:ec6f:1b33:ab3f:bfd7? ([2a02:810d:15c0:828:ec6f:1b33:ab3f:bfd7])
        by smtp.gmail.com with ESMTPSA id gz1-20020a170907a04100b0094a6ba1f5ccsm586972ejc.22.2023.04.13.00.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 00:53:38 -0700 (PDT)
Message-ID: <663cd386-463b-b672-ef07-b112a6a99a6a@linaro.org>
Date:   Thu, 13 Apr 2023 09:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 3/4] net/ftgmac100: add mac-address-increment option for
 GMA command from NC-SI
Content-Language: en-US
To:     Ivan Mikhaylov <fr0st61te@gmail.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
 <20230413002905.5513-4-fr0st61te@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230413002905.5513-4-fr0st61te@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2023 02:29, Ivan Mikhaylov wrote:
> Add s32 mac-address-increment option for Get MAC Address command from
> NC-SI.
> 
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ftgmac100.txt | 4 ++++

Use subject prefixes matching the subsystem (which you can get for
example with `git log --oneline -- DIRECTORY_OR_FILE` on the directory
your patch is touching).

>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
> index 29234021f601..7ef5329d888d 100644
> --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> @@ -22,6 +22,10 @@ Optional properties:
>  - use-ncsi: Use the NC-SI stack instead of an MDIO PHY. Currently assumes
>    rmii (100bT) but kept as a separate property in case NC-SI grows support
>    for a gigabit link.
> +- mac-address-increment: Increment the MAC address taken by GMA command via
> +  NC-SI. Specifies a signed number to be added to the host MAC address as
> +  obtained by the OEM GMA command. If not specified, 1 is used by default
> +  for Broadcom and Intel network cards, 0 otherwise.

First conversion to DT Schema. New properties are not accepted to TXT files.

Best regards,
Krzysztof

