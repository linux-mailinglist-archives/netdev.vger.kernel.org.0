Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC251F68
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfFYAAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:00:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42747 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbfFYAAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:00:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so24217606edq.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiCzFUU4aNbRFV3l1sNwflHMaLppJlc4JnVU/5ypyo8=;
        b=X208Z3wfqHum+AxSMF/7dLZKR1Gs+gGh6FVyjyQcIGsqj/NWR+m8VO7ytUnzp4M6Yb
         Vt/TcRcNrNw73wNNc5uXM2hh8tBxLSGORLkkM6dKSWC5dWXWKH6OvkKrfLhuPuRbHycZ
         9FZ95ONIk/w6zqSU0cJHDVksp5UYZwgSw02/bg7z7g0hPxTBKtAjMYysSK3JVtatNdZ9
         yi1llfUGH7ZnW7ew0ft5THNaWEsYaBp4TGZY94MoKqbBPgtBGIVFJai8Pt0A0/7Dkkfn
         zvYRP2O7zo2tipMUlqgQdZrRYE5iW0vpPGSRAEQRYoE5dem9nLXhrMLUsNBQ1M05IHVY
         hYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiCzFUU4aNbRFV3l1sNwflHMaLppJlc4JnVU/5ypyo8=;
        b=RIHWYmEBWYVOPR5g53SB9NpzBuwK1VqdoR0pWNmWVNfllLwy75evnrr5IA0oWvLSMd
         b5q1Xp+knxSo2YSr8KBlppC8lm74QCfc4FLFVeTG44o3s0B2+euPBdgZuAPlSTG7NBf/
         s/hIfPMunETTwTlOpVeWEMxJz9GS1CibK6b7ZfC4/LGV+NCrkcWN05UjWry1SLcm8Jnc
         0goZxewKSHmv3I69jzawJ6Kp3Ws151GULoQ9vijrZWeJPsOMPD55g+uFPNdGk6J321j6
         p/QK4LG8RIJmBBciQO0JQU730IB/OqbibAHPY0lGVCtif2uqjx/sPADTXEOt5fHuKOsn
         jvHQ==
X-Gm-Message-State: APjAAAVROnb9v2DKKpkY1B5bCdlfKTX/sOfiBBvgONHIlovvmGJgz+7A
        guzAWw7CM8sbFLqO7b8Gf/90DZQopruKCIsLQp8ADQ==
X-Google-Smtp-Source: APXvYqzVWuoCYfKUDRYpBrM1K1KpirNEkis6Uf5331PJXwpucXwRhjp+EAz1xghAOEaudESyoBiCqOqCv4iKdJgu06I=
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr67158466ejb.230.1561420808172;
 Mon, 24 Jun 2019 17:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190623223508.2713-1-marex@denx.de> <20190623223508.2713-8-marex@denx.de>
 <2bbd5346-5fe1-16d7-327e-5d94950496f2@denx.de>
In-Reply-To: <2bbd5346-5fe1-16d7-327e-5d94950496f2@denx.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Jun 2019 02:59:56 +0300
Message-ID: <CA+h21hpgXxnnRS7Upc1R82ajLum4k-3O9EQDROonO6jtAD+NZw@mail.gmail.com>
Subject: Re: [PATCH V3 07/10] net: dsa: microchip: Initial SPI regmap support
To:     Marek Vasut <marex@denx.de>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 at 01:17, Marek Vasut <marex@denx.de> wrote:
>
> On 6/24/19 12:35 AM, Marek Vasut wrote:
> > Add basic SPI regmap support into the driver.
> >
> > Previous patches unconver that ksz_spi_write() is always ever called
> > with len = 1, 2 or 4. We can thus drop the if (len > SPI_TX_BUF_LEN)
> > check and we can also drop the allocation of the txbuf which is part
> > of the driver data and wastes 256 bytes for no reason. Regmap covers
> > the whole thing now.
> >
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Tristram Ha <Tristram.Ha@microchip.com>
> > Cc: Woojung Huh <Woojung.Huh@microchip.com>
>
> [...]
>
> > +#define KS_SPIOP_FLAG_MASK(opcode)           \
> > +     cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
>
> So the robot is complaining about this. I believe this is correct, as
> the mask should be in native endianness on the register and NOT the
> native endianness of the CPU.
>
> I think a cast would help here, e.g.:
> -       cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
> -       (__force unsigned long)cpu_to_be32((opcode) << (SPI_ADDR_SHIFT +
> SPI_TURNAROUND_SHIFT))
>
> Does this make sense ?
>
> > +#define KSZ_REGMAP_COMMON(width)                                     \
> > +     {                                                               \
> > +             .val_bits = (width),                                    \
> > +             .reg_stride = (width) / 8,                              \
> > +             .reg_bits = SPI_ADDR_SHIFT + SPI_ADDR_ALIGN,            \
> > +             .pad_bits = SPI_TURNAROUND_SHIFT,                       \
> > +             .max_register = BIT(SPI_ADDR_SHIFT) - 1,                \
> > +             .cache_type = REGCACHE_NONE,                            \
> > +             .read_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_RD),      \
> > +             .write_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_WR),     \
>
> [...]
>
> --
> Best regards,
> Marek Vasut

Hi Marek,

I saw SPI buffers and endianness and got triggered :)
Would it make sense to take a look at CONFIG_PACKING for the KSZ9477 driver?
I don't know how bad the field alignment issue is on that hardware,
but on SJA1105 it was such a disaster that I couldn't have managed it
any other way.

Regards,
-Vladimir
