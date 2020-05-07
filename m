Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999A51C970B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGRD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbgEGRD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:03:56 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF64C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 10:03:56 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id k81so6872794qke.5
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hld7f/Kw9bjvhfjaZsf7n7gSrldLUvvGkUrL/YswQok=;
        b=EpvVqjRHFxbK1wUeGGCkLIlkrmGeJJgfCrCsU+zmzM1wqgCW5VyfqZ7BHVia1xluk3
         gTvSp++LYK9R3PE9phD5/DFTk3/tQNJuidf/vzvvPtt7kdJynt8wVj/QTKbLYd7LPJNt
         pjmMliIGNvRFvzqCRSw/0q8XbuQA5ONaif8qjvwLZ2fyu5P1nTO6HibWKYEIwhPXjO7N
         aOMb6cpnL80stcrIAMjulGkzuyr/hqMdxxZv/MM075BCRgcShupXD0aySGxg+vn1h/hs
         CN5+wmJ8NlmAuwXJLYvUs2oCDLXSa/LjT1/ErrAonSYhTh8NKuWUUMvQEzUM5Jvz2gik
         yP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hld7f/Kw9bjvhfjaZsf7n7gSrldLUvvGkUrL/YswQok=;
        b=p4XQ366AkEKNblB3b8Rie6Pt4xm+AN6JXDB4WN3LZ8uqD2u5TSYulzdxQItgzJ4yRa
         44aZy+8CRo1rzKhWp/osONCjaWZawvwKrqUIRgI13dV9VCkT8cZYRd+IqHKb3EF8LdZh
         kFmVXj1dNQy31CW7TryNbc0isQ8bQcoQf4W1AZVR9RC1G/HMG94O4gGMP4eOAg0JR/TB
         IhxQWBiyjZkjP8/YaInFJH58Alk1wWsC6NZQ9ufIMmVdSXB0Zs8nYXQi52eKUhY9DTOG
         ZEFFY9VvOipU/Qo3voSCb0CqWcZACDZws/qfCHtB+QrY9jPXooBHl4GL+nsFSzdkGweQ
         EKhQ==
X-Gm-Message-State: AGi0PuYRQqt25KMtWm1PRDUtWIJOHHqSTVDFiURNBi5iJ7HabQpfQZnJ
        MZ5redYYXYOwq6KjZzaeVMdl8T9LBizgp2tWRDwFbw==
X-Google-Smtp-Source: APiQypJYPuD7vyBsx50AXMNfbjWRHiKRLtVBSWgqWt5R2mCiujv+F5SYL9Ov+qQKOQm8p348+/a1owCEaNzPso5tN/k=
X-Received: by 2002:a05:620a:65a:: with SMTP id a26mr14772836qka.323.1588871035690;
 Thu, 07 May 2020 10:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-6-brgl@bgdev.pl>
 <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
 <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com> <20200507095315.1154a1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507095315.1154a1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 7 May 2020 19:03:44 +0200
Message-ID: <CAMpxmJUEk3itZs4HujJOXUiL80kmEvGBvLF0NFc2UQoVDVTWRg@mail.gmail.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 7 maj 2020 o 18:53 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
>
> On Thu, 7 May 2020 11:25:01 +0200 Bartosz Golaszewski wrote:
> > =C5=9Br., 6 maj 2020 o 19:12 Jakub Kicinski <kuba@kernel.org> napisa=C5=
=82(a):
> > >
> > > On Wed, 6 May 2020 08:39:47 +0200 Bartosz Golaszewski wrote:
> > > > wt., 5 maj 2020 o 19:31 Jakub Kicinski <kuba@kernel.org> napisa=C5=
=82(a):
> > > > >
> > > > > On Tue,  5 May 2020 16:02:25 +0200 Bartosz Golaszewski wrote:
> > > > > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > > > >
> > > > > > Provide devm_register_netdev() - a device resource managed vari=
ant
> > > > > > of register_netdev(). This new helper will only work for net_de=
vice
> > > > > > structs that have a parent device assigned and are devres manag=
ed too.
> > > > > >
> > > > > > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > > >
> > > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > > index 522288177bbd..99db537c9468 100644
> > > > > > --- a/net/core/dev.c
> > > > > > +++ b/net/core/dev.c
> > > > > > @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *d=
ev)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(register_netdev);
> > > > > >
> > > > > > +struct netdevice_devres {
> > > > > > +     struct net_device *ndev;
> > > > > > +};
> > > > >
> > > > > Is there really a need to define a structure if we only need a po=
inter?
> > > > >
> > > >
> > > > There is no need for that, but it really is more readable this way.
> > > > Also: using a pointer directly doesn't save us any memory nor code
> > > > here.
> > >
> > > I don't care either way but devm_alloc_etherdev_mqs() and co. are usi=
ng
> > > the double pointer directly. Please make things consistent. Either do
> > > the same, or define the structure in some header and convert other
> > > helpers to also make use of it.
> >
> > In order to use devres_find() to check if struct net_device is managed
> > in devm_register_netdev() I need to know the address of the release
> > function used by devm_alloc_etherdev_mqs(). Do you mind if I move all
> > networking devres routines (currently only devm_alloc_etherdev_mqs())
> > into a separate .c file (e.g. under net/devres.c)?
>
> To implement Edwin's suggestion? Makes sense, but I'm no expert, let's
> also CC Heiner since he was asking about it last time.

Yes, because taking the last bit of priv_flags from net_device seems
to be more controversial but if net maintainers are fine with that I
can simply go with the current approach.

Bart
