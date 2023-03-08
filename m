Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695286B0536
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCHLAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCHLAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:00:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4441452F73
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 03:00:04 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s11so64046638edy.8
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 03:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678273203;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ALpgLnAG7SSkBtQyhSH7n2GLsWIDM9/6Md2rctRlw6U=;
        b=NWO+qIXuRatHRJcTMmjiZyOBbRcarKTHIDJGjlNTIkrDh7IENEqrkRDk+td3YezeUY
         yHNj+hHhV2MDxrLry3OmjNoaJQZTuRhCwZa4Bpm2qicWGUjPkhojs+Xkd7sFDbUcs9Ux
         iD3r8qTYL62aG6fQ/aJMcdeJa8IOjAut0++eCTTFuusgTiD8fvDeN43B7kc58wn6abLg
         gkOlavBT13ijz7xk3eDcBIhjZu8rhD5FAhhNmcu1uPFZObGP8EneE2i/6H0XEiBk4ddP
         T555LYKX9uxNXM2TrQkshD6N7S87e0K1fpFMm0UTq4Djuu1xhaTpKK2x0sbBX9XPT+Nx
         Xemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678273203;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALpgLnAG7SSkBtQyhSH7n2GLsWIDM9/6Md2rctRlw6U=;
        b=bcb+SY+Afu2yvHQfXcciWw/czEnfdceAxBvsb5t+w2m/jqdRE+71YjclLrCV4/JZB/
         tEeS4+yw5kABHRyDAS/YW1/rWRTslcNLprjipri8afFRKQTb7gMdH2fKcjB8Bs53ySDK
         H00LtRboCDgyjYGLZ69nimV1OTAUpRziY3rRiLe3CGtQ3dmn6nIjiTOwRX6Ou4vaHPP1
         c6iC2eH2v4UZ2UoCufJeeZQaJy8+9wNj2yjFm7T39EzqDUTWYa88yYKv3jCtz2Ykew7U
         zmQFVzljGHFAr1C/ALZGhi6Pn6n5jQAONtIWbeB2+Rbk8en3/kl0N459KOKG4zB0xiG4
         eNrw==
X-Gm-Message-State: AO0yUKXJCIzHJtE3UAMhCnLaHTsT6eqca5mUfIerKvRsHpPtNJEL9yTO
        JeQ5iaxQ3vTlNKJHQ4h+gwSMIw==
X-Google-Smtp-Source: AK7set/66VZEss0lMYkM50wqFCWKYBNwKAUAB/d2Sy4zn2xDs8a3GoDNNw48uNH5IpXOQx0lyJHATA==
X-Received: by 2002:a17:906:6c9:b0:8b1:77bf:5b9f with SMTP id v9-20020a17090606c900b008b177bf5b9fmr17312133ejb.13.1678273202731;
        Wed, 08 Mar 2023 03:00:02 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:ff33:9b14:bdd2:a3da? ([2a02:810d:15c0:828:ff33:9b14:bdd2:a3da])
        by smtp.gmail.com with ESMTPSA id bo19-20020a170906d05300b008cae50b0115sm7275973ejb.87.2023.03.08.03.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 03:00:02 -0800 (PST)
Message-ID: <ffb11c8b-be03-4ae3-6970-cf4bb21587e7@linaro.org>
Date:   Wed, 8 Mar 2023 12:00:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [net-next PATCH 10/11] dt-bindings: net: phy: Document support
 for LEDs node
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-11-ansuelsmth@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230307170046.28917-11-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2023 18:00, Christian Marangi wrote:
> Document support for LEDs node in phy and add an example for it.
> PHY LED will have to match led pattern and should be treated as a
> generic led.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Also missing changelog, history, tags, anything. This was already v8.

Also, I have doubts that your patchset is fully bisectable. Are you sure
of this?

Best regards,
Krzysztof

