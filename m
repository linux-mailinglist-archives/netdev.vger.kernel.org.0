Return-Path: <netdev+bounces-227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B556F623C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B70E280CAA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 23:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01060EEC0;
	Wed,  3 May 2023 23:52:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E960B9471
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 23:52:30 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1178A57;
	Wed,  3 May 2023 16:52:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-957dbae98b4so898805266b.1;
        Wed, 03 May 2023 16:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683157947; x=1685749947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kzq+0S+9Qb55VFJhQtIPR/JmvKERRCMD4v+Ql+odqSc=;
        b=J8jQ9VIZOJOYHi+NTQ8HJqGVAAnvRta3CV+4MCEqth9UpwHBOrhZNRhunei3OJStYU
         3dRqHS7AoeFQjltv3+9F+fjsvM57x1+mKLfhSDzQEDs+XR+5h8SgHwGoZvTXsnnTtcJ6
         lYZU5o439Opeh5sM5Ns80AWcnU+Xz9upPZAOQ3i9u9coHVo4+ziQPuFsNtcwv6gATQNy
         gljeTEn44gAadufipi/5gyhLprt5GzAS4MpuzP7SP5K/pYTg4/2APvMMeOmuMMAG5Yzz
         VzklYzIO5zhViCCb7hY6GPhZsTWdIfpZp1gV36hr4Fw4ZrTSderOv52qF/+WgeXWpQix
         Dzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157947; x=1685749947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kzq+0S+9Qb55VFJhQtIPR/JmvKERRCMD4v+Ql+odqSc=;
        b=Abr/nPQEzXf5yeslYWG0nmSwrssgzYHffwgY5oFIP7XdJMDbDElpbWhIVf5g8S0wEN
         baQG2F4Wxq2+2YQT9urEWYmIWd5Ar9GEjc7K5hE2o7+OXXmeDTrJEXf9XJM6szdnRd8X
         vWcHDgdNwevPKiMF5l/z8kGq75n5DoJZPE7MyMBRuKwJUlkpEqxGgCY9eKebFxmaQbDG
         rQ6I57qBqRq2Bgzhd0soliNIIOd5N7q6P9uGiAyO9aqeOQURabrA8OLy/meY8arpvzjo
         CUaYVPJuyethh6EYPaTDRaZcRyBOMHmlpCAE+PAjLpmiDcibWzpwQrCVUq4f3d9Vl35g
         zCJw==
X-Gm-Message-State: AC+VfDzDnhQeVagF4Fya2cyuksKXP1XloPTkHTFPUMaXlxycaARd0fAY
	DlgkUUxXM5gVvE8am1tqdfcj8a+Xcwl3DvGj2+8=
X-Google-Smtp-Source: ACHHUZ5J0UaeP5nWPnm79c1X+6XiydeUXuzsu/eu9LNVllDGjcMPcd9PPmwyFou9dgb4c9hJSmUzHcR2P36p2DCG5G4=
X-Received: by 2002:a17:906:58cc:b0:94e:f349:2a30 with SMTP id
 e12-20020a17090658cc00b0094ef3492a30mr4880171ejs.58.1683157947147; Wed, 03
 May 2023 16:52:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220421003152.339542-1-alobakin@pm.me> <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz> <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
 <20230414162821.GK63923@kunlun.suse.cz> <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
 <20230421073904.GJ15906@kitsune.suse.cz> <CACdoK4+KdM-sQKMO9WXk7kTL-x=Renjd0MuvSRT3JKbtzByyHQ@mail.gmail.com>
In-Reply-To: <CACdoK4+KdM-sQKMO9WXk7kTL-x=Renjd0MuvSRT3JKbtzByyHQ@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 3 May 2023 16:52:15 -0700
Message-ID: <CAEf4BzZgWwPJCkw1XKY03Vtb6B4_iE3dBbjqMB=upM0O=OYRXQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix
 accessing its fields
To: Quentin Monnet <quentin@isovalent.com>
Cc: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Alexander Lobakin <alobakin@mailbox.org>, 
	Alexei Starovoitov <ast@kernel.org>, Shung-Hsi Yu <shung-hsi.yu@suse.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Song Liu <songliubraving@fb.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 3, 2023 at 4:44=E2=80=AFPM Quentin Monnet <quentin@isovalent.co=
m> wrote:
>
> On Fri, 21 Apr 2023 at 08:39, Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
> >
> > On Thu, Apr 20, 2023 at 04:07:38PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Apr 14, 2023 at 9:28=E2=80=AFAM Michal Such=C3=A1nek <msuchan=
ek@suse.de> wrote:
> > > >
> > > > On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
> > > > > From: Michal Such=C3=A1nek <msuchanek@suse.de>
> > > > > Date: Fri, 14 Apr 2023 11:54:57 +0200
> > > > >
> > > > > > Hello,
> > > > >
> > > > > Hey-hey,
> > > > >
> > > > > >
> > > > > > On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wro=
te:
> > > > > >> When building bpftool with !CONFIG_PERF_EVENTS:
> > > > > >>
> > > > > >> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of=
 type 'struct bpf_perf_link'
