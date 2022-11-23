Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AC5634D3B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiKWBgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiKWBgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:36:16 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18012E0DCA;
        Tue, 22 Nov 2022 17:36:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 136so15575841pga.1;
        Tue, 22 Nov 2022 17:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VnT85l1YGrgftRmY4cs0kf1GLdUSkFh5ZyBQMsB8/d8=;
        b=oUgfZGpfTt3n+gdaAcgz00Mug4dCBCNB/xDdXlVP+K6uV0glmqUHVVcqvQO8b0rrYS
         k3IzWT0SIbOyFZv/D/7QcoURlIYUwvOvNaTu7L+CZNAwJYt1nt0rIwdpZN55gZjFPVDI
         QJECxzixlHdMg1q1pT9qIYI9+GhiFa1fqTUgbMKyAYcqpJDuaoCiKXQVuUOwTk0jlTjZ
         3Uev4hAehD0PGurOWFjtKN6iyx6GnRSSpFJyRNen7Sb0J7XCDoK3YT/eXmH0m93Yr+Jz
         aTw2wWkj5t9YMQ8PpTDjD/+uILOjduYoHPN5Xsw8eSbyvQHXUtHPQgtQs1cq8HHs6mn/
         8jNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnT85l1YGrgftRmY4cs0kf1GLdUSkFh5ZyBQMsB8/d8=;
        b=0APzdXLJc/TAu9t5pcAjRAs+VbqgYnLrrHXox67jtqoNDq97tkPfUNcCXuFA/U12Ew
         TiBmlr+Wn2r6euYiSGuv/+3BObCtx5k/36SeZ7RKSu+zL28Te1JSEjECGBiJR0BOlf2/
         R/pOlORiXzFdwlBX7H8QZqw2SCyG8MEzVjOPb/yp+6nznukM6PZfU4Y2i5sR+lx3TlmI
         hbj3WSIuO1NPo7Qn/ObLW4Ri/WtI/PNSk2E+iOT/QVGd2UFzls26x7Tt3pqL7AdlPv4/
         Edus0w23imZNLqG/G+LevRxBJfX9IQsm7p6qGHEnapIrVgrc3tPiV1jHRSL2EHpQnTDq
         CT8g==
X-Gm-Message-State: ANoB5pkJjbo95IT/uDKZ6bkTAY4Qm2t8V/YJPhwgvDjlO59yP2qbj6d3
        xkCdNRr7KNuXPpn6abKCwa0=
X-Google-Smtp-Source: AA0mqf78pgAVtMq8pq+tCGwJHeM7QPMfI1EDDft+2+fSPKOuH2O4/vhP5xQpLF4Y0UoxHBvM5RyLQA==
X-Received: by 2002:a63:ff0b:0:b0:477:362d:85d3 with SMTP id k11-20020a63ff0b000000b00477362d85d3mr5493742pgi.395.1669167374414;
        Tue, 22 Nov 2022 17:36:14 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:af8d:6047:29d5:446c])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902b68500b00186b758c9fasm12680124pls.33.2022.11.22.17.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 17:36:13 -0800 (PST)
Date:   Tue, 22 Nov 2022 17:36:09 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 7/9] dt-bindings: drop redundant part of title
 (beginning)
Message-ID: <Y315CQUTFYocBnfS@google.com>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-8-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:06:13PM +0100, Krzysztof Kozlowski wrote:
>  Documentation/devicetree/bindings/input/gpio-keys.yaml          | 2 +-
>  Documentation/devicetree/bindings/input/microchip,cap11xx.yaml  | 2 +-

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
