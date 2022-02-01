Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3524A53B0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiBAAEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiBAAEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:04:54 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB52C06173B;
        Mon, 31 Jan 2022 16:04:53 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c23so28573765wrb.5;
        Mon, 31 Jan 2022 16:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBTkWatVoRf7mAdGB+dxqdrFr+qHLJMbIjv4D9cDcgo=;
        b=TBJ927R42fEKQRHDCZwUtOu36hzRyfRJsPlcE/1UdzjrlxTJFtVUPuLSlgDZjUQ+2W
         Z3W+dB7jP1VfW6t3WrYC+M5vxkr5YYLN4zoGmqLdo09tV1KIciPgD9CB2uT7RZePT6Cl
         hsXmYPCUl4B3dFzZBC38bLeGTy+68fYdt6Szm584Bm85cCtUuLOgPHqyq1NXfJci0xeS
         ofKg054YZTGxbzRKliDMUfgi2wDWIHr/XFwxsgKau0mqHW0Fho1arsqpNxUVSYs/FyM8
         dNBICrxyTFwJ4mzrt68vgOpGqozqK/WuANPgcegmwlHH7omsKEdPUCaJCQOwm1cGKC6n
         mSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBTkWatVoRf7mAdGB+dxqdrFr+qHLJMbIjv4D9cDcgo=;
        b=lGhTashChUKzCLV1VAtpWlVYinLJJPmspIEhIux7YBmjgd9/hTmP+JAmdZpGEfyW1+
         86B4Z7Je8Xa7dSannP9hOVyaImpQiM1PmdYSvdygvCW7eNpC1uY9aPdGxR5x71yEx8Tg
         C4f+tCN6R38gi2jxnTSMD8xRAa1E2Y/60TliHc5b+h5EVNsiL0TwZGftotaAuYnOL1I+
         qIwWFJXnmxFFqaibMWr4+6rz9tvJ2deb6y+mxRofd9hXgz+RCXEvQRGV/ajIUuR3wLSh
         HYHWqieAfrxxWk4zMnZfx5cWjiJaitv4RPupI33YLqXPNIJGZf+T2Wj/DhS/JD4zaS/n
         LoEQ==
X-Gm-Message-State: AOAM531i7fLzCU5NHtVs+usy0EIKqwo8yAX1aXD41I0H5E1kiBS3Psh5
        iIrhalKJOxJ77XQiqhCzRMN3WZTNTjYwDDTc26U=
X-Google-Smtp-Source: ABdhPJzGV4y3Ta1GE0TKjv9FhswpUz4QxbLaboPqV49koQL/GO1e6pYU1VRUkwW2oJZhJMONypsZH7NsIq4Ll5FPnYs=
X-Received: by 2002:a5d:47c2:: with SMTP id o2mr19465998wrc.81.1643673892365;
 Mon, 31 Jan 2022 16:04:52 -0800 (PST)
MIME-Version: 1.0
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-2-miquel.raynal@bootlin.com> <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
 <20220131152345.3fefa3aa@xps13>
In-Reply-To: <20220131152345.3fefa3aa@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 31 Jan 2022 19:04:40 -0500
Message-ID: <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 31, 2022 at 9:23 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:35:35 -0500:
>
> > Hi,
> >
> > On Fri, Jan 28, 2022 at 6:08 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > The idea here is to create a structure per set of channels so that we
> > > can define much more than basic bitfields for these.
> > >
> > > The structure is currently almost empty on purpose because this change
> > > is supposed to be a mechanical update without additional information but
> > > more details will be added in the following commits.
> > >
> >
> > In my opinion you want to put more information in this structure which
> > is not necessary and force the driver developer to add information
> > which is already there encoded in the page/channel bitfields.
>
> The information I am looking forward to add is clearly not encoded in
> the page/channel bitfields (these information are added in the
> following patches). At least I don't see anywhere in the spec a
> paragraph telling which protocol and band must be used as a function of
> the page and channel information. So I improved the way channels are
> declared to give more information than what we currently have.
>

This makes no sense for me, because you are telling right now that a
page/channel combination depends on the transceiver.

> BTW I see the wpan tools actually derive the protocol/band from the
> channel/page information and I _really_ don't get it. I believe it only
> works with hwsim but if it's not the case I would like to hear
> more about it.
>

No, I remember the discussion with Christoffer Holmstedt, he described
it in his commit message "8.1.2 in IEEE 802.15.4-2011".
See wpan-tools commit 0af3e40bbd6da60cc000cfdfd13b9cdd8a20d717 ("info:
add frequency to channel listing for phy capabilities").

I think it is the chapter "Channel assignments"?

> > Why not
> > add helper functionality and get your "band" and "protocol" for a
> > page/channel combination?
>
> This information is as static as the channel/page information, so why
> using two different channels to get it? This means two different places
> where the channels must be described, which IMHO hardens the work for
> device driver writers.
>

device drivers writers can make mistakes here, they probably can only
set page/channel registers in their hardware and have no idea about
other things.

> I however agree that the final presentation looks a bit more heavy to
> the eyes, but besides the extra fat that this change brings, it is
> rather easy to give the core all the information it needs in a rather
> detailed and understandable way.

On the driver layer it should be as simple as possible. If you want to
have a static array for that init it in the phy register
functionality, however I think a simple lookup table should be enough
for that.
To make it more understandable I guess some people can introduce some
defines/etc to make a more sense behind setting static hex values.

- Alex
