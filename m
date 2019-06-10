Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4835D3B897
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbfFJPxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:53:04 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45459 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390550AbfFJPxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:53:03 -0400
Received: by mail-ot1-f67.google.com with SMTP id n2so8726890otl.12;
        Mon, 10 Jun 2019 08:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7uCnX5LIMJHtHTPYaDf7mFvAliKfGgnILabe1niN2o=;
        b=oAoQN1PM0ta5wsaELk8p5Ea3yH54iqbEAfrpkhqkZGMCVsw06eugxD2IoI4566Pjsw
         Rk3pbbLyKj/rM4MV8Jjv0667R9dJqhWTmWuW+jO0XS9f8QWqFEjJrkpzCGADqWxbwRHM
         Cv7E50lrJwB83BKjtPzWsfiHW8+NtdxbhBU3yGiD2FbAXv8YK1w6bySs13F7PvsPeSWb
         oDBlQIlL4cn+nDMkZTE5S5JQSqmdjphWwsqsSLxweSu2w7HnxyJlf5OM7jgrjToA2OMF
         j1XIFDG4Iywk3bh1QURsSspr/zYSw2nzOFyfgSApccMfQPOdHj3/5kLhE6+KhmXJwai4
         t0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7uCnX5LIMJHtHTPYaDf7mFvAliKfGgnILabe1niN2o=;
        b=fGfosXNyx0PlqnN6NXr3ie71V0X64wVWxwDDiPXyCUg94IsQSl6WmMiGWAuPl2kUN8
         bat0wdmNUh/YtUB5XlX+H1Usglnr99RsDvJPODYB5NL2lksyjHuNkHhatdDzpoc+3GtZ
         d4fPMwYE9bbJLWP9RNXIfKsC08uePZwI6oYxnLGzkrhuOuH65zEkfNtjqkIqow4dmSWR
         NewC8TuLwj+zcPkMDKByxJfqli9mSsP4Hi5tiXAU3cLbcROjdFRVMRKsoXsQrqZxIIsN
         eg8+PzGZ6qzokFMffNpwOM60V8GIWMGApmQAvF9FSHN3oQtMXM1i9wAeX1gIwAWMAK+A
         c7Uw==
X-Gm-Message-State: APjAAAVS2TEVLhw73I3oeG+bOau9683FSZk17KsP4z90BHv3+NKbOQB7
        yhBPNI9P6cDTAlW2HfSq6xQTn287r07OYg5jghc=
X-Google-Smtp-Source: APXvYqzBtsrTeIkjNn7DDhjuFe0wNjh2kvmCkP3GNZSqEC0xKl2tEIEqMtPBumjQp/9gUrheEnWAc4JbHlAvsf/i/IM=
X-Received: by 2002:a9d:6d8d:: with SMTP id x13mr29456736otp.6.1560181982711;
 Mon, 10 Jun 2019 08:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch> <20190610114700.tymqzzax334ahtz4@flea>
 <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com> <20190610132546.GE8247@lunn.ch>
In-Reply-To: <20190610132546.GE8247@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 10 Jun 2019 17:52:51 +0200
Message-ID: <CAFBinCAc6cczcZX_diCZJiUsNObcmFqfdq4v_osiwee18Gk0iA@mail.gmail.com>
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset GPIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jun 10, 2019 at 3:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > if anyone else (just like me) doesn't know about it, there are generic
> > bindings defined here: [0]
> >
> > I just tested this on my X96 Max by defining the following properties
> > inside the PHY node:
> >   reset-delay-us = <10000>;
> >   reset-assert-us = <10000>;
> >   reset-deassert-us = <10000>;
> >   reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
> >
> > that means I don't need any stmmac patches which seems nice.
> > instead I can submit a patch to mark the snps,reset-gpio properties in
> > the dt-bindings deprecated (and refer to the generic bindings instead)
> > what do you think?
>
> Hi Martin
>
> I know Linus wants to replace all users of old GPIO numbers with gpio
> descriptors. So your patches have value, even if you don't need them.
OK, then I will send my patches anyways

> One other things to watch out for. We have generic code at two
> levels. Either the GPIO is per PHY, and the properties should be in
> the PHY node, or the reset is for all PHYs of an MDIO bus, and then
> the properties should be in the MDIO node.
our Amlogic boards only have one PHY and all schematics I'm aware of
route the SoC's GPIO line directly to the PHY's reset line.
so in my opinion defining the resets for the PHY is the right thing to do


Martin
