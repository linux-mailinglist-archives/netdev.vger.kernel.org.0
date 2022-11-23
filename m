Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4D634D51
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiKWBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiKWBhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:37:24 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709879824F;
        Tue, 22 Nov 2022 17:37:23 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id n17so15530466pgh.9;
        Tue, 22 Nov 2022 17:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=57QTDQNjua4bD17eBQRGR4QYAKmDZiaeZv3y3ThjHNA=;
        b=AJd4p4Y1GJ2PPHHqMJkt2vAn6ERqJlfv48oiJrZolP8/Sh1CAzdLzBPA6Y9SygNMOB
         ZL09xzKfYY7O9Doh92VB3jb6Ja8HBaQeBTEaB8nC72ZjmyawK/usRw5XgujG3BFx/tAa
         YQzpVS/GviFMu850709iF5BIFlEAro2HnvijgpS0DgkaoVdPf+crlJ8hgf6xE8Hefq+w
         79hHmd2FIBoMnyNG0wJ0UGHjyN8DYJcXF/xPRlPXnE/3S7V0L3QNV1H73/xPNO9zBSaj
         Pg4w7ZIQmKiJxfxA9pfQlebDCPWdCV3XIz9WLiDa5A8wWXQqx8dPEJlxFOfUf9f5WHlm
         xytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57QTDQNjua4bD17eBQRGR4QYAKmDZiaeZv3y3ThjHNA=;
        b=Xp+xVKZiv7dMq3egI49uxxxbvYedqyTHuitrzxA6GyAq60sVbFtjCG2c9pZXqrKjCc
         QB8BbTxH25GIuBQoQkh/uYV/OsJoh6g1ZgZ7HtuSt5tLXPIeu8wduJk1El4S4TO/ph5u
         dsfB1siKCOyUh7fSNxpPWEnUva8PJPpHvEmCF+f9cagh5mFpSo/y4XDL2qUsi/PQ+3XV
         SnpsELKi9fwYWASuLCDlAGTpNhP//pQFLr59VU/Wfu+RNpjYZFsO2sxjP8jNl7NoCG9C
         HI/l9lAbg51TeW1lKP2aRR86wjGWnfejofeyGOf/l4niZDyvBOVe3dJiN8qct/30/Hpu
         hSqQ==
X-Gm-Message-State: ANoB5pkbuQpHHvRO7TmK28EVTEO7K1Y2EIuioOwe9RjrEmjKoDbQRsyV
        WYdybXaTHipy/RRi5Bigbow=
X-Google-Smtp-Source: AA0mqf547JrxZeSVmkQLdlrpalzLSYM74m3LOUHFPzZ3vcYEWkifg+t/S5X1eHUvslK9HNQURfIwrg==
X-Received: by 2002:a63:de14:0:b0:477:4a61:eb99 with SMTP id f20-20020a63de14000000b004774a61eb99mr16322572pgg.48.1669167442801;
        Tue, 22 Nov 2022 17:37:22 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:af8d:6047:29d5:446c])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090a674400b002189ab866bfsm204545pjm.5.2022.11.22.17.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 17:37:22 -0800 (PST)
Date:   Tue, 22 Nov 2022 17:37:17 -0800
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
Subject: Re: [PATCH v2 9/9] dt-bindings: drop redundant part of title (manual)
Message-ID: <Y315Ta+ST067iVmh@google.com>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:06:15PM +0100, Krzysztof Kozlowski wrote:
>  Documentation/devicetree/bindings/input/fsl,scu-key.yaml        | 2 +-
>  Documentation/devicetree/bindings/input/matrix-keymap.yaml      | 2 +-

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
