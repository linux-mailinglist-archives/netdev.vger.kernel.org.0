Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C18B434A4B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJTLlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhJTLla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:41:30 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCC3611B0;
        Wed, 20 Oct 2021 11:39:15 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.misterjones.org)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1md9w8-000Q93-UK; Wed, 20 Oct 2021 12:39:13 +0100
Date:   Wed, 20 Oct 2021 12:39:11 +0100
Message-ID: <878ryoc4dc.wl-maz@kernel.org>
From:   Marc Zyngier <maz@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        patrice.chotard@foss.st.com
Cc:     Rob Herring <robh+dt@kernel.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        michael turquette <mturquette@baylibre.com>,
        stephen boyd <sboyd@kernel.org>,
        herbert xu <herbert@gondor.apana.org.au>,
        "david s . miller" <davem@davemloft.net>,
        david airlie <airlied@linux.ie>,
        daniel vetter <daniel@ffwll.ch>,
        thierry reding <thierry.reding@gmail.com>,
        sam ravnborg <sam@ravnborg.org>,
        yannick fertre <yannick.fertre@foss.st.com>,
        philippe cornu <philippe.cornu@foss.st.com>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        vinod koul <vkoul@kernel.org>,
        ohad ben-cohen <ohad@wizery.com>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        baolin wang <baolin.wang7@gmail.com>,
        jonathan cameron <jic23@kernel.org>,
        lars-peter clausen <lars@metafoo.de>,
        olivier moysan <olivier.moysan@foss.st.com>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jagan Teki <jagan@amarulasolutions.com>,
        dillon min <dillon.minfei@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        pascal Paillet <p.paillet@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Le Ray <erwan.leray@foss.st.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        dmaengine@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: dt-bindings: treewide: Update @st.com email address to @foss.st.com
In-Reply-To: <22fb6f19-21eb-dcb5-fa31-bb243d4a7eaf@canonical.com>
References: <20211020065000.21312-1-patrice.chotard@foss.st.com>
        <22fb6f19-21eb-dcb5-fa31-bb243d4a7eaf@canonical.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/27.1
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: krzysztof.kozlowski@canonical.com, patrice.chotard@foss.st.com, robh+dt@kernel.org, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com, mturquette@baylibre.com, sboyd@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, airlied@linux.ie, daniel@ffwll.ch, thierry.reding@gmail.com, sam@ravnborg.org, yannick.fertre@foss.st.com, philippe.cornu@foss.st.com, benjamin.gaignard@linaro.org, vkoul@kernel.org, ohad@wizery.com, bjorn.andersson@linaro.org, baolin.wang7@gmail.com, jic23@kernel.org, lars@metafoo.de, olivier.moysan@foss.st.com, arnaud.pouliquen@foss.st.com, tglx@linutronix.de, jassisinghbrar@gmail.com, mchehab@kernel.org, hugues.fruchet@foss.st.com, fabrice.gasnier@foss.st.com, lee.jones@linaro.org, miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com, kuba@kernel.org, srinivas.kandagatla@linaro.org, kishon@ti.com, linus.walleij@linaro.org, lgirdwood@gmail.com, broonie@kernel.org, mathieu.poirier@linaro.org, mpm@selenic.com, a.zummo@towertech.i
 t, alexandre.belloni@bootlin.com, gregkh@linuxfoundation.org, rafael@kernel.org, daniel.lezcano@linaro.org, amitk@kernel.org, rui.zhang@intel.com, wim@linux-watchdog.org, linux@roeck-us.net, geert+renesas@glider.be, viresh.kumar@linaro.org, a.fatoum@pengutronix.de, jagan@amarulasolutions.com, dillon.minfei@gmail.com, marex@denx.de, laurent.pinchart@ideasonboard.com, sre@kernel.org, dmitry.torokhov@gmail.com, paul@crapouillou.net, fabien.dessenne@foss.st.com, christophe.roullier@foss.st.com, gabriel.fernandez@foss.st.com, lionel.debieve@foss.st.com, amelie.delaunay@foss.st.com, pierre-yves.mordret@foss.st.com, ludovic.barre@foss.st.com, christophe.kerello@foss.st.com, p.paillet@foss.st.com, peppe.cavallaro@st.com, joabreu@synopsys.com, erwan.leray@foss.st.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
  dmaengine@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org, alsa-devel@alsa-project.org, linux-media@vger.kernel.org, linux-mtd@lists.infradead.org, netdev@vger.kernel.org, linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org, linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, linux-pm@vger.kernel.org, linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 08:45:02 +0100,
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:
> 
> On 20/10/2021 08:50, patrice.chotard@foss.st.com wrote:
> > From: Patrice Chotard <patrice.chotard@foss.st.com>
> > 
> > Not all @st.com email address are concerned, only people who have
> > a specific @foss.st.com email will see their entry updated.
> > For some people, who left the company, remove their email.
> > 
> 
> Please split simple address change from maintainer updates (removal,
> addition).
> 
> Also would be nice to see here explained *why* are you doing this.

And why this can't be done with a single update to .mailmap, like
anyone else does.

	M.

-- 
Without deviation from the norm, progress is not possible.
