Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B05171529
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbfGWJ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfGWJ2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 05:28:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 718A4308421A;
        Tue, 23 Jul 2019 09:28:12 +0000 (UTC)
Received: from ovpn-117-106.ams2.redhat.com (ovpn-117-106.ams2.redhat.com [10.36.117.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B1F15D9C5;
        Tue, 23 Jul 2019 09:28:09 +0000 (UTC)
Message-ID: <d797ed8522bd37f2f01002b26a06ee146ebe2b90.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
From:   Thomas Haller <thaller@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date:   Tue, 23 Jul 2019 11:28:03 +0200
In-Reply-To: <20190723090908.GA2204@unicorn.suse.cz>
References: <cover.1556806084.git.mkubecek@suse.cz>
         <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
         <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
         <20190723090908.GA2204@unicorn.suse.cz>
Organization: Red Hat
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uB+G14xSU2RvYRVTrtZV"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 23 Jul 2019 09:28:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-uB+G14xSU2RvYRVTrtZV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-23 at 11:09 +0200, Michal Kubecek wrote:
> On Tue, Jul 23, 2019 at 10:57:54AM +0200, Thomas Haller wrote:
> > Does this flag and strict validation really provide any value?
> > Commonly a netlink message is a plain TLV blob, and the meaning
> > depends entirely on the policy.
> >=20
> > What I mean is that for example
> >=20
> >   NLA_PUT_U32 (msg, ATTR_IFINDEX, (uint32_t) ifindex)
> >   NLA_PUT_STRING (msg, ATTR_IFNAME, "net")
> >=20
> > results in a 4 bytes payload that does not encode whether the data
> > is
> > a number or a string.
> >=20
> > Why is it valuable in this case to encode additional type
> > information
> > inside the message, when it's commonly not done and also not
> > necessary?
>=20
> One big advantage of having nested attributes explicitly marked is
> that
> it allows parsers not aware of the semantics to recognize nested
> attributes and parse their inner structure.
>=20
> This is very important e.g. for debugging purposes as without the
> flag,
> wireshark can only recurse into nested attributes if it understands
> the
> protocol and knows they are nested, otherwise it displays them only
> as
> an opaque blob (which is what happens for most netlink based
> protocols).
> Another example is mnl_nlmsg_fprintf() function from libmnl which is
> also a valuable debugging aid but without NLA_F_NESTED flags it
> cannot
> show message structure properly.

Hi,

I don't question the use of the flag. I question whether it's necessary
for kernel to strictly require the sending side to aid debuggability.

"e.g. for debugging purposes" makes it sound like it would be important
for something else. I wonder what else.


Anyway. What you elaborate makes sense!! Thanks


My main point was to raise awareness that this is a problem for libnl3.


best,
Thomas

--=-uB+G14xSU2RvYRVTrtZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEESep8Zw4IUOdBlRT2KcI2bk38VygFAl020yMACgkQKcI2bk38
Vygegg//bjBYvpsSC7cGBhu9f7Eysloqq9pL8gVujgicZwpVU/vtK3MlieaUEoYU
Dm04WNKYXh7cIiD6k0BBvKnyG9wB3xEUr90PvvFn7Q5hUqLipO4boZ4fvNy5R9qA
bfteE9nfcwuz65XxIHgjZGnKoR8Xf3N4F9SuLNJIs0hyJLBeEyjjrcHDw0vwnvDF
z838zDyY9QnOlNYrpFKjeanRv+Wk3sdvKAfuXEcs8v/JV+wj6N7K+WM04Tx1x1XW
pC+Pw4JTj3mqO3wRWzyDJKkVQcwf1MJlhJEpHRXNQlINJ0OUNacretzySMA7Q1uG
6sChzfMK9mt3KjjyN17qZYlAz4PxqXarl9Q+j6nix5zRDsXy6xsjTigAZIH0j9zN
DPh9Q8htI4Re1m6GXhwaNthpHJgjyMRhWVJ5FJRRtnUHsMRUBREiDmSsoAEZe7ac
BXVffSYtfaT78NaIubqUT3D5Ab0pJPNPqjf15779nI/UAyCByXZFnCo3fJYnC1JC
6Yv7hlJY9KneSSmbJ/Iz0D0VMJQi9FhoboMLCvAD0yJO0MS6X8q9ozWRSFeIsNJ8
CeO9/JKIORS7cyQb8s6DnkUrGIW121lxCmzzHWViZXBQ+VXe2jc2gWzKK0NY8N0F
EegOD736E/ZkOlEQBBR7QJ63tkc97q1xAg14hRL2rQWH2FH3z5I=
=poN7
-----END PGP SIGNATURE-----

--=-uB+G14xSU2RvYRVTrtZV--

