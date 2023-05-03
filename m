Return-Path: <netdev+bounces-225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 761166F6230
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DE2C280CAA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 23:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095FAF50D;
	Wed,  3 May 2023 23:44:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AA129A8
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 23:44:06 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C65A9001
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:44:05 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-959a3e2dc72so1135574066b.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 16:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1683157443; x=1685749443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=liLgFGtLEu8niiT+POixuMWwPLgi8MonJlpUXOfniTs=;
        b=ZAWLGcEy9y5Kfw5/6jTt740MtThFAWA31fidlUjLjH0t5mWUKkB78Dvy9nN/tq+7By
         CutUsF+qCPzN2ntXgWK8INya0iPJ1EQ4CcQG+YSTkaznRA6vqTSz/PfNzTRx3GL5pVRi
         H0g1x8Py2f6hpRu4/u345w0yjZ52TQqLwM1u1TDKc3CvzcLfqmFbNdJ0urh4uMCuZGOP
         qcvx3PMIfhVt+U6taKCaT9U3cuYXQZ0lsUQDQVKQJD0KH5XEgScG7mQEzVNcwiQYklvT
         S2Sm35cvGmUvDaO5gHX/zgYCaEHY+J3iIDSCjsJk9YtLQZWqPu4lOg3LzUkCgPwrnV5R
         GVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157443; x=1685749443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=liLgFGtLEu8niiT+POixuMWwPLgi8MonJlpUXOfniTs=;
        b=HAJ25j+trfNOoe0zCX2uNcQot/dyGMxseYzSrWsko81iC+ohLL6SldEX70N+dTbiDM
         n53GkACv0gAZmkeAYg3NtjDL9f55LhL0T9tbYJXPsty4YG4usSI716gy1zfVi3Oy7imj
         ngEBuOR2Xft3D72zvCMoH0CqCYecpeux3bQ8S19lJFfAESQaAbYAqz10HtvvBpYqLzhd
         UeVt2TBZxajRVXBGr/Trs+XoQVCs01Axm33pdCGp/s1x8sE3yl5jgjLOgyP0EMSD+ery
         pZIWmTYJk2JBDN2tLgxHi6Z2mi/Vxso8IuvtlsTZbO2yvdAjyj1tmBM2h0FALmIVOkX9
         A9ww==
X-Gm-Message-State: AC+VfDxlPWcUzL3p+Z5wIO/DMzDY7d3G+enRUcpdLoAB/DDG+C6LETza
	O8/11F+wCIZB90iSHZ2R6zGfvhcKui19pzSTaTEpUA==
X-Google-Smtp-Source: ACHHUZ70s1wmfyWilBTquU6NlhHpqKHtu33nmdx1nZZg40IG7ODqFfuhe5AlvPFoO6DKHvzGXljqdF8xNM96g0aubJg=
X-Received: by 2002:a17:907:948a:b0:8b1:3467:d71b with SMTP id
 dm10-20020a170907948a00b008b13467d71bmr4884871ejc.48.1683157443547; Wed, 03
 May 2023 16:44:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220421003152.339542-1-alobakin@pm.me> <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz> <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
 <20230414162821.GK63923@kunlun.suse.cz> <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
 <20230421073904.GJ15906@kitsune.suse.cz>
In-Reply-To: <20230421073904.GJ15906@kitsune.suse.cz>
From: Quentin Monnet <quentin@isovalent.com>
Date: Thu, 4 May 2023 00:43:52 +0100
Message-ID: <CACdoK4+KdM-sQKMO9WXk7kTL-x=Renjd0MuvSRT3JKbtzByyHQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix
 accessing its fields
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Alexander Lobakin <alobakin@mailbox.org>, 
	Alexei Starovoitov <ast@kernel.org>, Shung-Hsi Yu <shung-hsi.yu@suse.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Song Liu <songliubraving@fb.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 21 Apr 2023 at 08:39, Michal Such=C3=A1nek <msuchanek@suse.de> wrot=
