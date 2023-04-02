Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17A6D3737
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 12:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjDBKVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 06:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjDBKV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 06:21:29 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6048684
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 03:21:27 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b20so106451031edd.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0dHtm6rEwdmIURaK6uwg13/SivrIWW9+hRVkQN5p4kM=;
        b=hWRZFnUzy/AO/MrrHGptqieSYv8r5ivl++6jYZxkWvmMxEye8miSsugXiCJBi5sqvL
         s719hTzx6xAsRH6O+8+R9ZEN4ZJOlMD6r2NdJ32bzEnaZmYynk5Oc2nlmJmRHXdUSkfQ
         qsbxUVvKFP7ACEIsS4RBi2a3SONFntKaxPE5/QMz4WxQD3+uAHQJO6pFs4XTeMC3pSGT
         onjtT+bDjrtAZx9GKQ5NBHQZEDwIaZRLJaOvD/2SIFP+Dhx0u02i4Uvx3y4spp4V8PRL
         g2AylIyMAALt7BOVeMXKB/5gE8oSD9J36tN636+e0ps1uHv2/DxBdfi/DCpIQ6LBfhEC
         B+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dHtm6rEwdmIURaK6uwg13/SivrIWW9+hRVkQN5p4kM=;
        b=EB8ev8vuO4Qxv+Y8URZu28+uW8BCAijnVInWyHEXGIN+A7cwz/TGnvSGm+b6xPZ62L
         QWwnxyPIiemZbjSnGB7XPsnEFKGR3keZyfjK2iRGVWbuabCFXMJdR18OdPgco3q3i2lj
         1HKytRV6DiTNi0gdzIRwRLfaJTEZh2GXnJTdQinCegicXIm9I70yhgApWUtbhb+O9S2N
         u3i/FrvIv1JeGDl5/BqaPbQ76TC/wXmlfhbw6q2LX2PO5mLWet2D+XECJCIll+LvICCh
         ZXM+lSP/lEwx1qtpZYDXwFIJHKO9zNOI63Oifqt4/ZWuTzcvZfYdBD1qN3ImmVugGZAD
         czqg==
X-Gm-Message-State: AAQBX9cAibtjqSltJqc2N20liqt3zZ6MnFuZSML9R/fHA1EVy2kNMOWc
        mMdBpSGoqsaGyYQ4oeJf1d5lhQ==
X-Google-Smtp-Source: AKy350b7C1SmwO8vWgBCIzK+/qLm6HfLt8cxKJ4Flko7Ti/4JiMy1EgB0vrkdSSZLLB43zm7wiLJkQ==
X-Received: by 2002:a17:906:3da:b0:931:95a1:a05a with SMTP id c26-20020a17090603da00b0093195a1a05amr33727013eja.62.1680430885727;
        Sun, 02 Apr 2023 03:21:25 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7f7f:6a30:7a20:94d5? ([2a02:810d:15c0:828:7f7f:6a30:7a20:94d5])
        by smtp.gmail.com with ESMTPSA id cw1-20020a170906c78100b0093de5b42856sm3055582ejb.119.2023.04.02.03.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 03:21:25 -0700 (PDT)
Message-ID: <b207a77f-18ac-0da5-e95f-bd38fc1f0d11@linaro.org>
Date:   Sun, 2 Apr 2023 12:21:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC 01/20] ARM: dts: oxnas: remove obsolete device tree
 files
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
 <20230331-topic-oxnas-upstream-remove-v1-1-5bd58fd1dd1f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-1-5bd58fd1dd1f@linaro.org>
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
> and since no new features will ever be added upstream, remove support
> for OX810 and OX820 devices.

Lack of development and new features are not really a reasons for
platform removal. Platform can stay in decent shape for many years,
without new features.

Lack of maintenance could be a reason, but first we usually make
platform orphaned to give community a chance. The best reason is lack of
users and any relevance, but your commit msg does not focus on that.

Best regards,
Krzysztof

