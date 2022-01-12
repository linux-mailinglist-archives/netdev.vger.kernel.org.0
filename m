Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9C448CCE9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357536AbiALUMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:12:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357535AbiALUMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 15:12:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642018349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NgAxzoNHmk78ZwFfIfXbcbUHmGyaAZXvPS0dQ/mlALw=;
        b=SoGKOUu/eW4dYjsDRJIrhjGJTHgli2u+V1OWZ44ToXUHqR+D38kB1WrICx5AnzZpNV/Xs0
        +QgAMTEWo52mCXJtQhcRyJz6kmh4aZk+EobhFKgXBZqSUK/AouWzjDw1+2gTbrWXHjQ6VL
        rul+Z7U0RzotpwpQkHD4AOREY8R1//4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-cD5oDCleM9SvV-anrQKzGQ-1; Wed, 12 Jan 2022 15:12:27 -0500
X-MC-Unique: cD5oDCleM9SvV-anrQKzGQ-1
Received: by mail-wm1-f69.google.com with SMTP id o185-20020a1ca5c2000000b003478a458f01so2621026wme.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:12:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NgAxzoNHmk78ZwFfIfXbcbUHmGyaAZXvPS0dQ/mlALw=;
        b=MnZvTXR47LWfdesaAzM79Wyb3vHBK+Cp4jR3CrhhY82ygF+Kvqtg3vB289c5YxGlO9
         rzNKqHUS5YorjWSM9QmLzUy5fbV9DfsS2eB2aLIvKsOQddxT2DRKlRT++g8b4H+37A8k
         fmDU3pJtQXVVmw0/mQC8U+dRjv0Ftvu3JiDqWqPujzQFR/zhpej1r3GnuexKvtUEV35K
         9LgX2jOx2exztJXcM4FlHn28DFjX8QqUVF7RY79gVwT0djXNNFd+wKYn6OgaVlrpKETN
         b2nzouLaZEZj1W9gGwKmtkidJsV9oJyYMldtaEu+62WjQmQYKj/Z+sKd3KXaPo25iP4v
         Lipg==
X-Gm-Message-State: AOAM53069u+LsdgwSKep8TyDkZg8rgdIygZhcnmj+Z7QQej18B6MLLVO
        V4S2/UGvpQgmT7IfyLPCAtm1jqV7g0dGdfpUdvLmQbT3ZP5fFm9mGWzgZ/GMaQyvcTFgEoJE9h6
        Qe5q079FfBbctqE1e
X-Received: by 2002:a5d:4d0f:: with SMTP id z15mr1171144wrt.657.1642018346721;
        Wed, 12 Jan 2022 12:12:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyr/ryo2Gres0BrZjr+QYZ091blDTRQyJvyLJ/PRKHd4hEtqBymUl9CJ60Fwd6QXYaT3VNzjg==
X-Received: by 2002:a5d:4d0f:: with SMTP id z15mr1171126wrt.657.1642018346404;
        Wed, 12 Jan 2022 12:12:26 -0800 (PST)
Received: from localhost (net-93-146-37-237.cust.vodafonedsl.it. [93.146.37.237])
        by smtp.gmail.com with ESMTPSA id e10sm958809wrq.40.2022.01.12.12.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 12:12:25 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:12:23 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Message-ID: <Yd82J8vxSAR9tvQt@lore-desk>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk>
 <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PtD+SxrtCsyFHi0y"
