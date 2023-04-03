Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28906D50D5
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjDCSic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjDCSib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:38:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B963C18
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:38:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eg48so121014389edb.13
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680547092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CySdEehWspubmXAcFc/gUkZ6ALWiIO8Dims2v4pC7cI=;
        b=XxNS02hVI+u4D2pE7UGlx7ntA7oWIlCwkuRm3Gyu0E+L6ULQyC+6ShlqR4ekLzDFlT
         pRslLrKcSR/9KsmwaW7cNkZ4sBLMBrrx13XQF615coXajYG/D2tRgvu66pGLfEkrm/C8
         2A12Wh9pO54frQbFLcjovLAct7UkfQ9S1TjuUtOPvPyfN9wP6JUhxmt2lMVWqNnXPliV
         rx/sm1EdhuYRfJXOSQ0ApUnyqwfYJXx+sqa2wWwvgay1iMPZZRXTCENV4sZ6NYwUwRpY
         /YoYeDYiuIdE9FWPQg9xmmoXwmNDiV7gsagK762uIJSgjXuFP8gohz0DLGqClEWw0WV8
         4NmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680547092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CySdEehWspubmXAcFc/gUkZ6ALWiIO8Dims2v4pC7cI=;
        b=cwChzjJm62gvi6/X1KobJ1NIs8z50xYDE57AfOtHag48gRuRL5p17sjbJFNeCN5z2T
         nvbmKkF7Kej75/5SpNHfEn/n7vIb0gj4K3WJMTUDd0PNro35SLU+NME1unBSliWwRdzv
         OBPI48Hg3LMuq1MV7svHvyIsIXkaxj1GIHnigPfOLx+m+poKQPCA/37hoo1jMEQ6IOhJ
         WOwLoKciAUvSk4B689YZ3Xrpt/+4S8oK3YeLdJWp0dMl97UHc8nWvgOm1ZVHxkATqTKj
         jKyDAakopQlO9F2hOBr6E5VxUWCUNTdsZqPM65a3IqKEZp9q2ReSzfUgQPHFswp/JtdC
         dzng==
X-Gm-Message-State: AAQBX9fdB8U5HimYtZ/Ko7V0Boc7N0HdHQu+gGBchzcMTTQAaAw+jcEL
        JjUIcgSdPAg+sJUP59w4DIzyEQ==
X-Google-Smtp-Source: AKy350a21SUvVW8zkI0jUgi5Fki72Pdn7B89a65yFrUkCNuucXQuzP/aqKcsR7vvEISiRfXbpBAEfA==
X-Received: by 2002:a17:907:8c83:b0:939:a610:fc32 with SMTP id td3-20020a1709078c8300b00939a610fc32mr38202123ejc.53.1680547092335;
        Mon, 03 Apr 2023 11:38:12 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:ae90:d80:1069:4805? ([2a02:810d:15c0:828:ae90:d80:1069:4805])
        by smtp.gmail.com with ESMTPSA id t17-20020a1709060c5100b00927341bf69dsm4868907ejf.88.2023.04.03.11.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 11:38:11 -0700 (PDT)
Message-ID: <ac0a61cc-942e-191a-76f2-855b482247ff@linaro.org>
Date:   Mon, 3 Apr 2023 20:38:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC 14/20] dt-bindings: pinctrl: oxnas,pinctrl: remove
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
 <20230331-topic-oxnas-upstream-remove-v1-14-5bd58fd1dd1f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-14-5bd58fd1dd1f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
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
> OX810 and OX820 pinctrl bindings.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../devicetree/bindings/pinctrl/oxnas,pinctrl.txt  | 56 -------------


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

