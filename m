Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BD53D016C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhGTRfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhGTRe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:34:57 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6590C061768;
        Tue, 20 Jul 2021 11:15:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r11so26972587wro.9;
        Tue, 20 Jul 2021 11:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:content-transfer-encoding:date:message-id:cc:subject
         :from:to:references:in-reply-to;
        bh=hhS705SlOjkRoqTojYTgrsq95q0IEJuqc4XsQcf1hRc=;
        b=cd8j7p6hzpYM2CDZBWvTlYy7pGIlXLU17lyrTUFOhXD6yrR6ygv7WL6ti1WU+HeSO/
         fnTsqAbq4LOPoAFw2Vo8qqNWxzXvtRmEL1euDBs9j8O6TbubOCrVEbY59/V1TW8nYQmD
         zDSQbMpCepP7JRbrfQYhpF8rLB2A8Egvbc6LRQvIWVnZgDT1BRfP7Ni7TlVdCqbxg+U0
         DoC50iEEhHDDlYmqz0uJXqr9uCetgb1pcKaJPv2dCGXpuLHbyUeUr/259exCLwL+7Som
         1ZBRsYw26DtMQaPdGBwQEgpU5PWcfASQ1TKQUWAX49VgxZB4zo4xoqM/Qt9RHS53AxiM
         CDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date
         :message-id:cc:subject:from:to:references:in-reply-to;
        bh=hhS705SlOjkRoqTojYTgrsq95q0IEJuqc4XsQcf1hRc=;
        b=nASbgy1oPsEHH0QuZIpaVCSYneU0/RnKBwlpqjKgpSgOningtzSJFtBP3F2+1U/Rbs
         iD89CDjmtLvb3hUCs2pQfefoWP6nwz889/3dHHpOvDDZKHtu+YrsuzQTEJQNiSM0q0YG
         SrGRDwGAcMNshGuBOfZlDIu8t9bhDqcmqq1TbtZCbaO1Oku/LyCQY2knLK5RMDVTr48P
         a3nlcLZpcuT68Pq5/aCICey43nVofC07+UAtfLfBmbG5DFRfhdbflObrD3W9bvNDtWUT
         m8QYxl314ObJGRJuOULKbVmxEIjP1orygE9yTAv/9gdrLS8R5mdD36Tg0ZHf3T5uSgGw
         en7A==
X-Gm-Message-State: AOAM532HHi0/q396wRUszo8VeolMr4cEtfZd7SWGPq6p8Ql1wALgRPGu
        3H6Mtm4118aekeBA9hwvUNg=
X-Google-Smtp-Source: ABdhPJxLKTXitFRX4kR6CpMpKBy2kBjAfXucf7wNYwW+mqaI3etVNE0PqF25MsCMX6/0mP7aRWmRYA==
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr38817689wrx.114.1626804928215;
        Tue, 20 Jul 2021 11:15:28 -0700 (PDT)
Received: from localhost (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id p5sm19571717wme.2.2021.07.20.11.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 11:15:27 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 20 Jul 2021 19:15:27 +0100
Message-Id: <CCY67UA29K2Q.2DEZ5GOF4HPTR@arch-thunder>
Cc:     <linux-kernel@vger.kernel.org>,
        "Maxime Ripard" <mripard@kernel.org>,
        "Chen-Yu Tsai" <wens@csie.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Sam Ravnborg" <sam@ravnborg.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Robert Marko" <robert.marko@sartura.hr>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        "Ramesh Shanmugasundaram" <rashanmu@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Oleksij Rempel" <o.rempel@pengutronix.de>,
        "ChiYuan Huang" <cy_huang@richtek.com>,
        "Wei Xu" <xuwei5@hisilicon.com>,
        "Dilip Kota" <eswara.kota@linux.intel.com>,
        "Karol Gugala" <kgugala@antmicro.com>,
        "Mateusz Holenko" <mholenko@antmicro.com>,
        "Olivier Moysan" <olivier.moysan@st.com>,
        "Peter Ujfalusi" <peter.ujfalusi@ti.com>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-rtc@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
From:   "Rui Miguel Silva" <rmfrfs@gmail.com>
To:     "Rob Herring" <robh@kernel.org>, <devicetree@vger.kernel.org>
References: <20210720172025.363238-1-robh@kernel.org>
In-Reply-To: <20210720172025.363238-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jul 20, 2021 at 6:20 PM WEST, Rob Herring wrote:

> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
>
> Enabling qca,ar71xx causes a warning, so let's fix the node names:
>
> Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: phy@3: =
'#phy-cells' is a required property
>         From schema: schemas/phy/phy-provider.yaml
>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rui Miguel Silva <rmfrfs@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Robert Marko <robert.marko@sartura.hr>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ramesh Shanmugasundaram <rashanmu@gmail.com>
> Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: ChiYuan Huang <cy_huang@richtek.com>
> Cc: Wei Xu <xuwei5@hisilicon.com>
> Cc: Dilip Kota <eswara.kota@linux.intel.com>
> Cc: Karol Gugala <kgugala@antmicro.com>
> Cc: Mateusz Holenko <mholenko@antmicro.com>
> Cc: Olivier Moysan <olivier.moysan@st.com>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-rtc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../display/allwinner,sun8i-a83t-dw-hdmi.yaml |  2 --
>  .../display/panel/boe,tv101wum-nl6.yaml       |  1 -
>  .../bindings/media/nxp,imx7-mipi-csi2.yaml    |  2 --

Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

Cheers,
   Rui
