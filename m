Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68020634D0E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbiKWBeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiKWBeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:34:15 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1FB88F83;
        Tue, 22 Nov 2022 17:34:14 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b185so15997747pfb.9;
        Tue, 22 Nov 2022 17:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0o+4E907Zvvy6ni+QZQIz8xU1g4Q1COgvbgTOREnlPc=;
        b=hm7Jpy1qREkOXLdAWvAMk4d1oXJ4z39uVk6vVyHKQn0eiACmSjnmVu7+6OjCgem/Nj
         kIC38x4waRshCgVXkata3W3e+zYStDSXXa+t5TCqFTf+YGEaJ0BXaE2iJ5CtShcple2O
         iwGh1BBp3Yhs+WBZuM41+XKvZLKvIQ57B1cHClHhYA/rIet45eATH+Q1t1VffM+nGEC/
         NDtdh2cBSDnIS/UrQQME9RN7DUtHUWpEEKXZ/b0KvJ1Jm7ZGdb8CejVl0zVYrURNmyZV
         oz7vGFvTG3kFnf0zzHDMzJrbdT1rboYq6lrpnWNVWFdZLGnPVJ5ugRoImnF/aGQwpm7m
         jIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o+4E907Zvvy6ni+QZQIz8xU1g4Q1COgvbgTOREnlPc=;
        b=g4FuS9EppDpDbGQT/XGIgqbFUVjtqhjKajGxM3rJ/O4c+67S6Xikx8BGHfbKbI37vQ
         CCozlKjiF6xVaLNunll9sZfpuvkkCD1BcwEh/3oX8shfaXuj3t3TgulFT0VmeUjPm0fz
         POp9kO/TC8oMkuixX4O8rqUtVbczb3G41FlsveKKuT2iJkQmBnEQJ0lDJnNOYdoauTkX
         +TkhR67gWY0sRB90PJK0AudCFRpcY8WwX9SxrUBk0VsdyN2AvK1zW19byDHyfbTiAYS4
         O75MIZl3zWvRbapQpXrwiQ0PSPSlBIDcIfelrOIT9mIknx4gxhUcl/kPKuRVJgBV1lFH
         gBNA==
X-Gm-Message-State: ANoB5pn/tJnWxn4l/ucQWZqhQA3NPk/G/Bj0f5J0fmX2izo467InyoqO
        HzcZAnJz0ynKpogaf1xKb80=
X-Google-Smtp-Source: AA0mqf4fIComKK9aDbVNdnJistSL4pHYNFA0hnYz4EKVMEmSoZO0zdR4co1U6hu9d1BpJRYGfXKZAA==
X-Received: by 2002:a63:f00d:0:b0:458:f364:b00e with SMTP id k13-20020a63f00d000000b00458f364b00emr7084885pgh.577.1669167254077;
        Tue, 22 Nov 2022 17:34:14 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:af8d:6047:29d5:446c])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902684600b001892af9472esm4174053pln.261.2022.11.22.17.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 17:34:13 -0800 (PST)
Date:   Tue, 22 Nov 2022 17:34:08 -0800
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
Subject: Re: [PATCH v2 4/9] dt-bindings: drop redundant part of title (end)
Message-ID: <Y314kIVvP+p2RIzp@google.com>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-5-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:06:10PM +0100, Krzysztof Kozlowski wrote:
>  .../devicetree/bindings/input/pine64,pinephone-keyboard.yaml    | 2 +-
>  .../devicetree/bindings/input/touchscreen/chipone,icn8318.yaml  | 2 +-
>  .../devicetree/bindings/input/touchscreen/pixcir,pixcir_ts.yaml | 2 +-
>  .../devicetree/bindings/input/touchscreen/silead,gsl1680.yaml   | 2 +-

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
