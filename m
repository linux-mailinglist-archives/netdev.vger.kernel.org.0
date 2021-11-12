Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF644E282
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhKLHpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbhKLHpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 02:45:33 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC3CC061208
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:42:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso9151886wml.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d4YpBbYWP9wG3LFBKWknnju7IW21BdQrAXLAFoUfJjk=;
        b=L0G7vqzIu4OmVtWPcfcfA5NzLtPk2i0H7s2BzObNlHQTFEkm03sqk/2QHQ4kjpk9BH
         XMXouE5QpmwrxFfo6B5ZLvuccwWWhT/w9Ko9Yi7L+7BfDDnicqyRLnT+TM8ck5H5bQEY
         cyD6P6qfh9iWldNqTQR7o5UJ+sXkSMXyDzLNU6kkBq7ka/+ZuUqEk/qcSbQ3GxXC7kiU
         cm9dyledHK9n0gr3crraQGaAfhd3vfTQwfXVu/kwmwojjE1dRCSgNEVgeiJJB70r7ke9
         OYePQHHEPa/usZJXytv516/nCeAGVXFsmZBOHnIcNaOTOhsULeXowN7ikvsxKqOo/gxw
         3O2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d4YpBbYWP9wG3LFBKWknnju7IW21BdQrAXLAFoUfJjk=;
        b=AkpSn/DapfdRudD+tASTk0NY7oJ1LKJ4d68HfelexMC6vf/OREb5it91t8hnORpMPH
         zIQoJa5s3B8SL7HQrPWqPCYXy8VxkG0ny58N7yfskqM32uSqa4ArgTbQwAlBWM8FN3BU
         D6VM+/4WhTkC2f9PyLlpbUNqxXPn5lmYNex/PBMG+04C+nNiKW/OUm13zT0QvaDb74rS
         bYRMdKT6vnHqKH6oeJk//41FQfcWI6sJSJRoSIuWv15srgDMvn/PAK2GbYhJlASxmcno
         IejKo4pD2wVBbGZ1sVkMjnBjt2JpjaK6A+zW/2/vkpVZGPr1ecPWFdfs53Fg/Ge56nPV
         4p2A==
X-Gm-Message-State: AOAM531fpppHUiOdZyqAADenKBZGxT5fZvTWsz0NvyKtPDL4KuCVm5iT
        /UeGmirdwsNCKjmIGVpYegyrmw==
X-Google-Smtp-Source: ABdhPJyYtg+MHn61GMl0MRFqSO/sm1wnHgrm7yORmq7WT7ihtvN7d0mp317CBhRDaom5mAlXGDszmg==
X-Received: by 2002:a05:600c:2107:: with SMTP id u7mr32377342wml.82.1636702961238;
        Thu, 11 Nov 2021 23:42:41 -0800 (PST)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id q8sm4978469wrx.71.2021.11.11.23.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 23:42:40 -0800 (PST)
Date:   Fri, 12 Nov 2021 07:42:37 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     patrice.chotard@foss.st.com, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        jonathan cameron <jic23@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        olivier moysan <olivier.moysan@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
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
Message-ID: <YY4a7ZxzhNq6Or+t@google.com>
References: <20211110150144.18272-1-patrice.chotard@foss.st.com>
 <20211110150144.18272-3-patrice.chotard@foss.st.com>
 <YYwjPAoCtuM6iycz@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYwjPAoCtuM6iycz@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021, Rob Herring wrote:

> On Wed, 10 Nov 2021 16:01:41 +0100, patrice.chotard@foss.st.com wrote:
> > From: Patrice Chotard <patrice.chotard@foss.st.com>
> > 
> > Benjamin has left the company, remove his name from maintainers.
> > 
> > Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> 
> Lee indicated he was going to pick this one up, so:
> 
> Acked-by: Rob Herring <robh@kernel.org>

Since you already merged the treewide patch, you may as well take
this too.  We'll work through any conflicts that may occur as a
result.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
