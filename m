Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56F02B8521
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgKRTyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRTyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:54:18 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F957C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 11:54:18 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id l14so2867479ybq.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 11:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8bgKYchYM+nfbrr1GYtm4pfVBjrHm8YD9MQK640tk3o=;
        b=qRpeAS+bmvZSzyJ4t3jKqlThky4GJ61rSpKwEF/bwrkN/2OgXxha7d56tezehXoiWB
         a+FrD3XXWdmAGHdUFg6bG+TFkjj11c/5htHQ356SbeMYs5tE92ScLLU7WimxsV+mNt2r
         EiGeJSQzDumFfBzzwgjiuxgsbgoWg/SK3gof6mpNBRtps/bTQVhYs6WNiJHFiQPRTD3d
         QXDPoyWmm0kDqKlHB6d4xjfnCne8+n1ggG2yfYN6xYLug9n61JlKjnCxOIbP3ph6ukuW
         4Aa70jtvm7vTXXcFfHi6Y09u/OEWBRglhnrHu1wQDRJDLPd1b+kYKsVT9ACXf/wEJgBh
         DvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8bgKYchYM+nfbrr1GYtm4pfVBjrHm8YD9MQK640tk3o=;
        b=CE8Eo8le1SEOwstSplpz8hQJlGn1eiG961oV/JWpPOB43L8qyZtJ1LwsMbxunaQR8r
         M8KUBkInH7dJtR8rUlKSYb+ioU+vKIAYMM6pgWFJa96OPbHoYYvyNAgxOuhtGS3KAv2z
         Ps/2fcqWaqBQmglE9bQ+dbk47FNOlRzy3LNQoJ/teYph4m1Wmr+fNYxJSNHw+ZNTLF+b
         5Z/3Rm4fReLWF7BW2ofHyZUE2FS6jRt9XOObQmULdrBl/9g0wPGUsr5iC0tQ7B6MDHXY
         M3y7mSQYgwQljijkusW3DQUgILJzfWWjtQxR2gI9KHIczqTlmkd5eiSlC4l5guEl+QA1
         y4qQ==
X-Gm-Message-State: AOAM531uCyTh8s5HPUyt8WGlxriA/AM7kb1xyYp4Ll5Hgxfe5vM1tnfg
        Rf4K1Zx3qoMHH+wdpR5hLamc+P+QlBwZ9hruVK4RvBPkPkQ=
X-Google-Smtp-Source: ABdhPJxTuapO0G6IJrrkNNVFcECaBL6BIDWdvMeIcWSp2bkBWrh7++G5xYWTMCd0bu6tAlbEZ3CmFGFL+9HZqUMpYfI=
X-Received: by 2002:a25:6ec3:: with SMTP id j186mr8398593ybc.335.1605729257515;
 Wed, 18 Nov 2020 11:54:17 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan> <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com> <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
 <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com> <7b3f1d07-eca4-b012-c46a-e1f09bba9d6f@gmail.com>
In-Reply-To: <7b3f1d07-eca4-b012-c46a-e1f09bba9d6f@gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 18 Nov 2020 11:54:01 -0800
Message-ID: <CAF2d9jgJZYtv3fEqB58rK+sFoT_zibvYyQdq64o6=Pgx7EY4+w@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     David Ahern <dsahern@gmail.com>
Cc:     nicolas.dichtel@6wind.com, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 10:04 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/18/20 10:39 AM, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=
=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
> > On Wed, Nov 18, 2020 at 8:58 AM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> >>
> >> Le 18/11/2020 =C3=A0 02:12, David Ahern a =C3=A9crit :
> >> [snip]
> >>> If there is no harm in just creating lo in the up state, why not just=
 do
> >>> it vs relying on a sysctl? It only affects 'local' networking so no r=
eal
> >>> impact to containers that do not do networking (ie., packets can't
> >>> escape). Linux has a lot of sysctl options; is this one really needed=
?
> >>>
> > I started with that approach but then I was informed about these
> > containers that disable networking all together including loopback.
> > Also bringing up by default would break backward compatibility hence
> > resorted to sysctl.
> >> +1
> >>
> >> And thus, it will benefit to everybody.
> >
> > Well, it benefits everyone who uses networking (most of us) inside
> > netns but would create problems for workloads that create netns to
> > disable networking. One can always disable it after creating the netns
> > but that would mean change in the workflow and it could be viewed as
> > regression.
> >
>
> Then perhaps the relevant sysctl -- or maybe netns attribute -- is
> whether to create a loopback device at all.

I'm open to ideas within the bounds of maintaining backward
compatibility. However, not able to see how we can pull it off without
creating a 'loopback' device.
