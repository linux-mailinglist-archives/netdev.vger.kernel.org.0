Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADACF44C9B5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhKJTyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:54:25 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:45970 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhKJTyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:54:14 -0500
Received: by mail-ot1-f51.google.com with SMTP id l7-20020a0568302b0700b0055ae988dcc8so5516055otv.12;
        Wed, 10 Nov 2021 11:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ObzL7zoc4FaanTV0FRdsY2Jh7qTWU6rDhJWsEvGiEMQ=;
        b=Dh1GhuFEKHMaMrjD2FFor8CWCUIi06PHjvJiZK804BDnqCg9NLJTTtw35vdjRoWVMn
         HKs7fceD7Q5fK++w3v6DV4P2jh4kACUfj5BdDxG08TPtTBXz9/nUb7+NjXcE0iXN/QIM
         X1quYDbnaR/1U7Tqyw9yKzPjYU4QTzCggXcJ0QRkT5PBUhzogEro/SYpxNxDhdn6drY9
         4Jd3E9jJz0UtOVWCWiztZeFD/e2b0wJdTc0BmkE8l9QGeK8d5sGSS6hJToFwNQxA3n4P
         Qirelh2ik6YCWnaltPHT8Qac5eulSz10O25OZzZuzRIouT+eBAcYrgU9ejsqvnlqCa5J
         Nedg==
X-Gm-Message-State: AOAM533Y0ROQrSBCPIOMA9sDpr0tlI20aybaT5bzM8P0m+Jma/XEXcWF
        58MkERgIgjeF9Di1hxti+g==
X-Google-Smtp-Source: ABdhPJyc+9+E+QZMI61J8RiueoqqJVjd5eWhNxneY0MS3rvPxMprKNWZtdE0NAi9tMvBLGJnnztoeA==
X-Received: by 2002:a9d:bf2:: with SMTP id 105mr1475029oth.21.1636573885318;
        Wed, 10 Nov 2021 11:51:25 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bb39sm213735oib.28.2021.11.10.11.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:51:24 -0800 (PST)
Received: (nullmailer pid 1851374 invoked by uid 1000);
        Wed, 10 Nov 2021 19:51:21 -0000
Date:   Wed, 10 Nov 2021 13:51:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     patrice.chotard@foss.st.com
Cc:     linux-i2c@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        dri-devel@lists.freedesktop.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-gpio@vger.kernel.org, daniel vetter <daniel@ffwll.ch>,
        linux-crypto@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        yannick fertre <yannick.fertre@foss.st.com>,
        Marek Vasut <marex@denx.de>, Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        pascal Paillet <p.paillet@foss.st.com>,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        michael turquette <mturquette@baylibre.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        jonathan cameron <jic23@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-media@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmaengine@vger.kernel.org,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-remoteproc@vger.kernel.org,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Matt Mackall <mpm@selenic.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        baolin wang <baolin.wang7@gmail.com>,
        lars-peter clausen <lars@metafoo.de>, netdev@vger.kernel.org,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        david airlie <airlied@linux.ie>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        linux-iio@vger.kernel.org,
        olivier moysan <olivier.moysan@foss.st.com>,
        ohad ben-cohen <ohad@wizery.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        linux-spi@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        herbert xu <herbert@gondor.apana.org.au>,
        philippe cornu <philippe.cornu@foss.st.com>,
        linux-mtd@lists.infradead.org, stephen boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@kernel.org>, linux-serial@vger.kernel.org,
        "david s . miller" <davem@davemloft.net>,
        dillon min <dillon.minfei@gmail.com>,
        alsa-devel@alsa-project.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        linux-phy@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>,
        Le Ray <erwan.leray@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-rtc@vger.kernel.org, linux-clk@vger.kernel.org,
        sam ravnborg <sam@ravnborg.org>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Marc Zyngier <maz@kernel.org>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        vinod koul <vkoul@kernel.org>,
        thierry reding <thierry.reding@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v3 4/5] dt-bindings: media: Update maintainers for
 st,stm32-hwspinlock.yaml
Message-ID: <YYwiuItyk2NtQC4v@robh.at.kernel.org>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-5-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110150144.18272-5-patrice.chotard@foss.st.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:01:43 +0100, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Benjamin has left the company, remove his name from maintainers.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> ---
>  .../devicetree/bindings/hwlock/st,stm32-hwspinlock.yaml          | 1 -
>  1 file changed, 1 deletion(-)
> 

Applied, thanks!
