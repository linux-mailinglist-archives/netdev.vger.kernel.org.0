Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611EC64FC51
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 21:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLQU5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 15:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQU5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 15:57:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E00F595;
        Sat, 17 Dec 2022 12:57:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s7so5534883plk.5;
        Sat, 17 Dec 2022 12:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsNOLxzzDUM86Dcn9dtIU2NoBPxLljweQcBTZ9NLmX0=;
        b=NRoAcBbcipvkcWU+CrzfHGM0nUY5XYUY5Vu4Wc12W2t89xJ9XulTFG7jyWkGSa71Gt
         mllSuPp5KWY/+A857nHJMdJeQXAW8AGki/Je3W3G4KkljZYN+9VE0KQX4Pl+uEdHUTv9
         GjnGN1Rqrt9VYttVsNd3AXiETiNZeaWFg7HfMq6wzM0jqvZmnonziwYfqzqLvawSdKiT
         xfXXgunFytHbHT/bg9p36z6NAu9qdIGSEr8eMQEE5VPKc90IcNb0Oupr6p8yQugw8HTD
         z+bv/VLY6fbGVR2uFE6FBerxybA/rlEn/DqMnHu7exuToWrAs+zqMhKe7CXjimrJk2z8
         iM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UsNOLxzzDUM86Dcn9dtIU2NoBPxLljweQcBTZ9NLmX0=;
        b=rX6pI0qsBoX1vUxScGJGzKWyvPNTVpRJWn1FqqKI+DdAdUNT44mBHOgIODVXTbh35x
         KBcS5IKeYA+IZhksGxaNwG1tSTBUCMNhHhJ1GRG4BatEQ+paLjRUgVRbZGTTfI2lpshJ
         /08WTGiR40GVXsOb/us2vu2+Ecdymhapee0m90DO0BLGHo6SBUqC3uuBYGOo9yxOlDOS
         JMoMeYrdXpH7mrj02XR+c3LCW73pnwQQU8lWwXlMxFOtdJf4iBnF5nFO36QIxCF/44V+
         1dYOpVW3YgElLmOynzlPZnMQQlPqcLsG2DNvKf2kCAGePRHyuBzaustAbhoIxcyG0D7s
         YiPg==
X-Gm-Message-State: ANoB5plMvoBu7NprAy4mGmUWKgTzaKSgVPypNY4L2IWo1xAQxaiL1yrZ
        HTjKFGmtI+JscAer/xKqRQ5RF0UnpVV7qIKEXCs=
X-Google-Smtp-Source: AA0mqf549V4Hy9hQmdroy9lbhZgtpKHGpFAj3mvSEPHGZPUx03/UlmcXbTq/idXKLOQxISPWDsgcM14OQmV3Tp4ENOg=
X-Received: by 2002:a17:902:9a8b:b0:190:c917:ab61 with SMTP id
 w11-20020a1709029a8b00b00190c917ab61mr1172194plp.93.1671310633744; Sat, 17
 Dec 2022 12:57:13 -0800 (PST)
MIME-Version: 1.0
References: <20221213004754.2633429-1-peter@pjd.dev> <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
 <7A3DBE8E-C13D-430D-B851-207779148A77@pjd.dev> <CAKgT0Uf-9XwvJJTZOD0EHby6Lr0R-tMYGiR_2og3k=d_eTBPAw@mail.gmail.com>
 <09CDE7FD-2C7D-4A0B-B085-E877472FA997@pjd.dev>
In-Reply-To: <09CDE7FD-2C7D-4A0B-B085-E877472FA997@pjd.dev>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 17 Dec 2022 12:57:02 -0800
Message-ID: <CAKgT0UfOnJGf+n_PTizCyq77H+ZvWMU4i=D=GW3o13RNqWf-Gg@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Always use unicast source MAC address
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 8:20 PM Peter Delevoryas <peter@pjd.dev> wrote:
>
>
>
> > On Dec 16, 2022, at 10:29 AM, Alexander Duyck <alexander.duyck@gmail.co=
m> wrote:
> >
> > On Thu, Dec 15, 2022 at 5:08 PM Peter Delevoryas <peter@pjd.dev> wrote:
> >>
> >>
> >>
> >>> On Dec 13, 2022, at 8:41 AM, Alexander H Duyck <alexander.duyck@gmail=
.com> wrote:
> >>>
> >>> On Mon, 2022-12-12 at 16:47 -0800, Peter Delevoryas wrote:

<...>

