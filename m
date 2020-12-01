Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23BF2CAD43
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392330AbgLAUZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgLAUZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:25:41 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016ADC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:24:55 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id 2so3043910ybc.12
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 12:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AuVsLAhJp0nLXhm6R/uaAUmnr1YAL9TIkrSIEpuUxlE=;
        b=kQKlJelIQAMV/FBrUOB5svMaLoIq1KKFj+5YLnYOr51lo4DLF6G4BuOdERS8anionq
         URXeWaJoAdqIAIkpQ+3aN4nUKQYyuoGv+DgXOrRl06LOjifsB2oCnKbAfpH03H7I+uhJ
         js1XPZbvr2/du0An7bP8NKrsAlp/gPrSMyXYTWnw4n9TlRGq/usydRQS59nUeyE2GIJI
         MG1sZnmo43h9tdNAbggSEk+OBVXXJBcYH8p/5ooYA7Tbt6Eme6+Y1IiL7nLq8U/LW9DC
         M2RspI+LkudPQRO2UkWQe0neVCKwo8aZ67qpXcNfWBOB3Scd0G8X1DrX+/aDWj70cDxx
         O4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AuVsLAhJp0nLXhm6R/uaAUmnr1YAL9TIkrSIEpuUxlE=;
        b=XxbeFfzOC8KasLs7Z4DRHcXhWo+736c7KOmraVhmNLP4yBPFnluaI7D2B8yAms6E+U
         B6L0ieV6mStC221bEF6dE0oSarrFVKRsat7pvrWZE0y4O5Nc9krX2oQICqOUv3U6qUk2
         M+NEvDFDpwszfRQ2cwcjE47ikjyYWC6vRXGD6MQVAamAnJu+c6ZBWchq88BI+fT1DkJd
         kiltIQMV38hk5f+BmeflIIGvaQaaN0roslfSkE7bTXxbsOe5xjfOGmpkOlUKORMb6zP2
         uM4+u8Fbfq1t10UiUEoflbz6kzNen5378JBiiC6Tq0JE/l+m1jH6IAqlY0x4KNmpMpGa
         1SGA==
X-Gm-Message-State: AOAM533zSAQC78ivmbDu6n5Cedpn+yC3nHzYPyLZf9xxZiV3f3nxUMfu
        37Mt1X5uXGVPvyGYX28E2K5Jap6oBG70+4NL0GkcdQ==
X-Google-Smtp-Source: ABdhPJzf8ruWggphZs5ETDCBK8WA9SH4F88TrW05dRqZfak77VUgrurYplK+DtiHA2oMhNOJjBy+JfE9wLgSZW00fu4=
X-Received: by 2002:a25:6951:: with SMTP id e78mr6592469ybc.42.1606854294835;
 Tue, 01 Dec 2020 12:24:54 -0800 (PST)
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
In-Reply-To: <20201119205633.6775c072@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 1 Dec 2020 12:24:38 -0800
Message-ID: <CAF2d9jgHOqsQFHE7tMwkgAQv2N24t3UWcMrK+ZnmfYNXHsPWuQ@mail.gmail.com>
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

On Thu, Nov 19, 2020 at 8:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Nov 2020 19:55:08 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > On Thu, Nov 19, 2020 at 12:03 AM Nicolas Dichtel
> > > Le 18/11/2020 =C3=A0 18:39, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) a =C3=A9crit :
> > > > netns but would create problems for workloads that create netns to
> > > > disable networking. One can always disable it after creating the ne=
tns
> > > > but that would mean change in the workflow and it could be viewed a=
s
> > > > regression.
> > > The networking is very limited with only a loopback. Do you have some=
 real use
> > > case in mind?
> >
> > My use cases all use networking but I think principally we cannot
> > break backward compatibility, right?
> > Jakub, WDYT?
>
> Do you have more details on what the use cases are that expect no
> networking?
>
> TBH I don't get the utility of this knob. If you want to write vaguely
> portable software you have to assume the knob won't be useful, because
> either (a) kernel may be old, or (b) you shouldn't assume to own the
> sysctls and this is a global one (what if an application spawns that
> expects legacy behavior?)
>
> And if you have to check for those two things you're gonna write more
> code than just ifuping lo would be.
>
> Maybe you can shed some more light on how it makes life at Google
> easier for you? Or someone else can enlighten me?
>
> I don't have much practical experience with namespaces, but the more
> I think about it the more pointless it seems.

Thanks for the input.

Sorry, I was on vacation and couldn't process this response earlier.

There are two things that this patch is providing and let me understand the
objections well.

(a) Bring up lo by default
(b) sysctl to protect the legacy behavior

Frankly we really dont have any legacy-behavior use case and one can
bring it back to life by just doing 'ifdown lo' if necessary. Most of
the use cases involve using networking anyways. My belief was that we
need to protect legacy behavior and hence went lengths to add sysctl
to protect it. If we are OK not to have it, I'm more than happy to
remove the sysctl and just have the 3 line patch to bring loopback up.

If legacy-behavior is a concern (which I thought generally is), then
either we can have the sysctl to have it around to protect it (the
current implementation) but if we prefer to have kernel-command-line
instead of sysctl that defaults to legacy behavior but if provided, we
can set it UP by default during boot (or the other way around)?

My primary motive is (a) while (b) is just a side-effect which we can
get away if deemed unnecessary.
