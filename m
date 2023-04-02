Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5051B6D3726
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 12:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjDBKTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 06:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjDBKSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 06:18:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7D3BDDE
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 03:18:46 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r11so106434601edd.5
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 03:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/rAiXCax5IEv3GbtrRjNdKeaqlkFvh50Ja+hlmWJztM=;
        b=CZ6AIWc+LYoqh0eKEeSfubGzY7nIZAjyELJDiSiiYYbEOgKtzDqCe3DdPPU2HH7+6l
         XyE76sN9/H2OjdE+O6lBy8jz9tirH524AiHcq1uu6AWrGQVgzo7qvWaxmZKqTdWk0xhq
         cnFbpfbEBkdTCWpkG0xdGy7sedCy1zlVtGLZDH3RJ0nB9toyOSb8AnnyEUDn4EUF8Vtk
         iOAiBOR+Ggh5Q4EdePZCLxCfhws6xkFYnx50q2m/KqpmtBgbz9yCfA70877PIDqFQUfn
         lTbFradnLqyvCRVf2pcUT4UXXy20oY+tZMVT5JF8h9Gvuv37ODIhzGz74Q2d91Tbt8U4
         l1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rAiXCax5IEv3GbtrRjNdKeaqlkFvh50Ja+hlmWJztM=;
        b=aIu82vKd/qRKUxfn05nLkAUAjEzSDfKgxZGVW22mfMB/ghWeE8qOwBsazpTVboHaeD
         FRZ/NRDv34aUj9QFG71fJQoxwHtoUhvJA+wf+0vWmIq5WuUIbUUqZQUa+OuCflOuDo+y
         rvoZkRGUce69u8KG/1KOMmM7TgG3ddm4D4XjVzQS4bSaw7/vCz0YjJQM/6OmQj611gHL
         K3qs7o5BEza0+WWJ/6D6x9ewirBdqU03o/TYUG96tjpw9tUg0+VCbgXs9SzFWtTLoBVC
         pUzoKS1rLyIOPa5fH1XRaerVN9Oh0ZvuQ4uNpZiNpBLgsjQ5xscth5dFLg1z37l7ieHf
         3h/w==
X-Gm-Message-State: AAQBX9eenIf/7JbDdZS8JtflALr747zlSTgYtFT4/eTaZk/0X+pf1OUm
        4T1JHYS/RIrA7LBVs1qOg2vKow==
X-Google-Smtp-Source: AKy350a58/ZGMnWVhUq5Dhq9lLiSkEtxFuGyfG7+T6kIeXZ4waLFXxIO23QvKHjBcWD0NzsEIN9V1g==
X-Received: by 2002:a05:6402:cc:b0:500:5627:a20b with SMTP id i12-20020a05640200cc00b005005627a20bmr30009201edu.1.1680430726087;
        Sun, 02 Apr 2023 03:18:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7f7f:6a30:7a20:94d5? ([2a02:810d:15c0:828:7f7f:6a30:7a20:94d5])
        by smtp.gmail.com with ESMTPSA id a65-20020a509ec7000000b004fbf6b35a56sm3133164edf.76.2023.04.02.03.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 03:18:45 -0700 (PDT)
Message-ID: <626b9c03-2425-3d26-b088-66412f386657@linaro.org>
Date:   Sun, 2 Apr 2023 12:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC 08/20] dt-bindings: timer: oxsemi,rps-timer: remove
 obsolete bindings
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
 <20230331-topic-oxnas-upstream-remove-v1-8-5bd58fd1dd1f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-8-5bd58fd1dd1f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2023 10:34, Neil Armstrong wrote:
> Due to lack of maintainance and stall of development for a few years now,
> and since no new features will ever be added upstream, remove the
> OX810 and OX820 timer bindings.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