> >
> >>> My main
> >>> concern would be that the dev_addr is not initialized for those first
> >>> few messages so you may be leaking information.
> >>>
> >>>> This might have the effect of causing the NIC to learn 2 MAC address=
es from
> >>>> an NC-SI link if the BMC uses OEM Get MAC Address commands to change=
 its
> >>>> initial MAC address, but it shouldn't really matter. Who knows if NI=
C's
> >>>> even have MAC learning enabled from the out-of-band BMC link, lol.
> >>>>
> >>>> [1]: https://tinyurl.com/4933mhaj
> >>>> [2]: https://tinyurl.com/mr3tyadb
> >>>
> >>> The thing is the OpenBMC approach initializes the value themselves to
> >>> broadcast[3]. As a result the two code bases are essentially doing th=
e
> >>> same thing since mac_addr is defaulted to the broadcast address when
> >>> the ncsi interface is registered.
> >>
> >> That=E2=80=99s a very good point, thanks for pointing that out, I hadn=
=E2=80=99t
> >> even noticed that!
> >>
> >> Anyways, let me know what you think of the traces I added above.
> >> Sorry for the delay, I=E2=80=99ve just been busy with some other stuff=
,
> >> but I do really actually care about upstreaming this (and several
> >> other NC-SI changes I=E2=80=99ll submit after this one, which are unre=
lated
> >> but more useful).
> >>
> >> Thanks,
> >> Peter
> >
> > So the NC-SI spec says any value can be used for the source MAC and
> > that broadcast "may" be used. I would say there are some debugging
> > advantages to using broadcast that will be obvious in a packet trace.
>
> Ehhhhh yeah I guess, but the ethertype is what I filter for. But sure,
> a broadcast source MAC is pretty unique too.
>
> > I wonder if we couldn't look at doing something like requiring
> > broadcast or LAA if the gma_flag isn't set.
>
> What is LAA? I=E2=80=99m out of the loop

Locally administered MAC address[4]. Basically it is a MAC address
that is generated locally such as your random MAC address. Assuming
the other end of the NC-SI link is using a MAC address with a vendor
OUI there should be no risk of collisions on a point-to-point link.
Essentially if you wanted to you could probably just generate a random
MAC address for the NCSI protocol and then use that in place of the
broadcast address.

> But also: aren=E2=80=99t we already using broadcast if the gma_flag isn=
=E2=80=99t set?
>
> -       if (nca->ndp->gma_flag =3D=3D 1)
> -               memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_AL=
EN);
> -       else
> -               eth_broadcast_addr(eh->h_source);
> +       memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);

That I am not sure about. You were using this kernel without your
patch right? With your patch it would make sense to see that behavior,
but without I am not sure why you would see that address for any NC-SI
commands before the gma_flag is set.

>
> > With that we could at
> > least advertise that we don't expect this packet to be going out in a
> > real network as we cannot guarantee the MAC is unique.
>
> Yeah, but it probably wouldn=E2=80=99t help my simulation scenario.
>
> I guess it sounds like this patch is not a good idea, which to be fair,
> is totally reasonable.
>
> I can just add some iptables rules to tunnel these packets with a differe=
nt
> source MAC, or fix the multicast socket issue I was having. It=E2=80=99s =
really
> not a big deal, and like you=E2=80=99re saying, we probably don=E2=80=99t=
 want to make
> it harder to maintain _forever_.

Like I said before I would be good with either a Broadcast address OR
a LAA address. The one thing we need to watch out for though is any
sort of leak. One possible concern would be if for example you had 4
ports using 4 different MAC addresses but one BMC. You don't want to
accidently leak the MAC address from one port onto the other one. With
a LAA address if it were to leak and screw up ARP tables somewhere it
wouldn't be a big deal since it isn't expected to be switched in the
first place.

> I would just suggest praying for the next guy that tries to test NC-SI
> stuff with QEMU and finds out NC-SI traffic gets dropped by bridges.
> I had to resort to reading the source code and printing stuff with
> BPF to identify this. Maybe it=E2=80=99s more obvious to other people thi=
s wouldn=E2=80=99t
> work though.

Well it seems like NC-SI isn't meant to be bridged based on the fact
that it is using a broadcast MAC address as a source. If nothing else
I suppose you could try to work with the standards committee on that
to see what can be done to make the protocol more portable.. :-)

[4]: https://macaddress.io/faq/what-are-a-universal-address-and-a-local-adm=
inistered-address
