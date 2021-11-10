Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FCE44C9DD
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhKJT43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:56:29 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:42895 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhKJT4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:56:24 -0500
Received: by mail-ot1-f43.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso5557492otg.9;
        Wed, 10 Nov 2021 11:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtQL/sbdzpxz6Lu8ElJAZUiYQnGOPRjAvEo183EhEZQ=;
        b=Y+G/EpUnkYeRwidEQcxcB/bCKh8UXs/sQt22sSAO1wgkYWmb6nrJ7MuuHhQul2ci8j
         2CwHUXM2ymOtKrduUBQB+2NKgfo1yAiFZ3j6AQ3PxM07YMklELUttcvWqG0omYwHl/sV
         yq8ZNsn3uiX3CnIQsK4DPopYdZ06Tq2RKg71EImg75aZyWplCShG2+E4b+BN9TypjKq/
         mxKnFrAPVWtMfZ5FpoGYvy/PhT51mw5okPo70sezswBDfmXPIo1gcvzoTOUMmdMFJ1J6
         XUoK7OrbJdyduylqzZ0cXRPntrMYyIIcF9X993qFHhgxve4XP2bRPSjR8QOauLAvH5kc
         sZwA==
X-Gm-Message-State: AOAM532SQ0biJ93+S/ljBKB2KNqVAnkdvc6jx23hWkd0WvEF1lIpE4E4
        TbYwou8v7aIAf5FdWCwmag==
X-Google-Smtp-Source: ABdhPJzPMoAqV3AUGDDa1G/mcQBg1/+e3vLu75Mv4kA30QovRpmA/hmvXuDtC6I5AysjT0t7pidUQg==
X-Received: by 2002:a9d:6a4e:: with SMTP id h14mr1449816otn.134.1636574015905;
        Wed, 10 Nov 2021 11:53:35 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j7sm129827oon.13.2021.11.10.11.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:53:35 -0800 (PST)
Received: (nullmailer pid 1864115 invoked by uid 1000);
        Wed, 10 Nov 2021 19:53:32 -0000
Date:   Wed, 10 Nov 2021 13:53:32 -0600
From:   Rob Herring <robh@kernel.org>
To:     patrice.chotard@foss.st.com
Cc:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        jonathan cameron <jic23@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        olivier moysan <olivier.moysan@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-mtd@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        Matt Mackall <mpm@selenic.com>, vinod koul <vkoul@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        baolin wang <baolin.wang7@gmail.com>,
        linux-spi@vger.kernel.org, david airlie <airlied@linux.ie>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        netdev@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        ohad ben-cohen <ohad@wizery.com>, linux-gpio@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Le Ray <erwan.leray@foss.st.com>,
        herbert xu <herbert@gondor.apana.org.au>,
        michael turquette <mturquette@baylibre.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        linux-serial@vger.kernel.org, Amit Kucheria <amitk@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        "david s . miller" <davem@davemloft.net>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-i2c@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        thierry reding <thierry.reding@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        philippe cornu <philippe.cornu@foss.st.com>,
        linux-rtc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        alsa-devel@alsa-project.org, Zhang Rui <rui.zhang@intel.com>,
        linux-crypto@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-iio@vger.kernel.org, pascal Paillet <p.paillet@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        linux-pm@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stephen boyd <sboyd@kernel.org>,
        dillon min <dillon.minfei@gmail.com>,
        devicetree@vger.kernel.org,
        yannick fertre <yannick.fertre@foss.st.com>,
        linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-phy@lists.infradead.org,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        sam ravnborg <sam@ravnborg.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Richard Weinberger <richard@nod.at>,
        Rob Herring <robh+dt@kernel.org>, Marek Vasut <marex@denx.de>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Jagan Teki <jagan@amarulasolutions.com>,
        dmaengine@vger.kernel.org, linux-media@vger.kernel.org,
        daniel vetter <daniel@ffwll.ch>, Marc Zyngier <maz@kernel.org>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        lars-peter clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 2/5] dt-bindings: mfd: timers: Update maintainers for
 st,stm32-timers
Message-ID: <YYwjPAoCtuM6iycz@robh.at.kernel.org>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-3-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150144.18272-3-patrice.chotard@foss.st.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:01:41 +0100, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Benjamin has left the company, remove his name from maintainers.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> ---
>  Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Lee indicated he was going to pick this one up, so:

Acked-by: Rob Herring <robh@kernel.org>
