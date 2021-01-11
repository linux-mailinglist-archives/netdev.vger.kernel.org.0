Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFA62F2274
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbhAKWKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbhAKWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:10:17 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78074C061794;
        Mon, 11 Jan 2021 14:09:37 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id y22so616554ljn.9;
        Mon, 11 Jan 2021 14:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MaAJz+3cRdiTPh2sh3UXQnecZjA7GzXvapWd7cfhm5I=;
        b=bwRaUeUIkZfEaSey1fqB8RwqZWkmEEDiudKCals5VJ7evrkB+2EFUuMN8jOsqmzdNi
         V2lJJngo4TEr0XAIy1Vo+0xXKKeAiZ2CehQLw31ygzm8uENJdOLfQlhjWUctZiGslv8b
         9Hqh4WY1kbNNx51nWSEhh7PttMOl7ocWzxi2S7+n0q2fIWA7JLoYbEggAzdGeOy+KmiV
         Pu2mTcTzavViCH6iCqMst8tSF4xxIRVAuZ9UXOSvKdK7FwFN96oiw23pfzE/vBsS5TQ1
         3DamfK+cHcb2Yly2N8JEOWtieYDwlrvea99Ra8fKUgw8+SiLf4TlAgtS6t6AQsYZkPcT
         votg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MaAJz+3cRdiTPh2sh3UXQnecZjA7GzXvapWd7cfhm5I=;
        b=rHgnMgvEHTVxe0TH6x13nNdU5bcJQtitGbK5/xNJJVrAGpud3/0Ph0Oo3Zl0jqqsEa
         ogVAdysUbTJMYxUhWnveuhDtUcKsT8fqcd8mCWDkIyAHFdMPi8etWifU4RMtmENwJswZ
         WaKie1k0JGvASWkbx3aUCY1QvlrBmsrNoVuopPWeX1Oam2Q9MZ8FDiXJ+jxmXwvv1ak/
         lq4AnkKzSW6BKmiAus6jAfu385tDFlw5YMFV7jSgDKwt/vvWMQCBDbrrPwKI1la1CnL5
         q5w+ECC51dX0KMUj2i+2qKvIettGsf9HDo9iSqfTkf2GbG4WEv4jRU/GCfp3nRsDdclQ
         RXsQ==
X-Gm-Message-State: AOAM533Ga8ISUu5A1XI50cdU4+mf0hVQneaJff1wn8EH3L/1xjByj0Ux
        TkKOV0cko7uPiWpEN0wBTieP795wLmoTGcYcQ7g=
X-Google-Smtp-Source: ABdhPJxNuGmvRgzWTvgOeDw82iyCyKN1WeH6PhT5XqkLTB3vqCeR2GmAy/7mhywmhqfJMm6AXCuhtJouVmFPueK/UjE=
X-Received: by 2002:a2e:3514:: with SMTP id z20mr670852ljz.110.1610402975946;
 Mon, 11 Jan 2021 14:09:35 -0800 (PST)
MIME-Version: 1.0
References: <CAD56B7fYivPF33BhXWDPskYqNE5jRxd-sA=6+ushNXhyiCrwiQ@mail.gmail.com>
 <f3b0e354-9390-1ce8-6be5-b6ba9f201589@gmail.com>
In-Reply-To: <f3b0e354-9390-1ce8-6be5-b6ba9f201589@gmail.com>
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Mon, 11 Jan 2021 17:09:24 -0500
Message-ID: <CAD56B7fJbej4A9QpG4VLfeU-Qu-RwZHEkpJvMab4KhL7Jr-QgA@mail.gmail.com>
Subject: Re: net: macb: can macb use __napi_schedule_irqoff() instead of __napi_schedule()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 4:35 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 11.01.2021 20:45, Paul Thomas wrote:
> > Hello, recently I was doing a lot of tracing/profiling to understand
> > an issue we were having. Anyway, during this I ran across
> > __napi_schedule_irqoff() where the comment in dev.c says "Variant of
> > __napi_schedule() assuming hard irqs are masked".
> >
> > It looks like the queue_writel(queue, IDR, bp->rx_intr_mask); call
> > just before the __napi_schedule() call in macb_main.c is doing this
> > hard irq masking? So could it change to be like this?
> >
> It's unsafe under forced irq threading. There has been a number of
> discussions about this topic in the past.
OK thanks, and our use case is forced irq threading under PREEMPT_RT

-Paul

> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -1616,7 +1623,7 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
> >
> >                         if (napi_schedule_prep(&queue->napi)) {
> >                                 netdev_vdbg(bp->dev, "scheduling RX softirq\n");
> > -                               __napi_schedule(&queue->napi);
> > +                               __napi_schedule_irqoff(&queue->napi);
> >                         }
> >                 }
> >
> > -Paul
> >
>
