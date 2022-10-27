Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8F60FC30
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiJ0PmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiJ0PmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:42:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BC4C6954;
        Thu, 27 Oct 2022 08:42:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ud5so5817821ejc.4;
        Thu, 27 Oct 2022 08:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Foe3NaxZvpwgbIwWLGZVEAQzzIpp6zxIwx25sYmkf4U=;
        b=XTXK7tjqoiAMq5OJ2BI3Ue+mXD2T4Ihcfep1IxX1JNjE1zfAgKQDWCXBCKTavCasQr
         CSP6UfEyH0nYnrpeMmLRxDZ3jKL8M2IItTjyk0E28ALTAl4lMT+MCiCRP8YRWCjnUkmC
         n8htJH9ZrIioOlxyFX1B7sOoa0jZf1afDGy5kzzluyZKK77+2sfJLLUXZ4AUntH+L3LR
         VNDIfaJ3azos1WX1KbVaYG1ERviugCQozqYxF3Ra3/i9rDXZamra1bBLQHBFKamTK7pl
         3vVNhwkL/ACt1oKlOZzAF5AweaMErjX1bcGmsKJtcQJFjwjrEA/u6nMY8Ot1dHC3WEB0
         1wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Foe3NaxZvpwgbIwWLGZVEAQzzIpp6zxIwx25sYmkf4U=;
        b=n95Cop2/w08ibnGErYhlnzwiia2Kee2IW8wlS5wgh4CDfKnLqGBK87O6E9MbcB0Uay
         0uZ0aWcAb2rYXrnBYBV2Kcc4PgpC0yCe8LlsgalROWkd3Zkx+6+HCa9Qz3JKnM6NkYrO
         7XAlzvlrwFCq4BQF1lPwNfkMV0BQA9bvYpZnuq670tijblGKoYcO5R2C41FTeE1Ht9tM
         2NlaVIhxGl51TW3PFR+nqPwTQsQpZiAhoXV9lFHP4dYolCtcAmutm46cYwCHXPyu9WQg
         lgKpeFGsJvVcZTOoZuwD7y2B0ahpP3Ew+rueAceLjngRU4i/iLOkNg8lEFj/GodvJ/LM
         gMSQ==
X-Gm-Message-State: ACrzQf2N7z/nMQyTAG2UKCjsy06nhdpOPD5W5Ii8DaJMXrRk4tus2E0F
        sGVYiGeqYWtD+65EK2zAjdY=
X-Google-Smtp-Source: AMsMyM6eAhx24hELhlVVAeMi+1qb9jjHHsECANFN/IOPuukLQKFzJF4HGkTq1LAl2rlZTw+eQKjPwQ==
X-Received: by 2002:a17:907:983:b0:77b:6e40:8435 with SMTP id bf3-20020a170907098300b0077b6e408435mr40638628ejc.570.1666885319692;
        Thu, 27 Oct 2022 08:41:59 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p25-20020a056402075900b00457b5ba968csm1166237edy.27.2022.10.27.08.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:41:59 -0700 (PDT)
Date:   Thu, 27 Oct 2022 18:41:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Camel Guo <camel.guo@axis.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Message-ID: <20221027154156.wdi2ka52xwdgm7cj@skbuf>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135243.4038706-2-camel.guo@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Camel,

On Tue, Oct 25, 2022 at 03:52:40PM +0200, Camel Guo wrote:
> +additionalProperties: true

I don't think the switch schema should have additionalProperties: true.
Only shared schemas should. WHat should be here is "unevaluatedProperties: false".

> +                port@5 {
> +                    reg = <5>;
> +                    label = "cpu";

Please drop label = "cpu" for the CPU port, it is not needed/not parsed.

> +                    ethernet = <&eth0>;
> +                    phy-mode = "rgmii-id";
> +
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                        pause;
> +                    };
> +                };
> +            };
