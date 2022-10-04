Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA33A5F42C3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiJDMP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 08:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJDMP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 08:15:26 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A44712768;
        Tue,  4 Oct 2022 05:15:24 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s30so14850964eds.1;
        Tue, 04 Oct 2022 05:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2lOHsA4YDq2IujWxO2OEfkKj+VmjOjVPd32CvU9w1c4=;
        b=MtiN0+8DKyMoOZfm9dkixtCFFOQDi8dcF30pSFv3f78JsHYgtZQVlyGSKOnM8C9vQd
         h2n8MQWwLwY9mLa5+1Es/JRxockRg/gB5JIGp4MlDibcA9d5y/3zkByIS8dcodmmpyFD
         8sklYE0Bq9oE0cIrYdtMKWf9q37fXYjIImqAD8oLFaOQIvj+aptTtra/+eGUmK7qKfwF
         6x6NPdICbxH4QZFpJNCqJNIPo8kdMOBL1mW5f091ksVHYljDOhHZNV2L269om61fIo8W
         S0tAIXCTNSiKNgRMwQzabQsmXNh0rd2/6n5JNGviBTH+nIUJoGQaO+pA3Rfge9jJGcmH
         EJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2lOHsA4YDq2IujWxO2OEfkKj+VmjOjVPd32CvU9w1c4=;
        b=qsrZrKSNRkkqCeNA1FEcBkoUcc+w+jb4VrI3zQCJxUMApcdv4ezI0batD1uCttPssM
         W0bDmpwFvKJbcNqCMOwmlf5rQQPUG/UaXgBd01EJhCpadbe+6ULJ3xcqlXhAGxBwPEeC
         PTsJJ+V1nB483Ly9YDE/+UDN1unmLKKaPE7KVzrD2BrXnBRRQlSDtOefMw42ckf8hQvk
         /uXmRKNzTi1gurC6L+/6GK8d+vybiPe/0anze8Vd1Td+99LSODnKU/sSVzgWT9pTQzsF
         ReNCXrnvjFrL96DTc7e8jq7Jfu2wCqnw4BRrwUC1Tf7+l8aQ8v4HAVZ8Xj4gLVUevtwL
         RUrw==
X-Gm-Message-State: ACrzQf0R9TjiGFu7lMVwq9ShA6AaNU+TMSoxx4Ui8o+EEf8f0aWMio88
        qpSADUCRfH8zjpnhdP5+t1E=
X-Google-Smtp-Source: AMsMyM7sGqjKVDsAcBoTJRuW2xubDE5GjBS+Bd0StTskoL/V+fhdd8EfQQhWwh77AEluye9o145tIA==
X-Received: by 2002:aa7:cb18:0:b0:452:9071:aff with SMTP id s24-20020aa7cb18000000b0045290710affmr22877322edt.194.1664885722541;
        Tue, 04 Oct 2022 05:15:22 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090615d500b00779cde476e4sm6983423ejd.62.2022.10.04.05.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 05:15:20 -0700 (PDT)
Date:   Tue, 4 Oct 2022 15:15:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20221004121517.4j5637hnioepsxgd@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
> > +  # Ocelot-ext VSC7512
> > +  - |
> > +    spi {
> > +        soc@0 {
> 
> soc in spi is a bit confusing.

Do you have a better suggestion for a node name? This is effectively a
container for peripherals which would otherwise live under a /soc node,
if they were accessed over MMIO by the internal microprocessor of the
SoC, rather than by an external processor over SPI.

> How is this example different than previous one (existing soc example)?
> If by compatible and number of ports, then there is no much value here.

The positioning relative to the other nodes is what's different.
