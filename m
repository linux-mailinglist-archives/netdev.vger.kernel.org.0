Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FA649CD2F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbiAZPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242451AbiAZPAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC47AC06161C;
        Wed, 26 Jan 2022 07:00:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECB3161825;
        Wed, 26 Jan 2022 15:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010A8C340E6;
        Wed, 26 Jan 2022 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643209238;
        bh=ZmlWB7oHgY4EUnBee2pldpeTuBsyuIALVfTUMB0azg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqbjYQZfZ7lixZCQlNjBWxdELqePWgf6CgBwjPK2K1FpZxU69BYSrU5NDWr+VShbD
         MKE9vO0yVgcGcKncMgHq24YGoVp8WbZLhiZxdWHwUtwYEKA853hnlN+8hsLnmGEHJq
         O2lcF7NeLzLxIpVObp6DM8OZax/rcyfrgVumVzLh1lgeatJuPUxKrnEEkA//r08TtD
         5qcGQFptJMe02O2qH9XaH60zKnBl5Ci+k9+I2DyWkCdf6TVz0k5SRpO/bxTx6hSX4M
         RHUYElrvOXB9C7Up0paU3kPBri8zlo70vMWsK8693nziN7Mtjh5esVUK0sfLjUzjkr
         TVG5ymCpRUmOQ==
Date:   Wed, 26 Jan 2022 16:00:34 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <YfFiEgNHwo7o78vq@lore-desk>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
 <YfEwLrB6JqNpdUc0@lore-desk>
 <113d070a-6df1-66c2-1586-94591bc5aada@nvidia.com>
 <878rv23bkk.fsf@toke.dk>
 <499142da-2b16-4d94-48b0-8141506e79e3@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OSlkpr/o/h7btl8h"
Content-Disposition: inline
In-Reply-To: <499142da-2b16-4d94-48b0-8141506e79e3@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OSlkpr/o/h7btl8h
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 26/01/2022 14:50, Toke H=F8iland-J=F8rgensen wrote:
> > Nikolay Aleksandrov <nikolay@nvidia.com> writes:
> >=20
> >> On 26/01/2022 13:27, Lorenzo Bianconi wrote:
> >>>> On 24/01/2022 19:20, Lorenzo Bianconi wrote:
> >>>>> Similar to bpf_xdp_ct_lookup routine, introduce
> >>>>> br_fdb_find_port_from_ifindex unstable helper in order to accelerate
> >>>>> linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
> >>>>> lookup in the associated bridge fdb table and it will return the
> >>>>> output ifindex if the destination address is associated to a bridge
> >>>>> port or -ENODEV for BOM traffic or if lookup fails.
> >>>>>
> >>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >>>>> ---
> >>>>>  net/bridge/br.c         | 21 +++++++++++++
> >>>>>  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++--=
----
> >>>>>  net/bridge/br_private.h | 12 ++++++++
> >>>>>  3 files changed, 91 insertions(+), 9 deletions(-)
> >>>>>
> >>>>
> >>>> Hi Lorenzo,
> >>>
> >>> Hi Nikolay,
> >>>
> >>> thx for the review.
> >>>
> >>>> Please CC bridge maintainers for bridge-related patches, I've added =
Roopa and the
> >>>> bridge mailing list as well. Aside from that, the change is certainl=
y interesting, I've been
> >>>> thinking about a similar helper for some time now, few comments belo=
w.
> >>>
> >>> yes, sorry for that. I figured it out after sending the series out.
> >>>
> >>>>
> >>>> Have you thought about the egress path and if by the current bridge =
state the packet would
> >>>> be allowed to egress through the found port from the lookup? I'd gue=
ss you have to keep updating
> >>>> the active ports list based on netlink events, but there's a lot of =
egress bridge logic that
> >>>> either have to be duplicated or somehow synced. Check should_deliver=
() (br_forward.c) and later
> >>>> egress stages, but I see how this is a good first step and perhaps w=
e can build upon it.
> >>>> There are a few possible solutions, but I haven't tried anything yet=
, most obvious being
> >>>> yet another helper. :)
> >>>
> >>> ack, right but I am bit worried about adding too much logic and slow =
down xdp
> >>> performances. I guess we can investigate first the approach proposed =
by Alexei
> >>> and then revaluate. Agree?
> >>>
> >>
> >> Sure, that approach sounds very interesting, but my point was that
> >> bypassing the ingress and egress logic defeats most of the bridge
> >> features. You just get an fdb hash table which you can build today
> >> with ebpf without any changes to the kernel. :) You have multiple
> >> states, flags and options for each port and each vlan which can change
> >> dynamically based on external events (e.g. STP, config changes etc)
> >> and they can affect forwarding even if the fdbs remain in the table.
> >=20
> > To me, leveraging all this is precisely the reason to have BPF helpers
> > instead of just replicating state in BPF maps: it's very easy to do that
> > and show a nice speedup, and then once you get all the corner cases
> > covered that the in-kernel code already deals with, you've chipped away
> > at that speedup and spent a lot of time essentially re-writing the
> > battle-tested code already in the kernel.
> >=20
> > So I think figuring out how to do the state sync is the right thing to
> > do; a second helper would be fine for this, IMO, but I'm not really
> > familiar enough with the bridge code to really have a qualified opinion.
> >=20
> > -Toke
> >=20
>=20
> Right, sounds good to me. IMO it should be required in order to get a mea=
ningful bridge
> speedup, otherwise the solution is incomplete and you just do simple look=
ups that ignore
> all of the state that could impact the forwarding decision.

ack, I agree but I need to review it first since I am not so familiar
with that codebase :)
Doing so we can compare this solution with the one proposed by Alexei.

Regards,
Lorenzo

>=20
> Cheers,
>  Nik

--OSlkpr/o/h7btl8h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYfFiEgAKCRA6cBh0uS2t
rBX0AP970Tqrve/nXSLkopFCEuLZea5q0NCx3xs7Gbf0S76AAAD8CTp3W8h7ZG17
TTj9kv5ZzIJ/AyBF9f0UGoVCRYGvuwI=
=2a4l
-----END PGP SIGNATURE-----

--OSlkpr/o/h7btl8h--
