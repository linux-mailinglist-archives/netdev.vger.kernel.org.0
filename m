Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080F72CC860
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgLBUzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgLBUzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:55:00 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34AC061A48
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 12:54:12 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id g15so2895429ybq.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YWijZDU/blOi1OQt6j2dR7q4DPIdany4ktv51nqcokY=;
        b=KaKkjKev1jZGyphLthPg3ZdeE8mqoehEp5+YBXdshNg059TBZ7kTYR3CAPGosx3l1p
         /3r/yuSjNtDvOD0q+jltO1NxQ/GtHMy1na5Z0J3Eo9ipKmH0JTgKDrMTphHIPCAgADMQ
         mrSCRHFYzcldDxYhwnIF19ffol6IynXRk4ibIY6FME5XtQ/bJKXdch0aV804aO7gfTft
         JePTGaMYYTifVZA5OdhSV4BNj3l7ovRv+gFRR0nw/f/8Ngo/pijv6U08W8alsbl4Mxng
         dv7nFz+Uw8TFT6V+7J+NJ4i8czsS6Z4C718b9ClB6WPT10qcHQXwIy0RxNjKStNgHLQY
         83Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YWijZDU/blOi1OQt6j2dR7q4DPIdany4ktv51nqcokY=;
        b=O4qXwhqrjgQ1N7GZEyALQdBqFffJKNZrrR6kkpRVV2TLntDavAFFKaoSmCK/lPSHti
         f86Fj2m1C/2tmo3InvljjCEol+XvJnUdCAUotleADuJuFbIAVlcnNcq13xFmfJmEpIki
         qIztmvOGq80/jfTMjY0j6ysSokG0y3jzf4Y3BJ71Mrvna925DTUFG3F3onDc7WvvsVe/
         1Dup3pX0XxO+aFozAQHUhUZbCWY0pEZHdQmM+hFvnd8x8QNHP1dxVkku33TZVk1o6Xtp
         gY4dQMoZEtgXWTCheWrAbdYQD0egFSl50+JKqMWVMp7bif0d6VCGB06NJDWxhuDbk/hL
         5R3w==
X-Gm-Message-State: AOAM532SMJ3I6sasGB+o/DlZY4Hwjh4zT+dlCgcaF7CjJAqg+E4KamM6
        Nqaxc56PrWNsYzzxQlGxjAzg79VRZPF5wjUow82yMQ==
X-Google-Smtp-Source: ABdhPJxyci+RcPNvK6TXPRJ98FYC5eaIoWts8iAxPOHhMVJ4kbHf8X8XyQAj/6hBU2opYXYeVE8fNZgrPiJ2Aa52PeQ=
X-Received: by 2002:a25:e7ce:: with SMTP id e197mr6921487ybh.305.1606942450915;
 Wed, 02 Dec 2020 12:54:10 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan> <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com> <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
 <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
 <eb1a89d2-f0c0-1c10-6588-c92939162713@6wind.com> <CAF2d9jgVhk8wOyNcKewBXP+B16Jh2FGakU64UH3fhFA+cTaNSg@mail.gmail.com>
 <20201119205633.6775c072@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAF2d9jgHOqsQFHE7tMwkgAQv2N24t3UWcMrK+ZnmfYNXHsPWuQ@mail.gmail.com> <20201201183818.7d19b620@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201183818.7d19b620@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 2 Dec 2020 12:53:54 -0800
Message-ID: <CAF2d9jjT2xmL8yKr0BkEGQ0af7pG4o6eGksBRWjp+h+rJQJb3Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nicolas.dichtel@6wind.com, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
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

On Tue, Dec 1, 2020 at 6:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 1 Dec 2020 12:24:38 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > On Thu, Nov 19, 2020 at 8:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Do you have more details on what the use cases are that expect no
> > > networking?
> > >
> > > TBH I don't get the utility of this knob. If you want to write vaguel=
y
> > > portable software you have to assume the knob won't be useful, becaus=
e
> > > either (a) kernel may be old, or (b) you shouldn't assume to own the
> > > sysctls and this is a global one (what if an application spawns that
> > > expects legacy behavior?)
> > >
> > > And if you have to check for those two things you're gonna write more
> > > code than just ifuping lo would be.
> > >
> > > Maybe you can shed some more light on how it makes life at Google
> > > easier for you? Or someone else can enlighten me?
> > >
> > > I don't have much practical experience with namespaces, but the more
> > > I think about it the more pointless it seems.
> >
> > Thanks for the input.
> >
> > Sorry, I was on vacation and couldn't process this response earlier.
> >
> > There are two things that this patch is providing and let me understand=
 the
> > objections well.
> >
> > (a) Bring up lo by default
> > (b) sysctl to protect the legacy behavior
> >
> > Frankly we really dont have any legacy-behavior use case and one can
> > bring it back to life by just doing 'ifdown lo' if necessary.
>
> If use cases depending on legacy behavior exist we are just trading the
> ifup in one case for an ifdown in another.
>
Yes, I would agree with this if the use-cases are 50/50 but I would
say it's more like 99/1 distribution (99% of the time if not higher
times lo is required to be UP and probably 1% of the time or less it's
 down)

> Unless we can dispel the notion that sand-boxing by lo down is a
> legitimate use case IMO we're just adding complexity and growing
> a sysctl for something that can be trivially handled from user space.
>
OK, I can remove the sysctl and just have the 3 line patch.



> > Most of
> > the use cases involve using networking anyways. My belief was that we
> > need to protect legacy behavior and hence went lengths to add sysctl
> > to protect it. If we are OK not to have it, I'm more than happy to
> > remove the sysctl and just have the 3 line patch to bring loopback up.
> >
> > If legacy-behavior is a concern (which I thought generally is), then
> > either we can have the sysctl to have it around to protect it (the
> > current implementation) but if we prefer to have kernel-command-line
> > instead of sysctl that defaults to legacy behavior but if provided, we
> > can set it UP by default during boot (or the other way around)?
> >
> > My primary motive is (a) while (b) is just a side-effect which we can
> > get away if deemed unnecessary.
>
