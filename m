Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8098283413
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgJEKhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgJEKhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:37:07 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE0C0613CE;
        Mon,  5 Oct 2020 03:37:07 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ce10so11165146ejc.5;
        Mon, 05 Oct 2020 03:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EQcMf3aBHGTHbFtiLcGPyEnLeByAfRIiKvJYpM7dHjI=;
        b=JMXtpOzBphG2KW05zXFj2vXclgc2K+H8JNLe4wZm7v+D9biCrsBBlunvumrZBdu1ay
         dGsC3P+vCBgpuvq8Us5VYT17QD/j1PGdTs3yayROXo3Im6WBME+yzVPRs9dhmCnhv+Kp
         deAaGEl4mX/k8HNSg+lcAp97KgIlUIgmSSwwdLTGDqN7XE8+lWKnDQvOaVfL9MZ14U+a
         QRIvo/0Rw3hXEZYEYP0VkWPlkV5tVRSOzoq3CiZiRn3rvyx0WeBnBNIUIK3FrMGOYn9N
         QIQdKyuVIgtZvtCvpApddnOAphNZZn8AUAHtmpPXbjSAxqojzQj+J6GDsnofUdkYSHTP
         MAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EQcMf3aBHGTHbFtiLcGPyEnLeByAfRIiKvJYpM7dHjI=;
        b=GTjT0sqgscirFuksdmXhumGdg9b7CDq+MuYYKd/R/tiveGwbYDIsoVDOonn3+CdVZG
         zGnQHQv5HLeyQC1vdwUY0CQJ9C7JFuUApte2C8IbnOSboyF0BKedtG288fjX7st+OBQ1
         9g8621CtHzat/D6890n/ih3J30ugDkacwKA3tyv1vENQk7JmMuJFcSwThFl4o/0Q5a24
         ByJWNHeV1Uv9Edk5xHosWLmCBM3NATuXfCDaPGX6BZHKFQ8NszqQ8tCO1RRiSNYbwYRp
         ka2FFVC3MTIUoW4HJyU0SimKcFXz31tSLnOgFZBFKyn8S3ykM6K37lEJaKJ3cSJiyJ4t
         p53w==
X-Gm-Message-State: AOAM5337dIcGvB9GV+KsxhVtmS+4COZ0Qa1NSuAir03dDOQ+oekzj5Y/
        XDaNJ8qvSWUpaD+I/F7q+t8=
X-Google-Smtp-Source: ABdhPJyAUrA9v+oT7mNxthuQoeotTCXMOOGXsGx3LdAG3pM2W9hPKJEenugRGvwJUGZXAZHqegPZ7g==
X-Received: by 2002:a17:906:6545:: with SMTP id u5mr14725364ejn.346.1601894226145;
        Mon, 05 Oct 2020 03:37:06 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id yz15sm7567670ejb.9.2020.10.05.03.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 03:37:04 -0700 (PDT)
Date:   Mon, 5 Oct 2020 12:37:03 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Another round of adding missing
 'additionalProperties'
Message-ID: <20201005103703.GN425362@ulmo>
References: <20201002234143.3570746-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CQDko/0aYvuiEzgn"
Content-Disposition: inline
In-Reply-To: <20201002234143.3570746-1-robh@kernel.org>
User-Agent: Mutt/1.14.7 (2020-08-29)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CQDko/0aYvuiEzgn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 02, 2020 at 06:41:43PM -0500, Rob Herring wrote:
[...]
>  .../arm/tegra/nvidia,tegra20-pmc.yaml         |  2 ++
[...]
>  .../bindings/sound/nvidia,tegra186-dspk.yaml  |  2 ++
>  .../sound/nvidia,tegra210-admaif.yaml         |  2 ++
>  .../bindings/sound/nvidia,tegra210-dmic.yaml  |  2 ++
>  .../bindings/sound/nvidia,tegra210-i2s.yaml   |  2 ++
[...]
>  .../bindings/usb/nvidia,tegra-xudc.yaml       |  2 ++
[...]

Acked-by: Thierry Reding <treding@nvidia.com>

--CQDko/0aYvuiEzgn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl96908ACgkQ3SOs138+
s6Hn/g/+OAyAW+yLaNZ0EuRduaLOLtd19HpvVqZdf68FWcAxWHANPdIKnVuc++CF
2r+nHjgPy4zI3LGP1bGlgPufCdAapy2QTx9sGt/VeTEOuo9uTjb6J4Y7xXC11qQT
pVI+v4ofSi48FN6vY6VWsotDscDJFLkJy/eZdb1RRuU44SG4dw04Z3fn1STm9wAN
PS6hKtpUTbZYzgI0hngx2Ph30t7fyu18NIRPsKZ6/3WgR4HwD8cdpVi+06ThN3GQ
s5CEQ/J7l9z1tfQhUypxLic1JV21su9fCERZQd96CKyIvcpJ5RByk7d7EnnZ4A53
ZDRzwiymRP29X0IUzvEoHc7XvUP/mIZIkRNtTc3tLGZHZ34+Gc805Hcy5slbzhRz
V+Gl3oXG56OhWLSbyNQXOOlbJJAmdFS1IDAoV752G6kq5fFZ397AW34DLF5YJX0k
lYF3NWBTpuxxWCGuceKkACfscLE1dAifN2Rtgf9mbM1k2mIG7mVa6tdpxJ3sjf8Y
1T0v3HYAwfOKTajaYUY4UYLMIJcZNjjJsw/olvcM6a9c8x/g79W3BgSjS6F/pEww
DtuObW8366dl2WoqlYTJ9eWvKXSbCHRBhPpYLamHRBOBj7HKqGSHyyq0hEGPvd6X
Hr+OJUghj7CHS+5vXEq5oNiT4bE6x9ytJdHNf5hIiRchRu6TeOQ=
=hMJa
-----END PGP SIGNATURE-----

--CQDko/0aYvuiEzgn--
