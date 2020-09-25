Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368B9278445
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgIYJoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgIYJoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 05:44:08 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8BC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:44:07 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nw23so2783836ejb.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AghgxIBacPICxjrCH2oN4Lf3uqMGFWBNgt8V7vWuPYA=;
        b=QfqE5K9eAELrebYbEi8rOf0sHacPV6ju3Ssne6gTVXHgdurtxMjyKxpIyc84BSEXQB
         KOtQQhzWP4vUNdPNu5i0hA/AaZd+MEDLmrFhAY7CpEahpaGtgnnFrLE/pcs+uI3QIBvL
         U+Ud627BRpTYpJoFFhecXCPpbnX8oqXY/6fle4ZxqVj7EMp2oUSLMRzmgmn+CxcPzM/A
         J13BqlIQP8qr14oRQqkAm7SqaPp2PTYqMDp4xFLwmU9zoDFmz1v1f0Ny22J2g8VOWXMi
         BcZggcEQTJV3n0z8DymxXpXd8VNogLS9DgJ1+O49hkOsirED3ZsICi/0GXf4muJD0cgF
         LW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AghgxIBacPICxjrCH2oN4Lf3uqMGFWBNgt8V7vWuPYA=;
        b=ND/AmO0qKa6R7/5RR+1VcXWvAlrevp+8S9pTvHtdd6zuJuKjHgK/BNrXZgm3vTgzbU
         Ch3pBy3FWLnnQFRQnI44dPj0h9ASTVXZ3MWndBvs+g81jxiNDj4rAxpwGbRDSYPiTYzH
         3jBs3INvPEAz4/hUTlcAxjSTACECeBXkq1YhiyUwX54BiDsmRrWn4x7Den3JOYWqKJsB
         OHhykSCW+eIyG8NZoUie91khIuCa07r6u0/ETxLaumPWcWIo2Uc/kh2jfKbrfFqjxSR5
         lF7a74v6dS8M4RmF+4ewNDmPsHLR05zz55dFz8vqUfw/2s7A4k16IQ75D2KnnFbWDn6O
         P50g==
X-Gm-Message-State: AOAM531AYfDM2bPvbSpkVHbfS0LybwbfOfhdan27l8iAvuIvyYhSzGXp
        BKmKUOtbwuSyY4qzQPmM5rPVGSDj0iFneCJng+yt7ucqvOh+qA==
X-Google-Smtp-Source: ABdhPJzukoF3h3bi3TCaavICnNIIh1RQ+PGL/Tghb9YrV67+MOOK/FxT3RdZwsN28F98xntVIReuS1LKQZInG7Q+KOE=
X-Received: by 2002:a17:906:3e90:: with SMTP id a16mr1694225ejj.363.1601027046567;
 Fri, 25 Sep 2020 02:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200925024247.993-1-yongxin.liu@windriver.com>
 <CAMpxmJWjczUhKH2K25E4Ezs9DEFQMxHMhD8qzhurSeEyE=wmXg@mail.gmail.com> <BYAPR11MB2600094C066D51C15B81EA70E5360@BYAPR11MB2600.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2600094C066D51C15B81EA70E5360@BYAPR11MB2600.namprd11.prod.outlook.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Fri, 25 Sep 2020 11:43:55 +0200
Message-ID: <CAMpxmJXbwrE-X7zsnNy0DzmhWADR0GRXZy_RFK4RuOnCv=p7OA@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()"
To:     "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 10:51 AM Liu, Yongxin <Yongxin.Liu@windriver.com> wrote:
>

[snip]

> > >                         true);
> > >
> > > -       err = ixgbe_mii_bus_init(hw);
> > > -       if (err)
> > > -               goto err_netdev;
> > > +       ixgbe_mii_bus_init(hw);
> > >
> > >         return 0;
> > >
> > > -err_netdev:
> > > -       unregister_netdev(netdev);
> > >  err_register:
> > >         ixgbe_release_hw_control(adapter);
> > >         ixgbe_clear_interrupt_scheme(adapter);
> > > --
> > > 2.14.4
> > >
> >
> > Then we should check if err == -ENODEV, not outright ignore all potential
> > errors, right?
> >
>
> Hm, it is weird to take -ENODEV as a no error.
> How about just return 0 instead of -ENODEV in the following function?
>

No, it's perfectly fine. -ENODEV means there's no device and this can
happen. The caller can then act accordingly - for example: ignore that
fact. We do it in several places[1].

Bartosz

[snip]

[1] https://elixir.bootlin.com/linux/latest/source/drivers/misc/eeprom/at24.c#L714
