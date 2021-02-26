Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B148832667A
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 18:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBZRvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 12:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZRvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 12:51:33 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE75BC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:50:52 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id 62so3296966uar.13
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fxb6yJzM1uB6Kf5JL0eSskJ1nCBPgKpwN7GXZzemYuk=;
        b=LImAf87q/bLRtRCN/TsLrr4ZrvQ7uQJHctBakGygq7fL5HqB8UwD0AItpkIiuaZWl8
         f1VsZ/nZ/9inWFtt6hBLQFPQJrK5VEjcqAxya91HTRr7k40lVMju1ZtPHwAV7bICZ7Pg
         k7xd2wrz/THs+ikTyXLFd8lIqCJPO4W0qIpe5Q/pj2Qo1FN0kPZV+Wq4brdLrqTF6zDE
         iyGM6MjeCJ7qJ5QDyKZgSzw/58v7FrBcm0j3gZ8W7pRSMVCCwAseiBPdKsSvK3aIqNjf
         XgNezqoq3GMOZFHNigBo0fuDDUw+dagxdW1bMy7AvwXMN04wvLEewidVgnwW7/GPhJ3J
         kOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fxb6yJzM1uB6Kf5JL0eSskJ1nCBPgKpwN7GXZzemYuk=;
        b=K5UxtJsQFA0R99wPDD/UZKOOKtLS+Nqcfn8m1uHajUssOYF3h7ZArWThFhcSRBMdow
         kQfB5142EiXHdALkPawetRkZyHR8+W0tYyfvCD8CAvDSd1uaJxBUSshgpMq2mwSgs0s7
         S1M7X8ZuPrdcYODYa7h+Dll9L2NZDU/WPS1V3482Eq1jjde4//4oBbjkCRs2tKFmL4b4
         diWr1flEeeGI2kjQlOGvgT+5Dx9M90AHMBtAlJ08uBhGcrmi+/c7hulwDp/87sqcKLsT
         51FOHZuHVjJkMiKIn1Rr5O7aNOyMGb0xk3PdATyWAY9G2wggOAr+/jG3UwCFkz+MD66X
         NMSA==
X-Gm-Message-State: AOAM533mH1gPR6NOvDxP2i8UUUWYt0TtgVAVQU1w7/EzTdqlD6f2qpsv
        FnDHMtg4XZWH+UquDaG7TUM4iFzwxY+Um1dPElzcbg==
X-Google-Smtp-Source: ABdhPJzHRvIz3Zhna5m9f30rda1rI5KMs35hZ8PKZHHCgPEVbcKj1zqXRPiMlGS9FNnunuEHbCkn19AgYBcnGtJvREE=
X-Received: by 2002:ab0:45c9:: with SMTP id u67mr2951639uau.46.1614361851094;
 Fri, 26 Feb 2021 09:50:51 -0800 (PST)
MIME-Version: 1.0
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com> <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
 <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com> <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
 <d5b6a39496db4a4aa5ceb770485dd47c@AcuMS.aculab.com> <32E2B684-5D8C-41E3-B17A-938A5F784461@gmail.com>
In-Reply-To: <32E2B684-5D8C-41E3-B17A-938A5F784461@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 26 Feb 2021 12:50:34 -0500
Message-ID: <CADVnQyk+hZX46gVogJpqMQrpQEPdPZRd=hr2zcYxTTtMZubY+g@mail.gmail.com>
Subject: Re: TCP stall issue
To:     Gil Pedersen <kanongil@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 11:26 AM Gil Pedersen <kanongil@gmail.com> wrote:
>
>
> > On 26 Feb 2021, at 15.39, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > Some thoughts...
> >
> > Does a non-android linux system behave correctly through the same NAT g=
ateways?
> > Particularly with a similar kernel version.
> >
> > If you have a USB OTG cable and USB ethernet dongle you may be able to =
get
> > android to use a wired ethernet connection - excluding any WiFi issues.
> > (OTG usually works for keyboard and mouse, dunno if ethernet support is=
 there.)
> >
> > Does you android device work on any other networks?
>
> I have done some further tests. I managed to find another Android device =
(kernel 4.9.113), which thankfully does _not_ send the weird D-SACKs and qu=
ickly recovers, so the problem appears to be on the original device.
>
> Additionally, I have managed to do a trace on the WLAN AP, where I can co=
nfirm that all packets seem to be transferred without unnecessary modificat=
ions or re-ordering. Ie. all segments sent from the server make it to the d=
evice and any loss will be device local. As such this points to a driver-le=
vel issue?
>
> I don't have an ethernet dongle ready. I tried to connect using cellular =
and was unable to replicate the issue, so this further points at a driver-l=
evel issue.
>
> Given that it now seems relevant, the device is an Android P20 Lite, runn=
ing a variant of Android 9.1 with an update from this year (kernel was buil=
t jan. 05 2021).

Thanks for the details. Agreed, it does sound as if a wifi
hardware/firmare/driver issue on that particular Android device is the
most likely cause of those symptoms.

The only sequence I can think of that would cause these  symptoms
would be if the wifi hardware/firmer/driver on that device is somehow
both:

(1) duplicating each of the retransmit packets that it passes up the
network stack, and
(2) dropping the first ACK packet generated by the first of the two
copies of the retransmit

Though that sounds so unlikely that perhaps there is a different explanatio=
n...

neal
