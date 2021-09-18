Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79242410604
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 13:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhIRLRt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Sep 2021 07:17:49 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:42925 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhIRLRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 07:17:48 -0400
Received: by mail-ua1-f45.google.com with SMTP id c33so7778008uae.9
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 04:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TbVN4SnFa75VRyqZwcvvJq5B+keT39FAb+WXQjYnctE=;
        b=OU1SS+aA1OATiUO7HPWRaxycRFeSIMtcqYSUKTNks2AAU6be4MmQPJJ5VzBw9dOI09
         x5JYJa3CPdLJ+CQul9k8CIsRDsQSbmcHSmbJJ21sMHbfLmXmk0S/K6PuSihT9A8ncLH6
         AElZQvCHlhxKbr0teXyfNWt/N2MSOs1wa+gcFkn8S4WkL9y5CQCM3DRoyqFuGqp1fq0G
         uugvjTgxYB/9N+2KlPOx3EnV77wPOxqhvaVz9jaQbsWkyAuToU58uh86i6tXNNc3LKM9
         o9klg36arir3P/Tb80MpCtY1/tOKJdMFaOBgMaHCnAHCbiTeoKUPsJ6mahMK8TfQQ0ph
         dhig==
X-Gm-Message-State: AOAM531Q13l8eWvZTayWrskbLkae+d5O+5gw84xi1yhAqIsLQryG3Z2A
        2zOkPngQPKqaLzd7XmDUdSit50OOij/WU/8dduI=
X-Google-Smtp-Source: ABdhPJzP6BjQ1zOGmsuT1SutdVDMFNW5ulJSIoNY/pqGRnkDkTGN13Wds/QXiBoQ2/IA7Jgz+nMumxTXb3pXFNhobd8=
X-Received: by 2002:ab0:6ec9:: with SMTP id c9mr8399190uav.114.1631963784102;
 Sat, 18 Sep 2021 04:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
 <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANP3RGfPzXTMX+FAvd73EWjQnqUPyczuTD0dTQ79RMoVpjyQMg@mail.gmail.com> <20210917123713.67e116aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917123713.67e116aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 18 Sep 2021 13:16:13 +0200
Message-ID: <CAMuHMdWobCyOtQTWjzFi410Vmx9qXW3PRD3kTs46QBzv_8J+sQ@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Sep 17, 2021 at 9:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 17 Sep 2021 21:05:55 +0200 Maciej Żenczykowski wrote:
> > > Yeah.. more context here:
> > >
> > > https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com/
> > >
> > > default !USB_RTL8152 would be my favorite but that probably doesn't
> > > compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> > > mark it as a sub-option of CDCETHER? It's hard to blame people for
> > > expecting drivers to default to n, we should make it clearer that this
> > > is more of a "make driver X support variation Y", 'cause now it sounds
> > > like a completely standalone driver from the Kconfig wording. At least
> > > to a lay person like myself.
> >
> > I think:
> >         depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
> >         default y
> > accomplished exactly what was wanted.
> >
> > USB_NET_CDCETHER is a dependency, hence:
> >
> > USB_NET_CDCETHER=n forces it off - as it should - it's an addon to cdcether.
> >
> > USB_NET_CDCETHER=m disallows 'y' - module implies addon must be module.

What is the expected behavior if USB_NET_CDCETHER=y, and USB_RTL8152=n?

In that case, the old "default y" made USB_RTL8153_ECM builtin.
That was the issue I was fixing.
If USB_RTL8153_ECM is somewhat critical, perhaps you want
"default m if USB_NET_CDCETHER=m"?

> > similarly USB_RTL8152 is a dependency, so it being a module disallows 'y'.
> > This is desired, because if CDCETHER is builtin, so this addon could
> > be builtin, then RTL8152 would fail to bind it by default.
> > ie. CDCETHER=y && RTL8152=m must force RTL8153_ECM != y  (this is the bugfix)
> >
> > basically the funky 'USB_RTL8152 || USB_RTL8152=n' --> disallows 'y'
> > iff RTL8152=m
> >
> > 'default y' enables it by default as 'y' if possible, as 'm' if not,
> > and disables it if impossible.
> >
> > So I believe this had the exact right default behaviour - and allowed
> > all the valid options.
>
> Right, it was _technically_ correct but run afoul of the "drivers
> should default to 'n'" policy. If it should not be treated as a driver
> but more of a feature of an existing driver which user has already
> selected we should refine the name of the option to make that clear.


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
