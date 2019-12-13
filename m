Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9811DB01
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbfLMAQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 19:16:18 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33412 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731184AbfLMAQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:16:17 -0500
Received: by mail-io1-f68.google.com with SMTP id s25so609653iob.0
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 16:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fhx/o/Pv1jKO2VN20lZS4U3D0OWihtm5CE7vV8mMIQI=;
        b=BYQ3mPdXtaWu+GYbSo2EbcO4eeMH+Fb3l3klt2gfIT2IkPen3VBvtrBTo6BruzEDl6
         mifIROamB8UEziu9ZaB2wu7AjiYkoJaAOK/SXSVIzx0Qu8cQC9ePMinYTs2uh1SRWxmY
         YDDhI/bwZX2p757KzmVIVPRfs80dZfV2ys3dxHQrPEFg1L5v778fGNs9XlVShSOHZQM8
         CJ0Zz1RmIESneN0s2zrADn5LZGtvOuL1/X0EW2gB+/UHY+/cT6BzAtu6PGgZ/s494SJz
         mEKthYXBwdT2dMlPK5FVMROXYTrt04vlJucGDpBvOz3S73bh5OM0pCO6lbTynammQ/H6
         EFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fhx/o/Pv1jKO2VN20lZS4U3D0OWihtm5CE7vV8mMIQI=;
        b=ay2851rj4VpgUWlueGM+dUqp5aXIZlqUk/bnUo7tEVsfVjo3MejNrwGsikX9LAPkPM
         Il+aY/bzQ4hQcd0INTd9nCipksUf0t3lPw8F35paq3vWGVKOZK0UGQiE4qxOitTM/loa
         HNcJAQlYlUqH7qpL3aySpO8CqF15G+CVjbZVAkA751M750O05xobM4OSYqq+XXVK5PnT
         TUyRx7ZlUgl1ghSPrHuYfEmmWzeP3WUb6bQv5kuNb0rZtj7TRcBqx9Fdw7ymXBe+Z91u
         obBtYn45iXObDvBJL0z00ZDAvjcGr3FUVkKIyMYxlJgUEwyNevZzyFbRA2qZNpJKfvyh
         TaAQ==
X-Gm-Message-State: APjAAAWzksO/7b92RuAR0dwCbFlm8Io2etnGHsMA04piKKPl15S+RHGy
        WwvE8HUbraLTI4menV/3HKwTCmuG3sdQmRWtvtp4U27b8Bk=
X-Google-Smtp-Source: APXvYqzKGGPDRDFfatMrOymOR3BopDiiGJG/yGfUw3OfUsYXTKNwWRjXmEc0wjrYlA+7NwB3IfpEu5heBfA6RXN7epc=
X-Received: by 2002:a6b:3105:: with SMTP id j5mr5744700ioa.170.1576196176419;
 Thu, 12 Dec 2019 16:16:16 -0800 (PST)
MIME-Version: 1.0
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com> <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com> <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
 <20191210093111.7f1ad05d@cakuba.netronome.com>
In-Reply-To: <20191210093111.7f1ad05d@cakuba.netronome.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Fri, 13 Dec 2019 09:16:03 +0900
Message-ID: <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 2:31 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> I don't consider users of non-vanilla kernels to necessarily be a
> reason to merge patches upstream, no. They carry literally millions
> of lines of patches out of tree, let them carry this patch, too.
> If I can't boot a vanilla kernel on those devices, and clearly there is
> no intent by the device manufacturers for me to ever will, why would I
> care?

That's *not* the intent.
https://arstechnica.com/gadgets/2019/11/google-outlines-plans-for-mainline-linux-kernel-support-in-android/

> > The reason Android runs non-vanilla kernels is *because* patches like
> > this - that make Linux work in the real world - are missing from
> > vanilla Linux

That's exactly the point here. Saying, "Android will never use
mainline, so why should mainline take their patches" is a
self-fulfilling prophecy. Obviously, if mainline never takes Android
patches, then yes, Android will never be able to use mainline. We do
have an Android tree we can take this patch into. But we don't want to
take it without at least attempting to get it into mainline first.

The use case here is pretty simple. There are many CPUs in a mobile
phone. The baseband processor ("modem") implements much of the
functionality required by cellular networks, so if you want cellular
voice or data, it needs to be able to talk to the network. For many
reasons (architectural, power conservation, security), the modem needs
to be able to talk directly to the cellular network. This includes,
for example, SIP/RTP media streams that go directly to the audio
hardware, IKE traffic that is sent directly by the modem because only
the modem has the keys, etc. Normally this happens directly on the
cellular interface and Linux/Android is unaware of it. But, when using
wifi calling (which is an IPsec tunnel over wifi to an endpoint inside
the cellular network), the device only has one IPv4 address, and the
baseband processor and the application processor (the CPU that runs
Linux/Android) have to share it. This means that some ports have to be
reserved so that the baseband processor can depend on using them. NAT
cannot be used because the 3GPP standards require protocols that are
not very NAT-friendly, and because the modem needs to be able to
accept unsolicited inbound traffic.

Other than "commit message doesn't have a use case", are there
technical concerns with this patch?
