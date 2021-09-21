Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6977A412F7B
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhIUHcO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Sep 2021 03:32:14 -0400
Received: from mail-vs1-f49.google.com ([209.85.217.49]:39773 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhIUHcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:32:14 -0400
Received: by mail-vs1-f49.google.com with SMTP id o124so19265218vsc.6
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s45fPjetHdCmuoDK+nGyLuoTHMHeTbqjHbQsdynE5ac=;
        b=tp98q6jiPV/A86mV8+J7y7yoFlsa/f4m4/GY2moLcdRw8Hmd3FAlL0gQh6POrgN+sF
         LdfGeTi4raYfXTc+F7JLCKdAB22COZDE9iOT2BVOK3vRx23UP8qaC7VPUjwf44nrgWtC
         z1pce7+q9uOs7RV9g3LZDi5FNOKQvG64ijRJjoe+7oeJuKqzbEGrkoS0a+RldxJN9Ovi
         HkMebMJdmrH5oOCWsDzWw3x3/akirS3QjwLzJ8US5TFOg0sqW4pIz/PI6RbvnIMOgTT6
         1ldphy6748YjksTuHwzUWnVBY+BGs63og3Ue/JUkTAccREiIrmu7GIqBF/r3cuhcmf+D
         nwpQ==
X-Gm-Message-State: AOAM532MogZMMiQHoGIyD5Mpv90Olps51dci6/idis5yfcbMBuTtGQEx
        fTMAa+yWLb7m2aMP9SBZzH+KwCnPnp/qLgSSk6M=
X-Google-Smtp-Source: ABdhPJx8+RRcE9eD/7ImgNnJQRbs9kmZmxvfgMMTshDeh1is0SClZiSiDwCryWT/bmblXn5DIRwJU4WxpT/NLoX/RTw=
X-Received: by 2002:a67:cb0a:: with SMTP id b10mr19733532vsl.9.1632209445621;
 Tue, 21 Sep 2021 00:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
 <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com>
 <20210920121523.7da6f53d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANP3RGd5Hiwvx1W=UOCY166MUpLP38u5V6=zJR9c=FPAR52ubg@mail.gmail.com>
In-Reply-To: <CANP3RGd5Hiwvx1W=UOCY166MUpLP38u5V6=zJR9c=FPAR52ubg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Sep 2021 09:30:34 +0200
Message-ID: <CAMuHMdX1ZjLFjE5oH7usz5mGPKPBy+qvvt4fN=wUw-BHOBiVqA@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

On Mon, Sep 20, 2021 at 10:20 PM Maciej Żenczykowski <maze@google.com> wrote:
> On Mon, Sep 20, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat, 18 Sep 2021 12:53:31 +0200 Geert Uytterhoeven wrote:
> > > > Yeah.. more context here:
> > > >
> > > > https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com/
> > > >
> > > > default !USB_RTL8152 would be my favorite but that probably doesn't
> > > > compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> > > > mark it as a sub-option of CDCETHER? It's hard to blame people for
> > > > expecting drivers to default to n, we should make it clearer that this
> > > > is more of a "make driver X support variation Y", 'cause now it sounds
> > > > like a completely standalone driver from the Kconfig wording. At least
> > > > to a lay person like myself.
> > >
> > > If it can be a module (tristate), it must be a separate (sub)driver, right?
> >
> > Fair point.
>
> The problem is CDCETHER (ECM) tries to be a generic driver that just
> works for USB standards compliant generic hardware...
> (similarly the EEM/NCM drivers)
>
> There shouldn't be a 'subdriver'

If it does not make any sense to disable USB_RTL8153_ECM if CDCETHER
is enabled, perhaps the option should just be removed?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
