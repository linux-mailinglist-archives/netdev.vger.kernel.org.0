Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD2C2BA157
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgKTDz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgKTDz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:55:27 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A466C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:55:25 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v92so7348101ybi.4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5FzFYaey8liBWPJFQwuMtk0+xYf//gOPidhBjOFWJJo=;
        b=NWRbI5bK4VwLwrauuA4RZ7iGNnK8D5r6VpE42X7O3jpgyh1h+mvGwlwlsqtp6yCjjl
         9BbwV8+iFE63ZtdY1mXYIrRt1oPsaGcnyTmfpwEY60cuPU0zX+XMebcO/FnhbaY5CFpc
         6B73IAayiMPunhrK1SmHbFxdOT3J3K27ECCoPvekYWdX2sO7tfteMs1bQ4jE4OhcULYb
         SmUdU0SmluaF3jukJDHEol+UxQO66ltzh5r2/j9VMph9aWaZC2wdB409wK02cqQphp+c
         /BVBpoizicMdsriygGNFgBeZyS9SzxQ0jNH4MmWa49xeRUH0cr08saddeD7d00mVzdS1
         5Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5FzFYaey8liBWPJFQwuMtk0+xYf//gOPidhBjOFWJJo=;
        b=A3riBEYsD7l3NDoAatAPFbUpls/dUUjuvfShRK7wEWpwekGuYjv4H6Wkez1EHdpCh/
         QDAZl9rEbFqb27HJufA4tERqKFDkvHZInJW3Snt80jfHMx5YP6nNFPk8UwM5YZDz2R9U
         ZYYctPW4Y1OG2rmDizVVKCdxgd2ktw0oQgeHQHHjf6ZMWqnXt6wI5td/eFW9rGjSVO6M
         V7RX7leitwHBZWlZfWhtUfDVlKT2Mv+63UwwhJmg/s1Lnzpv5bkFH/jGx4wdMTKlFCkr
         FzeTskzEX82mbbIcOCkIpvMlGhbiC7+Kb9q4fYCqA0isduvgXmnZ4F2hilkyfNPxb4Y0
         t+Hg==
X-Gm-Message-State: AOAM532W4LAaMywMUQsFdOwkNcboI3h8hHNAph25ZiK2CAkbissj6c8S
        cXxFW5jr4VHjtf3Lf83E9b5ecwY3s8xQ5Z2/S8L+9Q==
X-Google-Smtp-Source: ABdhPJxL9gRQiWuSir7oJokARLblIw7pfGlutKoNggm+9lZQXmMb6ZjasAEB3nZU2Er8gR5xjTv57P7WoCdTMBe7vY4=
X-Received: by 2002:a25:848e:: with SMTP id v14mr17604149ybk.153.1605844524054;
 Thu, 19 Nov 2020 19:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan> <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com> <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
 <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com> <eb1a89d2-f0c0-1c10-6588-c92939162713@6wind.com>
In-Reply-To: <eb1a89d2-f0c0-1c10-6588-c92939162713@6wind.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 19 Nov 2020 19:55:08 -0800
Message-ID: <CAF2d9jgVhk8wOyNcKewBXP+B16Jh2FGakU64UH3fhFA+cTaNSg@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     nicolas.dichtel@6wind.com
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
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

On Thu, Nov 19, 2020 at 12:03 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 18/11/2020 =C3=A0 18:39, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=
=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) =
a =C3=A9crit :
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
> Sure.
>
> > netns but would create problems for workloads that create netns to
> > disable networking. One can always disable it after creating the netns
> > but that would mean change in the workflow and it could be viewed as
> > regression.
> The networking is very limited with only a loopback. Do you have some rea=
l use
> case in mind?

My use cases all use networking but I think principally we cannot
break backward compatibility, right?
Jakub, WDYT?
