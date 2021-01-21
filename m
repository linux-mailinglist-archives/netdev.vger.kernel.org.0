Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC642FDE41
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbhAUA50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbhAUAR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 19:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC122360D;
        Thu, 21 Jan 2021 00:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611188199;
        bh=oSY5j1RwH+0tuI91BJXdScP9I35wwPguytRpawcS3Hg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=foiLhMPztwwV3SbKC2/I0tpE4Q3XWNw6Y4M1i+GguJIWrP4Ur7UrZmhFchJ4MqmGd
         lDA9l1FHxde3rmL4yVSXcnOCKPh/lGWID3WK2I7I5rjkVdqSI/4kDaewKfxWZ8KXjO
         4zVpVbQIsg49UFB1PRNcT5aPePfATZRMkW5vArqm2NOY9kmQ+KUSRpf9+Ybb+VXP8F
         Ap//ZeLSiF7fOPhCMgmCHNfXOxuHJPk3fembMCJ+Gpx9ZOBjgm2RtNS9Qu8ucPmBrq
         Jzi/p4mod1D+CUArtKtiTP3txE7rn2jiU9EAolRF8JpOiI/OlHXWIf0zf2aGFW0z/G
         F1cArgzR0/5nQ==
Date:   Wed, 20 Jan 2021 16:16:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210120161637.6735ef4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAjEUdYnGSPjZSy5@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <X/+nVtRrC2lconET@lunn.ch>
        <20210119115610.GZ3565223@nanopsycho.orion>
        <YAbyBbEE7lbhpFkw@lunn.ch>
        <20210120083605.GB3565223@nanopsycho.orion>
        <YAg2ngUQIty8U36l@lunn.ch>
        <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YAjEUdYnGSPjZSy5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 01:01:21 +0100 Andrew Lunn wrote:
> On Wed, Jan 20, 2021 at 03:41:58PM -0800, Jakub Kicinski wrote:
> > On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote: =20
> > > > No, the FW does not know. The ASIC is not physically able to get the
> > > > linecard type. Yes, it is odd, I agree. The linecard type is known =
to
> > > > the driver which operates on i2c. This driver takes care of power
> > > > management of the linecard, among other tasks.   =20
> > >=20
> > > So what does activated actually mean for your hardware? It seems to
> > > mean something like: Some random card has been plugged in, we have no
> > > idea what, but it has power, and we have enabled the MACs as
> > > provisioned, which if you are lucky might match the hardware?
> > >=20
> > > The foundations of this feature seems dubious. =20
> >=20
> > But Jiri also says "The linecard type is known to the driver which
> > operates on i2c." which sounds like there is some i2c driver (in user
> > space?) which talks to the card and _does_ have the info? Maybe I'm
> > misreading it. What's the i2c driver? =20
>=20
> Hi Jakub
>=20
> A complete guess, but i think it will be the BMC, not the ASIC. There
> have been patches from Mellanox in the past for a BMC, i think sent to
> arm-soc, for the ASPEED devices often used as BMCs. And the BMC is
> often the device doing power management. So what might be missing is
> an interface between the driver and the BMC. But that then makes the
> driver system specific. A OEM who buys ASICs and makes their own board
> could have their own BMC running there own BMC firmware.
>=20
> All speculation...

I see that does make sense =F0=9F=A4=94=20
