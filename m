Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5DE44C99B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhKJTyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:54:02 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:40933 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKJTxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:53:55 -0500
Received: by mail-ot1-f46.google.com with SMTP id q33-20020a056830442100b0055abeab1e9aso5534763otv.7;
        Wed, 10 Nov 2021 11:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IaGtHvG6f2Nq9zdI9Tpc3bPF147EUDcHeqfU5NOs8/A=;
        b=4n7Qto9EokmAwIDR9TI0zqrWUs9uEivnjYtyYzTulb+9EEalPtUvbJu8saLBKXPgkO
         m/xR0K94dEyTcIUkXbiBb4GCa42AA28eGeAN+4EfJign89YNyzeFUNZqhjU5X8unMm3W
         4tXE0yO6Zh7Ez4XeKaOgHORR1KgSlN51XMLsp6wfNsHB1PVmtMoXdzaM6k4w6cCD/7Et
         WoDHTpIli+rxU8eQG8IM5c4neaseF9ODKIj33w9FcmmTopAaXDowsOPK9FmhWdYr6uW3
         +RSYH2hsZ54MzFgz15DNyCOGP1HkDu3aDBMN1S4X+MNS9qkqYMPWvJIOjxHoD5+Z3bUq
         wvCQ==
X-Gm-Message-State: AOAM530CbwNZE2INL+5jpD9YpXx7RAzsjBCWExN40Z60HgBWWhETZ2qV
        QR/BehzGn+Y6MZLBYFJoOA==
X-Google-Smtp-Source: ABdhPJyoqzCKoO1mccILtZ9+sI1239ZXZq43Cb4nIbMhmS7HoNW5DY3iPPKtMi57BRAkrSAOfgsptg==
X-Received: by 2002:a9d:6854:: with SMTP id c20mr1506260oto.190.1636573866562;
        Wed, 10 Nov 2021 11:51:06 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q44sm190616otv.80.2021.11.10.11.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:51:05 -0800 (PST)
Received: (nullmailer pid 1849495 invoked by uid 1000);
        Wed, 10 Nov 2021 19:51:02 -0000
Date:   Wed, 10 Nov 2021 13:51:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     patrice.chotard@foss.st.com
Cc:     linux-i2c@vger.kernel.org,
        olivier moysan <olivier.moysan@foss.st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        dillon min <dillon.minfei@gmail.com>,
        yannick fertre <yannick.fertre@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        linux-spi@vger.kernel.org,
        thierry reding <thierry.reding@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Amit Kucheria <amitk@kernel.org>,
        dri-devel@lists.freedesktop.org, david airlie <airlied@linux.ie>,
        linux-iio@vger.kernel.org, linux-rtc@vger.kernel.org,
        jonathan cameron <jic23@kernel.org>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        daniel vetter <daniel@ffwll.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Zyngier <maz@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-media@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "david s . miller" <davem@davemloft.net>,
        alsa-devel@alsa-project.org, Guenter Roeck <linux@roeck-us.net>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        dmaengine@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Jakub Kicinski <kuba@kernel.org>,
        lars-peter clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Le Ray <erwan.leray@foss.st.com>,
        pascal Paillet <p.paillet@foss.st.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        ohad ben-cohen <ohad@wizery.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-watchdog@vger.kernel.org,
        philippe cornu <philippe.cornu@foss.st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-serial@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-gpio@vger.kernel.org,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-phy@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        linux-arm-kernel@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Paul Cercueil <paul@crapouillou.net>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        sam ravnborg <sam@ravnborg.org>, vinod koul <vkoul@kernel.org>,
        linux-remoteproc@vger.kernel.org, linux-mtd@lists.infradead.org,
        michael turquette <mturquette@baylibre.com>,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-usb@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        linux-crypto@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        Marek Vasut <marex@denx.de>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        baolin wang <baolin.wang7@gmail.com>,
        stephen boyd <sboyd@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        herbert xu <herbert@gondor.apana.org.au>,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH v3 3/5] dt-bindings: media: Update maintainers for
 st,stm32-cec.yaml
Message-ID: <YYwipuVeW+U9LgXa@robh.at.kernel.org>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-4-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150144.18272-4-patrice.chotard@foss.st.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:01:42 +0100, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Benjamin has left the company, remove his name from maintainers.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> ---
>  Documentation/devicetree/bindings/media/st,stm32-cec.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Applied, thanks!
