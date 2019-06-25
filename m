Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AAB54F12
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbfFYMlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:41:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36535 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFYMlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:41:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id k21so26970924edq.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 05:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uV9ZI6R0sGd6M+qbK/NMUtk8WzSI65pTVkQvtw9VB/0=;
        b=csUC4PqCAzSATgIRmIUvQS45FK6nKyEhEzxiJ85bMn7v4gRbbWkAagCRvuDTjuYIOi
         gqD1H7BY5FWZ29RMdNEuRRXVkVvbA+FaJDT5PKBY2yVedrvlw9MwORq5FtyQv8xNLvSu
         XxvOwyS6gxUzRv1hcGQVdV/bexGlk9b0AXKMQRzkkArqckC9YbbrANmddylm/N+E1MDK
         +MOF2GVGCq1CaSLHRHW3hc564JwsvsUOiIR/s0tBeEIdfHJI/MI4NUWkq5pJMX94+7/w
         HOiUaiTlfw0ATA+kRrVSmiqN0nrP1aCMC5AcZzjuzEogqoRSomU0ZwqhZZYIfKEf//T/
         6yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uV9ZI6R0sGd6M+qbK/NMUtk8WzSI65pTVkQvtw9VB/0=;
        b=U8C+6epxLqxMZVjv3Ebww/n36e+MP4ldFhPtcOTQtfpyvDiks7HQkASd98akDdwVUR
         C8WbvW2VhGynBkud5PYQCUgv3xrswGGCX8JxIp55M/FGNnxsz6PQVmk076E7upKEq2Sn
         o5c17/a0FJm9YrAimycKKfN+2bHa8swTrKT4SCRSx9drmyeYvX1CQeKyjEPWmtqvPhwG
         99luJsCdN3r+8oUUHKgVlt9MRiL9dhj068uEdI6IvffZ5nVJBm7sR90s3gJgyaDoE7it
         cHuRvUg4vZrXtVJcKHx5vDyY/yune/9Q5NvWqOk6Cg0plZ8bGpyc9Yl4/KyEXOYS09RF
         vElg==
X-Gm-Message-State: APjAAAWBqemgsOb3PyROWXXW+Z59+16jTTGrhTy2Oxqi1GHo4OrTPqnp
        ZFcO4el3YU+7wBukRy43BVI0HAYbkcZfkKa6cps=
X-Google-Smtp-Source: APXvYqz+7XRud5lsR8VmWweOP2sAF/RkHNgmnrixtzEGyqX0sjx0+AA2MkHMh7yOweIhlRrioNKgwMfZgvfjufB48VY=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr17638944ejd.300.1561466465013;
 Tue, 25 Jun 2019 05:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190623223508.2713-1-marex@denx.de> <20190623223508.2713-8-marex@denx.de>
 <2bbd5346-5fe1-16d7-327e-5d94950496f2@denx.de> <CA+h21hpgXxnnRS7Upc1R82ajLum4k-3O9EQDROonO6jtAD+NZw@mail.gmail.com>
 <f1dfe749-4bfa-17f7-ede7-f9bc38afa0d4@denx.de>
In-Reply-To: <f1dfe749-4bfa-17f7-ede7-f9bc38afa0d4@denx.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Jun 2019 15:40:53 +0300
Message-ID: <CA+h21hot0TMh7G_BZ15DNXKTaxVv88B-8O7XpXPuqpNiQD5bxA@mail.gmail.com>
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

On Tue, 25 Jun 2019 at 15:06, Marek Vasut <marex@denx.de> wrote:
>
> On 6/25/19 1:59 AM, Vladimir Oltean wrote:
> > On Tue, 25 Jun 2019 at 01:17, Marek Vasut <marex@denx.de> wrote:
> >>
> >> On 6/24/19 12:35 AM, Marek Vasut wrote:
> >>> Add basic SPI regmap support into the driver.
> >>>
> >>> Previous patches unconver that ksz_spi_write() is always ever called
> >>> with len = 1, 2 or 4. We can thus drop the if (len > SPI_TX_BUF_LEN)
> >>> check and we can also drop the allocation of the txbuf which is part
> >>> of the driver data and wastes 256 bytes for no reason. Regmap covers
> >>> the whole thing now.
> >>>
> >>> Signed-off-by: Marek Vasut <marex@denx.de>
> >>> Cc: Andrew Lunn <andrew@lunn.ch>
> >>> Cc: Florian Fainelli <f.fainelli@gmail.com>
> >>> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> >>> Cc: Woojung Huh <Woojung.Huh@microchip.com>
> >>
> >> [...]
> >>
> >>> +#define KS_SPIOP_FLAG_MASK(opcode)           \
> >>> +     cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
> >>
> >> So the robot is complaining about this. I believe this is correct, as
> >> the mask should be in native endianness on the register and NOT the
> >> native endianness of the CPU.
> >>
> >> I think a cast would help here, e.g.:
> >> -       cpu_to_be32((opcode) << (SPI_ADDR_SHIFT + SPI_TURNAROUND_SHIFT))
> >> -       (__force unsigned long)cpu_to_be32((opcode) << (SPI_ADDR_SHIFT +
> >> SPI_TURNAROUND_SHIFT))
> >>
> >> Does this make sense ?
> >>
> >>> +#define KSZ_REGMAP_COMMON(width)                                     \
> >>> +     {                                                               \
> >>> +             .val_bits = (width),                                    \
> >>> +             .reg_stride = (width) / 8,                              \
> >>> +             .reg_bits = SPI_ADDR_SHIFT + SPI_ADDR_ALIGN,            \
> >>> +             .pad_bits = SPI_TURNAROUND_SHIFT,                       \
> >>> +             .max_register = BIT(SPI_ADDR_SHIFT) - 1,                \
> >>> +             .cache_type = REGCACHE_NONE,                            \
> >>> +             .read_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_RD),      \
> >>> +             .write_flag_mask = KS_SPIOP_FLAG_MASK(KS_SPIOP_WR),     \
> >>
> >> [...]
> >>
> >> --
> >> Best regards,
> >> Marek Vasut
> >
> > Hi Marek,
> >
> > I saw SPI buffers and endianness and got triggered :)
> > Would it make sense to take a look at CONFIG_PACKING for the KSZ9477 driver?
> > I don't know how bad the field alignment issue is on that hardware,
> > but on SJA1105 it was such a disaster that I couldn't have managed it
> > any other way.
>
> How does that help me here ? All I really need is a static constant mask
> for the register/flags , 32bit for KSZ9xxx and 16bit for KSZ87xx. I
> don't need any dynamic stuff, luckily.
>

Ok. I was thinking *instead of* regmap.
On the SJA1105 I couldn't use a spi regmap because:
* the enum regmap_endian wasn't enough to describe the hardware's bit
layout (it is big endian, but high-order and low-order 32 bit words
are swapped)
* it doesn't really expose a well-defined register map, but rather,
you're supposed to dynamically construct a TLV-type buffer and write
it starting with a fixed address.
I just thought you were facing some of these problems as well with
regmap. If not, that's perfectly fine!

> But I'm glad to see TJA1105 driver mainline :)
>
> --
> Best regards,
> Marek Vasut

Regards,
-Vladimir
