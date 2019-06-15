Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC246F33
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 11:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfFOJLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 05:11:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33638 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOJLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 05:11:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id q186so3762744oia.0;
        Sat, 15 Jun 2019 02:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbR5FQbdW0iBa/beUoJRgpiQJiBQoxkjSkavczcORWw=;
        b=VcMKkBRb/rUMovH0xbl2hjAVh9RWLeL/2Omm6qN6vF5jxP+rWGNVzHcsGsRQvedhKE
         S89OH9D5SwVuq27LAT4LJRftoaoZWD+Q+twAaWKckXjWiqLzn1bs/2YgCgpf+YNJfUmo
         be923v5MXnvxDaYj3nIixo6Ne+HWXGGaQB2SjXTgW/VMKX9C+Z+ffC7xuBS7N4BmPObm
         z9gyq8qsnkZsXCaAifchqzQp1XgRa1Cm8zKTZCYNdVbsy+qMbAMNDTKXIEZhuzgaLtHh
         TaFOa/le9r531qZeB18/OtOYxMQNllAvwHWVeBofughuSlh7nLEDzdQP0DqY1WwEKzIG
         OF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbR5FQbdW0iBa/beUoJRgpiQJiBQoxkjSkavczcORWw=;
        b=P7jl3Zn4PxB0FknQRQ9Ocjkka1HCOudb6d1+91RlcYHNulyU/j1kKhdEg0/197OE3A
         ZuF5VTg5k4/vYcbclD0dAUR1Wnx1KBFrnq696GSNcmvPlaaf7mccHFMJB9628CVPzcUz
         yoZrs4LiWyFzY/p+j2bMylg4EILURywThIfZbIyZFTH5Y4iePRgw/yz5oAY3yROE5ncK
         N5wyxpbI9EezJWDcz6XXsKCesTSIzEffyMatrz38dNwceD5Y2/cDLkXstIAcHWwij0vR
         XhTersYFpo6JeppSDknfSwXquUmbExzWAkDOoyYnM9GURz82E6hXpDZWhQJgdzLRSgm1
         nQlw==
X-Gm-Message-State: APjAAAUejJ5ZuFWsglF9CvvBu2HGHj7N6H8GAj6lxI2rHQN3sHgwA/Za
        p+andc8T/6NvylBMc9VBbSEcVgiEX1Rcll5CRHDDwNUDFuA=
X-Google-Smtp-Source: APXvYqyyMM3N5RMCR87NhEVuLBpMnEBYAzow16OocnDpntu7REewHZk5fn65ccx+y4maGLwoRyUAtcvK+dw0582yfzo=
X-Received: by 2002:aca:f144:: with SMTP id p65mr4627672oih.47.1560589906273;
 Sat, 15 Jun 2019 02:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190612193115.6751-1-martin.blumenstingl@googlemail.com>
 <20190612193115.6751-2-martin.blumenstingl@googlemail.com> <CACRpkdajXRXRFz=XpbEzwUb-crhBxNQ4f-m9rfdY6+HcG0+_gA@mail.gmail.com>
In-Reply-To: <CACRpkdajXRXRFz=XpbEzwUb-crhBxNQ4f-m9rfdY6+HcG0+_gA@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 15 Jun 2019 11:11:35 +0200
Message-ID: <CAFBinCAimhth8fDcBZ3vNdy_9dGmHZVAAK0=TUczWWC4Dsa-pA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: stmmac: use GPIO descriptors in stmmac_mdio_reset
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Sat, Jun 15, 2019 at 11:08 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Hi Martin!
>
> Thanks for fixing this up!
you're welcome
I think I finally understand why you want to switch everything over to
GPIO descriptors

> A hint for a follow-up:
>
> On Wed, Jun 12, 2019 at 9:31 PM Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>
> > diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
> > index 4335bd771ce5..816edb545592 100644
> > --- a/include/linux/stmmac.h
> > +++ b/include/linux/stmmac.h
> > @@ -97,7 +97,7 @@ struct stmmac_mdio_bus_data {
> >         int *irqs;
> >         int probed_phy_irq;
> >  #ifdef CONFIG_OF
> > -       int reset_gpio, active_low;
> > +       int reset_gpio;
>
> Nothing in the kernel seems to be using this reset_gpio either.
>
> I think it can be deleted with associated code, any new users
> should use machine descriptors if they insist on board files.
good catch, thank you - I'll put that in my cleanup series that I want
to send anyways


Martin
