Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323572FC168
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbhASSuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730665AbhASS22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 13:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C882233EA;
        Tue, 19 Jan 2021 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611075945;
        bh=alaksRNTDQpckIDhtJpw9+7JcWoMBKls4G92axni+74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZMCarGbdc2i+CriApZz6bCYKwVVOzstDBSLdB7w0d7nuXvM9qkRcsikgOE40tw6JZ
         V0/7d7V6T7JQTwtNd8mgLyVXGYomskDaUrA4KRVOV3PoQSFCsPgumXzGXaCsgzT6gz
         9kSkIOU5P/TlDSpEM0MJhwjvlsbMGySvOlZSm67lRxIWiZupItSPlV0N0JaMNkFcYa
         zjLbKbVlasAkaleaiDH+wY2spLBhiFCyNKeR/LOyiu1aCp4eWYfJMd5vv/BJAfgYc9
         gkuNvTrkjqQacLuU/xuqja6UmlkptHhdvLPQmKLUpFmR7itoXVlFcMmtkZAqumQp9+
         dhy8UjWTez6lA==
Date:   Tue, 19 Jan 2021 09:05:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
Message-ID: <20210119090539.22c3d29e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <19eab284-b7b0-7053-1aa7-5fedcee04263@molgen.mpg.de>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
        <20201102231307.13021-3-pmenzel@molgen.mpg.de>
        <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
        <20201103103940.2ed27fa2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c1ad26c6-a4a6-d161-1b18-476b380f4e58@molgen.mpg.de>
        <X/ShBVXp32Y+Jeds@kroah.com>
        <19eab284-b7b0-7053-1aa7-5fedcee04263@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 07:55:19 +0100 Paul Menzel wrote:
> Am 05.01.21 um 18:25 schrieb Greg KH:
> > On Tue, Jan 05, 2021 at 06:16:59PM +0100, Paul Menzel wrote: =20
> >> Am 03.11.20 um 19:39 schrieb Jakub Kicinski: =20
> >>> On Tue, 3 Nov 2020 08:35:09 +0100 Paul Menzel wrote: =20
> >>>> According to *Developer's Certificate of Origin 1.1* [3], it=E2=80=
=99s my
> >>>> understanding, that it is *not* required. The items (a), (b), and (c)
> >>>> are connected by an *or*.
> >>>> =20
> >>>>>           (b) The contribution is based upon previous work that, to=
 the best
> >>>>>               of my knowledge, is covered under an appropriate open=
 source
> >>>>>               license and I have the right under that license to su=
bmit that
> >>>>>               work with modifications, whether created in whole or =
in part
> >>>>>               by me, under the same open source license (unless I am
> >>>>>               permitted to submit under a different license), as in=
dicated
> >>>>>               in the file; or =20
> >>>
> >>> Ack, but then you need to put yourself as the author, because it's
> >>> you certifying that the code falls under (b).
> >>>
> >>> At least that's my understanding. =20
> >>
> >> Greg, can you please clarify, if it=E2=80=99s fine, if I upstream a pa=
tch authored
> >> by somebody else and distributed under the GPLv2? I put them as the au=
thor
> >> and signed it off. =20
> >=20
> > You can't add someone else's signed-off-by, but you can add your own and
> > keep them as the author, has happened lots of time in the past.
> >=20
> > Or, you can make the From: line be from you if the original author
> > doesn't want their name/email in the changelog, we've done that as well,
> > both are fine. =20
>=20
> Greg, thank you for the clarification.
>=20
> Jakub, with that out of the way, can you please take patch 2/2?

Please repost the patches, if you know how please add a lore link to
this posting, thanks!
