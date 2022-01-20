Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711804956FD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 00:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbiATXcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 18:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiATXcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 18:32:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2177C061574;
        Thu, 20 Jan 2022 15:32:10 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o1-20020a1c4d01000000b0034d95625e1fso10830391wmh.4;
        Thu, 20 Jan 2022 15:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ku131us7LM1bLPNHUn4NlF/H3MAWudsucRIvqzb+t0U=;
        b=RCh+svdFNI+3mzm6phgDV94xNkZtas8GQAUQS0izpkY8fL+Tgar08HaGqVYio+P9Gv
         AzTEas7Be/gqYJKM1+XsR9Ct3eJSbktM11HNo5y0o4HQWzmwzvfxQt+Mx5UNH4sRFxVI
         rR3t5zp/anfF4cOQEqwfUmw7IZMkn6QFCht0fdp4ONetIC8kYJBTXahIkIkLRGKcUxBo
         RcDeRTldpGY04IfE6O2tC7KvpmDxr+AD/sxmbyaKUGQ4V70s68KH7O3/suDpBYN9K7I0
         cUKOaqXNUCezO/MOO8ptgnXGewzeDw+mfoJ5/bhDuY67W2eRXjdc5YYAhWJuqZ32Z11Z
         oeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ku131us7LM1bLPNHUn4NlF/H3MAWudsucRIvqzb+t0U=;
        b=KRbUDWlv7SV6fWvs7o+m9NVY/MeDKgpe1dGMmkMzXVmFFIv5YC7Njqa/KLRg2jpV/N
         9cwdLDc5u1uM42WrlQeAwld3uQ3Mk8URPhMdP5Lpeaa1gaic+i8GgEs5HrVlQyR2FLVL
         Lwf6MFzGDtGjRJppPWOWNctIJlVHR2tdWnMnIDU74A4r9t9xYCz3zansMH7Hic68fMRH
         vDrqq55qWiUvpXJvFx4G52B7Cz6653knodBzFtr6BfU76m3tufgPNrbI1qCNR9HdD0B2
         kF34tIA6WgjgnXmoW6Iw5czAkPuvpoowuDhHxwk5WEUB9E5c+b3snl+FZs/DyHyzN53a
         T1xg==
X-Gm-Message-State: AOAM531XKSNABNMgP6p3vRD9FnYTOvIA/rv9OpDAeNg/Oh9V7QZ39pUb
        oE1LWe2fMoZXrCTkaozf2b8m/3WLxljzkPZ/+Z0=
X-Google-Smtp-Source: ABdhPJwNyl6HLMLMqcGIOI3yBtEuhjqlySjApZU0I3PG5Ozjv/EKC4ABOhw3y24Ao9cvt6VWjds4mEMmTV+yqDl3h5s=
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr1312302wrn.207.1642721529494;
 Thu, 20 Jan 2022 15:32:09 -0800 (PST)
MIME-Version: 1.0
References: <20220120004350.308866-1-miquel.raynal@bootlin.com> <87r192imcy.fsf@tynnyri.adurom.net>
In-Reply-To: <87r192imcy.fsf@tynnyri.adurom.net>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 20 Jan 2022 18:31:58 -0500
Message-ID: <CAB_54W5ORQ7Po3k3rjZMqxf8YfrDk6E_wKGgir9G31RVSDnyqw@mail.gmail.com>
Subject: Re: [wpan-next 0/4] ieee802154: General preparation to scan support
To:     Kalle Valo <kvalo@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle and Miquel,

On Thu, 20 Jan 2022 at 08:10, Kalle Valo <kvalo@kernel.org> wrote:
>
> Miquel Raynal <miquel.raynal@bootlin.com> writes:
>
> > These few patches are preparation patches and light cleanups before the
> > introduction of scan support.
> >
> > David Girault (4):
> >   net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
> >   net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
> >     menu
> >   net: ieee802154: Move the address structure earlier
> >   net: ieee802154: Add a kernel doc header to the ieee802154_addr
> >     structure
> >
> >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> >  net/Kconfig             |  3 +--
> >  net/ieee802154/Kconfig  |  1 +
> >  3 files changed, 21 insertions(+), 11 deletions(-)
>
> Is there a reason why you cc linux-wireless? It looks like there's a
> separate linux-wpan list now and people who are interested about wpan
> can join that list, right?
>

I thought it would make sense to cc wireless as they have similar
paradigms constructs (probably due the fact both are IEEE standards?).
As well we took some ideas from wireless as base. Moreover we were
talking about things which wireless already solved.
I was hoping to get some feedback if somebody knows the right do's and
don'ts of managing a wireless subsystem and I am pretty sure some
802.11 developers have more knowledge about it than some 802.15.4
developers (including myself).

I apologise for this. Please Miquel drop wireless for your future patch-series.

Miquel please slow down the amount of patches. First sending the
fixes, then new features in small series one by one. And with one by
one I mean after they are applied.

- Alex
