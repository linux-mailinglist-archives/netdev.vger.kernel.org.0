Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546D744C978
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhKJTwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:52:41 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:39884 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhKJTwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:52:37 -0500
Received: by mail-ot1-f54.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso5545847ots.6;
        Wed, 10 Nov 2021 11:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jffv+4OBBpjkkC43YZCngYWCvEJMwZVhqAxEmFK8L/I=;
        b=MQxfkCCi2v2hsTKxKKuRvH/yTYF6TvDBR2IkrVLa3FgtYNkKDKAvhOX7hlWsN/EjhA
         6++46uomlk3KOlLKNE7k9u0dvTqAYLBDLBZHQ6HZ0YNytxlA4y10ptz371mCGPzRsGCh
         h/a/SsGW1e01hZkI9vuDR0obEq//YfAcPrQcEkR3WlwdocoMFfFIa0rrHuQ05Dj1v7Bs
         82C3y+q4e6XXDZhAOfJPbSFyCn79J9t2hGE0w/Ewrs5NUPg4+q8n4DYanW8Ynzb/VWIy
         6f8vx0BJyPV++gOnPVlNcixBtHRHKxqWz9RYhzjUgosiC3OOv6ZFWvz8ZIdnRilx7ChI
         4D/w==
X-Gm-Message-State: AOAM531HkJ2fCFC3fCq5mihHJeLsLKt6n9DZ2HfLf+TVea7JNQpnA2PV
        +2/L2NW0LazGv+oEF/CAnQ==
X-Google-Smtp-Source: ABdhPJyfVpmfG+ubS7aEU1ww03RUaTffAeDZHobEFdd7aYoPfW2ZAH5HMpiQ+tL5kGtHFO9Urrh52g==
X-Received: by 2002:a9d:67c1:: with SMTP id c1mr1412382otn.299.1636573788340;
        Wed, 10 Nov 2021 11:49:48 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id p14sm130082oov.0.2021.11.10.11.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:49:47 -0800 (PST)
Received: (nullmailer pid 1843729 invoked by uid 1000);
        Wed, 10 Nov 2021 19:49:44 -0000
Date:   Wed, 10 Nov 2021 13:49:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     patrice.chotard@foss.st.com
Cc:     Sebastian Reichel <sre@kernel.org>,
        dri-devel@lists.freedesktop.org,
        thierry reding <thierry.reding@gmail.com>,
        linux-iio@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        herbert xu <herbert@gondor.apana.org.au>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-remoteproc@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mtd@lists.infradead.org,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        "david s . miller" <davem@davemloft.net>,
        olivier moysan <olivier.moysan@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-clk@vger.kernel.org,
        michael turquette <mturquette@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, netdev@vger.kernel.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        Amit Kucheria <amitk@kernel.org>, dmaengine@vger.kernel.org,
        linux-usb@vger.kernel.org, dillon min <dillon.minfei@gmail.com>,
        yannick fertre <yannick.fertre@foss.st.com>,
        linux-watchdog@vger.kernel.org, ohad ben-cohen <ohad@wizery.com>,
        Le Ray <erwan.leray@foss.st.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        devicetree@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-spi@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-i2c@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        david airlie <airlied@linux.ie>, alsa-devel@alsa-project.org,
        baolin wang <baolin.wang7@gmail.com>,
        philippe cornu <philippe.cornu@foss.st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        daniel vetter <daniel@ffwll.ch>, linux-media@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        linux-crypto@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Zhang Rui <rui.zhang@intel.com>,
        jonathan cameron <jic23@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        sam ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marek Vasut <marex@denx.de>, linux-phy@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        vinod koul <vkoul@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        lars-peter clausen <lars@metafoo.de>,
        linux-serial@vger.kernel.org,
        pascal Paillet <p.paillet@foss.st.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        stephen boyd <sboyd@kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/5] dt-bindings: timer: Update maintainers for
 st,stm32-timer
Message-ID: <YYwiWGn0ehnD4nDZ@robh.at.kernel.org>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-2-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150144.18272-2-patrice.chotard@foss.st.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:01:40 +0100, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Benjamin has left the company, add Fabrice and myself as maintainers.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> ---
>  Documentation/devicetree/bindings/timer/st,stm32-timer.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Applied, thanks!