Content-Disposition: inline
In-Reply-To: <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PtD+SxrtCsyFHi0y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 12, 2022 at 11:47 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel=
=2Eorg> wrote:
> > > > > >
> > > > > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kern=
el.org> wrote:
> > > > > > > >
> > > > > > > > Introduce support for the following SEC entries for XDP mul=
ti-buff
> > > > > > > > property:
> > > > > > > > - SEC("xdp_mb/")
> > > > > > > > - SEC("xdp_devmap_mb/")
> > > > > > > > - SEC("xdp_cpumap_mb/")
> > > > > > >
> > > > > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > > > > > > sleepable, seems like we'll have kprobe.multi or  something a=
long
> > > > > > > those lines as well), so let's stay consistent and call this =
"xdp_mb",
> > > > > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > > > > > > recognizable? would ".multibuf" be too verbose?). Also, why t=
he "/"
> > > > > > > part? Also it shouldn't be "sloppy" either. Neither expected =
attach
> > > > > > > type should be optional.  Also not sure SEC_ATTACHABLE is nee=
ded. So
> > > > > > > at most it should be SEC_XDP_MB, probably.
> > > > > >
> > > > > > ack, I fine with it. Something like:
> > > > > >
> > > > > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_A=
TTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > > > > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER=
, SEC_ATTACH_BTF, attach_iter),
> > > > > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPAB=
LE),
> > > > > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> > > > > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SE=
C_ATTACHABLE),
> > > > > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> > > > > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SE=
C_ATTACHABLE),
> > > > > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
> > > > >
> > > > > yep, but please use SEC_NONE instead of zero
> > > > >
> > > > > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTAC=
HABLE_OPT | SEC_SLOPPY_PFX),
> > > > > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE=
 | SEC_SLOPPY_PFX),
> > > > > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | S=
EC_SLOPPY_PFX),
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > > ---
> > > > > > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > > > > > > >  1 file changed, 8 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > > > > > >         SEC_SLEEPABLE =3D 8,
> > > > > > > >         /* allow non-strict prefix matching */
> > > > > > > >         SEC_SLOPPY_PFX =3D 16,
> > > > > > > > +       /* BPF program support XDP multi-buff */
> > > > > > > > +       SEC_XDP_MB =3D 32,
> > > > > > > >  };
> > > > > > > >
> > > > > > > >  struct bpf_sec_def {
> > > > > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct=
 bpf_program *prog,
> > > > > > > >         if (def & SEC_SLEEPABLE)
> > > > > > > >                 opts->prog_flags |=3D BPF_F_SLEEPABLE;
> > > > > > > >
> > > > > > > > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP && (def & S=
EC_XDP_MB))
> > > > > > > > +               opts->prog_flags |=3D BPF_F_XDP_MB;
> > > > > > >
> > > > > > > I'd say you don't even need SEC_XDP_MB flag at all, you can j=
ust check
> > > > > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > > > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem gen=
eric
> > > > > > > enough to warrant a flag.
> > > > > >
> > > > > > ack, something like:
> > > > > >
> > > > > > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP &&
> > > > > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > > > > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > > > > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > > > > > +               opts->prog_flags |=3D BPF_F_XDP_MB;
> > > > >
> > > > > yep, can also simplify it a bit with strstr(prog->sec_name,
> > > > > ".multibuf") instead of three strcmp
> > > >
> > > > Maybe ".mb" ?
> > > > ".multibuf" is too verbose.
> > > > We're fine with ".s" for sleepable :)
> > >
> > >
> > > I had reservations about "mb" because the first and strong association
> > > is "megabyte", not "multibuf". And it's not like anyone would have
> > > tens of those programs in a single file so that ".multibuf" becomes
> > > way too verbose. But I don't feel too strongly about this, if the
> > > consensus is on ".mb".
> >
> > The rest of the patches are using _mb everywhere.
> > I would keep libbpf consistent.
>=20
> Should the rest of the patches maybe use "multibuf" instead of "mb"? I've=
 been
> following this patch series closely and excitedly, and I keep having to r=
emind
> myself that "mb" is "multibuff" and not "megabyte". If I'm having to corr=
ect
> myself while following the patch series, I'm wondering if future confusio=
n is
> inevitable?
>=20
> But, is it enough confusion to be worth updating many other patches? I'm =
not
> sure.
>=20
> I agree consistency is more important than the specific term we're consis=
tent
> on.

I would prefer to keep the "_mb" postfix, but naming is hard and I am polar=
ized :)

Regards,
Lorenzo

>=20
> --Zvi
>=20

--PtD+SxrtCsyFHi0y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYd82JwAKCRA6cBh0uS2t
rAfHAP0Tic4BnmXWeA9aKV/S4g8OLYk3cWyc0AzbwKO2dJDi/gD/X5uPsGsG8SU0
sPnkxIdck7Zdbz7G9/qCw7q3/oV7bAE=
=VUXx
-----END PGP SIGNATURE-----

--PtD+SxrtCsyFHi0y--

