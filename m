Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17266BF4A4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCQVw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCQVw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:52:27 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AD3B761;
        Fri, 17 Mar 2023 14:52:01 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5447d217bc6so118172157b3.7;
        Fri, 17 Mar 2023 14:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679089916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKtagOM/JAUz4jAmNpr2xD81W1Y87KjgbxfWBpiZoeg=;
        b=AumdPhs5m5HCtXnISRZtI6eGxQZZaORJM2u41wlLLEdtgw6P4gZwp2JI3LuJ6Iii2H
         +Svbj7vqD9N/gNiZ+kCwxSAl8tUqAAk7kWCkcoJPoTZuRwn37NMNuWexh9HzZSZb/2L0
         V7HvSOmGw1DqKO6tO6MwU1BN7CPMC+xOw8N5w7HbXzybExOwJPfF5XI7uT/1NPX/EBAF
         mnTY5musbCb61oD/aoE4kfgHNv7DfiBE4cQ2DFxsNR+ma9gAw17v8koy6zrvzaYxmmGw
         g6CGVLLrZ40Cm1P7F+GsahPZ9bt62psbDbiIsF0PHiQD6SM248i6sYkauqQcOluhdW1o
         uY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679089916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKtagOM/JAUz4jAmNpr2xD81W1Y87KjgbxfWBpiZoeg=;
        b=bgiEr3jkdPHT/52WbxblmSFMLinc9UqtO9kbqZPtqR7r3tcOjInfF/0MhiV3KJOdsA
         d6w+2lTPVJhCmglTRuSBgX5dvBWbCG5Wv5PS25yMrVEBeUAgR3+34mCcaJwa7/Xt3JQa
         ZWMjbYGU2THJbJjbh68JyKYptpoH0zkNicJWdW/ODYWfN/sN2h9O6OW0xi/aGFb3G3Ai
         aJUHjMS71n/Nqjc0tLfvXgqER8kF/QlMRwTtXo5DADQZSQgrBuDyeYoN0HDH2ZAd17vF
         +E4Z0Cj12WL460IwkKQRWQh/cVVcHbZM9uplCWkTRT+H+oESAwLhJmeIveYvb0YYA7hL
         +0rg==
X-Gm-Message-State: AO0yUKWIput97AOR3qSxALyHkU8oDnikGXwpwom+tt39hZX4xVFDXGMr
        ytlXaKDhdyFAB7sKF756B0QPj/bW4gdlUXhmdNg=
X-Google-Smtp-Source: AK7set/WnalWzyU2DZyj10hIZUdLEpGZo5yGe9ZqTSTod2e3UkLYddRiEsg/gqpiT2qmyBM41gtSvWiikIzJQ+2fyuc=
X-Received: by 2002:a81:ed06:0:b0:540:e6c5:5118 with SMTP id
 k6-20020a81ed06000000b00540e6c55118mr5786288ywm.2.1679089915760; Fri, 17 Mar
 2023 14:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230317120815.321871-1-noltari@gmail.com> <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
 <CAOiHx==TiSZKE4AP3PZ9Ah4zuAsrfpOTvRADWpT2kMS9UVRH9Q@mail.gmail.com> <9f771318-5a59-ac31-a333-e2ad9947679f@gmail.com>
In-Reply-To: <9f771318-5a59-ac31-a333-e2ad9947679f@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 22:51:45 +0100
Message-ID: <CAKR-sGdgfztvXCymeNSPSoR=C466NzQ-6siiWSUukSAR_-c4-Q@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

El vie, 17 mar 2023 a las 17:55, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/17/23 09:49, Jonas Gorski wrote:
> > On Fri, 17 Mar 2023 at 17:32, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Fri, Mar 17, 2023 at 01:08:15PM +0100, =C3=81lvaro Fern=C3=A1ndez R=
ojas wrote:
> >>> When BCM63xx internal switches are connected to switches with a 4-byt=
e
> >>> Broadcom tag, it does not identify the packet as VLAN tagged, so it a=
dds one
> >>> based on its PVID (which is likely 0).
> >>> Right now, the packet is received by the BCM63xx internal switch and =
the 6-byte
> >>> tag is properly processed. The next step would to decode the correspo=
nding
> >>> 4-byte tag. However, the internal switch adds an invalid VLAN tag aft=
er the
> >>> 6-byte tag and the 4-byte tag handling fails.
> >>> In order to fix this we need to remove the invalid VLAN tag after the=
 6-byte
> >>> tag before passing it to the 4-byte tag decoding.
> >>
> >> Is there an errata for this invalid VLAN tag? Or is the driver simply
> >> missing some configuration for it to produce a valid VLAN tag?
> >>
> >> The description does not convince me you are fixing the correct
> >> problem.
> >
> > This isn't a bug per se, it's just the interaction of a packet going
> > through two tagging CPU ports.
> >
> > My understanding of the behaviour is:
> >
> > 1. The external switch inserts a 4-byte Broadcom header before the
> > VLAN tag, and sends it to the internal switch.
> > 2. The internal switch looks at the EtherType, finds it is not a VLAN
> > EtherType, so assumes it is untagged, and adds a VLAN tag based on the
> > configured PVID (which 0 in the default case).
> > 3. The internal switch inserts a legacy 6-byte Broadcom header before
> > the VLAN tag when forwarding to its CPU port.
> >
> > The internal switch does not know how to handle the (non-legacy)
> > Broadcom tag, so it does not know that there is a VLAN tag after it.
> >
> > The internal switch enforces VLAN tags on its CPU port when it is in
> > VLAN enabled mode, regardless what the VLAN table's untag bit says.
> >
> > The result is a bogus VID 0 and priority 0 tag between the two
> > Broadcom Headers. The VID would likely change based on the PVID of the
> > port of the external switch.
>
> My understanding matches yours, at the very least, we should only strip
> off the VLAN tag =3D=3D 0, in case we are stacked onto a 4-bytes Broadcom
> tag speaking switch, otherwise it seems to me we are stripping of VLAN
> tags a bait too greedily.

Maybe I'm wrong here, but we're only removing the VLAN tag for a
specific case in which we shouldn't have any kind of VLAN tag, right?

For example, let's say we have an internal switch with the following ports:
- 0: LAN 1
- 4: RGMII -> External switch
- 8: CPU -> enetsw controller

And the external switch has the following ports:
- 0: LAN 2
- 1: LAN 3
...
- 8: CPU -> Internal switch RGMII

A. If we get a packet from LAN 1, it will only have the 6-bytes tag
(and optionally the VLAN tag).
When dsa_master_find_slave() is called, the net_device returned won't
have any kind of DSA protocol and therefore netdev_uses_dsa() will
return FALSE.

B. However, when a packet is received from LAN 2/3, the first tag
processed will be the 6-byte tag (corresponding to the internal
switch).
The 6-byte tag will identify this as coming from port 4 of the
internal switch (RGMII) and therefore dsa_master_find_slave() will
return the extsw interface which will have the DSA protocol of the
4-byte tag and netdev_uses_dsa() will return TRUE.

Only for the second case the invalid VLAN tag will be removed and
since extsw (RGMI) will never have VLANs enabled, I don't see the
problem that you suggest about removing the VLAN tags too greedily.

Am I wrong here?

> --
> Florian
>

Best regards,
=C3=81lvaro.
