Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196B1DB4C6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgETNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETNRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:17:07 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EBCC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:17:07 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id z3so729010vka.10
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IB2ji97TeXrARDidiQkz70uOOho4XrDGY3ggn3bxND4=;
        b=cOBHw03XPgDYTX7PqqtBbyX5ZKvTPcRExEehiiKJ/Z9R4gFAdx5G6aLd6bUS9VHier
         uFmvmzzmbarq/WgKqg38N137Aa84MNlnxRYrD0tY2J+YmCm2/swpcnmKdGKZOINs24Mi
         AuiQDuFa1xtPS6lxEpoLqoq42uzeOSP2j+PsioeL5qVjLxHklPHqz3Yqd86lQcJLCdOD
         K+SkPgZdgTCrH2mBrwS+vyQJCwZUPpQuK722h+WjwAiK8AjP3mt+5eXVJ2g9JN2tNvqG
         DCYYa6xVk58++V5otqlwLPETdZieFka/ScRxbbJtk5b1VDuQbgEsUXeJCNORAujO7jLR
         Iu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IB2ji97TeXrARDidiQkz70uOOho4XrDGY3ggn3bxND4=;
        b=iWvn4jUme09R1zvT+xWm4CF3D08gd+yQbvJuH4K2WNARLOemjixBpby/UMEkzQUxMd
         vOAiGMVHlkeizWVU20sfx4fi79L9niIJyczDykdFoyONczD/nQ2+7FNgZbeBuOYLf3cd
         fr/W21beL/JRJBDSKvO7/eLT+LByj4Nldg+UXzoIMXHErF3K3ZLCKQdpvVwkOw0t55b8
         M89/COOTTVOPbJVGLVtDeC8CRPce6dscOlVSr6CADtJ+Vg6t2HmmXIiiufH4IFPX65iH
         Hrrwv8VuUgX/9S4sZsWdLko2SGupX1YMIUKCD2iUbfQvm23n9Cyh0L8DAi4OG46XjfT/
         5VNQ==
X-Gm-Message-State: AOAM530ZgzBL98OkpAutSN6pkr9xUnmdVygZe5aim3CeJJP4C28SaJrQ
        Rvyg1a83SDTHiN0d0y1oP2HIZImGmxSBOmsz7VTrxQ==
X-Google-Smtp-Source: ABdhPJw6KEaxkaaNNLQucc/piNIN5NIiHpL8mMobgcAXz7wLmxdRdmbm45Y4iSms+nrm4VPKPFG4lPrR9MqxNomucIs=
X-Received: by 2002:a1f:2bd7:: with SMTP id r206mr3739251vkr.28.1589980626036;
 Wed, 20 May 2020 06:17:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200519120748.115833-1-brambonne@google.com> <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
In-Reply-To: <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
From:   =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Date:   Wed, 20 May 2020 15:16:53 +0200
Message-ID: <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your comments Lorenzo!

On Tue, May 19, 2020 at 6:11 PM Lorenzo Colitti <lorenzo@google.com> wrote:
>
> On Tue, May 19, 2020 at 9:08 PM Bram Bonn=C3=A9 <brambonne@google.com> wr=
ote:
> > @@ -381,7 +382,8 @@ static struct inet6_dev *ipv6_add_dev(struct net_de=
vice *dev)
> >         timer_setup(&ndev->rs_timer, addrconf_rs_timer, 0);
> >         memcpy(&ndev->cnf, dev_net(dev)->ipv6.devconf_dflt, sizeof(ndev=
->cnf));
> >
> > -       if (ndev->cnf.stable_secret.initialized)
> > +       if (ndev->cnf.stable_secret.initialized &&
> > +           !ipv6_addr_gen_use_softmac(ndev))
> >                 ndev->cnf.addr_gen_mode =3D IN6_ADDR_GEN_MODE_STABLE_PR=
IVACY;
>
> Looks like if stable_secret is set, then when the interface is brought
> up it defaults to stable privacy addresses. But if
> ipv6_addr_gen_use_softmac(), then this remains unset (which means...
> EUI-64?) Any reason you don't set it to
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC in this case?

ipv6_addr_gen_use_softmac() means that addr_gen_mode is set to
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC. I was debating making that
explicit here, instead of using the inline function. It sounds like
that might be a better idea to make the implementation clearer?

The intention here (and below) was to keep the existing default
behavior of using IN6_ADDR_GEN_MODE_STABLE_PRIVACY if stable_secret is
set, while allowing to override this behavior by setting add_gen_mode
to IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC. I tested this locally,
and it seems to work as expected, but please let me know if you think
the above approach does not make sense (or if you'd prefer
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC to be the default instead).

> Since you haven't changed the netlink code, I assume that this address
> is going to appear to userspace as IFA_F_STABLE_PRIVACY. I assume
> that's what we want here? It's not really "stable", it's only as
> stable as the MAC address. Does the text of the RFC support this
> definition of "stable"?

The RFC considers the generated identifiers as: "stable for each
network interface within each subnet, but [changing] as a host moves
from one network to another". If the MAC address stays stable for a
specific subnet, this implementation fits that definition.
That being said, if you think it makes sense to define a separate
IFA_F_STABLE_PRIVACY_SOFTMAC flag (or some better name), I'm happy to
add that in.

> Can it happen that the MAC address when the device is up and an IPv6
> address already exists? If so, what happens to the address? Will the
> system create a second stable privacy address when the next RA
> arrives? That seems bad. But perhaps this cannot happen.

Trying to change the MAC when the device is up errors with EBUSY on my
machines, so I was under the assumption that the device needs to be
down to change the MAC. I could very well be wrong though.
