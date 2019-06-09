Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D443AC1C
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfFIVua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 17:50:30 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:39834 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFIVua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 17:50:30 -0400
Received: by mail-lf1-f44.google.com with SMTP id p24so5226237lfo.6
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 14:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=He8uuSEDC/b/uWidg8RVfT3AGe4hP03AsY17X0DSxgk=;
        b=zlJsT0l/3IuyndfDS2BTaHnjJraASu525KwaMplyFARGp91fxTu7ST6SIuVl4iRefh
         Zw2rTEVnDvjnMuSCPzdUGoVDoRp8QrZ61tK4XFRB4D3Zl0L6VgXr//I766ZqEDgE17BM
         ARN60spGcN65rNvB7ab14R7DSGuQndhDP7PBCgB3CP8DrR7V+VOu1ATbAAdkQfPQj4IY
         quGE/acE6nwNwUq5m4i9HC26SOp56AoTeO2Nuk1flxiykzI9jViwQQchw1hlF1ArhsRC
         N14lVBN37nhxWkXhB1kOBhH6Fg5Nahbz9F5Ozo1lzj8nZbQmTBZ4tBPY5d9h7mtBuiCS
         cZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=He8uuSEDC/b/uWidg8RVfT3AGe4hP03AsY17X0DSxgk=;
        b=IZ8G1PbVGRIgRipkOENq707ZjBBRXM9I75Et89zJa07awGD+L9aqbHIs1JWI7T4r6l
         WUmNU/7GcB9fqNmLtniAGJEgLGVT0lcvD9IJVItHqST9yNWx3PH2AdO8BZpVScXLlmnl
         Px0e0aggENZqEK9ACl2mEHEQUnk5/DKmvariHwSMlItWyUAZyu405FwhP1e1cZPmlb4F
         UGaJk5WGbJO4G3SNSFP2XF05sP7o5MFtq9sgll0FGKb5lw+mTZTYQrbhLPC4twrLEods
         jz/ZJqUnxeSKmG94uLtgCI/wQyaqHgNBvE0vGs77rarvlG3nzGnH+ilQ15B0GXBMTPEG
         D6UQ==
X-Gm-Message-State: APjAAAWdlKdJC/Nveo/HYJ4/0SSWQm8Jn36PFNPAIJQB9CsK4Nbjbg5Z
        Xx/nXFF+f3ehWflZveuYIgbld7xZDnwe+IBX1hbBxw==
X-Google-Smtp-Source: APXvYqyf2NDu19vowinqKXukK4VxadyL6zt3qyCVskmgqawUHY4dBR21FjzW4762E23uuSqmCFocFD/qpnabF+6julg=
X-Received: by 2002:a19:dc0d:: with SMTP id t13mr9951237lfg.152.1560117028189;
 Sun, 09 Jun 2019 14:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com> <20190609180621.7607-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20190609180621.7607-4-martin.blumenstingl@googlemail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 9 Jun 2019 23:50:21 +0200
Message-ID: <CACRpkdZCbFiUfW-qOM1Hxuj0e5TC8ViMuiz-VeVjSYP8A9sN3A@mail.gmail.com>
Subject: Re: [RFC next v1 3/5] net: stmmac: use GPIO descriptors in stmmac_mdio_reset
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 9, 2019 at 8:06 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:

> Switch stmmac_mdio_reset to use GPIO descriptors. GPIO core handles the
> "snps,reset-gpio" for GPIO descriptors so we don't need to take care of
> it inside the driver anymore.
>
> The advantage of this is that we now preserve the GPIO flags which are
> passed via devicetree. This is required on some newer Amlogic boards
> which use an Open Drain pin for the reset GPIO. This pin can only output
> a LOW signal or switch to input mode but it cannot output a HIGH signal.
> There are already devicetree bindings for these special cases and GPIO
> core already takes care of them but only if we use GPIO descriptors
> instead of GPIO numbers.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

This is in line with how I want the gpiolib to just swallow all quirks,
so:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
