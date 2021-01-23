Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E313011DE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbhAWBNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbhAWBNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:13:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA1D523A7D;
        Sat, 23 Jan 2021 01:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611364345;
        bh=uPvzidVHRy4/UWt19cxIFD/VdW/vjghzVAz62Fn815U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ws48govYua3q3SZcjGeSh9J5n+qcYQgKtT/KeZ+ooNa9cz/7vxSJ0ju0jq0ZCSE1j
         VcB5bjaS5xCBQqDxGV2Qn1PaG60Aen8L4f/JgGiYep01Yuar9jy3RuyJkkx3Ffsn8B
         RdKJko1WgBhPh+MvnDR6OSenKtgzwsyTs/aPc+xHOhEYYdCxB3uw1Vqz/vgUBCspbR
         cQVjEEHdvTSORnQTELfSvBzisNXkcgrVpng+dqTgwimCR63IGv0TTyxK0SUHVc7ZGo
         tLcJ7EkfFXdWIfFT6XaUyuKbViFK7NkpyfmuyTT3NzLQhzYa4UO41CG6eeIhJrTXgX
         dOVFaowmZNdow==
Date:   Fri, 22 Jan 2021 17:12:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210122171223.1f7b55b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 08:36:01 +0000 Oleksandr Mazur wrote:
> On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:
> > On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote: =20
> > > Add new trap action HARD_DROP, which can be used by the
> > > drivers to register traps, where it's impossible to get
> > > packet reported to the devlink subsystem by the device
> > > driver, because it's impossible to retrieve dropped packet
> > > from the device itself.
> > > In order to use this action, driver must also register
> > > additional devlink operation - callback that is used
> > > to retrieve number of packets that have been dropped by
> > > the device.=C2=A0  =20
> >=20
> > Are these global statistics about number of packets the hardware dropped
> > for a specific reason or are these per-port statistics?
> >=20
> > It's a creative use of devlink-trap interface, but I think it makes
> > sense. Better to re-use an existing interface than creating yet another
> > one. =20
>=20
> > Not sure if I agree, if we can't trap why is it a trap?
> > It's just a counter. =20
>=20
> It's just another ACTION for trap item. Action however can be
> switched, e.g. from HARD_DROP to MIRROR.
>=20
> The thing is to be able to configure specific trap to be dropped, and
> provide a way for the device to report back how many packets have
> been dropped. If device is able to report the packet itself, then
> devlink would be in charge of counting. If not, there should be a way
> to retrieve these statistics from the devlink.

Sure, but the action is drop. The statistics on the trap are orthogonal
to the action.
