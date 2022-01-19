Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0186E4943D8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344327AbiASX03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 18:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiASX02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 18:26:28 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34276C061574;
        Wed, 19 Jan 2022 15:26:28 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ay14-20020a05600c1e0e00b0034d7bef1b5dso11203702wmb.3;
        Wed, 19 Jan 2022 15:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8moMvKWzWLAdYvtiyhfQY79vC7UANYWI8Ev2bLeTtR8=;
        b=STE7gIRwjFIGcuaMKJMMP0DgwXZyo8pPa6l7fToPxEMEUoT2Tb9TA7UcAWHVrM82LG
         T7LOoPdzHd9NiGQJSItflnZkS8eBICC5DDcP+C1Zn4p6t25/hhjR4mVVuqlN8HVkgmrM
         8tAEItN7aFyQW1bSPYC8rJ5SINTQ+J4Fk3K+dMSe/x/5Z8aR3I/fUC7p6cxqEEKKgGgm
         SZHOzwSPZow/qNHWFEQJ8Ykpe3g6/7+jdhfupxgd2NdU9SMKsuQc4QWlULOCc459xwIO
         XxaVyRhQOxVDjEtOUtQ8KT5i6CsT9eIRuj1n51A7MBiDMHW+Z2F4h+EGcnIiH+dD32DZ
         bHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8moMvKWzWLAdYvtiyhfQY79vC7UANYWI8Ev2bLeTtR8=;
        b=C7PUmZcni2TMdhtJnysgyyl2b2hovELzABl/TCFc6xUEScwsUYqROESr7feebO16vo
         zu30Eo9W5GpUDTS2nOIlk9c3Gg3ULa+jGqwVbmQ4H/OSBP/rkOXDKLFD382LweFG9RkN
         5RyfPM3TPR9Qvl0GR0b4JGp1gXqdF8NWXh8YiY9p7FdAcN7vQHF8SHqEVrCwo4vUzI8F
         GOnEPE+RpsIdISpDKiAj52XAVOgC8vAPz3HCv2yCGRiWkGZA1BToXExi7DNTbGQf3rjP
         SCPh2QYsNVAu6PuuwwQBY81n2b1wa/pw4e39GZ8d2UnINzVfP/4JyoEQucflY0ChCXAM
         ZE8Q==
X-Gm-Message-State: AOAM533AcYuKyZpyrhR2rvMdKzv35eEtUIIwla3i/2XXdva8v59OMh3u
        Gt+IQT5m56X6aOrrNcrvNKvysciUwbU5/+euCV8=
X-Google-Smtp-Source: ABdhPJydvMU+is0N0KdzLIJfSjpeWTLuIFuPjabqlua8OsQ0a0LH2SF8OXx0Llu8dYRvY1vEP6AM9nEKKL4ypyNcEzQ=
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr25995466wrx.56.1642634786708;
 Wed, 19 Jan 2022 15:26:26 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-9-miquel.raynal@bootlin.com> <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
 <20220113121645.434a6ef6@xps13> <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
 <20220114112113.63661251@xps13> <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
 <20220117101245.1946e474@xps13> <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
 <20220118113833.0185f564@xps13> <CAB_54W4Z0H5ubvOBjpnCpGOWYrNXYOJvxB4_kZsp8LqdJrTLkg@mail.gmail.com>
 <20220119232600.6b8755d0@xps13>
In-Reply-To: <20220119232600.6b8755d0@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 19 Jan 2022 18:26:15 -0500
Message-ID: <CAB_54W6AeRY5cP1KpaUH1VsCWtafdvPXkubPwq8rrDw-Vg4hvg@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 19 Jan 2022 at 17:26, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Tue, 18 Jan 2022 17:43:00 -0500:
>
> > Hi,
> >
> > On Tue, 18 Jan 2022 at 05:38, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > > > > btw:
> > > > > > Also for testing with hwsim and the missing features which currently
> > > > > > exist. Can we implement some user space test program which replies
> > > > > > (active scan) or sends periodically something out via AF_PACKET raw
> > > > > > and a monitor interface that should work to test if it is working?
> > > > >
> > > > > We already have all this handled, no need for extra software. You can
> > > > > test active and passive scans between two hwsim devices already:
> > > > >
> > > > > # iwpan dev wpan0 beacons send interval 15
> > > > > # iwpan dev wpan1 scan type active duration 1
> > > > > # iwpan dev wpan0 beacons stop
> > > > >
> > > > > or
> > > > >
> > > > > # iwpan dev wpan0 beacons send interval 1
> > > > > # iwpan dev wpan1 scan type passive duration 2
> > > > > # iwpan dev wpan0 beacons stop
> > > > >
> > > > > > Ideally we could do that very easily with scapy (not sure about their
> > > > > > _upstream_ 802.15.4 support). I hope I got that right that there is
> > > > > > still something missing but we could fake it in such a way (just for
> > > > > > hwsim testing).
> > > > >
> > > > > I hope the above will match your expectations.
> > > > >
> > > >
> > > > I need to think and read more about... in my mind is currently the
> > > > following question: are not coordinators broadcasting that information
> > > > only? Means, isn't that a job for a coordinator?
> > >
> > > My understanding right now:
> > > - The spec states that coordinators only can send beacons and perform
> > >   scans.
> >
> > ok.
> >
> > > - I don't yet have the necessary infrastructure to give coordinators
> > >   more rights than regular devices or RFDs (but 40+ patches already,
> > >   don't worry this is something we have in mind)
> > > - Right now this is the user to decide whether a device might answer
> > >   beacon requests or not. This will soon become more limited but it
> > >   greatly simplifies the logic for now.
> > >
> >
> > There was always the idea behind it to make an "coordinator" interface
> > type and there is a reason for that because things e.g. filtering
> > becomes different than a non-coordinator interface type (known as node
> > interface in wpan).
> > At the end interface types should make a big difference in how the
> > "role" inside the network should be, which you can also see in
> > wireless as "station"/"access point" interface devices.
> >
> > A non full functional device should then also not be able to act as a
> > coordinator e.g. it cannot create coordinator types.
>
> I've added a few more parameters to be able to reflect the type of
> device (ffd, rfd, rfd_r/tx) and also eventually its coordinator state.
> I've hacked into nl802154 to give these information to the user and let
> it device wether the device (if it's an ffd) should act as a
> coordinator. This is only a first step before we create a real PAN
> creation procedure of course.
>
> I've then adapted the following patches to follow check against the
> device/coordinator state to decide if an operation should be aborted or
> not.

Okay, I need to see the patches to say anything about that and how it fits.

The problem still exists that we don't currently have any distinction
to know if a device can do it or not. After this patch series every
"node interface" is allowed to scan/send beacons, where a node
interface should not be allowed to do it. If we change it later we
break things. However there is still the question if we care about it
because 802.15.4 is in such an early/experimental state. It was
"experimental" as the Kconfig EXPERIMENTAL entry still existed. It was
dropped because most people ignored this setting, that doesn't mean
that 802.15.4 ever left the experimental state.

- Alex
