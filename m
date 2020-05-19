Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919FE1D9C20
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgESQLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgESQLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:11:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D1FC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:11:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x5so15161940ioh.6
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LHIWGNdkeggq/sBhwWzjL4BQcJ0VFKzcQlIQ59EDoTM=;
        b=sbffPtzjBjfcs7D/8zjHgn42Fb9uNIBpUOM7ZrpmNM3uh4K62Y9VRy5tOexekrK43g
         Xkgv9SDC8TIuEmAFyAEE8LG+mmLR2XyWBn4ELz/Vba8O3AhqY2n+BZDZ2Y4V34MVfhyb
         fZhlvBoPPXs0mxTAH72KWBN1Ff9G4bIKM8iOJrPsPB6SJlgw8gJh0Gqt1rQLOwoYxcBK
         y/jsDGxSZHeEMctkcPkzu4s6FseRGgCFypC7S/L9eq4iOpYrHTEA5QQ6ADxn5DNg8f+N
         6oxp811uPTBb5MPWCb5uXAgGxMlCA3TrfFu/xhA+b70FaC7g71Uz8FeOuur5CjqetnWz
         EOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LHIWGNdkeggq/sBhwWzjL4BQcJ0VFKzcQlIQ59EDoTM=;
        b=ad+Wgf+okgnB61GWLLZnEyaSMOtogTGrTo1WLwgugRSr28paNTO4d4t0fFGMhPKg02
         Cgd8232ehXUMiEeiQS3uWkQYdkY4IxxYCIspF48n8K9x1PQKMxkr+psJu+EFvufPAAqD
         3unbJQdMYGCQLHyl5RTWsbmj2e2I6CuArYGXoMUxwNV2f/+F0moUG85/T2f7pMOrXnoV
         u8AuBmas/eHghm5KFBdF9Usao/XP5NSYuR/EEXZiY/gSvs024PZ8tuq5izTuRrCBL3D6
         8NEmvjryEg2/1nskL2EAAdxH1IpdYotj1hgDWsrnLRf1AUWN0f9jWs11bdvuIrHAcpJ9
         L+yQ==
X-Gm-Message-State: AOAM532IF/LlNwgamo83qFxbQ3WzTeV/XkRWxB3bhq71j8uU/Q/vS1zW
        HS9KK5RAtLKwUSHK6RTiG1q2qZ/NsIgdKJImraZf3A==
X-Google-Smtp-Source: ABdhPJxtTERR8rA10YdRkTekPzTQtOFDltmO6K9Uy07McmfBgsh6z3VgORbx8bXuKIxLLFdLxh56F8hwu47ecBLx2gE=
X-Received: by 2002:a5d:8b81:: with SMTP id p1mr19606695iol.189.1589904698195;
 Tue, 19 May 2020 09:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200519120748.115833-1-brambonne@google.com>
In-Reply-To: <20200519120748.115833-1-brambonne@google.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 20 May 2020 01:11:26 +0900
Message-ID: <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
To:     =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
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

On Tue, May 19, 2020 at 9:08 PM Bram Bonn=C3=A9 <brambonne@google.com> wrot=
e:
> @@ -381,7 +382,8 @@ static struct inet6_dev *ipv6_add_dev(struct net_devi=
ce *dev)
>         timer_setup(&ndev->rs_timer, addrconf_rs_timer, 0);
>         memcpy(&ndev->cnf, dev_net(dev)->ipv6.devconf_dflt, sizeof(ndev->=
cnf));
>
> -       if (ndev->cnf.stable_secret.initialized)
> +       if (ndev->cnf.stable_secret.initialized &&
> +           !ipv6_addr_gen_use_softmac(ndev))
>                 ndev->cnf.addr_gen_mode =3D IN6_ADDR_GEN_MODE_STABLE_PRIV=
ACY;

Looks like if stable_secret is set, then when the interface is brought
up it defaults to stable privacy addresses. But if
ipv6_addr_gen_use_softmac(), then this remains unset (which means...
EUI-64?) Any reason you don't set it to
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC in this case?

> @@ -6355,7 +6372,7 @@ static int addrconf_sysctl_stable_secret(struct ctl=
_table *ctl, int write,
>                 for_each_netdev(net, dev) {
>                         struct inet6_dev *idev =3D __in6_dev_get(dev);
>
> -                       if (idev) {
> +                       if (idev && !ipv6_addr_gen_use_softmac(idev)) {
>                                 idev->cnf.addr_gen_mode =3D
>                                         IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
>                         }
> @@ -6363,7 +6380,9 @@ static int addrconf_sysctl_stable_secret(struct ctl=
_table *ctl, int write,
>         } else {
>                 struct inet6_dev *idev =3D ctl->extra1;
>
> -               idev->cnf.addr_gen_mode =3D IN6_ADDR_GEN_MODE_STABLE_PRIV=
ACY;
> +               if (idev && !ipv6_addr_gen_use_softmac(idev))
> +                       idev->cnf.addr_gen_mode =3D
> +                               IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
>         }

... and in these two as well?

Since you haven't changed the netlink code, I assume that this address
is going to appear to userspace as IFA_F_STABLE_PRIVACY. I assume
that's what we want here? It's not really "stable", it's only as
stable as the MAC address. Does the text of the RFC support this
definition of "stable"?

Can it happen that the MAC address when the device is up and an IPv6
address already exists? If so, what happens to the address? Will the
system create a second stable privacy address when the next RA
arrives? That seems bad. But perhaps this cannot happen.