> > > > > >>         perf_link =3D container_of(link, struct bpf_perf_link,=
 link);
> > > > > >>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
> > > > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:7=
4:22: note: expanded from macro 'container_of'
> > > > > >>                 ((type *)(__mptr - offsetof(type, member)));  =
  \
> > > > > >>                                    ^~~~~~~~~~~~~~~~~~~~~~
> > > > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:6=
8:60: note: expanded from macro 'offsetof'
> > > > > >>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)-=
>MEMBER)
> > > > > >>                                                   ~~~~~~~~~~~^
> > > > > >> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'st=
ruct bpf_perf_link'
> > > > > >>         struct bpf_perf_link *perf_link;
> > > > > >>                ^
> > > > > >>
> > > > > >> &bpf_perf_link is being defined and used only under the ifdef.
> > > > > >> Define struct bpf_perf_link___local with the `preserve_access_=
index`
> > > > > >> attribute inside the pid_iter BPF prog to allow compiling on a=
ny
> > > > > >> configs. CO-RE will substitute it with the real struct bpf_per=
f_link
> > > > > >> accesses later on.
> > > > > >> container_of() is not CO-REd, but it is a noop for
> > > > > >> bpf_perf_link <-> bpf_link and the local copy is a full mirror=
 of
> > > > > >> the original structure.
> > > > > >>
> > > > > >> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > > > > >
> > > > > > This does not solve the problem completely. Kernels that don't =
have
> > > > > > CONFIG_PERF_EVENTS in the first place are also missing the enum=
 value
> > > > > > BPF_LINK_TYPE_PERF_EVENT which is used as the condition for han=
dling the
> > > > > > cookie.
> > > > >
> > > > > Sorry, I haven't been working with my home/private stuff for more=
 than a
> > > > > year already. I may get back to it some day when I'm tired of Lua=
 (curse
> > > > > words, sorry :D), but for now the series is "a bit" abandoned.
> > > >
> > > > This part still appllies and works for me with the caveat that
> > > > BPF_LINK_TYPE_PERF_EVENT also needs to be defined.
> > > >
> > > > > I think there was alternative solution proposed there, which prom=
ised to
> > > > > be more flexible. But IIRC it also doesn't touch the enum (was it=
 added
> > > > > recently? Because it was building just fine a year ago on config =
without
> > > > > perf events).
> > > >
> > > > It was added in 5.15. Not sure there is a kernel.org LTS kernel usa=
ble
> > > > for CO-RE that does not have it, technically 5.4 would work if it w=
as
> > > > built monolithic, it does not have module BTF, only kernel IIRC.
> > > >
> > > > Nonetheless, the approach to handling features completely missing i=
n the
> > > > running kernel should be figured out one way or another. I would be
> > > > surprised if this was the last feature to be added that bpftool nee=
ds to
> > > > know about.
> > >
> > > Are we talking about bpftool built from kernel sources or from Github=
?
> > > Kernel source version should have access to latest UAPI headers and s=
o
> > > BPF_LINK_TYPE_PERF_EVENT should be available. Github version, if it
> > > doesn't do that already, can use UAPI headers distributed (and used
> > > for building) with libbpf through submodule.
> >
> > It does have a copy of the uapi headers but apparently does not use
> > them. Using them directly might cause conflict with vmlinux.h, though.
>
> Indeed, using the UAPI header here conflicts with vmlinux.h.
>
> Looking again at some code I started last year but never finalised, I
> used the following approach, redefining BPF_LINK_TYPE_PERF_EVENT with
> CO-RE:
>
>     enum bpf_link_type___local {
>         BPF_LINK_TYPE_PERF_EVENT___local =3D 7,
>     };
>
> Then guarding accordingly in iter():
>
>     [...]
>     if (obj_type =3D=3D BPF_OBJ_LINK &&
>         bpf_core_enum_value_exists(enum bpf_link_type___local,
>                        BPF_LINK_TYPE_PERF_EVENT___local)) {
>         struct bpf_link *link =3D (struct bpf_link *) file->private_data;
>
>         if (link->type =3D=3D bpf_core_enum_value(enum bpf_link_type___lo=
cal,
>                   BPF_LINK_TYPE_PERF_EVENT___local)) {
>             e.has_bpf_cookie =3D true;
>             e.bpf_cookie =3D get_bpf_cookie(link);
>         }
>     }
>     [...]
>
> Would that approach make sense? I had a VM around with kernel 5.8, and
> bpftool compiles there with that change. If I remember correctly, some
> older kernel versions required yet more CO-RE work in pid_iter.bpf.c,
> and at some point I was struggling, which is why I never submitted
> this set.
>
> If this approach looks correct to you Andrii, I can resubmit these
> patches with my addition so we can at least fix the build on 5.8
> onwards.

Yep, why not? In general, if using vmlinux.h makes life harder and
there is just a small set of types and enums BPF program needs, for
the sake of support of old kernels/distros it might be cleaner just to
define relevant structs, enums, etc explicitly and add
__attribute__((preserve_access_index)) to them to make the
CO-RE-relocatable

>
> Thanks,
> Quentin

