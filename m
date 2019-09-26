Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A1DBF470
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfIZNwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:52:31 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35449 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfIZNwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:52:31 -0400
Received: by mail-ot1-f65.google.com with SMTP id z6so2073670otb.2
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 06:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSzbHUFIH9s2C//2dWhNKKxkGVyk8CmSMswLpeoC9Uo=;
        b=hKFQcn22TcB+L2qUJ41Ziy5GPqbUFjqDfo7So6XVekBMiibhG0btaRY6eLTPiPYPh5
         0/lB3Y3pENag+1lJ44l5xI13AdLR9XSORUWKRa1AHWsrgiL3LPaRqj6euZOhWHP2J96W
         S6n7twGINSaGtvyB5U57oFBBMcciox9yzmpNp6E1xLBP+lZ3rqf27DiIs0HnnQLczldO
         6d6eNbAxGu6dscYhX+/Wmzu6hQhV3VaT4xjj87e3TOcel0PqV0mahMKTvFQH6UJfxpr2
         y/JRm1e5+Izb638nQUaPZUE7wg4omK57BPD8P/8uPYpctYD0ZT4AG8TkEpdTFXhGVF7U
         DXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSzbHUFIH9s2C//2dWhNKKxkGVyk8CmSMswLpeoC9Uo=;
        b=mkiZkb5Xuxz+Y1ZsCyqAd29DGAuJt429GLO61bI5JJvT7YjdN8LTS6LuX1f56yB0bA
         6yJY82YChIQ42JOHEawjZpQJEMJN3uJtPOVINYqKPPHhaupFmRy/IT46UOcWsZKXQh3k
         NrSBg7Yh2hE3966enSvMmA3R+Z9MNA2iiAhpRi4XdbZFR3rk2lcBOI2JMsfIkOn/IcFc
         G+ZXiQpgqv8cYIXiNds+VyzjlV/m9DdfCABF+f5KzyLYcs8VTljBztAiYE63+xHxl0fJ
         e/V18gIjr8N0YNfFeDd+Oq4ZDMGcSXNLfnsz/EpZJkRW3UEG8u+xK6vEmaYDcwgNP0v7
         kzxg==
X-Gm-Message-State: APjAAAWzMQJpNdriFR+22CMMquogDs9aC1p/a/oqcXP5hRGwWC3SyIcL
        1JKg0uywVWiVn7q5eWq1CW7lgI+Chqkyxx7nYQ==
X-Google-Smtp-Source: APXvYqxR1GQKhw5A28k8u+MoDmnJhxBQ/iNjvd5W6hGV7I9Pjb3yViPh7sKfJuJthw2npm9UrXN4hcqqAhZ7KXGkx6c=
X-Received: by 2002:a05:6830:1617:: with SMTP id g23mr2579291otr.366.1569505949178;
 Thu, 26 Sep 2019 06:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190925220842.4301-1-marex@denx.de>
In-Reply-To: <20190925220842.4301-1-marex@denx.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 26 Sep 2019 08:52:17 -0500
Message-ID: <CAFSKS=PFBewpMiMXuPmJXqv=sbYhS8_9k=DrwAXjjPNi7xFwcA@mail.gmail.com>
Subject: Re: [PATCH V2] net: dsa: microchip: Always set regmap stride to 1
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 5:08 PM Marek Vasut <marex@denx.de> wrote:
>
> The regmap stride is set to 1 for regmap describing 8bit registers already.
> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
> is not correct, as the switch protocol supports unaligned register reads
> and writes and the KSZ87xx even uses such unaligned register accesses to
> read e.g. MIB counter.
>
> This patch fixes MIB counter access on KSZ87xx.

After looking through a couple hundred pages of register documentation
for KSZ9477 and KSZ9567 I find only registers that are aligned to
their width. In my testing the KSZ9567 works fine with and without the
patch. The only downside is that all of the unaligned registers
needlessly show up in the debugfs regmap, this doesn't really matter
though. As long as it fixes the issues on KSZ87xx this looks fine to
me.

>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> Fixes: 46558d601cb6 ("net: dsa: microchip: Initial SPI regmap support")
> Fixes: 255b59ad0db2 ("net: dsa: microchip: Factor out regmap config generation into common header")
> ---
> V2: Add Fixes: tags
> ---
>  drivers/net/dsa/microchip/ksz_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index a24d8e61fbe7..dd60d0837fc6 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -303,7 +303,7 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
>         {                                                               \
>                 .name = #width,                                         \
>                 .val_bits = (width),                                    \
> -               .reg_stride = (width) / 8,                              \
> +               .reg_stride = 1,                                        \
>                 .reg_bits = (regbits) + (regalign),                     \
>                 .pad_bits = (regpad),                                   \
>                 .max_register = BIT(regbits) - 1,                       \
> --
> 2.23.0
>

Reviewed-by: George McCollister <george.mccollister@gmail.com>

I tested the patch on the KSZ9567, not anything else FWIW:
Tested-by: George McCollister <george.mccollister@gmail.com>
