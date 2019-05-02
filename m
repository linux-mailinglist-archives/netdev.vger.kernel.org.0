Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7969B12387
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEBUkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:40:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:19745 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfEBUkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 16:40:02 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 13:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="asc'?scan'208";a="320953549"
Received: from vbhyrapu-mobl.amr.corp.intel.com ([10.252.138.72])
  by orsmga005.jf.intel.com with ESMTP; 02 May 2019 13:40:00 -0700
Message-ID: <5e546c17ad929d97d6c4ca7d93b8f504da33dc31.camel@intel.com>
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Thu, 02 May 2019 13:40:00 -0700
In-Reply-To: <0c73af48-d638-dd58-fcf8-c872ff8591d7@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
         <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
         <806f5242-d509-e015-275e-ad0325f17222@iogearbox.net>
         <0c73af48-d638-dd58-fcf8-c872ff8591d7@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-MbaSF+XY3PvY1kLHplAo"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-MbaSF+XY3PvY1kLHplAo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-02 at 22:29 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On 2019-05-02 16:47, Daniel Borkmann wrote:
> > On 04/29/2019 09:16 PM, Jeff Kirsher wrote:
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >=20
> > > GCC will generate jump tables for switch-statements with more than 5
> > > case statements. An entry into the jump table is an indirect call,
> > > which means that for CONFIG_RETPOLINE builds, this is rather
> > > expensive.
> > >=20
> > > This commit replaces the switch-statement that acts on the XDP
> > > program
> > > result with an if-clause.
> > >=20
> > > The if-clause was also refactored into a common function that can be
> > > used by AF_XDP zero-copy and non-zero-copy code.
> >=20
> > Isn't it fixed upstream by now already (also in gcc)?
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dce02ef06fcf7a399a6276adb83f37373d10cbbe1
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Da9d57ef15cbe327fe54416dd194ee0ea66ae53a4
> >=20
>=20
> Hmm, given that Daniel's work is upstream, this patch doesn't really
> make sense any more. OTOH it can stay in the series, and be cleaned up
> later.
>=20
> I'll leave it for you to decide, Jeff!

I am already making revisions to the series due to another patch, so if
these changes are no longer needed to improve performance in RETPOLINE
builds, then lets drop it.

Bj=C3=B6rn, can you confirm that with or without these changes, XDP perform=
ance
stays the same for RETPOLINE builds?

--=-MbaSF+XY3PvY1kLHplAo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzLVaAACgkQ5W/vlVpL
7c5dtA/+KH0OZ0Jj0d51xdf6Fhor0hJauecW54myanjnJXt/z+3kBu3/1GK9yo5A
oAazQT4QI1ev+TkJ0CLPRM6pt9C6u66P+4sSYq2R3swOg2CNpkkgp6ES3kUhOFoR
BXQ+ru0JKqMMQX5BgNZs3ckicJxE1U2m9Q6S8W/THHiStSqmTqKD9YSsUJdNqJYc
OB7UEGxss3hV92dIyc9mD8TSXw+ejG5Al9TvXit0CFFiB8P6rFsO+EwWBM6giwo8
saqpftncCrUZBV1hCm9GkPSMK6nnB0RTEaxGbtpnN4nRoGW0ugpmME1kncv7kE9q
hIZiDxB/6wIRJxexbu3rCRHPxdiYmfnwlaR6JhIUiMK7S9nPJwXrKL3M42j2a3Zk
c07ZL2n8q+OMU5c9pMie3mthcXKQXr0ZeCkz8a5IJy9DiDmRaM3w/yr8gWTOqZlW
ntwhb4HgRagOHvF+RxdGM7GIGc3f1W4LWrNu8s+dWDKJu/OoLGin5B/RisejQAZI
lfzeOY2P0Mkg0yHrRoAHUd97ISOa2Kr5UG51IIyBjvv5J6U9S3nW7U/QziaCEAjC
t0PVW/Z0F9jqzhDdQfY8rNnBMnUYMUpUC6U++AGMYABeGt73NhRN60sfdDu8f8Ge
rXHstSOanlH7NKYqJ7YMyUrlWbxqp9hGtUo4z269eXAe6O7tnxc=
=sjKw
-----END PGP SIGNATURE-----

--=-MbaSF+XY3PvY1kLHplAo--

