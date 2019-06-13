Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5822437AA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfFMPA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732585AbfFMOsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:48:03 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9726830BD1CC;
        Thu, 13 Jun 2019 14:47:55 +0000 (UTC)
Received: from localhost (ovpn-117-78.ams2.redhat.com [10.36.117.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE9E87BE6B;
        Thu, 13 Jun 2019 14:47:53 +0000 (UTC)
Date:   Thu, 13 Jun 2019 15:47:50 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next] vsock: correct removal of socket from the list
Message-ID: <20190613144750.GA10708@stefanha-x1.localdomain>
References: <MW2PR2101MB11162BBAEC52B232A7B1EFAFC0EF0@MW2PR2101MB1116.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB11162BBAEC52B232A7B1EFAFC0EF0@MW2PR2101MB1116.namprd21.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 13 Jun 2019 14:48:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2019 at 03:52:27AM +0000, Sunil Muthuswamy wrote:
> The current vsock code for removal of socket from the list is both
> subject to race and inefficient. It takes the lock, checks whether
> the socket is in the list, drops the lock and if the socket was on the
> list, deletes it from the list. This is subject to race because as soon
> as the lock is dropped once it is checked for presence, that condition
> cannot be relied upon for any decision. It is also inefficient because
> if the socket is present in the list, it takes the lock twice.
>=20
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> ---
>  net/vmw_vsock/af_vsock.c | 38 +++++++-------------------------------
>  1 file changed, 7 insertions(+), 31 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0CYhYACgkQnKSrs4Gr
c8iFswgAkhny+CmJw7mow5IOVXXncE2TxFf99EHKsOr8iDtwufjIL8hwWvTaUe6P
RTvfmyV/gNWaNTeDS59vx2PjBj6lqFvNcSkHgxk2TedBTjYZuT9zVpxgaR35z8/+
ijwiQDEUItPe/QTgLtGCe7cWonERvH8isScXPkJeRQwy6AM4VUgUA0BAp4UJ8d1C
wSPJN9FCoxq23VteUc5K64rfZx/HJ9nQHSgXpaGs1HZUP4ZCt+d+IdnHQqwnMqcO
StHv/E1Hw52VWDsuwnxBnabAj8upxLAAwz3fczAIBBv8Gzgcsm4mJ27kz1canPlv
TYXCHiC/JJ9sj1U5f6ggZhXBCsY9+g==
=426n
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
