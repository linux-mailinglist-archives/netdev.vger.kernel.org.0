Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1195E45456C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbhKQLQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhKQLQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:16:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E20A61B51;
        Wed, 17 Nov 2021 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637147582;
        bh=4TPDgKRXy11DMS8G6r5f3T4MtXQsAGt89Wz3+ccC0tE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AR+IHrw1JI4mQ4lsjxeM3btRBSgMBOlItBwZhFfGxp9tjslfN/4keivFutHqUWaEy
         7NRu9X7/y6U59muPtywbk3vW7QOpJbZQ8bnCr/Ebo3IjEuIyGU2nIHHZLljdErvUQw
         0Tfe0k2k1k78uFB0rJafmlVLluyvmJ7JblBguGsH9F68GJCuc+OoBjoFL4cfdYsoFW
         7UvLZK/umgJt2kfqDyg8ZvU9ur+jHu2RzEAHGSGMhW8XZcY/U5SkhKabs9W4ke31Va
         oGilim8y8XShWaYi0XgelYG3+nMUlaHNXhtbmJGQqxbo8acNNJmF04dhR0mCL/Nfnz
         5JVwbxsEB61zg==
Date:   Wed, 17 Nov 2021 12:12:58 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <YZTjuuQwLVTNaoTt@lore-desk>
References: <cover.1637013639.git.lorenzo@kernel.org>
 <ce5ad30af8f9b4d2b8128e7488818449a5c0d833.1637013639.git.lorenzo@kernel.org>
 <20211116071357.36c18edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZRI+ac4c0j/eue5@lore-desk>
 <20211116163159.56e1c957@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WdM0+DS2xhexbHLR"
Content-Disposition: inline
In-Reply-To: <20211116163159.56e1c957@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WdM0+DS2xhexbHLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 17 Nov 2021 01:12:41 +0100 Lorenzo Bianconi wrote:
> > ack, you are right. Sorry for the issue.
> > I did not trigger the problem with xdp-mb self-tests since we will not =
run
> > bpf_xdp_copy_buf() in this specific case, but just the memcpy()
> > (but what you reported is a bug and must be fixed). I will add more
> > self-tests.
> > Moreover, reviewing the code I guess we can just update bpf_xdp_copy() =
for our case.
> > Something like:
>=20
> Seems reasonable.  We could probably play some tricks with double
> pointers to avoid the ternary operator being re-evaluated for each
> chunk. But even if it's faster it is probably not worth the ugliness
> of the code.

ack, moreover I guess the slowest operation here is the mempcy().
I added a new self-test to cover the case where buf is across frag0
and frag1.
I will wait for some more feedbacks and then I will post a new version.
Thanks.

Regards,
Lorenzo

--WdM0+DS2xhexbHLR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYZTjugAKCRA6cBh0uS2t
rJYPAP9SlkRSbeWIhBw44PBH7vhThgAkXhPXN8FkQsr3vLEd1AD8DALSPCxniGjh
xP4RrZ0eTt4gm4Yz5aKkgdeVdrCZ3Qk=
=ENIZ
-----END PGP SIGNATURE-----

--WdM0+DS2xhexbHLR--
