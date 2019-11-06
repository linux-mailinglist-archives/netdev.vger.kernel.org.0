Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2807F1DC8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfKFSuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:50:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:49591 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfKFSuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 13:50:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 10:50:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="asc'?scan'208";a="201178857"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 06 Nov 2019 10:50:39 -0800
Message-ID: <7222dab4ac49346de9c652c4661b871669cd8570.camel@intel.com>
Subject: Re: [net-next 03/15] ice: Add support for FW recovery mode detection
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Wed, 06 Nov 2019 10:50:38 -0800
In-Reply-To: <20191105174836.4df162dd@cakuba.netronome.com>
References: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
         <20191106004620.10416-4-jeffrey.t.kirsher@intel.com>
         <20191105174836.4df162dd@cakuba.netronome.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CR97ScY9CYUabEUWfkkV"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-CR97ScY9CYUabEUWfkkV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-05 at 17:48 -0800, Jakub Kicinski wrote:
> On Tue,  5 Nov 2019 16:46:08 -0800, Jeff Kirsher wrote:
> > From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> >=20
> > This patch adds support for firmware recovery mode detection.
> >=20
> > The idea behind FW recovery mode is to recover from a bad FW state,
> > due to corruption or misconfiguration. The FW triggers recovery
> > mode
> > by setting the right bits in the GL_MNG_FWSM register and issuing
> > an EMP reset.
> >=20
> > The driver may or may not be loaded when recovery mode is
> > triggered. So
> > on module load, the driver first checks if the FW is already in
> > recovery
> > mode. If so, it drops into recovery mode as well, where it creates
> > and
> > registers a single netdev that only allows a very small set of
> > repair/
> > diagnostic operations (like updating the FW, checking version,
> > etc.)
> > through ethtool.
> >=20
> > If recovery mode is triggered when the driver is
> > loaded/operational,
> > the first indication of this in the driver is via the EMP reset
> > event.
> > As part of processing the reset event, the driver checks the
> > GL_MNG_FWSM
> > register to determine if recovery mode was triggered. If so,
> > traffic is
> > stopped, peers are closed and the ethtool ops are updated to allow
> > only
> > repair/diagnostic operations.
> >=20
> > Signed-off-by: Anirudh Venkataramanan <
> > anirudh.venkataramanan@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
> You shouldn't need to spawn a fake netdev just to recover the device.
>=20
> Implement devlink, you can have a devlink instance with full debug
> info and allow users to update FW via the flash op, even if driver is
> unable to bring up any port.

I have spoken with Anirudh and he is looking to implement devlink, as
suggested but it will not be a quick turn-around.  So I will drop this
patch from the series while Ani works on the devlink changes.

--=-CR97ScY9CYUabEUWfkkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3DFf4ACgkQ5W/vlVpL
7c6s9w//a+5fk/Byitv44wMoUxgahsVfxk+EzUozcyX35O0A83kbD5PvPeMeGb3V
C5tI8W2jZrfqhLdSLqwMdkXm5uxlzLCOMjeCeYN55f7joU6vRFwtaNuRLMSRy8nd
iW1zFujzfNsnpwDGMuTrv7lZeXIsIXqha4nKpTGfQECII4h0KvN/6O3TxiYRprvl
7u9tSS+pWmveSS4B+3fq15Sg6St11V3oGUVtiPOb5I/jwKoc8JsBv16U7BO2GH7M
ta3UUguK2P0JXOwzgqfHjXK/HAvA8YIYybmcb+OwKPXHWjY/uOgtKVjJMOd7/V+k
lTHwG06peWkGTVCeTjw/o3LOOKepatBeC+hYMfFm+VKsbfKk8Jr/lejpNLCb7Clb
dr8qUn3Vpe39h7YdceibNYlEmQGqOyzb5HOpwkWx8ZZFX2bIjYWeropadf+Guk/H
QjU2F6UDUaKo3AJVpBjpUZ9hACFob8usndNxrpP5IvJdTuqNB2mDv0+wKeJRVkg7
68X6F+xm9KMuMKhUrp0XKmHU06CCsZp9YcvDSDOWY6qzS5zMzpZ4gpGucXohoo7r
i9KM0V/SZjQaeYjFxprcQ/P6yxDapVZo9t9ZNL8snHkipEfJm2L2sqT9sjfF/KGr
KljljOGCqtusWUrm0MSDJox3PDfFcqTLOi4q3p3gjZzTtJ/iEhM=
=EfdO
-----END PGP SIGNATURE-----

--=-CR97ScY9CYUabEUWfkkV--

