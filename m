Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7172D60788C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJUNdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJUNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:33:30 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832527211A
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:33:24 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id z30so1956950qkz.13
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A72BE+IY0ZrHLTBIHgimMdusQVYAjUJuQP7S8i5Lgzg=;
        b=NSMmHp4D72Xj1JgY7/qmYBJ84+8CoWjIgZn+LlXfl5MOa/ypvZGuIOMc0zqIRgSiuA
         W7KinC3ipcNrUAOHnMjwM9ImAH4Z0622rc3FiQa/rRHO0tDAwjrlBI32Ts+z7yP0kILA
         A4SOg22jgqdJKf7i9HSlvvwbjee9SmmKWgajtWSJlbIGre6kFnT2QmUB3g6aYAv1IT+x
         skWsg5X/BgtB5/NkFmfwno16ZNTUpp1AyLXZBJ5zuy+C3GmgRMvYXjF041rcmzkmIq+3
         96/rRo+9PsHQAfcAm5ZCudDnpc9XKX8CcXckUaVOw03P6UT+T/WCCxIJti2HA13rrYB+
         +BuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A72BE+IY0ZrHLTBIHgimMdusQVYAjUJuQP7S8i5Lgzg=;
        b=BhMxYI2rVtp5Hc181ESu6nNKa29U66yhmDfdL0gbnD5J8U137yxSFVyMdpoMz3SAyk
         9sC7fke28kTAHzxN4Vr+waLR5tRzDE68kk1PmqvSfwWXWz2xl37Shu2QzAXTb9OyY200
         pB5QQc4hxbhpPZ8Ms2rjjJ5f6Ho/wKx3K/aMW3lMaP9yHxN3/qnRQ+8nTVl13xhdlfms
         brKz/yuMtJ0KUhSX2t1iPuyP3hnGJhYX6lTDHlOahXHdlG6qQlNOBCFtPg3DI4h4SIjJ
         Vg5hKgSFm4MXG2SozqBSHS167snkQRvw/cyadtMo2i3fzuHM4w0Qdqo2yMTB1L6jECTb
         GtuQ==
X-Gm-Message-State: ACrzQf02yedGHB7UNWqzbUG/kJmAa9iWIm3YIK2By+gFcMvWART04eqO
        TBEddh9E+RHntSdNQPy0qndFig==
X-Google-Smtp-Source: AMsMyM5qZak5lIY8DroovbcZWF2ESpxujwqRcUN1jNE81aHgGbe/231Ljtl9XkXmUws8ZJyuf658jg==
X-Received: by 2002:a05:620a:304:b0:6ee:77f1:ecf9 with SMTP id s4-20020a05620a030400b006ee77f1ecf9mr13922921qkm.94.1666359203197;
        Fri, 21 Oct 2022 06:33:23 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm9459881qkk.81.2022.10.21.06.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 06:33:22 -0700 (PDT)
Message-ID: <3b1e28f4-c057-670f-af36-d332e3afb61e@linaro.org>
Date:   Fri, 21 Oct 2022 09:33:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 1/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-2-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221021124556.100445-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 08:45, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V4->V5:
>  - Remove stray quotes arount the ref property
>  - Rename the binding to match the compatible string

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

