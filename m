Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886552B1231
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgKLWwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgKLWwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:52:41 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5EFC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:52:41 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y17so6826794ilg.4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0d9r3O4bWHgjRAbilkQt2aAbni9eXVeFLkdD366WVCo=;
        b=eVQmZeA4iRNZNJqvjutKVHOc27ikGHzj6wrn0ygUemc2PC5QWnyJTaVVcEiV+/ktI2
         EKsJddi7U++jRIqTlRO1bXZYsq4sQv5SuqBqeFKJa/uWrt5LknXTjCuub4oD+7aWgRJf
         CsJN63yhRENywkC0BWQJwjEbWtGbVAGVb93DzhMMDrY9DqvflT5VRSPecrlvC3QGagZV
         DFFaoDRhZWoSd2B4hsD69O/xIcTVq1m0ayRcGu9pGoQSYOt2iK5z1+3nWTN5puppW87N
         zNrxFuRsorwSUpiWOXQNxQi5Jz8IdorT99jDP30db7iWUvjn9PZeyGXH+at5l1jDc5q4
         A1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0d9r3O4bWHgjRAbilkQt2aAbni9eXVeFLkdD366WVCo=;
        b=TCMrnzDJtLR2Fh85FfzT3l1ZXimHHTtkWUlHlU9Ymy1+L0X16ugsOEPJmp1zP7Yh0p
         cbHnqunqFUFsk+AkUJGiYiYdGn+cOIfW0C2kybI61HxmyiKv727+Zilz0AvFfzFVtWPN
         vCNuNeZgFUH0so++HcA4/Xs4K0SSaNBZny7zoJZ5sa2v2c9NFzTlKx995FtSh8bVOU0R
         RSBXdIzGLuw0/q/GuXBhmKC6kRM831FdlL2KMmqMaKnDymNOymJFSGXQWFFAwM8lcoSF
         CEM7UaExgTmN9DHpwA0uOdA/66l+vd8+nzkXLV6HXpksz4OIlNxOG/lPoqTLgiWRNJaN
         ytWw==
X-Gm-Message-State: AOAM533phlkIYfyNr0jsKjs626aCl1G/Pn43YToyRrcKOT3KNzJcYW85
        76WuB/7nIpoINlK6qYpYdpcBBE25X1l2Y7b1HtI=
X-Google-Smtp-Source: ABdhPJyA4jL4rm5gKFdFBfZU+fsiMC1jnESE/gM2Klgds1I4jYKNH307Z5iQ6uLwA5NPL9fJzxGbkxOW0IDuvkViP6E=
X-Received: by 2002:a92:6706:: with SMTP id b6mr1484254ilc.42.1605221560755;
 Thu, 12 Nov 2020 14:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com> <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Nov 2020 14:52:30 -0800
Message-ID: <CAKgT0UcebjJQ0FA58nnw3xWoa0nY=Y5zTk4TpKgYOT4L8EX=_Q@mail.gmail.com>
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Markus_Bl=C3=B6chl?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 7:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 10 Nov 2020 16:39:58 +0100 Markus Bl=C3=B6chl wrote:
> > The rx-vlan-filter feature flag prevents unexpected tagged frames on
> > the wire from reaching the kernel in promiscuous mode.
> > Disable this offloading feature in the lan7800 controller whenever
> > IFF_PROMISC is set and make sure that the hardware features
> > are updated when IFF_PROMISC changes.
> >
> > Signed-off-by: Markus Bl=C3=B6chl <markus.bloechl@ipetronik.com>
> > ---
> >
> > Notes:
> >     When sniffing ethernet using a LAN7800 ethernet controller, vlan-ta=
gged
> >     frames are silently dropped by the controller due to the
> >     RFE_CTL_VLAN_FILTER flag being set by default since commit
> >     4a27327b156e("net: lan78xx: Add support for VLAN filtering.").
> >
> >     In order to receive those tagged frames it is necessary to manually=
 disable
> >     rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter o=
ff` or
> >     corresponding ioctls ). Setting all bits in the vlan filter table t=
o 1 is
> >     an even worse approach, imho.
> >
> >     As a user I would probably expect that setting IFF_PROMISC should b=
e enough
> >     in all cases to receive all valid traffic.
> >     Therefore I think this behaviour is a bug in the driver, since othe=
r
> >     drivers (notably ixgbe) automatically disable rx-vlan-filter when
> >     IFF_PROMISC is set. Please correct me if I am wrong here.
>
> I've been mulling over this, I'm not 100% sure that disabling VLAN
> filters on promisc is indeed the right thing to do. The ixgbe doing
> this is somewhat convincing. OTOH users would not expect flow filters
> to get disabled when promisc is on, so why disable vlan filters?
>
> Either way we should either document this as an expected behavior or
> make the core clear the features automatically rather than force
> drivers to worry about it.
>
> Does anyone else have an opinion, please?

My personal preference is for the setting of all 4096 VLANs when
promiscuous mode is enabled which is what we do with ixgbe if
virtualization is enabled. If we want to provide an option to disable
Rx VLAN filtering then just do it via the ethtool feature bit. With
that things would be at least consistent as I suspect disabling Rx
VLAN filtering may also impact Rx VLAN tag stripping so both might
need to be updated at the same time. I know in the case of
virtualization most NICs have to leave the VLAN filtering enabled for
SR-IOV to be able to handle per VF VLAN filters regardless of the PF
setting.

Anyway that is my $.02.

- Alex
