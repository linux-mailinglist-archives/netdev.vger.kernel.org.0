Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142AB26943D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgINR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgINR4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:56:05 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5DC06174A;
        Mon, 14 Sep 2020 10:56:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h206so503307ybc.11;
        Mon, 14 Sep 2020 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Un8zvLLsmqa/kJAIxo5TfYo5BqGUdFGp61peLrCl+OE=;
        b=N4ICZp/BNRRZryRN3ZspRbpXXmouOFbAt4nTOWjDi3v35mW36X8PIRF/QJdjLjfGUW
         NgvHaWYtRqTtOCGufVzifLnnHRCVOtNR9j1lTmhs08dcRflwylRNCMt9siSYRRXn6r/m
         sPx0lluXsHb88eG9gIpCdElmtlZy4SXdj3T9teD6Bnl8OGCv85xFibBbR05OWPiSc/8/
         7I+kSi0rceDaRX7hDxa9S4LtQiPvRJ/N0hWxmQ2rggrBV9SHmXdPLeE36afxLmUnrcOu
         rAqwfOzTO2iXDUZWFns1ySamYZl8+AbTASPEEnaaw/ZBZvKeZkYHF/a+k2a5yTz9uZ0t
         Y6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Un8zvLLsmqa/kJAIxo5TfYo5BqGUdFGp61peLrCl+OE=;
        b=BRzjoSqmNb4rholiAM6falGocN52FkBBn7uIfBuAcXvf2TscQJM/62WN+ApIn4zx1p
         APa+d6Qs2T6ZRS1wEWo6yvqIW0UrrKE53w1Zjew3BJAnBOTyUfKL+zVeU1yd3HT7Ej62
         5lIbmhtXdD3c2yW6Xr2VWbazHd/K00I7bNQdrNH7yUU1kRycE4ZnnqPGld+ElaAy27eI
         NeYJb65UNaQ7AYFn1HVi003UJHDE/TaWi2ShzVW4/zDdADXX8dCSS5rrDytA+3lp19MG
         Q/fLgvxI/00gM4GDnVG4xmOd/SeoxiH7Zt1xH572rI0X15yysiq3zk8i5BSFaiuuO+Wy
         kZrg==
X-Gm-Message-State: AOAM530t0HPePc6QW+x4BXci1Y6y9Id139i3LfWEuSikTNdaqmItByKe
        sv8rzOWIl0+V4DJtRMvaxk47W9GEA9S/UtYrdvc=
X-Google-Smtp-Source: ABdhPJxT/4CjMOuLqOwLzPQcPC6nv18+wBN/xeMQWdIsExxLBKMqv0o5qrbjDLmseFJG1kakOY5sMRjgDJ9uh1RfVPw=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr19613354ybm.230.1600106163978;
 Mon, 14 Sep 2020 10:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200914061206.2625395-1-yhs@fb.com> <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com> <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
 <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com> <8601f597-9c7e-a9a5-b375-75191fa93530@fb.com>
