Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5C3AC01
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 23:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfFIVVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 17:21:12 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39607 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfFIVVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 17:21:12 -0400
Received: by mail-ot1-f65.google.com with SMTP id r21so6552123otq.6;
        Sun, 09 Jun 2019 14:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILeRyRcjcESncIl+P40HqpETCX7L+NY2Xryuox2AyAU=;
        b=vA8aLg9fXf3AMIkpttufBddw8qtRPGAoEkExHeDBLzOR4ig+7ulCusH6Lq+Zfq8Qy5
         n27AtawXPi6N876u0WAnmpjFukegBqhtfOW/ivahVb3zJx84+aXeWYfmY/OxlTSL+60z
         pPIp2tpUv36aNJY8n/MYH5MSJcHb2SNryQAWScuOiMrGIzF2uO8eI0Gr6Wb6Gp4DaMBU
         jexUiHzfshPGcZCvgWMl3ZEua5Wax4mKYIBULPDfCC4gchorb1Csg6suVmgsML8voafP
         aTaX4gv7DsUxW5b9B20uLabF+OX3m0RmUUEyB77CsWTj8DKhnic5nkMeGNUYSfiJxWAZ
         T2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILeRyRcjcESncIl+P40HqpETCX7L+NY2Xryuox2AyAU=;
        b=tIjZROOSwNIhZnWRmMCSEqCcTVLsJVbYk7eBU++OzVQDl1jnUH0N55rn7fgHe8yiYJ
         0hEzjrTH9JaiytBEdTt5Zr9ZT1ts7+E7xmQ+vwsfwBBGdLPAEJCx0HvZRE/j2vh7e9VP
         qWFNU/L4xrh2xZXTRaFpxUNK96Is53NqMfy9X0/A8ZyJsp1vbSv/QvuPVQPeA1lDFm85
         4mWu9PevbR/5u8JmjZX+mVbnZobtYBFbsRl8dioQYJxvGBqTkgFuDOqa/j9BRbl6QZ/o
         IvJJ7dcMLkBF1mZ2EKRKVXjBNlhkb1GTIiVzcCuLJaLAqVv3xsYq/xExXQKxvJG3e0bA
         jcog==
X-Gm-Message-State: APjAAAWvJzR+ZVnXbckbsVAkRSXlTuGOYCIqgAvhj/sajNtZjH9Xri1O
        eWUPbeRelUWvrxwKG6+OmEln9iKUPIJd2eCbfSgGqg==
X-Google-Smtp-Source: APXvYqxchWD3SK/5TgN7AGYLIIb5pfYYcmdM95qajFTt87HFoDR3f82VHMstyE2SNxDn2jQ7NIGHtL0BVjkO1m192S0=
X-Received: by 2002:a9d:6405:: with SMTP id h5mr16556583otl.42.1560115271456;
 Sun, 09 Jun 2019 14:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609180621.7607-3-martin.blumenstingl@googlemail.com> <20190609203828.GA8247@lunn.ch>
In-Reply-To: <20190609203828.GA8247@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 9 Jun 2019 23:21:00 +0200
Message-ID: <CAFBinCA1xp5+77DhYMFjX31D3DsaU7d9EqFkWbn+UFFx5LSqEw@mail.gmail.com>
Subject: Re: [RFC next v1 2/5] gpio: of: parse stmmac PHY reset line specific
 active-low property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Jun 9, 2019 at 10:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Jun 09, 2019 at 08:06:18PM +0200, Martin Blumenstingl wrote:
> > The stmmac driver currently ignores the GPIO flags which are passed via
> > devicetree because it operates with legacy GPIO numbers instead of GPIO
> > descriptors.
>
> Hi Martin
>
> I don't think this is the reason. I think historically stmmac messed
> up and ignored the flags. There are a number of device tree blobs
> which have the incorrect flag value, but since it was always ignored,
> it did not matter. Then came along a board which really did need the
> flag, but it was too late, it could not be enabled because too many
> boards would break. So the hack was made, and snps,reset-active-low
> was added.
that seems appropriate. I don't know whether you can fetch the GPIO
flags when using legacy GPIO numbers.
so it may also be a mix of your explanation and mine.
in the end it's the same though: stmmac ignores the GPIO flags

> Since snps,reset-active-low is a hack, it should not be in the
> core. Please don't add it to gpiolib-of.c, keep it within stmmac
> driver.
I don't know how to keep backwards compatibility with old .dtb / .dts
when moving this into the stmmac driver again.

let's assume I put the "snps,reset-active-low" inversion logic back into stmmac.
then I need to ignore the flags because some .dts file use the flag
GPIO_ACTIVE_LOW *and* set "snps,reset-active-low" at the same time.
"snps,reset-active-low" would then invert GPIO_ACTIVE_LOW again, which
basically results in GPIO_ACTIVE_HIGH

however, I can't ignore the flags because then I'm losing the
information I need for the newer Amlogic SoCs like open drain / open
source.

so the logic that I need is:
- use GPIO flags from .dtb / .dts
- set GPIO_ACTIVE_LOW in addition to the flags if
"snps,reset-active-low" is set (this is different to "always invert
the output value")

my understanding that of_gpio_flags_quirks (which I'm touching with
this patch) is supposed to manage similar quirks to what we have in
stmmac (it also contains some regulator and MMC quirks too).
however, that's exactly the reason why I decided to mark this as RFC -
so I'm eager to hear Linus comments on this


Martin
