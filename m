Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75734930C3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349951AbiARWbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:31:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48280 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiARWbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:31:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DD62B816DD;
        Tue, 18 Jan 2022 22:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F03C340E0;
        Tue, 18 Jan 2022 22:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642545070;
        bh=oX9CGyc9E8hhrv48m5cRGpL3L0F4tcBBop88TGp7kYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6PcPHgHji3l63OgaCfRGEkxNq5pNk9dRlIFbiuLC98Syy80vxuBXfLuOjndOnDjl
         bFbsbnJ6l83Qc1u+h1h42jXk3yU9TiEM25j0rgCUkGw6CuKSaZfIzP5ZM5+YUAWlLy
         h5cnu55puAHjqH5PxavOUOUaS4Gzjr30mnNu3La+QfNC7BrE9bTcuEK41bcwjggV7y
         5KCLwQgLK+BAX/7/ArsVTGOgt0lI9xcd+LesqN7iu1N1PkSMlWt5oenGW/ND4fm1fp
         RoezHlCIfwM1Q6ggWuZU6ZkzXtCbqVyfp4fzpR1wYnH1emDHm2OabTnBbvKmhKwq8B
         MMLr9j1scmn6A==
Date:   Tue, 18 Jan 2022 23:31:06 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 18/23] libbpf: Add SEC name for xdp
 multi-frags programs
Message-ID: <Yec/qu7idEImzqxc@lore-desk>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
 <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jDCXUBLkOxwCT4Jh"
Content-Disposition: inline
In-Reply-To: <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jDCXUBLkOxwCT4Jh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jan 17, 2022 at 06:28:30PM +0100, Lorenzo Bianconi wrote:
> > Introduce support for the following SEC entries for XDP multi-frags
> > property:
> > - SEC("xdp.frags")
> > - SEC("xdp.frags/devmap")
> > - SEC("xdp.frags/cpumap")
> >=20
> > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index fdb3536afa7d..611e81357fb6 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6562,6 +6562,9 @@ static int libbpf_preload_prog(struct bpf_program=
 *prog,
> >  	if (def & SEC_SLEEPABLE)
> >  		opts->prog_flags |=3D BPF_F_SLEEPABLE;
> > =20
> > +	if (prog->type =3D=3D BPF_PROG_TYPE_XDP && strstr(prog->sec_name, ".f=
rags"))
> > +		opts->prog_flags |=3D BPF_F_XDP_HAS_FRAGS;
>=20
> That's a bit sloppy.
> Could you handle it similar to SEC_SLEEPABLE?
>=20
> > +
> >  	if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> >  	     prog->type =3D=3D BPF_PROG_TYPE_LSM ||
> >  	     prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> > @@ -8600,8 +8603,11 @@ static const struct bpf_sec_def section_defs[] =
=3D {
> >  	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, =
attach_lsm),
> >  	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_ite=
r),
> >  	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
> > +	SEC_DEF("xdp.frags/devmap",	XDP, BPF_XDP_DEVMAP, SEC_NONE),
> >  	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > +	SEC_DEF("xdp.frags/cpumap",	XDP, BPF_XDP_CPUMAP, SEC_NONE),
> >  	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > +	SEC_DEF("xdp.frags",		XDP, BPF_XDP, SEC_NONE),
>=20
> It would be SEC_FRAGS here instead of SEC_NONE.

ack, I dropped SEC_FRAGS (SEC_XDP_MB before) from sec_def_flags because And=
rii asked to remove
it but I am fine to add it back. Agree?

Regards,
Lorenzo

>=20
> >  	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> >  	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> >  	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > --=20
> > 2.34.1
> >=20
>=20
> --=20

--jDCXUBLkOxwCT4Jh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYec/qgAKCRA6cBh0uS2t
rL10AP9i7Q9nJfl51xXLI7UVYYE7k+qHiKJINTodQObtiDR6kAEA8lHEv6BEd5Af
n69shaeREE6qwkXIcuoFXF1gLMwDCgM=
=JhGZ
-----END PGP SIGNATURE-----

--jDCXUBLkOxwCT4Jh--