In-Reply-To: <8601f597-9c7e-a9a5-b375-75191fa93530@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 10:55:53 -0700
Message-ID: <CAEf4BzYd8Yp_CX52xYmbWg56JjyS__SmBD6Cb3y0M5hvVPYARw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>
Cc:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 10:46 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/14/20 10:23 AM, Quentin Monnet wrote:
> > On 14/09/2020 17:54, Yonghong Song wrote:
> >>
> >>
> >> On 9/14/20 9:46 AM, Yonghong Song wrote:
> >>>
> >>>
> >>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
> >>>> On 14/09/2020 07:12, Yonghong Song wrote:
> >>>>> When building bpf selftests like
> >>>>>     make -C tools/testing/selftests/bpf -j20
> >>>>> I hit the following errors:
> >>>>>     ...
> >>>>>     GEN
> >>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documenta=
tion/bpftool-gen.8
> >>>>>
> >>>>>     <stdin>:75: (WARNING/2) Block quote ends without a blank line;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:71: (WARNING/2) Literal block ends without a blank line=
;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:85: (WARNING/2) Literal block ends without a blank line=
;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:57: (WARNING/2) Block quote ends without a blank line;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:66: (WARNING/2) Literal block ends without a blank line=
;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:109: (WARNING/2) Literal block ends without a blank lin=
e;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:175: (WARNING/2) Literal block ends without a blank lin=
e;
> >>>>> unexpected unindent.
> >>>>>     <stdin>:273: (WARNING/2) Literal block ends without a blank lin=
e;
> >>>>> unexpected unindent.
> >>>>>     make[1]: ***
> >>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Document=
ation/bpftool-perf.8]
> >>>>> Error 12
> >>>>>     make[1]: *** Waiting for unfinished jobs....
> >>>>>     make[1]: ***
> >>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Document=
ation/bpftool-iter.8]
> >>>>> Error 12
> >>>>>     make[1]: ***
> >>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Document=
ation/bpftool-struct_ops.8]
> >>>>> Error 12
> >>>>>     ...
> >>>>>
> >>>>> I am using:
> >>>>>     -bash-4.4$ rst2man --version
> >>>>>     rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
> >>>>>     -bash-4.4$
> >>>>>
> >>>>> Looks like that particular version of rst2man prefers to have a
> >>>>> blank line
> >>>>> after literal blocks. This patch added block lines in related .rst
> >>>>> files
> >>>>> and compilation can then pass.
> >>>>>
> >>>>> Cc: Quentin Monnet <quentin@isovalent.com>
> >>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE
> >>>>> ALSO" sections in man pages")
> >>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>>>
> >>>>
> >>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
> >>>> setup. For the record my rst2man version is:
> >>>>
> >>>>      rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
> >>>>
> >>>> Your patch looks good, but instead of having blank lines at the end =
of
> >>>> most files, could you please check if the following works?
> >>>
> >>> Thanks for the tip! I looked at the generated output again. My above
> >>> fix can silent the warning, but certainly not correct.
> >>>
> >>> With the following change, I captured the intermediate result of the
> >>> .rst file.
> >>>
> >>>    ifndef RST2MAN_DEP
> >>>           $(error "rst2man not found, but required to generate man pa=
ges")
> >>>    endif
> >>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2ma=
n
> >>> $(RST2MAN_OPTS) > $@
> >>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
> >>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
> >>>
> >>> With below command,
> >>>      make clean && make bpftool-cgroup.8
> >>> I can get the new .rst file for bpftool-cgroup.
> >>>
> >>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
> >>>
> >>>       ID       AttachType      AttachFlags     Name
> >>> \n SEE ALSO\n=3D=3D=3D=3D=3D=3D=3D=3D\n\t**bpf**\ (2),\n\t**bpf-helpe=
rs**\
> >>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
> >>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
> >>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
> >>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
> >>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
> >>> (8),\n\t**bpftool-struct_ops**\ (8)\n
> >>>
> >>> This sounds correct if we rst2man can successfully transforms '\n'
> >>> or '\t' to proper encoding in the man page.
> >>>
> >>> Unfortunately, with my version of rst2man, I got
> >>>
> >>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
> >>> Literal block ends without a blank line; unexpected unindent.
> >>> .sp
> >>> n SEE
> >>> ALSOn=3D=3D=3D=3D=3D=3D=3D=3Dnt**bpf**(2),nt**bpf\-helpers**(7),nt**b=
pftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-ge=
n**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),=
nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpf=
tool\-struct_ops**(8)n
> >>>
> >>> .\" Generated by docutils manpage writer.
> >>>
> >>> The rst2man simply considered \n as 'n'. The same for '\t' and
> >>> this caused the issue.
> >>>
> >>> I did not find a way to fix the problem https://urldefense.proofpoint=
.com/v2/url?u=3Dhttps-3A__www.google.com_url-3Fq-3Dhttps-3A__zoom.us_j_9486=
4957378-3Fpwd-253DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09-26sa-3DD-26source-3Dcale=
ndar-26ust-3D1600532408208000-26usg-3DAOvVaw3SJ0i8oz4ZM-2DGRb7hYkrYlyet&d=
=3DDwIDaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3DkEK7ScP=
MF-y-i8dli-or8wWEGREW5V4qPB7UqHqDnkg&s=3DBr0g0MFXxL_pJuDVTOY5UrmvfD2ru_6Uf_=
X_8Nr2Rhk&e=3D .
> >>
> >> The following change works for me.
> >>
> >> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
> >>   ifndef RST2MAN_DEP
> >>          $(error "rst2man not found, but required to generate man page=
s")
> >>   endif
> >> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
> >> $(RST2MAN_OPTS) > $@
> >> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man
> >> $(RST2MAN_OPTS) > $@
> >>
> >>   clean: helpers-clean
> >>          $(call QUIET_CLEAN, Documentation)
> >> -bash-4.4$
> >>
> >> I will send revision 2 shortly.
> >
> > Thanks Yonghong, but this does not work on my setup :/. The version of
> > echo which is called on my machine from the Makefile does not seem to
> > interpret the "-e" option and writes something like "-e\nSEE ALSO",
> > which causes rst2man to complain.
> >
> > I suspect the portable option here would be printf, even though Andrii
> > had some concerns that we could pass a format specifier through the fil=
e
> > names [0].
> >
> > Would this work on your setup?
> >
> >       $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man...
> >
> > Would that be acceptable?
>
> It works for me. Andrii originally suggested `echo -e`, but since `echo
> -e` does not work in your environment let us use printf then. I will add
> a comment about '%' in the bpftool man page name.

It's amazing how incompatible echo can be. But that aside, I have
nothing against printf itself, but:

printf "%s" "whatever we want to print out"

seems like the way to go, similarly how you'd do it in your C code, no?

>
> >
> > [0]
> > https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isoval=
ent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e
> >
> > Quentin
> >