e:
>
> On Thu, Apr 20, 2023 at 04:07:38PM -0700, Andrii Nakryiko wrote:
> > On Fri, Apr 14, 2023 at 9:28=E2=80=AFAM Michal Such=C3=A1nek <msuchanek=
@suse.de> wrote:
> > >
> > > On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
> > > > From: Michal Such=C3=A1nek <msuchanek@suse.de>
> > > > Date: Fri, 14 Apr 2023 11:54:57 +0200
> > > >
> > > > > Hello,
> > > >
> > > > Hey-hey,
> > > >
> > > > >
> > > > > On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote=
:
> > > > >> When building bpftool with !CONFIG_PERF_EVENTS:
> > > > >>
> > > > >> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of t=
ype 'struct bpf_perf_link'
> > > > >>         perf_link =3D container_of(link, struct bpf_perf_link, l=
ink);
> > > > >>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~
> > > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:=
22: note: expanded from macro 'container_of'
> > > > >>                 ((type *)(__mptr - offsetof(type, member)));    =
\
> > > > >>                                    ^~~~~~~~~~~~~~~~~~~~~~
> > > > >> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:=
60: note: expanded from macro 'offsetof'
> > > > >>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->M=
EMBER)
> > > > >>                                                   ~~~~~~~~~~~^
> > > > >> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'stru=
ct bpf_perf_link'
> > > > >>         struct bpf_perf_link *perf_link;
> > > > >>                ^
> > > > >>
> > > > >> &bpf_perf_link is being defined and used only under the ifdef.
> > > > >> Define struct bpf_perf_link___local with the `preserve_access_in=
dex`
> > > > >> attribute inside the pid_iter BPF prog to allow compiling on any
> > > > >> configs. CO-RE will substitute it with the real struct bpf_perf_=
link
> > > > >> accesses later on.
> > > > >> container_of() is not CO-REd, but it is a noop for
> > > > >> bpf_perf_link <-> bpf_link and the local copy is a full mirror o=
f
> > > > >> the original structure.
> > > > >>
> > > > >> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > > > >
> > > > > This does not solve the problem completely. Kernels that don't ha=
ve
> > > > > CONFIG_PERF_EVENTS in the first place are also missing the enum v=
alue
> > > > > BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handl=
ing the
> > > > > cookie.
> > > >
> > > > Sorry, I haven't been working with my home/private stuff for more t=
han a
> > > > year already. I may get back to it some day when I'm tired of Lua (=
curse
> > > > words, sorry :D), but for now the series is "a bit" abandoned.
> > >
> > > This part still appllies and works for me with the caveat that
> > > BPF_LINK_TYPE_PERF_EVENT also needs to be defined.
> > >
> > > > I think there was alternative solution proposed there, which promis=
ed to
> > > > be more flexible. But IIRC it also doesn't touch the enum (was it a=
dded
> > > > recently? Because it was building just fine a year ago on config wi=
thout
> > > > perf events).
> > >
> > > It was added in 5.15. Not sure there is a kernel.org LTS kernel usabl=
e
> > > for CO-RE that does not have it, technically 5.4 would work if it was
> > > built monolithic, it does not have module BTF, only kernel IIRC.
> > >
> > > Nonetheless, the approach to handling features completely missing in =
the
> > > running kernel should be figured out one way or another. I would be
> > > surprised if this was the last feature to be added that bpftool needs=
 to
> > > know about.
> >
> > Are we talking about bpftool built from kernel sources or from Github?
> > Kernel source version should have access to latest UAPI headers and so
> > BPF_LINK_TYPE_PERF_EVENT should be available. Github version, if it
> > doesn't do that already, can use UAPI headers distributed (and used
> > for building) with libbpf through submodule.
>
> It does have a copy of the uapi headers but apparently does not use
> them. Using them directly might cause conflict with vmlinux.h, though.

Indeed, using the UAPI header here conflicts with vmlinux.h.

Looking again at some code I started last year but never finalised, I
used the following approach, redefining BPF_LINK_TYPE_PERF_EVENT with
CO-RE:

    enum bpf_link_type___local {
        BPF_LINK_TYPE_PERF_EVENT___local =3D 7,
    };

Then guarding accordingly in iter():

    [...]
    if (obj_type =3D=3D BPF_OBJ_LINK &&
        bpf_core_enum_value_exists(enum bpf_link_type___local,
                       BPF_LINK_TYPE_PERF_EVENT___local)) {
        struct bpf_link *link =3D (struct bpf_link *) file->private_data;

        if (link->type =3D=3D bpf_core_enum_value(enum bpf_link_type___loca=
l,
                  BPF_LINK_TYPE_PERF_EVENT___local)) {
            e.has_bpf_cookie =3D true;
            e.bpf_cookie =3D get_bpf_cookie(link);
        }
    }
    [...]

Would that approach make sense? I had a VM around with kernel 5.8, and
bpftool compiles there with that change. If I remember correctly, some
older kernel versions required yet more CO-RE work in pid_iter.bpf.c,
and at some point I was struggling, which is why I never submitted
this set.

If this approach looks correct to you Andrii, I can resubmit these
patches with my addition so we can at least fix the build on 5.8
onwards.

Thanks,
Quentin

