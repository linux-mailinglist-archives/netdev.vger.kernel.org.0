Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A133269C7
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZWAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBZWAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:00:20 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFD9C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:59:40 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id d3so3544326uap.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mHH5qL34NUre2vvWl7OkTh1alfWjGTk1rti2H6Gn0ns=;
        b=hcFuwfCRmjRgsSdY0N4ggPOW2TRgJ/93jmWQ/xWK6oxDMat/18cOZ9x/KIE1arLFos
         00f7gPz8Z8vwF1vjSi2VPtDnbBuzom798fjJU+8H12H81UHQMkhwk3wmhEJiTOOmbf09
         A62TPiJPgpYOxnvGahhfX3cjm8rQTcWxEegruhMtPZ0XaAhpg/0YPZ3HMYDe6URYauAs
         S9kpV7mrqmVGF/4LepqrdFZ2r8UWoZs0dW3/9LWkJk+PvVrFMtuUfmiG4qY95vo/42B+
         5ND2UkV22rt6Rj4G49Sgt/Yyid7zoj1t9mLMxC5VJfl1btzSDPyrs9sZnTpU5Oj1MhDM
         ntCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mHH5qL34NUre2vvWl7OkTh1alfWjGTk1rti2H6Gn0ns=;
        b=o0Bw6m+Q0Ia6GYX8h1W6kzOMvRkTSR09eJnpm4lgvtPzQ90NH54/iC2iXGLvr7FBum
         eBFWvdfBNQm8/6sg1Pgglq/MwW67zlRcEfFmbcVjadYAke2iC9dIlC53kVWQv+oUcAFf
         AauHp+tpclYEk6lCzoGsNT8BN/wdavj+Qw8YXPyPjo3jmtC6YInm+BRleEpL5jbCh6En
         PdeoTstOn7iozbJYxxzWRQBxI5H0+nWo87UMIu/05GVSs0VqJPQG8fbEuqIFJlJyJWnV
         IZyqI2GiHwJPD0bF4kq9rP13BPpYuiZjHbSODhktmUZtTeeqTFzKlpXWo0ON2WUHX7GS
         pl7A==
X-Gm-Message-State: AOAM532EYez7kUVICUxsG2evHZy9o/56fBhLIio6QBKVCwZ/rlnA05EG
        uLmHHPvtT3iRZJf7J4OHd8q1QrQ8CtcwMAJUUHEEOA==
X-Google-Smtp-Source: ABdhPJyG3s/nTVGgTODHLIR4qOs0G84ZYd6sEeAVvluzaU2c6DlSl6MbjT4pGxD9sSuLO9k9/8aUHPIfQAXsTbxjyyQ=
X-Received: by 2002:ab0:7e89:: with SMTP id j9mr3564902uax.36.1614376779062;
 Fri, 26 Feb 2021 13:59:39 -0800 (PST)
MIME-Version: 1.0
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com> <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
 <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com> <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
 <d5b6a39496db4a4aa5ceb770485dd47c@AcuMS.aculab.com> <32E2B684-5D8C-41E3-B17A-938A5F784461@gmail.com>
 <CADVnQyk+hZX46gVogJpqMQrpQEPdPZRd=hr2zcYxTTtMZubY+g@mail.gmail.com>
In-Reply-To: <CADVnQyk+hZX46gVogJpqMQrpQEPdPZRd=hr2zcYxTTtMZubY+g@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 26 Feb 2021 13:59:26 -0800
Message-ID: <CANP3RGfTy089zgbzhLiUApSuMBZtn71szC6MWFkKdDQ-PN0XSA@mail.gmail.com>
Subject: Re: TCP stall issue
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Gil Pedersen <kanongil@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 9:50 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Feb 26, 2021 at 11:26 AM Gil Pedersen <kanongil@gmail.com> wrote:
> >
> >
> > > On 26 Feb 2021, at 15.39, David Laight <David.Laight@ACULAB.COM> wrot=
e:
> > >
> > > Some thoughts...
> > >
> > > Does a non-android linux system behave correctly through the same NAT=
 gateways?
> > > Particularly with a similar kernel version.
> > >
> > > If you have a USB OTG cable and USB ethernet dongle you may be able t=
o get
> > > android to use a wired ethernet connection - excluding any WiFi issue=
s.
> > > (OTG usually works for keyboard and mouse, dunno if ethernet support =
is there.)
> > >
> > > Does you android device work on any other networks?
> >
> > I have done some further tests. I managed to find another Android devic=
e (kernel 4.9.113), which thankfully does _not_ send the weird D-SACKs and =
quickly recovers, so the problem appears to be on the original device.
> >
> > Additionally, I have managed to do a trace on the WLAN AP, where I can =
confirm that all packets seem to be transferred without unnecessary modific=
ations or re-ordering. Ie. all segments sent from the server make it to the=
 device and any loss will be device local. As such this points to a driver-=
level issue?
> >
> > I don't have an ethernet dongle ready. I tried to connect using cellula=
r and was unable to replicate the issue, so this further points at a driver=
-level issue.
> >
> > Given that it now seems relevant, the device is an Android P20 Lite, ru=
nning a variant of Android 9.1 with an update from this year (kernel was bu=
ilt jan. 05 2021).
>
> Thanks for the details. Agreed, it does sound as if a wifi
> hardware/firmare/driver issue on that particular Android device is the
> most likely cause of those symptoms.
>
> The only sequence I can think of that would cause these  symptoms
> would be if the wifi hardware/firmer/driver on that device is somehow
> both:
>
> (1) duplicating each of the retransmit packets that it passes up the
> network stack, and
> (2) dropping the first ACK packet generated by the first of the two
> copies of the retransmit
>
> Though that sounds so unlikely that perhaps there is a different explanat=
ion...
>
> neal

I got pulled into this thread without any real background... so I'm
guessing a fair bit.

I'm not at all sure what 'P20 Lite' refers to, but assuming this is
talking about a Pixel 2020 (perhaps the Pixel 4a 5G) then they were
never released with Android 9 (Pie), but rather with Android 11 (R) --
there were I think some early dev versions on Android 10 (Q), but
definitely nothing on P.  Plus the kernel is 4.19 based, not 4.9.

Based on the above, I'd assume you're not talking about a pixel
phone... but rather some other P20 Lite - perhaps from Huawei.
For non-Google/Pixel devices, all I can really say is talk to the
chipset vendor / oem (manufacturer) and possibly the carrier...
There's usually tons of 'value add' added by them (chipset vendor /
oem) or because of them (carrier) - in particular in the kernel...
Maybe ask for your device's kernel GPL source...

Additionally 4.9 LTS is at 4.9.258, so the kernel on the device is
simply very old (though that might be the revision on a different
device?).

Cheers,
Maciej
