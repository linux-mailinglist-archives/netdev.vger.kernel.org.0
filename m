Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2353B88F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391298AbfFJPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:51:37 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40432 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390550AbfFJPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:51:37 -0400
Received: by mail-oi1-f194.google.com with SMTP id w196so6584303oie.7;
        Mon, 10 Jun 2019 08:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuHcFSp9RV6IeTzjDjOYf2cyyZ7YnVvyyWSJ347qo6A=;
        b=Sl+8Rmb2SbYgcshM1Z0Js0gffJMpHV6iNwuBeKkftDEg6qJgrbJkm+yybg3CWqzJ2x
         qR/7WtHww9+6woEtKc/YlVDtO0g8Y7A5kuCpvgscXSZXtgke0JyDjp7/Ew/b8W3AI/1n
         gk/fXnfGrZlppgM50p9VnIWFn0op1rziV+e31gh6EDInrEX50Zgw9lXzNQTzACC4Jz4y
         xuZfkn9Py55sJbkDpD6NHuD5fTNDddBbEKMWUsAunWtMuSUEU6AKzYsvxiPACEuq19TJ
         TR+RMKGFu9vNaEkKqQAk3oVJ4ZRkCumfzKglVgjyGf5iNvXv1fklUHBgHDDTgVFNNHmA
         0rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuHcFSp9RV6IeTzjDjOYf2cyyZ7YnVvyyWSJ347qo6A=;
        b=mosc0Z4WQ2YUgEFcicolS++ZbxPUbOsXqOv3hgfZXBrFgz6RjRxbjPYClTpp3vP674
         /mlut4Vn/qmN4ZozCl2cFn9el/bml+1OOUTet5UkHB6htHvKBQ7EyPAE8W8ET/71iFSG
         Pcn1nkR9i2LOD0FMJCQFB0snS6yzimJbrwlROSLrOlu462FGHSR4aL+kxB7HgEHbBTmO
         s9IhdDpIOWJ+Q/OREZ2OuopIuuR8ueCUhnElOgCPrcnOIIo7XgV6k033R/zFIm2TP87Z
         WWdKzRoV6OBjNQLdIB5Sfq6MgqGIbvKgUcfHA5YrJE/NEM0F9VVYXX0TkXMKU+vj+8oZ
         HuqQ==
X-Gm-Message-State: APjAAAV2kfq6PdKeSNPDmHI82YUVqo1/L95X8h4pdEeK59QF7GOenbEg
        jVytFcOIZMrGH4LWLl3txmXEvlRyfdNcOuVbLiw=
X-Google-Smtp-Source: APXvYqwamDEZ2pn1KOIAFzWrcT6R7MpvRaH+7gsnVBBoMuB1pYAjxIlbqNIxs3Use8vvJu0GGPKKrdLueixgJ+eH8z4=
X-Received: by 2002:aca:4403:: with SMTP id r3mr12815875oia.39.1560181896310;
 Mon, 10 Jun 2019 08:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch> <20190610114700.tymqzzax334ahtz4@flea>
 <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com> <20190610135109.7alkvruvw2jbtwph@flea>
In-Reply-To: <20190610135109.7alkvruvw2jbtwph@flea>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 10 Jun 2019 17:51:25 +0200
Message-ID: <CAFBinCAy=YR+qV=vYtAV4p5ftcR-VuYTJz3wuMY-k6PWcmbDQQ@mail.gmail.com>
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset GPIO
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
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

On Mon, Jun 10, 2019 at 3:51 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi Martin,
>
> On Mon, Jun 10, 2019 at 02:31:17PM +0200, Martin Blumenstingl wrote:
> > On Mon, Jun 10, 2019 at 1:47 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > Hi Andrew,
> > >
> > > On Sun, Jun 09, 2019 at 10:45:10PM +0200, Andrew Lunn wrote:
> > > > > Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> > > > > "Always leave the campground cleaner than you found it."
> > > >
> > > > > I
> > > > > am also looking for suggestions how to handle these cross-tree changes
> > > > > (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> > > > > go through the net-next tree. I will re-send patch #5 separately as
> > > > > this should go through Kevin's linux-amlogic tree).
> > > >
> > > > Patches 1 and 4 don't seem to have and dependencies. So i would
> > > > suggest splitting them out and submitting them to netdev for merging
> > > > independent of the rest.
> > >
> > > Jumping on the occasion of that series. These properties have been
> > > defined to deal with phy reset, while it seems that the PHY core can
> > > now handle that pretty easily through generic properties.
> > >
> > > Wouldn't it make more sense to just move to that generic properties
> > > that already deals with the flags properly?
> > thank you for bringing this up!
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
>
> I'm glad it works for you :)
>
> > instead I can submit a patch to mark the snps,reset-gpio properties in
> > the dt-bindings deprecated (and refer to the generic bindings instead)
> > what do you think?
>
> I already did as part of the binding reworks I did earlier today:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-June/658427.html
great, thank you - you have my Reviewed-by!
