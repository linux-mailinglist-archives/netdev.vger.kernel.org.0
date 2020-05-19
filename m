Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F9F1D9D59
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgESQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:58:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728689AbgESQ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589907514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T43xGoEAjMpYwQrnKaIkzJZQCyxFxdLO76s7H3ber1c=;
        b=NZZhbpD6dll5Y30PgoZA6okxB3WIFrvpzUaGJOppZpUxHF41YKO7ClJpw/vqqrUBCPmKLz
        mwy243K1arkOl5Z4rmO4wMxkSaunIATkbGHCynnSK2PrYeD/dQnVsc0Sb46AA+CFrl84dN
        vTRQNIKNGO0L+YP1Y7WwRqI9qkuxd7o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-GZEx46jaN0iAaAeawdI0FA-1; Tue, 19 May 2020 12:58:30 -0400
X-MC-Unique: GZEx46jaN0iAaAeawdI0FA-1
Received: by mail-wm1-f70.google.com with SMTP id t62so1713595wmt.7
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T43xGoEAjMpYwQrnKaIkzJZQCyxFxdLO76s7H3ber1c=;
        b=TOQOUBUBzABs74pQa7xOeebm5iZic8uMxZHH/JfD6y9VjoZ+RU5kXqMeWDkssApa7D
         NtSTP6jYOJKTQSzSCPsPeAtniwvuIySHo+WQL98x9MDdx5ftkHGUBJZynJv9+BG5GYuZ
         zJZM+ERKCv9OYQ28l0tszfvS12mhmY89CDO1fy3VI6gR79f8BCey01SwJ1Bn6QON8Mi7
         PcN/uvbiMEAxKsjsR7UDuoLHHP5ek3d3U+2Ucw1avlV7GpkEH7PoCdDjTvO28YaD1smB
         0vYPSrxMjvm+sC7tzbKn0Yh2HHm2rW5vPjPDMyVFoWsrTWLraXFM96C/mCTqNRhwUMXw
         V7aQ==
X-Gm-Message-State: AOAM531zaHkmeIyr0zEqCjBO2KecrqaELDCAME2r+XNi+kmb5bvrviXd
        8cozSK3WBaB61/2qdqDeGWVXD2gbCTE7eTqyS/AhLiSC7AXc8uSlkosJoesDiRx+O5Jbm3tJymK
        1cxFGqYiy8QM3MZz2
X-Received: by 2002:a7b:cb9a:: with SMTP id m26mr327600wmi.79.1589907509429;
        Tue, 19 May 2020 09:58:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/0fB7Z5mVRwScbOzm1kqToFwB//9O1RpoNuI6yOmxCUfp3aLsjuuI15hZ3UyRBrHmZ7STVw==
X-Received: by 2002:a7b:cb9a:: with SMTP id m26mr327578wmi.79.1589907509142;
        Tue, 19 May 2020 09:58:29 -0700 (PDT)
Received: from localhost ([151.48.155.206])
        by smtp.gmail.com with ESMTPSA id t129sm367712wmg.27.2020.05.19.09.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 09:58:28 -0700 (PDT)
Date:   Tue, 19 May 2020 18:58:25 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
Message-ID: <20200519165825.GC44528@localhost.localdomain>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk>
 <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk>
 <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk>
 <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
 <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
 <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
 <20200519162127.00308f3b@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20200519162127.00308f3b@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 19 May 2020 15:31:20 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>=20
> > On 5/19/20 2:02 AM, David Ahern wrote:
> > > On 5/18/20 3:06 PM, Daniel Borkmann wrote: =20
> > >>
> > >> So given we neither call this hook on the skb path, nor XDP_TX nor
> > >> AF_XDP's TX path, I was wondering also wrt the discussion with
> > >> John if it makes sense to make this hook a property of the devmap
> > >> _itself_, for example, to have a default BPF prog upon devmap
> > >> creation or a dev-specific override that is passed on map update
> > >> along with the dev. At least this would make it very clear where
> > >> this is logically tied to and triggered from, and if needed (?)
> > >> would provide potentially more flexibility on specifiying BPF
> > >> progs to be called while also solving your use-case. =20
> > >=20
> > > You lost me on the 'property of the devmap.' The programs need to be =
per
> > > netdevice, and devmap is an array of devices. Can you elaborate? =20
> >=20
> > I meant that the dev{map,hash} would get extended in a way where the
> > __dev_map_update_elem() receives an (ifindex, BPF prog fd) tuple from
> > user space and holds the program's ref as long as it is in the map slot.
> > Then, upon redirect to the given device in the devmap, we'd execute the
> > prog as well in order to also allow for XDP_DROP policy in there. Upon
> > map update when we drop the dev from the map slot, we also release the
> > reference to the associated BPF prog. What I mean to say wrt 'property
> > of the devmap' is that this program is _only_ used in combination with
> > redirection to devmap, so given we are not solving all the other egress
> > cases for reasons mentioned, it would make sense to tie it logically to
> > the devmap which would also make it clear from a user perspective _when_
> > the prog is expected to run.
>=20
> Yes, I agree.
>=20
> I also have a use-case for 'cpumap' (cc. Lorenzo as I asked him to
> work on it).  We want to run another XDP program on the CPU that
> receives the xdp_frame, and then allow it to XDP redirect again.
> It would make a lot of sense, to attach this XDP program via inserting
> an BPF-prog-fd into the map as a value.
>=20
> Notice that we would also need another expected-attach-type for this
> case, as we want to allow XDP program to read xdp_md->ingress_ifindex,
> but we don't have xdp_rxq_info any-longer. Thus, we need to remap that
> to xdp_frame->dev_rx->ifindex (instead of rxq->dev->ifindex).

here I am looking at how we can extend cpumaps in order to pass from
usersapce the qsize and a bpf program file descriptor adding an element
to the map and allow cpu_map_update_elem() to load the program (e.g.
similar to dev_change_xdp_fd())
Doing so we can have an approach similar to veth xdp implementation.

Regards,
Lorenzo

>=20
> The practical use-case is the espressobin mvneta based ARM64 board,
> that can only receive IRQs + RX-frames on CPU-0, but hardware have more
> TX-queues that we would like to take advantage of on both CPUs.
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXsQQLwAKCRA6cBh0uS2t
rAriAP9CKHe3kPtzLkCBOE13AwmEXn3aLkz9yrqzonRN6KFGpwEA/8y985Zu/g2O
qHfw2QerlAvBlgdfyR67v4iHNFJ4Awg=
=3MxU
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--

