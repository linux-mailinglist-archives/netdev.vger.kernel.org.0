Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91326D372D
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 12:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjDBKTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 06:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjDBKTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 06:19:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C3E265A4
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 03:18:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id er13so65433329edb.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 03:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OtKdrX4/WYAWGE/oihOuzGoYfmWNzeAKoe00y3BPSN8=;
        b=D+szkCU7Xi1hnPAayL38twbm9pO3fqDI9qeOd42UZkG7444L+rQobQCRhAvQOCqrSA
         kmDTr9aINpjhHtM7q+A1FLgjCKm1w03SEIYf+QBLC0DfQbK317bJbyR7u9P6y0JVsnaK
         exAx+RJ6ewcq0d7yjYyHo9Y0xsGjWQWDC6cQ6XM7wgWpH3DrDA+W3sA8u6ovkahKcX9w
         K4x+ZAijcG3jIdDZZ6KPeFjnkhJUTKVAGY9mLCtEVeefg/0bZ8Zr1hekU63vsLU9dldq
         tKxB446wBeUoYa1hkh0vxsost5Gtf3tt9hcmfd6m1wdJrZ+sIMs9uzBdbf+3ap4CyoTz
         1vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtKdrX4/WYAWGE/oihOuzGoYfmWNzeAKoe00y3BPSN8=;
        b=nHpMKeyPTDi+SYybO3YZh2VXTftqZJYE0z7eQz5Eyc9aLoq6aGXq13c+3MEoNEID5H
         3EdrwxEcwzqQs2NbWZN2DTYouIlGJaO4st0ZFgPasd0i60Ujd0NawI3uXLGW451MSukC
         3cddWdP6NvL1kmfDpEjX6s0OYI4zPQgaLBvPAlG0yuZRQSCBg661rjeUppyIuVKDICFC
         TxA66/3HgFjzIqXMCjCVianV/uQYORhwaGPJNKJ4dR8fl4doo1E8S1iJPXBocMAHTBap
         z3aytsKKWvWT3n4vdizUOrX4+Kh4dlQDnmBv5gorfFr8x88rVYtEuIGk6DxNp6BGo5Up
         3xbQ==
X-Gm-Message-State: AAQBX9cuUUU1V+8WWSYVoCTvkD6/B98yZhOtvU5sYe4amp7qAgcoy2kq
        UPy4gjBy5XcFqgIKAPUFdoUcjA==
X-Google-Smtp-Source: AKy350alqKW+Mo2o+XyvN+VkTY02grNM59TxjbAC9a7rEScQk56nn27JU+ggSLKxyElt2GWi/vqu/A==
X-Received: by 2002:aa7:c145:0:b0:4fa:ad62:b1a0 with SMTP id r5-20020aa7c145000000b004faad62b1a0mr28417046edp.41.1680430737670;
        Sun, 02 Apr 2023 03:18:57 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7f7f:6a30:7a20:94d5? ([2a02:810d:15c0:828:7f7f:6a30:7a20:94d5])
        by smtp.gmail.com with ESMTPSA id o2-20020a50c282000000b00501cc88b3adsm3105800edf.46.2023.04.02.03.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 03:18:57 -0700 (PDT)
Message-ID: <775f687b-bc80-a9ae-86f8-d821775f4e72@linaro.org>
Date:   Sun, 2 Apr 2023 12:18:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC 10/20] dt-bindings: mtd: oxnas-nand: remove obsolete
 bindings
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
 <20230331-topic-oxnas-upstream-remove-v1-10-5bd58fd1dd1f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-10-5bd58fd1dd1f@linaro.org>
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
> for OX810 and OX820 nand bindings.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

