Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E534B7C89
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbiBPB02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:26:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243885AbiBPB01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:26:27 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6CBA279C;
        Tue, 15 Feb 2022 17:26:16 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id z18so382283iln.2;
        Tue, 15 Feb 2022 17:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=50KyuGY+FXK7lanV9rBdAP/JmHgxsIXffSguCeTz5Yo=;
        b=IEji/yspaTeDdWAxfYTTi3u6hvbQPgP+P148Kp0VnTCTHfGQbHF7E2sQ4I4mJIkrv6
         esLYrLp7f9LKsXtMHfmetc/hb2um6L5/MgQG673p80X08ttpzvJtFy76Tqb5gYiYgl43
         2u2zGA/LC0z20GdZba0TgBJ0LERjj55DNSIOoV9RjdJPKjdmPN9dKqoloqKunL+gaNpA
         zq8WOZppzUQLAOnoQX7PC9vgTVk4IaABZETcCFF4D4+sf5Mb+bxm50c9sg0mbFhwu9kt
         Yu2F16w65W0GP2rWxzRJZS/7rvgzi18xATku49NviYKJZl5Jlqg4O4Cj25N1UzjQia7H
         IyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=50KyuGY+FXK7lanV9rBdAP/JmHgxsIXffSguCeTz5Yo=;
        b=F07LD8RsmYqWl7GkYaS4yU3oVimJa8UR1NTAcv3cUvm/Uc/aQaYzv5lNvBibx+g1FO
         N/TPcHNk+4j+3CNA8PHyRlebA/H4WyyKlHOaiXV034kbdXWT0/mmN0PqXPPfQ5Ca6gCv
         DvbFPFKMLdyBSZSn50JF6QM4xe1sx3Ke30u8HTZNz/VQeEdJkK+Hju4CZtrk7duL/AUw
         mvNBZS8GQrUD/whRpYuCab26ycP4i1pqNnFcXmmU2SRKBvcGhqwDGYGZTODwBxBtplZS
         G/OdC1669vuoy9fe3pXZM4J+o2LqvQu06vbmAozUEu4Al8D4Ku0rE32gj2boCxSvzVqh
         zvIA==
X-Gm-Message-State: AOAM532tw1GBnz70w5j+HD5Dmxb9jmhrjXPu4xQ/fgF7eu9s8QWEbJaI
        MHqkC2iCS9dol4q0G9W2JC1ENfCViKqx/W5K9Y8=
X-Google-Smtp-Source: ABdhPJzpwGlFEFuRf1ayHKpQTMCno+q9jfPKW6NUvCjobMmV/D/epZG8FY9IqJGX0vNcxXRPsotPhbS98Oxahl6OfBE=
X-Received: by 2002:a92:d208:0:b0:2c1:1a3c:7b01 with SMTP id
 y8-20020a92d208000000b002c11a3c7b01mr290449ily.71.1644974776064; Tue, 15 Feb
 2022 17:26:16 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-7-mauricio@kinvolk.io>
 <CAEf4BzYp4bCBYrbXGw75x6WFqM_k6Bhy3D73hR9TR1O8S7gXcQ@mail.gmail.com> <CAHap4ztLNVm81jchDkAe15UybKRCFEJNci-BFFCRQf86iW_pVw@mail.gmail.com>
In-Reply-To: <CAHap4ztLNVm81jchDkAe15UybKRCFEJNci-BFFCRQf86iW_pVw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Feb 2022 17:26:05 -0800
Message-ID: <CAEf4BzYoN38cgJOpoVuYwM-g-mYcYucovyFynY3=0sCf7b2dwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 6/7] bpftool: gen min_core_btf explanation and examples
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:56 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Fri, Feb 11, 2022 at 7:42 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.=
io> wrote:
> > >
> > > From: Rafael David Tinoco <rafaeldtinoco@gmail.com>
> > >
> > > Add "min_core_btf" feature explanation and one example of how to use =
it
> > > to bpftool-gen man page.
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  .../bpf/bpftool/Documentation/bpftool-gen.rst | 93 +++++++++++++++++=
++
> > >  1 file changed, 93 insertions(+)
> > >
> >
> > [...]
> >
> > > +Now, the "5.4.0-smaller.btf" file may be used by libbpf as an extern=
al BTF file
> > > +when loading the "one.bpf.o" object into the "5.4.0-example" kernel.=
 Note that
> > > +the generated BTF file won't allow other eBPF objects to be loaded, =
just the
> > > +ones given to min_core_btf.
> > > +
> > > +::
> > > +
> > > +  struct bpf_object *obj =3D NULL;
> > > +  struct bpf_object_open_opts openopts =3D {};
> > > +
> > > +  openopts.sz =3D sizeof(struct bpf_object_open_opts);
> > > +  openopts.btf_custom_path =3D "./5.4.0-smaller.btf";
> > > +
> > > +  obj =3D bpf_object__open_file("./one.bpf.o", &openopts);
> >
> > Can you please use LIBBPF_OPTS() macro in the example, that's how
> > users are normally expected to use OPTS-based APIs anyways. Also there
> > is no need for "./" when specifying file location. This is a different
> > case than running a binary in the shell, where binary is searched in
> > PATH. This is never done when opening files.
> >
> > So all this should be:
> >
> > LIBBPF_OPTS(bpf_object_open_opts, opts, .btf_custom_path =3D "5.4.0-sma=
ller.btf");
> > struct bpf_object *obj;
> >
>
> I suppose you meant DECLARE_LIBBPF_OPTS(...)

No, actually, we do have LIBBPF_OPTS and DECLARE_LIBBPF_OPTS is just
an (logically) deprecated alias to LIBBPF_OPTS. Minor difference, but
shorter LIBBPF_OPTS is easier to remember.

>
> > obj =3D bpf_object__open_file("one.bpf.o", &opts);
> >
> > That's all.
> >
> >
> > > +
> > > +  ...
> > > --
> > > 2.25.1
> > >
